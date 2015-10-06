unit ufrmBrowseSource;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxLookAndFeelPainters, StdCtrls, cxButtons, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxContainer, cxLabel, cxCheckBox, cxBlobEdit, Menus, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxRichEdit, cxMemo, DBCtrls,
   DBClient, cxLookAndFeels, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinBlueprint, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinHighContrast, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinSevenClassic, dxSkinSharpPlus,
  dxSkinTheAsphaltWorld, dxSkinVS2010, dxSkinWhiteprint, cxNavigator,
  JvExStdCtrls, JvRichEdit;

type
  TfrmBrowseSource = class(TForm)
    tvSource: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    btnBrowse: TcxButton;
    cxLabel1: TcxLabel;
    OpenDialog1: TOpenDialog;
    edtSource: TcxButtonEdit;
    chkOriginal: TcxCheckBox;
    clmnSourceExamineeNo: TcxGridDBColumn;
    clmnSourceExamineeName: TcxGridDBColumn;
    clmnSourceIP: TcxGridDBColumn;
    clmnSourcePort: TcxGridDBColumn;
    clmnSourceStatus: TcxGridDBColumn;
    clmnSourceRemainTime: TcxGridDBColumn;
    clmnSourceTimeStamp: TcxGridDBColumn;
    edtUnCompressedScoreInfo: TJvRichEdit;
    ckbxSingleExam: TcxCheckBox;
    tvSourceSex: TcxGridDBColumn;
    procedure edtSourceClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure tvSourceFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
//    procedure DecryptExamineeInfoCDS(cds:TClientDataSet);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrowseSource: TfrmBrowseSource;

implementation

uses udmMain, uPubFn, DataFieldConst, compress, Commons,datautils;

{$R *.dfm}

procedure TfrmBrowseSource.btnBrowseClick(Sender: TObject);
var
   filename:string;
begin
  btnBrowse.Enabled := false;
  try
     filename:=edtSource.text;
     if filename<>'' then
     begin
       tvsource.BeginUpdate;
       //清空当前数据集
       if dmMain.cdsSource.Active then
       begin
         dmMain.cdsSource.EmptyDataSet;
         dmMain.cdsSource.Active := false;
       end;
       if dmMain.cdsSourceOriginal.Active then
       begin
         dmMain.cdsSourceOriginal.EmptyDataSet;
         dmMain.cdsSourceOriginal.Active := false;
       end;

       dmMain.dsSource.DataSet:=nil;
       if ckbxSingleExam.Checked then begin
         dmMain.cdsSourcefromfile.LoadFromFile(filename);
         DecryptExamineeInfoCDS(dmMain.cdsSourcefromfile);
         dmMain.dsSource.DataSet := dmMain.cdsSourcefromfile;
       end else begin
         if SetSourceConn(filename) then
         begin
           if chkOriginal.Checked then begin
             dmMain.dsSource.DataSet := dmMain.cdsSourceoriginal;
             dmMain.cdsSourceoriginal.Active := true;
           end else begin
             DecryptExamineeInfoCDS(dmMain.cdsSource);
             dmMain.dsSource.DataSet := dmMain.cdsSource;
           end;
         end;
       end;
   //      tvsource.ClearItems;
   //      tvSource.DataController.CreateAllItems;
         tvsource.EndUpdate;
     end
     else
       application.MessageBox('上报库路径为空','错误');
  finally
     btnBrowse.Enabled:= true;
  end;
end;

procedure TfrmBrowseSource.edtSourceClick(Sender: TObject);
begin
  if  opendialog1.Execute then
    edtSource.Text := OpenDialog1.FileName
  else
    edtsource.Text := '';
end;

procedure TfrmBrowseSource.tvSourceFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
var
  stream : TMemoryStream;
begin
  stream := TMemoryStream.Create;
  with dmMain.dsSource.DataSet do begin
    try
      stream.Clear;
      (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(stream);
      stream.Position := 0;
      UnCompressStream(stream);
      edtUnCompressedScoreInfo.Lines.LoadFromStream(stream);
    finally
      stream.Free;
    end;
  end;
end;

end.
