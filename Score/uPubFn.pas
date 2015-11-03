unit uPubFn;

interface
uses uGrade,classes,dbclient,db;
type
  scorearray =array [0..7] of integer;
  TFormMode=(SINGLESELECT_MODEL,MULTISELECT_MODEL,TYPE_MODEL,WINDOWS_MODEL,WORD_MODEL,EXCEL_MODEL,POWERPOINT_MODEL,IE_MODEL);


procedure GetDBPath(var srcpath:string;var tagpath:string);//获得配置路径
function SetSourceConn(dbfilename:string):boolean ; //设置上报库数据连接
//function DecryptStr(const Src:string; Key: String='JiaPing'): String; //解码
procedure StrToScoreInfo( Content:string;var ScoreInfo:TScoreInfo;chr:char=',');
function OperateScore(ScoreInfoStrings: TStrings;chr:char=','):Integer;
function SelectScore(amode:TFormMode;ScoreInfoStrings: TStrings):Integer;
procedure GetScore(dataset:TDataset;var score:scorearray );

implementation
uses sysutils,forms, udmMain,commons,examglobal;
procedure GetDBPath(var srcpath:string;var tagpath:string);
var
  configList: TStringList;
begin
  if FileExists(ExtractFilePath(application.ExeName) + 'config.txt') then
  begin
    configlist := Tstringlist.Create;
    try
      configlist.LoadFromFile(ExtractFilePath(application.ExeName) + 'config.txt');
      if configlist.Count = 2 then
      begin
        srcpath := configlist.Strings[0];
        tagpath := configlist.strings[1];
      end
      else
      begin
        application.MessageBox('配置文件有错', '提示');
        srcpath := '';
        tagpath := '';
      end;

    finally
      configlist.free;
    end;
  end
  else
  begin
    application.MessageBox('当前程序路径中配置文件不存在', '提示');
    srcpath := '';
    tagpath := '';
  end;
end;

function SetSourceConn(dbfilename:string):boolean ;
begin
  dmMain.connSource.Connected :=false;
  dmmain.connSource.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;User ID=admin;Data Source='+dbfilename+';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Engine Type=5;;Jet OLEDB:Database Password='+ DecryptStr(SYSDBPWD);
  try
    dmMain.connSource.Connected := true;
    result := true;
  except
    application.MessageBox('连接上报库错误，请检查库文件路径或文件是否有错误','错误');
    result := false;
  end;
end;

//function DecryptStr(const Src:string; Key: String='JiaPing'): String;
//var
//  KeyLen :Integer;
//  KeyPos :Integer;
//  offset :Integer;
//  noff:Integer;
//  dest :string;
//  SrcPos :Integer;
//  SrcAsc :Integer;
//  sTemp:string;
//begin
//  KeyLen:=Length(Key);
//  KeyPos:=0;
//  dest:='';
//  sTemp:='$'+src[1]+src[2];
//  offset:=strtoint(sTemp);
//  for SrcPos := 2 to Length(Src) div 2 do
//  begin
//    if KeyPos < KeyLen then
//      KeyPos:= KeyPos + 1
//    else
//      KeyPos:=1;
//    SrcAsc:=strtoint('$'+src[SrcPos*2-1]+src[SrcPos*2]);
//    noff:=SrcAsc;
//    SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
//
//    if SrcAsc<offset then
//      srcasc:=SrcAsc+255;
//    SrcAsc:=SrcAsc-offset;
//    dest:=dest + chr(SrcAsc);
//    offset:=noff;
//  end;
//  Result:=Dest;
//end;

//获得每题得分
procedure GetScore(dataset:TDataset;var score:scorearray );
var
  ScoreInfoStrings:TStringList;
begin
  ScoreInfoStrings:=TStringList.Create;
  try
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('xz1_fs').AsString;
//    score[0] :=SelectScore(SINGLESELECT_MODEL,ScoreInfoStrings);
//
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('pd_fs').AsString;
//    score[1] :=SelectScore(MULTISELECT_MODEL,ScoreInfoStrings);
//
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('dz_fs').AsString;
//    score[2] :=OperateScore(ScoreInfoStrings);
//
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('Win_fs').AsString;
//    score[3] :=OperateScore(ScoreInfoStrings);
//
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('Word_fs').AsString;
//    score[4] :=OperateScore(ScoreInfoStrings);
//
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('Excel_fs').AsString;
//    score[5] :=OperateScore(ScoreInfoStrings,'~');
//
//    ScoreInfoStrings.Text:=dataset.Fieldbyname('ppt_fs').AsString;
//    score[6] :=OperateScore(ScoreInfoStrings);
//
//    score[7]:=score[0]+score[1]+score[2]+(score[3]+score[4]+score[5]+score[6]) div 10;
//    //score[7]:=score[0]+score[1]+score[2]+(score[3]+score[4]+score[5]+score[6]) div 10;

  finally // wrap up
    ScoreInfoStrings.Free;
  end;    // try/finally
end;


function OperateScore(ScoreInfoStrings: TStrings;chr:char=','):Integer;
var
  I: Integer;
  Score : Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,chr);
    if scoreinfo.IsRight=-1 then
    begin
      Score := score + scoreInfo.points;
    end
  end;    // for
  result := Score ;
end;

function SelectScore(amode:TFormMode;ScoreInfoStrings: TStrings):Integer;
var
  I: Integer;
  Score : Integer;
  scoreInfo:TScoreInfo;
begin
  score := 0;
  for I := 1 to ScoreInfoStrings.Count  do    // Iterate
  begin
    StrToScoreInfo(ScoreInfoStrings.Strings[i-1],scoreinfo,',');
    if scoreinfo.IsRight=-1 then
    begin
      Score := score +1;
    end
  end;    // for
  case aMode  of    //
    MULTISELECT_MODEL:
    begin
      score := score*2; 
    end;       
  end;    // case
  result := Score ;
end;
procedure StrToScoreInfo( Content:string;var ScoreInfo:TScoreInfo;chr:char=',');
var
  Head,Tail:pchar;
  index:integer;
begin
  //这个函数的实现可参考extractstrings,setstring等
  //它通过修改content中的分隔字符为#0，来完成将一个大字符串分隔成多个小字符串
  //对content的修改，不影响它作为一个string的行为
  if (content='0') or (content='NULL') then
  begin
    ScoreInfo.EQID:='';

    ScoreInfo.GIID :=-1;


    ScoreInfo.EQText :='';


    ScoreInfo.Points :=0;

    ScoreInfo.ExamineValue :='';


    ScoreInfo.IsRight :=0;
  end
  else
  begin
    try
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
      ScoreInfo.ExamineValue :=Head;

      Head:=Tail;
      Tail:=strscan(Tail,chr);
      Tail^:=#0;
      Tail:=Tail+1;
      ScoreInfo.IsRight :=strtoint(Head);
    except
      ScoreInfo.EQID:='';

      ScoreInfo.GIID :=-1;

      ScoreInfo.EQText :='';

      ScoreInfo.Points :=0;

      ScoreInfo.ExamineValue :='';

      ScoreInfo.IsRight :=0;
    end;


  end;
    
end;

end.
