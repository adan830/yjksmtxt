unit ufrmTestStrategy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBase, Menus, cxLookAndFeelPainters, cxClasses, cxStyles,
  cxGridTableView, DB, ADODB, cxEdit, cxEditRepositoryItems, dxDockControl,
  ufraTree, dxDockPanel, StdCtrls, cxButtons, ExtCtrls, cxTextEdit, cxLabel,
  cxControls, cxContainer, cxMemo, cxGroupBox, cxCheckGroup, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxDockControlPainter, 
  Commons, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue, cxGraphics, cxLookAndFeels, cxPC;

type
  TfrmTestStrategy = class(TfrmBase)
    memoStrategy: TcxMemo;
    cxLabel2: TcxLabel;
    cxLabel9: TcxLabel;
    edtTestName: TcxTextEdit;
    setSysConfig: TADODataSet;
    dsTestStrategy: TDataSource;
  private
    procedure doSave(RecID: String); override;
    procedure doModify(RecID: String); override;
    procedure doBrowse(RecID: String); override;
    procedure SetControlState(aAction: TFormAction); override;
    procedure doAppend(RecID: string);
    { Private declarations }
  public
    class procedure FormShowMode(aMode:TFormMode);
    { Public declarations }
  end;

var
  frmTestStrategy: TfrmTestStrategy;

implementation
uses uDmSetQuestion;
{$R *.dfm}

{ TfrmBase1 }

procedure TfrmTestStrategy.doBrowse(RecID: String);
begin
  inherited;

end;

procedure TfrmTestStrategy.doAppend(RecID: string);
begin
  RecID := NewRecordNo(FModelID);
  dmSetQuestion.stSt.AppendRecord([recid]);

//  dmMain.stSt.Append;
//  dmMain.stSt.Edit;
//  dmmain.stst.FieldByName('st_no').AsString:=RecID;
//  dmMain.stst.Post;
  doBrowse(RecID);
  doModify(RecID);
end;

procedure TfrmTestStrategy.doModify(RecID: String);
begin
  inherited;

end;

procedure TfrmTestStrategy.doSave(RecID: String);
var
  setSt:TADODataSet;
  StrList:TStringList;
  commstr:string;
  i:integer;
begin
  inherited;
   setSt:=TADODataSet.Create(self);
   StrList:=TStringList.Create;
   setSt.Connection:=dmSetQuestion.stkConn;

   with setSt do
   try
      case  CurrentFormAction  of
         faModify,faAppend:begin
                     CommandText:='select * from sysconfig where st_no=:stno';
                     Parameters.ParamByName('stno').Value:=trim(edtTestName.Text);
                     active:=true;
                     if not isempty then
                     begin
                        edit;
                        FieldByName('st_lr').Assign(memoStrategy.Lines);

                        Post;
                     end;
                  end;
      end;
   finally
     strList.Free;
     setSt.Free;
     //dmMain.stSt.Requery();
   end;

end;

class procedure TfrmTestStrategy.FormShowMode(aMode: TFormMode);
begin

end;

procedure TfrmTestStrategy.SetControlState(aAction: TFormAction);
begin
  inherited;

end;

end.
(, , )
