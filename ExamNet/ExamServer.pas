{
  {  12/12/2007
  {

}

unit ExamServer;

interface

uses
   IdGlobal, IdCmdTCPServer, Classes, ExamineesManager, IdSchedulerOfThreadPool, IdServerInterceptLogFile, IdContext,
   IdCustomTCPServer, SysUtils, IdCommandHandlers;

type
   TExamServer       = class;
   ECommandException = class(Exception);

   // event
   TOnUpdateStatus = procedure(ASender : TExamServer; const ADocument : string) of object;

   TExamServer = class(TIdCmdTCPServer)
   private
      FExamineesManager : TExamineesManager;
      FThreadPool       : TIdSchedulerOfThreadPool;
      procedure ExamServerOnDisconnect(AContext : TIdContext);
      procedure ExamServerListenException(AThread : TIdListenerThread; AException : Exception);
      procedure ExamServerException(AContext : TIdContext; AException : Exception);
      procedure CmdHandleException(ACommand : String; AContext : TIdContext);

      // CommandHandlers
      procedure commandSendExamineeStatus(ASender : TIdCommand);
      procedure CommandGetExamineeInfo(ASender : TIdCommand);
      procedure CommandGetExamineePhoto(ASender : TIdCommand);
      procedure CommandGetBaseConfig(ASender : TIdCommand);
      procedure CommandExamineeLogin(ASender : TIdCommand);

      procedure CommandGetEQInfo(ASender : TIdCommand);
      procedure CommandGetEQRecord(ASender : TIdCommand);
      procedure CommandGetEQFile(ASender : TIdCommand);
      procedure CommandGetExamineeTestFilePack(ASender : TIdCommand);

      procedure CommandSendScoreInfo(ASender : TIdCommand);
      procedure CommandSendExamineeZipFile(ASender : TIdCommand);

      // procedure CommandGetExamineeZipFile(ASender: TIdCommand);
   protected

      procedure InitComponent; override;
      procedure InitializeCommandHandlers; override;
      procedure SetActive(AValue : Boolean); override;
      procedure DoConnect(AContext : TIdContext); override;
   public
      constructor Create(AOwner : TComponent; AExamineeManager : TExamineesManager; APort : Integer = 3000);
      destructor Destroy; override;

   end;

implementation

uses NetGlobal, Windows, ServerGlobal, StkRecordInfo, tq, BaseConfig, cndebug;

constructor TExamServer.Create(AOwner : TComponent; AExamineeManager : TExamineesManager; APort : Integer = 3000);
   begin
      inherited Create(AOwner);
      FExamineesManager := AExamineeManager;
      // FThreadPool := TIdSchedulerOfThreadPool.Create(Self);
      // FThreadPool.PoolSize:=0;
      // Self.Scheduler := FThreadPool;

      ListenQueue                                     := 150;
      MaxConnections                                  := 150;
      TerminateWaitTime                               := 3000;
      OnDisconnect                                    := ExamServerOnDisconnect;
      OnListenException                               := ExamServerListenException;
      OnException                                     := ExamServerException;
      Self.CommandHandlers.OnCommandHandlersException := CmdHandleException;
      DefaultPort                                     := APort;

      {$IFDEF DEBUG}
      // Intercept := TIdServerInterceptLogFile.Create(nil);
      // with TIdServerInterceptLogFile(Intercept) do
      // begin
      // Filename := 'serverlog.txt';
      // LogTime := false;
      // end;
      {$ENDIF}
   end;

destructor TExamServer.Destroy;
   begin
      // FThreadPool.free;
      {$IFDEF DEBUG}
      if Assigned(Intercept) then
      begin
         TIdServerInterceptLogFile(Intercept).Free;
         Intercept := nil;
      end;
      {$ENDIF}
      inherited;
   end;

procedure TExamServer.DoConnect(AContext : TIdContext);
   begin
      AContext.Connection.IOHandler.DefStringEncoding := IndyTextEncoding_UTF8(); // TIdTextEncoding.UTF8 ;
      inherited;

   end;

procedure TExamServer.InitComponent;
   begin
      inherited;
      // FThreadPool := TIdSchedulerOfThreadPool.Create(Self);
      // FThreadPool.PoolSize := 20;

      // Scheduler := FThreadPool;

   end;

procedure TExamServer.InitializeCommandHandlers;
   begin
      inherited;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETBASECONFIG; { do not localize }
         OnCommand   := CommandGetBaseConfig;
         ParseParams := False;
         // Disconnect := true;  //default is false
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_SENDEXAMINEESTATUS; { do not localize }
         OnCommand   := commandSendExamineeStatus;
         ParseParams := True;
         // Disconnect := true;  //default is false
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETEXAMINEEINFO; { do not localize }
         OnCommand   := CommandGetExamineeInfo;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETEXAMINEEPHOTO; { do not localize }
         OnCommand   := CommandGetExamineePhoto;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_EXAMINEELOGIN; { do not localize }
         OnCommand   := CommandExamineeLogin;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETEQINFO; { do not localize }
         OnCommand   := CommandGetEQInfo;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETEQRECORD; { do not localize }
         OnCommand   := CommandGetEQRecord;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETEQFILE; { do not localize }
         OnCommand   := CommandGetEQFile;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_GETEXAMINEETESTFILEPACK; { do not localize }
         OnCommand   := CommandGetExamineeTestFilePack;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_SENDSCOREINFO; { do not localize }
         OnCommand   := CommandSendScoreInfo;
         ParseParams := True;
         // Disconnect := true;
      end;
      with CommandHandlers.Add do
      begin
         Command     := CMD_SENDEXAMINEEZIPFILE; { do not localize }
         OnCommand   := CommandSendExamineeZipFile;
         ParseParams := True;
         // Disconnect := true;
      end;
      // with CommandHandlers.Add do
      // begin
      // Command := CMD_GETEXAMINEEZIPFILE;         {do not localize}
      // OnCommand := CommandGetExamineeZipFile;
      // ParseParams := True;
      // //Disconnect := true;
      // end;
      Greeting.Clear;
   end;

procedure TExamServer.SetActive(AValue : Boolean);
   begin
      if AValue = True then
      begin
         inherited;
         // FExamineesManager.EnableTimer(AValue);
      end
      else
      begin
         // FExamineesManager.EnableTimer(AValue);
         inherited;
      end;
   end;

procedure TExamServer.ExamServerOnDisconnect(AContext : TIdContext);
   var
      Examinee : PExaminee;
   begin
      {$IFNDEF NODISPLAY }
      New(Examinee);
      with Examinee^ do
      begin
         ID     := CMDNULLNONAME;
         Name   := CMDNULLNONAME;
         Status := esDisConnect;
         // RemainTime := strtoint(Params[3]);
         IP   := AContext.Connection.Socket.Binding.PeerIP;
         Port := AContext.Connection.Socket.Binding.PeerPort;
      end;
      FExamineesManager.UpdateDisConnectStatus(AContext.Binding);
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('ExamServerOnDisconnect OK! ', AContext.Binding.PeerIP.Substring(8));
      {$ENDIF}
      {$ENDIF}
   end;

procedure TExamServer.ExamServerListenException(AThread : TIdListenerThread; AException : Exception);
   begin
      {$IFDEF DEBUG}
      // TExamServerGlobal.logger.WriteLog('ServerListenException:'+AException.Message);
      {$IFDEF DEBUG}
      CnDebugger.LogFull('Server Listen exception:' + AException.Message, AThread.Binding.PeerIP.Substring(8), 0, cmtException);
      {$ENDIF}
      // if Assigned(Intercept) then
      // TIdServerInterceptLogFile(Intercept).LogWriteString('ListenExcpetion-----exception:' + AException.Message);
      {$ENDIF}
   end;

procedure TExamServer.ExamServerException(AContext : TIdContext; AException : Exception);
   begin
      {$IFDEF DEBUG}
      // TExamServerGlobal.logger.WriteLog('ServerException:'+AException.Message);
      {$IFDEF DEBUG}
      CnDebugger.LogFull('Server exception:' + AException.Message, AContext.Binding.PeerIP.Substring(8), 0, cmtException);
      {$ENDIF}
      // if Assigned(Intercept) then
      // TIdServerInterceptLogFile(Intercept).LogWriteString('ServerException-----exception:' + AException.Message);
      {$ENDIF}
   end;

procedure TExamServer.CmdHandleException(ACommand : String; AContext : TIdContext);
   begin
      {$IFDEF DEBUG}
      // TExamServerGlobal.logger.WriteLog('CmdhandleException:'+Acommand);
      {$IFDEF DEBUG}
      CnDebugger.LogFull('Server Command handle exception :' + ACommand, AContext.Binding.PeerIP.Substring(8), 0, cmtException);
      {$ENDIF}
      // if Assigned(Intercept) then
      // TIdServerInterceptLogFile(Intercept).LogWriteString(ACommand + ':' + AContext.Binding.PeerIP + ':' + inttostr(AContext.Binding.PeerPort));
      {$ENDIF}
   end;

procedure TExamServer.commandSendExamineeStatus(ASender : TIdCommand);
   var
      Examinee : PExaminee; // Examinee will be put in the message ,so we'll dynamic alloc mem
   begin
      ASender.PerformReply := False;
      New(Examinee);
      with ASender do
      begin
         Assert(Params.Count = 4, 'Error commandSendExamineeStatus params count');
         with Examinee^ do
         begin
            ID         := Params[0];
            Name       := Params[1];
            Status     := TExamineeStatus(StrToInt(Params[2]));
            RemainTime := StrToInt(Params[3]);
            IP         := Context.Binding.PeerIP;
            Port       := Context.Binding.PeerPort;
         end;
         FExamineesManager.UpdateStatus(Examinee);
      end;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('commandSendExamineeStatus OK! exaimineeID:' + Examinee.ID, ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
   end;

procedure TExamServer.CommandGetExamineeTestFilePack(ASender : TIdCommand);
   var
      packStream : TMemoryStream;
      examineeID : string;
      loginType  : TLoginType;
   begin
      ASender.PerformReply := False;
      with ASender, ASender.Context.Connection.IOHandler do
      begin
         {$IFDEF DEBUG}
         if ASender.Params.Count <> 2 then
            CnDebugger.LogMsgWithTagLevel('CommandGetExamineeTestFilePack OK!', ASender.Context.Binding.PeerIP.Substring(8),0);
         {$ENDIF}
         examineeID := Params[0];
         loginType  := TLoginType(StrToInt(Params[1]));
         // CreateExamineesEQBZipFileStreamArray
         packStream := TMemoryStream.Create;
         // GetExamineeTestFilePackByExamineeStatus(Params[0],Params[1],packStream);
         TExamServerGlobal.GlobalStkRecordInfo.AcquireTestFilePack(examineeID, loginType, packStream);
         if packStream.Size <> 0 then
         begin
            try
               packStream.Position := 0;
               Write(packStream, packStream.Size, True);
            finally
               packStream.Free;
            end;
         end;
      end;
      FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandGetExamineeTestFilePack OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
   end;

procedure TExamServer.CommandGetEQFile(ASender : TIdCommand);
   var
      EQFile : TMemoryStream;
   begin
      ASender.PerformReply := False;
      with ASender, ASender.Context.Connection.IOHandler do
      begin
         EQFile := TExamServerGlobal.GlobalStkRecordInfo.AcquireEQFile(Params[0]);
         if EQFile <> nil then
         begin
            try
               EQFile.Position := 0;
               Write(EQFile, EQFile.Size, True);
            finally
               EQFile.Free;
            end;
         end;
      end;
      FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
      // ASender.Disconnect := True;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandGetEQFile OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
   end;

procedure TExamServer.CommandGetEQRecord(ASender : TIdCommand);
   var
      recordPacket : TClientEQRecordPacket;
      st           : string;
   begin
      ASender.PerformReply := False;
      with recordPacket, ASender, ASender.Context.Connection.IOHandler do
      begin
         recordPacket := TExamServerGlobal.GlobalStkRecordInfo.AcquireEQRecord(Params[0]);
         try
            WriteLn(recordPacket.st_no);

            Content.Position := 0;
            Write(Content, Content.Size, True);

            StAnswer.Position := 0;
            Write(StAnswer, StAnswer.Size, True);

            Environment.Position := 0;
            Write(Environment, Environment.Size, True);
            Comment.Position := 0;
            Write(Comment, Comment.Size, True);
         finally
            recordPacket.Free;
         end;
      end;
      FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
      // ASender.Disconnect := True;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandGetEQRecord OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
   end;

procedure TExamServer.CommandGetEQInfo(ASender : TIdCommand);
   var
      EQInfo     : TStringList;
      BaseConfig : TBaseConfig;
   begin
      ASender.PerformReply := True;
      with ASender do
      begin
         try
            BaseConfig := TExamServerGlobal.GlobalStkRecordInfo.BaseConfig;
            EQInfo     := TExamServerGlobal.GlobalStkRecordInfo.AcquireEQInfo(BaseConfig);
         finally
            // if Assigned(EQInfo) then

            Reply.Code := CMDCONSTCORRECTREPLYCODE;
            Reply.Text.Assign(EQInfo);
            EQInfo.Free;
         end;

      end;
      FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
      // ASender.Disconnect := True;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandGetEQInfo OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
   end;

procedure TExamServer.CommandGetExamineeInfo(ASender : TIdCommand);
   var
      Examinee    : TExaminee;
      AExamineeID : string;
   begin
      ASender.PerformReply := True;
      with ASender do
      begin
         try
            try
               try
                  FExamineesManager.GetExamineeInfo(Params[0], Examinee);
               finally
                  { TODO -ojp -cneedmodify : need deal with error examinee ID Or not allow }
                  if Examinee.Name = CMDNOEXAMINEEINFO then
                     Reply.Code := CMDCONSTERRORREPLYCODE
                  else
                  begin
                     Reply.Code := CMDCONSTCORRECTREPLYCODE;
                     ConvertExamineeToStrings(Examinee, Reply.Text);

                  end;
               end;
               {$IFDEF DEBUG}
               CnDebugger.LogMsgWithTag('CommandGetExamineeInfo OK! examineeID:' + Examinee.ID, ASender.Context.Binding.PeerIP.Substring(8));
               {$ENDIF}
            finally
               Examinee.ClearData;
            end;
         except
            on E : Exception do
            begin
               Reply.Code := CMDCONSTERRORREPLYCODE;
               {$IFDEF DEBUG}
               if Assigned(Intercept) then
                  TIdServerInterceptLogFile(Intercept).LogWriteString('GetExamineeInfo-----exception:' + E.Message);
               {$ENDIF}
            end;
         end;
      end;
      // ASender.Disconnect := True;

   end;

procedure TExamServer.CommandGetExamineePhoto(ASender : TIdCommand);
   var
      PhotoFile         : TMemoryStream;
      examineePhotoFile : string;
   begin
      ASender.PerformReply := False;
      Assert(ASender.Params.Count = 1, 'Error commandGetExamineeInfo params count');
      examineePhotoFile := TExamServerGlobal.ServerCustomConfig.PhotoFolder + '\' + ASender.Params[0] + '.jpg';
      with ASender, ASender.Context.Connection.IOHandler do
      begin
         PhotoFile := TMemoryStream.Create();
         try
            if FileExists(examineePhotoFile) then
               PhotoFile.LoadFromFile(examineePhotoFile);
            PhotoFile.Position := 0;
            Write(PhotoFile, PhotoFile.Size, True);
         finally
            PhotoFile.Free;
         end;
      end;
      // TODO:下面代码引发异常，将终止连接
      // 将考虑连接异常中止时如何重新连接
      // FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
      // ASender.Disconnect := True;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandGetExamineePhoto OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
   end;

// procedure TExamServer.CommandGetExamineeZipFile(ASender: TIdCommand);
// var
// zipStream:TMemoryStream;
// begin
// ASender.PerformReply := false;
// with ASender,ASender.Context.Connection.IOHandler do
// begin
// zipStream := TMemoryStream.Create;
// try
// try
// if FileExists(GlobalCustomConfig.ServerDataPath+'\'+params[0]+'.dat') then begin
// zipStream.LoadFromFile(GlobalCustomConfig.ServerDataPath+'\'+params[0]+'.dat');
// zipStream.Position :=0;
// Write(zipStream,zipStream.Size,True);
// WriteLn(CMDCONSTCORRECTREPLYCODE);
// end else begin
// WriteLn(CMDCONSTERRORREPLYCODE);
// end;
// except
// WriteLn(CMDCONSTERRORREPLYCODE);
// end;
// finally
// zipStream.Free;
// end;
// end;
// FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
// end;

procedure TExamServer.CommandGetBaseConfig(ASender : TIdCommand);
   var
      strlist : TStringList;
   begin
      { TODO -ojp -c1 : need deal with exception:if connect is close resource need to be free }
      ASender.PerformReply := True;
      with ASender do
      begin
         try
            try
               strlist := TExamServerGlobal.GlobalStkRecordInfo.BaseConfig.ToStrings();
            finally
               if strlist <> nil then
               begin
                  Reply.Code := CMDCONSTCORRECTREPLYCODE; // code must before text
                  // Reply.Text.Encoding := TIdTextEncoding.UTF8;

                  Reply.Text.Assign(strlist);

                  strlist.Free;
               end
               else
               begin
                  Reply.Code := CMDCONSTERRORREPLYCODE;
               end;
               {$IFDEF DEBUG}
               CnDebugger.LogMsgWithTag('CommandGetBaseConfig OK!', ASender.Context.Binding.PeerIP.Substring(8));
               {$ENDIF}
            end;
         except
            on E : Exception do
            begin
               Reply.Code := CMDCONSTERRORREPLYCODE;
               {$IFDEF DEBUG}
               // if Assigned(Intercept) then
               // TIdServerInterceptLogFile(Intercept).LogWriteString('GetSysConfig-----exception:' + E.Message);
               {$ENDIF}
            end;
         end;
      end;

   end;

{ TODO -ojp -cMust : 登录后，如果未进入考试，退出应该发送状态信息，已便能再次登录 }
procedure TExamServer.CommandExamineeLogin(ASender : TIdCommand);
   var
      // Examinee   : PExaminee;
      examineeID : string;
      loginType  : TLoginType;
      pwd        : string;
      RemainTime : Integer;
   begin
      ASender.PerformReply := True;
      with ASender do
      begin
         try
            {$IFDEF DEBUG}
            if Params.Count <> 3 then
            begin
               CnDebugger.LogMsgWithTagLevel('CommandExamineeLogin error! parameter num not be 4', ASender.Context.Binding.PeerIP.Substring(8), 0);
            end;
            {$ENDIF}
            examineeID:=Params[0];
            loginType := TLoginType(StrToInt(Params[1]));
            pwd       := Params[2];
            // RemainTime := Params[3].ToInteger();

            // New(Examinee);
            try
               // Examinee.ID   := Params[0];
               // Examinee.IP   := Context.Binding.PeerIP;
               // Examinee.Port := Context.Binding.PeerPort;
               // examinee.Status := esLogined;
               // examinee.RemainTime := remainTime;
               // if addTime>0 then
               // RemainTime:=RemainTime+addTime;
               if FExamineesManager.Login(examineeID, loginType, pwd,Context.Binding.PeerIP,Context.Binding.PeerPort) = crOk then
               begin
                  Reply.Code := CMDCONSTCORRECTREPLYCODE;
                  // ConvertExamineeToStrings(Examinee^, Reply.Text);
                  {$IFDEF DEBUG}
                  CnDebugger.LogMsgWithTag('CommandExamineeLogin OK!', ASender.Context.Binding.PeerIP.Substring(8));
                  {$ENDIF}
               end
               else
               begin
                  Reply.Code := CMDCONSTERRORREPLYCODE;
                  {$IFDEF DEBUG}
                  CnDebugger.LogMsgWithTag('CommandExamineeLogin Fault!', ASender.Context.Binding.PeerIP.Substring(8));
                  {$ENDIF}
               end;
            finally
               // Dispose(Examinee);
            end;
         except
            on E : Exception do
            begin
               Reply.Code := CMDCONSTERRORREPLYCODE;
               // {$IFDEF DEBUG}
               // if Assigned(Intercept) then
               // TIdServerInterceptLogFile(Intercept).LogWriteString('CommandExamineeLogin-----exception:' + E.Message);
               // {$ENDIF}
            end;
         end;
      end;
      // ASender.Disconnect := True;
   end;

procedure TExamServer.CommandSendScoreInfo(ASender : TIdCommand);
   var
      Examinee    : PExaminee;
      ScoreStream : TMemoryStream;
   begin
      ASender.PerformReply := False;
      ScoreStream          := TMemoryStream.Create;
      // try
      with ASender, ASender.Context.Connection.IOHandler do
      begin
         try
            ReadStream(ScoreStream, -1);
            WriteLn(CMDCONSTCORRECTREPLYCODE);
         except
            WriteLn(CMDCONSTERRORREPLYCODE);
         end;
         New(Examinee);
         with Examinee^ do
         begin
            ID                    := Params[0];
            Status                := TExamineeStatus(StrToInt(Params[2]));
            RemainTime            := StrToInt(Params[3]);
            IP                    := Context.Binding.PeerIP;
            Port                  := Context.Binding.PeerPort;
            ScoreCompressedStream := ScoreStream;
            // ScoreCompressedStream.LoadFromStream(ScoreStream);
            // ScoreInfo := TScoreIni.Create;
            // ScoreInfo.SetStrings(AScoreInfo);
         end;
         FExamineesManager.UpdateScoreInfo(Examinee);
      end;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandSendScoreInfo OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
      // finally
      // ScoreStream.Free;
      // end;
      FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
   end;

procedure TExamServer.CommandSendExamineeZipFile(ASender : TIdCommand);
   var
      ExamineeZipFile : TMemoryStream;
   begin
      ASender.PerformReply := False;
      with ASender, ASender.Context.Connection.IOHandler do
      begin
         ExamineeZipFile := TMemoryStream.Create;
         try
            ReadStream(ExamineeZipFile, -1);
            ExamineeZipFile.SaveToFile(IncludeTrailingPathDelimiter(TExamServerGlobal.ServerCustomConfig.DataBakFolder) + Params[0] + '.dat');
         finally
            ExamineeZipFile.Free;
         end;
      end;
      {$IFDEF DEBUG}
      CnDebugger.LogMsgWithTag('CommandSendExamineeZipFile OK!', ASender.Context.Binding.PeerIP.Substring(8));
      {$ENDIF}
      FExamineesManager.UpdateTimeStamp(ASender.Context.Binding);
      // ASender.Disconnect := True;
   end;

end.
