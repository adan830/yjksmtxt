unit uFormOperate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, JvExStdCtrls, JvRichEdit, Vcl.Buttons, tq, ugrade,customcolorform,
  CnButtons;

type
  TFormOperate = class(TCustomColorForm)
    pnl1: TPanel;
    txtTime: TStaticText;
    edtEQContent: TJvRichEdit;
    Timer1: TTimer;
    btnGrade: TCnSpeedButton;
    btnOpen: TCnSpeedButton;
    btnReturn: TCnSpeedButton;
    procedure btnExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnGradeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
  private
    pos: TPoint;
    FAnchors: TAnchors;
    Expended: Boolean;

    moduleInfo: TModuleInfo;
    TestQuestion: TTQ;

    procedure WMMOVING(var Msg: TMessage); //message WM_MOVING;
  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ShowForm(aModuleInfo: TModuleInfo; aTq: TTQ);
  end;

var
  FormOperate: TFormOperate;

implementation

uses
  System.Math, examclientglobal, examglobal, ShellModules, udispanswer;

{$R *.dfm}

procedure TFormOperate.btnExitBitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFormOperate.btnGradeClick(Sender: TObject);
var
  GradeInfoStrings: TStringList;
  delegateGrade: fnFillGrades;
begin
  @delegateGrade := GetProcAddress(moduleInfo.DllHandle, FN_FILLGRADES);
  GradeInfoStrings := TStringList.Create;
  try
    TestQuestion.StAnswer.Position := 0;
    GradeInfoStrings.LoadFromStream(TestQuestion.StAnswer);
    delegateGrade(GradeInfoStrings, TExamClientGlobal.ExamPath, moduleInfo.DocName, nil, fmExamValue, False);
    TfrmDispAnswer.ShowForm(GradeInfoStrings, moduleInfo.DelimiterChar);
  finally
    GradeInfoStrings.Free;
  end;
end;

procedure TFormOperate.btnOpenClick(Sender: TObject);
var
  kspath: string;
  DllHandle: THandle;
  delegateOpenAction: ProcOpenAction;
begin
  @delegateOpenAction := GetProcAddress(moduleInfo.DllHandle, PROC_OPEN_ACTION);
  delegateOpenAction(Handle, TExamClientGlobal.ExamPath);
end;

procedure TFormOperate.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style :=ws_overlapped;
    params.ExStyle:=params.exstyle or ws_ex_topmost;
    //WndParent:=mainform.Handle;
    WndParent :=GetDesktopWindow;//0;   //     //父窗体为form1
  end;
end;

procedure TFormOperate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // CloseAllDoc; //todo
  TExamClientGlobal.ClientMainForm.visible := true;
  modalresult := 1;
end;

procedure TFormOperate.FormCreate(Sender: TObject);
begin
  parent := nil;
  if (TExamClientGlobal.BaseConfig.ExamClasify = EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode = SCOREDISPLAYMODECLIENT) then
    btnGrade.visible := true
  else
    btnGrade.visible := False;
  // Application.NormalizeTopMosts;
end;

procedure TFormOperate.ShowForm(aModuleInfo: TModuleInfo; aTq: TTQ);
begin
//Shadowed:=true;
  moduleInfo := aModuleInfo;
  TestQuestion := aTq;


  Caption:= moduleInfo.Name+'操作题';
  btnOpen.Caption := moduleInfo.ButtonText;
  TestQuestion.Content.Position := 0;
  edtEQContent.Lines.LoadFromStream(TestQuestion.Content);

  self.ShowModal;
end;

procedure TFormOperate.Timer1Timer(Sender: TObject);
const
  cOffset = 12;
var
  curHandle: THandle;
  curPoint: TPoint;
begin
  // CWP_ALL
  // 测试所有窗口
  // CWP_SKIPINVISIBLE
  // 忽略不可见窗口
  // CWP_SKIPDISABLED
  // 忽略已屏蔽的窗口
  // CWP_SKIPTRANSPARENT
  // 忽略透明窗口
  // curHandle :=ChildWindowFromPointEx(Handle,Mouse.CursorPos,CWP_SKIPINVISIBLE);
  // OutputDebugString(PWideChar(IntToStr(curHandle)));
  if WindowFromPoint(Mouse.CursorPos) = Handle then
  begin
    if akTop in FAnchors then
    begin
      Top := 0;
    end;
    if akLeft in FAnchors then
    begin
      Left := 0;
    end;
    if akRight in FAnchors then
    begin
      Left := Screen.Width - Width;
    end;
    if akBottom in FAnchors then
    begin
      Top := Screen.Height - Height;
    end;
  end
  else
  begin
    curPoint := self.ScreenToClient(Mouse.CursorPos);
    if ChildWindowFromPoint(Handle, curPoint) = 0 then
    begin
      if akLeft in FAnchors then
      begin
        Left := -Width + cOffset;
      end;
      if akTop in FAnchors then
      begin
        Top := -Height + cOffset;
      end;
      if akRight in FAnchors then
      begin
        Left := Screen.Width - cOffset;
      end;
      if akBottom in FAnchors then
      begin
        Top := Screen.Height - cOffset;
      end;
    end;
  end;
end;

procedure TFormOperate.WMMOVING(var Msg: TMessage);
begin
  inherited;
  with PRect(Msg.LParam)^ do
  begin
    Left := Min(Max(0, Left), Screen.Width - self.Width);
    Top := Min(Max(0, Top), Screen.Height - self.Height);
    // Right:=left+Width;
    // Bottom:=top+Height;
    Right := Min(Max(self.Width, Right), Screen.Width);
    Bottom := Min(Max(self.Height, Bottom), Screen.Height);
    FAnchors := [];
    if Left = 0 then
      Include(FAnchors, akLeft);
    if Right = Screen.Width then
      Include(FAnchors, akRight);
    if Top = 0 then
      Include(FAnchors, akTop);
    if Bottom = Screen.Height then
      Include(FAnchors, akBottom);
    Timer1.Enabled := FAnchors <> [];
    Expended := FAnchors <> [];
  end;
end;

end.
