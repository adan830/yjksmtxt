program Score;

uses
  Forms,
  SysUtils,
  uAuthAppFactory,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmScoreReceive in 'ufrmScoreReceive.pas' {frmScoreReceive},
  ufrmConfig in 'ufrmConfig.pas' {frmConfig},
  udmMain in 'udmMain.pas' {dmMain: TDataModule},
  ufrmBrowseSource in 'ufrmBrowseSource.pas' {frmBrowseSource},
  uPubFn in 'uPubFn.pas',
  ufrmScore in 'ufrmScore.pas' {frmScore},
  ufrmReceiveEQUseInfo in 'ufrmReceiveEQUseInfo.pas' {frmReceiveEQUseInfo},
  CommandRegister in 'CommandRegister.pas',
  GlobalScore in 'GlobalScore.pas',
  ufrmRestoreExamFolder in 'ufrmRestoreExamFolder.pas' {frmRestoreExamFolder};

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
