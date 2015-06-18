unit uDispAnswer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs, vcl.ExtCtrls, vcl.StdCtrls, vcl.Buttons, vcl.Grids, ExamGlobal,Types;

type
  TfrmDispAnswer = class(TForm)
    memoComment: TMemo;
    Panel1: TPanel;
    lblCaption: TLabel;
    lblAnswer: TLabel;
    Panel2: TPanel;
    grdAnswer: TStringGrid;
    btnClose: TButton;
    imgOk: TImage;
    imgError: TImage;
    procedure btnExitClick(Sender: TObject);
    procedure grdAnswerDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowForm(node:PTQTreeNode);overload;
    class procedure ShowForm(node: TTQNode); overload;
    class procedure ShowForm(strings:TStrings;chr:char=',');overload;

  end;

implementation
uses uGrade,Commons, LogicalExprEval;

{$R *.dfm}

{ TfrmDispAnswer }
{$REGION '老版，未使用泛型'}
class procedure TfrmDispAnswer.ShowForm(node: PTQTreeNode);
var
  frmDispAnswer:TfrmDispAnswer;
  str,tempStr:string;
  i:integer;
  pc :pchar;
begin
  frmDispAnswer:=TfrmDispAnswer.Create(nil);
  try
    with frmDispAnswer do
    begin
      frmDispAnswer.memoComment.Visible:=true;
      frmDispAnswer.grdAnswer.Visible:=false;
      if node^.TQ.St_no<>'' then
        tempStr := node^.TQ.ReadStAnswerStr ;
        pc:=pchar(tempStr);
        for I := 0 to length(tempStr)-1  do    // Iterate
        begin
          str:=str+ chr(ord(pc[i])+16);
        end;    // for
        lblAnswer.Caption:=str;
        node^.TQ.ReadCommentToStrings(memoComment.Lines);
    end;    // with
    frmDispAnswer.ShowModal;
  finally // wrap up
    frmDispAnswer.free;
  end;    // try/finally
end;
{$ENDREGION}

{$REGION '新版，使用泛型'}
class procedure TfrmDispAnswer.ShowForm(node: TTQNode);
var
  frmDispAnswer:TfrmDispAnswer;
  str,tempStr:string;
  i:integer;
  pc :pchar;
begin
  frmDispAnswer:=TfrmDispAnswer.Create(nil);
  try
    with frmDispAnswer do
    begin
      frmDispAnswer.memoComment.Visible:=true;
      frmDispAnswer.grdAnswer.Visible:=false;
      if node.TQ.St_no<>'' then
        tempStr := node.TQ.ReadStAnswerStr ;
        pc:=pchar(tempStr);
        for I := 0 to length(tempStr)-1  do    // Iterate
        begin
          str:=str+ chr(ord(pc[i])+16);
        end;    // for
        lblAnswer.Caption:=str;
        node.TQ.ReadCommentToStrings(memoComment.Lines);
    end;    // with
    frmDispAnswer.ShowModal;
  finally // wrap up
    frmDispAnswer.free;
  end;    // try/finally
end;
{$ENDREGION}

procedure TfrmDispAnswer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  with Params do
  begin
    Style :=ws_overlapped;
    params.ExStyle:=ws_ex_topmost;
    WndParent :=0;   // mainform.Handle;    //父窗体为form1
  end;
end;

class procedure TfrmDispAnswer.ShowForm(strings:TStrings; chr: char =',');
var
  frmDispAnswer:TfrmDispAnswer;
  gradeInfos: array of TGradeInfo;
  i,j:Integer;
  str:string;
  points:Integer;
  expEva : TLogicalExprEval;
  index :Integer;

  procedure fillgrid(index:Integer;isRight:integer;gradeinfo:TGradeInfo);
  begin
    with frmDispAnswer.grdAnswer do begin
        Cells[0,index+1]:=inttostr(index+1)+'、';
        cells[1,index+1]:=gradeInfo.EQText;
        if IsRight=-1 then
        begin
          cells[2,index+1]:='正确';
          cells[3,index+1]:='+'+FloatToStrF(gradeInfo.Points/10,ffFixed,4,1)+'分';
          points:=points+gradeInfo.Points;
        end
        else
        begin
          cells[2,index+1]:='错';
          cells[3,index+1]:='';
        end;
    end; 
  end;
begin
  frmDispAnswer:=TfrmDispAnswer.Create(nil);
  try
    points:=0;
    frmDispAnswer.memoComment.Visible:=false;
    frmDispAnswer.grdAnswer.Visible:=true;

    with frmDispAnswer.grdAnswer do
    begin
      RowCount:=strings.Count +1;
      ColCount:=4;

      SetLength(gradeInfos,strings.Count);
      for I := 0 to strings.Count - 1 do    // Iterate
      begin
        StrToGradeInfo(strings[i],gradeInfos[i],chr);
      end;
      i := 0; index :=0;
      while i<strings.Count do
      begin
        if (gradeInfos[i].Exp) <> '' then begin
            expEva := TLogicalExprEval.Create(gradeinfos[i].Exp);
            with expEva do begin
              try
                for j := 0  to ConstCount -1 do begin
                  if gradeInfos[i+j].IsRight=-1 then ConstValue[j] := 1 else ConstValue[j] :=0;
                end;
                expEva.Evaluate();
                if expEva.EvaluateSuccess then
                  if expEva.ExprValue  then
                    fillgrid(index,-1,Gradeinfos[i])
                  else
                    fillgrid(index,1,Gradeinfos[i])
                else
                  raise Exception.Create('Evaluate express error');
              finally
                 i := i + constcount;
                 expEva.Free;
              end;
            end;
        end else begin
          fillgrid(index,Gradeinfos[i].IsRight,Gradeinfos[i]);
          Inc(i);
        end;
        Inc(index);
      end;
    end;   // with
    frmDispAnswer.lblCaption.Caption:='本题得分：';
    frmDispAnswer.lblAnswer.Caption:=FloatToStrF(Points/10,ffFixed,4,1)+'分';
    frmDispAnswer.ShowModal;
  finally // wrap up
    frmDispAnswer.free;
  end;    // try/finally
end;

procedure TfrmDispAnswer.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDispAnswer.grdAnswerDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  textSize:TSize;
  text :string;
begin
  if ARow=0 then
  begin
    grdAnswer.Canvas.FillRect(rect);
    case ACol of
      0: text := '编号';
      1: text := '试题内容';
      2: text := '结果';
      3: text := '得分';
    end;
    textSize:=grdAnswer.Canvas.TextExtent(text);
    Rect.Left:=Rect.Left+(Rect.Right-Rect.Left-textSize.cx) div 2;
    Rect.Top := rect.Top+(Rect.Bottom-rect.Top-textSize.cy) div 2 ;
    grdAnswer.Canvas.TextOut(rect.Left,rect.Top,text);
  end;
    
  if acol=2 then
  begin
    if aRow>0 then
    begin
      grdAnswer.Canvas.FillRect(rect);
      rect.Left:=rect.Left+(rect.Right-rect.Left) div 2 -8;
      rect.Top:=rect.Top+(rect.Bottom-rect.top) div 2 -9;
      if grdAnswer.Cells[acol,arow]='错' then
      begin
        grdAnswer.Canvas.Draw(rect.Left,rect.Top,imgError.Picture.Graphic);
      end;       
      if grdAnswer.Cells[acol,arow]='正确' then
      begin
        grdAnswer.Canvas.Draw(rect.Left,rect.Top,imgOk.Picture.Graphic);
      end;
    end;
  end;
end;

end.
