unit ufrmScore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxLookAndFeelPainters, StdCtrls, cxButtons,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGrid, cxMemo, cxBlobEdit,
  cxDropDownEdit, cxLookAndFeels, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxNavigator, Vcl.Menus, JvExStdCtrls, JvRichEdit;

type
  TfrmScore = class(TForm)
    tvscore: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    tvscoreExamineeID: TcxGridDBColumn;
    tvscoreName: TcxGridDBColumn;
    tvscoreRemainTime: TcxGridDBColumn;
    tvscorestatus: TcxGridDBColumn;
    tvscorexSex: TcxGridDBColumn;
    tvscorezf: TcxGridDBColumn;
    tvsScoreInfo: TcxGridDBColumn;
    edtUnCompressedScoreInfo: TJvRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
    procedure tvscoreFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScore: TfrmScore;

implementation

uses udmMain,DataFieldConst;

{$R *.dfm}

procedure TfrmScore.cxButton1Click(Sender: TObject);
begin
  dmMain.dsScore.DataSet := dmMain.cdsScore;
  dmMain.cdsScore.Active := false;
  dmMain.cdsScore.IndexFieldNames:=DFNEI_EXAMINEEID;
  dmmain.cdsScore.Active := true;
end;

procedure TfrmScore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmmain.dsScore.DataSet:=nil;
end;

procedure TfrmScore.tvscoreFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
var
  stream : TMemoryStream;
begin
   if dmMain.dsScore.DataSet=nil then
      exit;

  stream := TMemoryStream.Create;
  with dmMain.dsScore.DataSet do begin
    try
      stream.Clear;
      (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(stream);
      stream.Position := 0;
      //UnCompressStream(stream);
      edtUnCompressedScoreInfo.Lines.LoadFromStream(stream);
    finally
      stream.Free;
    end;
  end;
end;

end.
