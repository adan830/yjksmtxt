unit CMDServer;

interface
uses idTcpServer, Controls,  IdSchedulerOfThreadPool,
  IdContext,NetPubUtils, syncObjs, uStkRecordInfo,
  IdServerInterceptLogFile;
type
   TCMDServer=class
   private
      FServer: TIdTCPServer;
      FStkRecordInfo:TStkRecordInfo;
      IdServerInterceptLogFile1: TIdServerInterceptLogFile;
      IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
      FUsers:TUsers;
      FLock:TCriticalSection;
      function DoClientStatusCommand(AContext: TIdContext; Cmd: string): boolean;
      function DoGetClientInfoCommand(AContext: TIDContext; ksh: string): boolean;
      function HandleCommand(AContext: TIdContext; cmd: string): boolean;
      procedure tcpServerOnConnect(AContext: TIdContext);
      procedure tcpServerOnDisconnect(AContext: TIdContext);
      procedure tcpServerExecute(AContext: TIdContext);
      procedure SetActive(const Value: boolean);

      function DoGetEQInfoCommand(AContext: TIDContext): boolean;
      function DoGetEQRecordCommand(AContext: TIDContext;ARecordNo:String): boolean;
    function DoGetEQFileCommand(AContext: TIDContext; AFileID: String): boolean;
   protected
   public
      constructor Create(AOwner:TWinControl;APort:integer);
      destructor Destroy; override;

      property Active :boolean write SetActive;

   end;
implementation

uses
  Classes, SysUtils,uServerUtils;

{ TTcpServer }

constructor TCMDServer.Create(AOwner: TWinControl;APort:integer);
begin
   IdServerInterceptLogFile1:=TIdServerInterceptLogFile.Create(AOwner);
   IdSchedulerOfThreadPool1:=TIdSchedulerOfThreadPool.Create(AOwner);
   FServer:=TIdTCPServer.Create(AOwner);
   FServer.DefaultPort:=APort;
   FServer.Intercept:=IdServerInterceptLogFile1;
   FServer.Scheduler:=IdSchedulerOfThreadPool1;
   FServer.OnExecute:=tcpServerExecute;
   FServer.OnConnect:=tcpServerOnConnect;
   FServer.OnDisconnect:=tcpServerOnDisconnect;
   FLock:=TCriticalSection.Create;
   FUsers:=TUsers.Create(AOwner);

   FStkRecordInfo:=TStkRecordInfo.Create;
   FStkRecordInfo.SetupEQStrategies;
   FStkRecordInfo.SetupMemStk;
   FStkRecordInfo.SetupMemStkFile;
end;

destructor TCMDServer.Destroy;
begin
   FServer.Free;
   IdSchedulerOfThreadPool1.Free;
   IdServerInterceptLogFile1.Free;
   { TODO : free all sub object }
   FUsers.Free;
   FLock.Free;
   inherited;
end;


procedure TCMDServer.tcpServerOnConnect(AContext: TIdContext);
var
  aIP: string;

  usersList:TList;
  user:TUser;
  index:integer;
begin
   usersList:=FUsers.LockList;
   try
      if FUsers.FindItemByIPPort(AContext.Binding.PeerIP,AContext.Binding.PeerPort)=-1 then
      begin
         user := TUser.Create(AContext.Binding.PeerIP,AContext.Binding.PeerPort, AContext);
         FUsers.Add(user);
      end;
   finally
      FUsers.UnlockList;
   end;
end;

procedure TCMDServer.tcpServerOnDisconnect(AContext: TIdContext);
var
   user:TUser;
begin
  user := TUser(AContext.Data); 
  if user <> nil then
  begin
    user.Lock;
    try
      user.Context := nil;
      FUsers.UpdateStatus(AContext.Binding.PeerIP,AContext.Binding.PeerPort,csDisConnected,0);
    finally
      user.Unlock;
    end;
  end;

end;

procedure TCMDServer.tcpServerExecute(AContext: TIdContext);
var
  Client: TUser;
  cmd: string;
begin
  Client := TUser(AContext.Data);
  if Client <> nil then
  begin
    Client.Lock;
    try
      AContext.Connection.IOHandler.CheckForDataOnSource(250);
      if not AContext.Connection.IOHandler.InputBufferIsEmpty then
      begin
          cmd := AContext.Connection.IOHandler.ReadLn;

          FLock.Enter;
          try
//            Memo1.Lines.Add(Format(' %s ："%s"',
//              [Client.IP,  cmd]));
            HandleCommand(AContext,cmd);
          finally
            FLock.Leave;
          end;

      end;
    finally
      Client.Unlock;
    end;
  end;
end;

//handle command 
function TCMDServer.HandleCommand(AContext:TIdContext;cmd:string):boolean;
begin
   //TextIsSame(Copy(AData, 1, Length(Command)), Command);
   if pos(CMD_GETCLIENTINFO,cmd)=1 then
      result:=DoGetClientInfoCommand(AContext,trim(copy(cmd,15,length(cmd))));
   if pos(CMD_CLIENTSTATUS,cmd)=1 then
      result:=DoClientStatusCommand(AContext,cmd);
   if pos(CMD_GETEQINFO,cmd)=1 then
      result:=DoGetEQInfoCommand(AContext);
   if pos(CMD_GETEQRECORD,cmd)=1 then
      result:=DoGetEQRecordCommand(AContext,trim(copy(cmd,13,length(cmd))));
   if pos(CMD_GETEQFILE,cmd)=1 then
      result:=DoGetEQFileCommand(AContext,trim(copy(cmd,11,length(cmd))));
end;

procedure TCMDServer.SetActive(const Value: boolean);
begin
   FServer.Active:=value;
end;

//command handler for GetClientInfo
function  TCMDServer.DoGetClientInfoCommand(AContext:TIDContext;ksh:string):boolean;
var
   ksxm:string;
   clientIP:string;
   clientPort:integer;
begin
   with AContext.Connection.IOHandler do
   begin
      ksxm:=GetKsxmByKsh(ksh);
      WriteLn(ksxm);
      clientIP:=AContext.Binding.PeerIP;
      clientPort:=AContext.Binding.PeerPort;
      //FUsers.Add(clientIP,clientPort,ksh,ksxm);
//      RefreshData;
   end;

//begin
//   try
//      with ASender.Context.Connection.IOHandler do
//      begin
//         clientStatus:=TClientStatus( StrToInt( ReadLn));
//         clientRemainTime := StrToInt( readln);
//         clientIP:=ASender.Context.Binding.PeerIP;
//         clientPort:=ASender.Context.Binding.PeerPort;
//         FUsers.UpdateStatus(clientIP,clientPort,clientStatus,clientRemainTime);
//      end;
//   except on E: Exception do
//      OutputDebugString('read client stauts error');
//   end;
end;

//command handler for GetClientInfo
function  TCMDServer.DoGetEQInfoCommand(AContext:TIDContext):boolean;
var
   EQInfo:TStringList;
begin
   with AContext.Connection.IOHandler do
   begin
      EQInfo:=FStkRecordInfo.AcquireEQInfo(FStkRecordInfo.EQStrategies[0]);
      WriteLn(inttostr(EQInfo.Count));
      //sleep(5000);
      WriteRFCStrings(EQInfo,false);
   end;
end;

function  TCMDServer.DoGetEQFileCommand(AContext:TIDContext;AFileID:string):boolean;
var
   EQFile:TMemoryStream;
begin
   with AContext.Connection.IOHandler do
   begin
      try
         EQFile:=FStkRecordInfo.AcquireEQFile(AFileID);
         if EQFile<>nil then begin
            try
               EQFile.Position:=0;
               Write(EQFile,EQFile.Size,true);
            finally
               EQFile.Free;
            end;
         end;
      except on E: Exception do
         raise;
      end;
   end;
end;

//command handler for GetClientInfo
function  TCMDServer.DoGetEQRecordCommand(AContext:TIDContext;ARecordNo:String):boolean;
var
   EQRecord:TStringList;
   recordPacket:TClientEQRecordPacket;
   i:integer;
begin
   with AContext.Connection.IOHandler  do
   begin
      try
         recordPacket:=FStkRecordInfo.AcquireEQRecord(ARecordNo);
         EQRecord:=TStringList.Create;

            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_lr;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);

            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_item1;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);
            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_item2;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);
            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_item3;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);
            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_item4;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);
            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_da;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);
            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_hj;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);
            EQRecord.Clear;
            EQRecord.Text:=recordPacket.st_da1;
            WriteLn(inttostr(EQRecord.Count));
            WriteRFCStrings(EQRecord,false);


      finally
         //recordStream.Free;
      end;


   end;
end;

function TCMDServer.DoClientStatusCommand(AContext:TIdContext;Cmd:string):boolean;
var
   clientStatus:TClientStatus;
   clientRemainTime:Integer;
   clientIP:string;
   clientPort:integer;
   cmdList:TStringList;
begin
   cmdList:=TStringList.create;
   cmdList.DelimitedText:=cmd;
   with AContext.Connection.IOHandler do
   begin
      clientStatus:=TClientStatus(strtoint(cmdList[1]));
      clientRemainTime:=strtoint(cmdList[2]);
      clientIP:=AContext.Binding.PeerIP;
      clientPort:=AContext.Binding.PeerPort;
      FUsers.UpdateStatus(clientIP,clientPort,clientStatus,clientRemainTime);
   end;
end;
//var
//  aFileSize : Integer;
//  aFileName : String;
//  Buff : array[0..1023] of Byte;
//  ReadCount : Integer;
//begin
//  with AThread.Data as TThreadData do
//  begin
//    if State = dstNone then
//    begin
//      if not AThread.Terminated and AThread.Connection.Connected then
//      begin
//        //读取文件名
//        aFileName := AThread.Connection.ReadLn(#13#10, 100);
//        if aFileName = '' then
//          Exit;
//        SaveDialog1.FileName := aFileName;
//        if SaveDialog1.Execute then
//        begin
//          //返回确认文件传输标志
//          AThread.Connection.WriteLn;
//          //开始读取文件长度，创建文件
//          AThread.Connection.ReadBuffer(aFileSize, 4);
//          FileSize := aFileSize;
//          ProgressBar1.Max := FileSize;
//          Stream := TFileStream.Create(SaveDialog1.FileName, fmCreate);
//          State := dstReceiving;
//        end
//        else
//          AThread.Connection.Disconnect
//      end;
//    end else begin
//      if not AThread.Terminated and AThread.Connection.Connected then
//      begin
//        //读取文件流
//        repeat
//          if FileSize - Stream.Size > SizeOf(Buff) then
//            ReadCount := SizeOf(Buff)
//          else
//            ReadCount := FileSize - Stream.Size;
//          AThread.Connection.ReadBuffer(Buff, ReadCount);
//          Stream.WriteBuffer(Buff, ReadCount);
//          ProgressBar1.Position := Stream.Size;
//          Caption := IntToStr(Stream.Size) + '/' + IntToStr(FileSize);
//          Application.ProcessMessages;
//        until Stream.Size >= FileSize;
//        AThread.Connection.WriteLn('OK');
//        Stream.Free;
//        Stream := nil;
//        State := dstNone;
//      end;
//    end;
//  end;
//  if OpenDialog1.Execute then
//  begin
//    IdTCPClient1.Connect;
//    aStream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareDenyWrite);
//    try
//      //发送文件名
//      aFileName := ExtractFileName(OpenDialog1.FileName);
//      IdTCPClient1.WriteLn(aFileName);
//      //等待接受确认
//      IdTCPClient1.ReadLn(#13#10, 1000);
//      //写文件长度和文件流
//      aSize := aStream.Size;
//      ProgressBar1.Max := aSize;
//      IdTCPClient1.WriteBuffer(aSize, 4);
//      //IdTCPClient1.WriteStream(aStream);
//      while aStream.Position < aStream.Size do
//      begin
//        if aStream.Size - aStream.Position >= SizeOf(Buf) then
//          ReadCount := sizeOf(Buf)
//        else
//          ReadCount := aStream.Size - aStream.Position;
//        aStream.ReadBuffer(Buf, ReadCount);
//        IdTCPClient1.WriteBuffer(Buf, ReadCount);
//        ProgressBar1.Position := aStream.Position;
//        Application.ProcessMessages;
//      end;
//      Caption := IdTCPClient1.ReadLn;
//      IdTCPClient1.Disconnect;
//    finally
//      aStream.Free;
//    end;

end.
