unit ufrmType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBase, DB, ADODB, cxEdit, cxEditRepositoryItems,
  dxDockControl, ufraTree, dxDockPanel, StdCtrls, cxButtons, ExtCtrls,
  cxLabel, cxTextEdit, cxControls, cxContainer, cxMemo, Menus,
  cxLookAndFeelPainters, cxClasses, cxStyles, cxGridTableView, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, cxGroupBox, cxCheckGroup, 
  Commons, Role, cxGraphics, cxLookAndFeels, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, JvExStdCtrls, JvRichEdit;

type
  TfrmType = class(TfrmBase)
    cxGroupBox2: TcxGroupBox;
    edtEQContent: TJvRichEdit;
    lbl1: TcxLabel;
    edtTotalNum: TcxTextEdit;
    btnTotal: TcxButton;
    procedure btnTotalClick(Sender: TObject);
  private
    function TotalWordsNum: string;
  protected
    procedure SetControlState(aAction: TFormAction); override;
    procedure doBrowse(RecID: String); override;
    procedure doSave(RecID: String); override;
    { Private declarations }
  public
    { Public declarations }
    class procedure FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);
  end;

var
  frmType: TfrmType;

implementation

uses uDmSetQuestion, SetQuestionGlobal;

{$R *.dfm}

{ TfrmType }
procedure TfrmType.btnTotalClick(Sender: TObject);
begin
  inherited;
  edtTotalNum.Text := TotalWordsNum();
end;

procedure TfrmType.doBrowse(RecID: String);
begin
    inherited;
    edtEQContent.Lines.LoadFromStream(FCurrentTQRecord.Content);
    edtTotalNum.Text := TotalWordsNum();
end;

function TfrmType.TotalWordsNum():string;
var
   strText:string;
   wordCount:Integer;
   i:Integer;
   mbcsByteType:TMbcsByteType ;
begin
  inherited;
  strText:= edtEQContent.Text;
  wordCount := 0;
  for I := 1 to Length(strText)  do begin
     mbcsByteType:=ByteType(strText,i) ;
     if  mbcsByteType = mbSingleByte then Inc(wordCount);
     if  mbcsByteType = mbLeadByte then  Inc(wordCount);
  end;
  Result := IntToStr(wordCount);
end;

procedure TfrmType.doSave(RecID: String);
begin
   case  CurrentFormAction  of
      faModify,faAppend:begin
         FCurrentTQRecord.Content.Clear;
         edtEQContent.Lines.SaveToStream(FCurrentTQRecord.Content);
      end;
   end;
   inherited;
end;

class procedure TfrmType.FormShowMode(const AModuleFileName:TFileName;aMode: TFormMode);
var
  frmType:TfrmType;
begin
  frmType:=TfrmType.Create(AModuleFileName,aMode);
  try
     frmType.ShowModal;
  finally // wrap up
    frmType.Free;
  end;    // try/finally
end;

procedure TfrmType.SetControlState(aAction: TFormAction);
begin
  inherited;
  case aAction of    //
    faBrowse,
    faSave,
    faCancel: begin
       edtEQContent.ReadOnly := True;
    end;
    faAppend,
    faModify: begin
       edtEQContent.ReadOnly := False;
    end;
  end;    // case
end;

end.
