unit ExamineesManager;

interface

uses Classes, Controls, ExtCtrls, DB, Windows, SysUtils, IdSocketHandle, NetGlobal, DBClient;

type

   EMemTableError = class(EDataBaseError);

   // TListChangedEvent =procedure(const item:TClientbak) of object;  //index=-1表示非一项改变，否则表示index项发生改变

   { TODO -ojp : 多线程安全问题需要保证 }
   TExamineesManager = class(TOBject)
      private
         // 只允许指定范围内的考生登录　要求先设定范围，并显示出来
         FExamineesList  : TThreadList;
         FMessageHandler : THandle; // 处理列表消息的窗口
         FTimer          : TTimer;
         function FindItemByExamineeNo(AExaminee : PExaminee; AList : TList) : integer; overload;
         function FindItemByExamineeNo(AExamineeID : string; AList : TList) : integer; overload;
         procedure FTimerTimer(Sender : TOBject);
         function GetCount : integer;
      protected
         // procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      public
         constructor Create; overload;
         constructor Create(AMessageHandler : THandle); overload;

         destructor Destroy; override;
         // ==============================================================================
         // GetExamineeInfo 将加密获取的考生信息
         // ==============================================================================
         procedure GetExamineeInfo(const AExamineeID : string; out AExaminee : TExaminee);
         procedure UpdateTimeStamp(const ABinding : TIdSocketHandle);
         function Login(AExamineeID : string; ALoginType : TLoginType; APwd, aPeerIP : string; aPeerPort : UInt16) : TCommandResult;
         /// 查找已存在的项，返回数组索引，如果不存在返回 -1;
         function FindItemByIPPort(const ABinding : TIdSocketHandle; AList : TList) : integer;

         procedure UpdateStatus(AExaminee : PExaminee);
         procedure UpdateDisConnectStatus(const ABinding : TIdSocketHandle);
         procedure UpdateScoreInfo(AExaminee : PExaminee);
         procedure EnableTimer(AValue : Boolean);
         procedure SaveExamineeInfo();
         function Add(AExaminee : PExaminee) : Boolean;
         function GetExamineesCDS() : TClientDataSet;
      published
         property ExamineesList  : TThreadList read FExamineesList;
         property Count          : integer read GetCount;
         property MessageHandler : THandle read FMessageHandler write FMessageHandler;
   end;

const
   ColIndexOfExamineeNo   = 0;
   ColIndexOfExamineeName = 1;
   ColIndexOfIP           = 2;
   ColIndexOfPort         = 3;
   ColIndexOfStatus       = 4;
   ColIndexOfRemainTime   = 5;

implementation

uses
   Variants, ServerUtils, Forms, ServerGlobal, StkRecordInfo, datafieldconst, cndebug;

function TExamineesManager.Add(AExaminee : PExaminee) : Boolean;
   var
      list : TList;
   begin
      Result := False;
      list   := ExamineesList.LockList;
      try
         if FindItemByExamineeNo(AExaminee.ID, list) = -1 then
         begin
            list.Add(AExaminee);
            Result := True;
         end;

      finally
         ExamineesList.UnlockList;
      end;
   end;

constructor TExamineesManager.Create;
   begin
      inherited;
      // FMessageHandler := AMessageHandler;
      FExamineesList  := TThreadList.Create();
      FTimer          := TTimer.Create(nil);
      FTimer.Enabled  := False;
      FTimer.Interval := 3000;
      FTimer.OnTimer  := FTimerTimer;
   end;

constructor TExamineesManager.Create(AMessageHandler : THandle);
   begin
      inherited Create();
      FMessageHandler := AMessageHandler;
      FExamineesList  := TThreadList.Create();
      FTimer          := TTimer.Create(nil);
      FTimer.Enabled  := False;
      FTimer.Interval := 3000;
      FTimer.OnTimer  := FTimerTimer;
   end;

destructor TExamineesManager.Destroy;
   var
      i    : integer;
      list : TList;
      p    : PExaminee;
   begin
      FMessageHandler := 0;
      list            := FExamineesList.LockList;
      try
         for i := list.Count - 1 downto 0 do
         begin
            p := list[i];
            list.Delete(i);
            /// 这里需要考虑，为什么为空
            if Assigned(p.ScoreCompressedStream) then
               p.ScoreCompressedStream.Free;
            Dispose(p);
         end;
      finally
         FExamineesList.UnlockList;
      end;
      FExamineesList.Free;
      FTimer.Enabled := False;
      FTimer.Free;
      inherited;
   end;

procedure TExamineesManager.EnableTimer(AValue : Boolean);
   begin
      if FTimer.Enabled <> AValue then
         FTimer.Enabled := AValue;
   end;

procedure TExamineesManager.SaveExamineeInfo;
   var
      myList : TList;
   begin
      myList := ExamineesList.LockList;
      try
         TExamServerGlobal.GlobalStkRecordInfo.UpdateExamineeInfo(myList);
      finally
         ExamineesList.UnlockList;
      end;
   end;

function TExamineesManager.GetCount : integer;
   var
      list : TList;
   begin
      list := FExamineesList.LockList;
      try
         Result := list.Count;
      finally
         FExamineesList.UnlockList;
      end;
   end;

procedure TExamineesManager.GetExamineeInfo(const AExamineeID : string; out AExaminee : TExaminee);
   var
      list  : TList;
      index : integer;
   begin
      list := FExamineesList.LockList;
      try
         index := FindItemByExamineeNo(AExamineeID, list);
         if index <> -1 then
         begin
            AExaminee := TExaminee(list[index]^);
            // no need score
            AExaminee.ScoreCompressedStream := nil;
         end else begin
            AExaminee.ID                    := AExamineeID;
            AExaminee.Name                  := CMDNOEXAMINEEINFO;
            AExaminee.ScoreCompressedStream := nil;
         end;
      finally
         FExamineesList.UnlockList;
      end;
   end;

// used for print exam record
function TExamineesManager.GetExamineesCDS : TClientDataSet;
   var
      list      : TList;
      index     : integer;
      AExaminee : TExaminee;
      astatus   : string;
   begin
      // init cds structure
      Result := TClientDataSet.Create(nil);
      // cdsTemp := TClientDataSet.Create(self);
      Result.FieldDefs.Add(DFNEI_EXAMINEEID, ftString, 11);
      Result.FieldDefs.Add(DFNEI_EXAMINEENAME, ftString, 8);
      // cdsTemp.FieldDefs.Add('IP',ftString,15);
      // cdsTemp.FieldDefs.Add('Port',ftInteger);
      Result.FieldDefs.Add(DFNEI_STATUS, ftString,8);
      Result.FieldDefs.Add(DFNEI_REMAINTIME, ftInteger);
      // cdsTemp.FieldDefs.Add('TimeStamp',ftDateTime);
      // cdsTemp.FieldDefs.Add('ScoreInfo',ftBlob);
      Result.CreateDataSet;
      // Result.Active    := True;

      // update data
      list := FExamineesList.LockList;
      try
         if list.Count = 0 then
            exit;

         for index := 0 to list.Count - 1 do
         begin
            AExaminee := TExaminee(list[index]^);
            case AExaminee.Status of
               esNotLogined :
                  astatus := '缺考';
               esAllowReExam :
                  astatus := '允许重考';
               esAllowContinuteExam :
                  astatus := '允许续考';
               esAllowAddTimeExam :
                  astatus := '允许延考';
               esGetTestPaper :
                  astatus := '获取试卷';
               esLogined, esExamining, esGrading, esSutmitAchievement, esError, esAbsent, esDisConnect, esGradeError :
                  astatus := '异常';
               esCheat :
                  astatus := '作弊';
               esExamEnded :
                  astatus := '正常';
            end;
            Result.AppendRecord([AExaminee.ID, AExaminee.Name, aStatus, AExaminee.RemainTime]);
         end;
      finally
         FExamineesList.UnlockList;
      end;

   end;

// function TExamineesManager.ExamineeLogin(AExamineeNo : string):string;
// begin
// //   { TODO -ojp -cInprove : 添加索引可提高查找速度 }
/// /   // Wait for critical section.
/// /     inc(FLockCount);
/// /     n:=WaitForSingleObject(FSemaphore,3000);
/// /     if (n=WAIT_TIMEOUT) or (n=WAIT_FAILED) then
/// /     begin
/// /         dec(FLockCount);
/// /         exit;
/// /     end else begin
/// /         try
// try
// if FCDSExaminees.Locate('ExamineeNo', AExamineeNo, []) then
// begin
// Result := FCDSExaminees.FieldValues['ExamineeName'];
// end;
// except
// OutputDebugString(PChar('Get ExamineeName error:'+AExamineeNo));
// end;
/// /         finally
/// /            dec(FLockCount);
/// /            ReleaseSemaphore(FSemaphore,1,nil);
/// /         end;
/// /     end;
// end;

function TExamineesManager.Login(AExamineeID : string; ALoginType : TLoginType; APwd, aPeerIP : string; aPeerPort : UInt16) : TCommandResult;
   var
      index           : integer;
      myList          : TList;
      tempExaminee    : PExaminee;
      currentStatus   : TExamineeStatus;
      msg             : string;
      conditionResult : Boolean;

      procedure ModifyExamineeInfo(astatus : TExamineeStatus);
         begin
            TExaminee(myList[index]^).IP     := aPeerIP;
            TExaminee(myList[index]^).Port   := aPeerPort;
            TExaminee(myList[index]^).Status := astatus; // esLogined;
            // TExaminee(myList[index]^).RemainTime:= CONSTEXAMINENATIONTIME;
            TExaminee(myList[index]^).TimeStamp := Now;

            // AExaminee.Name   := TExaminee(myList[index]^).Name;
            // AExaminee.Status := AStatus; // esLogined ;
            // if (TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0) and
            // ((ALoginType = ltContinuteEndedExam) or (ALoginType = ltAddTimeExam)) then
            // AExaminee.RemainTime :=  aRemainTime // 时间由客户端传来的确定
            // else
            // AExaminee.RemainTime := TExaminee(myList[index]^).RemainTime; // 时间由服务器端设定
            // ARemainTime          := TExaminee(myList[index]^).RemainTime;

            // 为将examinee通过消息发出去，而创建一个临时对象，它将在事件接收过程中被释放。
            New(tempExaminee);
            tempExaminee.Assign(TExaminee(myList[index]^));
         end;

   begin
      Result := crError;
      myList := FExamineesList.LockList;
      try
         index := FindItemByExamineeNo(AExamineeID, myList);
         if index <> -1 then
         begin
            currentStatus := TExaminee(myList[index]^).Status;
            case ALoginType of
               ltFirstLogin :
                  begin
                     conditionResult := currentStatus = esNotLogined;
                     msg             := 'Examineesmanager FirstLogin';
                  end;
               ltContinuteInterupt :
                  begin
                     conditionResult := currentStatus = esDisConnect;
                     msg             := 'Examineesmanager ContinuteInterupt';
                  end;
               ltContinuteEndedExam :
                  begin
                     conditionResult := (TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0) and (APwd = TExamServerGlobal.ServerCustomConfig.ContPwd) or
                             (currentStatus = esAllowContinuteExam);
                     msg := 'Examineesmanager ReExamLogin';
                  end;
               ltReExamLogin :
                  begin
                     conditionResult := (TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0) and (APwd = TExamServerGlobal.ServerCustomConfig.RetryPwd) or
                             (currentStatus = esAllowReExam);
                     msg := 'Examineesmanager ReExamLogin';
                  end;
               ltAddTimeExam :
                  begin
                     conditionResult := (TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0) and (APwd = TExamServerGlobal.ServerCustomConfig.AddTimePwd) or
                             (currentStatus = esAllowAddTimeExam);
                     msg := 'Examineesmanager AddTimeExam';
                  end;
            else
               begin
                  conditionResult := False;
                  msg             := format('Examineesmanager LoginType is %d', [ord(ALoginType)]);
               end;
            end;

            if conditionResult then
            begin
               ModifyExamineeInfo(esLogined);
               {$IFDEF DEBUG}
               CnDebugger.LogMsgWithTag(msg + ' login OK!', tempExaminee^.IP.Substring(8));
               {$ENDIF}
               PostMessage(FMessageHandler, CLM_Changed, longint(tempExaminee), 0);
               Result := crOk;
            end else begin
               {$IFDEF DEBUG}
               CnDebugger.LogMsgWithTag(msg + ' login refused!', tempExaminee^.IP.Substring(8));
               {$ENDIF}
               Dispose(tempExaminee);
               Result := crRefuseLogin;
            end;
         end
         else
            raise Exception.Create('Examineesmanager no examinee error');
      finally
         FExamineesList.UnlockList;
      end;
   end;

// procedure TExamineesManager.Notification(AComponent: TComponent; Operation: TOperation);
// var
// WasLocked:boolean;
// begin
// if (Operation=opRemove) and (AComponent=FDataSet) then
// begin
// WasLocked:=IsLocked;
// while IsLocked do Unlock;
// FDataset:=nil;
// if WasLocked then raise EMemTableError.Create('kbmDatasetRemoveLockedErr');
// end;
// inherited Notification(AComponent,Operation);
// end;

function TExamineesManager.FindItemByExamineeNo(AExamineeID : string; AList : TList) : integer;
   begin
      Result := 0;
      with AList do
      begin
         while (Result < Count) and (not((TExaminee(AList[Result]^).ID = AExamineeID))) do
         begin
            Inc(Result);
         end;
         if Result = Count then
            Result := -1;
      end;
   end;

function TExamineesManager.FindItemByIPPort(const ABinding : TIdSocketHandle; AList : TList) : integer;
   begin
      Result := 0;
      try

         with AList do
         begin
            while (Result < Count) and (not((TExaminee(AList[Result]^).IP = ABinding.PeerIP) and (TExaminee(AList[Result]^).Port = ABinding.PeerPort))) do
            begin
               Inc(Result);
            end;
            if Result = Count then
               Result := -1;
         end;
      except
         on E : Exception do
         begin

            {$IFDEF DEBUG}
            raise;
            {$ENDIF}
         end;
      end;
   end;

procedure TExamineesManager.FTimerTimer(Sender : TOBject);
   var
      myList    : TList;
      pListItem : PExaminee;
      // Examinee:TExaminee;
      escapeTime       : Int64;
      PMessageExaminee : PExaminee;
   begin
      myList := FExamineesList.LockList;
      try
         for pListItem in myList do
         begin
            with pListItem^ do
            begin
               // Examinee:=TExaminee(pListItem^);
               // if Examinee.Status in [esLogined,esReExamLogined, esContinueExamLogined,esGetTestPaper,esExamining,esGrading,esSutmitAchievement] then    begin
               if (Port > 0) and (Status > esLogined) and (Status < esExamEnded) then
               begin
                  escapeTime := System.Trunc(frac(Now - TimeStamp) * SecsPerDay); { TODO -ojp -cMust : 时间需要修改为刷新间隔 }
                  if escapeTime > 6 then
                  begin
                     Status := esDisConnect;
                     New(PMessageExaminee);
                     PMessageExaminee.ID         := ID;
                     PMessageExaminee.Name       := Name;
                     PMessageExaminee.IP         := IP;
                     PMessageExaminee.Port       := Port;
                     PMessageExaminee.RemainTime := RemainTime;
                     PMessageExaminee.Status     := Status;
                     PostMessage(FMessageHandler, CLM_Changed, longint(PMessageExaminee), 0);
                  end;
               end;
               if (Port > 0) and (Status >= esGrading) and (Status < esExamEnded) then
               begin
                  escapeTime := System.Trunc(frac(Now - TimeStamp) * SecsPerDay);
                  if escapeTime > 120 then
                  begin
                     Status := esGradeError;
                     New(PMessageExaminee);
                     PMessageExaminee.ID         := ID;
                     PMessageExaminee.Name       := Name;
                     PMessageExaminee.IP         := IP;
                     PMessageExaminee.Port       := Port;
                     PMessageExaminee.RemainTime := RemainTime;
                     PMessageExaminee.Status     := Status;
                     PostMessage(FMessageHandler, CLM_Changed, longint(PMessageExaminee), 0);
                  end;
               end;
            end;

         end;
      finally
         FExamineesList.UnlockList;
      end;
   end;

function TExamineesManager.FindItemByExamineeNo(AExaminee : PExaminee; AList : TList) : integer;
   begin
      Result := 0;
      with AList do
      begin
         while (Result < Count) and (not((TExaminee(AList[Result]^).ID = AExaminee.ID))) do
         begin
            Inc(Result);
         end;
         if Result = Count then
            Result := -1;
      end;
   end;

procedure TExamineesManager.UpdateStatus(AExaminee : PExaminee);
   var
      index  : integer;
      myList : TList;
      item   : TExaminee;
   begin
      myList := FExamineesList.LockList;
      try
         index := FindItemByExamineeNo(AExaminee, myList);
         if index <> -1 then
         begin
            TExaminee(myList[index]^).IP         := AExaminee.IP;
            TExaminee(myList[index]^).Port       := AExaminee.Port;
            TExaminee(myList[index]^).Status     := AExaminee.Status;
            TExaminee(myList[index]^).RemainTime := AExaminee.RemainTime;
            TExaminee(myList[index]^).TimeStamp  := Now;
            PostMessage(FMessageHandler, CLM_Changed, longint(AExaminee), 0);
         end else begin
            {$IFDEF DEBUG}
            CnDebugger.LogMsg('TExamineesManager UpdateStatus not find exaimineeID:' + AExaminee.ID);
            {$ENDIF}
            raise Exception.Create('no examinee error');
         end;

      finally
         FExamineesList.UnlockList;
      end;
   end;

procedure TExamineesManager.UpdateDisConnectStatus(const ABinding : TIdSocketHandle);
   var
      index     : integer;
      myList    : TList;
      AExaminee : PExaminee;
   begin
      myList := FExamineesList.LockList;
      try
         index := FindItemByIPPort(ABinding, myList);
         if index <> -1 then
         begin
            New(AExaminee);
            // TExaminee(myList[index]^).IP := AExaminee.IP;
            // TExaminee(myList[index]^).Port := AExaminee.Port;
            TExaminee(myList[index]^).Status := esDisConnect;
            // TExaminee(myList[index]^).RemainTime := AExaminee.RemainTime;
            AExaminee.ID         := TExaminee(myList[index]^).ID;
            AExaminee.Name       := TExaminee(myList[index]^).Name;
            AExaminee.IP         := TExaminee(myList[index]^).IP;
            AExaminee.Port       := TExaminee(myList[index]^).Port;
            AExaminee.Status     := esDisConnect;
            AExaminee.RemainTime := TExaminee(myList[index]^).RemainTime;
            // direct transfer list item to message ,because the list is exist before app is terminate;
            // in the message processing ,not to dispose list item;
            PostMessage(FMessageHandler, CLM_Changed, longint(AExaminee), 0);
         end
         // else
         // raise  Exception.Create('no examinee error');
      finally
         FExamineesList.UnlockList;
      end;
   end;

procedure TExamineesManager.UpdateTimeStamp(const ABinding : TIdSocketHandle);
   var
      index  : integer;
      myList : TList;
   begin
      myList := FExamineesList.LockList;
      try
         index := FindItemByIPPort(ABinding, myList);
         if index <> -1 then
         begin
            TExaminee(myList[index]^).TimeStamp := Now;
         end
         else
            raise Exception.Create('no examinee error');
      finally
         FExamineesList.UnlockList;
      end;
   end;

procedure TExamineesManager.UpdateScoreInfo(AExaminee : PExaminee);
   var
      index  : integer;
      myList : TList;
      item   : TExaminee;
   begin
      myList := FExamineesList.LockList;
      try
         index := FindItemByExamineeNo(AExaminee, myList);
         if index <> -1 then
         begin
            // TExaminee(myList[index]^).IP := AExaminee.IP;
            // TExaminee(myList[index]^).Port := AExaminee.Port;
            TExaminee(myList[index]^).Status := AExaminee.Status;
            // TExaminee(myList[index]^).RemainTime := AExaminee.RemainTime;
            TExaminee(myList[index]^).ScoreCompressedStream := AExaminee.ScoreCompressedStream;
            PostMessage(FMessageHandler, CLM_Changed, longint(AExaminee), 0);
         end
         else
            raise Exception.Create('no examinee error');
      finally
         FExamineesList.UnlockList;
      end;
   end;

// procedure TExamineesManager.SaveExamineeInfo;
// var
// myList:TList;
// begin
// myList:= ExamineesList.LockList;
// try
// GlobalStkRecordInfo.UpdateExamineeInfo(myList);
// finally
// ExamineesList.UnlockList;
// end;
// end;

end.
