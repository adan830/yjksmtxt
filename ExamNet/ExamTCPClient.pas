unit ExamTCPClient;

interface

uses IdTCPClient, SysUtils, IdComponent, ExtCtrls, Controls, classes,
   NetGlobal, ScoreIni, ExamInterface, tq, BaseConfig;

type
   /// implement the encapsulaton of TIDTcpClient, so  we can test convenient and separate the GUI and business logic.
   TExamTCPClient = class(TIdTCPClient, IExamTcpClient)
   private
      FTimer             : TTimer;
      FCommandProcessing : Boolean;
      FOnTimer           : TNotifyEvent;
      procedure SetOnTimer(const Value : TNotifyEvent);
      function GetServerIPPortConfig(filename : string) : Boolean;

   public
      // constructor Create(AHost:string;APort:integer);  reintroduce;overload;
      constructor Create(); reintroduce;
      destructor Destroy(); override;
      procedure TimerTimer(Sender : TObject);
      procedure OnConnected(Sender : TObject);
      procedure OnDisConnected(Sender : TObject);
      function CommandGetExamineeInfo(AExamineeID : string; var AExaminee : TExaminee) : TCommandResult;
      function CommandGetExamineePhoto(AExamineeID : string; out AStream : TMemoryStream) : TCommandResult;
      function CommandSendExamineeStatus(AExamineeID, AExamineeName : string; AStauts : TExamineeStatus; ARemainTime : Integer) : TCommandResult;

      function CommandGetBaseConfig(out ABaseConfig : TBaseConfig) : TCommandResult;
      function CommandGetEQInfo(out AEQInfoList : TStringList) : TCommandResult;
      function CommandGetEQFile(AFileID : string; out AStream : TMemoryStream) : TCommandResult;
      function CommandGetEQRecord(ANo : string; out ARecordPacket : TClientEQRecordPacket) : TCommandResult;
      function CommandExamineeLogin(var AExaminee : TExaminee; AFlag : TLoginType; ALoginPwd : string = NULLSTR; aRemainTime : Integer = 0) : TCommandResult;

      function CommandSendScoreInfo(AExaminee : TExaminee; AScore : TScoreIni) : TCommandResult;
      function CommandSendExamineeZipFile(AExamineeID : string; AZipStream : TMemoryStream) : TCommandResult;
      // function CommandGetExamineeZipFile(AExamineeID: string; out AZipStream: TMemoryStream): TCommandResult;
      function CommandGetExamineeTestFilePack(AExamineeID : string; ALoginType : TLoginType; AStream : TMemoryStream) : TCommandResult;
      function SendCmd(AOut : string; const AResponse : SmallInt = -1) : SmallInt; overload;

   public
      property OnTimer : TNotifyEvent read FOnTimer write SetOnTimer;
   end;

implementation

uses Windows, IdStack, Forms, IdException, compress, IdGlobal, cndebug;

{ TTcpClient }
// constructor TExamTCPClient.Create(AHost: string; APort: integer);
constructor TExamTCPClient.Create();
   begin
      inherited Create();
      if not GetServerIPPortConfig('examconfig.ini') then
      begin
         raise Exception.Create('读配置文件examconfig.ini出错！请检查文件');
      end;

      // because follow reason ,we don't compelling client port
      // http://groups.google.com/group/borland.public.delphi.internet.winsock/browse_thread/thread/26200060a26213d6/2303afa1932de55c?q=boundport&lnk=nl&
      // The only way to release the IP/Port faster is to use setsockopt() to enable
      // the SO_REUSEADDR attribute on the socket.  If you are using the latest Indy
      // 10 snapshot, then TIdTCPClient has a ReuseSocket property available for
      // that.
      //
      // If you are using an earlier build of Indy 10, then you can try using the
      // TIdIOHandlerSocket.OnSocketAllocated event to call setsockopt() manually.
      // In order to gain access to the event, you will have to assign a separate
      // TIdIOHandlerStack component to the TIdTCPClient instead of using the
      // implicit instance that TIdTCPClient creates for itself internally by
      // default.
      //
      // Otherwise, you are out of luck (unless you change Indy's source code and
      // recompile it), as earlier versions to not provide access for you to set that
      // attribute when the socket is being allocated.
      // BoundPort := 2999;

      // Host:=aHost;
      // Port:=APort;
      FTimer          := TTimer.Create(nil);
      FTimer.Enabled  := False;
      FTimer.Interval := 3000;
      FTimer.OnTimer  := TimerTimer;

      FOnConnected    := OnConnected;
      FOnDisconnected := OnDisConnected;

   end;

destructor TExamTCPClient.Destroy;
   begin
      FTimer.free;
      inherited;
   end;

function TExamTCPClient.GetServerIPPortConfig(filename : string) : Boolean;
   var
      cfg     : TStringList;
      index   : Integer;
      ahost   : string;
      aPort   : word;
      MyClass : TComponent;
   begin
      Result := False;
      if FileExists('examconfig.ini') then
      begin
         cfg := TStringList.Create;
         try
            cfg.LoadFromFile('examconfig.ini');
            ahost := cfg.Values['serverip'];
            if not word.tryparse(cfg.Values['serverport'], aPort) then
               exit;
            Host   := ahost;
            port   := aPort;
            Result := true;
            // if trim(aip)=string.Empty then errorMessage:='配置文件中ServerIP不能为空；';
            // if (not integer.tryparse( cfg.values['serverport'], portvalue)) then errorMessage:=errorMessage+'配置文件中ServerPort项值应为整数，默认应为3000;';
         finally
            cfg.free;
         end;
      end;
   end;

procedure TExamTCPClient.OnConnected(Sender : TObject);
   begin
      IOHandler.DefStringEncoding := IndyTextEncoding_UTF8(); // TIdTextEncoding.UTF8 ;
      FTimer.Enabled              := true;
   end;

procedure TExamTCPClient.OnDisConnected(Sender : TObject);
   begin
      FTimer.Enabled := False;
   end;

function TExamTCPClient.SendCmd(AOut : string; const AResponse : SmallInt = -1) : SmallInt;
   begin
      Result := SendCmd(AOut, AResponse, IndyTextEncoding_UTF8()); // TIdTextEncoding.UTF8);
   end;

procedure TExamTCPClient.SetOnTimer(const Value : TNotifyEvent);
   begin
      FOnTimer := Value;
   end;

procedure TExamTCPClient.TimerTimer(Sender : TObject);
   begin
      { TODO -ojp -c0 : test if overflow ,test if correct }
      // if (GlobalExaminee.RemainTime div GlobalSysConfig.StatusRefreshInterval)=(GlobalExaminee.RemainTime / GlobalSysConfig.StatusRefreshInterval) then
      if (not FCommandProcessing) and (Assigned(FOnTimer)) then
      begin
         FOnTimer(Sender);
         // The following code is moved to notify event ,以减少与主程序的耦合
         // if (GlobalExaminee.Status > esLogined) and (not FCommandProcessing) then
         // begin
         // { TODO -ojp -c0 : direct update remaintime in server ,is correct ? }
         // GlobalExamTCPClient.CommandSendExamineeStatus(GlobalExaminee.ID,GlobalExaminee.Name,GlobalExaminee.Status,GlobalExaminee.RemainTime);
         // end;
      end;
   end;

// procedure TExamClient.Connect;
// var
// op:boolean;
// begin
// try
// if not Connected then
// Connect
// else begin
// if not IOHandler.Opened then
// IOHandler.Open;
// end;
// except on E: Exception do
// raise;
// end;
// end;

function TExamTCPClient.CommandGetExamineeInfo(AExamineeID : string; var AExaminee : TExaminee) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            SendCmd(CMD_GETEXAMINEEINFO + ' ' + AExamineeID, [600, 700]);
            if LastCmdResult.Code = CMDCONSTCORRECTREPLYCODE then
            begin
               ConvertStringsToExaminee(LastCmdResult.Text, AExaminee);
               Result := crOk;
            end
            else
            begin
               Result := crError;
            end;
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crNetError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandGetExamineePhoto(AExamineeID : string; out AStream : TMemoryStream) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            with IOHandler do
            begin
               WriteLn(CMD_GETEXAMINEEPHOTO + ' ' + AExamineeID);
               AStream := TMemoryStream.Create;
               ReadStream(AStream, -1);
               Result := crOk;
            end
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandGetBaseConfig(out ABaseConfig : TBaseConfig) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            SendCmd(CMD_GETBASECONFIG);
            if LastCmdResult.Code = CMDCONSTCORRECTREPLYCODE then
            begin
               if ABaseConfig = nil then
                  ABaseConfig := TBaseConfig.Create;
               ABaseConfig.FromStrings(LastCmdResult.Text);
               Result := crOk;
            end
            else
            begin
               Result := crError;
            end;
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crNetError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandExamineeLogin(var AExaminee : TExaminee; AFlag : TLoginType; ALoginPwd : string; aRemainTime : Integer) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            SendCmd(CMD_EXAMINEELOGIN + ' ' + AExaminee.ID + ' ' + IntToStr(Ord(AFlag)) + ' ' + ALoginPwd + ' ' + aRemainTime.ToString());
            if LastCmdResult.Code = CMDCONSTCORRECTREPLYCODE then
            begin
               ConvertStringsToExaminee(LastCmdResult.Text, AExaminee);
               Result := crOk;
            end;
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandGetEQInfo(out AEQInfoList : TStringList) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            SendCmd(CMD_GETEQINFO);
            if LastCmdResult.Code = CMDCONSTCORRECTREPLYCODE then
            begin
               AEQInfoList := TStringList.Create;
               AEQInfoList.Assign(LastCmdResult.Text);
               Result := crOk;
            end;
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandGetEQRecord(ANo : string; out ARecordPacket : TClientEQRecordPacket) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            ARecordPacket := TClientEQRecordPacket.Create;
            with IOHandler, ARecordPacket do
            begin
               WriteLn(Format('%s %s', [CMD_GETEQRECORD, ANo]));

               ARecordPacket.st_no := IOHandler.ReadLn;
               ReadStream(Content, -1);
               ReadStream(StAnswer, -1);
               ReadStream(Environment, -1);
               ReadStream(Comment, -1);
            end;
            Result := crOk;
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandGetEQFile(AFileID : string; out AStream : TMemoryStream) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try

         try
            with IOHandler do
            begin
               WriteLn(CMD_GETEQFILE + ' ' + AFileID);
               AStream := TMemoryStream.Create;
               ReadStream(AStream, -1);
               Result := crOk;
            end
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandGetExamineeTestFilePack(AExamineeID : string; ALoginType : TLoginType; AStream : TMemoryStream) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            with IOHandler do
            begin
               WriteLn(CMD_GETEXAMINEETESTFILEPACK + ' ' + AExamineeID + ' ' + IntToStr(Integer(ALoginType)));
               AStream.Clear;
               ReadStream(AStream, -1);
               Result := crOk;
            end
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

// function TExamTCPClient.CommandGetExamineeZipFile(AExamineeID: string; out AZipStream: TMemoryStream): TCommandResult;
// begin
// Result := crError;
// FCommandProcessing := True;
// try
// AZipStream := TMemoryStream.Create;
// try
// with IOHandler do
// begin
// WriteLn(CMD_GETEXAMINEEZIPFILE+' '+AExamineeID);
// ReadStream(AZipStream,-1);
// //ExamineeZipFile.SaveToFile(+'.dat');
// if IOHandler.ReadLn() = CMDCONSTCORRECTREPLYCODE then  Result := crOk;
// end;
// finally
// // ExamineeZipFile.Free;
// end;
// finally
// FCommandProcessing := False;
// end;
// //ASender.Disconnect := True;
// end;

function TExamTCPClient.CommandSendExamineeStatus(AExamineeID, AExamineeName : string; AStauts : TExamineeStatus; ARemainTime : Integer) : TCommandResult;
   var
      socketException : EIdSocketError;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try

            IOHandler.WriteLn(Format('%s %s %s %d %d', [CMD_SENDEXAMINEESTATUS, AExamineeID, AExamineeName, Ord(AStauts), ARemainTime]));
         except
            on E : Exception do
            begin
               socketException := E as EIdSocketError;
               { TODO -c必需 : 这里需要处理10053等异常 }
               // self.IOHandler.InputBuffer.Clear;
               self.IOHandler.Close;
               self.IOHandler.Open;
               // self.Disconnect;
               // self.Connect;
               // OutputDebugString('Sendclientstate command end with error');
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

// function TExamTCPClient.CommandSendScoreInfo(AExaminee: TExaminee; AScore: TScoreIni): TCommandResult;
// var
// ScoreStream : TMemoryStream;
// bb:TTreeview;
// begin
// Result := crError;
// FCommandProcessing := True;
// bb.SaveToStream();
// ScoreStream := TMemoryStream.Create;
// try
// AScore.SaveToStream(ScoreStream);
// try
// IOHandler.WriteLn(Format('%s %s %s %d %d',[CMD_SENDSCOREINFO,AExaminee.ID,AExaminee.Name, Ord(AExaminee.Status), AExaminee.RemainTime]));
// ScoreStream.Position :=0;
// IOHandler.Write(ScoreStream,ScoreStream.Size,True);
/// /           result:=crOK; //
/// /        IOHandler.WriteLn(IntToStr(ScoreInfo.Count));
/// /        IOHandler.WriteRFCStrings(ScoreInfo,false);
// if IOHandler.ReadLn() = CMDCONSTCORRECTREPLYCODE then
// Result := crOk;
// except
// on E:Exception do  begin
//
// if E is EIdConnClosedGracefully then
// Result := crConnClosedGracefully
// else
// Result := crError;
// end;
// end;
// finally
// ScoreStream.Free;
// FCommandProcessing := False;
// end;
// end;

function TExamTCPClient.CommandSendScoreInfo(AExaminee : TExaminee; AScore : TScoreIni) : TCommandResult;
   var
      ScoreStream : TMemoryStream;
   begin
      Result             := crError;
      FCommandProcessing := true;
      ScoreStream        := TMemoryStream.Create;
      try
         try
            AScore.SaveToStream(ScoreStream);
            CompressStream(ScoreStream);
            with IOHandler do
            begin
               IOHandler.WriteLn(Format('%s %s %s %d %d', [CMD_SENDSCOREINFO, AExaminee.ID, AExaminee.Name, Ord(AExaminee.Status), AExaminee.RemainTime]));
               ScoreStream.Position := 0;
               Write(ScoreStream, ScoreStream.Size, true);
               if ReadLn() = CMDCONSTCORRECTREPLYCODE then
                  Result := crOk;
            end;
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         ScoreStream.free;
         FCommandProcessing := False;
      end;
   end;

function TExamTCPClient.CommandSendExamineeZipFile(AExamineeID : string; AZipStream : TMemoryStream) : TCommandResult;
   begin
      Result             := crError;
      FCommandProcessing := true;
      try
         try
            with IOHandler do
            begin
               WriteLn(CMD_SENDEXAMINEEZIPFILE + ' ' + AExamineeID);
               AZipStream.Position := 0;
               Write(AZipStream, AZipStream.Size, true);
               Result := crOk;
            end
         except
            on E : Exception do
            begin
               if E is EIdConnClosedGracefully then
                  Result := crConnClosedGracefully
               else
                  Result := crError;
            end;
         end;
      finally
         FCommandProcessing := False;
      end;
   end;

end.
