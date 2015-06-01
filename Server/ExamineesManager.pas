unit ExamineesManager;

interface
uses Classes,Controls,ExtCtrls,DB,Windows,SysUtils,IdSocketHandle, NetGlobal;

type

   EMemTableError = class(EDataBaseError);

   //TListChangedEvent =procedure(const item:TClientbak) of object;  //index=-1��ʾ��һ��ı䣬�����ʾindex����ı�

   { TODO -ojp : ���̰߳�ȫ������Ҫ��֤ }
   TExamineesManager= class
   private
      //ֻ����ָ����Χ�ڵĿ�����¼��Ҫ�����趨��Χ������ʾ����
      FExamineesList : TThreadList;
      FMessageHandler : THandle;  //�����б���Ϣ�Ĵ���
      FTimer : TTimer;
      function FindItemByExamineeNo(AExaminee: PExaminee; AList: TList): integer; overload;
      function FindItemByExamineeNo(AExamineeID:string; AList: TList): integer; overload;
      procedure FTimerTimer(Sender: TObject);
    function GetCount: Integer;
   protected
      //procedure Notification(AComponent: TComponent; Operation: TOperation); override;
   public
      constructor Create(AMessageHandler: THandle);
      destructor Destroy; override;
//==============================================================================
// GetExamineeInfo �����ܻ�ȡ�Ŀ�����Ϣ
//==============================================================================
      procedure GetExamineeInfo(const AExamineeID: string;out AExaminee:TExaminee);
      procedure UpdateTimeStamp(const ABinding: TIdSocketHandle);
      function Login(AExaminee: PExaminee; ALoginType: TLoginType; APwd: string; out ARemainTime: integer): TCommandResult;
      ///�����Ѵ��ڵ������������������������ڷ��� -1;
      function FindItemByIPPort(const ABinding: TIdSocketHandle; AList: TList):integer;

       procedure UpdateStatus(AExaminee: PExaminee);
       procedure UpdateDisConnectStatus(const ABinding: TIdSocketHandle);
       procedure UpdateScoreInfo(AExaminee: PExaminee);
       procedure EnableTimer(AValue:Boolean);
       procedure SaveExamineeInfo();
       function Add(AExaminee : PExaminee) :Boolean;
  published
      property ExamineesList : TThreadList read FExamineesList;
      property Count :Integer read GetCount;
  end;

  const
  ColIndexOfExamineeNo = 0;
  ColIndexOfExamineeName = 1;
  ColIndexOfIP = 2;
  ColIndexOfPort = 3;
  ColIndexOfStatus = 4;
  ColIndexOfRemainTime =5;

implementation

uses
  Variants, ServerUtils,Forms, ServerGlobal, StkRecordInfo;

function TExamineesManager.Add(AExaminee: PExaminee) : Boolean;
var
  list: TList;
begin
  Result := False;
  list:=ExamineesList.LockList;
    try
      if FindItemByExamineeNo(AExaminee.ID,list)=-1 then begin
         list.Add(AExaminee);
         Result := True;
      end;
         
    finally
      ExamineesList.UnlockList;
    end;
end;

constructor TExamineesManager.Create(AMessageHandler: THandle);
begin
   inherited Create();
   FMessageHandler := AMessageHandler;
   FExamineesList := TThreadList.Create();
   FTimer := TTimer.Create(nil);
   FTimer.Enabled := False;
   FTimer.Interval := 3000;
   FTimer.OnTimer := FTimerTimer;
end;

destructor TExamineesManager.Destroy;
var
   i:Integer;
   list :TList;
   p:PExaminee;
begin
   FMessageHandler := 0;
   list := FExamineesList.LockList;
   try
     for i := list.Count-1 downto 0  do begin
        p := list[i];
        list.Delete(i);
        ///������Ҫ���ǣ�ΪʲôΪ��
        if Assigned(p.ScoreCompressedStream) then p.ScoreCompressedStream.Free;
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

procedure TExamineesManager.EnableTimer(AValue: Boolean);
begin
   if FTimer.Enabled <>AValue then
      FTimer.Enabled := AValue;
end;

procedure TExamineesManager.SaveExamineeInfo;
var
   myList:TList;
begin
   myList:= ExamineesList.LockList;
   try
      TExamServerGlobal.GlobalStkRecordInfo.UpdateExamineeInfo(myList);
   finally
      ExamineesList.UnlockList;
   end;
end;

function TExamineesManager.GetCount: Integer;
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

procedure TExamineesManager.GetExamineeInfo(const AExamineeID : string;out AExaminee:TExaminee);
var
   list : TList;
   index: Integer;
begin
   list := FExamineesList.LockList;
   try
     index :=FindItemByExamineeNo(AExamineeID,list);
     if index <>-1 then begin
       AExaminee := TExaminee(list[index]^);
       //no need score
       AExaminee.ScoreCompressedStream := nil;
     end
     else begin
        AExaminee.ID := AExamineeID;
        AExaminee.Name := CMDNOEXAMINEEINFO;
        AExaminee.ScoreCompressedStream := nil;
     end;
   finally
     FExamineesList.UnlockList;
   end;
end;

//function TExamineesManager.ExamineeLogin(AExamineeNo : string):string;
//begin
//   //   { TODO -ojp -cInprove : ������������߲����ٶ� }
////   // Wait for critical section.
////     inc(FLockCount);
////     n:=WaitForSingleObject(FSemaphore,3000);
////     if (n=WAIT_TIMEOUT) or (n=WAIT_FAILED) then
////     begin
////         dec(FLockCount);
////         exit;
////     end else begin
////         try
//            try
//               if FCDSExaminees.Locate('ExamineeNo', AExamineeNo, []) then
//               begin
//                  Result := FCDSExaminees.FieldValues['ExamineeName'];
//               end;
//            except
//               OutputDebugString(PChar('Get ExamineeName error:'+AExamineeNo));
//            end;
////         finally
////            dec(FLockCount);
////            ReleaseSemaphore(FSemaphore,1,nil);
////         end;
////     end;
//end;


function TExamineesManager.Login(AExaminee: PExaminee; ALoginType: TLoginType; APwd: string;out ARemainTime: integer): TCommandResult;
var
   index:integer;
   myList :TList;
   tempExaminee:PExaminee;

   procedure ModifyExamineeInfo(AStatus: TExamineeStatus);
   begin
     TExaminee(myList[index]^).IP := AExaminee.IP;
     TExaminee(myList[index]^).Port :=AExaminee.Port;
     TExaminee(myList[index]^).Status :=AStatus;// esLogined;
//     TExaminee(myList[index]^).RemainTime:= CONSTEXAMINENATIONTIME;
     TExaminee(myList[index]^).TimeStamp := Now;

     AExaminee.Name := TExaminee(myList[index]^).Name;
     AExaminee.Status := AStatus;//esLogined ;
     AExaminee.RemainTime := TExaminee(myList[index]^).RemainTime ;
     ARemainTime := TExaminee(myList[index]^).RemainTime ;
     //Ϊ��examineeͨ����Ϣ����ȥ��������һ����ʱ�����������¼����չ����б��ͷš�
     New(tempExaminee);
     tempExaminee.Assign(AExaminee^);
   end;
begin
   Result := crError;
   begin
     myList:=FExamineesList.LockList;
     try
        index:= FindItemByExamineeNo(AExaminee,myList );
        if index <>-1  then begin
           case ALoginType of
             ltFirstLogin:begin
                             ModifyExamineeInfo(esLogined);

                             PostMessage(FMessageHandler,CLM_Changed,longint(tempExaminee),0);
                             Result := crOk;
                          end;
             ltContinuteInterupt: begin
                             //if APwd=GlobalStkRecordInfo.GetEQStrategiesItem(0).ContinueExamPwd then
                             begin
                                ModifyExamineeInfo(esLogined);
                                PostMessage(FMessageHandler,CLM_Changed,longint(tempExaminee),0);
                                Result := crOk;
                             end;
                          end;
             ltContinuteEndedExam: begin
                             //if APwd=GlobalStkRecordInfo.GetEQStrategiesItem(0).ContinueExamPwd then
                             begin
                                ModifyExamineeInfo(esLogined);
                                PostMessage(FMessageHandler,CLM_Changed,longint(tempExaminee),0);
                                Result := crOk;
                             end;
                          end;
             ltReExamLogin:begin
//                             if APwd=GlobalStkRecordInfo.GetEQStrategiesItem(0).ContinueExamPwd then
                             begin
                               ModifyExamineeInfo(esLogined);
                               PostMessage(FMessageHandler,CLM_Changed,longint(tempExaminee),0);
                               Result := crOk;
                             end
                          end;
           end;
        end else
           raise  Exception.Create('no examinee error');
     finally
        FExamineesList.UnlockList;
     end;
   end;
end;

//procedure TExamineesManager.Notification(AComponent: TComponent; Operation: TOperation);
//var
//   WasLocked:boolean;
//begin
//     if (Operation=opRemove) and (AComponent=FDataSet) then
//     begin
//          WasLocked:=IsLocked;
//          while IsLocked do Unlock;
//          FDataset:=nil;
//          if WasLocked then raise EMemTableError.Create('kbmDatasetRemoveLockedErr');
//     end;
//     inherited Notification(AComponent,Operation);
//end;


function TExamineesManager.FindItemByExamineeNo(AExamineeID: string; AList: TList): integer;
begin
   result:=0;
   with AList do begin
      while (Result < Count) and (not((TExaminee(AList[Result]^).ID = AExamineeID))) do
      begin
         Inc(Result);
      end;
      if Result = Count then
       Result := -1;
   end;
end;

function TExamineesManager.FindItemByIPPort(const ABinding: TIdSocketHandle; AList: TList): integer;
begin
   result:=0;
   try

      with AList do begin
         while (Result < Count) and (not((TExaminee(AList[Result]^).IP= ABinding.PeerIP)and(TExaminee(AList[Result]^ ).Port = ABinding.PeerPort))) do
         begin
            Inc(Result);
         end;
         if Result = Count then
          Result := -1;
      end;
   except
         on E:Exception do begin

            {$IFDEF DEBUG}
            raise;
            {$ENDIF}
         end;
   end;
end;

procedure TExamineesManager.FTimerTimer(Sender: TObject);
var
   myList:TList;
   pListItem: PExaminee;
   //Examinee:TExaminee;
   escapeTime:Int64;
   PMessageExaminee:PExaminee;
begin
   myList:=FExamineesList.LockList;
      try
         for pListItem in myList do begin
            with pListItem^ do
            begin
              //Examinee:=TExaminee(pListItem^);
              //if Examinee.Status in [esLogined,esReExamLogined, esContinueExamLogined,esGetTestPaper,esExamining,esGrading,esSutmitAchievement] then    begin
              if (Port>0)and(Status >=esLogined)and (Status <esExamEnded)  then begin
                 escapeTime:= System.Trunc(frac(Now - TimeStamp)*SecsPerDay);
                 if escapeTime>6 then begin
                    Status := esDisConnect;
                    New(PMessageExaminee);
                    PMessageExaminee.ID := ID;
                    PMessageExaminee.Name := Name;
                    PMessageExaminee.IP := ip;
                    PMessageExaminee.Port := Port;
                    PMessageExaminee.RemainTime :=RemainTime;
                    PMessageExaminee.Status :=Status;
                    PostMessage(FMessageHandler,CLM_Changed,longint(PMessageExaminee),0);
                 end;
              end;
              if (Port>0)and(Status >=esGrading)and (Status <esExamEnded)  then begin
                 escapeTime:= System.Trunc(frac(Now - TimeStamp)*SecsPerDay);
                 if escapeTime>120 then begin
                    Status := esGradeError;
                    New(PMessageExaminee);
                    PMessageExaminee.ID := ID;
                    PMessageExaminee.Name := Name;
                    PMessageExaminee.IP := ip;
                    PMessageExaminee.Port := Port;
                    PMessageExaminee.RemainTime :=RemainTime;
                    PMessageExaminee.Status :=Status;
                    PostMessage(FMessageHandler,CLM_Changed,longint(PMessageExaminee),0);
                 end;
              end;
            end;
              
         end;
      finally
         FExamineesList.UnlockList;
      end;
end;

function TExamineesManager.FindItemByExamineeNo(AExaminee :PExaminee; AList: TList): integer;
begin
   result:=0;
   with AList do begin
      while (Result < Count) and (not((TExaminee(AList[Result]^).ID = AExaminee.ID))) do
      begin
         Inc(Result);
      end;
      if Result = Count then
       Result := -1;
   end;
end;

procedure TExamineesManager.UpdateStatus(AExaminee :PExaminee);
var
   index:integer;
   myList :TList;
   item:TExaminee;
begin
   myList:=FExamineesList.LockList;
   try
     index:= FindItemByExamineeNo(AExaminee,myList );
     if index <>-1  then begin
        TExaminee(myList[index]^).IP := AExaminee.IP;
        TExaminee(myList[index]^).Port := AExaminee.Port;
        TExaminee(myList[index]^).Status := AExaminee.Status;
        TExaminee(myList[index]^).RemainTime := AExaminee.RemainTime;
        TExaminee(myList[index]^).TimeStamp := now;
        PostMessage(FMessageHandler,CLM_Changed,longint(AExaminee),0);
     end else
        raise  Exception.Create('no examinee error');
   finally
     FExamineesList.UnlockList;
   end;
end;


procedure TExamineesManager.UpdateDisConnectStatus(const ABinding: TIdSocketHandle);
var
   index:integer;
   myList :TList;
   AExaminee:PExaminee;
begin
   myList:=FExamineesList.LockList;
   try
     index:= FindItemByIPPort(ABinding,myList);
     if index <>-1  then begin
        New(AExaminee);
        //TExaminee(myList[index]^).IP := AExaminee.IP;
        //TExaminee(myList[index]^).Port := AExaminee.Port;
        TExaminee(myList[index]^).Status := esDisConnect;
        //TExaminee(myList[index]^).RemainTime := AExaminee.RemainTime;
        AExaminee.ID := TExaminee(myList[index]^).ID;
        AExaminee.Name := TExaminee(myList[index]^).Name;
        AExaminee.IP := TExaminee(myList[index]^).IP;
        AExaminee.Port := TExaminee(myList[index]^).Port;
        AExaminee.Status := esDisConnect;
        AExaminee.RemainTime :=TExaminee(myList[index]^).RemainTime;
        //direct transfer list item to message ,because the list is exist before app is terminate;
        // in the message processing ,not to dispose list item;
        PostMessage(FMessageHandler,CLM_Changed,longint(AExaminee),0);
     end
   //         else
   //            raise  Exception.Create('no examinee error');
   finally
     FExamineesList.UnlockList;
   end;
end;

procedure TExamineesManager.UpdateTimeStamp(const ABinding: TIdSocketHandle);
var
   index:integer;
   myList :TList;
begin
   myList:=FExamineesList.LockList;
   try
     index:= FindItemByIPPort(ABinding,myList);
     if index <>-1  then begin
        TExaminee(myList[index]^).TimeStamp := Now;
     end else
        raise  Exception.Create('no examinee error');
   finally
     FExamineesList.UnlockList;
   end;
end;

procedure TExamineesManager.UpdateScoreInfo(AExaminee :PExaminee);
var
   index:integer;
   myList :TList;
   item:TExaminee;
begin
      myList:=FExamineesList.LockList;
      try
         index:= FindItemByExamineeNo(AExaminee,myList );
         if index <>-1  then begin
//            TExaminee(myList[index]^).IP := AExaminee.IP;
//            TExaminee(myList[index]^).Port := AExaminee.Port;
            TExaminee(myList[index]^).Status := AExaminee.Status;
//            TExaminee(myList[index]^).RemainTime := AExaminee.RemainTime;
            TExaminee(myList[index]^).ScoreCompressedStream := AExaminee.ScoreCompressedStream;
            PostMessage(FMessageHandler,CLM_Changed,longint(AExaminee),0);
         end else
            raise  Exception.Create('no examinee error');
      finally
         FExamineesList.UnlockList;
      end;
end;

//procedure TExamineesManager.SaveExamineeInfo;
//var
//   myList:TList;
//begin
//   myList:= ExamineesList.LockList;
//   try
//      GlobalStkRecordInfo.UpdateExamineeInfo(myList);
//   finally
//      ExamineesList.UnlockList;
//   end;
//end;



end.

