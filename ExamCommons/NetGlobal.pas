unit NetGlobal;

interface

uses Classes, ScoreIni, DataFieldConst;

const
   CMD_GETBASECONFIG           = 'GETBASECONFIG';
   CMD_GETEXAMINEEINFO         = 'GETEXAMINEEINFO';
   CMD_GETEXAMINEEPHOTO        = 'GETEXAMINEEPHOTO';
   CMD_GETEXAMPWD              = 'GETEXAMPWD';
   CMD_EXAMINEELOGIN           = 'EXAMINEELOGIN';
   CMD_SENDEXAMINEESTATUS      = 'SENDEXAMINEESTATUS';
   CMD_GETEQINFO               = 'GETEQINFO';
   CMD_GETEQRECORD             = 'GETEQRECORD';
   CMD_GETEQFILE               = 'GETEQFILE';
   CMD_GETEXAMINEETESTFILEPACK = 'GETEXAMINEETESTFILEPACK';
   CMD_SENDSCOREINFO           = 'SENDSCOREINFO';
   CMD_SENDEXAMINEEZIPFILE     = 'SENDEXAMINEEZIPFILE';
   // CMD_GETEXAMINEEZIPFILE  ='GETEXAMINEEZIPFILE';

   CMDNULLNONAME            = 'NULL';
   CMDNOEXAMINEEINFO        = 'NOEXAMINEEINFO';
   CMDCONSTCORRECTREPLYCODE = '600';
   CMDCONSTERRORREPLYCODE   = '700';

   NULLSTR = '';

   /// 需要加入-系统设置中
   /// 考生号长度
   CONSTEXAMINEEIDLENGTH = 11; // examinee id length
   {$REGION '根据配置文件设置'}
   // ///服务器IP地址
   // {$IFDEF VMSERVER}
   // CONSTSERVERIP           ='192.168.128.3';
   // {$ELSE}
   // CONSTSERVERIP           ='127.0.0.1';
   // {$ENDIF}
   /// /服务器端口号
   // CONSTSERVERPORT         = 3000;
   {$ENDREGION}

   // '60.173.210.154';     //
type

   TExamineeStatus = (esNotLogined = 0, esAllowReExam = 1, esAllowContinuteExam = 2,esGetTestPaper = 3,  esLogined = 20,
           esExamining = 22, esGrading = 30, esSutmitAchievement = 33, esError = 39, esAbsent = 41, esCrib = 42,esDisConnect = 90, esGradeError = 91, esExamEnded = 99);

   // TO-DO:增加性别，相片
   TExaminee = record
      ID : string;
      Name : string;
      Sex : string;
      IP : string;    // not transmit  between client and server
      Port : integer; // not transmit  between client and server
      Status : TExamineeStatus;
      RemainTime : integer;
      TimeStamp : TDateTime;
      // ScoreInfo:TScoreIni;
      HasPhoto : Boolean;
      ScoreCompressedStream : TMemoryStream;

      procedure Assign(AExaminee : TExaminee);
      procedure ClearData();
      procedure Decrypt();
   end;

   PExaminee = ^TExaminee;

   TLoginType = (ltFirstLogin = 0, ltContinuteInterupt = 1, ltContinuteEndedExam = 2, ltReExamLogin = 3);

   TCommandResult = (crOk = 1, crRefuseLogin = 2, crError = 3, crDisConnected = 4, crConnClosedGracefully = 5, crNetError = 6);

   TServerState = (ssClosed = 0, ssListening = 1);

   // command result is equal TCmdRec's status;


   // public
   // st_no : string;
   // Content :string;
   // StAnswer:
   /// /      st_lr:string;
   /// /      st_item1:string;
   /// /      st_item2:string;
   /// /      st_item3:string;
   /// /      st_item4:string;
   /// /      st_da:string;
   /// /      st_hj:string;
   /// /      st_da1:string;
   // Comment:string;
   //
   // procedure Assign(Source: TClientEQRecordPacket);
   // procedure ClearData();
   // end;

   // TSysConfig = record
   // ExamName:string ;
   // Clasify : string;
   // LastDate :TDateTime;
   // ScoreDisplayMode:string;
   // //ManagePwd : string;
   // ClientPath : string;
   // StatusRefreshInterval:Integer;
   // ExamTime:Integer;
   // TypeTime:Integer;
   // Modules :TStringList;
   // end;

   // TExaminee vs TStrings  Convert
   // procedure ConvertExamineeToStrings(AExaminee :TExaminee; AStrings:TStrings);
   // procedure ConvertStringsToExaminee(AStrings :TStrings; var AExaminee:TExaminee);
   // procedure ConvertStringsToSysConfig(AStrings :TStrings; var ASysConfig:TSysConfig);

function GetStatusDisplayValue(AStatus : TExamineeStatus) : string;

procedure ConvertExamineeToStrings(AExaminee : TExaminee; AStrings : TStrings);

procedure ConvertStringsToExaminee(AStrings : TStrings; var AExaminee : TExaminee);

implementation

uses
   SysUtils, Commons;

{ TClientEQRecordPacket }
// procedure TClientEQRecordPacket.Assign(Source: TClientEQRecordPacket);
// begin
// Content := Source.Content;
/// /   st_lr:=Source.st_lr;
/// /   st_item1:=Source.st_item1;
/// /   st_item2:=Source.st_item2;
/// /   st_item3:=Source.st_item3;
/// /   st_item4:=Source.st_item3;
// st_da:=Source.st_da;
// st_hj:=Source.st_hj;
// st_da1:=Source.st_da1;
// Comment := Source.Comment;
// end;
//
// procedure TClientEQRecordPacket.ClearData;
// begin
// Content := '';
/// /   st_lr:='';
/// /   st_item1:='';
/// /   st_item2:='';
/// /   st_item3:='';
/// /   st_item4:='';
// st_da:='';
// st_hj:='';
// st_da1:='';
// Comment := '';
// end;




// procedure ConvertStringsToSysConfig(AStrings :TStrings; var ASysConfig:TSysConfig);
// var
// i:Integer;
// begin
// ASysConfig.ExamName := AStrings[0];
// ASysConfig.Clasify := AStrings[1];
// ASysConfig.LastDate := strtoint64(AStrings[2]);
// ASysConfig.ScoreDisplayMode := (AStrings[3]);
// ASysConfig.ClientPath := AStrings[4];
// ASysConfig.StatusRefreshInterval :=StrToInt(AStrings[5]);
// ASysConfig.ExamTime :=StrToInt(AStrings[6]);
// ASysConfig.TypeTime :=StrToInt(AStrings[7]);
// if AStrings.Count>=8 then
// ASysConfig.Modules:=TStringList.Create;
// for i := 10 to AStrings.Count-1 do begin
// ASysConfig.Modules.Add(AStrings[i]);
// end;
// end;

function GetStatusDisplayValue(AStatus : TExamineeStatus) : string;
   begin
      Result := '无此状态';
      case AStatus of
         esNotLogined :
            Result := '未登录';
         esDisConnect :
            Result := '异常中断';
         esGradeError :
            Result := '交卷中断';
         esLogined :
            Result := '已登录';
         esAllowReExam :
            Result := '允许重考';
         esAllowContinuteExam :
            Result := '允许续考';
         esGetTestPaper :
            Result := '正在获取试卷';
         esExamining :
            Result := '考试中...';
         esGrading :
            Result := '正在评分...';
         esSutmitAchievement :
            Result := '提交成绩';
         esExamEnded :
            Result := '考试正常结束';
         esError :
            Result := '有错误';
         esAbsent :
            Result := '缺考';
         esCrib :
            Result := '作弊';
      end;
   end;

procedure ConvertExamineeToStrings(AExaminee : TExaminee; AStrings : TStrings);
   begin
      AStrings.Clear;
      AStrings.Add(AExaminee.ID);
      AStrings.Add(AExaminee.Name);
      AStrings.Add(AExaminee.IP);
      AStrings.Add(IntToStr(Ord(AExaminee.Status)));
      AStrings.Add(IntToStr(AExaminee.RemainTime));
   end;

procedure ConvertStringsToExaminee(AStrings : TStrings; var AExaminee : TExaminee);
   begin
      AExaminee.ID         := AStrings[0];
      AExaminee.Name       := AStrings[1];
      AExaminee.IP         := AStrings[2];
      AExaminee.Status     := TExamineeStatus(StrToInt(AStrings[3]));
      AExaminee.RemainTime := StrToInt(AStrings[4]);
   end;
{ TExaminee }

procedure TExaminee.Assign(AExaminee : TExaminee);
   begin
      ID                    := AExaminee.ID;
      Name                  := AExaminee.Name;
      IP                    := AExaminee.IP;   // not transmit  between client and server
      Port                  := AExaminee.Port; // not transmit  between client and server
      Status                := AExaminee.Status;
      RemainTime            := AExaminee.RemainTime;
      TimeStamp             := AExaminee.TimeStamp;
      ScoreCompressedStream := AExaminee.ScoreCompressedStream;
   end;

procedure TExaminee.Decrypt;
   begin
      // ID:=EncryptStr(ID);
      // Name:=EncryptStr(Name);
      // IP:=EncryptStr(IP);       //not transmit  between client and server
      // Port:=EncryptStr(Port;    //not transmit  between client and server
      // Status:=EncryptStr(Status;
      // RemainTime:=EncryptStr(RemainTime;
      // TimeStamp:=EncryptStr(TimeStamp;
      // ScoreCompressedStream :=AExaminee.ScoreCompressedStream;
   end;

procedure TExaminee.ClearData;
   begin
      ID         := '';
      Name       := '';
      IP         := ''; // not transmit  between client and server
      Port       := 0;  // not transmit  between client and server
      Status     := esNotLogined;
      RemainTime := 0;
      TimeStamp  := 0;
      if Assigned(ScoreCompressedStream) then
         ScoreCompressedStream.Free;
   end;

end.
