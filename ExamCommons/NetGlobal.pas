unit NetGlobal;

interface
uses Classes, ScoreIni, DataFieldConst;
const
   CMD_GETBASECONFIG     ='GETBASECONFIG';
   CMD_GETEXAMINEEINFO  ='GETEXAMINEEINFO';
   CMD_GETEXAMPWD       ='GETEXAMPWD';
   CMD_EXAMINEELOGIN    ='EXAMINEELOGIN';
   CMD_SENDEXAMINEESTATUS ='SENDEXAMINEESTATUS';
   CMD_GETEQINFO        ='GETEQINFO' ;
   CMD_GETEQRECORD      ='GETEQRECORD';
   CMD_GETEQFILE        ='GETEQFILE';
   CMD_GETEXAMINEETESTFILEPACK           ='GETEXAMINEETESTFILEPACK';
   CMD_SENDSCOREINFO    ='SENDSCOREINFO';
   CMD_SENDEXAMINEEZIPFILE ='SENDEXAMINEEZIPFILE';
//   CMD_GETEXAMINEEZIPFILE  ='GETEXAMINEEZIPFILE';

   CMDNULLNONAME      ='NULL';
   CMDNOEXAMINEEINFO    ='NOEXAMINEEINFO';
   CMDCONSTCORRECTREPLYCODE ='600';
   CMDCONSTERRORREPLYCODE ='700';

   //�������˿ں�
   CONSTSERVERPORT         = 3000;

   NULLSTR                 = '';

   ///��Ҫ����-ϵͳ������
   ///�����ų���
   CONSTEXAMINEEIDLENGTH        = 11;           // examinee id length
   ///������IP��ַ
   CONSTSERVERIP           ='127.0.0.1';
   //'60.173.210.154';     //
type

   TExamineeStatus=( esNotLogined = 0,
                     esAllowReExam =1,
                     esAllowContinuteExam =2,
                     esDisConnect=10,
                     esGradeError=11,

                     esLogined=20,
                     esGetTestPaper=21,
                     esExamining=22,

                     esGrading =30,
                     esSutmitAchievement=33,
                     esError =39,
                     esExamEnded=40,

                     esAbsent = 41,
                     esCrib =42
                  );
   
   TExaminee  = record
      ID:string;
      Name:string;
      IP:string;       //not transmit  between client and server
      Port:integer;    //not transmit  between client and server
      Status:TExamineeStatus;
      RemainTime:integer;
      TimeStamp:TDateTime;
      //ScoreInfo:TScoreIni;
      ScoreCompressedStream : TMemoryStream;

      procedure Assign(AExaminee : TExaminee);
      procedure ClearData();
      procedure Decrypt();
   end;
   PExaminee = ^TExaminee;

   TLoginType = ( ltFirstLogin=0, ltContinuteInterupt =1,ltContinuteEndedExam=2, ltReExamLogin=3);

   TCommandResult = (crOk=1,crError=2,crDisConnected=3,crConnClosedGracefully=4,crNetError=5);

   TServerState=(ssClosed=0,ssListening=1);
   
   //command result is equal TCmdRec's status;

   
//   public
//      st_no : string;
//      Content :string;
//      StAnswer:
////      st_lr:string;
////      st_item1:string;
////      st_item2:string;
////      st_item3:string;
////      st_item4:string;
////      st_da:string;
////      st_hj:string;
////      st_da1:string;
//      Comment:string;
//
//      procedure Assign(Source: TClientEQRecordPacket);
//      procedure ClearData();
//   end;

//   TSysConfig = record
//      ExamName:string ;
//      Clasify : string;
//      LastDate :TDateTime;
//      ScoreDisplayMode:string;
//      //ManagePwd : string;
//      ClientPath : string;
//      StatusRefreshInterval:Integer;
//      ExamTime:Integer;
//      TypeTime:Integer;
//      Modules :TStringList;
//   end;

   // TExaminee vs TStrings  Convert
//   procedure ConvertExamineeToStrings(AExaminee :TExaminee; AStrings:TStrings);
//   procedure ConvertStringsToExaminee(AStrings :TStrings; var AExaminee:TExaminee);
   //procedure ConvertStringsToSysConfig(AStrings :TStrings; var ASysConfig:TSysConfig);

   function GetStatusDisplayValue(AStatus:TExamineeStatus):string;

   procedure ConvertExamineeToStrings(AExaminee :TExaminee; AStrings:TStrings);

   procedure ConvertStringsToExaminee(AStrings :TStrings; var AExaminee:TExaminee);

implementation

uses
  SysUtils,Commons;

{ TClientEQRecordPacket }
//procedure TClientEQRecordPacket.Assign(Source: TClientEQRecordPacket);
//begin
//    Content := Source.Content;
////   st_lr:=Source.st_lr;
////   st_item1:=Source.st_item1;
////   st_item2:=Source.st_item2;
////   st_item3:=Source.st_item3;
////   st_item4:=Source.st_item3;
//   st_da:=Source.st_da;
//   st_hj:=Source.st_hj;
//   st_da1:=Source.st_da1;
//   Comment := Source.Comment;
//end;
//
//procedure TClientEQRecordPacket.ClearData;
//begin
//   Content := '';
////   st_lr:='';
////   st_item1:='';
////   st_item2:='';
////   st_item3:='';
////   st_item4:='';
//   st_da:='';
//   st_hj:='';
//   st_da1:='';
//   Comment := '';
//end;




//procedure ConvertStringsToSysConfig(AStrings :TStrings; var ASysConfig:TSysConfig);
//var
//   i:Integer;
//begin
//   ASysConfig.ExamName := AStrings[0];
//   ASysConfig.Clasify := AStrings[1];
//   ASysConfig.LastDate := strtoint64(AStrings[2]);
//   ASysConfig.ScoreDisplayMode := (AStrings[3]);
//   ASysConfig.ClientPath := AStrings[4];
//   ASysConfig.StatusRefreshInterval :=StrToInt(AStrings[5]);
//   ASysConfig.ExamTime :=StrToInt(AStrings[6]);
//   ASysConfig.TypeTime :=StrToInt(AStrings[7]);
//   if AStrings.Count>=8 then
//      ASysConfig.Modules:=TStringList.Create;
//   for i := 10 to AStrings.Count-1 do begin
//      ASysConfig.Modules.Add(AStrings[i]);
//   end;
//end;

function GetStatusDisplayValue(AStatus:TExamineeStatus):string;
begin
   Result := '�޴�״̬';
   case AStatus of
      esNotLogined: Result:='δ��¼';
      esDisConnect: Result:='�쳣�ж�';
      esGradeError: Result:='�����ж�';
      esLogined: Result:='�ѵ�¼';
      esAllowReExam: Result:='�����ؿ�';
      esAllowContinuteExam: Result:='��������';
      esGetTestPaper: Result:='���ڻ�ȡ�Ծ�';
      esExamining: Result:='������...';
      esGrading: Result:='��������...';
      esSutmitAchievement: Result:='�ύ�ɼ�';
      esExamEnded: Result:='������������';
      esError: Result:='�д���';
      esAbsent: Result:='ȱ��';
      esCrib: Result:='����';
   end;
end;
procedure ConvertExamineeToStrings(AExaminee :TExaminee; AStrings:TStrings);
begin
     AStrings.Clear;
     AStrings.Add(AExaminee.ID);
     AStrings.Add(AExaminee.Name);
     AStrings.Add(AExaminee.IP);
     AStrings.Add(IntToStr(Ord(AExaminee.Status)));
     AStrings.Add(IntToStr(AExaminee.RemainTime));
end;
procedure ConvertStringsToExaminee(AStrings :TStrings; var AExaminee:TExaminee);
begin
     AExaminee.ID := AStrings[0];
     AExaminee.Name := AStrings[1];
     AExaminee.IP := AStrings[2];
     AExaminee.Status := texamineeSTatus( StrToInt(AStrings[3]));
     AExaminee.RemainTime := StrToInt(AStrings[4]);
end;
{ TExaminee }

procedure TExaminee.Assign(AExaminee: TExaminee);
begin
    ID:=AExaminee.ID;
    Name:=AExaminee.Name;
    IP:=AExaminee.IP;       //not transmit  between client and server
    Port:=AExaminee.Port;    //not transmit  between client and server
    Status:=AExaminee.Status;
    RemainTime:=AExaminee.RemainTime;
    TimeStamp:=AExaminee.TimeStamp;
    ScoreCompressedStream :=AExaminee.ScoreCompressedStream;
end;

procedure TExaminee.Decrypt;
begin
//    ID:=EncryptStr(ID);
//    Name:=EncryptStr(Name);
//    IP:=EncryptStr(IP);       //not transmit  between client and server
//    Port:=EncryptStr(Port;    //not transmit  between client and server
//    Status:=EncryptStr(Status;
//    RemainTime:=EncryptStr(RemainTime;
//    TimeStamp:=EncryptStr(TimeStamp;
//    ScoreCompressedStream :=AExaminee.ScoreCompressedStream;
end;

procedure TExaminee.ClearData;
begin
  ID:='';
  Name:='';
  IP:='';       //not transmit  between client and server
  Port:=0;    //not transmit  between client and server
  Status:=esNotLogined;
  RemainTime:=0;
  TimeStamp:=0;
  if Assigned(ScoreCompressedStream) then
    ScoreCompressedStream.Free;
end;

end.