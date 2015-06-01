unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, udmClient,  jpeg, ExtCtrls,dbtables,
  Buttons, ComCtrls, NetGlobal, FlashPlayerControl;

type
  TLoginForm = class(TForm)
    BtSubmit: TButton;
    Label2: TLabel;
    BtCancel: TButton;
    edtUserId: TEdit;
    Label1: TLabel;
    Image1: TImage;
    tmrLogin: TTimer;
    FlashPlayer: TFlashPlayerControl;

    procedure BtSubmitClick(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
    procedure edtUserIdKeyPress(Sender: TObject; var Key: Char);
    procedure tmrLoginTimer(Sender: TObject);

    procedure FlashPlayerFlashCall(ASender: TObject; const request: WideString);
    procedure FormShow(Sender: TObject);
  private
    loginescapetime:Int64;
//    function NotarizeExaminee(AExaminee : TExaminee) : Integer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  {$IFDEF TEST}
  public
      function Login(AExamineeID:string):Boolean;
      function GetExamineeInfo(AExamineeID:string):string;
      procedure CreateEnvironment;
  {$ELSE}
  private
    function GetExamineeInfo(AExamineeID:string):string;
    function Login(AExamineeID:string):Boolean;
      { Private declarations }
    procedure CreateEnvironment;
  {$ENDIF}
  end;

var
  LoginForm: TLoginForm;
  FlashCodeStream: TResourceStream;

implementation

uses adodb,uFnPublic,  ExamTCPClient,ClientGlobal,ExamGlobal,ExamTypeFrm,ShellExamCommons,XMLIntf,XMLDoc;        //ExamTypeFrm

{$R *.dfm}
{$R CoverFlash.res}

procedure TLoginForm.BtSubmitClick(Sender: TObject);

begin
   tmrLogin.Enabled := false;
   CreateEnvironment;    //  建立考试环境
end;

procedure TLoginForm.CreateEnvironment;
begin
//   SetSysConfig();
   SetGlobalExamPath;
   try
      if GlobalLoginType=ltContinueExam then
      begin
         GetExamineeZipFile(GlobalExaminee.ID);
         GlobalDmClient.SetEQBConn(GlobalExamPath);   //设置考生试题库连接
         GlobalDmClient.SetupExamineeInfoBase(GlobalExaminee);  //以备上报评分时获得考生信息
//         dm.ksStatus:=1;
      end
      else
      begin
         CreateExamineeBase(GlobalExamPath);                  //建立考生试题库并切换考生信息到考生数据库
         CreateWindowsExamEnvironment(GlobalExamPath);
         CreateWordExamEnvironment(GlobalExamPath);
         CreateExcelExamEnvironment(GlobalExamPath);
         CreatePptExamEnvironment(GlobalExamPath);
//         ClearScore;       // 清除系统考生信息中得分
         { raise ERangeError.CreateFmt('%d is not within the valid range of %d..%d', [1, 1, 1]);  }
      end;
//      updateExamState(dm.ksStatus);
//
//      dm.TbKsxxk.close;
      modalResult:=1;
   except
      MessageBoxOnTopForm(Application,'生成考试环境出现问题，请重新进入系统', '提示:', mb_ok);
      modalResult:=-1;
   end;
end;

procedure TLoginForm.CreateParams(var Params: TCreateParams);
begin
  inherited   CreateParams( Params );
  with Params do
  begin
    Style :=ws_overlapped;//WS_POPUP+WS_MAXIMIZE;  //	;ws_overlapped             //+
//    params.ExStyle:=ws_ex_topmost;
      WndParent :=0;   // mainform.Handle;    //父窗体为form1
//    Self.Left :=0;
//    Self.Top :=0;
//    Self.AutoSize :=False;
  end;
end;

//function TLoginForm.NotarizeExaminee(AExaminee: TExaminee): Integer;
//var
//   sMessage : string;
//begin
//   sMessage:='你的姓名：'+ AExaminee.Name + CR + CR +'准考证号：'+ AExaminee.ID + CR;
//   result := MessageBoxOnTopForm(Application,sMessage, '请确认:', mb_yesno) ;
//end;

procedure TLoginForm.tmrLoginTimer(Sender: TObject);
begin
   loginescapetime := loginescapetime +1;
   if (loginescapetime div GlobalSysConfig.StatusRefreshInterval)=(loginescapetime / GlobalSysConfig.StatusRefreshInterval) then
      begin
         { TODO -ojp -c0 : direct update remaintime in server ,is correct ? }
         GlobalExamTCPClient.CommandSendExamineeStatus(GlobalExaminee.ID,GlobalExaminee.Name,GlobalExaminee.Status,GlobalExaminee.RemainTime);
      end;
end;

procedure TLoginForm.BtCancelClick(Sender: TObject);
begin
   modalResult:=-1;
end;

{$region '-----oldLogin已更改为GetExamineeInfo 和 Login 二个函数为 flash 使用'}
// 已更改为GetExamineeInfo 和 Login 二个函数为 flash 使用
//function TLoginForm.Login(AExamineeID:string):Boolean;
//var
//  loginResult: TCommandResult;
//begin
//  Result := False;
//  if length(AExamineeID) = CONSTEXAMINEEIDLENGTH  then
//  begin
//    if (GlobalExamTCPClient.CommandGetExamineeInfo(AExamineeID, GlobalExaminee) = crOK) and (NotarizeExaminee(GlobalExaminee) = IDYES)  then
//    begin //        GlobalExamPath := 'e:\yjksmtxt\debug';
//      //        SetSysConfig;
//      { TODO -ojp -cneeddo : 考试环境、时间需要设置 }
//      loginResult := crError;
//      case GlobalExaminee.Status of
//        esNotLogined: begin
//            GlobalLoginType := ltFirstLogin;
//            loginResult := GlobalExamTCPClient.CommandExamineeLogin(GlobalExaminee, GlobalLoginType);
//        end;
//        esDisConnect, esLogined, esGetTestPaper, esExamining, esSutmitAchievement, esExamEnded: begin
//            ExamTypeForm := TExamTypeForm.create(self);
//            case examtypeForm.showmodal of
//              mrAll:
//                begin //8
//                  GlobalLoginType := ltReExamLogin;
//                  loginResult := GlobalExamTCPClient.CommandExamineeLogin(GlobalExaminee, GlobalLoginType, ExamTypeForm.UserPwd);
//                end;
//              mrOk:
//                begin
//                  GlobalLoginType := ltContinueExam;
//                  loginResult := GlobalExamTCPClient.CommandExamineeLogin(GlobalExaminee, GlobalLoginType, ExamTypeForm.UserPwd);
//                end;
//            end;
//          end;
//      end;
//      if loginResult = crOk  then begin
//        Result := True;
//      end;
//    end;
//  end;
//end;
{$ENDREGION}

function TLoginForm.Login(AExamineeID:string):Boolean;
var
  loginResult: TCommandResult;
begin
  Result := False;
      { TODO -ojp -cneeddo : 考试环境、时间需要设置 }
      loginResult := crError;
      case GlobalExaminee.Status of
        esNotLogined: begin
            GlobalLoginType := ltFirstLogin;
            loginResult := GlobalExamTCPClient.CommandExamineeLogin(GlobalExaminee, GlobalLoginType);
        end;
        esDisConnect, esLogined, esGetTestPaper, esExamining, esSutmitAchievement, esExamEnded: begin
            ExamTypeForm := TExamTypeForm.create(self);
            case examtypeForm.showmodal of
              mrAll:
                begin //8
                  GlobalLoginType := ltReExamLogin;
                  loginResult := GlobalExamTCPClient.CommandExamineeLogin(GlobalExaminee, GlobalLoginType, ExamTypeForm.UserPwd);
                end;
              mrOk:
                begin
                  GlobalLoginType := ltContinueExam;
                  loginResult := GlobalExamTCPClient.CommandExamineeLogin(GlobalExaminee, GlobalLoginType, ExamTypeForm.UserPwd);
                end;
            end;
          end;
      end;
      if loginResult = crOk  then begin
        Result := True;
      end;
end;

procedure TLoginForm.edtUserIdKeyPress(Sender: TObject; var Key: Char);
begin
{ TODO -ojp -c0 : while inputed Examinee.ID'length equals 11 then triger login event; }
   if key = CR then
   begin
     BtSubmit.Enabled := False;
     if Login(edtUserId.Text) then begin
        BtSubmit.Enabled := True;
        tmrLogin.Enabled := True;
     end else begin
   {$IFNDEF TEST}
        MessageBoxOnTopForm(Application, '你的准考证号有误，请重新输入！', '错误！', mb_Ok);
   {$ENDIF}
     end;
   end;
end;



procedure TLoginForm.FlashPlayerFlashCall(ASender: TObject; const request: WideString);
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
    if procName = 'GetExamineeInfo' then begin
      value := GetExamineeInfo(param);
      value := '<string>'+value+'</string>';
      FlashPlayer.SetReturnValue(value);
      Exit;
    end;
    if procName = 'ExamLogin' then begin
       if Login(GlobalExaminee.ID) then begin
         tmrLogin.Enabled := True;
          value := '<string>LoginOK</string>';
          FlashPlayer.SetReturnValue(value);
       end;
       Exit;
    end;
    if procName ='CreateEnvironment' then begin
       tmrLogin.Enabled := False;
       CreateEnvironment;
    end;

    if procName = 'CloseApp' then
      Close;
end;

procedure TLoginForm.FormShow(Sender: TObject);
var
   flashStream:TResourceStream;
begin
   flashStream:=TResourceStream.Create(0,'CoverFlash','Flash');
   FlashPlayer.LoadMovieFromStream(0,flashStream);
   flashStream.Free;
   FlashPlayer.Play;
end;

function TLoginForm.GetExamineeInfo(AExamineeID: string): string;
begin
  if length(AExamineeID) = CONSTEXAMINEEIDLENGTH  then
  begin
    if (GlobalExamTCPClient.CommandGetExamineeInfo(AExamineeID, GlobalExaminee) = crOK) then
    begin
       Result :='OK,'+ GlobalExaminee.ID+','+GlobalExaminee.Name+','+GetStatusDisplayValue(GlobalExaminee.Status);
    end else begin
       Result := '获取考生信息错误！';
    end;
  end else begin
     Result := '准考证号长度不够！';
  end;
end;

initialization
   FlashCodeStream := TResourceStream.Create(0, 'FlashOCX', 'BIN');
   FlashPlayerControl.LoadFlashOCXCodeFromStream(FlashCodeStream);
   FlashCodeStream.Free;
end.
