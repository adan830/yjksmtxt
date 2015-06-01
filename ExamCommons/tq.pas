unit tq;

//==============================================================================
// ��ʾ�����¼����
//==============================================================================
interface

uses
  Classes, ADODB,DB;

type
   TTQReadWriteOption  =(rwoStNO ,rwoContext, rwoEnvironment,rwoStAnswer,rwoKsda,rwoComment,rwoPointID,
                        rwoTimeStamp,rwoDifficulty,rwoTotalRight,rwoTotalUsed,
                        rwoRedactTime,rwoRedactor,rwoIsModified);
   TTQReadWriteOptions = set of TTQReadWriteOption;
   //д���µĿ�����
const
   //���ڿ������ݿ��У���ȡ��TQ�У���������ksda
   TQReadWriteOptionsNormal = [rwoStNO,rwoContext, rwoEnvironment,rwoStAnswer,rwoKsda,rwoComment,rwoDifficulty];
   //���ڶ�ȡTQ��Ҫ�������ֶ�ֵ ����Ҳ������ksda
   TQReadWriteOptionsAllTQFields = [ rwoStNO ,rwoContext, rwoEnvironment,rwoStAnswer,rwoComment,
                                 rwoDifficulty, rwoRedactTime,rwoRedactor,rwoIsModified ];
type
//TTQWriteOptionsNewExamBase =
   
   //��ʾ����ѹ��״̬
   TCompressState = (csNo,csYes,csFault);

//==============================================================================
// ���� ��Ϊ��ӡ���ȡ �����¼���ֻ࣬�������������Ҫ�ֶ�
//==============================================================================
  TTQ = class
  private
//==============================================================================
// ���������ú�������д�����ݵ��ַ����б��������߼���д��������
//==============================================================================
    procedure ReadStreamToStrings(const AStream : TMemoryStream; AStrings : TStrings);
    procedure WriteStringsToStream(const AStrings: TStrings; var AStream: TMemoryStream);

  public

//------------------------------------------------------------------------------
// ���±��������ݿ�������ֶζ�Ӧ��������Ӧ��ֵ
//------------------------------------------------------------------------------
    St_no            : string;
    Content          : TMemoryStream;
    StAnswer         : TMemoryStream;
    Environment      : TMemoryStream;
    Comment          : TMemoryStream;
    Difficulty       : Integer;
    //�����ֶ�ֻ�����������
    Redactor         : string;
    RedactTime       : TDateTime;
    IsModified       : Boolean;

    FCompressState   : TCompressState ;                 //�����Ƿ�ѹ�����
    FWriteOption     : TTQReadWriteOptions;         //д���ݱ�־λ��ȷ����Щ���ݽ���д�����ݿ��ֶ�

    constructor Create();
    destructor Destroy(); override;
    procedure ClearData();

//==============================================================================
// ���º���ֻ������ ��ȡ ��ѹ���������������δ����ǰ���д���
// ���漰���ݿ����
//==============================================================================
    procedure ReadContentToStrings(AStrings : TStrings);
    procedure ReadStAnswerToStrings(AStrings : TStrings);
    procedure ReadEnvironmentToStrings(AStrings : TStrings);
    procedure ReadCommentToStrings(AStrings : TStrings);
    function ReadStAnswerStr():string;
//==============================================================================
// ���º���ֻ������ ���� �����У���δ����ѹ��
// ���漰���ݿ����
//==============================================================================
    procedure WriteStringsToContent(const AStrings : TStrings);
    procedure WriteStringsToStAnswer(const AStrings : TStrings);
    procedure WriteStringsToEnvironment(const AStrings : TStrings);
    procedure WriteStringsToComment(const AStrings : TStrings);
    procedure WriteStrToStAnswer(const str:string);

//==============================================================================
// ���º�����д���ݿ���TQ
//==============================================================================
    //procedure CompressAndWriteTQByID(var ATQ: TTQ; ATQDm: ITQDataModule);



//------------------------------------------------------------------------------
// ѹ��,��ѹ �������
//------------------------------------------------------------------------------
    procedure CompressTQ;
    procedure UnCompressTQ;

//------------------------------------------------------------------------------
// ��TQ����д��������ݿ�ĵ�ǰ��¼��  ����������
//------------------------------------------------------------------------------
    class procedure WriteFieldValuesToTQ(const ADS: TDataSet; var ATQ: TTQ;AWriteOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal); static;
//------------------------------------------------------------------------------
// ��TQ������ѹ����д�����ݿ��У�������������ȷ�����޸Ļ������
//------------------------------------------------------------------------------
    class procedure WriteCompressedTQ2DB(var ATQ: TTQ; ATQDBConn: TADOConnection; AWriteOptions: TTQReadWriteOptions =[]);
//------------------------------------------------------------------------------
// ��ATQDm�л�ȡ���ݿ����ӣ��ҿ����ݱ����ҵ�AIDָ���ļ�¼��Ȼ��
//               ���� WriteFieldValuesToTq ��ȡ���ݵ� ATQ�У�ֻ��ȡ����������
//------------------------------------------------------------------------------
    class procedure ReadTQFromDB(const AID: string; ATQDBConn : TADOConnection; out ATQ : TTQ;AReadOptions:TTQReadWriteOptions=TQReadWriteOptionsNormal);
//------------------------------------------------------------------------------
// д���ݵ�������У�����st_no���Ҽ�¼����ȷ������ԭ��¼�����������¼�¼��
// ��ATQDm�л�ȡ���ݿ����ӣ��ҿ����ݱ����ҵ�AIDָ���ļ�¼��Ȼ��
// ���� WriteStreamToField ��ATQ�����ݷֱ�д�����ݼ��ֶ��У�������ATQ�����ݽ��д���
//------------------------------------------------------------------------------
    class procedure WriteTQ2DB(ATQ:TTQ;ATQDBConn: TADOConnection; ATQWriteOptions: TTQReadWriteOptions);

    //==============================================================================
// ���¼��������������� ����� ���ݵĶ�д
// �����мӡ����� ����
// function GetDBRecordFieldValues(const ASqlStr:string; const AParamValues:Variant;const FieldNames: string): Variant;
///the following procedure get test question db record from db and fill ATQ ��class TTQ) record
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
// TClientEQRecordPacket���ڿ��Է�������ͻ���֮�䴫��������
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
         //���û�ҵ����������ż�¼��������¼�¼����д��������
         //���ҵ�����¸ü�¼
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

            //дʱ�����¼������
            // 1. ����д���������   : st4,difficulty,redactor,redacttime
            // 2. д�������ÿ�       : st4,difficulty
            // 3. д��������         : st4,
            // 4. ����ֿ�д���ܿ�   : st4,redactor,redacttime
            // TotalRight,Totalused,Difficult:ֻ��ͳ�Ƴɼ�ʱ���£��������������д��
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
         //û��д���ֶ� ������ ֵ
         if rwoComment in AWriteOptions    then  WriteFieldValueToStream(DFNTQ_COMMENT,Comment);
         if rwoDifficulty in AWriteOptions    then  Difficulty := FieldByName(DFNTQ_DIFFICULTY).AsInteger;
         { TODO : һ�������ȡ�����ֶΣ���������ʱ }
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
