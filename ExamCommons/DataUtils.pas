unit DataUtils;

interface
uses Variants,Vcl.StdCtrls, Classes, ExamInterface, DataFieldConst, DB, ADODB, tq,Provider,DBClient;
  /// <remarks>
  /// 以下函数为mdb数据库相关的基础函数
  /// </remarks>

  /// <summary>
  /// 获取mdb数据库文件的数据连接
  /// </summary>
  /// <param name="dbfilename">mdb数据库文件名及文件路径</param>
  /// <param name="aMode">Share Deny None:表示只读共享;share exclusive:表示独占可写,具体可参见连接创建中参数</param>
  /// <returns>返回连接TADOConnection</returns>
  function GetMdbConn(dbfilename:string;aMode:string='Share Deny None' ;aPwd:string = '' ):TADOConnection ;
  /// <summary>
  /// 获取TclientDataSet dddd
  /// </summary>
  /// <param name="aDSProvider"></param>
  /// <param name="aCommandText"></param>
  /// <returns></returns>
  function GetMdbCDS(aDSProvider:TDataSetProvider;aCommandText:string):TClientDataSet;
  /// <summary>
  ///
  /// </summary>
  /// <param name="aDs"></param>
  /// <param name="aOptions"></param>
  /// <param name="aUpdateMode"></param>
  /// <returns></returns>
  function GetMdbProvider(aDs:TDataSet;aOptions :TProviderOptions =[poAllowCommandText,poUseQuoteChar];aUpdateMode:TUpdateMode =upWhereKeyOnly):TDataSetProvider;
  function GetMdbAdoQuery(aConn:TADOConnection;aSql:string=''):TADOQuery;

  /// <summary>
  /// 解密TclientDataSet中考生信息
  /// </summary>
  /// <param name="cds">需解密的数据集对象</param>
  /// <param name="AIncludeScoreField">是否解密scoreinfo字段值，默认不解密</param>
  procedure DecryptExamineeInfoCDS(cds:TClientDataSet;AIncludeScoreField:Boolean =false);
  procedure EncryptExamineeInfoCDS(cdsSource:TClientDataSet;cdsTarget:TClientDataSet;AIncludeScoreField:Boolean =false);
  /// <summary>
  ///  解密考生信息数据集中，scoreinfo字段的值
  /// </summary>
  /// <param name="DataSet">需解密的数据集对象</param>
  procedure DecryptExamineeInfoCDSScoreInfo(DataSet: TDataSet);
  procedure EncryptExamineeInfoCDSScoreInfo(DataSet: TDataSet);


   /// <remarks>
   ///
   /// </remarks>
   function VarToInt(const V:Variant):Integer; //stdcall;

   ///this function is for convert TQ content control (TJVRichedit.lines) value to variant;
   ///  the Arichedit is control of TJVRichEdit;
   ///  the control is for display TQ content
   procedure AssignValueToRichEdit(value: Variant; ARichEdit: TCustomMemo);
   function StringsToVairant(strings:TStrings):Variant;
   //procedure VariantToStream (const v : Variant; Stream : TMemoryStream);
   //procedure StreamToVariant (Stream : TMemoryStream; var v : Variant);

//==============================================================================
// 以下几个函数用来处理 试题表 数据的读写
// 并进行加、解密 处理
// function GetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string): Variant;
///the following procedure get test question db record from db and fill ATQ （class TTQ) record
/// because Test question is compress ,then need uncompress
///
///base ID find record then update,so don't used as insert new reocrd
//==============================================================================
//  procedure ReadTQByIDAndUnCompress(const AID: string; ATQDm : ITQDataModule; out ATQ : TTQ);
//  procedure ReadTQAndUnCompressFromDS(ADs:TDataSet; out ATQ : TTQ);
  //写TQ结构数据到数据库，先压缩，再写，如在库中没找到相应记录，则添加新记录
  //procedure CompressAndWriteTQByID(var ATQ: TTQ; ATQDm: ITQDataModule; AWriteOptions: TTQWriteOptions);

  // 当前仅用于打字题写入考生录入文字到环境字段中
  procedure WriteTQStAnswerEnvironmentByID(const AID: string; ATQConn : TAdoConnection; const ATQ : TTQ);
 // procedure WriteTQStAnswerByID(const AID: string; ATQDm : ITQDataModule; const ATQ : TTQ);
 //==============================================================================
// 在数据集中添加一条记录，并将TTQ中的数据填充进入，
// 并不对ATQ中的数据进行任何处理
// 主要用在客户端从服务端取得记录，写入考生库 试题表中
//==============================================================================
  procedure AppendTQToDB(const ADS:TDataSet; const ATQ:TTQ); //used in client for append tq to db



  {-------------------------------------------------------------------------------
  过程名:    ReadTQFromDB，  WriteTQ2DB 		日期:      2009.05.02
  参数:      const AID: string; ATQDm : ITQDataModule; out ATQ : TTQ
  说明:      这是二个相反操作的函数，分别为读写
             ReadTQByID：从ATQDm中获取数据库连接，找开数据表，查找到AID指定的记录，然后
               利用 WriteFieldValuesToTq 读取数据到 ATQ中，只读取，并不解密
             WriteTQ2DB ：从ATQDm中获取数据库连接，找开数据表，查找到AID指定的记录，然后
               利用 WriteStreamToField 将ATQ中数据分别写入数据集字段中，并不对ATQ中数据进行处理
-------------------------------------------------------------------------------}
  //procedure ReadTQFromDB(const AID: string; ATQDm : ITQDataModule; out ATQ : TTQ);
  {-------------------------------------------------------------------------------
  过程名:    WriteFieldValuesToTQ		日期:      2009.05.02
  参数:      const ADS:TDataSet; var ATQ:TTQ
  说明:      从ADS中读取当前记录字段数据到ATQ中，并未解密
-------------------------------------------------------------------------------}
 // procedure WriteFieldValuesToTQ(const ADS:TDataSet; var ATQ:TTQ);

  //procedure WriteTQ2DB(const ATQ: TTQ; ATQDm: ITQDataModule);
  //procedure ImportTQ2DB(const AID: string; ATQDm : ITQDataModule; const ATQ : TTQ);
  {-------------------------------------------------------------------------------
  过程名:    UnCompressTQ		日期:      2009.05.02
  参数:      var ATQ:TTQ
  说明:      解密 ATQ 中的数据
-------------------------------------------------------------------------------}
  //procedure UnCompressTQ(var ATQ:TTQ);

  {-------------------------------------------------------------------------------
  过程名:    CompressTQ		日期:      2009.05.02
  参数:      var ATQ:TTQ
  说明:      解压缩 ATQ 中的数据
-------------------------------------------------------------------------------}
//procedure CompressTQ(var ATQ:TTQ);

  function StreamToStr(AStream:TMemoryStream):string;  // for select tq to get standart answer
  procedure StrToStream(str:string;out AStream:TMemoryStream); // for select tq to write standart answer
 // procedure StringsToStream(str:string;out AStream:TMemoryStream); //for operate TQ to write standand answer
 // procedure StreamToStrings(AStream:TMemoryStream;); //for operate TQ to write standand answer

//==============================================================================
// 以下几个函数用来处理数据库操作
//==============================================================================
  function GetDataSetByPreFix(const APreFix : string;const AConn: TADOConnection) : TDataSet;
  function GetTQIDByPreFix(const APreFix : string;const AConn: TADOConnection) :string;
  function GetDataSetBySQL(const ASQLStr : string;const AParamValue : Variant ;const AConn: TADOConnection) : TDataSet;
  procedure UpdateClientDBRemainTime(const aremainTime : integer;const AConn: TADOConnection) ;

//==============================================================================
// 考生得分信息相关函数
//==============================================================================
//procedure CompressScoreInfoField(sourceField,targetField:TField);
procedure UnCompressScoreInfoFieldToField(sourceField,targetField:TField);

implementation
  uses compress, ZLib, SysUtils, ExamException, ExamResourceStrings,Commons;


  function GetMdbConn(dbfilename:string;aMode:string='Share Deny None' ;aPwd:string = '' ):TADOConnection ;
  var
    connStr : string;
  begin
      Result := TADOConnection.Create(nil);
      Result.LoginPrompt :=false;
    Result.Connected :=false;
    connStr := 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=admin;Data Source=%s;Mode=%s;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=%s;Jet OLEDB:Engine Type=5;';
    connStr := Format(connStr,[dbfilename,aMode,aPwd]);
    Result.ConnectionString :=  connStr;
    try
      Result.Connected := true;
    except
      Result.Free;
      Result :=nil;
      raise EMDBConnectionException.Create(dbfileName);
    end;
  end;

  function GetMdbCDS(aDSProvider:TDataSetProvider;aCommandText:string):TClientDataSet;
  begin
    Result := TClientDataSet.Create(nil);
    Result.SetProvider(aDSProvider);
    Result.CommandText:=aCommandText;
    Result.Active:=true;
  end;
  function GetMdbProvider(aDs:TDataSet;aOptions :TProviderOptions =[poAllowCommandText,poUseQuoteChar];aUpdateMode :TUpdateMode =upWhereKeyOnly):TDataSetProvider;
  begin
    Result := TDataSetProvider.Create(nil);
    Result.Options := aOptions;
    Result.UpdateMode := aUpdateMode;
    Result.DataSet := aDs;
  end;
  function GetMdbAdoQuery(aConn:TADOConnection;aSql:string=''):TADOQuery;
  begin
    Result := TADOQuery.Create(nil);
    Result.Connection := aConn;
    Result.SQL.Text := aSql;
  end;



procedure DecryptExamineeInfoCDS(cds:TClientDataSet;AIncludeScoreField:Boolean =false);
begin
  with cds do
  begin
    if not Active  then   active := True;
    first;
    while not eof do
    begin
      edit;
      fieldvalues[DFNEI_EXAMINEEID] := DecryptStr(Fieldbyname(DFNEI_EXAMINEEID).AsString);
      fieldvalues[DFNEI_EXAMINEENAME] := DecryptStr(Fieldbyname(DFNEI_EXAMINEENAME).AsString);
      fieldvalues[DFNEI_IP] := DecryptStr(Fieldbyname(DFNEI_IP).AsString);
      fieldvalues[DFNEI_PORT] := DecryptStr(Fieldbyname(DFNEI_PORT).AsString);
      fieldvalues[DFNEI_STATUS] := DecryptStr(Fieldbyname(DFNEI_STATUS).AsString);
      fieldvalues[DFNEI_REMAINTIME] := DecryptStr(Fieldbyname(DFNEI_REMAINTIME).AsString);
      fieldvalues[DFNEI_TIMESTAMP] := DecryptStr(Fieldbyname(DFNEI_TIMESTAMP).AsString);
      if AIncludeScoreField  then
        DecryptExamineeInfoCDSScoreInfo( cds);
      post;
      next;
    end;
    First;
  end;
end;

procedure EncryptExamineeInfoCDS(cdsSource:TClientDataSet;cdsTarget:TClientDataSet;AIncludeScoreField:Boolean =false);
begin
  with cdsSource do
  begin
    if not Active  then   active := True;
    if not cdsTarget.Active  then  cdsTarget.Active :=true;

    first;
    while not eof do
    begin
      cdsTarget.AppendRecord([EncryptStr(Fieldbyname(DFNEI_EXAMINEEID).AsString),
                              EncryptStr(Fieldbyname(DFNEI_EXAMINEENAME).AsString),
                              EncryptStr(Fieldbyname(DFNEI_IP).AsString),
                              EncryptStr(Fieldbyname(DFNEI_PORT).AsString),
                              EncryptStr(Fieldbyname(DFNEI_REMAINTIME).AsString),
                              EncryptStr(Fieldbyname(DFNEI_TIMESTAMP).AsString)]
                              );
      if AIncludeScoreField  then
         EncryptExamineeInfoCDSScoreInfo( cdsTarget);
      next;
    end;
  end;
end;

procedure DecryptExamineeInfoCDSScoreInfo(DataSet: TDataSet);
var
  stream : TMemoryStream;
begin
  stream := TMemoryStream.Create;
  with DataSet do begin
    try
      stream.Clear;
      (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(stream);
      stream.Position := 0;
      UnCompressStream(stream);
      stream.Position := 0;
      (FieldByName('DFNEI_SCOREINFO') as TBlobField).LoadFromStream(stream);
    finally
      stream.Free;
    end;
  end;
end;

procedure EncryptExamineeInfoCDSScoreInfo(DataSet: TDataSet);
var
  stream : TMemoryStream;
begin
  stream := TMemoryStream.Create;
  with DataSet do begin
    try
      edit;
      stream.Clear;
      (FieldByName(DFNEI_SCOREINFO) as TBlobField).SaveToStream(stream);
      stream.Position := 0;
      CompressStream(stream);
      stream.Position := 0;
      (FieldByName('DFNEI_SCOREINFO') as TBlobField).LoadFromStream(stream);
      Post;
    finally
      stream.Free;
    end;
  end;
end;

function VarToInt(const V:Variant):Integer;
begin
  if not VarIsNull(V) then
     Result := V
  else
     Result := 0;
end;

procedure AssignValueToRichEdit(value: Variant; ARichEdit: TCustomMemo);
var
  //strStream : TStringStream;
  stream: TMemoryStream;
begin
  //strStream := TStringStream.Create(value);
  stream := TMemoryStream.Create;
  try
    VariantToStream(value,stream);
    UnCompressStream(stream);
    ARichEdit.Lines.LoadFromStream(stream);
  finally
    stream.Free;
  end;

end;

function StringsToVairant(strings: TStrings): Variant;
var
  //strStream:TStringStream;
  tempStream : TMemoryStream;
  str:string;
begin
  Result := '';
  //strStream := TStringStream.Create('');
  tempStream := TMemoryStream.Create;
  try
    strings.SaveToStream(tempStream);
    CompressStream(tempStream,clDefault);
    //tempStream.SaveToStream(strStream);
    //strStream.Position :=0;
    //Result := strStream.ReadString(strStream.Size);
    result:=streamtovariant(tempStream);
  finally
    //strStream.Free;
    tempStream.Free;
  end;
end;



procedure WriteTQStAnswerEnvironmentByID(const AID: string; ATQConn : TAdoConnection; const ATQ : TTQ);
var
  setTemp: TADODataSet;
  procedure WriteStreamToField(AFieldName : string; const AStream:TMemoryStream);
  begin
     if Assigned(AStream)  then
       (setTemp.FieldByName(AFieldName) as TBlobField).LoadFromStream(AStream);
  end;
begin
    setTemp:=TADODataSet.Create(nil);
    with setTemp do
    begin
      try
        Connection:=ATQConn;
        CommandText:= SQLSTR_GETTQDATASET_BY_STNO;//'select * from 试题 where st_no= :stno';
        Parameters[0].Value:= AID;
        Active:=true;
        if not IsEmpty then
        begin
           Edit;
           with ATQ,setTemp do begin
                  //FieldValues[DFNTQ_ST_NO] := St_no;
                  //WriteStreamToField(DFNTQ_CONTENT,Content);
                  WriteStreamToField(DFNTQ_STANSWER,StAnswer);
                  WriteStreamToField(DFNTQ_ENVIRONMENT,Environment);
                  //WriteStreamToField(DFNTQ_COMMENT,Comment);
           end;
        end;
      finally
        Post;
        setTemp.Free;
      end;
    end;
end;



procedure AppendTQToDB(const ADS:TDataSet; const ATQ:TTQ);
   procedure WriteStreamToField(AFieldName : string; const AStream:TMemoryStream);
  begin
     if Assigned(AStream)  then
       (ads.FieldByName(AFieldName) as TBlobField).LoadFromStream(AStream);
  end;
begin
   with ATQ,ADS do begin
      ADS.AppendRecord([St_no]);
      Edit;
      WriteStreamToField(DFNTQ_CONTENT,Content);
      WriteStreamToField(DFNTQ_STANSWER,StAnswer);
      WriteStreamToField(DFNTQ_ENVIRONMENT,Environment);
      WriteStreamToField(DFNTQ_COMMENT,Comment);
      Post;
   end;
end;

//procedure ReadTQFromDB(const AID: string; ATQDm : ITQDataModule; out ATQ : TTQ);
//var
//  setTemp: TADODataSet;
//begin
//    setTemp:=TADODataSet.Create(nil);
//    with setTemp do
//    begin
//      try
//        Connection:= ATQDm.GetTQDBConn;
//        CommandText:= 'select * from 试题 where st_no= :stno';
//        Parameters[0].Value:= AID;
//        Active:=true;
//        ETQRecordNotFoundException.IfTrue(IsEmpty,Format(RSTQRecordNotFound,[AID]));
//        if not Assigned(ATQ) then
//            ATQ := TTQ.Create;
//        TTq.WriteFieldValuesToTQ(setTemp,ATQ);
//      finally
//        setTemp.Free;
//      end;
//    end;
//end;

//procedure WriteFieldValuesToTQ(const ADS:TDataSet; var ATQ:TTQ);
//   procedure WriteFieldValueToStream(AFieldName : string; out AStream:TMemoryStream);
//   begin
//     if not Assigned(AStream) then AStream := TMemoryStream.Create;
//     try
//       (ADS.FieldByName(AFieldName) as TBlobField).SaveToStream(AStream);
//     except
//       AStream.Free;
//       raise;
//     end;
//   end;
//begin
//   with ATQ,ADS do begin
//               St_no := FieldValues[DFNTQ_ST_NO];
//               WriteFieldValueToStream(DFNTQ_CONTENT,Content);
//               WriteFieldValueToStream(DFNTQ_STANSWER,StAnswer);
//               WriteFieldValueToStream(DFNTQ_ENVIRONMENT,Environment);
//               WriteFieldValueToStream(DFNTQ_COMMENT,Comment);
//   end;
//end;
{$REGION '以下几个函数用来处理 试题表 数据的读写'}
//==============================================================================
// 以下几个函数用来处理 试题表 数据的读写
// 并进行加、解密 处理
// function GetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string): Variant;
///the following procedure get test question db record from db and fill ATQ （class TTQ) record
/// because Test question is compress ,then need uncompress
///
///base ID find record then update,so don't used as insert new reocrd
//==============================================================================
//procedure ReadTQByIDAndUnCompress(const AID: string; ATQDm : ITQDataModule; out ATQ : TTQ);
//begin
//   ReadTQFromDB(AID,ATQDm,ATQ);
//   atq.UnCompressTQ;
//end;

//procedure ReadTQAndUnCompressFromDS(ADs:TDataSet; out ATQ : TTQ);
//begin
//   if not Assigned(ATQ) then
//      ATQ := TTQ.Create;
//   TTQ.WriteFieldValuesToTQ(ADs,ATQ);
//   atq.UnCompressTQ;
//end;

//procedure CompressAndWriteTQByID(var ATQ: TTQ; ATQDm: ITQDataModule; AWriteOptions: TTQWriteOptions);
//begin
//   atq.CompressTQ;
//   ATQ.WriteTQ2DB(ATQDm,AWriteOptions );
//end;

//procedure UnCompressTQ(var ATQ:TTQ);
//begin
//   with ATQ do begin
//      UnCompressStream(Content);
//      UnCompressStream(StAnswer);
//      UnCompressStream(Environment);
//      UnCompressStream(Comment);
//   end;
//end;

//procedure CompressTQ(var ATQ:TTQ);
//begin
//    with ATQ do begin
//      CompressStream(Content);
//      CompressStream(StAnswer);
//      CompressStream(Environment);
//      CompressStream(Comment);
//   end;
//end;

function StreamToStr(AStream:TMemoryStream):string;
var
   list : TStringStream;
begin
   list := TStringStream.Create('');
   try
      AStream.SaveToStream(list);
      Result := list.DataString;
   finally
      list.Free;
   end;
end;

procedure StrToStream(str:string;out AStream:TMemoryStream);
var
   strStream : TStringStream;
begin
   if str='' then begin
     AStream.Clear;
   end else begin
      if AStream=nil then AStream:= TMemoryStream.Create();
      strStream := TStringStream.Create(str);
      try
         AStream.LoadFromStream(strStream);
      finally
         strStream.Free;
      end;
   end;
end;

//procedure StringsToStream(str:string;out AStream:TMemoryStream);
//var
//   list : TStringList;
//begin
//   if AStream=nil then AStream:= TMemoryStream.Create;
//   list := TStringList.Create;
//   try
//      if str='' then begin
//         AStream.Clear;
//      end else begin
//         list.Text := str;
//         list.SaveToStream(AStream);
//      end;
//   finally
//      list.Free;
//   end;
//end;
{$ENDREGION}

{$REGION '数据库操作'}
//==============================================================================
// 以下几个函数用来处理数据库操作
//==============================================================================
function GetTQIDByPreFix(const APreFix : string;const AConn: TADOConnection) :string;
var
  qry : TADOQuery;
begin
  qry := TADOQuery.Create(nil);
  try
    qry.Connection := AConn;
    qry.SQL.Add(SQLSTR_GETTQID_BY_PREFIX);
    qry.Parameters[0].Value := APreFix;
    qry.Active := True;
    if qry.RecordCount =1 then
      Result := qry.FieldValues[DFNTQ_ST_NO];
  finally
    qry.Free;
  end;
end;

function GetDataSetByPreFix(const APreFix : string;const AConn: TADOConnection) : TDataSet;
var
  ds : TADODataSet;
begin
  ds := TADODataSet.Create(nil);
  try
    ds.Connection := AConn;
    ds.CommandText :=SQLSTR_GETTQDATASET_BY_PREFIX;
    ds.Parameters[0].Value := APreFix;
    ds.Active := True;
    Result := ds;
  except
    ds.Free;
    raise;
  end;
end;

function GetDataSetBySQL(const ASQLStr : string;const AParamValue : Variant ;const AConn: TADOConnection) : TDataSet;
var
  ds : TADODataSet;
begin
  ds := TADODataSet.Create(nil);
  try
    ds.Connection := AConn;
    ds.CommandText :=ASQLStr;
    ds.Parameters[0].Value := AParamValue;
    ds.Active := True;
    Result := ds;
  except
    ds.Free;
    raise;
  end;
end;

procedure UpdateClientDBRemainTime(const aremainTime : integer;const AConn: TADOConnection) ;
var
  qry : TADOQuery;
  result:integer;
begin
  qry := TADOQuery.Create(nil);
  try
    qry.Connection := AConn;
    qry.SQL.Add(SQLSTR_UPDATECLIENTDBREAMINTIME);
    qry.Parameters[0].Value :=EncryptStr(IntToStr( aremainTime));
    result:=qry.ExecSQL;
  finally
    qry.Free;
  end;
end;
{$ENDREGION}

{$region '------考生信息处理相关函授------'}
procedure UnCompressScoreInfoFieldToField(sourceField,targetField:TField);
var
  stream : TMemoryStream;
begin
  stream := TMemoryStream.Create;
    try
      stream.Clear;
      (sourceField as TBlobField).SaveToStream(stream);
      stream.Position := 0;
      UnCompressStream(stream);
      targetField.DataSet.Edit;
      (targetField as TBlobField).LoadFromStream(stream);
      targetField.DataSet.Post;
    finally
      stream.Free;
    end;
end;
{$endregion '------考生信息处理相关函授------'}
{$REGION 'obsolete'}
//procedure VariantToStream (const v : Variant; Stream : TMemoryStream);
//var
//   p : pointer;
//begin
//   Stream.Position := 0;
//   Stream.Size := VarArrayHighBound (v, 1) - VarArrayLowBound (v, 1) + 1;
//   p := VarArrayLock (v);
//   Stream.Write (p^, Stream.Size);
//   VarArrayUnlock (v);
//   Stream.Position := 0;
//end;
//procedure VariantToStream (const v : Variant; Stream : TMemoryStream);
//var
//   p : pointer;
//   str:string;
//   strStream:TStringStream;
//begin
//   Stream.Position := 0;
//
//   str := VarToStr(v);
//   strStream := TStringStream.Create(str);
//   stream.CopyFrom(strStream,strStream.Size);
//  // UnCompressStream(Stream);
//  // Stream.Write (p^, Stream.Size);
//   //VarArrayUnlock (v);
//   Stream.Position := 0;
//end;

//procedure StreamToVariant (Stream : TMemoryStream; var v : Variant);
//var
//   p : pointer;
//begin
//   v := VarArrayCreate ([0, Stream.Size - 1], varByte);
//   p := VarArrayLock (v);
//   Stream.Position := 0;
//   Stream.ReadBuffer(p^, Stream.Size);
//   VarArrayUnlock (v);
//end;

///new data access procedure
//procedure WriteTQ2DB(const ATQ: TTQ; ATQDm: ITQDataModule);
//var
//  setTemp: TADODataSet;
//  procedure WriteStreamToField(AFieldName : string; const AStream:TMemoryStream);
//  begin
//     if Assigned(AStream)  then
//       (setTemp.FieldByName(AFieldName) as TBlobField).LoadFromStream(AStream);
//  end;
//begin
//    setTemp:=TADODataSet.Create(nil);
//    with setTemp do
//    begin
//      try
//        Connection:=ATQDm.GetTQDBConn;
//        CommandText:= 'select * from 试题 where st_no= :stno';
//        Parameters[0].Value:= ATQ.St_no;
//        Active:=true;
//         //如果没找到给定试题编号记录，则添加新记录，并写入试题编号
//         //如找到则更新该记录
//        if IsEmpty then  setTemp.AppendRecord([ATQ.St_no]);
//         with ATQ,setTemp do begin
//            Edit;
//            WriteStreamToField(DFNTQ_CONTENT,Content);
//            WriteStreamToField(DFNTQ_STANSWER,StAnswer);
//            WriteStreamToField(DFNTQ_ENVIRONMENT,Environment);
//            WriteStreamToField(DFNTQ_COMMENT,Comment);
//         end;
//      finally
//        Post;
//        setTemp.Free;
//      end;
//    end;
//end;
//procedure WriteTQStAnswerByID(const AID: string; ATQDm : ITQDataModule; const ATQ : TTQ);
//var
//  setTemp: TADODataSet;
//  procedure WriteStreamToField(AFieldName : string; const AStream:TMemoryStream);
//  begin
//     if Assigned(AStream)  then
//       (setTemp.FieldByName(AFieldName) as TBlobField).LoadFromStream(AStream);
//  end;
//begin
//    setTemp:=TADODataSet.Create(nil);
//    with setTemp do
//    begin
//      try
//        Connection:=ATQDm.GetTQDBConn;
//        CommandText:= 'select * from 试题 where st_no= :stno';
//        Parameters[0].Value:= AID;
//        Active:=true;
//        if not IsEmpty then
//        begin
//           Edit;
//           with ATQ,setTemp do begin
//                  //FieldValues[DFNTQ_ST_NO] := St_no;
//                  //WriteStreamToField(DFNTQ_CONTENT,Content);
//                  WriteStreamToField(DFNTQ_STANSWER,StAnswer);
//                  //WriteStreamToField(DFNTQ_ENVIRONMENT,Environment);
//                  //WriteStreamToField(DFNTQ_COMMENT,Comment);
//           end;
//        end;
//      finally
//        Post;
//        setTemp.Free;
//      end;
//    end;
//end;
{$ENDREGION}
end.
