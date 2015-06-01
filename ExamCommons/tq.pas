unit tq;

//==============================================================================
// 表示试题记录的类
//==============================================================================
interface

uses
  Classes, ADODB,DB;

type
   TTQReadWriteOption  =(rwoStNO ,rwoContext, rwoEnvironment,rwoStAnswer,rwoKsda,rwoComment,rwoPointID,
                        rwoTimeStamp,rwoDifficulty,rwoTotalRight,rwoTotalUsed,
                        rwoRedactTime,rwoRedactor,rwoIsModified);
   TTQReadWriteOptions = set of TTQReadWriteOption;
   //写入新的考生库
const
   //用于考生数据库中，读取到TQ中，但不包括ksda
   TQReadWriteOptionsNormal = [rwoStNO,rwoContext, rwoEnvironment,rwoStAnswer,rwoKsda,rwoComment,rwoDifficulty];
   //用于读取TQ需要的所有字段值 ，但也不包括ksda
   TQReadWriteOptionsAllTQFields = [ rwoStNO ,rwoContext, rwoEnvironment,rwoStAnswer,rwoComment,
                                 rwoDifficulty, rwoRedactTime,rwoRedactor,rwoIsModified ];
type
//TTQWriteOptionsNewExamBase =
   
   //表示内容压缩状态
   TCompressState = (csNo,csYes,csFault);

//==============================================================================
// 本类 作为添加、读取 试题记录的类，只包含试题表中主要字段
//==============================================================================
  TTQ = class
  private
//==============================================================================
// 基础被调用函数，读写流数据到字符串列表，被其它高级读写函数调用
//==============================================================================
    procedure ReadStreamToStrings(const AStream : TMemoryStream; AStrings : TStrings);
    procedure WriteStringsToStream(const AStrings: TStrings; var AStream: TMemoryStream);

  public

//------------------------------------------------------------------------------
// 以下变量与数据库试题表字段对应，保存相应的值
//------------------------------------------------------------------------------
    St_no            : string;
    Content          : TMemoryStream;
    StAnswer         : TMemoryStream;
    Environment      : TMemoryStream;
    Comment          : TMemoryStream;
    Difficulty       : Integer;
    //以下字段只用于命题相关
    Redactor         : string;
    RedactTime       : TDateTime;
    IsModified       : Boolean;

    FCompressState   : TCompressState ;                 //数据是否压缩标记
    FWriteOption     : TTQReadWriteOptions;         //写数据标志位，确定哪些数据将被写入数据库字段

    constructor Create();
    destructor Destroy(); override;
    procedure ClearData();

//==============================================================================
// 以下函数只是用来 读取 解压缩后的流，不能在未解密前进行处理
// 不涉及数据库访问
//==============================================================================
    procedure ReadContentToStrings(AStrings : TStrings);
    procedure ReadStAnswerToStrings(AStrings : TStrings);
    procedure ReadEnvironmentToStrings(AStrings : TStrings);
    procedure ReadCommentToStrings(AStrings : TStrings);
    function ReadStAnswerStr():string;
//==============================================================================
// 以下函数只是用来 保存 到流中，但未进行压缩
// 不涉及数据库访问
//==============================================================================
    procedure WriteStringsToContent(const AStrings : TStrings);
    procedure WriteStringsToStAnswer(const AStrings : TStrings);
    procedure WriteStringsToEnvironment(const AStrings : TStrings);
    procedure WriteStringsToComment(const AStrings : TStrings);
    procedure WriteStrToStAnswer(const str:string);

//==============================================================================
// 以下函数读写数据库与TQ
//==============================================================================
    //procedure CompressAndWriteTQByID(var ATQ: TTQ; ATQDm: ITQDataModule);



//------------------------------------------------------------------------------
// 压缩,解压 相关数据
//------------------------------------------------------------------------------
    procedure CompressTQ;
    procedure UnCompressTQ;

//------------------------------------------------------------------------------
// 将TQ数据写入给定数据库的当前记录，  ？？？？？
//------------------------------------------------------------------------------
    class procedure WriteFieldValuesToTQ(const ADS: TDataSet; var ATQ: TTQ;AWriteOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal); static;
//------------------------------------------------------------------------------
// 将TQ中数据压缩后，写到数据库中，根据试题编号来确定是修改或是添加
//------------------------------------------------------------------------------
    class procedure WriteCompressedTQ2DB(var ATQ: TTQ; ATQDBConn: TADOConnection; AWriteOptions: TTQReadWriteOptions =[]);
//------------------------------------------------------------------------------
// 从ATQDm中获取数据库连接，找开数据表，查找到AID指定的记录，然后
//               利用 WriteFieldValuesToTq 读取数据到 ATQ中，只读取，并不解密
//------------------------------------------------------------------------------
    class procedure ReadTQFromDB(const AID: string; ATQDBConn : TADOConnection; out ATQ : TTQ;AReadOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal);
//------------------------------------------------------------------------------
// 写数据到试题库中，根据st_no查找记录，来确定更新原记录，或是增加新记录。
// 从ATQDm中获取数据库连接，找开数据表，查找到AID指定的记录，然后
// 利用 WriteStreamToField 将ATQ中数据分别写入数据集字段中，并不对ATQ中数据进行处理
//------------------------------------------------------------------------------
    class procedure WriteTQ2DB(ATQ:TTQ;ATQDBConn: TADOConnection; ATQWriteOptions: TTQReadWriteOptions);

    //==============================================================================
// 以下几个函数用来处理 试题表 数据的读写
// 并进行加、解密 处理
// function GetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string): Variant;
///the following procedure get test question db record from db and fill ATQ （class TTQ) record
/// because Test question is compress ,then need uncompress
///
///base ID find record then update,so don't used as insert new reocrd
//==============================================================================
    class procedure ReadTQAndUnCompressFromDS(ADs: TDataSet; out ATQ: TTQ); static;
    class procedure ReadTQByIDAndUnCompress(const AID: string; ATQDBConn: TADOConnection; out ATQ: TTQ;AReadOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal); static;
property
       CompressState  :TCompressState read FCompressState write FCompressState;
end;

//==============================================================================
// TClientEQRecordPacket用于考试服务器与客户端之间传递数据用
//==============================================================================
  PClientEQRecordPacket =^TClientEQRecordPacket;
  TClientEQRecordPacket= TTq;
implementation

uses
  SysUtils,   DataFieldConst,compress, ExamException, ExamResourceStrings;

{ TTQ }

procedure TTQ.ClearData;
begin
   St_no := '';
   Content.Clear;
   StAnswer.Clear;
   Environment.Clear;
   Comment.Clear;
   Difficulty := 0;
   Redactor := '';
   RedactTime := Now;
   IsModified := False;
end;



constructor TTQ.Create;
begin
   inherited Create;
   St_no := '';
   Content := TMemoryStream.Create;
   StAnswer := TMemoryStream.Create;
   Environment := TMemoryStream.Create;
   Comment := TMemoryStream.Create;
   Difficulty := 0;
   Redactor := '';
   RedactTime := 0;
   IsModified := False;
end;

destructor TTQ.Destroy;
begin
   if Assigned(Content) then FreeAndNil(Content);
   if Assigned(StAnswer)  then StAnswer.Free;
   if Assigned(Environment) then Environment.Free;
   if Assigned(Comment) then Comment.Free;
   inherited Destroy;
end;

procedure TTQ.ReadCommentToStrings(AStrings: TStrings);
begin
  ReadStreamToStrings(Comment,AStrings);
end;

procedure TTQ.ReadContentToStrings(AStrings: TStrings);
begin
  ReadStreamToStrings(Content,AStrings);
end;

procedure TTQ.ReadEnvironmentToStrings(AStrings: TStrings);
begin
  ReadStreamToStrings(Environment,AStrings);
end;

function TTQ.ReadStAnswerStr: string;
var
  strStream : TStringStream;
begin
  strStream := TStringStream.Create('');
  try
    StAnswer.SaveToStream(strStream);
    Result := strStream.DataString;
  finally
    strStream.Free;
  end;
end;

procedure TTQ.ReadStAnswerToStrings(AStrings: TStrings);
begin
  ReadStreamToStrings(StAnswer,AStrings);
end;

procedure TTQ.ReadStreamToStrings(const AStream: TMemoryStream; AStrings: TStrings);
begin
  AStream.Position := 0;
  AStrings.LoadFromStream(AStream);
end;

procedure TTQ.WriteStringsToComment(const AStrings: TStrings);
begin
  WriteStringsToStream(AStrings,Comment);
end;

procedure TTQ.WriteStringsToContent(const AStrings: TStrings);
begin
  WriteStringsToStream(AStrings,Content);
end;

procedure TTQ.WriteStringsToEnvironment(const AStrings: TStrings);
begin
  WriteStringsToStream(AStrings,Environment);
end;

procedure TTQ.WriteStringsToStAnswer(const AStrings: TStrings);
begin
  WriteStringsToStream(AStrings,StAnswer);
end;

procedure TTQ.WriteStringsToStream(const AStrings: TStrings;var AStream: TMemoryStream);
begin
  AStream.Clear;
  AStrings.SaveToStream(AStream);
end;

procedure TTQ.WriteStrToStAnswer(const str: string);
var
  strStream : TStringStream;
begin
  strStream := TStringStream.Create(str);
  try
    StAnswer.LoadFromStream(strStream);
  finally
    strStream.Free;
  end;
end;

class procedure TTQ.ReadTQFromDB(const AID: string; ATQDBConn : TADOConnection; out ATQ : TTQ;AReadOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal);
var
  setTemp: TADODataSet;
begin
    setTemp:=TADODataSet.Create(nil);
    with setTemp do
    begin
      try
        Connection:= ATQDBConn;
        CommandText:= SQLSTR_GETTQDATASET_BY_STNO;
        Parameters[0].Value:= AID;
        Active:=true;
        ETQRecordNotFoundException.IfTrue(IsEmpty,Format(RSTQRecordNotFound,[AID]));
        if not Assigned(ATQ) then
            ATQ := TTQ.Create;
        TTq.WriteFieldValuesToTQ(setTemp,ATQ,AReadOptions);
      finally
        setTemp.Free;
      end;
    end;
end;

class procedure TTQ.WriteTQ2DB(ATQ:TTQ;ATQDBConn: TADOConnection; ATQWriteOptions: TTQReadWriteOptions);
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
        Connection:= ATQDBConn;
        CommandText:= SQLSTR_GETTQDATASET_BY_STNO ;
        Parameters[0].Value:= ATQ.St_no;
        Active:=true;
         //如果没找到给定试题编号记录，则添加新记录，并写入试题编号
         //如找到则更新该记录
        if IsEmpty then  setTemp.AppendRecord([ATQ.St_no]);
         with ATQ,setTemp do begin
            Edit;
            WriteStreamToField(DFNTQ_CONTENT,Content);
            WriteStreamToField(DFNTQ_STANSWER,StAnswer);
            WriteStreamToField(DFNTQ_ENVIRONMENT,Environment);
            WriteStreamToField(DFNTQ_COMMENT,Comment);

            if rwoDifficulty in ATQWriteOptions then  FieldByName(DFNTQ_DIFFICULTY).Value := Difficulty;
            if rwoRedactor in ATQWriteOptions then  FieldByName(DFNTQ_REDACTOR).Value := Redactor;
            if rwoRedactTime in ATQWriteOptions then FieldByName(DFNTQ_REDACTTIME).Value := RedactTime;
            if rwoIsModified in ATQWriteOptions then FieldByName(DFNTQ_ISMODIFIED).Value := True;

            //写时有以下几种情况
            // 1. 导出写到分命题库   : st4,difficulty,redactor,redacttime
            // 2. 写到考试用库       : st4,difficulty
            // 3. 写到考生库         : st4,
            // 4. 导入分库写到总库   : st4,redactor,redacttime
            // TotalRight,Totalused,Difficult:只在统计成绩时更新，其它情况均均需写入
         end;
      finally
        Post;
        setTemp.Free;
      end;
    end;
end;

procedure TTQ.CompressTQ();
begin
   if compressState = csNo then begin
      try
         CompressStream(Content);
         CompressStream(StAnswer);
         CompressStream(Environment);
         CompressStream(Comment);
         compressState := csYes;
      except
         on E:exception do begin
           CompressState := csFault;
           raise;
         end;
      end;
   end;
end;

procedure TTQ.UnCompressTQ();
begin
   if compressState = csYes then begin
      try
         UnCompressStream(Content);
         UnCompressStream(StAnswer);
         UnCompressStream(Environment);
         UnCompressStream(Comment);
         compressState := csNo;
      except
         on E:exception do begin
           CompressState := csFault;
           raise;
         end;
      end;  
   end;
end;
                   //?????
class procedure TTQ.WriteFieldValuesToTQ(const ADS:TDataSet; var ATQ:TTQ;AWriteOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal);
   procedure WriteFieldValueToStream(AFieldName : string; out AStream:TMemoryStream);
   begin
     if not Assigned(AStream) then AStream := TMemoryStream.Create;
     try
       (ADS.FieldByName(AFieldName) as TBlobField).SaveToStream(AStream);
     except
       AStream.Free;
       raise;
     end;
   end;
begin
   with ATQ,ADS do begin
      try
         if rwoStNO in AWriteOptions    then  St_no := FieldValues[DFNTQ_ST_NO];
         if rwoContext in AWriteOptions then  WriteFieldValueToStream(DFNTQ_CONTENT,Content);
         if rwoEnvironment in AWriteOptions    then  WriteFieldValueToStream(DFNTQ_ENVIRONMENT,Environment);
         if rwoStAnswer in AWriteOptions    then  WriteFieldValueToStream(DFNTQ_STANSWER,StAnswer);
         //没有写入字段 考生答案 值
         if rwoComment in AWriteOptions    then  WriteFieldValueToStream(DFNTQ_COMMENT,Comment);
         if rwoDifficulty in AWriteOptions    then  Difficulty := FieldByName(DFNTQ_DIFFICULTY).AsInteger;
         { TODO : 一般无需读取以下字段，除非命题时 }
         if rwoRedactor in AWriteOptions    then  Redactor := FieldByName(DFNTQ_REDACTOR).AsString;
         if rwoRedactTime in AWriteOptions    then  RedactTime := FieldByName(DFNTQ_REDACTTIME).AsDateTime;
         if rwoIsModified in AWriteOptions    then  IsModified := FieldByName(DFNTQ_ISMODIFIED).AsBoolean;
         CompressState := csYes;
      except
         on Exception do begin
            CompressState := csFault;
            raise;
         end;
      end;  

   end;
end;


class procedure TTQ.WriteCompressedTQ2DB(var ATQ: TTQ; ATQDBConn: TADOConnection; AWriteOptions: TTQReadWriteOptions = []);
begin
   atq.CompressTQ;
   TTQ.WriteTQ2DB(ATQ,ATQDBConn,AWriteOptions );
end;

class procedure TTQ.ReadTQByIDAndUnCompress(const AID: string; ATQDBConn : TADOConnection; out ATQ : TTQ;AReadOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal);
begin
   ReadTQFromDB(AID,ATQDBConn,ATQ,AReadOptions);
   atq.UnCompressTQ;
end;

class procedure TTQ.ReadTQAndUnCompressFromDS(ADs:TDataSet; out ATQ : TTQ);
begin
   if not Assigned(ATQ) then
      ATQ := TTQ.Create;
   TTQ.WriteFieldValuesToTQ(ADs,ATQ);
   atq.UnCompressTQ;
end;

end.
