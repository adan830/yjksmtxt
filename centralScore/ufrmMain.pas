unit ufrmMain;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Variants,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   ComCtrls,
   ShlObj,
   ExamGlobal,
   ufrminprocess,
   Data.DB,
   Data.Win.ADODB,
   scoreini, cxShellCommon, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxShellComboBox, Vcl.StdCtrls,NetGlobal;

type
   TfrmMain = class(TForm)
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      edtStart: TEdit;
      edtEnd: TEdit;
      Button1: TButton;
      ListBox1: TListBox;
      cbKspath: TcxShellComboBox;
      Label4: TLabel;
      cbSystemDBpath: TcxShellComboBox;
      lblProgress: TLabel;
      Label7: TLabel;
      Label8: TLabel;
      Label9: TLabel;
      pb: TProgressBar;
      edtname: TEdit;
      edtzkh: TEdit;
      edtPath: TEdit;
      setExamineeBase: TADODataSet;
      connExamineeBase: TADOConnection;
      Label10: TLabel;
      procedure Button1Click(Sender: TObject);
      procedure connExamineeBaseBeforeConnect(Sender: TObject);
   private
      CurrentExaminee: TExaminee;
      pbHandle: integer; // ��ʾ����������
      procedure CreateExamEnvironment(aPath, currentID: string);
      procedure InsertExamineeRec(AExaminee: TExaminee; AScore: TScoreIni);
      // procedure OnProcess(AMessage: string; AStep: integer = 1);
   public

      { Public declarations }
   end;

procedure OnProcess(AMessage: string; AStep: integer);

var
   frmMain: TfrmMain;

implementation

uses udmMain,
   ufrmGrade,
   compress,
   datafieldconst,
   commons,
   centralgrade;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var
   st, en, count: int64;
   i: integer;
   spath: string;
   currentID: string;
   currentDatFile: string;
   // AOnProcess: TOnProcess;
   centralgrade: TCentralGrade;
begin
   dm := dm1;
   st := strtoint64(edtStart.text);
   en := strtoint64(edtEnd.text);
   spath := IncludeTrailingPathDelimiter(cbKspath.AbsolutePath);
   count := en - st + 1;
   for i := 0 to count - 1 do
      begin
         currentID := inttostr(st + i);
         currentDatFile := currentID + '.dat';
         if not DirectoryExists(spath + currentID) then
            if FileExists(spath + currentDatFile) then
               begin
                  try
                     UnZipExamPackFile2Dir(spath + currentDatFile, spath);
                  except
                     on E: Exception do
                        Application.MessageBox(pwidechar(Format('��ѹ�����ļ��������ļ�����Ϊ�� %s /n ������ϸ��Ϣ�� %s', [currentDatFile, E.Message])),
                          '��ѹ�����ļ�������', MB_OK + MB_ICONSTOP + MB_TOPMOST);
                  end;
               end
            else
               Continue;

         // ������ֳ����ɿ����Թ�����¼���б����
         CreateExamEnvironment(spath, currentID);
         // if not udmMain.dm1.TbKsStk.Active then
         // udmMain.dm1.TbKsStk.Active := true;
         // frmgrade.show;
         edtname.text := CurrentExaminee.Name;
         edtzkh.text := CurrentExaminee.ID;
         edtPath.text := spath + currentID;

         // AOnProcess := OnProcess;

         // pbHandle := PMBeginProcess(Application, '�������֣��벻Ҫ������������������', '���ڿ�ʼ���֣�', 0, 100, -1);
         centralgrade := TCentralGrade.Create(spath + currentID, udmMain.dm1.ksconn, OnProcess);
         try
            centralgrade.SingleSelectGrade();
            centralgrade.MultiSelectGrade();
            centralgrade.TypeGrade();
            // texamclientglobal.typeFrame.HideFrame;
            centralgrade.OperationGrade();
            InsertExamineeRec(CurrentExaminee, centralgrade.Score);
            ListBox1.Items.Add(CurrentExaminee.ID + '-' + CurrentExaminee.Name + centralgrade.ErrorMessage)
         finally
            centralgrade.free;
            // PMEndProcess(pbHandle);
         end;

      end;
      lblProgress.Caption:='��������֣�';
end;

procedure TfrmMain.CreateExamEnvironment(aPath, currentID: string);
var
   temp: TAdocommand;
   qry: TADOQuery;
begin
   CurrentExaminee.ClearData;
   aPath := IncludeTrailingPathDelimiter(aPath) + currentID;
   try
      // if dm.ksstatus=-2 then
      begin
         udmMain.dm1.ksconn.Connected := false;
         if FileExists(IncludeTrailingPathDelimiter(aPath) + '�������.dat') then
            begin
               udmMain.dm1.ksconn.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + IncludeTrailingPathDelimiter(aPath)
                 + '�������.dat;Persist Security Info=False;Jet OLEDB:Database Password=jiaping';
            end
         else
            raise Exception.Create(Format('�� %s ���Ҳ��� ���������.dat�ļ�������', [aPath]));
         udmMain.dm1.ksconn.Connected := true;
         qry := TADOQuery.Create(nil);
         try
            with qry, CurrentExaminee do
               begin
                  Connection := udmMain.dm1.ksconn;

                  SQL.Add('select * from ' + TBANAME_EXAMDB_INFO);
                  qry.Active := true;
                  qry.First;
                  ID := DecryptStr(qry.FieldValues[DFNEI_EXAMINEEID]);
                  Name := DecryptStr(qry.FieldValues[DFNEI_EXAMINEENAME]);
                  // Sex := DecryptStr(qry.FieldValues[DFNEI_EXAMINEESEX]);
                  RemainTime := strtoint(DecryptStr(qry.FieldValues[DFNEI_REMAINTIME]));
               end;
         finally
            qry.free;
         end;
         if CurrentExaminee.ID <> currentID then
            raise Exception.Create(Format('�������.dat�п����ţ�%s �뵱ǰ��:%s ��һ�£�����', [CurrentExaminee.ID, currentID]));

         // udmMain.dm1.TbKsxxk.Active := false;
         // udmMain.dm1.TbKsxxk.Connection := udmMain.dm1.ksconn;
         // udmMain.dm1.TbKsxxk.Active := true;
         // udmMain.dm1.TbKsxxk.First;
         //
         // udmMain.dm1.kszkh := DecryptStr(udmMain.dm1.TbKsxxk.fieldbyname(DFNEI_EXAMINEEID).AsString);
         // udmMain.dm1.ksxm := DecryptStr(udmMain.dm1.TbKsxxk.fieldbyname(DFNEI_EXAMINEENAME).AsString);
         // udmMain.dm1.KsPath := aPath;

         // udmMain.dm.TbKsxxk.AppendRecord([udmMain.dm.kszkh,udmMain.dm.ksxm,udmMain.dm.kssj,1]);
      end;
      // temp := TAdocommand.Create(self);
      // try
      // temp.Connection := udmMain.dm1.sysconn;
      // temp.CommandText :=
      // 'insert into ������Ϣ (zkh,xm,zsj,status,xz1_fs,pd_fs,dz_fs,win_fs,word_fs,excel_fs,ppt_fs,zf) values(:zkh,:xm,:zsj,:status,:xz,:pd,:dz,:win,:word,:excel,:ppt,:zf)';
      // temp.Parameters.ParamByName('zkh').Value := udmMain.dm1.TbKsxxk.FieldValues['zkh'];
      // temp.Parameters.ParamByName('xm').Value := udmMain.dm1.TbKsxxk.FieldValues['xm'];
      // temp.Parameters.ParamByName('zsj').Value := 0; // dm1.TbKsxxk.FieldValues['zsj'];
      // temp.Parameters.ParamByName('status').Value := '0A70'; // dm1.TbKsxxk.FieldValues['status'];
      // temp.Parameters.ParamByName('xz').Value := '0A70'; // dm1.TbKsxxk.FieldValues['xz1_fs'];
      // temp.Parameters.ParamByName('pd').Value := '0A70'; // dm1.TbKsxxk.FieldValues['pd_fs'];
      // temp.Parameters.ParamByName('dz').Value := '0A70'; // dm1.TbKsxxk.FieldValues['dz_fs'];
      // temp.Parameters.ParamByName('win').Value := '0A70'; // dm1.TbKsxxk.FieldValues['win_fs'];
      // temp.Parameters.ParamByName('word').Value := '0A70'; // dm1.TbKsxxk.FieldValues['word_fs'];
      // temp.Parameters.ParamByName('excel').Value := '0A70'; // dm1.TbKsxxk.FieldValues['excel_fs'];
      // temp.Parameters.ParamByName('ppt').Value := '0A70'; // dm1.TbKsxxk.FieldValues['ppt_fs'];
      // temp.Parameters.ParamByName('zf').Value := '0A70'; // dm1.TbKsxxk.FieldValues['zf'];
      // temp.Execute;
      // finally
      // temp.Free;
      // end;

      // dm1.TbMainFile.close;
      udmMain.dm1.TbKsxxk.close;

   except
      Application.NormalizeTopMosts;
      Application.MessageBox('���ɿ��Ի����������⣬�����½���ϵͳ', '��ʾ:', MB_OK);
      Application.RestoreTopMosts;

   end;

   // dm.ksstatus��ʾ����״̬ -1���ؿ� -2������ -3����Ч
   // try
   // if dm.ksstatus=-2 then
   // begin
   // dm.ksconn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dm.kspath+'\�������.dat;Persist Security Info=False;Jet OLEDB:Database Password=jiaping';
   // dm.ksconn.Connected:=true;
   // dm.TbKsxxk.Active:=false;
   // dm.TbKsxxk.Connection:=dm.ksconn;
   // dm.TbKsxxk.Active:=true;
   // dm.TbKsxxk.AppendRecord([dm.kszkh,dm.ksxm,dm.kssj]);      //�Ա��ϱ�����ʱ��ÿ�����Ϣ
   // dm.ksStatus:=1;
   // end
   // else
   // begin
   // createKsstk;                  //������������Ⲣ�л�������Ϣ���������ݿ�
   // CreateWindowsExamEnvironment(dm.KsPath);
   // CreateWordExamEnvironment;
   // CreateExcelExamEnvironment;
   // CreatePptExamEnvironment;
   // ClearScore;       // ���ϵͳ������Ϣ�е÷�
   // { raise ERangeError.CreateFmt('%d is not within the valid range of %d..%d', [1, 1, 1]);  }
   // end;
   // updateExamState(dm.ksStatus);
   // dm.TbMainFile.close;
   // dm.TbKsxxk.close;
   // modalResult:=1;
   // except
   // application.NormalizeTopMosts;
   // application.MessageBox('���ɿ��Ի����������⣬�����½���ϵͳ', '��ʾ:', mb_ok);
   // application.RestoreTopMosts;
   // modalResult:=-1;
   // end;
end;

procedure TfrmMain.InsertExamineeRec(AExaminee: TExaminee; AScore: TScoreIni);
var
   dfstr: string;
   sqlstr: string;
   ScoreStream: TMemoryStream;
begin
   if not setExamineeBase.Active then
      setExamineeBase.Active := true;

   ScoreStream := TMemoryStream.Create;
   try
      AScore.SaveToStream(ScoreStream);
      CompressStream(ScoreStream);
      setExamineeBase.AppendRecord([EncryptStr(CurrentExaminee.ID), EncryptStr(CurrentExaminee.Name)]);
      //, EncryptStr(CurrentExaminee.Sex),
//        EncryptStr(CurrentExaminee.IP), EncryptStr(inttostr(CurrentExaminee.Port)), EncryptStr(inttostr(ord(CurrentExaminee.Status))),
//        EncryptStr(inttostr(CurrentExaminee.RemainTime)), EncryptStr(DateTimeToStr(CurrentExaminee.TimeStamp))]);
      setExamineeBase.Edit;
      ScoreStream.Position := 0;
      (setExamineeBase.FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(ScoreStream);
      setExamineeBase.Post;
   finally
      ScoreStream.free;
   end;
end;

procedure TfrmMain.connExamineeBaseBeforeConnect(Sender: TObject);
var
   path: string;
begin
   path := ExtractFilePath(Application.ExeName);
   if not FileExists(path + '�ɼ���.mdb') then
      raise Exception.Create(Format('ϵͳδ���� %s ���ҵ� %s �ļ���' + examglobal.CR + '�����˳���', [path, '�ɼ���.mdb']));
   // if FileExists(path + '�ɼ���.mdb') then
   // begin
   connExamineeBase.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + path + '\�ɼ���.mdb' +
     ';Persist Security Info=False;Jet OLEDB:Database Password=' + DecryptStr(SYSDBPWD);
   // end
   // else
   // begin
   // Application.MessageBox(PChar(Format('ϵͳδ���� %s ���ҵ� %s �ļ���' + ExamGlobal.CR + '��ѡ��ɼ��⣬���������÷���ϵͳ·����', [path, '�ɼ���.mdb'])), 'δ�ҵ��ɼ���',
   // MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
   // Application.Terminate;
   // dlgOpen1.Title := '��ѡ��ϵͳ��⣺';
   // dlgOpen1.InitialDir := path;
   // dlgOpen1.FileName := '�ɼ���.mdb';
   // if dlgOpen1.Execute() then
   // begin
   // StkDbFilePath := dlgOpen1.FileName;
   // connExamineeBase.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + dlgOpen1.FileName +
   // ';Persist Security Info=False;Jet OLEDB:Database Password=' + DecryptStr(SYSDBPWD);
   // end
   // else
   // begin
   // { TODO : �Ƿ�Ҫ�˳����򣬻��Ǽ��� }
   // end;
   // end;
end;

// procedure OnProcess(AMessage: string; AStep: integer);
// begin
// PMOnProcess(frmMain.pbHandle, AMessage, AStep);
// end;

procedure OnProcess(AMessage: string; AStep: integer);
begin

   // PMOnProcess(frmMain.pbHandle, AMessage, AStep);

   if AMessage <> '' then
      frmMain.lblProgress.Caption := AMessage;

   // if ShowPosition then
   // frmInProcess.Info := frmInProcess.Info + '��' + IntToStr(frmInProcess.pb.Position) + '\' + IntToStr(frmInProcess.pb.Max) + '��';

   // if Position <> -1 then
   // frmInProcess.Position := Position
   // else
   frmMain.pb.StepBy(AStep);

   Application.ProcessMessages;

   // if frmInProcess.Canceled then
   // Canceled := true;

end;

end.
