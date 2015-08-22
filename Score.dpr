program Score;

uses
  Forms,
  SysUtils,
  uAuthAppFactory,
  ufrmMain in 'Score\ufrmMain.pas' {frmMain},
  ufrmScoreReceive in 'Score\ufrmScoreReceive.pas' {frmScoreReceive},
  ufrmConfig in 'Score\ufrmConfig.pas' {frmConfig},
  udmMain in 'Score\udmMain.pas' {dmMain: TDataModule},
  ufrmBrowseSource in 'Score\ufrmBrowseSource.pas' {frmBrowseSource},
  uPubFn in 'Score\uPubFn.pas',
  ufrmScore in 'Score\ufrmScore.pas' {frmScore},
  ufrmReceiveEQUseInfo in 'Score\ufrmReceiveEQUseInfo.pas' {frmReceiveEQUseInfo},
  CommandRegister in 'Score\CommandRegister.pas',
  GlobalScore in 'Score\GlobalScore.pas',
  ufrmRestoreExamFolder in 'Score\ufrmRestoreExamFolder.pas' {frmRestoreExamFolder};

{$R *.res}

  var
  AppFactory : TAuthAppFactory;
  

begin
  ReportMemoryLeaksOnShutdown :=True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  try
    AppFactory := TAuthAppFactory.Create(GlobalUserDatFileName,TfrmMainCommand);
    try
      if not AppFactory.Factory then
        exit;
    finally // wrap up
      AppFactory.Free;
    end;    // try/finally

    // Application.Title := ;
    Application.Run;
  except
    on e: Exception do
      Application.HandleException(nil);
  end;
end.
