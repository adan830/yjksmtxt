unit ExamClientGlobal;

interface

uses ClientMain, ExamTCPClient, NetGlobal, Classes,
   ExtCtrls, uGrade, ScoreIni, ADODB, floatform, select, BaseConfig, controls, uFrameSingleSelect, uFrameMultiSelect, keyboardType, uFrameOperate, uFormOperate,DataFieldConst;


// TModules = array of TModuleInfo;

// TFormMode=(SINGLESELECT_MODEL=0,MULTISELECT_MODEL=1,TYPE_MODEL=2,WINDOWS_MODEL=3,WORD_MODEL=4,EXCEL_MODEL=5,POWERPOINT_MODEL=6,IE_MODEL=7);
// TExamModule =(MODULESINGLESELECT=0,MODULEMULTISELECT=1,MODULETYPE=2,MODULEWINDOWS=3,MODULEWORD=4,MODUELEXCEL=5,MODULEPOWERPOINT=6,MODULEIE=7);

type
   TExamClientGlobal = class
      {$REGION '---考试端全局变量----'}
      private
      class var
         FExamTCPClient : TExamTCPClient;
         FBaseConfig    : TBaseConfig;
         FExamPath      : string;
         FLoginType     : TLoginType;
         FModules       : TModules;
         FScore         : TScoreIni;
         // FDmClient: TdmClient;
         FConnClientDB : TADOConnection;
         FMainTimer    : TTimer;
      private
         class function GetConnClientDB : TADOConnection; static;
         class procedure MainTimerTimer(Sender : TObject);
         class procedure UpdateStatusTimer(Sender : TObject);

      public
      class var
         Examinee       : TExaminee;
         ExamineePhoto  : TMemoryStream;
         ClientMainForm : TClientMainForm;
         // FloatWindow :TFloatWindow;
         floatWindow                                          : TFormOperate;
         singleFrame                                          : TFrameSingleSelect;
         multiFrame                                           : TFrameMultiSelect;
         typeFrame                                            : TFrameKeyType;
         windowsFrame, WordFrame, ExcelFrame, PowerPointFrame : TFrameOperate;
         // SelectWindow: TSelectForm;
         // RemainTime:integer;
         Inst : TExamClientGlobal;
      public // global variable for ExamClient
         class property ExamTCPClient : TExamTCPClient read FExamTCPClient write FExamTCPClient;

         // class property Examinee : TExaminee read FExaminee write FExaminee;
         class property BaseConfig : TBaseConfig read FBaseConfig write FBaseConfig;
         class property ExamPath   : string read FExamPath write FExamPath;
         class property LoginType  : TLoginType read FLoginType write FLoginType;

         class property Modules : TModules read FModules write FModules;
         class property Score   : TScoreIni read FScore write FScore;
         /// this for client db
         class property ConnClientDB : TADOConnection read GetConnClientDB;
         {$ENDREGION}
      public
         // constructor Create();
         class procedure CreateClassObject();
         class procedure DestroyClassObject();
         // destructor Destroy(); override;
         /// 从服务器获取配置数据保存到 TExamClientGlobal.Modules中
         class function SetBaseConfig() : TCommandResult;
         class function GetClientConfig(filename : string) : boolean;
         // 从 sysconfig表中获得加密数据 来设置数据模块中的全局变量
         class procedure SetGlobalExamPath();

         class function CreateExamEnvironmentByTestFilepack(AExamineeID : string; ALoginType : TLoginType; AEnvironmentPath : string) : Integer;

         class procedure SetEQBConn(path : string = ''; dbName : string =CLIENTDB_FILENAME; { '考生题库.dat';} pwd : string = 'jiaping');

         class procedure SetupExamineeInfoBase(const AExaminee : TExaminee); static;
         class procedure AquireExamineeInfoFromClientDB(var AExaminee : TExaminee); static;
         class function VerifiesExamineeIDFromClientDB(AExaminee: TExaminee): boolean; static;

         class function Login() : TCommandResult; overload; static;
         class function Login(LoginType : TLoginType; pwd : string) : TCommandResult; overload; static;

         class procedure EnableTimer;
         class procedure UnableTimer;

         class function InitExam : TModalResult;
         class function CreateEnvironment(const ALoginType : TLoginType) : TModalResult;

   end;

   // var
   // clientGlobal: TExamClientGlobal;

implementation

uses
   SysUtils, ExamGlobal, Windows, ShellModules, Commons, compress,
   ExamInterface, tq, Forms, Variants, datautils,ExamException;

// constructor TExamClientGlobal.Create();
// begin
// TExamClientGlobal.Inst := Self;
// TExamClientGlobal.FScore := TScoreIni.Create;
// end;

class function TExamClientGlobal.SetBaseConfig() : TCommandResult;
   var
      i                              : Integer;
      delegateGetModuleName          : FngetModuleDllName;
      delegateGetModuleButtonText    : FnGetModuleButtonText;
      delegateGetPrefix              : FnGetModulePreFix;
      delegateGetModuleDocName       : FnGetModuleDocName;
      delegateGetModuleDelimiterChar : FnGetModuleDelimiterChar;
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

class function TExamClientGlobal.GetClientConfig(filename : string) : boolean;
   var
      cfg   : TStringList;
      ahost : string;
      aPort : word;
   begin
      Result := false;
      if FileExists('clientconfig.ini') then
      begin
         cfg := TStringList.Create;
         try
            cfg.LoadFromFile('clientconfig.ini');
            ahost := cfg.Values['serverip'];
            if not word.tryparse(cfg.Values['serverport'], aPort) then
            begin
               Application.MessageBox('读取配置文件ClietnConfig.ini出错！' + #13#10 + '请检查是否存在ServerPort项，该项值是否为3000', '提示');
               exit;
            end;

            TExamClientGlobal.ExamTCPClient.Host := ahost;
            TExamClientGlobal.ExamTCPClient.Port := aPort;

            TExamClientGlobal.FExamPath := cfg.Values['ExamPath'];
            if not DirectoryExists(TExamClientGlobal.FExamPath) then
            begin
               if not createdir(TExamClientGlobal.FExamPath) then
               begin
                  Application.MessageBox('读取配置文件ClietnConfig.ini出错！' + #13#10 + '请检查是否存在Exampath项，该项值是否为有效路径', '提示');
                  exit;
               end;
            end;
            Result := true;
            // if trim(aip)=string.Empty then errorMessage:='配置文件中ServerIP不能为空；';
            // if (not integer.tryparse( cfg.values['serverport'], portvalue)) then errorMessage:=errorMessage+'配置文件中ServerPort项值应为整数，默认应为3000;';
         finally
            cfg.free;
         end;
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
// //建立考生题库
// try
// if FExamTCPClient.CommandGetEQFile('1',memStream) =crOk then
// memStream.SaveToFile(APath+'\考生题库.dat')
// else
// raise Exception.Create('获取考生题库出错');
// finally
// memStream.Free;
// end;
//
// //建立考生题库连接
// DmClient.SetEQBConn(APath);
// //GlobalExamTCPClient.CommandGetEQInfo(EQInfo);
// PopulateExamineeBase();
//
// //切换考生信息到考生数据库
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
// raise Exception.Create('获取试题出错'+AEQInfo[i]);
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
         raise Exception.Create('考生ID不能为空');
      FExamPath := IncludeTrailingPathDelimiter(FExamPath) + Examinee.ID; // FBaseConfig.ExamPath + '\' + Examinee.ID;
   end;

class procedure TExamClientGlobal.CreateClassObject;
   begin
      // TExamClientGlobal.Inst := Self;
      FScore := TScoreIni.Create;
   end;

class function TExamClientGlobal.CreateExamEnvironmentByTestFilepack(AExamineeID : string; ALoginType : TLoginType; AEnvironmentPath : string) : Integer;
   var
      memStream : TMemoryStream;
   begin
      memStream := TMemoryStream.Create;
      try
         if FExamTCPClient.CommandGetExamineeTestFilePack(AExamineeID, ALoginType, memStream) = crOk then
         begin
            if not DirectoryExists(AEnvironmentPath) then
               createdir(AEnvironmentPath);
            DirectoryDecompression(AEnvironmentPath, memStream);
         end;
      finally
         memStream.free;
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
      moduleinfo : TModuleInfo;
      i          : Integer;
      jg         : LongBool;
   begin
      if ExamineePhoto <> nil then
         ExamineePhoto.free;
      for i := 0 to high(FModules) do
      begin
         moduleinfo := FModules[i];
         jg         := FreeLibrary(moduleinfo.DllHandle);
         moduleinfo.free;
      end;
      FModules := nil;
      if (FBaseConfig <> nil) then
         FBaseConfig.free;
      FExamTCPClient.free;
      FConnClientDB.free;
      FScore.free;
      if FMainTimer <> nil then
         FMainTimer.free;
   end;

class procedure TExamClientGlobal.EnableTimer;
   begin
      if FMainTimer = nil then
      begin
         FMainTimer          := TTimer.Create(nil);
         FMainTimer.Interval := 1000;
         FMainTimer.OnTimer  := MainTimerTimer;
         FMainTimer.Enabled  := true;
      end else begin
         FMainTimer.OnTimer := MainTimerTimer;
         FMainTimer.Enabled := true;
      end;
   end;

class procedure TExamClientGlobal.UnableTimer;
   begin
      if FMainTimer <> nil then
      begin
         FMainTimer.Enabled := false;
      end;
   end;

class procedure TExamClientGlobal.SetEQBConn(path : string = ''; dbName : string =CLIENTDB_FILENAME; { '考生题库.dat';} pwd : string = 'jiaping');
   var
      appPath : string;
   begin
      if FConnClientDB = nil then
      begin
         FConnClientDB                := TADOConnection.Create(nil);
         FConnClientDB.LoginPrompt    := false;
         FConnClientDB.Provider       := 'Microsoft.Jet.OLEDB.4.0';
         FConnClientDB.KeepConnection := true;

      end;

      if FileExists(path + '\' + dbName) then
      begin
         FConnClientDB.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + path + '\' + dbName + ';Mode=Share Deny None;Persist ' +
                 'Security Info=False;Jet OLEDB:Database Password=' + pwd;
      end
      else
         raise Exception.Create('找不到考生试题库！，可能是生成考试环境出错，或错误删除了该文件');
         FConnClientDB.Connected := true;
     

   end;

class function TExamClientGlobal.GetConnClientDB : TADOConnection;
   begin
      Result := FConnClientDB;
   end;

class procedure TExamClientGlobal.SetupExamineeInfoBase(const AExaminee : TExaminee);
   var
      qry : TADOQuery;
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
         qry.free;
      end;
   end;

class procedure TExamClientGlobal.AquireExamineeInfoFromClientDB(var AExaminee : TExaminee);
   var
      qry : TADOQuery;
   begin
      qry := TADOQuery.Create(nil);
      try
         with qry, AExaminee do
         begin
            Connection := FConnClientDB;

            SQL.Add('select * from ' + TBANAME_EXAMDB_INFO);
            qry.Active := true;
            qry.First;
            if AExaminee.ID = DecryptStr(qry.FieldValues[DFNEI_EXAMINEEID]) then
            begin
               AExaminee.RemainTime := strtoint(DecryptStr(qry.FieldValues[DFNEI_REMAINTIME]));
            end;
         end;
      finally
         qry.free;
      end;
   end;
class function TExamClientGlobal.VerifiesExamineeIDFromClientDB(AExaminee : TExaminee):boolean;
   var
      qry : TADOQuery;
   begin
      result:=false;
      qry := TADOQuery.Create(nil);
      try
         with qry, AExaminee do
         begin
            Connection := FConnClientDB;

            SQL.Add('select * from ' + TBANAME_EXAMDB_INFO);
            qry.Active := true;
            qry.First;
            if AExaminee.ID = DecryptStr(qry.FieldValues[DFNEI_EXAMINEEID]) then
               result:=true;
         end;
      finally
         qry.free;
      end;
   end;

class function TExamClientGlobal.Login(LoginType : TLoginType; pwd : string) : TCommandResult;
   begin
      Result := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee.ID, TExamClientGlobal.LoginType, pwd);
      if Result = crOk then
      begin
         TExamClientGlobal.ExamTCPClient.OnTimer := TExamClientGlobal.UpdateStatusTimer;
      end;
   end;

class function TExamClientGlobal.Login() : TCommandResult;
   var
      loginResult : TCommandResult;
      // AExamineeID: string;
   begin
      Result := crRefuseLogin;
      // AExamineeID := TExamClientGlobal.Examinee.ID;
      { TODO -ojp -cneeddo : 考试环境、时间需要设置 }
      loginResult := crError;
      case TExamClientGlobal.Examinee.Status of
         esNotLogined :
            begin
               TExamClientGlobal.LoginType := ltFirstLogin;
               loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee.ID, TExamClientGlobal.LoginType);
            end;
         esDisConnect :
            begin
               // if DirectoryExists(GlobalExamPath) then
               begin
                  TExamClientGlobal.LoginType := ltContinuteInterupt;
                  loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee.ID, TExamClientGlobal.LoginType);
               end;
            end;
         esAllowContinuteExam :
            begin
               TExamClientGlobal.LoginType := ltContinuteEndedExam;
               loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee.ID, TExamClientGlobal.LoginType);
            end;
         esAllowReExam :
            begin
               TExamClientGlobal.LoginType := ltReExamLogin;
               loginResult                 := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee.ID, TExamClientGlobal.LoginType);
            end;
      else
         begin
            // 如果是其它状态，则不允许登录
            Result := crRefuseLogin; // refuse login
         end;
      end;
      if Result = crOk then
      begin
         TExamClientGlobal.ExamTCPClient.OnTimer := TExamClientGlobal.UpdateStatusTimer;
      end;
   end;

class procedure TExamClientGlobal.UpdateStatusTimer(Sender : TObject);
   begin
      if (TExamClientGlobal.Examinee.Status >= esLogined) then
      begin
         UpdateClientDBRemainTime(TExamClientGlobal.Examinee.RemainTime, TExamClientGlobal.ConnClientDB);
         TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name, TExamClientGlobal.Examinee.Status,
            TExamClientGlobal.Examinee.RemainTime);
      end;
   end;

class procedure TExamClientGlobal.MainTimerTimer(Sender : TObject);
   var
      sj : string;
   begin
      with TExamClientGlobal, TExamClientGlobal.Examinee do
      begin
         RemainTime := RemainTime - 1;
         sj         := format('%.2d:%.2d', [RemainTime div 60, RemainTime mod 60]);
         {$IFDEF FLASH}
         ClientMainForm.SetFlashRemainTime(sj);
         {$ENDIF}
         if Assigned(ClientMainForm) and ClientMainForm.Showing then
            ClientMainForm.lblTime.Caption := '考试剩余时间:' + sj;
         if Assigned(floatWindow) and floatWindow.Showing then
         begin
            floatWindow.txtTime.Caption := '剩余:' + sj;
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
      // Floatwindow.stTime1.caption:='时间：'+sj;
      // end;
      //
      //
      // if TExamClientGlobal.RemainTime=300 then
      // MessageBoxOnTopForm(application,'还有5分钟考试结束，请保存好文档','警告', mb_ok);
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

   end;

class function TExamClientGlobal.InitExam : TModalResult;
   begin
      Result := TExamClientGlobal.CreateEnvironment(TExamClientGlobal.LoginType);
      TExamClientGlobal.Examinee.Status:= esLogined;
      TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name, TExamClientGlobal.Examinee.Status,
         TExamClientGlobal.Examinee.RemainTime);

   end;

class function TExamClientGlobal.CreateEnvironment(const ALoginType : TLoginType) : TModalResult;
   begin
      Result := mrOk;
      TExamClientGlobal.SetGlobalExamPath;
      try
         case ALoginType of
            ltFirstLogin, ltReExamLogin :
               begin
                  TExamClientGlobal.CreateExamEnvironmentByTestFilepack(TExamClientGlobal.Examinee.ID, ALoginType, TExamClientGlobal.ExamPath);
                  TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);            // 设置考生试题库连接
                  TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee); // 以备上报评分时获得考生信息
               end;
            ltContinuteInterupt :
               begin
                  if DirectoryExists(TExamClientGlobal.ExamPath) then
                  begin
                     TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);                     // 设置考生试题库连接
                     TExamClientGlobal.AquireExamineeInfoFromClientDB(TExamClientGlobal.Examinee); // 以备上报评分时获得考生信息
                  end else begin
                     MessageBoxOnTopForm(Application, '找不到上次考试文件目录！', '提示:', mb_ok);
                     Result := mrCancel;
                  end;
               end;
            ltContinuteEndedExam:
               begin
                  if not DirectoryExists(TExamClientGlobal.ExamPath) then
                     TExamClientGlobal.CreateExamEnvironmentByTestFilepack(TExamClientGlobal.Examinee.ID, ALoginType, TExamClientGlobal.ExamPath);
                  TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);                     // 设置考生试题库连接
                  EExamException.IfFalse( TExamClientGlobal.VerifiesExamineeIDFromClientDB(TExamClientGlobal.Examinee),'考生文件夹中准考号与登录号不一致！'); // 校验考生
                  TExamClientGlobal.AquireExamineeInfoFromClientDB(TExamClientGlobal.Examinee); // 以备上报评分时获得考生信息
               end;
            ltAddTimeExam :
               begin
                  if not DirectoryExists(TExamClientGlobal.ExamPath) then
                     TExamClientGlobal.CreateExamEnvironmentByTestFilepack(TExamClientGlobal.Examinee.ID, ALoginType, TExamClientGlobal.ExamPath);
                  TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);                     // 设置考生试题库连接
                  EExamException.IfFalse( TExamClientGlobal.VerifiesExamineeIDFromClientDB(TExamClientGlobal.Examinee),'考生文件夹中准考号与登录号不一致！'); // 校验考生
               end;
         end;
      except
         on e : Exception do
         begin
            MessageBoxOnTopForm(Application, '生成考试环境出现问题，请重新进入系统'+EOL + e.Message, '提示:', mb_ok);
            Result := mrCancel;
         end;
      end;

   end;

end.
