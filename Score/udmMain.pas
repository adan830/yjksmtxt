unit udmMain;

interface

uses
  SysUtils, Classes, DB, ADODB, Provider, DBClient,uPubFn;

type
  TdmMain = class(TDataModule)
    connSource: TADOConnection;
    connScore: TADOConnection;
    qrySource: TADOQuery;
    cdsSource: TClientDataSet;
    dspSource: TDataSetProvider;
    dsSource: TDataSource;
    dspSourceOriginal: TDataSetProvider;
    cdsSourceoriginal: TClientDataSet;
    connStatistics: TADOConnection;
    qryStatistics: TADOQuery;
    dspScore: TDataSetProvider;
    dspStatistics: TDataSetProvider;
    cdsScore: TClientDataSet;
    cdsStatistics: TClientDataSet;
    qryScore: TADOQuery;
    dsScore: TDataSource;
    cdsSourceFromFile: TClientDataSet;
    wdstrngfldSourceFromFileExamineeID: TWideStringField;
    wdstrngfldSourceFromFileExamineeName: TWideStringField;
    wdstrngfldSourceFromFileIP: TWideStringField;
    wdstrngfldSourceFromFilePort: TWideStringField;
    wdstrngfldSourceFromFileStatus: TWideStringField;
    wdstrngfldSourceFromFileRemainTime: TWideStringField;
    wdstrngfldSourceFromFileTimeStamp: TWideStringField;
    blbfldSourceFromFileScoreInfo: TBlobField;
    wdstrngfldSourceExamineeID: TWideStringField;
    wdstrngfldSourceExamineeName: TWideStringField;
    wdstrngfldSourceIP: TWideStringField;
    wdstrngfldSourcePort: TWideStringField;
    wdstrngfldSourceStatus: TWideStringField;
    wdstrngfldSourceRemainTime: TWideStringField;
    wdstrngfldSourceTimeStamp: TWideStringField;
    blbfldSourceScoreInfo: TBlobField;
    procedure connScoreWillConnect(Connection: TADOConnection;
      var ConnectionString, UserID, Password: WideString;
      var ConnectOptions: TConnectOption; var EventStatus: TEventStatus);
    procedure dspScoreUpdateData(Sender: TObject;
      DataSet: TCustomClientDataSet);
    procedure cdsSourceCalcFields(DataSet: TDataSet);
    procedure dspSourceGetData(Sender: TObject; DataSet: TCustomClientDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation
uses forms, ExamGlobal, DataFieldConst, compress;

{$R *.dfm}

procedure TdmMain.dspSourceGetData(Sender: TObject;
  DataSet: TCustomClientDataSet);
var
  stream : TMemoryStream;
  str : string;
begin
  stream := TMemoryStream.Create;
  try
    with dataset do
    begin
      first;
      while not Eof do
      begin
        Edit;
        FieldValues[DFNEI_EXAMINEEID]    := Fieldbyname(DFNEI_EXAMINEEID).AsString;  //DecryptStr(Fieldbyname('status').AsString);
        FieldValues[DFNEI_EXAMINEENAME]  := Fieldbyname(DFNEI_EXAMINEENAME).AsString;
        FieldValues[DFNEI_IP]            := Fieldbyname(DFNEI_IP).AsString;
        FieldValues[DFNEI_PORT]          := Fieldbyname(DFNEI_PORT).AsInteger;
        FieldValues[DFNEI_STATUS]        := Fieldbyname(DFNEI_STATUS).AsInteger;
        FieldValues[DFNEI_REMAINTIME]    := Fieldbyname(DFNEI_REMAINTIME).AsInteger;
//        stream.Clear;
//        (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(stream);
//        stream.Position := 0;
//        UnCompressStream(stream);
//        (FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(stream);
//        if stream.Size>0 then
//
//        (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToFile('abcd.txt');
//        if stream.Size =0  then
//          FieldByName(DFNEI_SCOREINFO).Value := 'aaaaaaaaaaaaaaaaaaaaaaaaa';
        post;
        next;
      end;
    end;
  finally
    stream.Free;
  end;
    
end;

procedure TdmMain.cdsSourceCalcFields(DataSet: TDataSet);
var
//  score :scorearray ;
  stream : TMemoryStream;
  strList : TStringList;
  str:string;
begin
  stream := TMemoryStream.Create;
  strList := TStringList.Create;
  with DataSet do begin
    try
      stream.Clear;
      (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(stream);
      stream.Position := 0;
      UnCompressStream(stream);
      strList.LoadFromStream(stream);
      FieldByName('uncompressedscoreinfo').Value := strList.Text;
      FieldByName('ddd').Value := strList.Text;
      str := FieldByName('uncompressedscoreinfo').AsString;
    finally
      stream.Free;
    end;
  end;      

//  getscore(dataset,score);
//  with dataset do
//  begin
////    edit;
//    fieldvalues['xz'] := score[0];
//    fieldvalues['pd'] := score[1];
//    fieldvalues['dz'] := score[2];
//    fieldvalues['win'] := score[3];
//    fieldvalues['word'] := score[4];
//    fieldvalues['excel'] := score[5];
//    fieldvalues['ppt'] := score[6];
////    if (fieldbyname('zf').AsString<>'') then
//    begin
//      if (score[7] = fieldbyname('zf').AsInteger)  then
//      begin
//        fieldvalues['zzf'] := score[7];
//        fieldvalues['eq'] := true ;
//      end
//      else
//      begin
//        if (score[7] > fieldbyname('zf').AsInteger) then
//        begin
//          fieldvalues['zzf'] :=score[7];
//          fieldvalues['eq'] := false;
//        end
//        else
//        begin
//          fieldvalues['zzf'] := fieldvalues['zf'];
//          fieldvalues['eq'] := false;
//        end;
//        
//      end;
//    end
////    else
////    begin
////      fieldvalues['zzf'] := score[7];
////      fieldvalues['eq'] := false;
////    end;
//
////    post;
//  end;
end;

procedure TdmMain.dspScoreUpdateData(Sender: TObject;
  DataSet: TCustomClientDataSet);
begin
  DataSet.FieldByName(DFNEI_EXAMINEEID).ProviderFlags := [pfInWhere, pfInKey,pfInUpdate];
end;

procedure TdmMain.connScoreWillConnect(Connection: TADOConnection;
  var ConnectionString, UserID, Password: WideString;
  var ConnectOptions: TConnectOption; var EventStatus: TEventStatus);
var
  path:string;
begin
  path:=ExtractFilePath(application.ExeName);
  connectionstring:='Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source='+path+'»ã×Ü³É¼¨.mdb;Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2';
end;

end.
