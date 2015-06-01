program SetQuestions;
uses
  {$IFDEF DEBUG}
  {$ENDIF }
  Forms,
  uAuthAppFactory,
  SysUtils,
  ufrmBase in 'SetQuestions\ufrmBase.pas' {frmBase},
  ufraTree in 'SetQuestions\ufraTree.pas' {fraTree: TFrame},
  uDmSetQuestion in 'SetQuestions\uDmSetQuestion.pas' {dmSetQuestion: TDataModule},
  uBaseActionForm in 'SetQuestions\uBaseActionForm.pas' {BaseActionForm},
  uFnMt in 'SetQuestions\uFnMt.pas',
  ufrmType in 'SetQuestions\ufrmType.pas' {frmType},
  ufrmWin in 'SetQuestions\ufrmWin.pas' {frmWin},
  ufrmWord in 'SetQuestions\ufrmWord.pas' {frmWord},
  uSysConfig in 'SetQuestions\uSysConfig.pas' {frmSysConfig},
  ufrmMain in 'SetQuestions\ufrmMain.pas' {frmMain},
  ufrmFileCheck in 'SetQuestions\ufrmFileCheck.pas' {frmFileCheck},
  ufrmPpt in 'SetQuestions\ufrmPpt.pas' {frmPpt},
  ufrmExcel in 'SetQuestions\ufrmExcel.pas' {frmExcel},
  ufrmSelect in 'SetQuestions\ufrmSelect.pas' {frmSelect},
  SetQuestionGlobal in 'SetQuestions\SetQuestionGlobal.pas',
  ufrmEQImport in 'SetQuestions\ufrmEQImport.pas' {frmEQImport},
  ufrmEQBUseInfo in 'SetQuestions\ufrmEQBUseInfo.pas' {frmEQBUseInfo},
  ufrmTestStrategy in 'SetQuestions\ufrmTestStrategy.pas' {frmTestStrategy},
  uConvertDBtoRTF in 'SetQuestions\uConvertDBtoRTF.pas' {frmConverttoRTF},
  uFileAddonsImport in 'SetQuestions\uFileAddonsImport.pas' {frmAddonsFile},
  ufrmModifyTQNo in 'SetQuestions\ufrmModifyTQNo.pas' {frmModifyTQNo},
  ufrmEncryptStr in 'SetQuestions\ufrmEncryptStr.pas' {frmStrEncrypt},
  CommandRegister in 'SetQuestions\CommandRegister.pas',
  SetQuestionsException in 'SetQuestions\SetQuestionsException.pas',
  SetQuestionsResoureStrings in 'SetQuestions\SetQuestionsResoureStrings.pas',
  ufrmExpressionTree in 'SetQuestions\ufrmExpressionTree.pas' {frmExpressionTree};

{$R *.res}

var
  AppFactory : TAuthAppFactory;

begin
  {$IFDEF DEBUG}
  //ReportMemoryLeaksOnShutdown :=True;
  {$ENDIF}
  Application.Initialize;
  Application.Title := RSAppTitle;
  Application.MainFormOnTaskbar := True;
  try
      AppFactory := TAuthAppFactory.Create(RSUserDataFileName,TfrmMainCommand);
      try
         if not AppFactory.Factory then
            exit;
      finally
         AppFactory.Free;
      end;
     Application.Run;
  except
    on e: Exception do
      Application.HandleException(nil);
  end;
end.
