unit Commons;

{
   This file include common function for examine environment and Grade;
}
interface
uses Classes,  uGrade, sysutils, ExamInterface, DB, ExamGlobal, Vcl.Forms,Vcl.Controls;
const
	CONSTWILDCARD='%';
type
  parray=array [0..4]of pchar;

  //考试类型模块枚举类型
  TFormMode=(SINGLESELECT_MODEL=0,MULTISELECT_MODEL=1,TYPE_MODEL=2,WINDOWS_MODEL=3,WORD_MODEL=4,EXCEL_MODEL=5,POWERPOINT_MODEL=6);//,IE_MODEL=7);
  TExamModule =(EMSINGLESELECT=0,EMMULTISELECT=1,EMTYPE=2,EMWINDOWS=3,EMWORD=4,EMEXCEL=5,EMPOWERPOINT=6);//,EMIE=7);

  

  //字符串加密  解密
   function EncryptStr(const Src: String; const Key: String=SYSKEY): String; //stdcall; export
   function DecryptStr(const Src: String; const Key: String=SYSKEY): String; //stdcall; export

   //删除字符串中特殊字符：回车，','
   function  DelStrChar(const Value: string):string; //stdcall;

  //操作题评分及环境生成相关方法

  //将生成试题环境的命令字符串转换成数组指针
  //已被移走
  //procedure GetCommandParam(var commandstring:string; var param:parray);
//==============================================================================
// 格式化选择题评分信息字符串
//==============================================================================
   function FormatSelectGradeInfo(AID, AExamValue: string; IsRight: Boolean): string;
  //将字符串转换成 TGradeInfo 记录
//    procedure StrToGradeInfo( Content:string;var GradeInfo:TGradeInfo);  overload ;
    function StrToGradeInfo(Content:string;var GradeInfo:TGradeInfo;chr:char=','):Integer; //stdcall;
//    function GradeInfoToStr(GradeInfo: TGradeInfo):string; overload;
    function GradeInfoToStr(GradeInfo: TGradeInfo;chr:char=','):string;   //stdcall ;
    //评分信息中获得得分
    function GradeinfoStringsToScore(GradeInfoStrings:TStringList):integer;
    function GradeInfoStringsToScoreInfoStrings(EQID:string;GradeInfoStrings:TStrings;chr:char=','):TStrings;

  //将字符串转换成TEnvironmentInfo记录
    procedure StrToEnvironmentItem( Content:string;var AEnvironmnetItem:TEnvironmentItem);
    function EnvironmnetInfoToStr(AEnvironmentItem: TEnvironmentItem):string;

  //将字符串转换成TScoreInfo记录
    procedure StrToScoreInfo( Content:string;var ScoreInfo:TScoreInfo;chr:char=',');
    procedure StrToModuleInfo( Content:string;var AModuleInfo:TModuleInfo;chr:char=','); //stdcall;
    //overload for clients and mt
{$region  '------建立考试环境------' }
//==============================================================================
// 建立考试环境相关过程
//==============================================================================
   //2009.5.4日，以下几个函数被废弃，因为Environment字段，直接存取文档或文件夹的压缩包
    procedure GetEnvironmentStrings(AEQType:string;ADataModule:ITQDataModule;var AStrList:TStringList);
    procedure GetEnvironmentStringsByPrefix(APrefix:string;ds:TDataSet;var AStrList:TStringList);
    function CreateExamEnvironment(APath: string; AEnvironmentStrings: TStrings; AExamTcpClient: IExamTcpClient) : Integer;  //stdcall ;//exports
    //2009.5.4日创建，因为Environment字段，直接存取文档或文件夹的压缩包
    //从流中内容来生成操作题文档，用在word,excel,ppt操作题中
    procedure CreateOperateDoc(AFileName:string; AEnvironStream:TMemoryStream) ;
    //从流中读取文件，然后解压到目录中，生成windows题的操作环境的目录树
    procedure CreateOperateDir(APath:string;AEnvironStream:TMemoryStream);
//==============================================================================
// 根据模块来找到试题记录，创建操作文档环境
//==============================================================================
   function CreateExamEnvironmentByModules(APath: string; AModules :TModules;ADs:TDataSet) : Integer;
   procedure CreateOperateEnvironmentByModule(AModule :TModuleInfo;APath :string ; ds:TDataSet);

{$ENDREGION}
    // 根据模式确定试题编号前辍字符
    function GetRecordNoPreFlag(aMode: TFormMode): string;

    function GetApplicationPath():string;
     //显示消息窗口在顶层
    function MessageBoxOnTopForm(App:TApplication;AText, ACaption: string; AFlags: integer): Integer; //stdcall;

    //about directory
    function DeleteDir(ADicPath:TfileName):integer; //stdcall;

    /// <summary>
    /// 删除文件，删除前弹出提示对话框
    /// </summary>
    /// <param name="AFileName">需删除的文件</param>
    /// <returns>成功删除则返回真，反之为否</returns>
    function DeleteFileWithPrompt(AFileName:TFileName):Boolean;

//==============================================================================
// 一般通用函数
//==============================================================================
    procedure VariantToStream(const Data: OleVariant; Stream: TStream);
    function StreamToVariant(Stream: TStream): OleVariant;



implementation
//uses sysutils,adodb,datamodule,forms;
//为集中评分而改
  uses shellapi, NetGlobal,DataFieldConst,compress,Variants, ExamException, 
  ExamResourceStrings,IOUtils,windows;    // udmMain
//字符串加密
function EncryptStr(const Src: String; const Key: String=SYSKEY): String;
var
  KeyLen :Integer;
  KeyPos :Integer;
  offset :Integer;
  dest :string;
  SrcPos :Integer;
  SrcAsc :Integer;
  Range :Integer;
  srcraw: rawbytestring;
begin
  if Length(Src)=0 then begin
    Result := '';
    Exit;
  end;
  KeyLen:=Length(Key);
  srcraw:=src;
  KeyPos:=0;
  Range:=256;

  Randomize;
  offset:=Random(Range);
  dest:=format('%1.2x',[offset]);
  for SrcPos := 1 to Length(srcraw) do
  begin
    SrcAsc:=(Ord(srcraw[SrcPos]) + offset) MOD 255;
    if KeyPos < KeyLen then
      KeyPos:= KeyPos + 1
    else
      KeyPos:=1;
    SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
    dest:=dest + format('%1.2x',[SrcAsc]);
    offset:=SrcAsc;
  end;
  Result:=Dest;
end;

//字符串解密
function DecryptStr(const Src: String; const Key: String=SYSKEY): String;
var
  KeyLen :Integer;
  KeyPos :Integer;
  offset :Integer;
  noff:Integer;
  dest :string;
  SrcPos :Integer;
  SrcAsc :Integer;
  sTemp:string;
  destBytes:PByte;
begin
  if Length(Src)=0 then begin
    Result := '';
    Exit;
  end;
  KeyLen:=Length(Key);
  KeyPos:=0;
  sTemp:='$'+src[1]+src[2];
  offset:=strtoint(sTemp);
  getmem(destBytes,(Length(Src)-2) div 2 +1 );
  for SrcPos := 2 to Length(Src) div 2 do
  begin
    if KeyPos < KeyLen then
      KeyPos:= KeyPos + 1
    else
      KeyPos:=1;
    SrcAsc:=strtoint('$'+src[SrcPos*2-1]+src[SrcPos*2]);
    noff:=SrcAsc;
    SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
    if SrcAsc<offset then
      srcasc:=SrcAsc+255;
    SrcAsc:=SrcAsc-offset;
    destBytes[srcpos-2]:= srcasc;
    offset:=noff;
  end;
  destBytes[srcpos-2]:= 0;
  dest:=pansichar(destbytes);
  freemem(destbytes);
  Result:=dest;
end;

//procedure GetCommandParam(var commandstring:string; var param:parray);
//var
//  temp:pchar;
//  count:integer;
//begin
//
//  for count:=0 to 4 do begin
//    param[count]:=nil;
//  end;
//  temp:=pchar(commandstring);
//  count:=0;
//  while temp[0]<>#0 do
//  begin
//    param[count]:=temp;
//    temp:=strscan(temp,',');
//    temp[0]:=#0;
//    temp:=temp+1;
//    count:=count+1;
//  end;
//end;

//procedure StrToGradeInfo( Content:string;var GradeInfo:TGradeInfo);
//var
//  Head,Tail:pchar;
//  index:integer;
//begin
//  //这个函数的实现可参考extractstrings,setstring等
//  //它通过修改content中的分隔字符为#0，来完成将一个大字符串分隔成多个小字符串
//  //对content的修改，不影响它作为一个string的行为
//  Tail:=pchar(Content);
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.ID:=strtoint(Head);
//
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.ObjStr:=Head;
//
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.StandardValue:=Head;
////  Head:=Tail;
////  Tail:=strscan(Tail,',');
////  Tail^:=#0;
////  Tail:=Tail+1;
////  GradeInfo.ValueType:=strtoint(Head);
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.EQText:=Head;
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.Points:=strtoint(Head);
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.ExamineValue:=Head;
//  Head:=Tail;
//  Tail:=strscan(Tail,',');
//  Tail^:=#0;
//  Tail:=Tail+1;
//  GradeInfo.IsRight:=strtoint(Head);
//end;

function StrToGradeInfo(Content:string;var GradeInfo:TGradeInfo;chr:char=','):Integer;
var
  Head,Tail:pchar;
begin
  //这个函数的实现可参考extractstrings,setstring等
  //它通过修改content中的分隔字符为#0，来完成将一个大字符串分隔成多个小字符串
  //对content的修改，不影响它作为一个string的行为
  Tail:=pchar(Content);
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.ID:=strtoint(Head);

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.ObjStr:=Head;

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.StandardValue:=Head;
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.EQText:=Head;
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.Points:=strtoint(Head);
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.Exp:=Head;
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  GradeInfo.ExamineValue:=Head;
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  GradeInfo.IsRight:=strtoint(Head);
end;

//function GradeInfoToStr(GradeInfo: TGradeInfo):string;
//var
//  sResult:string;
//begin
//  with GradeInfo do
//  begin
//    sResult:=IntToStr(ID)+','+ObjStr+','+StandardValue+','+EQText+','+IntToStr(Points)+','+ExamineValue+','+inttostr(IsRight)+',';
//  end;
//  result:=sresult;
//end;

function GradeInfoToStr(GradeInfo: TGradeInfo;chr:char=','):string;
var
  sResult:string;
begin
  with GradeInfo do
  begin
    sResult:=IntToStr(ID)+chr+ObjStr+chr+StandardValue+chr+EQText+chr+IntToStr(Points)+chr+Exp+chr+ExamineValue+chr+inttostr(IsRight)+chr;
  end;
  result:=sresult;
end;

procedure StrToEnvironmentItem( Content:string;var AEnvironmnetItem:TEnvironmentItem);
var
  Head,Tail:pchar;
begin
  //这个函数的实现可参考extractstrings,setstring等
  //它通过修改content中的分隔字符为#0，来完成将一个大字符串分隔成多个小字符串
  //对content的修改，不影响它作为一个string的行为
  Tail:=pchar(Content);
  Head:=Tail;
  Tail:=strscan(Tail,',');
  Tail^:=#0;
  Tail:=Tail+1;
  AEnvironmnetItem.ID:=strtoint(Head);

  Head:=Tail;
  Tail:=strscan(Tail,',');
  Tail^:=#0;
  Tail:=Tail+1;
  AEnvironmnetItem.value1 :=Head;

  Head:=Tail;
  Tail:=strscan(Tail,',');
  Tail^:=#0;
  Tail:=Tail+1;
  AEnvironmnetItem.value2 :=Head;

  Head:=Tail;
  Tail:=strscan(Tail,',');
  Tail^:=#0;
  AEnvironmnetItem.value3 :=Head;
end;

function EnvironmnetInfoToStr(AEnvironmentItem: TEnvironmentItem):string;
var
  sResult:string;
begin
  with AEnvironmentItem do
  begin
    sResult:=IntToStr(ID)+','+value1 +','+value2+','+value3+',';
  end;
  result:=sresult;
end;

procedure StrToScoreInfo( Content:string;var ScoreInfo:TScoreInfo;chr:char=',');
var
  Head,Tail:pchar;
begin
  //这个函数的实现可参考extractstrings,setstring等
  //它通过修改content中的分隔字符为#0，来完成将一个大字符串分隔成多个小字符串
  //对content的修改，不影响它作为一个string的行为
  Tail:=pchar(Content);
  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  ScoreInfo.EQID:=Head;

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  ScoreInfo.GIID :=strtoint(Head);

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  ScoreInfo.EQText :=Head;

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  ScoreInfo.Points :=strtoint(Head);

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  ScoreInfo.Exp:=Head;

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  Tail:=Tail+1;
  ScoreInfo.ExamineValue :=Head;

  Head:=Tail;
  Tail:=strscan(Tail,chr);
  Tail^:=#0;
  ScoreInfo.IsRight :=strtoint(Head);
end;

procedure StrToModuleInfo( Content:string;var AModuleInfo:TModuleInfo;chr:char=',');
var
  Head,Tail:pchar;
begin
  //这个函数的实现可参考extractstrings,setstring等
  //它通过修改content中的分隔字符为#0，来完成将一个大字符串分隔成多个小字符串
  //对content的修改，不影响它作为一个string的行为
//  Tail:=pchar(Content);
//  Head:=Tail;
//  Tail:=strscan(Tail,chr);
//  Tail^:=#0;
//  Tail:=Tail+1;
//  AModuleInfo.Prefix:=Head;
//  
//  Head:=Tail;
//  Tail:=strscan(Tail,chr);
//  Tail^:=#0;
//  Tail:=Tail+1;
//  AModuleInfo.Classify :=strtoint(Head);
//
//  Head:=Tail;
//  Tail:=strscan(Tail,chr);
//  Tail^:=#0;
//  Tail:=Tail+1;
//  AModuleInfo..DllName :=Head;
//
//  Head:=Tail;
//  Tail:=strscan(Tail,chr);
//  Tail^:=#0;
//  AModuleInfo.DocName :=Head;
end;

//procedure CreateExamEnvironment(path:string);
//var
//  EnvironmentInfoStrings : TStringList;
//  //tempSet:TADODataSet;
//begin
////  tempSet:= TADODataSet.Create(nil);
////  try
////    tempSet.Connection := dm.ksconn;
////    tempSet.CommandText :='select * from 考生试题 where st_no like :v_stno';
////    tempSet.Parameters.ParamValues['v_stno']:='D%';
////    tempSet.Active :=true;
////    if not tempSet.IsEmpty then
////    begin
////      EnvironmentInfoStrings:=TStringList.Create;
////      try
////        EnvironmentInfoStrings.Text :=tempSet.FieldByName('st_hj').AsWideString ;
////        CreateWindowsExamEnvironment(path,EnvironmentInfoStrings);
////      finally // wrap up
////        EnvironmentInfoStrings.Free;
////      end;    // try/finally
////    end;
////  finally // wrap up
////    tempSet.Free;
////  end;    // try/finally
//end;
{$region  '------建立考试环境------' }
//function GetEnvironmentStrings(AEQType:string;ADataModule:ITQDataModule):string;
//var
//   strStream : TStringStream;
//   memStream : TMemoryStream;
//begin
//  strStream := TStringStream.Create('');
//  memStream := TMemoryStream.Create;
//  try
//     ADataModule.GetTQFieldStream(SQLSTR_GETENVIRONMENT_BY_TQ_TYPE,AEQType,memStream);
//     memStream.SaveToStream(strStream);
//     Result := strStream.DataString;
//  finally
//     strStream.Free;
//     memStream.Free;
//  end;
//end;

procedure GetEnvironmentStrings(AEQType:string;ADataModule:ITQDataModule;var AStrList:TStringList);
var
   memStream : TMemoryStream;
begin
  memStream := TMemoryStream.Create;
  try
     ADataModule.GetTQFieldStream(SQLSTR_GETENVIRONMENT_BY_TQ_TYPE,AEQType,memStream);
     AStrList.LoadFromStream(memStream);
  finally
     memStream.Free;
  end;
end;

procedure GetEnvironmentStringsByPreFix(APrefix:string;ds:TDataSet;var AStrList:TStringList);
var
   memStream : TMemoryStream;
begin
  memStream := TMemoryStream.Create;
  try
    with ds  do
    begin
      if Locate(DFNTQ_ST_NO,APrefix,[loCaseInsensitive,loPartialKey]) then begin
         (FieldByName(DFNTQ_ENVIRONMENT) as TBlobField).SaveToStream(memStream);
         UnCompressStream(memStream);
         AStrList.LoadFromStream(memStream);
      end else AStrList.Clear;
    end;
  finally
     memStream.Free;
  end;
end;

procedure CreateOperateEnvironmentByModule(AModule :TModuleInfo;APath :string ; ds:TDataSet);
var
   memStream : TMemoryStream;
begin
  memStream := TMemoryStream.Create;
  try
    with ds  do
    begin
      if Locate(DFNTQ_ST_NO,AModule.Prefix,[loCaseInsensitive,loPartialKey]) then begin
         (FieldByName(DFNTQ_ENVIRONMENT) as TBlobField).SaveToStream(memStream);
         UnCompressStream(memStream);
         if AModule.Name ='Windows' then
            CreateOperateDir(APath,memStream)
         else
            createOperateDoc(IncludeTrailingPathDelimiter(APath)+AModule.DocName,memStream);
      end ;
    end;
  finally
     memStream.Free;
  end;
end;

function CreateExamEnvironment(APath: string; AEnvironmentStrings: TStrings; AExamTcpClient: IExamTcpClient) : Integer; //stdcall;
var
   i:Integer;
   EnvironmentItem : TEnvironmentItem;
begin
   for i:=0 to AEnvironmentStrings.count-1 do
   begin
      StrToEnvironmentItem(AEnvironmentStrings.Strings[i],EnvironmentItem);
     // ExceuteEnvironmentItemCommand(APath,EnvironmentItem,AExamTcpClient);
   end;
end;

procedure CreateOperateDoc(AFileName:string;AEnvironStream:TMemoryStream) ;
begin
   EDirNotExistException.IfFalse(DirectoryExists(ExtractFilePath(AFileName)));
   EFileNotExistException.IfTrue(ExtractFileName(AFileName)=NULLSTR,Format(RSFileNotExist,[NULLSTR]));
   AEnvironStream.SaveToFile(AFileName);
end;

procedure CreateOperateDir(APath:string;AEnvironStream:TMemoryStream);
begin
   EDirNotExistException.IfFalse(DirectoryExists(APath),Format(RSDirNotExist,[APath]));
   DirectoryDecompression(APath,AEnvironStream);
end;


//create all environment by modules info
function CreateExamEnvironmentByModules(APath: string;AModules :TModules;ADs:TDataSet) : Integer; overload;
var
  EnvironmentInfoStrings : TStringList;
  i: Integer;
begin
  EnvironmentInfoStrings:=TStringList.Create;
  try
    for i := 0 to High(Amodules) do begin
      CreateOperateEnvironmentByModule(amodules[i],APath,ADs);
    end;
  finally
    EnvironmentInfoStrings.Free;
  end;
end;

{$endregion}

function GetRecordNoPreFlag(aMode: TFormMode): string;
var
  preFlag :string;
begin
    case aMode of    //
      SINGLESELECT_MODEL: preFlag := 'A';
      MULTISELECT_MODEL: preFlag := 'X';
      TYPE_MODEL : preFlag := 'C' ;
      WORD_MODEL: preFlag := 'E';
      WINDOWS_MODEL: preFlag := 'D';
      EXCEL_MODEL : preFlag := 'F';
      POWERPOINT_MODEL : preFlag := 'G';
    end;    // case
    Result := preFlag;
end;

function GradeinfoStringsToScore(GradeInfoStrings:TStringList):integer;
var
  gradeInfo : TGradeInfo;
  score:integer;
  i:Integer;
begin
  for I := 0 to gradeInfoStrings.Count - 1 do    // Iterate
  begin
    StrToGradeInfo(GradeInfoStrings.Strings[i],gradeInfo );
    if gradeInfo.IsRight=-1 then
    begin
      score:=score+gradeInfo.points;
    end;                                  
  end;    // for
  result:=score;
end;

function  DelStrChar(const Value: string):string;
var
  P: PChar;
  S: string;
begin
    s:= Value;
    P := Pointer(s);
    if P <> nil then
    begin
        while P^ <> #0 do
        begin
          while not (P^ in [',', #10, #13]) do Inc(P);
          if P^ = ',' then p^:=' ';
          if P^ = #13 then p^:=' ';
          if P^ = #10 then p^:=' ';
          inc(p);
        end;
    end ;
    result := s;
end;


function GetApplicationPath():string;
begin
//  result:=ExtractFilePath(Application.ExeName);
end;

function MessageBoxOnTopForm(App:TApplication;AText, ACaption: string; AFlags: integer): Integer; //stdcall;
begin
   App.NormalizeTopMosts;
   result := App.MessageBox(pchar(AText), pchar(ACaption), AFlags) ;
   App.RestoreTopMosts;
end;

//About Directory
function DeleteDir(ADicPath:TFileName):integer;
var
  lpFileOp: TSHFileOpstruct;
begin
    Result := 0;
    if DirectoryExists(ADicPath) then
    begin
        with lpFileOp do
        begin
            Wnd := 0;
            wFunc := FO_DELETE;
            pFrom := pchar(ADicPath + #0#0);
            pTo := nil;
            fFlags := FOF_NOCONFIRMATION;
            hNameMappings := nil;
            lpszProgressTitle := nil;
            fAnyOperationsAborted := false;
        end;
        { TODO -ojp -ccommons : 查找shfileoperation函数的异常触发机制，如何获取窗口句柄的？以及如何阻止异常窗口的弹出 }
        if SHFileOperation(lpFileOp)=0 then
           Result := 1;
    end;
end;

function DeleteFileWithPrompt(AFileName:TFileName):Boolean;
begin
  Result := false;
  if TFile.Exists( AFileName) then
    begin
      if (Application.MessageBox(pwidechar(AFileName+'文件已存在，是否删除？'),'提示',mb_yesno)= ID_YES) then
      begin
        try
           TFile.Delete(AFileName);
           Result := True;
        except
          on e:Exception do
             Application.MessageBox(pwidechar(e.Message),'提示',mb_ok) ;
        end;
      end else
    end;
end;


function FormatSelectGradeInfo(AID, AExamValue: string; IsRight: Boolean): string;
var
  isRightText :string;
begin
  if IsRight  then isRightText := '-1' else isRightText := '1';
  Result := AID+',0,,0,,'+AExamValue+','+isrighttext+',';
end;

function GradeInfoStringsToScoreInfoStrings(EQID:string;GradeInfoStrings:TStrings;chr:char=','):TStrings;
var
  GradeInfo: TGradeInfo;
  I: Integer;
  ResultStrings:TStringlist;
begin
  ResultStrings:=TStringList.create;
  try
    for I := 0 to GradeInfoStrings.Count - 1 do    // Iterate
    begin
      StrToGradeInfo(GradeInfoStrings.Strings[i],GradeInfo,chr);
      //scoreinfo 与gradeinfo 的主要区别是将操作题信息前面加上题号;
      ResultStrings.Add(EQID+chr+inttostr(gradeInfo.ID)+chr+gradeinfo.EQText+chr+inttostr(gradeinfo.Points)+chr+gradeInfo.Exp+chr+gradeinfo.ExamineValue+chr+inttostr(gradeInfo.IsRight)+chr);
    end;    // for
    result:=ResultStrings;
  except
    Result := nil;
    ResultStrings.Free;
  end;    // try/finally
end;


{$REGION '=====一般通用函数====='}
procedure VariantToStream(const Data: OleVariant; Stream: TStream);
var
  p: Pointer;
begin
  p := VarArrayLock(Data);
  try
    Stream.Write(p^, VarArrayHighBound(Data,1) + 1); 
  finally 
    VarArrayUnlock(Data); 
  end; 
end; 

function StreamToVariant(Stream: TStream): OleVariant;
var 
  p: Pointer; 
begin 
  Result := VarArrayCreate([0, Stream.Size - 1], varOleStr);
  p := VarArrayLock(Result); 
  try 
    Stream.Position := 0;
    Stream.Read(p^, Stream.Size); 
  finally 
    VarArrayUnlock(Result); 
  end; 
end;

{$ENDREGION}


end.
