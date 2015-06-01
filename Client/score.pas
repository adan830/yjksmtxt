unit score;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls,ExamClientGlobal, db,
  ExtCtrls, Buttons, Commons;

type
  TScoreForm = class(TForm)
    btnReturn: TButton;
    btnExit: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlMain: TPanel;
    Label18: TLabel;
    Image1: TImage;
    Image2: TImage;
    gbSingle: TGroupBox;
    gbMulti: TGroupBox;
    lblTypeName: TLabel;
    lblType: TLabel;
    lblTotal: TLabel;
    grpOperate: TGroupBox;
    procedure btnReturnClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnWinClick(Sender: TObject);
    procedure btnWordClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure btnPptClick(Sender: TObject);
  private
    function SelectScoreView(amode:TFormMode;grpBox:TGroupBox;ScoreInfoStrings:TStrings):integer;
    function OperateScoreValue(ScoreInfoStrings: TStrings;chr:char=','):Single;
    function DzScoreValue(scoreLabel: TLabel;ScoreInfoStrings: TStrings;chr:char=','): integer;
    procedure ShowOperateDetailScore(ABtnTag:integer);
    procedure AddOperateDisplayControl(AItemIndex,AModuleIndex: Integer;ADisName:string;AScoreValue:string);
    function OperateScoreView1(amode: TFormMode; grpBox: TGroupBox; ScoreInfoStrings: TStrings): Integer;
    procedure btnDetailScoreClick(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  ScoreForm: TScoreForm;

implementation
uses adodb, uGrade, ExamGlobal, uDispAnswer, DataFieldConst;

{$R *.dfm}

procedure TScoreForm.btnReturnClick(Sender: TObject);
begin
  modalresult:=1;
  TExamClientGlobal.ClientMainForm.Visible:=true;
end;

procedure TScoreForm.btnExitClick(Sender: TObject);
begin
//  deletedir;

  modalresult:=-1;
  //MainForm.Close;
end;

procedure TScoreForm.FormShow(Sender: TObject);
var
  ScoreInfoStrings:TStringList;
  TotalScore:single;
  i,j:Integer;
  itemScore:Single;
  itemScoreStr: string;
begin
  ScoreInfoStrings := TStringList.Create;
  try
    TExamClientGlobal.Score.ReadSection(MODULE_SINGLE_NAME,ScoreInfoStrings);
    TotalScore := TotalScore+SelectScoreView(SINGLESELECT_MODEL,gbsingle,ScoreInfoStrings);
    TExamClientGlobal.Score.ReadSection(MODULE_MULTIPLE_NAME,ScoreInfoStrings);
    TotalScore := TotalScore+SelectScoreView(MULTISELECT_MODEL,gbMulti,ScoreInfoStrings);
    TExamClientGlobal.Score.ReadSection(MODULE_KEYTYPE_NAME,ScoreInfoStrings);
    itemScore := OperateScoreValue(ScoreInfoStrings,',');
    TotalScore := TotalScore+ itemScore;
    lblType.Caption := FloatToStrF(itemScore,ffFixed,4,1)+ '分';

    j:=0;
    for I := 0 to length(TExamClientGlobal.Modules) - 1 do begin
      with TExamClientGlobal.Modules[i] do
      begin
         if Classify =TEST_QUESTION_CLASSIFY_OPERATION then begin
            if dllHandle<>null then begin
               TExamClientGlobal.Score.ReadSection(name,ScoreInfoStrings);
               if ScoreInfoStrings.Text<>NULL_STR then begin
                  j:=j+1;
                  itemScore := OperateScoreValue(ScoreInfoStrings,DelimiterChar);
                  TotalScore := TotalScore+ itemScore;
                  itemScoreStr := FloatToStrF(itemScore,ffFixed,4,1)+ '分';
                  AddOperateDisplayControl(j,i,Name,itemScoreStr);
               end;
            end;
         end;
      end;
   end;
    lblTotal.Caption := '总得分：'+floattostrf(TotalScore,ffFixed,5,1) +'分';
  finally 
    ScoreInfoStrings.Free;
  end;
end;

procedure TScoreForm.AddOperateDisplayControl(AItemIndex,AModuleIndex:Integer;ADisName:string;AScoreValue:string);
var
   hpos,vpos :Integer;
begin
    hpos := 20+((AItemIndex-1) div 4)*300;
    vpos := 28+(AItemIndex-1)*32;
    with TLabel.Create(self) do
    begin
      parent := grpOperate;
      left :=hpos;
      top :=vpos;
      Alignment := taRightJustify;
      width:=180;
      height:=25;
      font.Size := 12;
      caption:=ADisName;
    end;    // with
    with TLabel.Create(self) do
    begin
      parent := grpOperate;
      left :=hpos+185;
      top :=vpos;
      width:=55;
      height:=25;
      font.Size := 12;
      Alignment := taCenter;
      caption:=AScoreValue;
    end;    // with
    with TButton.Create(self) do
    begin
      parent := grpOperate;
      left :=hpos+185+65;
      top :=vpos;
      width:=65;
      height:=25;
      Tag  := AModuleIndex;
      Caption := '查看详细';
      OnClick := btnDetailScoreClick;
    end;    // with
end;

function TScoreForm.SelectScoreView(amode:TFormMode;grpBox:TGroupBox;ScoreInfoStrings: TStrings):Integer;
var
  I: Integer;
  Score : Integer;
  hpos,vpos:Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo);
    hpos := 20+((i-1) mod 10)*65;
    vpos := 28+((i-1) div 10)*32;
    with TLabel.Create(self) do
    begin
      parent := GrpBox;
      left :=hpos;
      top :=vpos;
      width:=25;
      height:=25;
      font.Size := 12;
      caption:=inttostr(i)+'.';
    end;    // with
    with TSpeedButton.Create(self) do
    begin
      parent := GrpBox;
      left :=hpos+25;
      top :=vpos;
      width:=25;
      height:=25;
      if scoreinfo.IsRight=-1 then
      begin
        Score := score +1;
        glyph:=image1.Picture.Bitmap
      end
      else
      begin
        glyph:=image2.Picture.Bitmap;
      end;
        
    end;    // with
  end;    // for
  case aMode  of    //
    SINGLESELECT_MODEL:begin
      grpBox.Caption := ' 单项选择题得分：'+inttostr(score )+'分 ';
    end;
    MULTISELECT_MODEL:begin
      score := score*2;
      grpBox.Caption := ' 多项选择题得分：'+inttostr(score )+'分 ';
    end;       
  end;    // case
  result := Score ;

end;
function TScoreForm.OperateScoreView1(amode:TFormMode;grpBox:TGroupBox;ScoreInfoStrings: TStrings):Integer;
var
  I: Integer;
  Score : Integer;
  hpos,vpos:Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo);
    hpos := 20+((i-1) mod 10)*65;
    vpos := 28+((i-1) div 10)*32;
    with TLabel.Create(self) do
    begin
      parent := GrpBox;
      left :=hpos;
      top :=vpos;
      width:=25;
      height:=25;
      font.Size := 12;
      caption:=inttostr(i)+'.';
    end;    // with
    with TSpeedButton.Create(self) do
    begin
      parent := GrpBox;
      left :=hpos+25;
      top :=vpos;
      width:=25;
      height:=25;
      if scoreinfo.IsRight=-1 then
      begin
        Score := score +1;
        glyph:=image1.Picture.Bitmap
      end
      else
      begin
        glyph:=image2.Picture.Bitmap;
      end;
        
    end;    // with
  end;    // for
  case aMode  of    //
    SINGLESELECT_MODEL:begin
      grpBox.Caption := ' 单项选择题得分：'+inttostr(score )+'分 ';
    end;
    MULTISELECT_MODEL:begin
      score := score*2;
      grpBox.Caption := ' 多项选择题得分：'+inttostr(score )+'分 ';
    end;       
  end;    // case
  result := Score ;

end;
procedure TScoreForm.ShowOperateDetailScore(ABtnTag:integer);
var
  GradeInfoStrings,ScoreInfoStrings:TStringList;
  scoreInfo :TScoreInfo;
  i:integer;
  str:string;
  chr:Char;
begin
  ScoreInfoStrings:=TStringList.Create;
  GradeInfoStrings:=TStringList.Create;
  try
      str := TExamClientGlobal.Modules[ABtnTag].Name;
      ScoreInfoStrings.Text := TExamClientGlobal.Score.ReadString(str,'value','');
      chr := TExamClientGlobal.Modules[ABtnTag].delimiterChar;
      for i := 0 to ScoreInfoStrings.Count -1 do begin
         StrToScoreInfo(ScoreInfoStrings.Strings[i],scoreInfo,chr );
         begin
            str:=inttostr(scoreInfo.GIID)+chr+chr+chr+scoreInfo.EQText+chr+inttostr(scoreInfo.Points)+chr+scoreInfo.ExamineValue+chr+inttostr(scoreInfo.IsRight)+chr;
            GradeInfoStrings.Add(str );
         end;
      end;
      TfrmDispAnswer.ShowForm(GradeInfoStrings,chr);
  finally // wrap up
    GradeInfoStrings.Free;
    ScoreInfoStrings.Free;
  end;    // try/finally
end;

procedure TScoreForm.btnWinClick(Sender: TObject);
begin
  //ShowOperateScore(WINDOWS_MODEL);
end;
procedure TScoreForm.btnWordClick(Sender: TObject);
begin
  //ShowOperateScore(WORD_MODEL);
end;

procedure TScoreForm.btnExcelClick(Sender: TObject);
begin
  //ShowOperateScore(EXCEL_MODEL);
end;

procedure TScoreForm.btnPptClick(Sender: TObject);
begin
  //ShowOperateScore(POWERPOINT_MODEL);
end;

procedure TScoreForm.btnDetailScoreClick(Sender: TObject);
begin
  ShowOperateDetailScore( TButton(sender).tag);
end;

function TScoreForm.OperateScoreValue(ScoreInfoStrings: TStrings;chr:char=','): Single;
var
  I: Integer;
  Score : single;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  score:= score/10;
  result := Score;
end;

function TScoreForm.DzScoreValue(scoreLabel: TLabel;ScoreInfoStrings: TStrings;chr:char=','): integer;
var
  I: Integer;
  Score : Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  scoreLabel.caption := inttostr(score)+ '分';
  result := Score;
end;

end.
