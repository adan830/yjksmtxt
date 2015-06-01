unit floatform;

interface

uses
  Forms, StdCtrls, Buttons, Controls, ExtCtrls, DBCtrls, Classes, ComCtrls, 
  Windows, uGrade, JvExStdCtrls, JvRichEdit, DataFieldConst, tq, Messages;

type
   TTabItem = record
      ModuleInfo :TModuleInfo;
      TQ : TTQ;
   end;

   TTabs = array of TTabItem;

  TFloatWindow = class(TForm)
    tcEQ: TTabControl;
    Panel1: TPanel;
    ExitBitBtn: TBitBtn;
    stTime: TStaticText;
    OpenBitBtn: TBitBtn;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    btnExpand: TButton;
    stTime1: TStaticText;
    btnGrade: TButton;
    edtEQContent: TJvRichEdit;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tcEQChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnExpandClick(Sender: TObject);
    procedure OpenBitBtnClick(Sender: TObject);
    procedure btnGradeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    pos:TPoint;
    Tabs : TTabs;
    FAnchors: TAnchors;
    Expended:Boolean;
    procedure WMMOVING(var Msg: TMessage);message WM_MOVING;
    procedure GetEQTextByPrefix(APreFix: string; var ATQ : TTQ);  //return eq count
    //procedure SetupEQTab(ATcEQ: TComponent);
    { Private declarations }
  public
    procedure CreateTabs();
    { Public declarations }
  protected
     procedure CreateParams(var Params: TCreateParams); override;

  end;

implementation

uses ExamClientGlobal, uDispAnswer, ExamGlobal,
  Variants, ShellModules, SysUtils, DataUtils, ClientMain,math;

{$R *.dfm}

procedure TFloatWindow.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams( Params );
  with Params do
  begin
    Style :=ws_overlapped;
    params.ExStyle:=params.exstyle or ws_ex_topmost;
    //WndParent:=mainform.Handle;
    WndParent :=GetDesktopWindow;//0;   //     //父窗体为form1
  end;
end;

procedure TFloatWindow.GetEQTextByPrefix(APreFix: string; var ATQ : TTQ);
var
   stno :string;
begin
   stno := GetTQIDByPreFix(APreFix+'%',TExamClientGlobal.ConnClientDB);
   TTQ.ReadTQByIDAndUnCompress(stno,TExamClientGlobal.ConnClientDB,ATQ);
end;

procedure TFloatWindow.CreateTabs;
var
  I,tabscount: Integer;
begin
//这里要求，试题库中设置的操作模块，必须在考生库中有相应的试题
   tabscount :=0 ;
   for I := 0 to high(TExamClientGlobal.Modules) do begin
      with TExamClientGlobal.Modules[i] do
      begin
         if Classify =TEST_QUESTION_CLASSIFY_OPERATION then begin
               if dllHandle<>null then begin
                  Inc(tabscount);
                  SetLength(Tabs,tabscount);
                  Tabs[tabscount-1].ModuleInfo :=TExamClientGlobal.Modules[i];
                  Tabs[tabscount-1].TQ := TTQ.Create;
                  GetEQTextByPrefix(Prefix,Tabs[tabscount-1].TQ);
               end;
         end;
      end;
   end;
   if Length(Tabs)>0 then begin
      tcEQ.Tabs.Clear;
      for I := 0 to Length(Tabs) - 1 do begin
         tcEQ.Tabs.Add(inttostr(i+1)+'.'+ Tabs[i].ModuleInfo.Name);
      end;
   end;
end;

procedure TFloatWindow.ExitBitBtnClick(Sender: TObject);
begin
  close;

end;

procedure TFloatWindow.FormCreate(Sender: TObject);
begin
  parent:=nil;
  //Application.NormalizeTopMosts;
  if (TExamClientGlobal.BaseConfig.ExamClasify=EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode=SCOREDISPLAYMODECLIENT) then
     btnGrade.Visible:=true
  else
     btnGrade.Visible:=false;
  CreateTabs;
end;

procedure TFloatWindow.FormDestroy(Sender: TObject);
var
  i :Integer;
begin
  for I := 0 to Length(Tabs) - 1 do begin
    Tabs[i].ModuleInfo := nil;
    Tabs[i].TQ.Free;
  end;
end;

procedure TFloatWindow.tcEQChange(Sender: TObject);
begin
   OpenBitBtn.Caption := Tabs[tcEQ.TabIndex].ModuleInfo.ButtonText;
   Tabs[tcEQ.TabIndex].TQ.Content.Position :=0;
   edtEQContent.Lines.LoadFromStream(Tabs[tcEQ.TabIndex].TQ.Content);
end;

procedure TFloatWindow.WMMOVING(var Msg: TMessage);
begin
  inherited;
  with PRect(Msg.LParam)^ do
  begin
    Left := Min(Max(0, Left), Screen.Width - Width);
    Top := Min(Max(0, Top), Screen.Height - Height);
    Right := Min(Max(Width, Right), Screen.Width);
    Bottom := Min(Max(Height, Bottom), Screen.Height);
    FAnchors := [];
    if Left = 0 then Include(FAnchors, akLeft);
    if Right = Screen.Width then
      Include(FAnchors, akRight);
    if Top = 0 then Include(FAnchors, akTop);
    if Bottom = Screen.Height then
      Include(FAnchors, akBottom);
      Timer1.Enabled := FAnchors <> [];
      Expended := FAnchors <> [];
    end;
end;


procedure TFloatWindow.Timer1Timer(Sender: TObject);
const
  cOffset = 2;
  var
    curHandle:THandle;
    curPoint:TPoint;
  begin
//  CWP_ALL
//    测试所有窗口
//    CWP_SKIPINVISIBLE
//    忽略不可见窗口
//    CWP_SKIPDISABLED
//    忽略已屏蔽的窗口
//    CWP_SKIPTRANSPARENT
//    忽略透明窗口
//     curHandle :=ChildWindowFromPointEx(Handle,Mouse.CursorPos,CWP_SKIPINVISIBLE);
//     OutputDebugString(PWideChar(IntToStr(curHandle)));
    if WindowFromPoint(Mouse.CursorPos) = Handle   then
       begin
         if akTop in FAnchors then begin  Top := 0; end;
         if akLeft in FAnchors then begin  Left := 0; end;
         if akRight in FAnchors then  begin
            Left := Screen.Width - Width;    end;
          if akBottom in FAnchors then begin
            Top := Screen.Height - Height;  end;
          end else
       begin
           curPoint := Self.ScreenToClient(Mouse.CursorPos);
           if ChildWindowFromPoint(Handle,curPoint)=0 then
           begin
             if akLeft in FAnchors then begin Left := -Width + cOffset; end;
              if akTop in FAnchors then begin  Top := -Height + cOffset;  end;
              if akRight in FAnchors then   begin
                Left := Screen.Width - cOffset;   end;
              if akBottom in FAnchors then  begin
                Top := Screen.Height - cOffset;   end;
           end;
       end;
end;


procedure TFloatWindow.BitBtn1Click(Sender: TObject);
var
  place :tagWINDOWPLACEMENT;
begin
  place.length:=sizeof(tagWINDOWPLACEMENT);
  GetWindowPlacement(handle,@place ) ;
  pos.X:=place.rcNormalPosition.Left;
  pos.Y := place.rcNormalPosition.Top;
  if pos.X<0 then
    pos.X:=0;
  if pos.Y<0 then
    pos.Y:=0;
  Panel2.Visible:=true;
  autoscroll := False;
  SetWindowPos(handle,HWND_TOPMOST,pos.X,pos.Y,180,53,SWP_SHOWWINDOW);
end;

procedure TFloatWindow.btnExpandClick(Sender: TObject);
var
  place :tagWINDOWPLACEMENT;
begin
  place.length:=sizeof(tagWINDOWPLACEMENT);
  GetWindowPlacement(handle,@place ) ;
  pos.X:=place.rcNormalPosition.Left;
  pos.Y := place.rcNormalPosition.Top;
    if pos.X<0 then
    pos.X:=0;
  if pos.Y<0 then
    pos.Y:=0;
  panel2.Visible:=false;
  AutoScroll := True;
  SetWindowPos(handle,HWND_TOPMOST,pos.X,pos.Y,689,172,SWP_SHOWWINDOW);
end;

procedure TFloatWindow.OpenBitBtnClick(Sender: TObject);
var
  kspath:string;
  dllHandle :THandle;
  delegateOpenAction : ProcOpenAction;
begin
   @delegateOpenAction := GetProcAddress(tabs[tcEQ.TabIndex].ModuleInfo.DllHandle,PROC_OPEN_ACTION);
   delegateOpenAction(Handle,TExamClientGlobal.ExamPath);
end;

procedure TFloatWindow.btnGradeClick(Sender: TObject);
var
  GradeInfoStrings:TStringList;
  delegateGrade : fnFillGrades;
begin
   @delegateGrade := GetProcAddress(tabs[tcEQ.TabIndex].ModuleInfo.DllHandle,FN_FILLGRADES);
   GradeInfoStrings:=TStringList.Create;
   try
      tabs[tcEQ.TabIndex].TQ.StAnswer.Position :=0;
      GradeInfoStrings.LoadFromStream(tabs[tcEQ.TabIndex].TQ.StAnswer);
      delegateGrade(GradeInfoStrings,TExamClientGlobal.ExamPath,tabs[tcEQ.TabIndex].ModuleInfo.DocName,nil,fmExamValue,False);
      TfrmDispAnswer.ShowForm(GradeInfoStrings,tabs[tcEQ.TabIndex].ModuleInfo.DelimiterChar);
   finally
      GradeInfoStrings.Free;
   end;
end;

procedure TFloatWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //CloseAllDoc; //todo
  TExamClientGlobal.ClientMainForm.visible:=true;
  modalresult:=1;
end;

end.
