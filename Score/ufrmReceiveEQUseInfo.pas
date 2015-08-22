unit ufrmReceiveEQUseInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLabel, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLookAndFeelPainters, StdCtrls, cxButtons,db, uGrade, DBClient,
  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Provider, dxSkinsCore, dxSkinsDefaultPainters, Menus, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue, cxLookAndFeels, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TfrmReceiveEQUseInfo = class(TForm)
    edtSource: TcxButtonEdit;
    cxLabel1: TcxLabel;
    OpenDialog1: TOpenDialog;
    cxButton1: TcxButton;
    cdsSystemDB: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    edtKStotal: TcxTextEdit;
    edtEQTotal: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxButton2: TcxButton;
    procedure cxButton2Click(Sender: TObject);
    procedure DataSetProvider1UpdateData(Sender: TObject;
      DataSet: TCustomClientDataSet);
    procedure FormCreate(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure edtSourcePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    procedure SelectUseInfo(ScoreInfoStrings: TStrings);
    procedure UpdateUseInfo(scoreInfo: TScoreInfo);
    { Private declarations }
  public
    procedure ReceiveEQUserInfo(dataset:TClientDataSet);
    { Public declarations }
  end;

var
  frmReceiveEQUseInfo: TfrmReceiveEQUseInfo;

implementation
uses adodb, uPubFn, udmMain;

{$R *.dfm}

procedure TfrmReceiveEQUseInfo.edtSourcePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if  opendialog1.Execute then
    edtSource.Text := OpenDialog1.FileName
  else
    edtsource.Text := '';
end;

procedure TfrmReceiveEQUseInfo.cxButton1Click(Sender: TObject);
var
  connSource:TADOConnection;
  qrySource:TADOQuery;
  dspSource:TDatasetProvider;
  cdsSource:TClientDataset;

begin
  connSource:=TADOConnection.Create(nil);
  connSource.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+edtSource.Text;
  connsource.LoginPrompt := false ;
  qrySource:=TADOQuery.Create(nil);
  qrySource.Connection := connSource;
  dspSource:=TDataSetProvider.Create(nil);
  dspSource.DataSet := qrySource;
  dspSource.Options:=[poAllowCommandText,poUseQuoteChar];
  cdsSource:=TClientDataSet.Create(nil);
  cdssource.SetProvider(dspSource);
  cdsSource.CommandText:='select zkh,xzinfo,pdinfo from »ã×Ü³É¼¨';
  try
    cdsSource.PacketRecords:=1000;
    cdsSource.ReadOnly:=true;
    cdsSource.Active := True ;
    ReceiveEQUserInfo(cdsSource);
    
  finally
    cdsSource.Free;
    dspsource.Free;
    qrySource.Free;
    connSource.Free;
    cdsSystemDB.ApplyUpdates(0);
  end;
end;

procedure TfrmReceiveEQUseInfo.ReceiveEQUserInfo(dataset:TClientDataSet);
var
  ScoreInfoStrings:TStringList;
  co:integer;
begin
  ScoreInfoStrings:=TStringList.Create;
  try
    dataset.first;
    co:=0;
    while not dataset.eof do
    begin   
      ScoreInfoStrings.Text:=dataset.Fieldbyname('xzinfo').AsString;
      SelectUseInfo(ScoreInfoStrings);
      ScoreInfoStrings.Text:=dataset.Fieldbyname('pdinfo').AsString;
      SelectUseInfo(ScoreInfoStrings);

      edtksTotal.Text:=inttostr(strtoint64(edtkstotal.Text)+1);
      application.ProcessMessages;
       dataset.Next;
       co:=co+1;
       if (co mod 500)=0 then
                cdsSystemDB.ApplyUpdates(0);
    end;
  finally // wrap up

    ScoreInfoStrings.Free;
  end;    // try/finally
end;

procedure TfrmReceiveEQUseInfo.SelectUseInfo(ScoreInfoStrings: TStrings);
var
  I: Integer;
  Score : Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    //Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,',');
    UpdateUseInfo(scoreinfo);
   // edtEqTotal.Text:=inttostr(strtoint64(edtEqtotal.Text)+1);
  end;    // for

end;

procedure TfrmReceiveEQUseInfo.UpdateUseInfo(scoreInfo:TScoreInfo);
begin
  if  cdsSystemDB.Locate('st_no',scoreinfo.EQID,[]) then
  begin
    cdsSystemDB.Edit;
    if scoreinfo.IsRight=-1 then
      cdsSystemDB.Fieldbyname('nd').asinteger:=cdsSystemDB.Fieldbyname('nd').AsInteger+1;
    cdsSystemDB.Fieldbyname('syn').asinteger:=cdsSystemDB.Fieldbyname('syn').AsInteger+1;
    cdsSystemDB.Post;
  end;
end;

procedure TfrmReceiveEQUseInfo.FormCreate(Sender: TObject);
begin
 
  cdsSystemdb.SetProvider(dmMain.dspStatistics);
  cdsSystemdb.Active:=true;
  cdsSystemdb.IndexFieldNames:='st_no';
//  dsSystemdb.DataSet:=cdssystemdb;
//  tvsystemdb.DataController.CreateAllItems;
end;

procedure TfrmReceiveEQUseInfo.DataSetProvider1UpdateData(Sender: TObject;
  DataSet: TCustomClientDataSet);
begin
with DataSet do
  begin
    FieldByName('st_no').ProviderFlags := [pfInWhere, pfInKey];
  end;

end;

procedure TfrmReceiveEQUseInfo.cxButton2Click(Sender: TObject);
begin
 // cdsSystemdb.Active:=true;
 // dsSystemdb.DataSet:=cdssystemdb;
//  tvsystemdb.DataController.CreateAllItems;
end;

end.
