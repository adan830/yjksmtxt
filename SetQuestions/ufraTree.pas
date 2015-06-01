unit ufraTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms, 
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ADODB, cxCheckBox, Menus, cxLookAndFeelPainters,
  StdCtrls, cxButtons, ExtCtrls, Classes, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue, cxLookAndFeels, dxSkinBlueprint,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinHighContrast,
  dxSkinMetropolis, dxSkinMetropolisDark, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinSevenClassic,
  dxSkinSharpPlus, dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint,
  cxNavigator;

type
  TfraTree = class(TFrame)
    grdStListLevel1: TcxGridLevel;
    grdStList: TcxGrid;
    gvStList: TcxGridTableView;
    colSelected: TcxGridColumn;
    gvStListst_no: TcxGridColumn;
    Panel1: TPanel;
    btnSaveSelect: TcxButton;
    btnSelect: TcxButton;
  private
    { Private declarations }
  public
    procedure LoadStList(ds: TADODataSet);
    procedure Append(AStNo: string);
    procedure DeleteCurrent();
    function  CurrentTQNo():string;
    procedure SetFocus(ARecNo:string);
    { Public declarations }
  end;

implementation

uses DataFieldConst;

{$R *.dfm}

procedure TfraTree.LoadStList(ds:TADODataSet);
var
  recordIndex: integer;
  stList: TStringList;
begin
  ds.First;
  recordIndex:=0;
  gvStList.BeginUpdate;
  gvStList.DataController.RecordCount:=ds.RecordCount;
  while not ds.Eof do
  begin
    gvStList.DataController.Values[recordIndex,0]:=false;
    gvStList.DataController.Values[recordIndex,1]:=ds.FieldValues[DFNTQ_ST_NO];
    //gvStList.DataController.Values[recordIndex,2]:=ds.FieldValues['st_lr'];
    recordIndex:=recordIndex+1;
    ds.Next;
  end; 
  gvStList.EndUpdate;
end;

procedure TfraTree.SetFocus(ARecNo: string);
var
   recIndex:Integer;
begin
   with gvStList.DataController do begin
      FocusedRecordIndex:=FindRecordIndexByText(0,1,ARecNo,False,False,true);
   end;
end;

procedure TfraTree.Append(AStNo:string);
begin
   with gvStList.DataController do
   begin
      RecordCount := RecordCount +1;
      Values[RecordCount-1,0] := False;
      Values[RecordCount-1,1] := AStNo;
      FocusedRecordIndex := RecordCount-1;
   end;
end;

procedure TfraTree.DeleteCurrent();
begin
   gvStList.DataController.DeleteFocused;
end;

function TfraTree.CurrentTQNo():string;
begin
   Result:=gvStList.DataController.GetDisplayText(gvStList.DataController.GetFocusedRecordIndex ,1);
end;


end.
