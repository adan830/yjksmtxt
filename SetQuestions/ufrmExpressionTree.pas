unit ufrmExpressionTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinsDefaultPainters, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxLabel, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue;

type
  TfrmExpressionTree = class(TForm)
    mmSourceStr: TcxMemo;
    lblSourceStr: TcxLabel;
    mmTargetStr: TcxMemo;
    lblTargetStr: TcxLabel;
    btnCreateTree: TcxButton;
    btnDecrypt: TcxButton;
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure btnCreateTreeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Commons, LogicalExprEval,types;

{$R *.dfm}

procedure TfrmExpressionTree.btnCreateTreeClick(Sender: TObject);
var
   exp:TLogicalExprEval;
   linetext:string;
   value:boolean;
   sl:TStringList;
  I: Integer;
  errormsg:string;
begin
   exp :=tlogicalexpreval.Create('');
   sl := TStringList.Create;
   try
      //exp.ClearExpressions();
      //for linetext in mmSourceStr.Lines do
      //   exp.AddExpression(linetext);
      Exp.exprstring :=  mmSourceStr.Lines.Text ;
      Exp.constvalue:=TIntegerDynArray.Create(1,0,1);

      //Exp.Evaluate();
      //if Exp.evaluatesuccess then  value := exp.exprvalue;


      //linetext :=BoolToStr(value);
      //mmTargetStr.Lines.Add(linetext);

      if not exp.ValidateExpr(errormsg) then
         mmTargetStr.Lines.Add(errormsg);
      for I := 0 to Exp.ConstCount - 1 do
         mmTargetStr.Lines.Add(exp.ConstName[i]);
      //value:=exp.ResultValue;
      //mmTargetStr.Lines.Assign(sl);//Format('%d', [value]);
      //mmzx.Lines.Text := Format('%*.*f', [value]);
      //mmTargetStr.Lines.Text:=exp.Evaluate(mmSourceStr.Lines.Text) ;
   finally
      exp.Free;
   end;
end;

procedure TfrmExpressionTree.btnDecryptClick(Sender: TObject);
begin
  mmTargetStr.Lines.Text :=DecryptStr(mmSourceStr.Lines.Text);
end;

procedure TfrmExpressionTree.btnEncryptClick(Sender: TObject);
begin
  mmTargetStr.Lines.Text :=EncryptStr(mmSourceStr.Lines.Text);
end;

end.
