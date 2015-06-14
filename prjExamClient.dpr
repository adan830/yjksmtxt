program prjExamClient;



{$R *.dres}

uses
  FastMM4,
  Forms,
  SysUtils,
  IdException,
  ExamTCPClient in 'ExamNet\ExamTCPClient.pas',
  ExamClientGlobal in 'Client\ExamClientGlobal.pas',
  ExamTypeFrm in 'Client\ExamTypeFrm.pas' {ExamTypeForm},
  ClientMain in 'Client\ClientMain.PAS' {ClientMainForm},
  Select in 'Client\Select.pas' {SelectForm},
  KeyType in 'Client\KeyType.pas' {TypeForm},
  score in 'Client\score.pas' {ScoreForm},
  floatform in 'Client\floatform.pas' {FloatWindow},
  ufrmExit in 'Client\ufrmExit.pas' {frmExit},
  NetGlobal {frmExit},
  SelectGrade in 'Client\SelectGrade.pas',
  Windows,
  ufrmInProcess in 'ExamCommons\ufrmInProcess.pas' {frmInProcess},
  uDispAnswer in 'ExamCommons\uDispAnswer.pas' {frmDispAnswer},
  ufrmLogin in 'Client\ufrmLogin.pas' {FrmLogin},
  ufrmSingleSelect in 'Client\ufrmSingleSelect.pas' {frmSingleSelect: TFrame};

//FlashPlayerControl in 'FlashPlayerControl\FlashPlayerControl\Delphi2007\FlashPlayerControl.pas';

{$R *.res}

begin
   {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown :=True;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := true  ;
  Application.Title := '一级WINDOWS无纸化考试系统';
  TExamClientGlobal.CreateClassObject();
  //Application.CreateForm(TDmClient, TExamClientGlobal.DmClient);
  TExamClientGlobal.ExamTCPClient := TExamTCPClient.Create(CONSTSERVERIP,CONSTSERVERPORT);
  try
     TExamClientGlobal.ExamTCPClient.Connect;// GlobalExamTCPClient.Connect;
     TExamClientGlobal.SetBaseConfig();
  except
     on E : Exception do begin
         //Application.MessageBox(pchar(e.Message),'ddd');
         Application.MessageBox('连接服务器失败！请检查服务器程序是否运行、网络是否正常！',
           '连接服务器失败', MB_RETRYCANCEL + MB_ICONSTOP + MB_TOPMOST);
         application.Terminate;
      end;
  end;

{$ifdef NOLOGIN  }
    TExamClientGlobal.Examinee.ID:='11111100101';
    TExamClientGlobal.Login();
    TExamclientGlobal.InitExam;
   Application.CreateForm(TClientMainForm,TExamClientGlobal.ClientMainForm );
{$ELSE}
  with TFrmLogin.Create(Application) do
  try
    if showModal=1 then
    begin
      Application.CreateForm(TTExamClientGlobal, TExamClientGlobal);
  Application.CreateForm(TTExamClientGlobal, TExamClientGlobal);
  Application.CreateForm(TClientMainForm,TExamClientGlobal.ClientMainForm );

//    Application.CreateForm(TSelectForm, SelectForm);
//    Application.CreateForm(TFloatWindow, FloatWindow);
    //Application.CreateForm(TTypeForm, TypeForm);
    //  Application.CreateForm(TScoreForm, ScoreForm);
      free;
    end
    else
    begin
      free;
      application.Terminate;
    end;

  except
    Free;
    application.Terminate;
  end;
 {$ENDIF}
  Application.Run;
end.
