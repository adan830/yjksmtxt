unit clientmm;

interface

type
 TClientsList= class(TThreadList)
      private
         FOnListChanged:TListChangedEvent;
         FOwner:TWinControl;
         FTimer:TTimer;
         procedure FTimerTimer(Sender: TObject);
         function GetItem(AIndex: Integer): TClientbak;
      public
         constructor Create();
         procedure Add(AUser:TExaminee);overload;


         procedure UpdateStatus(AIP: string; APort: integer;  AStatus: TExamineeStatus; ARemainTime: integer); overload;
         procedure UpdateStatus(AExamineeNo : string; AIP: string; APort: integer;  AStatus: TExamineeStatus; ARemainTime: integer); overload;
         function SetItemState(ip:string;port:integer;state:TExamineeStatus):integer;

         ///查找已存在的项，返回数组索引，如果不存在返回 -1;
         function FindItemByIPPort(ip: string; port: Integer; AList: TList):integer;
         function FindItemByExamineeNo(AExamineeNo: string; AList: TList):integer;

         property Item[index:integer]:TClientbak read GetItem; default;
         property OnListChanged:TListChangedEvent read FOnListChanged write FOnListChanged;
   end;

 TClientbak = class
   private
      FID:integer;
      FExamineeName:string;
      FIP:string;
      FPort:integer;
      FExamineeNo:string;
      FStatus:TExamineeStatus;
      FRemainTime:integer;
      FTimeStamp:TDateTime;
   public
      constructor Create(AExamineeNo, AExamineeName, aIP: string; aPort: Integer; AStatus: TExamineeStatus; ARemainTime: Integer); reintroduce;
     
      property ID: integer read FID;
      property ExamineeNo: string read FExamineeNo write FExamineeNo;
      property ExamineeName: string read FExamineeName write FExamineeName;
      property IP: string read FIP write FIP;
      property Port: Integer read FPort write FPort;
      property Status: TExamineeStatus read FStatus write FStatus;
      property RemainTime: integer read FRemainTime write FRemainTime;
      property TimeStamp: TDateTime read FTimeStamp write FTimeStamp;
   end;

implementation

{ TClientbak }

constructor TClientbak.Create(AExamineeNo, AExamineeName, aIP: string; aPort: Integer; AStatus: TExamineeStatus; ARemainTime: Integer);
begin
   FIP := aIP;
   FPort := aPort;
   FStatus := AStatus;
   FRemainTime := ARemainTime;
end;

{ TClientsList }

procedure TClientsList.Add(AUser:TExaminee);
var
   myList:TList;
begin
//   myList:=LockList;
//   try
//      myList.Add(AUser);
//      PostMessage(FOwner.Handle,CLM_Added,longint(AUser),0);
//   finally
//      UnlockList;
//   end;
end;


constructor TClientsList.Create();
begin
   inherited Create();
   //FOwner:=aOwner;
//   FTimer:=TTimer.Create(nil);
//   FTimer.Enabled:=false;
//   FTimer.Interval:=1000;
//   FTimer.OnTimer:=FTimerTimer;
   //FTimer.Enabled:=true;
end;


function TClientsList.FindItemByExamineeNo(AExamineeNo: string; AList: TList): integer;
begin
   result:=0;
   with AList do begin
      while (Result < Count) and (not((TClientbak(AList[Result]).ExamineeNo = AExamineeNo))) do
      begin
         Inc(Result);
      end;
      if Result = Count then
         Result := -1;
   end;
end;


function TClientsList.FindItemByIPPort(ip: string; port: Integer; AList: TList): integer;
begin
   result:=0;
   with AList do begin
      while (Result < Count) and (not((TClientbak(AList[Result]).IP= ip)and(TClientbak(AList[Result] ).Port = port))) do
      begin
         Inc(Result);
      end;

      if Result = Count then
       Result := -1;
   end;
end;



function TClientsList.GetItem(AIndex: Integer): TClientbak;
var
   list : TList;
begin
   list := LockList;
   try
      Result := list[AIndex];
   finally
      UnlockList;
   end;
end;


function TClientsList.SetItemState(ip: string; port: integer;state:TExamineeStatus): integer;
var
   index:integer;
begin
//   index:= FindItemByIPPort(ip,port);
//   if index=-1 then
//   begin
//      result:=index;
//   end else begin
//      FList[index].State:=state;
//      if Assigned(FOnListChanged) then
//         FOnListChanged(index);
//      result:=index;
//   end;


end;


procedure TClientsList.UpdateStatus(AExamineeNo, AIP: string; APort: integer; AStatus: TExamineeStatus; ARemainTime: integer);
var
   index:integer;
   myList :TList;
   item:TClientbak;
begin
   myList:=LockList;
   try
      index:= FindItemByIPPort(AIP, APort,myList );
      if index <>-1  then begin
         item:=TClientbak(myList[index]);
         if AStatus=esNotLogined then
         begin
            if item.ExamineeNo <> CMDNULLNONAME then
            begin
               //if  item.ExamineeName =EmptyStr then item.ExamineeName :=
               item.ExamineeNo := AExamineeNo;
               item.Status:=AStatus;
               item.RemainTime:=ARemainTime;
               item.TimeStamp:=now;
               PostMessage(FOwner.Handle,CLM_Changed,longint(item),0);
            end else
                begin
                   myList.Remove(item);
                   PostMessage(FOwner.Handle,CLM_Deleted,longint(item),0);
   //              item.Free;
                end;
         end else
             begin
                  item.FExamineeNo := AExamineeNo;
                  item.FStatus:=AStatus;
                  item.FRemainTime:=ARemainTime;
                  item.FTimeStamp:=now;
                  PostMessage(FOwner.Handle,CLM_Changed,longint(item),0);
             end;
      end else  begin
                  Add(TClientbak.Create(CMDNULLNONAME,CMDNULLNONAME , AIP,APort ,AStatus, ARemainTime));
                end;
   finally
      UnlockList;
   end;
end;


procedure TClientsList.UpdateStatus(AIP: string; APort: integer;  AStatus: TExamineeStatus; ARemainTime: integer);
var
   index:integer;
   myList :TList;
   item:TClientbak;
begin
   //index:= FindItemByIPPort(AIP, APort, );
   if index<>-1 then
   begin
      myList:=LockList;
      try
         item:=TClientbak(myList[index]);
         if AStatus=esNotLogined then
         begin
            if item.ExamineeNo<>'' then
            begin
               item.FStatus:=AStatus;
               item.FRemainTime:=ARemainTime;
               item.FTimeStamp:=now;
               PostMessage(FOwner.Handle,CLM_Changed,longint(item),0);
            end else
                begin
                   myList.Remove(item);

                   PostMessage(FOwner.Handle,CLM_Deleted,longint(item),0);
   //              item.Free;
                end;
         end else
             begin
                  item.FStatus:=AStatus;
                  item.FRemainTime:=ARemainTime;
                  item.FTimeStamp:=now;
                  PostMessage(FOwner.Handle,CLM_Changed,longint(item),0);
             end;

      finally
         UnlockList;
      end;
   end else
       begin
          Add(TClientbak.Create(CMDNULLNONAME,CMDNULLNONAME ,AIP,APort ,AStatus, ARemainTime));
       end;
end;


procedure TClientsList.FTimerTimer(Sender: TObject);
begin
   try

   except on E: Exception do
   end;

end;
{ TUser }


end.
