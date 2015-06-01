unit ufrmEQBUseInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxContainer,
  cxTextEdit, ADODB, cxBlobEdit, cxRichEdit, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TfrmEQBUseInfo = class(TForm)
    grdSelectTableLevel1: TcxGridLevel;
    grdSelectTable: TcxGrid;
    btnExport: TcxButton;
    grdSelectTableDBTableView1: TcxGridDBTableView;
    grdSelectTableDBTableView1DBColumn: TcxGridDBColumn;
    grdSelectTableDBTableView1DBColumn1: TcxGridDBColumn;
    grdSelectTableDBTableView1DBColumn2: TcxGridDBColumn;
    grdSelectTableDBTableView1DBColumn3: TcxGridDBColumn;
    grdSelectTableDBTableView1DBColumn4: TcxGridDBColumn;
    grdSelectTableDBTableView1WIN: TcxGridDBColumn;
    grdSelectTableDBTableView1Word: TcxGridDBColumn;
    grdSelectTableDBTableView1Excel: TcxGridDBColumn;
    grdSelectTableDBTableView1Ppt: TcxGridDBColumn;
    dsStUseInfo: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private

    { Private declarations }

  public
    procedure doExport;
    { Public declarations }
  end;

var
  frmEQBUseInfo: TfrmEQBUseInfo;

implementation
uses uFnMt, uDmSetQuestion, Commons;
{$R *.dfm}

procedure TfrmEQBUseInfo.btnExportClick(Sender: TObject);
begin
  doExport;
end;

procedure TfrmEQBUseInfo.FormCreate(Sender: TObject);
begin
  if not dmSetQuestion.stSelect.Active then
     dmSetQuestion.stSelect.Active:=true;
end;

procedure TfrmEQBUseInfo.doExport();
var
  StkUseInfo:TStringListArray;
  connSource,connTarget:TADOConnection;
begin
  StkUseInfo:=GetCurrentStkUseInfo();
  connSource:=dmSetQuestion.stkConn;
  connTarget:=GetExportDBconn();
  try

    ExportTestQuestionsToDB(connSource,connTarget,StkUseInfo,WINDOWS_MODEL);
    ExportTestQuestionsToDB(connSource,connTarget,StkUseInfo,WORD_MODEL);
  finally
    connTarget.Free;
  end;
end;


end.
FCurrentTQRecord, dmSetQuestion, 
