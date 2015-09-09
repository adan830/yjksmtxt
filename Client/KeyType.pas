unit KeyType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, DataFieldConst, tq,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, cxSplitter;

type
  TTypeForm = class(TForm)
    SourceRich: TRichEdit;
    targetRich: TRichEdit;
    ExitBitBtn: TBitBtn;
    Timer1: TTimer;
    Label1: TLabel;
    Label3: TLabel;
    pnlTitle: TPanel;
    lblTime: TLabel;
    cxspltr1: TcxSplitter;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    pnl6: TPanel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ExitBitBtnClick(Sender: TObject);
    procedure targetRichKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure targetRichKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SourceRichKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure targetRichChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fFlag: boolean;
    fCurrentPos: integer;
    FTQ : TTQ;
//    fLength: integer;
    FTime:integer;
    procedure SetTextSize;
   // procedure SetRichFormat(re: TRichEdit; start, length: integer;color: TColor; style: TFontStyles);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
     fSource: string;
     fTarget: string;
     class procedure TypeFormShow(Sender : TComponent); static;
  end;

var
  TypeForm: TTypeForm;

implementation

uses    ExamClientGlobal, ExamGlobal, DataUtils, ClientMain;

{$R *.dfm}

procedure TTypeForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
   with Params do
  begin
    Style :=ws_overlapped;
    params.ExStyle:=params.exstyle or ws_ex_topmost;
    //WndParent:=mainform.Handle;
    WndParent :=GetDesktopWindow;//0;   //     //父窗体为桌面
  end;
end;

procedure TTypeForm.ExitBitBtnClick(Sender: TObject);
var
  i,wordnum,correctnum:integer;
  stno : string;
begin
  timer1.Enabled:=false;
  visible:=false;

  stno:=GetTQIDByPreFix('C%',TExamClientGlobal.ConnClientDB);
  FTQ.WriteStringsToEnvironment(TargetRich.Lines);
  FTQ.WriteStrToStAnswer(inttostr(FTime));
  FTQ.CompressTQ();

   //WriteTQStAnswerEnvironmentByID(stno,TExamClientGlobal.ConnClientDB,FTQ);
   correctnum:=0;
   for i :=1  to length(TargetRich.Text)  do
   begin
     if TargetRich.Text[i]=SourceRich.Text[i] then
     begin
       correctnum:=correctnum+1;
     end;
   end;
   wordnum:=length(sourcerich.Text);
   
   wordnum:=round((correctnum/wordnum)*10);
   if wordnum<0 then
   begin
      wordnum:=0;
   end;
   TExamClientGlobal.Score.WriteString(MODULE_KEYTYPE_NAME,stno+',1,type,'+inttostr(wordnum)+',,,-1,');
   ModalResult:=-1;
   TExamClientGlobal.ClientMainForm.Visible:=true;
end;

procedure TTypeForm.targetRichKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cursorpos:Integer;
begin
  if (key=VK_BACK)or(key=VK_DELETE)or(key=VK_RIGHT)or(key=VK_LEFT)or(key=VK_UP )or(key=VK_DOWN) then
  begin
    cursorpos:=targetRich.SelStart;
    if fCurrentPos>cursorpos then
      fCurrentPos:=cursorpos;
  end;
//  cursorpos:=targetRich.SelStart;
//  while fCurrentPos<cursorpos do
//  begin
//    with targetRich do
//    if (targetRich.Text[fCurrentPos+1]>=char($a0)) then
//    begin
//      if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) and (SourceRich.Text[fCurrentPos+2]=targetRich.Text[fCurrentPos+2]) then
//      begin
//           SelStart:=fCurrentPos;
//           SelLength:=2;
//           SelAttributes.Color:=clBlue;
//      end
//      else
//      begin
//           SelStart:=fCurrentPos;
//           SelLength:=2;
//           SelAttributes.Color:=clRed;
//      end;
//      fCurrentPos:=fCurrentPos+2;
//    end
//    else
//    begin
//      if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) then
//      begin
//         SelStart:=fCurrentPos;
//         SelLength:=1;
//         SelAttributes.Color:=clBlue;
//      end
//      else
//      begin
//         SelStart:=fCurrentPos;
//         SelLength:=1;
//         SelAttributes.Color:=clRed;
//      end;
//      fCurrentPos:=fCurrentPos+1;
//    end;
//
//  end;
//  targetRich.SelStart:=cursorpos;
//  fCurrentpos:=targetRich.SelStart;  
end;

procedure TTypeForm.FormShow(Sender: TObject);
var
  stno,strAnswer:string;
begin
  Caption := TExamClientGlobal.BaseConfig.ExamName + '--打字测试';
  pnlTitle.Caption := ' 打字测试';
  stno:=GetTQIDByPreFix('C%',TExamClientGlobal.ConnClientDB);
  Ftq := TTq.Create();
  TTQ.ReadTQByIDAndUnCompress(stno,TExamClientGlobal.ConnClientDB,ftq);
  FTQ.ReadContentToStrings(SourceRich.Lines);
  SetTextSize();
  strAnswer := FTQ.ReadStAnswerStr();
  if strAnswer ='' then
      FTime:=TExamClientGlobal.BaseConfig.TypeTime
  else
      FTime:=strtoint(strAnswer);

  fFlag:=false;
  fCurrentPos:=0;
 // FTime:=900;
  timer1.Enabled:=true;
end;

procedure TTypeForm.SetTextSize();
begin
  SourceRich.SelectAll;
  SourceRich.SelAttributes.Size := 16;
  FTQ.ReadEnvironmentToStrings(TargetRich.Lines);
  SourceRich.SelLength :=0;
  targetRich.SelectAll;
  targetRich.SelAttributes.Size := 16;
  targetRich.SelStart := targetRich.SelLength;
  targetRich.SelLength :=0;
end;

procedure TTypeForm.Timer1Timer(Sender: TObject);
var
  sj:string;
begin
  FTime:=FTime-1;
  if (FTime>-5) and (Ftime<0) then
  begin
    ExitBitBtnClick(self);
    application.MessageBox('打字时间已用完，系统自动返回主界面！','提示：',MB_OK);
  end;
  sj:=format('剩余时间:%.2d:%.2d',[FTime div 60,FTime mod 60]);
  lblTime.Caption := sj;
end;

procedure TTypeForm.targetRichChange(Sender: TObject);
var
  cursorpos:Integer;

  procedure SetRichFormat(re:TRichEdit;start,length:integer;color:TColor;style:TFontStyles);
  begin
      re.SelStart:=start;
      re.SelLength:=length;
      re.SelAttributes.Color:=color;
      re.SelAttributes.Style:=style;
//      SendMessage(targetRich.Handle,WM_DISPLAYCHANGE,0,0);
      //OutputDebugStringW(PWideChar(re.SelText+inttostr(color)+re.Name ));
  end;
begin
   SendMessage(targetrich.Handle,WM_IME_ENDCOMPOSITION,0,0) ;

   cursorpos:=targetRich.SelStart;
   if fCurrentPos<cursorpos then
   begin
      while fCurrentPos<cursorpos do
      begin
      with targetRich do  begin
        if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) then
        begin
           SetRichFormat(targetRich,fcurrentpos,1,clblue,[]);
        end
        else
        begin
           SetRichFormat(targetRich,fcurrentpos,2,clRed,[]);
        end;
        fCurrentPos:=fCurrentPos+1;
      end;
//      if (targetRich.Text[fCurrentPos+1]>=char($a0)) then
//      begin
//        if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) and (SourceRich.Text[fCurrentPos+2]=targetRich.Text[fCurrentPos+2]) then
//        begin
//           SetRichFormat(targetRich,fcurrentpos,2,clblue,[]);
//        end
//        else
//        begin
//             SetRichFormat(targetRich,fcurrentpos,2,clred,[]);
//        end;
//        fCurrentPos:=fCurrentPos+2;
//      end
//      else
//      begin
//        if (SourceRich.Text[fCurrentPos+1]=targetRich.Text[fCurrentPos+1]) then
//        begin
//           SetRichFormat(targetRich,fcurrentpos,1,clblue,[]);
//        end
//        else
//        begin
//           SetRichFormat(targetRich,fcurrentpos,2,clRed,[]);
//        end;
//        fCurrentPos:=fCurrentPos+1;
//      end;

      end;
      SourceRich.SelStart:=cursorpos;
      targetRich.SelStart:=cursorpos;
      fCurrentpos:=cursorpos;
   end
   else
   begin
      SetRichFormat(sourcerich,0,length(sourcerich.text),clwindowtext,[]);
   end;
   SetRichFormat(sourcerich,0,length(targetrich.text),clwindowtext,[fsUnderline]);
end;

procedure TTypeForm.targetRichKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if ((ssctrl in shift) and (key=86 ))or((ssshift in shift) and (key=45 )) then
    key:=32;
end;

procedure TTypeForm.SourceRichKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//if ((ssctrl in shift) and ((key=86 )or (key=88)))or((ssshift in shift) and (key=45 )) or (key=vk_delete) or(key=vk_back) then
    key:=32;
    
end;

procedure TTypeForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult=-1 then
    canclose := True
  else
    canclose :=false;
end;

procedure TTypeForm.FormDestroy(Sender: TObject);
begin
  FTQ.Free;
end;

procedure TTypeForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fFlag:=false;
  fCurrentPos:=0;
end;

//procedure TTypeForm.SetRichFormat(re:TRichEdit;start,length:integer;color:TColor;style:TFontStyles);
//begin
//    re.SelStart:=start;
//    re.SelLength:=length;
//    re.SelAttributes.Color:=color;
//    re.SelAttributes.Style:=style;
//end;

class procedure TTypeForm.TypeFormShow(Sender : TComponent);
var
  stno:string;
  tq : TTQ;
  remainTimeStr:string;
  procedure dispForm();
  var
    frm :TTypeForm;
  begin
    frm := TTypeForm.Create(Application);
    try
      frm.ShowModal;
    finally
      frm.Free;
    end;
  end;
begin
  stno := GetTQIDByPreFix('C%',TExamClientGlobal.ConnClientDB);
  tq := TTQ.Create;
  try
    TTQ.ReadTQByIDAndUnCompress(stno,TExamClientGlobal.ConnClientDB,tq);
    remainTimeStr := tq.ReadStAnswerStr ;
    if  remainTimeStr ='' then
      dispForm
    else
      if  strtoint(remainTimeStr)<5 then
      begin
        (sender as TForm).visible := True ;
       application.MessageBox('打字时间已用完，你不能进入！','提示：',MB_OK);
      end  else
        dispForm;
  finally
    tq.Free;
  end;
end;

end.
