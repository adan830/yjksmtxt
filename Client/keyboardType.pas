unit KeyboardType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,tq;

type
  TFrameKeyType = class(TFrame)
    pnlTitle: TPanel;
    lblTime: TLabel;
    pnl1: TPanel;
    pnl3: TPanel;
    sourceRich: TRichEdit;
    pnl5: TPanel;
    lbl1: TLabel;
    pnl4: TPanel;
    targetRich: TRichEdit;
    pnl6: TPanel;
    lbl2: TLabel;
    pnl2: TPanel;
    timer1: TTimer;
    spl1: TSplitter;
    procedure sourceRichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure targetRichChange(Sender: TObject);
    procedure targetRichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure targetRichKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure timer1Timer(Sender: TObject);
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
  public
     fSource: string;
     fTarget: string;
     constructor Create(AOwner: TComponent); override;
     procedure HideFrame;
     procedure ShowFrame;
  end;

implementation

uses
  DataUtils,ExamClientGlobal,Commons,FrameWorkUtils,ExamGlobal;

{$R *.dfm}

{ TFrameKeyType }



procedure TFrameKeyType.targetRichChange(Sender: TObject);
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

procedure TFrameKeyType.targetRichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if ((ssctrl in shift) and (key=86 ))or((ssshift in shift) and (key=45 )) then
    key:=32;
end;

procedure TFrameKeyType.targetRichKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrameKeyType.sourceRichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  key:=32;
end;

constructor TFrameKeyType.Create(AOwner: TComponent);
var
  stno,strAnswer,stprefix:string;
begin
  inherited;
//  Caption := TExamClientGlobal.BaseConfig.ExamName + '--打字测试';
  pnlTitle.Caption := ' 打字测试';
  stPrefix:=ExamModuleToStPrefixWildCard(TExamModule.EMTYPE);
  stno:=GetTQIDByPreFix(stPrefix,TExamClientGlobal.ConnClientDB);
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
  //timer1.Enabled:=true;
end;

procedure TFrameKeyType.SetTextSize;
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

procedure TFrameKeyType.ShowFrame;
var
  stno:string;
  remainTimeStr:string;

begin

  //  remainTimeStr := ftq.ReadStAnswerStr ;
//    if  remainTimeStr ='' then
//      Self.Show;
//      self.timer1.Enabled:=True;
//    else
      if  FTime<5 then
      begin
        application.MessageBox('打字时间已用完，你不能进入！','提示：',MB_OK);
      end  else
      begin
        Self.Show;
        self.timer1.Enabled:=True;
      end;

end;

procedure TFrameKeyType.timer1Timer(Sender: TObject);
var
  sj:string;
begin
  FTime:=FTime-1;
  if (FTime>-5) and (Ftime<0) then
  begin
    //ExitBitBtnClick(self);
    application.MessageBox('打字时间已用完，系统自动返回主界面！','提示：',MB_OK);
  end;
  sj:=format('剩余时间:%.2d:%.2d',[FTime div 60,FTime mod 60]);
  lblTime.Caption := sj;
end;

procedure TFrameKeyType.HideFrame;
var
  i,wordnum,correctnum:integer;
  stno ,stprefix: string;
begin
  timer1.Enabled:=false;
  visible:=false;

  stPrefix:=ExamModuleToStPrefixWildCard(TExamModule.EMTYPE);
  stno:=GetTQIDByPreFix(stPrefix,TExamClientGlobal.ConnClientDB);
  FTQ.WriteStringsToEnvironment(TargetRich.Lines);
  FTQ.WriteStrToStAnswer(inttostr(FTime));
  FTQ.CompressTQ();

   WriteTQStAnswerEnvironmentByID(stno,TExamClientGlobal.ConnClientDB,FTQ);
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
   //ModalResult:=-1;
   //TExamClientGlobal.ClientMainForm.Visible:=true;
   Self.Hide;

end;

end.
