unit ufrmSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBase, DB, ADODB, cxEdit, cxEditRepositoryItems,
  dxDockControl, ufraTree, dxDockPanel, StdCtrls, cxButtons, ExtCtrls,
  cxTextEdit, cxMemo, cxCheckBox, cxGroupBox, cxControls, cxContainer,
  cxRadioGroup, cxLabel, Menus, cxLookAndFeelPainters, cxClasses, cxStyles,
  cxGridTableView, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, cxCheckGroup, 
  Commons, cxRichEdit, JvExStdCtrls, JvRichEdit, cxGraphics, cxLookAndFeels,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, cxPC;

type
  TfrmSelect = class(TfrmBase)
    chkgrpItem: TcxGroupBox;
    chkItem1: TcxCheckBox;
    chkItem2: TcxCheckBox;
    chkItem3: TcxCheckBox;
    chkItem4: TcxCheckBox;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    rbItem1: TcxRadioButton;
    rbItem2: TcxRadioButton;
    rbItem3: TcxRadioButton;
    rbItem4: TcxRadioButton;
    edtEQContent: TJvRichEdit;
    lblItemA: TcxLabel;
    lblItemB: TcxLabel;
    lblItemC: TcxLabel;
    lblItemD: TcxLabel;
    edtEQComment: TJvRichEdit;
  private
  protected
    procedure doBrowse(RecID: String); override;
    procedure doModify(RecID: String); override;
    procedure doSave(RecID: String); override;
    procedure SetControlState(aAction: TFormAction); override;
    { Private declarations }
  public
    { Public declarations }

   class procedure FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);
  end;

implementation

uses uDmSetQuestion, DataFieldConst, DataUtils, ExamInterface;

{$R *.dfm}

{ TfrmSelect }

class procedure TfrmSelect.FormShowMode(const AModuleFileName:TFileName;aMode:TFormMode);
var
  frmSelect:TfrmSelect;
begin
  frmSelect:=TfrmSelect.Create(AModuleFileName,aMode);
  try
     frmSelect.ShowModal;
  finally // wrap up
    frmSelect.Free;
  end;    // try/finally
end;

procedure TfrmSelect.doBrowse(RecID: String);
var
  s:string;
  pc:Pchar;
  i,j:integer;
begin
    inherited;
      edtEQContent.Lines.LoadFromStream(FCurrentTQRecord.Content);
      edtEQComment.Lines.LoadFromStream(FCurrentTQRecord.Comment);
      s := StreamToStr(FCurrentTQRecord.StAnswer);
      case FModelID of    //
         SINGLESELECT_MODEL: begin
             if length(s)>0 then
             begin
               case strtoint(s)-1 of    //
                 0: rbItem1.Checked := True;
                 1: rbItem2.Checked := True;
                 2: rbItem3.Checked := True;
                 3: rbItem4.Checked := True;
               end;    // case
             end;
         end;
         MULTISELECT_MODEL: begin
             chkItem1.Checked := False;
             chkItem2.Checked := False;
             chkItem3.Checked := False;
             chkItem4.Checked := False;

             pc:=pchar(s);
             for i:=0 to Length(s)-1 do
             begin
               j:=strtoint(pc[i])-1;                      //在这里要考虑非数值的情况，可能会触发异常
               if (j>=0) and (j<=3) then
                  case j of    //
                   0: chkItem1.Checked := True;
                   1: chkItem2.Checked := True;
                   2: chkItem3.Checked := True;
                   3: chkItem4.Checked := True;
                  end;    // case
             end;
       end;
      end;    // case
end;

procedure TfrmSelect.doModify(RecID: String);
begin
  inherited;

end;

procedure TfrmSelect.doSave(RecID: String);
var
  str:string;
begin
      case  CurrentFormAction  of
         faModify,faAppend :   begin
               FCurrentTQRecord.ClearData;
               FCurrentTQRecord.St_no := RecID;
               edtEQContent.Lines.SaveToStream(FCurrentTQRecord.Content);
                        str := '';
                        case FModelID of    //
                          SINGLESELECT_MODEL:
                          begin
                            if rbItem1.Checked then
                               str := '1';
                            if rbItem2.Checked then
                               str := '2';
                            if rbItem3.Checked then
                               str := '3';
                            if rbItem4.Checked then
                               str := '4';                               
                          end;
                          MULTISELECT_MODEL:
                          begin
                            if chkItem1.Checked then
                               str := '1';
                            if chkItem2.Checked then
                               str := str+'2';
                            if chkItem3.Checked then
                               str := str+'3';
                            if chkItem4.Checked then
                               str := str+'4';                               
                          end;
                        end;    // case
                        StrToStream(str,FCurrentTQRecord.StAnswer);
                        edtEQComment.Lines.SaveToStream(FCurrentTQRecord.Comment);
                        
         end;
      end; 
   inherited;
end;

procedure TfrmSelect.SetControlState(aAction: TFormAction);
begin
  inherited;
  case FModelID of    //
    SINGLESELECT_MODEL: begin
                rbItem1.Visible := True;
                rbItem2.Visible := True;
                rbItem3.Visible := True;
                rbItem4.Visible := True;

                chkItem1.Visible := False;
                chkItem2.Visible := False;
                chkItem3.Visible := False;
                chkItem4.Visible := False;
    end;
    MULTISELECT_MODEL: begin
                rbItem1.Visible := False;
                rbItem2.Visible := False;
                rbItem3.Visible := False;
                rbItem4.Visible := False;

                chkItem1.Visible := True;
                chkItem2.Visible := True;
                chkItem3.Visible := True;
                chkItem4.Visible := True;
    end;
  end;    // case
  case aAction of    //
    faBrowse,
    faSave,
    faCancel: begin
      	edtEQContent.ReadOnly := True;
         rbItem1.Enabled := False;
         rbItem2.Enabled := False;
         rbItem3.Enabled := False;
         rbItem4.Enabled := False;
         chkItem1.Enabled := False;
         chkItem2.Enabled := False;
         chkItem3.Enabled := False;
         chkItem4.Enabled := False;

         //edtStNo.Properties.ReadOnly:=true;

         edtEQComment.ReadOnly := True;
    end;
    faAppend,
    faModify: begin
         edtEQContent.ReadOnly := False;
         rbItem1.Enabled := True;
         rbItem2.Enabled := True;
         rbItem3.Enabled := True;
         rbItem4.Enabled := True;
         chkItem1.Enabled := True;
         chkItem2.Enabled := True;
         chkItem3.Enabled := True;
         chkItem4.Enabled := True;
         // edtStNo.Properties.ReadOnly:=false;
         edtEQComment.ReadOnly := False;
    end;
  end;    // case
end;

end.
