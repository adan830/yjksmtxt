program prjEaxmServer;

uses
  FastMM4,
  Forms,
  uFormMainServer in 'Server\uFormMainServer.pas' {FormMainServer},
  ExamineesManager in 'Server\ExamineesManager.pas',
  ServerUtils in 'Server\ServerUtils.pas',
  uDmServer in 'Server\uDmServer.pas' {dmServer: TDataModule},
  uDataModulePool in 'Server\uDataModulePool.pas',
  StkRecordInfo in 'Server\StkRecordInfo.pas',
  ExamServer in 'ExamNet\ExamServer.pas',
  frmExamineesImport in 'Server\frmExamineesImport.pas' {ExamineesImport},
  ServerGlobal in 'Server\ServerGlobal.pas',
  frmEnterForBaseImport in 'Server\frmEnterForBaseImport.pas' {EnterForBaseImport},
  uTotalScoreForm in 'Server\uTotalScoreForm.pas' {TotalScoreForm},
  SetExamPwd in 'Server\SetExamPwd.pas' {ResetExamPwdForm},
  ufrmServerLogin in 'Server\ufrmServerLogin.pas' {FormServerLogin};

{$R *.res}

begin
   {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown :=True;
  {$ENDIF}
  // define REGISTER_EXPECTED_MEMORY_LEAK
  //NeverSleepOnMMThreadContention := True;
  Application.Initialize;
  IsMultiThread := true;
  Application.MainFormOnTaskbar := True;
  //Application.CreateForm(TdmServer, GlobalDmServer);
  Application.CreateForm(TFormMainServer, FormMainServer);

  {$IFNDEF NOLOGIN  }
   FormMainServer.visible:=false;
   FormMainServer.Shadowed:=false;
   with TFormServerLogin.Create(Application) do
      try
         if showModal = 1 then
         begin
            FormMainServer.visible:=true;
            FormMainServer.Shadowed:=true;
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
end.
