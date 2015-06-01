program prjExamClient;



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
  uDispAnswer in 'ExamCommons\uDispAnswer.pas' {frmDispAnswer};
  //FlashPlayerControl in 'FlashPlayerControl\FlashPlayerControl\Delphi2007\FlashPlayerControl.pas';

{$R *.res}

begin
   {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown :=True;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := true  ;
  Application.Title := 'һ��WINDOWS��ֽ������ϵͳ';
  TExamClientGlobal.CreateClassObject();
  //Application.CreateForm(TDmClient, TExamClientGlobal.DmClient);
  TExamClientGlobal.ExamTCPClient := TExamTCPClient.Create(CONSTSERVERIP,CONSTSERVERPORT);
  try
     TExamClientGlobal.ExamTCPClient.Connect;// GlobalExamTCPClient.Connect;
     TExamClientGlobal.SetBaseConfig();
  except
     on E : Exception do begin
         //Application.MessageBox(pchar(e.Message),'ddd');
         Application.MessageBox('���ӷ�����ʧ�ܣ���������������Ƿ����С������Ƿ�������', 
           '���ӷ�����ʧ��', MB_RETRYCANCEL + MB_ICONSTOP + MB_TOPMOST); 
         application.Terminate;
      end;
  end;
  //Application.CreateForm(TExamClientGlobal, TExamClientGlobal.Inst);
  
  Application.CreateForm(TClientMainForm,TExamClientGlobal.ClientMainForm);
  Application.Run;
end.
