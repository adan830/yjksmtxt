unit score;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls,ExamClientGlobal, db,
  ExtCtrls, Buttons, Commons,CustomColorForm, CnButtons;

type
  TScoreForm = class(TCustomColorForm)
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
    btnExit: TCnSpeedButton;
    btnReturn: TCnSpeedButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function SelectScoreView(amode:TFormMode;grpBox:TGroupBox;ScoreInfoStrings:TStrings):integer;
    function OperateScoreValue(ScoreInfoStrings: TStrings;chr:char=','):Single;
    function DzScoreValue(scoreLabel: TLabel;ScoreInfoStrings: TStrings;chr:char=','): integer;
    procedure ShowOperateDetailScore(ABtnTag:integer);
    procedure AddOperateDisplayControl(AItemIndex,AModuleIndex: Integer;ADisName:string;AScoreValue:string);
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
  TotalScore,operateTotalScore:single;
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
    operateTotalScore:=itemScore;
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
                  operateTotalScore:=operateTotalScore+itemscore;
                  itemScoreStr := FloatToStrF(itemScore,ffFixed,4,1)+ '分';
                  AddOperateDisplayControl(j,i,Name,itemScoreStr);
               end;
            end;
         end;
      end;
   end;
   grpOperate.Caption:='操作题得分:'+ FloatToStrF(operateTotalScore,ffFixed,4,1)+ '分';
    lblTotal.Caption := '总得分：'+floattostrf(TotalScore,ffFixed,5,1) +'分';
  finally 
    ScoreInfoStrings.Free;
  end;
end;

procedure TScoreForm.AddOperateDisplayControl(AItemIndex,AModuleIndex:Integer;ADisName:string;AScoreValue:string);
var
   hpos,vpos :Integer;
begin
    hpos := 50+((AItemIndex-1) div 4)*300;
    vpos := 50+(AItemIndex-1)*32;
    with TLabel.Create(self) do
    begin
      parent := grpOperate;
      left :=hpos;
      top :=vpos;
      Alignment := taRightJustify;
      width:=180;
      height:=25;
      font.Height := 14;
      Font.Name:='宋体';
      caption:=ADisName+':';
    end;    // with
    with TLabel.Create(self) do
    begin
      parent := grpOperate;
      left :=hpos+185;
      top :=vpos;
      width:=55;
      height:=25;
      font.Height := 14;
      Font.Name:='宋体';
      Alignment := taCenter;
      caption:=AScoreValue;
    end;    // with
    with TCnSpeedButton.Create(self) do    //TButton.Create(self)
    begin
      parent := grpOperate;
      left :=hpos+185+65;
      top :=vpos-10;
      width:=120;
      height:=25;
      Color:=$00F3A055;
      Font.Color:=clWhite;
      Font.Name:='宋体';
      Font.Height:=14;
      flat:=True;
      FlatBorder:=false;
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
    with TCnSpeedButton.Create(self) do
    begin
      parent := GrpBox;
      left :=hpos+25;
      top :=vpos;
      width:=25;
      height:=25;
      Color:=$00F3A055;
      flat:=True;
      FlatBorder:=false;
      if scoreinfo.IsRight=-1 then
      begin
        Score := score +1;
        glyph:=image1.Picture.Bitmap
      end
      else
      begin
        glyph:=image2.Picture.Bitmap;
      end;
      Layout:=blGlyphRight;
        
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
  strTemp:string;
begin
  ScoreInfoStrings:=TStringList.Create;
  GradeInfoStrings:=TStringList.Create;
  try
      str := TExamClientGlobal.Modules[ABtnTag].Name;
//      ScoreInfoStrings.Text := TExamClientGlobal.Score.ReadString(str,'value','');
      TExamClientGlobal.Score.ReadSection(str,ScoreInfoStrings);
      chr := TExamClientGlobal.Modules[ABtnTag].delimiterChar;
      for i := 0 to ScoreInfoStrings.Count -1 do begin
      strTemp:=string.Copy( ScoreInfoStrings.Strings[i]);
         StrToScoreInfo(strTemp,scoreInfo,chr );
         begin
            str:=inttostr(scoreInfo.GIID)+chr+chr+chr+scoreInfo.EQText+chr+inttostr(scoreInfo.Points)+chr+scoreInfo.exp+chr+scoreInfo.ExamineValue+chr+inttostr(scoreInfo.IsRight)+chr;
            GradeInfoStrings.Add(str );
         end;
      end;
      TfrmDispAnswer.ShowForm(GradeInfoStrings,chr);
  finally // wrap up
    GradeInfoStrings.Free;
    ScoreInfoStrings.Free;
  end;    // try/finally
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
  strTemp:string;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    strTemp:=string.Copy( ScoreInfoStrings.Strings[i-1]);
    StrToScoreInfo(strTemp,scoreinfo,chr);
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
   strTemp:string;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
   strTemp:=string.Copy( ScoreInfoStrings.Strings[i-1]);
    StrToScoreInfo(strtemp,scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  scoreLabel.caption := inttostr(score)+ '分';
  result := Score;
end;

end.
