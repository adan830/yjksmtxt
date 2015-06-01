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
  frmEnterForBaseImport in 'Server\frmEnterForBaseImport.pas' {EnterForBaseImport};

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
  Application.Run;
end.
