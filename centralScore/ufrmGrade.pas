unit ufrmGrade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmGrade = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    pb: TProgressBar;
    edtname: TEdit;
    edtzkh: TEdit;
    edtPath: TEdit;
  private
  public
    procedure progress;
    { Public declarations }
  end;
  procedure OnProcess(AMessage : string; AStep : integer = 1);
var
  frmGrade: TfrmGrade;

implementation

uses ufrmInProcess, publicunit, uKeyType;

{$R *.dfm}

procedure TfrmGrade.progress;
var
  I: Integer;
  pbHandle:integer;  //表示进度条对象
  zf:Integer;
  AOnProcess : TOnProcess;
begin
//    pbHandle:=TProcessManager.BeginProcess('',0, 100,-1);
//    try
//      SingleSelectGrade(pbHandle);
//      MultiSelectGrade(pbHandle);
//      typeform1.FormShow(self);
//      WinGrade(pbHandle);
//      WordGrade(pbHandle);
//      ExcelGrade(pbHandle);
//      PptGrade(pbHandle);
//    finally // wrap up
//      TProcessManager.EndProcess(pbHandle);
//    end;    // try/finally

    //UpdateTotalScore;
      AOnProcess := OnProcess;

      pbHandle := PMBeginProcess(Application, '系统正在评分，请不要进行其它操作！！！', '正在开始评分！', 0, 100, -1);
      try
         SingleSelectGrade(AOnProcess);
         MultiSelectGrade(AOnProcess);
         //texamclientglobal.typeFrame.HideFrame;
        // OperationGrade(AOnProcess, TExamClientGlobal.connClientDB, TExamClientGlobal.ExamPath);
      finally
         PMEndProcess(pbHandle);
      end;

      //SaveScoreToDB(TExamClientGlobal.score);
     // TExamClientGlobal.ExamTCPClient.CommandSendScoreInfo(TExamClientGlobal.Examinee, TExamClientGlobal.score);
end;

procedure OnProcess(AMessage : string; AStep : integer = 1);
   begin
      //PMOnProcess(.pb, AMessage, AStep);
   end;

end.
