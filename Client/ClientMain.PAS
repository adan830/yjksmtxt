unit ClientMain;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ExtCtrls, Buttons, ScoreIni, StdCtrls, NetGlobal, JvExControls,
   JvSpeedButton, CustomBmpForm, Vcl.ComCtrls, Vcl.Imaging.pngimage,
   uFrameSingleSelect, uFrameMultiSelect, keyboardType, CnButtons, Vcl.Imaging.GIFImg, uframecover; // floatform,

type
   TClientMainForm = class(TCustomBmpForm)
      pnl1 : TPanel;
      imgTop : TImage;
      btnSingleSelect : TJvSpeedButton;
      btnMultiSelect : TJvSpeedButton;
      btnType : TJvSpeedButton;
      pnlClient : TPanel;
      pnl2 : TPanel;
      btn1 : TButton;
      btnWindows : TJvSpeedButton;
      btnWord : TJvSpeedButton;
      btnExcel : TJvSpeedButton;
      btnPowerPoint : TJvSpeedButton;
      imgExaminee : TImage;
      txtExamineeName : TStaticText;
      txtExamineeSex : TStaticText;
      txtExamineeNo : TStaticText;
      btnComplete : TCnSpeedButton;
    Image1: TImage;
    lblTime: TLabel;
      procedure FormCloseQuery(Sender : TObject; var CanClose : Boolean);
      procedure FormClose(Sender : TObject; var Action : TCloseAction);
      procedure FormCreate(Sender : TObject);
      procedure FlashPlayerFlashCall(ASender : TObject; const request : WideString);
      procedure btn1Click(Sender : TObject);
      procedure btn1btnClick(Sender : TObject);
      procedure btnModuleClick(Sender : TObject);
      procedure btnCompleteClick(Sender : TObject);
   private
      FDz      : Boolean;
      closenum : integer;

      currentMoude : TFrame;
      coverFrame   : TFrameCover;
      // singleFrame:TFrameSingleSelect;
      // multiFrame:TFrameMultiSelect;
      // typeFrame:TFrameKeyType;
      /// <summary>
      /// ///获取考生信息
      /// </summary>
      procedure SendExamineeDict;
      // moved form loginForm
      // function Login(AExamineeID:string):Integer;

      function GetExamineeInfo(AExamineeID : string) : string;
      /// <summary>
/// w
/// </summary>
/// <param name="AScore"></param>
      procedure SaveScoreToDB(AScore : TScoreIni);
      function GetExamineeIDLength : string;
      procedure SetTabFrameStatus(tabID : integer);
      procedure CreateCover;

      // procedure WinGrade(pbHandle: integer);
   public
      winStatus : Boolean;
      pbHandle  : integer; // 表示进度条对象

      procedure dograde;
      procedure SetFlashRemainTime(const ARemainTime : string);
      destructor Destroy(); override;
      procedure CloseCover;
      procedure LoadExamineePhoto(img : TImage);
   protected
      procedure CreateParams(var Params : TCreateParams); override;
      procedure OnTimer(Sender : TObject);
   end;

procedure OnProcess(AMessage : string; AStep : integer = 1);

// var
// FlashCodeStream: TResourceStream;
implementation

uses floatform, XMLIntf, XMLDoc,
    ADODB, Select, KeyType, SelectGrade, score, ExamGlobal,
   ufrmInProcess, Commons, compress, DB, DataUtils, DataFieldConst, tq,
   ExamClientGlobal, FrameWorkUtils, uFrameOperate, cndebug;

{$R *.dfm}
// {$R CoverFlash.res}

function TClientMainForm.GetExamineeIDLength() : string;
   begin
      Result := '11';
   end;

function TClientMainForm.GetExamineeInfo(AExamineeID : string) : string;
   begin
      if length(AExamineeID) = CONSTEXAMINEEIDLENGTH then
      begin
         if (TExamClientGlobal.ExamTCPClient.CommandGetExamineeInfo(AExamineeID, TExamClientGlobal.Examinee) = crOK) then
         begin
            with TExamClientGlobal.Examinee do
            begin
               Result := 'OK,' + ID + ',' + Name + ',' + GetStatusDisplayValue(Status) + ',' + IntToStr(RemainTime);
            end;
         end
         else
         begin
            Result := '获取考生信息错误！';
         end;
      end
      else
      begin
         Result := '准考证号长度不够！';
      end;
   end;



// function TClientMainForm.Login(AExamineeID: string): Integer;
// var
// loginResult: TCommandResult;
// begin
// Result := -1;
// { TODO -ojp -cneeddo : 考试环境、时间需要设置 }
// loginResult := crError;
// case TExamClientGlobal.Examinee.Status of
// esNotLogined: begin
// TExamClientGlobal.LoginType := ltFirstLogin;
// loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
// end;
// esDisConnect: begin
// //if DirectoryExists(GlobalExamPath) then
// begin
// TExamClientGlobal.LoginType := ltContinuteInterupt;
// loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
// end;
// end;
// esAllowContinuteExam: begin
// TExamClientGlobal.LoginType := ltContinuteEndedExam;
// loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
// end;
// esAllowReExam: begin
// TExamClientGlobal.LoginType := ltReExamLogin;
// loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
// end;
// else begin
// Result := 2; //refuse login
// end;
//
// end;
// if loginResult = crOk  then begin
// Result := 1; //login ok
// end;
// end;

procedure TClientMainForm.OnTimer(Sender : TObject);
   begin
      if (TExamClientGlobal.Examinee.Status >= esLogined) then
      begin
         { TODO -ojp -c0 : direct update remaintime in server ,is correct ? }
         TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name,
                 TExamClientGlobal.Examinee.Status, TExamClientGlobal.Examinee.RemainTime);
      end;
   end;

procedure TClientMainForm.LoadExamineePhoto(img : TImage);
   var
      png : TpngImage;
   begin
      png := TpngImage.Create;
      try
         if TExamClientGlobal.Examinee.HasPhoto then
         begin
            png.LoadFromStream(TExamClientGlobal.ExamineePhoto);
            img.Picture.Bitmap.Assign(png);
         end
         else
         begin
            png.LoadFromResourceName(HInstance, 'NullPhoto');
            img.Picture.Bitmap.Assign(png);
         end;
      finally
         png.Free;
      end;
   end;

procedure OnProcess(AMessage : string; AStep : integer = 1);
   begin
      PMOnProcess(TExamClientGlobal.ClientMainForm.pbHandle, AMessage, AStep);
   end;

procedure TClientMainForm.btn1btnClick(Sender : TObject);
   var
      frmSelect : TForm;
   begin
      frmSelect := TSelectForm.Create(self);
      frmSelect.show;
   end;

procedure TClientMainForm.btn1Click(Sender : TObject);
   begin
      // SetFlashRemainTime('8:00');
      ModalResult := mrAbort;
      Close;
   end;

procedure TClientMainForm.btnCompleteClick(Sender : TObject);
   begin
      TExamClientGlobal.typeFrame.HideFrame;
      SetTabFrameStatus(-1);
      ModalResult := mrOk;
      Close;
   end;

procedure TClientMainForm.btnModuleClick(Sender : TObject);
   var
      btn : TJvSpeedButton;
      tag : integer;
   begin
      btn := Sender as TJvSpeedButton;
      tag := btn.tag;
      SetTabFrameStatus(tag);
   end;

procedure TClientMainForm.SetTabFrameStatus(tabID : integer);
   begin
      btnSingleSelect.Down := false;
      btnMultiSelect.Down  := false;
      btnType.Down         := false;
      btnWindows.Down      := false;
      btnWord.Down         := false;
      btnExcel.Down        := false;
      btnPowerPoint.Down   := false;
      with TExamClientGlobal do
      begin
         if (singleFrame <> nil) and (singleFrame.Showing) then
            singleFrame.HideFrame;
         if (multiFrame <> nil) and (multiFrame.Showing) then
            multiFrame.HideFrame;
         if (typeFrame <> nil) and (typeFrame.Showing) then
            typeFrame.HideFrame;
         if (windowsFrame <> nil) and (windowsFrame.Showing) then
            windowsFrame.HideFrame;
         if (wordFrame <> nil) and (wordFrame.Showing) then
            wordFrame.HideFrame;
         if (excelFrame <> nil) and (excelFrame.Showing) then
            excelFrame.HideFrame;
         if (powerPointFrame <> nil) and (powerPointFrame.Showing) then
            powerPointFrame.HideFrame;

         case tabID of
            1 :
               begin
                  btnSingleSelect.Down := true;
                  if singleFrame = nil then
                     singleFrame := LoadFrameByClassName(TFrameSingleSelect, pnlClient) as TFrameSingleSelect;
                  singleFrame.ShowFrame;
               end;
            2 :
               begin
                  btnMultiSelect.Down := true;
                  if multiFrame = nil then
                     multiFrame := LoadFrameByClassName(TFrameMultiSelect, pnlClient) as TFrameMultiSelect;
                  multiFrame.ShowFrame;
               end;
            3 :
               begin
                  btnType.Down := true;
                  if typeFrame = nil then
                     typeFrame := LoadFrameByClassName(TFrameKeyType, pnlClient) as TFrameKeyType;
                  typeFrame.ShowFrame;
               end;
            4 :
               begin
                  btnWindows.Down := true;
                  if windowsFrame = nil then
                     windowsFrame := LoadFrameByClassName(TFrameOperate, pnlClient, TExamModule.EMWINDOWS) as TFrameOperate;
                  windowsFrame.ShowFrame;
                  // if TExamClientGlobal.Floatwindow = nil then
                  // TExamClientGlobal.Floatwindow := TFloatWindow.Create(self);
                  // self.Hide;
                  // TExamClientGlobal.Floatwindow.ShowModalwithShadow;

               end;
            5 :
               begin
                  btnWord.Down := true;
                  if wordFrame = nil then
                     wordFrame := LoadFrameByClassName(TFrameOperate, pnlClient, TExamModule.EMWORD) as TFrameOperate;
                  wordFrame.ShowFrame;
               end;
            6 :
               begin
                  btnExcel.Down := true;
                  if excelFrame = nil then
                     excelFrame := LoadFrameByClassName(TFrameOperate, pnlClient, TExamModule.EMEXCEL) as TFrameOperate;
                  excelFrame.ShowFrame;
               end;
            7 :
               begin
                  btnPowerPoint.Down := true;
                  if powerPointFrame = nil then
                     powerPointFrame := LoadFrameByClassName(TFrameOperate, pnlClient, TExamModule.EMPOWERPOINT) as TFrameOperate;
                  powerPointFrame.ShowFrame;
               end;
         end;
      end;
   end;

procedure TClientMainForm.CreateParams(var Params : TCreateParams);
   begin
      inherited CreateParams(Params);
      // with Params do
      // begin
      // // {$IFNDEF DEBUG}
      // Style :=WS_POPUP;//+WS_MAXIMIZE ;             //ws_overlapped+      params.ExStyle:=ws_ex_topmost;
      // //ExStyle := ExStyle + WS_EX_APPWINDOW	;
      // WndParent :=0;   // mainform.Handle;    //父窗体为form1
      /// /    Self.Left :=0;
      /// /    Self.Top :=0;
      // Self.AutoSize :=False;
      // //{$ENDIF}
      /// /    FlashPlayer.Scale := 'ExactFit';  //是在控件中拉伸
      /// /    FlashPlayer.ScaleMode :=2;
      // end;
   end;

destructor TClientMainForm.Destroy;
   begin
      // FlashPlayer.Free;
      //FreeAndNil(coverFrame);
      FreeAndNil(currentMoude);
      inherited;
   end;

procedure TClientMainForm.SaveScoreToDB(AScore : TScoreIni);
   var
      ds     : TDataSet;
      stream : TMemoryStream;
   begin
      ds     := GetDataSetBySQL(SQLSTR_GETCLIENT_EXAMINEEINFO,  TExamClientGlobal.connClientDB);  //TExamClientGlobal.Examinee.ID,
      stream := TMemoryStream.Create;
      try
         with ds do
         begin
            First;
            if (DecryptStr(FieldValues[DFNEI_EXAMINEEID])<>TExamClientGlobal.Examinee.ID) then
            begin
               //raise Exception.Create('Error Message');
               Application.MessageBox('未找到考生信息，无法保存成绩到本地库！','提示');
               Exit;
            end;

            Edit;
            AScore.SaveToStream(stream);
            CompressStream(stream);
            (FieldByName(DFNEI_SCOREINFO) as TBlobField).LoadFromStream(stream);
            Post;
         end;
      finally
         ds.Free;
         stream.Free;
      end;
   end;

procedure TClientMainForm.FormCreate(Sender : TObject);
   var
      flashStream : TResourceStream;
   begin
      {$IFDEF DEBUG}
          btn1.Visible:=False;
      {$ELSE}
         btn1.Visible:=false;
      {$ENDIF}
      FDz      := false;
      closenum := 0;
      CreateCover;
      // TExamClientGlobal.ExamTCPClient.OnTimer := OnTimer;
      // if FileExists(TExamClientGlobal.ExamPath+'\'+TExamClientGlobal.Examinee.ID+'.jpg') then
      // imgExaminee.Picture.LoadFromFile(TExamClientGlobal.ExamPath+'\'+TExamClientGlobal.Examinee.ID+'.jpg')
      // else
      // begin
      // imgExaminee.Picture.LoadFromFile(TExamClientGlobal.ExamPath+'\photo.jpg')
      // end;

      txtExamineeName.Caption := '考生姓名:' + TExamClientGlobal.Examinee.Name;
      txtExamineeSex.Caption  := '性    别:' + TExamClientGlobal.Examinee.Sex;
      txtExamineeNo.Caption   := '准考证号:' + TExamClientGlobal.Examinee.ID;
      LoadExamineePhoto(imgExaminee);
      // flashStream:=TResourceStream.Create(0,'CoverFlash','Flash');
      // FlashPlayer.LoadMovieFromStream(0,flashStream);
      // flashStream.Free;
      // FlashPlayer.Play;

   end;

procedure TClientMainForm.CreateCover;
   begin
      coverFrame := TFrameCover.Create(self);
      self.pnl1.Hide;
      self.pnl2.Hide;
      self.pnlClient.Hide;
      coverFrame.Parent := self;
      coverFrame.Align  := alClient;
      self.LoadExamineePhoto(coverFrame.imgExaminee);
      coverFrame.txtExamineeName.Caption := '考生姓名:' + TExamClientGlobal.Examinee.Name;
      coverFrame.txtExamineeSex.Caption  := '性    别:' + TExamClientGlobal.Examinee.Sex;
      coverFrame.txtExamineeNo.Caption   := '准考证号:' + TExamClientGlobal.Examinee.ID;
      coverFrame.show;
   end;

procedure TClientMainForm.CloseCover;
   begin
      coverFrame.Hide;
//      coverFrame.Free;
      self.pnl1.show;
      self.pnl2.show;
      self.pnlClient.show;
      TExamClientGlobal.Examinee.Status := esExamining;
      TExamClientGlobal.EnableTimer;
      if TExamClientGlobal.typeFrame = nil then
                     TExamClientGlobal.typeFrame := LoadFrameByClassName(TFrameKeyType, pnlClient) as TFrameKeyType;
      SetTabFrameStatus(1);
   end;

procedure TClientMainForm.dograde;
   var
      I          : integer;
      zf         : integer;
      AOnProcess : TOnProcess;
   begin
      // GlobalDmClient.MainTimer.Enabled := False;
      TExamClientGlobal.Examinee.Status := esGrading;
      TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name,
              TExamClientGlobal.Examinee.Status, TExamClientGlobal.Examinee.RemainTime);
      AOnProcess := OnProcess;

      pbHandle := PMBeginProcess(Application, '系统正在评分，请不要进行其它操作！！！', '正在开始评分！', 0, 100, -1);
      try
         SingleSelectGrade(AOnProcess);
         MultiSelectGrade(AOnProcess);
         //texamclientglobal.typeFrame.HideFrame;
         OperationGrade(AOnProcess, TExamClientGlobal.connClientDB, TExamClientGlobal.ExamPath);
      finally
         PMEndProcess(pbHandle);
      end;

      SaveScoreToDB(TExamClientGlobal.score);
      TExamClientGlobal.Examinee.Status := esSutmitAchievement;
      TExamClientGlobal.ExamTCPClient.CommandSendScoreInfo(TExamClientGlobal.Examinee, TExamClientGlobal.score);
      SendExamineeDict();
      zf := TExamClientGlobal.score.GetScoreValue;
      if (TExamClientGlobal.BaseConfig.ExamClasify = EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode = SCOREDISPLAYMODECLIENT)
      then
      begin
         scoreForm := TScoreForm.Create(Application);
         scoreForm.ShowModal;
      end;

      if TExamClientGlobal.BaseConfig.ExamClasify = EXAMINATIONTYPEFORMAL then
      begin
         if zf = 0 then
            MessageBoxOnTopForm(Application, '注意考生成绩为：0分!     考试成功结束，请离开考场！', '提示：', mb_Ok)
         else
            MessageBoxOnTopForm(Application, '考试成功结束，请离开考场！', '提示：', mb_Ok);
      end;
   end;

procedure TClientMainForm.SendExamineeDict();
   var
      AStream : TMemoryStream;
   begin
      try
         DirectoryCompression(TExamClientGlobal.ExamPath, AStream);
         if TExamClientGlobal.ExamTCPClient.CommandSendExamineeZipFile(TExamClientGlobal.Examinee.ID, AStream) = crOK then
            TExamClientGlobal.Examinee.Status := esExamEnded
         else
            TExamClientGlobal.Examinee.Status := esError;
         TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name,
                 TExamClientGlobal.Examinee.Status, TExamClientGlobal.Examinee.RemainTime);
      finally
         AStream.Free;
      end;

   end;

procedure TClientMainForm.SetFlashRemainTime(const ARemainTime : string);
   var
      response, bb : WideString;
   begin
      // bb := '<invoke name="CallMeFromApplication" returntype="xml"><arguments><string>'+ARemainTime+'</string></arguments></invoke>';
      // response :=FlashPlayer.CallFunction(bb);

   end;

procedure TClientMainForm.FlashPlayerFlashCall(ASender : TObject; const request : WideString);
   var
      XMLDoc     : IXMLDocument;
      invokeNode : IXMLNode;
      paramNode  : IXMLNode;
      procName   : string;
      param      : string;
      value      : string;
   begin
      // xmlDoc := TXMLDocument.Create(nil);
      // try
      // xmlDoc.XML.Text := request;
      // xmlDoc.Active := True;
      // invokeNode := xmlDoc.ChildNodes[0];
      // procName :=invokeNode.Attributes['name'];
      // if invokeNode.HasChildNodes then begin
      // paramNode := invokeNode.ChildNodes[0];
      // if paramNode.HasChildNodes then begin
      // paramNode := paramNode.ChildNodes[0];
      // param := paramNode.Text;
      // end;
      // end;
      // finally
      // paramNode :=nil;
      // invokeNode :=nil;
      // xmlDoc := nil;
      // end;
      // if procName = 'GetIDLength' then begin
      // value := GetExamineeIDLength;
      // value := '<string>'+value+'</string>';
      /// /      FlashPlayer.SetReturnValue(value);
      // Exit;
      // end;
      // if procName = 'GetExamineeInfo' then begin
      // value := GetExamineeInfo(param);
      // value := '<string>'+value+'</string>';
      /// /      FlashPlayer.SetReturnValue(value);
      // Exit;
      // end;
      // if procName = 'ExamLogin' then begin
      // value := IntToStr(TExamClientGlobal.Login());
      // value := '<string>'+value+'</string>';
      /// /          FlashPlayer.SetReturnValue(value);
      // Exit;
      // end;
      // if procName ='StartNewExam' then begin
      // //CreateEnvironment(TExamClientGlobal.LoginType);
      // TExamClientGlobal.FloatWindow := TFloatWindow.Create(self);
      // TExamClientGlobal.SelectWindow := TSelectForm.Create(self);
      // //TypeForm := TTypeForm.Create(self);
      // TExamClientGlobal.Examinee.Status := esExamining;
      // TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.status,TExamClientGlobal.Examinee.RemainTime);
      // TExamClientGlobal.EnableTimer;
      // value := '<string>OK</string>';
      /// /          FlashPlayer.SetReturnValue(value);
      /// /          FlashPlayer.StopPlay;
      // Exit;
      // end;
      // if procName ='ContinuteExam' then begin
      // //CreateEnvironment(TExamClientGlobal.LoginType);
      // TExamClientGlobal.FloatWindow := TFloatWindow.Create(self);
      // TExamClientGlobal.SelectWindow := TSelectForm.Create(self);
      // //TypeForm := TTypeForm.Create(self);
      // TExamClientGlobal.Examinee.Status := esExamining;
      // TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.status,TExamClientGlobal.Examinee.RemainTime);
      // TExamClientGlobal.EnableTimer;
      // value := '<string>OK</string>';
      /// /       FlashPlayer.SetReturnValue(value);
      // Exit;
      // end;
      // if procName ='TestSelect' then begin
      // visible:=false;
      // TExamClientGlobal.SelectWindow.ShowModal;
      // end;
      // if procName ='TestOperator' then begin
      // visible:=false;
      // TExamClientGlobal.Floatwindow.ShowModal;
      // end;
      // if procName ='TestType' then begin
      // visible:=false;
      // TTypeForm.TypeFormShow(self);
      // Visible :=True;
      /// /        value := GetTQIDByPreFix('C%',TExamClientGlobal.DmClient.GetTQDBConn);
      /// /
      /// /        typeform :=Ttypeform.Create(application);
      /// /
      /// /           if TExamClientGlobal.DmClient.FilterQueryst_da.asstring='' then
      /// /           begin
      /// /              TypeForm.ShowModal;
      /// /              typeform.Release;
      /// /           end
      /// /           else
      /// /           if  strtoint(TExamClientGlobal.DmClient.FilterQueryst_da.asstring)<5 then
      /// /           begin
      /// /             visible := True ;
      /// /             application.MessageBox('打字时间已用完，你不能进入！','提示：',MB_OK);
      /// /           end
      /// /           else
      /// /           begin
      /// /             TypeForm.ShowModal;
      /// /             typeform.Release;
      /// /           end;
      // end;
      // if procName ='TestSubmit' then begin
      // if application.MessageBox('你真的要交卷吗？','提示：',MB_YESNO)=IDYES then
      // begin
      // ModalResult:=mrOk;
      // TExamClientGlobal.UnableTimer;
      // //FlashPlayer.StopPlay;
      // close;
      // end;
      // end;
      //
      // if procName = 'CloseApp' then begin
      // //GlobalExamTCPClient.Disconnect;
      // ModalResult := mrOk;
      // Close;
      // end;
   end;

{ TODO -ojp -cMust : 如果在登录状态直接关闭，必须发送信息到服务器，结束会话和连接 }
procedure TClientMainForm.FormClose(Sender : TObject; var Action : TCloseAction);
var
  ksPath:string;
   begin
      {$IFDEF DEBUG}
      if ModalResult = mrAbort then
      begin
         TExamClientGlobal.ExamTCPClient.Disconnect;
         TExamClientGlobal.destroyclassobject();
         Release;
         Exit;
      end;
      {$ENDIF}
      if TExamClientGlobal.Examinee.Status >= esExamining then
      begin
         self.Visible := false;
         dograde;
      end;
      ksPath:=TExamClientGlobal.ExamPath;
      TExamClientGlobal.ExamTCPClient.Disconnect;
      TExamClientGlobal.destroyclassobject();
      DeleteDir(TExamClientGlobal.ExamPath);
      Release;
      Application.Terminate;
      // Application.Free;
   end;

procedure TClientMainForm.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
   begin
      if ModalResult = mrOk then
      begin
         CanClose := true;
         {$IFDEF DEBUG}
         CnDebugger.LogMsg('Client can close!');
         {$ENDIF}
         // closenum := closenum + 1;
         // if closenum = 1 then
         // CanClose := true
         // else
         // begin
         // CanClose := false;
         // {$IFDEF DEBUG}
         // CnDebugger.LogMsgWithLevel(msg + 'Client close over onece!', 0);
         // {$ENDIF}
         // end;

      end
      else if TExamClientGlobal.Examinee.Status = esLogined then
      begin
         // send close
         TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID, TExamClientGlobal.Examinee.Name, esNotLogined,
                 TExamClientGlobal.Examinee.RemainTime);
         //TExamClientGlobal.ExamTCPClient.DisconnectNotifyPeer();
         CanClose := true;
      end
      else
      begin
         CanClose := false;
         {$IFDEF DEBUG}
         if ModalResult = mrAbort then
            CanClose := true;
         {$ENDIF}
      end;
   end;

end.
