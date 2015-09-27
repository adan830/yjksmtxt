program prjExamServer;

{ .$R uac.res uac.rc }
uses
{$IFDEF DEBUG}
   FastMM4, {$ENDIF}
   Forms, Winapi.Windows, uFormMainServer in 'Server\uFormMainServer.pas' {FormMainServer} , ExamineesManager in 'Server\ExamineesManager.pas',
   ServerUtils in 'Server\ServerUtils.pas', uDmServer in 'Server\uDmServer.pas' {dmServer: TDataModule} , uDataModulePool in 'Server\uDataModulePool.pas',
   StkRecordInfo in 'Server\StkRecordInfo.pas', ExamServer in 'ExamNet\ExamServer.pas',
   frmExamineesImport in 'Server\frmExamineesImport.pas' {ExamineesImport} , ServerGlobal in 'Server\ServerGlobal.pas',
   frmEnterForBaseImport in 'Server\frmEnterForBaseImport.pas' {EnterForBaseImport} , uTotalScoreForm in 'Server\uTotalScoreForm.pas' {TotalScoreForm} ,
   SetExamPwd in 'Server\SetExamPwd.pas' {ResetExamPwdForm} , ufrmServerLogin in 'Server\ufrmServerLogin.pas' {FormServerLogin} ,
   ufrmServerLock in 'Server\ufrmServerLock.pas' {FormServerLock};

{$R *.res}

var
   mymutex: THandle;

begin
{$IFDEF DEBUG}
   ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
   mymutex := CreateMutex(nil, True, 'JPExamServer Singleton mutex object');
   if GetLastError <> ERROR_ALREADY_EXISTS then
   begin

      // define REGISTER_EXPECTED_MEMORY_LEAK
      // NeverSleepOnMMThreadContention := True;

      Application.Initialize;

      IsMultiThread := True;
      Application.MainFormOnTaskbar := True;
      // Application.CreateForm(TdmServer, GlobalDmServer);
      Application.CreateForm(TFormMainServer, FormMainServer);
{$IFNDEF NOLOGIN  }
      FormMainServer.visible := false;
      FormMainServer.Shadowed := false;
      with TFormServerLogin.Create(Application) do
         try
            Shadowed := True;
            if showModal = 1 then
            begin
               FormMainServer.visible := True;
               FormMainServer.Shadowed := True;
               free;
            end
            else
            begin
               free;
               Application.Terminate;
            end;

         except
            free;
            Application.Terminate;
         end;
{$ENDIF}
      Application.Run;
   end
   else
      Application.MessageBox('您已经运行了考试服务器程序!', '提示', mb_OK);

end.
