unit ExamClientGlobal;

interface

uses ClientMain, ExamTCPClient, NetGlobal, Classes,
  ExtCtrls, uGrade, ScoreIni, ADODB, floatform, select, BaseConfig, controls, uFrameSingleSelect, uFrameMultiSelect, keyboardType, uFrameOperate, uFormOperate;


// TModules = array of TModuleInfo;

// TFormMode=(SINGLESELECT_MODEL=0,MULTISELECT_MODEL=1,TYPE_MODEL=2,WINDOWS_MODEL=3,WORD_MODEL=4,EXCEL_MODEL=5,POWERPOINT_MODEL=6,IE_MODEL=7);
// TExamModule =(MODULESINGLESELECT=0,MODULEMULTISELECT=1,MODULETYPE=2,MODULEWINDOWS=3,MODULEWORD=4,MODUELEXCEL=5,MODULEPOWERPOINT=6,MODULEIE=7);

type
  TExamClientGlobal = class
{$REGION '---���Զ�ȫ�ֱ���----'}
  private
  class var
    FExamTCPClient: TExamTCPClient;
    FBaseConfig: TBaseConfig;
    FExamPath: string;
    FLoginType: TLoginType;
    FModules: TModules;
    FScore: TScoreIni;
    // FDmClient: TdmClient;
    FConnClientDB: TADOConnection;
    FMainTimer: TTimer;
  private
    class function GetConnClientDB: TADOConnection; static;
    class procedure MainTimerTimer(Sender: TObject);
  public
  class var
    Examinee: TExaminee;
    ExamineePhoto:TMemoryStream;
    ClientMainForm: TClientMainForm;
    // FloatWindow :TFloatWindow;
    floatWindow: TFormOperate;
    singleFrame: TFrameSingleSelect;
    multiFrame: TFrameMultiSelect;
    typeFrame: TFrameKeyType;
    windowsFrame, WordFrame, ExcelFrame, PowerPointFrame: TFrameOperate;
    // SelectWindow: TSelectForm;
    // RemainTime:integer;
    Inst: TExamClientGlobal;
  public // global variable for ExamClient
    class property ExamTCPClient: TExamTCPClient read FExamTCPClient write FExamTCPClient;

    // class property Examinee : TExaminee read FExaminee write FExaminee;
    class property BaseConfig: TBaseConfig read FBaseConfig write FBaseConfig;
    class property ExamPath: string read FExamPath write FExamPath;
    class property LoginType: TLoginType read FLoginType write FLoginType;

    class property Modules: TModules read FModules write FModules;
    class property Score: TScoreIni read FScore write FScore;
    class property ConnClientDB: TADOConnection read GetConnClientDB;
{$ENDREGION}
  public
    // constructor Create();
    class procedure CreateClassObject();
    class procedure DestroyClassObject();
    // destructor Destroy(); override;
    /// �ӷ�������ȡ�������ݱ��浽 TExamClientGlobal.Modules��
    class function SetBaseConfig(): TCommandResult;
    // �� sysconfig���л�ü������� ����������ģ���е�ȫ�ֱ���
    class procedure SetGlobalExamPath();

    class function CreateExamEnvironmentByTestFilepack(AExamineeID: string; ALoginType: TLoginType; AEnvironmentPath: string): Integer;

    class procedure SetEQBConn(path: string = ''; dbName: string = '�������.dat'; pwd: string = 'jiaping');

    class procedure SetupExamineeInfoBase(const AExaminee: TExaminee); static;
    class function Login(): Integer; static;

    class procedure EnableTimer;
    class procedure UnableTimer;

    class function InitExam: TModalResult;
    class function CreateEnvironment(const ALoginType: TLoginType): TModalResult;

  end;

var
  clientGlobal: TExamClientGlobal;

implementation

uses
  SysUtils, ExamGlobal, Windows, ShellModules, Commons, compress,
  ExamInterface, tq, Forms, Variants, DataFieldConst;

// constructor TExamClientGlobal.Create();
// begin
// TExamClientGlobal.Inst := Self;
// TExamClientGlobal.FScore := TScoreIni.Create;
// end;

class function TExamClientGlobal.SetBaseConfig(): TCommandResult;
  var
    i: Integer;
    delegateGetModuleName: FngetModuleDllName;
    delegateGetModuleButtonText: FnGetModuleButtonText;
    delegateGetPrefix: FnGetModulePreFix;
    delegateGetModuleDocName: FnGetModuleDocName;
    delegateGetModuleDelimiterChar: FnGetModuleDelimiterChar;
  begin
    Result := FExamTCPClient.CommandGetBaseConfig(FBaseConfig);
    if Result = crOk then
      begin
        Result := crError;
        SetLength(FModules, FBaseConfig.Modules.Count);
        for i := 0 to FBaseConfig.Modules.Count - 1 do
          begin
            FModules[i] := TModuleInfo.Create;
            FModules[i].FillModuleInfo(FBaseConfig.Modules[i]);
          end;
        Result := crOk;
      end;
  end;
//
// procedure TExamClientGlobal.CreateExamineeBase(APath :string);
// var
// memStream : TMemoryStream;
// begin
// //create directory
// if directoryExists(APath) then begin
// //dm.ksconn.Connected:=false;
// deleteDir(APath);  //path is not exist ?
// end;
//
// createdir(APath);
// //�����������
// try
// if FExamTCPClient.CommandGetEQFile('1',memStream) =crOk then
// memStream.SaveToFile(APath+'\�������.dat')
// else
// raise Exception.Create('��ȡ����������');
// finally
// memStream.Free;
// end;
//
// //���������������
// DmClient.SetEQBConn(APath);
// //GlobalExamTCPClient.CommandGetEQInfo(EQInfo);
// PopulateExamineeBase();
//
// //�л�������Ϣ���������ݿ�
// DmClient.SetupExamineeInfoBase(Examinee);
// end;
//
// procedure TExamClientGlobal.PopulateExamineeBase();
// var
// i:Integer;
// recordPacket : TClientEQRecordPacket;
// AEQInfo :TStringList;
// begin
// if FExamTCPClient.CommandGetEQInfo(AEQInfo)=crOk then begin
// { TODO -ojp : need to deal with exception }
// try
// for i := 0 to AEQInfo.Count-1 do
// begin
// try
// if FExamTCPClient.CommandGetEQRecord(AEQInfo[i],recordPacket)=crOk then
// DmClient.AddClientEQBRec(recordPacket)
// else
// raise Exception.Create('��ȡ�������'+AEQInfo[i]);
// finally
// if Assigned(recordPacket) then
// recordPacket.Free;
// end;
// end;
// finally
// AEQInfo.Free;
// end;
// end;
// end;

class procedure TExamClientGlobal.SetGlobalExamPath();
  begin
    if Examinee.ID = EmptyStr then
      raise Exception.Create('����ID����Ϊ��');
    FExamPath := FBaseConfig.ExamPath + '\' + Examinee.ID;
  end;

class procedure TExamClientGlobal.CreateClassObject;
  begin
    // TExamClientGlobal.Inst := Self;
    FScore := TScoreIni.Create;
  end;

class function TExamClientGlobal.CreateExamEnvironmentByTestFilepack(AExamineeID: string; ALoginType: TLoginType; AEnvironmentPath: string): Integer;
  var
    memStream: TMemoryStream;
  begin
    memStream := TMemoryStream.Create;
    try
      if FExamTCPClient.CommandGetExamineeTestFilePack(AExamineeID, ALoginType, memStream) = crOk then
        begin
          if not directoryexists(AEnvironmentPath) then
            createdir(AEnvironmentPath);
          DirectoryDecompression(AEnvironmentPath, memStream);
        end;
    finally
      memStream.Free;
    end;
  end;

// destructor TExamClientGlobal.Destroy;
// begin
// if (FBaseConfig<>nil) then
// FBaseConfig.Free;
// FExamTCPClient.Free;
// FConnClientDB.Free;
// FModules:=nil;
// FScore.Free;
// inherited;
// end;

class procedure TExamClientGlobal.DestroyClassObject;
  var
    moduleinfo: TModuleInfo;
    i: Integer;
    jg: LongBool;
  begin
    for i := 0 to high(FModules) do
      begin
        moduleinfo := FModules[i];
        jg         := FreeLibrary(moduleinfo.DllHandle);
        moduleinfo.Free;
      end;
    FModules := nil;
    if (FBaseConfig <> nil) then
      FBaseConfig.Free;
    FExamTCPClient.Free;
    FConnClientDB.Free;
    FScore.Free;
    if FMainTimer <> nil then
      FMainTimer.Free;
  end;

class procedure TExamClientGlobal.EnableTimer;
  begin
    if FMainTimer = nil then
      begin
        FMainTimer          := TTimer.Create(nil);
        FMainTimer.Interval := 1000;
        FMainTimer.OnTimer  := MainTimerTimer;
        FMainTimer.Enabled  := true;
      end
    else
      begin
        FMainTimer.OnTimer := MainTimerTimer;
        FMainTimer.Enabled := true;
      end;
  end;

class procedure TExamClientGlobal.UnableTimer;
  begin
    if FMainTimer <> nil then
      begin
        FMainTimer.Enabled := False;
      end;
  end;

class procedure TExamClientGlobal.SetEQBConn(path: string = ''; dbName: string = '�������.dat'; pwd: string = 'jiaping');
  var
    appPath: string;
  begin
    if FConnClientDB = nil then
      begin
        FConnClientDB                := TADOConnection.Create(nil);
        FConnClientDB.LoginPrompt    := False;
        FConnClientDB.Provider       := 'Microsoft.Jet.OLEDB.4.0';
        FConnClientDB.KeepConnection := true;
      end;

    if path = '' then
      path := 'e:\yjksmtxt\debug\bin';
    if FileExists(path + '\' + dbName) then
      begin
        FConnClientDB.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + path + '\' + dbName + ';Mode=Share Deny None;Persist ' +
          'Security Info=False;Jet OLEDB:Database Password=' + pwd;
      end
    else
      raise Exception.Create('�Ҳ�����������⣡�����������ɿ��Ի������������ɾ���˸��ļ�');
    FConnClientDB.Connected := true;
  end;

class function TExamClientGlobal.GetConnClientDB: TADOConnection;
  begin
    Result := FConnClientDB;
  end;



class procedure TExamClientGlobal.SetupExamineeInfoBase(const AExaminee: TExaminee);
  var
    qry: TADOQuery;
  begin
    qry := TADOQuery.Create(nil);
    try
      with qry, AExaminee do
        begin
          Connection := FConnClientDB;
          // qry.SQL.Add('select * from '+TBLNAME_EXAMDB_TQ) ;

          SQL.Add('insert into ' + TBANAME_EXAMDB_INFO + ' (');
          SQL.Add(DFNEI_EXAMINEEID + ',');
          SQL.Add(DFNEI_EXAMINEENAME + ',');
          SQL.Add(DFNEI_REMAINTIME + ',');
          SQL.Add(DFNEI_STATUS);
          SQL.Add(') values (');
          SQL.Add(QuotedStr(EncryptStr(ID)) + ',');
          SQL.Add(QuotedStr(EncryptStr(Name)) + ',');
          SQL.Add(QuotedStr(EncryptStr(IntToStr(RemainTime))) + ',');
          SQL.Add(QuotedStr(EncryptStr(IntToStr(Ord(Status)))) + ')');
          ExecSQL;
        end;
    finally
      qry.Free;
    end;
  end;

class function TExamClientGlobal.Login(): Integer;
  var
    loginResult: TCommandResult;
    AExamineeID: string;
  begin
    Result      := -1;
    AExamineeID := TExamClientGlobal.Examinee.ID;
    { TODO -ojp -cneeddo : ���Ի�����ʱ����Ҫ���� }
    loginResult := crError;
    case TExamClientGlobal.Examinee.Status of
      esNotLogined:
        begin
          TExamClientGlobal.LoginType := ltFirstLogin;
          loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
        end;
      esDisConnect:
        begin
          // if DirectoryExists(GlobalExamPath) then
          begin
            TExamClientGlobal.LoginType := ltContinuteInterupt;
            loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
          end;
        end;
      esAllowContinuteExam:
        begin
          TExamClientGlobal.LoginType := ltContinuteEndedExam;
          loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
        end;
      esAllowReExam:
        begin
          TExamClientGlobal.LoginType := ltReExamLogin;
          loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
        end;
      else
        begin
          // ���������״̬���������¼
          Result := 2; // refuse login
        end;
    end;
    if loginResult = crOk then
      begin
        Result := 1; // login ok
      end;
  end;

class procedure TExamClientGlobal.MainTimerTimer(Sender: TObject);
  var
    sj: string;
  begin
    with TExamClientGlobal, TExamClientGlobal.Examinee do
      begin
        RemainTime := RemainTime - 1;
        sj         := format('%.2d:%.2d', [RemainTime div 60, RemainTime mod 60]);
{$IFDEF FLASH}
        ClientMainForm.SetFlashRemainTime(sj);
{$ENDIF}
        if ClientMainForm.Showing then
          ClientMainForm.lblTime.Caption := '����ʣ��ʱ��:' + sj;
        if assigned(floatWindow) and floatWindow.Showing then
          begin
            floatWindow.txtTime.Caption := 'ʣ��:' + sj;
            // Floatwindow.stTime1.caption:='ʣ��:'+sj;
            // SelectWindow.lblTime.Caption := 'ʣ��ʱ�䣺'+sj;
          end;
      end;
    // only Examining update time


    // { TODO -ojp -c0 : test if overflow ,test if correct }
    // if (TExamClientGlobal.RemainTime div GlobalSysConfig.StatusRefreshInterval)=(TExamClientGlobal.RemainTime / GlobalSysConfig.StatusRefreshInterval) then
    // begin
    // { TODO -ojp -c0 : direct update remaintime in server ,is correct ? }
    // GlobalExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.ID,TExamClientGlobal.Name,TExamClientGlobal.Status,TExamClientGlobal.RemainTime);
    // end;
    // sj:=format('%.2d:%.2d',[TExamClientGlobal.RemainTime div 60,TExamClientGlobal.RemainTime mod 60]);
    // ClientMainForm.stTime.Caption:=sj;

    // todo2009120
    // if TExamClientGlobal.RemainTime<490 then
    // TExamClientGlobal.ClientMainForm.SetFlashRemainTime(sj);
    // if assigned(FloatWindow) then
    // begin
    // Floatwindow.stTime.caption:=sj;
    // Floatwindow.stTime1.caption:='ʱ�䣺'+sj;
    // end;
    //
    //
    // if TExamClientGlobal.RemainTime=300 then
    // MessageBoxOnTopForm(application,'����5���ӿ��Խ������뱣����ĵ�','����', mb_ok);
    // if TExamClientGlobal.RemainTime<=0 then
    // begin
    // MainTimer.Enabled:=false;
    // if floatWindow.Visible then
    // begin
    // floatWindow.ExitBitBtnClick(floatwindow);
    // floatWindow.Visible:=false;
    // end;
    // if SelectForm.Visible then
    // begin
    // SelectForm.btnReturnclick(SelectForm);
    // SelectForm.visible:=false;
    // end;
    //
    // if typeForm.visible then
    // begin
    // typeForm.ExitBitBtnClick(typeForm);
    // typeForm.visible:=false;
    // end;
    // TExamClientGlobal.ClientMainForm.ModalResult :=-1;
    // TExamClientGlobal.ClientMainForm.Close;
    // //mainform.btnJJClick(mainform);
    //
    // end;
    // todo20091207
    if TExamClientGlobal.Examinee.ID = '' then
      OutputDebugString(PChar('����״̬�����IDΪ��'));
  end;

class function TExamClientGlobal.InitExam: TModalResult;
  begin
    Result := TExamClientGlobal.CreateEnvironment(TExamClientGlobal.LoginType);
    // TExamClientGlobal.ClientMainForm:=TClientMainForm.Create(self);
    // TExamClientGlobal.FloatWindow := TFloatWindow.Create(self);
    // TExamClientGlobal.SelectWindow := TSelectForm.Create(self);
    // TypeForm := TTypeForm.Create(self);
    TExamClientGlobal.Examinee.Status := esExamining;
    TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name, TExamClientGlobal.Examinee.Status,
      TExamClientGlobal.Examinee.RemainTime);
    TExamClientGlobal.EnableTimer;
  end;

class function TExamClientGlobal.CreateEnvironment(const ALoginType: TLoginType): TModalResult;
  begin
    Result := mrOk;
    TExamClientGlobal.SetGlobalExamPath;
    try
      case ALoginType of
        ltFirstLogin, ltReExamLogin, ltContinuteEndedExam:
          begin
            TExamClientGlobal.CreateExamEnvironmentByTestFilepack(TExamClientGlobal.Examinee.ID, ALoginType, TExamClientGlobal.ExamPath);
            TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath); // ���ÿ������������
            TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee); // �Ա��ϱ�����ʱ��ÿ�����Ϣ
          end;
        ltContinuteInterupt:
          begin
            if directoryexists(TExamClientGlobal.ExamPath) then
              begin
                TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath); // ���ÿ������������
                TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee); // �Ա��ϱ�����ʱ��ÿ�����Ϣ
              end
            else
              begin
                MessageBoxOnTopForm(Application, '�Ҳ����ϴο����ļ�Ŀ¼��', '��ʾ:', mb_ok);
                Result := mrCancel;
              end;
          end;
      end;
    except
      MessageBoxOnTopForm(Application, '���ɿ��Ի����������⣬�����½���ϵͳ', '��ʾ:', mb_ok);
      Result := mrCancel;
    end;

  end;

end.
