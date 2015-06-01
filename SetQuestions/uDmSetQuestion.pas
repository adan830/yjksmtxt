unit uDmSetQuestion;

interface

uses
  SysUtils, Classes, DB, ADODB,  NetGlobal, Variants, ExamInterface, 
  DataFieldConst, Dialogs;

type
  TdmSetQuestion = class(TDataModule,IExamTcpClient,ITQDataModule)
    stkConn: TADOConnection;
    stTable: TADOTable;
    infoConn: TADOConnection;
    PointTable: TADOTable;
    stDS: TDataSource;
    TypeTable: TADOTable;
    TypeDs: TDataSource;
    stSt: TADODataSet;
    tblFjwj: TADOTable;
    tblFjwjGuid: TSmallintField;
    tblFjwjFileName: TWideStringField;
    tblFjwjFilestream: TBlobField;
    stSelect: TADODataSet;
    dlgOpen1: TOpenDialog;
    procedure stkConnBeforeConnect(Sender: TObject);
    procedure infoConnBeforeConnect(Sender: TObject);
    procedure stkConnConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure infoConnConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
  private
    function GetStUseInfoDataSet: TADODataSet;
    procedure GetFieldValue(const AField: TField;   value: variant);
   
  public
    kspath:string;
    UserID:string;
    UserName:string;
    function CommandGetEQFile(AFileID: string; out AStream: TMemoryStream): TCommandResult;
    function GetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string):Variant;
    function GetDBRecordFieldValuesByID(const AID: string;const FieldNames: string): Variant; 
    procedure SetDBRecordFieldValues(const ASqlStr: string; const AParamValues: Variant; const FieldNames: string; AFieldValues: Variant);
    procedure SetDBRecordFieldValuesByID(const AID: string; const FieldNames: string; AFieldValues: Variant);
    ///this procedure assign variant array value to blobfield
    procedure AssignFieldValue(AField: TField; value: variant);
    function IsAuthorizationUser(userid, pwd: string): boolean;
    function IDToUserName(id: string): string;
    // Instanse of ITQDataModule
    function GetTQDBConn() : TADOConnection;
    procedure GetTQFieldStream(const ASqlStr, AParamValue: string;AStream:TMemoryStream);
//    procedure ReadTQByID(const AID: string; out ATQ : TTQ);
//    procedure WriteTQByID(const AID: string; const ATQ :TTQ);

  property
    StUseInfoDataSet :TADODataSet read GetStUseInfoDataSet;



  end;

var
  dmSetQuestion: TdmSetQuestion;

implementation
uses forms, DataUtils, compress, Commons, ExamGlobal, ExamException, 
  ExamResourceStrings;
{$R *.dfm}

procedure TdmSetQuestion.infoConnConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
  PointTable.Active:=true;
  TypeTable.Active:=true;
end;

procedure TdmSetQuestion.stkConnBeforeConnect(Sender: TObject);
var
  filename:string;
begin
  dlgOpen1.Title := '请选择系统题库：';
  dlgOpen1.InitialDir := ExtractFilePath(application.ExeName);
  dlgOpen1.FileName := DEFAULTSYSDB_FILENAME;
  if dlgOpen1.Execute() then
  begin
    stkConn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
        +dlgOpen1.FileName
        +';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
  end else begin
     fileName := ExtractFilePath(application.ExeName)+DEFAULTSYSDB_FILENAME;
     EFileNotExistException.IFFalse(FileExists(fileName),Format(RSFileNotExist,[fileName]));
     stkConn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
        +filename+';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);
  end;
end;

procedure TdmSetQuestion.stkConnConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
  stTable.Active:=true;
  stSt.Active:=true;
  stSelect.Active:=true;
end;


function TdmSetQuestion.CommandGetEQFile(AFileID: string; out AStream: TMemoryStream): TCommandResult;
var
   tempSet:TADODataSet;
begin
  result := crError;
  tempSet:= TADODataSet.Create(nil);
  AStream:= TMemoryStream.Create;
  try
    tempSet.Connection := stkConn;
    tempSet.CommandText := 'select * from 附加文件 where guid = :v_guid ';
    tempSet.Parameters.ParamValues['v_guid']:=AFileID;
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      (tempSet.FieldByName('FileStream') as TBlobField).SaveToStream(AStream);
      Result := crOk;
    end;
  finally // wrap up
    tempSet.Free;
  end;    // try/finally
end;

function TdmSetQuestion.GetStUseInfoDataSet: TADODataSet;
begin
  if not stSelect.Active then
    stSelect.Active:=true;
  result := stSelect;
end;

function TdmSetQuestion.GetTQDBConn: TADOConnection;
begin
  Result := stkConn;
end;

procedure TdmSetQuestion.GetTQFieldStream(const ASqlStr, AParamValue: string; AStream: TMemoryStream);
var
   tempSet:TADODataSet;
begin
  tempSet:= TADODataSet.Create(nil);
  try
    tempSet.Connection := stkConn;
    tempSet.CommandText :=ASqlStr;
    tempSet.Parameters.ParamValues['v_stno']:=AParamValue;
    tempSet.Active :=true;
    if not tempSet.IsEmpty then
    begin
      if not Assigned(AStream) then
         AStream := TMemoryStream.Create;
      (tempSet.Fields[0] as TBlobField).SaveToStream(AStream) ;
      UnCompressStream(AStream);
    end;
  finally // wrap up
    tempSet.Free;
  end;    // try/finally
end;

procedure TdmSetQuestion.infoConnBeforeConnect(Sender: TObject);
var
   fileName:string;
begin
   fileName := ExtractFilePath(application.ExeName)+GRADEINFO_FILENAME;
   EFileNotExistException.IFFalse(FileExists(fileName),Format(RSFileNotExist,[fileName]));
   infoConn.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
        +filename+';Persist Security Info=False;Jet OLEDB:Database Password='+DecryptStr(SYSDBPWD);

end;

function TdmSetQuestion.GetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string): Variant;
var
  I: Integer;
  ValueFields: TList;
  setTemp: TADODataSet;
begin
    setTemp:=TADODataSet.Create(nil);
    with setTemp do
    begin
      try
        Connection:=stkConn;
        CommandText:=ASqlStr;

        if Parameters.Count =1 then
          Parameters[0].Value:=AParamValues
        else begin
          for I := 0 to Parameters.Count - 1 do
            TParam(Parameters[I]).Value := AParamValues[I];
        end;
        Active:=true;
        if not IsEmpty then
        begin
          if Pos(';', FieldNames) <> 0 then
          begin
            ValueFields := TList.Create;
            try
              GetFieldList(ValueFields, FieldNames);
              Result := VarArrayCreate([0, ValueFields.Count - 1], varVariant);
              for I := 0 to ValueFields.Count - 1 do
              begin
                GetFieldValue(ValueFields[I],Result[I]);
              end;
            finally
              ValueFields.Free;
            end;
          end else begin
              GetFieldValue(FieldByName(FieldNames),Result);
           end;
          end;
      finally
        setTemp.Free;
      end;
    end;
end;

function TdmSetQuestion.GetDBRecordFieldValuesByID(const AID: string; const FieldNames: string): Variant;
begin
   Result := GetDBRecordFieldValues( SQLSTR_GETTQDATASET_BY_STNO,AID,FieldNames);
end;

procedure TdmSetQuestion.SetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string;AFieldValues:Variant);
var
  I: Integer;
  ValueFields: TList;
  setTemp: TADODataSet;
begin
    setTemp:=TADODataSet.Create(nil);
    with setTemp do
    begin
      try
        Connection:=stkConn;
        CommandText:=ASqlStr;
        if Parameters.Count =1 then
          Parameters[0].Value:=AParamValues
        else begin
          for I := 0 to Parameters.Count - 1 do
            TParam(Parameters[I]).Value := AParamValues[I];
        end;
        Active:=true;
        if setTemp.RecordCount=1 then  //must be 1 for update
        begin
          Edit;
          if Pos(';', FieldNames) <> 0 then
          begin
            ValueFields := TList.Create;
            try
              GetFieldList(ValueFields, FieldNames);
              for I := 0 to ValueFields.Count - 1 do
              begin
                 AssignFieldValue(ValueFields[i],AFieldValues[i]);
              end;
            finally
              ValueFields.Free;
            end;
          end else begin
              AssignFieldValue(FieldByName(FieldNames),AFieldValues);
           end;
          end;
      finally
        Post;
        setTemp.Free;
      end;
    end;
end;

procedure TdmSetQuestion.AssignFieldValue(AField :TField; value : variant);
var
     stream:TMemoryStream;
begin
  if TVarData(value).VType = varByRef or varVariant then begin
      stream := TMemoryStream.Create;
      try
        varianttostream(value,stream);
        TBlobField(AField).LoadFromStream(stream);
      finally
        stream.Free;
      end;
  end else begin
    TField(AField).Value :=value;
  end;
end;

procedure TdmSetQuestion.GetFieldValue(const AField :TField;   value : variant);
var
     stream:TMemoryStream;
begin
  if AField is TBlobField then begin
      stream := TMemoryStream.Create;
      try
        TBlobField(AField).SaveToStream(stream);
        value:=StreamToVariant(stream);
      finally
        stream.Free;
      end;
  end else begin
     value :=TField(AField).Value;
  end;
end;

procedure TdmSetQuestion.SetDBRecordFieldValuesByID(const AID: string; const FieldNames: string; AFieldValues: Variant);
begin
   SetDBRecordFieldValues( SQLSTR_GETTQDATASET_BY_STNO,AID,FieldNames,AFieldValues);
end;

function TdmSetQuestion.IsAuthorizationUser(userid:string;pwd :string): boolean;
var
  qrUsers: TadoQuery;
begin
  qrusers:=TAdoquery.Create(nil);
  qrusers.Connection:=infoConn;
  qrusers.SQL.Add('select count(*) as rn from users where (id='+quotedstr(userid)+ ') and (pwd='+quotedstr(pwd)+')');
  qrusers.open;
  if qrusers.FieldValues['rn']=1 then
     result := true
  else
    result := false;
  qrusers.Close;
  qrusers.Free;
end;

function TdmSetQuestion.IDToUserName(id:string): string;
var
  qrUsers: TadoQuery;
begin
  qrusers := Tadoquery.Create(nil);
  try
    qrusers.Connection:=infoConn;
    qrusers.SQL.Add('select xm from users where id='+quotedstr(id));
    qrusers.open;
    if qrusers.RecordCount =1 then
       result := qrusers.FieldValues['xm']
    else
      result := '';
  finally
    qrusers.Free;
  end;
end;

end.
