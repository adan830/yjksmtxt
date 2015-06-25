unit KeyboardType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, tq;

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
    FTQ: TTQ;
    // fLength: integer;
    FTime: integer;
    // used for sourceRich calu disp
    disprow, prevPos: integer;

    procedure SetTextSize;
    procedure SetCaret(RTF: TRichEdit; caretPos: integer);
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
  DataUtils, ExamClientGlobal, Commons, FrameWorkUtils, ExamGlobal;

{$R *.dfm}

{ TFrameKeyType }
procedure TFrameKeyType.SetCaret(RTF: TRichEdit; caretPos: integer);
  var
    i, istopline, iselstart: integer;
    row, col: integer;
  begin
    row := disprow;
    if prevPos < caretPos then
      begin
        col := caretPos - prevPos;
        if col >= length(RTF.Lines[disprow]) then
          begin
            prevPos := prevPos + length(RTF.Lines[disprow]);
            disprow := disprow + 1;
          end;
      end;
    if (row = disprow) then
      exit;
    iselstart := prevPos + length(RTF.Lines[disprow]) + length(RTF.Lines[disprow + 1]);

    // 以设定票房的方式指定游标位置
    sendmessage(RTF.Handle, em_setsel, iselstart, iselstart);
    // 再次侦测游标位置
    // row:=SendMessage(rtf.handle,em_linefromchar,rtf.SelStart,0);
    // col:=rtf.SelStart-SendMessage(rtf.Handle,em_lineindex,row,0);
    // 到游标所在位置
    sendmessage(RTF.Handle, em_scrollcaret, 0, 0);
    // SendMessage(rtf.Handle,EM_SCROLL,)
    sourceRich.Enabled := true;
    sourceRich.SetFocus;
    sourceRich.Enabled := false;
  end;

procedure TFrameKeyType.targetRichChange(Sender: TObject);
  var
    cursorpos: integer;

    procedure SetRichFormat(re: TRichEdit; start, length: integer; color: TColor; style: TFontStyles);
      begin
        re.SelStart            := start;
        re.SelLength           := length;
        re.SelAttributes.color := color;
        re.SelAttributes.style := style;
        // SendMessage(targetRich.Handle,WM_DISPLAYCHANGE,0,0);
        // OutputDebugStringW(PWideChar(re.SelText+inttostr(color)+re.Name ));
      end;

  begin

    sendmessage(targetRich.Handle, WM_IME_ENDCOMPOSITION, 0, 0);

    cursorpos := targetRich.SelStart;
    if fCurrentPos < cursorpos then
      begin
        while fCurrentPos < cursorpos do
          begin
            with targetRich do
              begin
                if (sourceRich.Text[fCurrentPos + 1] = targetRich.Text[fCurrentPos + 1]) then
                  begin
                    SetRichFormat(targetRich, fCurrentPos, 1, clblue, []);
                  end
                else
                  begin
                    SetRichFormat(targetRich, fCurrentPos, 2, clRed, []);
                  end;
                fCurrentPos := fCurrentPos + 1;
              end;
          end;
        sourceRich.SelStart := cursorpos;
        targetRich.SelStart := cursorpos;
        fCurrentPos         := cursorpos;
      end
    else
      begin
        SetRichFormat(sourceRich, 0, length(sourceRich.Text), clRed, []);
      end;
    SetRichFormat(sourceRich, 0, length(targetRich.Text), clwindowtext, [fsUnderline]);
    SetCaret(sourceRich, fCurrentPos);
    targetRich.SetFocus;
  end;

procedure TFrameKeyType.targetRichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin
    if ((ssctrl in Shift) and (Key = 86)) or ((ssshift in Shift) and (Key = 45)) then
      Key := 32;
  end;

procedure TFrameKeyType.targetRichKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  var
    cursorpos: integer;
  begin
    if (Key = VK_BACK) or (Key = VK_DELETE) or (Key = VK_RIGHT) or (Key = VK_LEFT) or (Key = VK_UP) or (Key = VK_DOWN) then
      begin
        cursorpos := targetRich.SelStart;
        if fCurrentPos > cursorpos then
          fCurrentPos := cursorpos;
      end;
  end;

procedure TFrameKeyType.sourceRichKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin
    Key := 32;
  end;

constructor TFrameKeyType.Create(AOwner: TComponent);
  var
    stno, strAnswer, stprefix: string;
  begin
    inherited;
    // Caption := TExamClientGlobal.BaseConfig.ExamName + '--打字测试';
    pnlTitle.Caption := ' 打字测试';
    stprefix         := ExamModuleToStPrefixWildCard(TExamModule.EMTYPE);
    stno             := GetTQIDByPreFix(stprefix, TExamClientGlobal.ConnClientDB);
    FTQ              := TTQ.Create();
    TTQ.ReadTQByIDAndUnCompress(stno, TExamClientGlobal.ConnClientDB, FTQ);
    FTQ.ReadContentToStrings(sourceRich.Lines);
    SetTextSize();
    strAnswer := FTQ.ReadStAnswerStr();
    if strAnswer = '' then
      FTime := TExamClientGlobal.BaseConfig.TypeTime
      // FTime:=9
    else
      FTime := strtoint(strAnswer);

    fFlag       := false;
    fCurrentPos := 0;
    // FTime:=900;
    // timer1.Enabled:=true;
  end;

procedure TFrameKeyType.SetTextSize;
  begin
    sourceRich.SelectAll;
    sourceRich.SelAttributes.Size := 16;
    FTQ.ReadEnvironmentToStrings(targetRich.Lines);
    sourceRich.SelLength := 0;
    targetRich.SelectAll;
    targetRich.SelAttributes.Size := 16;
    targetRich.SelStart           := targetRich.SelLength;
    targetRich.SelLength          := 0;
  end;

procedure TFrameKeyType.ShowFrame;
  var
    stno: string;
    remainTimeStr: string;

  begin

    // remainTimeStr := ftq.ReadStAnswerStr ;
    // if  remainTimeStr ='' then
    // Self.Show;
    // self.timer1.Enabled:=True;
    // else
    if FTime < 3 then
      begin
        application.MessageBox('打字时间已用完，你不能进入！', '提示：', MB_OK);
      end
    else
      begin
        Self.Show;
        Self.timer1.Enabled := true;
      end;

  end;

procedure TFrameKeyType.timer1Timer(Sender: TObject);
  var
    sj: string;
  begin
    FTime := FTime - 1;
    if (FTime > -5) and (FTime < 0) then
      begin
        // ExitBitBtnClick(self);
        Self.HideFrame;
        application.MessageBox('打字时间已用完，系统自动返回主界面！', '提示：', MB_OK);
      end;
    sj              := format('剩余时间:%.2d:%.2d', [FTime div 60, FTime mod 60]);
    lblTime.Caption := sj;
  end;

procedure TFrameKeyType.HideFrame;
  var
    i, wordnum, correctnum: integer;
    stno, stprefix: string;
  begin
    timer1.Enabled := false;
    visible        := false;

    stprefix := ExamModuleToStPrefixWildCard(TExamModule.EMTYPE);
    stno     := GetTQIDByPreFix(stprefix, TExamClientGlobal.ConnClientDB);
    FTQ.WriteStringsToEnvironment(targetRich.Lines);
    FTQ.WriteStrToStAnswer(inttostr(FTime));
    FTQ.CompressTQ();

    WriteTQStAnswerEnvironmentByID(stno, TExamClientGlobal.ConnClientDB, FTQ);
    correctnum := 0;
    for i      := 1 to length(targetRich.Text) do
      begin
        if targetRich.Text[i] = sourceRich.Text[i] then
          begin
            correctnum := correctnum + 1;
          end;
      end;
    wordnum := length(sourceRich.Text);

    wordnum := round((correctnum / wordnum) * 10);
    if wordnum < 0 then
      begin
        wordnum := 0;
      end;
    TExamClientGlobal.Score.WriteString(MODULE_KEYTYPE_NAME, stno + ',1,type,' + inttostr(wordnum) + ',,,-1,');
    // ModalResult:=-1;
    // TExamClientGlobal.ClientMainForm.Visible:=true;
    Self.Hide;

  end;

end.
