unit ClientMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ExtCtrls, Buttons,ScoreIni, StdCtrls, NetGlobal; //  floatform,

type
  TClientMainForm = class(TForm)
    btn1: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FlashPlayerFlashCall(ASender: TObject; const request: WideString);
    procedure btn1Click(Sender: TObject);
  private
    FDz:boolean;
    closenum:integer;

    procedure SendExamineeDict;
    //moved form loginForm
   // function Login(AExamineeID:string):Integer;
    function GetExamineeInfo(AExamineeID:string):string;
    procedure CreateEnvironment(const ALoginType: TLoginType);
    procedure SaveScoreToDB(AScore: TScoreIni);
    function GetExamineeIDLength: string;
    //procedure WinGrade(pbHandle: integer);
  public
    winStatus:boolean;
    pbHandle:integer;  //表示进度条对象
    procedure dograde;
    procedure SetFlashRemainTime(const ARemainTime: string);
    destructor Destroy();override;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure OnTimer(sender : TObject);
  end;

  procedure OnProcess(AMessage:string;AStep:Integer=1);
//var
//  FlashCodeStream: TResourceStream;
implementation

uses  floatform,XMLIntf,XMLDoc,
  ufrmExit, ADODB, Select, KeyType,SelectGrade, score, ExamGlobal, 
  ufrmInProcess, Commons, compress, DB, DataUtils, DataFieldConst,tq,
  ExamClientGlobal;

{$R *.dfm}
//{$R CoverFlash.res}

function TClientMainForm.GetExamineeIDLength(): string;
begin
  Result := '11';
end;

function TClientMainForm.GetExamineeInfo(AExamineeID: string): string;
begin
  if length(AExamineeID) = CONSTEXAMINEEIDLENGTH  then
  begin
    if (TExamClientGlobal.ExamTCPClient.CommandGetExamineeInfo(AExamineeID, TExamClientGlobal.Examinee) = crOK) then
    begin
       with TExamClientGlobal.Examinee do
       begin
          Result :='OK,'+ ID+','+Name+','+GetStatusDisplayValue(Status)+','+IntToStr(RemainTime);
       end;
    end else begin
       Result := '获取考生信息错误！';
    end;
  end else begin
     Result := '准考证号长度不够！';
  end;
end;


//function TClientMainForm.Login(AExamineeID: string): Integer;
//var
//  loginResult: TCommandResult;
//begin
//  Result := -1;
//      { TODO -ojp -cneeddo : 考试环境、时间需要设置 }
//      loginResult := crError;
//      case TExamClientGlobal.Examinee.Status of
//        esNotLogined: begin
//                TExamClientGlobal.LoginType := ltFirstLogin;
//                loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
//            end;
//        esDisConnect: begin
//                //if DirectoryExists(GlobalExamPath) then
//                begin
//                  TExamClientGlobal.LoginType := ltContinuteInterupt;
//                  loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
//                end;
//            end;
//        esAllowContinuteExam: begin
//                TExamClientGlobal.LoginType := ltContinuteEndedExam;
//                loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
//            end;
//        esAllowReExam: begin
//                TExamClientGlobal.LoginType := ltReExamLogin;
//                loginResult := TExamClientGlobal.ExamTCPClient.CommandExamineeLogin(TExamClientGlobal.Examinee, TExamClientGlobal.LoginType);
//            end;
//        else begin
//               Result := 2; //refuse login
//            end;
//
//      end;
//      if loginResult = crOk  then begin
//        Result := 1; //login ok
//      end;
//end;

procedure TClientMainForm.OnTimer(sender: TObject);
begin
         if (TExamClientGlobal.Examinee.Status >= esLogined)  then
         begin
            { TODO -ojp -c0 : direct update remaintime in server ,is correct ? }
            TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.Status,TExamClientGlobal.Examinee.RemainTime);
         end;
end;

procedure OnProcess(AMessage: string;AStep:Integer=1);
begin
   PMOnProcess(TExamClientGlobal.ClientMainForm.pbHandle,AMessage,AStep);
end;


procedure TClientMainForm.btn1Click(Sender: TObject);
begin
   //SetFlashRemainTime('8:00');
   ModalResult := mrAbort;
   Close;
end;

procedure TClientMainForm.CreateEnvironment(const ALoginType: TLoginType);
begin
   TExamClientGlobal.SetGlobalExamPath;
   try
      case ALoginType of
        ltFirstLogin,ltReExamLogin,ltContinuteEndedExam: begin
                   TExamClientGlobal.CreateExamEnvironmentByTestFilepack(TExamClientGlobal.Examinee.ID,ALoginType,TExamClientGlobal.ExamPath);
                   TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);   //设置考生试题库连接
                   TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee);  //以备上报评分时获得考生信息
            end;
        ltContinuteInterupt: begin
                   if DirectoryExists(TExamClientGlobal.ExamPath) then begin
                     TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);   //设置考生试题库连接
                     TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee);  //以备上报评分时获得考生信息
                   end else begin
                      MessageBoxOnTopForm(Application,'找不到上次考试文件目录！', '提示:', mb_ok);
                      modalResult:= mrOk;
                   end;
            end;
      end; 
   except
      MessageBoxOnTopForm(Application,'生成考试环境出现问题，请重新进入系统', '提示:', mb_ok);
      modalResult:= mrOk;
   end;

end;

procedure TClientMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited   CreateParams( Params );
  with Params do
  begin
   // {$IFNDEF DEBUG}
    Style :=WS_POPUP+WS_MAXIMIZE ;             //ws_overlapped+      params.ExStyle:=ws_ex_topmost;
    //ExStyle := ExStyle + WS_EX_APPWINDOW	;
    WndParent :=0;   // mainform.Handle;    //父窗体为form1
    Self.Left :=0;
    Self.Top :=0;
    Self.AutoSize :=False;
    //{$ENDIF}
//    FlashPlayer.Scale := 'ExactFit';  //是在控件中拉伸
//    FlashPlayer.ScaleMode :=2;
  end;
end;

destructor TClientMainForm.Destroy;
begin
//  FlashPlayer.Free;
  inherited;
end;

procedure TClientMainForm.SaveScoreToDB(AScore: TScoreIni);
var
  ds :TDataSet;
  stream : TMemoryStream;
begin
  ds := GetDataSetBySQL(SQLSTR_GETCLIENT_EXAMINEEINFO,TExamClientGlobal.Examinee.ID,TExamClientGlobal.connClientDB);
  stream := TMemoryStream.Create;
  try
    with ds do begin
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

procedure TClientMainForm.FormCreate(Sender: TObject);
var
   flashStream:TResourceStream;
begin
  FDz:=false;
  closenum:=0;
//  flashStream:=TResourceStream.Create(0,'CoverFlash','Flash');
//   FlashPlayer.LoadMovieFromStream(0,flashStream);
//   flashStream.Free;
//   FlashPlayer.Play;
   TExamClientGlobal.ExamTCPClient.OnTimer := OnTimer;
end;



procedure TClientMainForm.dograde;
var
  I: Integer;
  zf:Integer;
  AOnProcess:TOnProcess;
begin
    //GlobalDmClient.MainTimer.Enabled := False;
    TExamClientGlobal.Examinee.Status := esGrading;
    TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.status,TExamClientGlobal.Examinee.RemainTime);
    AOnProcess := onProcess;

    pbHandle:=PMBeginProcess(Application,'系统正在评分，请不要进行其它操作！！！','正在开始评分！',0, 100,-1);
    try
      SingleSelectGrade(AOnProcess);
      MultiSelectGrade(AOnProcess);
      OperationGrade(AOnProcess,TExamClientGlobal.ConnClientDB,TExamClientGlobal.ExamPath);
    finally
      PMEndProcess(pbHandle);
    end;

    SaveScoreToDB(TExamClientGlobal.Score);
    TExamClientGlobal.Examinee.Status := esSutmitAchievement;
    TExamClientGlobal.ExamTCPClient.CommandSendScoreInfo(TExamClientGlobal.Examinee,TExamClientGlobal.Score);
    SendExamineeDict();
    zf := TExamClientGlobal.Score.GetScoreValue;
    if (TExamClientGlobal.BaseConfig.ExamClasify=EXAMENATIONTYPESIMULATION) and (TExamClientGlobal.BaseConfig.ScoreDisplayMode=SCOREDISPLAYMODECLIENT) then
    begin
      scoreForm:=TScoreForm.Create(application);
      scoreForm.ShowModal;
    end;
     if TExamClientGlobal.BaseConfig.ExamClasify=EXAMINATIONTYPEFORMAL then
     begin
       frmExit := TfrmExit.Create(application);
       if zf=0 then
          frmExit.Label1.Caption :=  '注意考生成绩为：0分!  考试成功结束，请离开考场！'
       else
           frmExit.Label1.Caption:=   '           考试成功结束，请离开考场！          ';
       frmExit.ShowModal;
     end;

    if TExamClientGlobal.BaseConfig.ExamClasify=EXAMINATIONTYPEFORMAL then
    begin
      if  zf=0 then
         MessageBoxOnTopForm(Application,'注意考生成绩为：0分!     考试成功结束，请离开考场！','提示：', mb_Ok)
      else
          MessageBoxOnTopForm(Application,'考试成功结束，请离开考场！','提示：', mb_Ok);
    end;
end;

procedure TClientMainForm.SendExamineeDict();
var
   AStream:TMemoryStream;
begin
   try
      DirectoryCompression(TExamClientGlobal.ExamPath,AStream );
      if TExamClientGlobal.ExamTCPClient.CommandSendExamineeZipFile(TExamClientGlobal.Examinee.ID,AStream)=crOk then
         TExamClientGlobal.Examinee.Status := esExamEnded
      else
         TExamClientGlobal.Examinee.Status := esError;
      TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.Status,TExamClientGlobal.Examinee.RemainTime);
   finally
      AStream.Free;
   end;

end;

procedure TClientMainForm.SetFlashRemainTime(const ARemainTime: string);
var
   response,bb:WideString;
begin
//   bb := '<invoke name="CallMeFromApplication" returntype="xml"><arguments><string>'+ARemainTime+'</string></arguments></invoke>';
//   response :=FlashPlayer.CallFunction(bb);
end;

procedure TClientMainForm.FlashPlayerFlashCall(ASender: TObject; const request: WideString);
var
   xmlDoc : IXMLDocument ;
   invokeNode: IXMLNode;
   paramNode : IXMLNode;
   procName :string;
   param :string;
   value:string;
begin
    xmlDoc := TXMLDocument.Create(nil);
    try
      xmlDoc.XML.Text := request;
      xmlDoc.Active := True;
      invokeNode := xmlDoc.ChildNodes[0];
      procName :=invokeNode.Attributes['name'];
      if invokeNode.HasChildNodes then begin
         paramNode := invokeNode.ChildNodes[0];
         if paramNode.HasChildNodes then begin
            paramNode := paramNode.ChildNodes[0];
            param := paramNode.Text;
         end;
      end;
    finally
      paramNode :=nil;
      invokeNode :=nil;
      xmlDoc := nil;
    end;
    if procName = 'GetIDLength' then begin
      value := GetExamineeIDLength;
      value := '<string>'+value+'</string>';
//      FlashPlayer.SetReturnValue(value);
      Exit;
    end;
    if procName = 'GetExamineeInfo' then begin
      value := GetExamineeInfo(param);
      value := '<string>'+value+'</string>';
//      FlashPlayer.SetReturnValue(value);
      Exit;
    end;
    if procName = 'ExamLogin' then begin
       value := IntToStr(TExamClientGlobal.Login());
          value := '<string>'+value+'</string>';
//          FlashPlayer.SetReturnValue(value);
       Exit;
    end;
    if procName ='StartNewExam' then begin
       CreateEnvironment(TExamClientGlobal.LoginType);
       TExamClientGlobal.FloatWindow := TFloatWindow.Create(self);
       TExamClientGlobal.SelectWindow := TSelectForm.Create(self);
       //TypeForm := TTypeForm.Create(self);
       TExamClientGlobal.Examinee.Status := esExamining;
       TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.status,TExamClientGlobal.Examinee.RemainTime);
       TExamClientGlobal.EnableTimer;
       value := '<string>OK</string>';
//          FlashPlayer.SetReturnValue(value);
//          FlashPlayer.StopPlay;
       Exit;
    end;
     if procName ='ContinuteExam' then begin
       CreateEnvironment(TExamClientGlobal.LoginType);
       TExamClientGlobal.FloatWindow := TFloatWindow.Create(self);
       TExamClientGlobal.SelectWindow := TSelectForm.Create(self);
       //TypeForm := TTypeForm.Create(self);
       TExamClientGlobal.Examinee.Status := esExamining;
       TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.status,TExamClientGlobal.Examinee.RemainTime);
       TExamClientGlobal.EnableTimer;
       value := '<string>OK</string>';
//       FlashPlayer.SetReturnValue(value);
       Exit;
    end;
    if procName ='TestSelect' then begin
      visible:=false;
      TExamClientGlobal.SelectWindow.ShowModal;
    end;
    if procName ='TestOperator' then begin
      visible:=false;
      TExamClientGlobal.Floatwindow.ShowModal;
    end;
    if procName ='TestType' then begin
        visible:=false;
        TTypeForm.TypeFormShow(self);
        Visible :=True;
//        value := GetTQIDByPreFix('C%',TExamClientGlobal.DmClient.GetTQDBConn);
//
//        typeform :=Ttypeform.Create(application);
//
//           if TExamClientGlobal.DmClient.FilterQueryst_da.asstring='' then
//           begin
//              TypeForm.ShowModal;
//              typeform.Release;
//           end
//           else
//           if  strtoint(TExamClientGlobal.DmClient.FilterQueryst_da.asstring)<5 then
//           begin
//             visible := True ;
//             application.MessageBox('打字时间已用完，你不能进入！','提示：',MB_OK);
//           end
//           else
//           begin
//             TypeForm.ShowModal;
//             typeform.Release;
//           end;
    end;
    if procName ='TestSubmit' then begin
        if application.MessageBox('你真的要交卷吗？','提示：',MB_YESNO)=IDYES then
        begin
          ModalResult:=mrOk;
          TExamClientGlobal.UnableTimer;
          //FlashPlayer.StopPlay;
          close;
        end;           
    end;

    if procName = 'CloseApp' then begin
       //GlobalExamTCPClient.Disconnect;
       ModalResult := mrOk;
       Close;
    end;
end;



procedure TClientMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{$IFDEF DEBUG}
   if ModalResult = mrAbort then
   begin
     Release ;
     Exit;
   end;
{$ENDIF}
    if TExamClientGlobal.Examinee.Status >=esExamining then  begin
       self.Visible:=false;
       doGrade;
    end;
    TExamClientGlobal.ExamTCPClient.Disconnect;
    TExamClientGlobal.destroyclassobject();
    Release ;
    Application.Terminate;
    //Application.Free;
end;

procedure TClientMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult=mrOk then
  begin
    closenum:=closenum+1;
    if closenum=1 then
      CanClose := True
    else
      CanClose := False ;
  end
  else
{$IFDEF DEBUG}
  if ModalResult =mrAbort then
    CanClose := True;
{$ENDIF}
  
end;

end.


