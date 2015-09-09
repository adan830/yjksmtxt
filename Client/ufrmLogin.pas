unit ufrmLogin;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomLoginForm, Vcl.StdCtrls,
   Vcl.Buttons, JvExControls, JvSpeedButton, cxGraphics, cxLookAndFeels,
   cxLookAndFeelPainters, Vcl.Menus, cxButtons, netglobal, IdBaseComponent, IdComponent, IdIPWatch;

type
   TFrmLogin = class(TcustomLoginForm)
      edtExamineeID : TEdit;
      edtExamineeName : TEdit;
      lblID : TLabel;
      lblName : TLabel;
      btnStartExam : TJvSpeedButton;
      procedure edtExamineeIDKeyPress(Sender : TObject; var Key : Char);
      procedure btnStartExamClick(Sender : TObject);
   private
      examineeID, examineeName : string;

      function GetExamineeInfo(AExamineeID : string; out examineeInfo : Texaminee) : bool;
      function GetExamineePhoto(AExamineeID : string; photoStream : TmemoryStream) : Texaminee;
      // procedure CreateEnvironment(const ALoginType: TLoginType);
      // procedure InitExam;
      { Private declarations }
   public
      function Login:TCommandResult;
      { Public declarations }
   end;

implementation

uses ExamClientGlobal, clientmain, commons, ExamTypeFrm;

{$R *.dfm}

procedure TFrmLogin.btnStartExamClick(Sender : TObject);
   begin
      try
         if Login()=crok then
          modalResult := TExamClientGlobal.InitExam;
      except
         application.NormalizeTopMosts;
         application.MessageBox('生成考试环境出现问题，请重新进入系统', '提示:', mb_ok);
         application.RestoreTopMosts;
         modalResult := -1;
      end;
   end;

procedure TFrmLogin.edtExamineeIDKeyPress(Sender : TObject; var Key : Char);
   var
      sMessage : string;
      cc, dd   : integer;
   begin
      if (Key = #13) then
      begin
         if (length(edtExamineeID.Text) = 11) then
         begin
            if GetExamineeInfo(edtExamineeID.Text, TExamClientGlobal.Examinee) then
            begin
               TExamClientGlobal.ExamTCPClient.CommandGetExamineePhoto(TExamClientGlobal.Examinee.ID, TExamClientGlobal.ExamineePhoto);
               // if examineeName.Length>0 then
               begin
                  edtExamineeName.Text := TExamClientGlobal.Examinee.Name;
                  //Login();
                  btnStartExam.Enabled := true;
               end;
            end
            else
            begin
               edtExamineeName.Text := '';
               btnStartExam.Enabled := false;
            end;
         end
         else
         begin
            sMessage := '你的准考证号有误，请重新输入！';
            // application.NormalizeTopMosts;
            application.MessageBox(pchar(sMessage), '请确认:', mb_ok);
            edtExamineeID.SetFocus;
         end;
      end;

      // if key=#13 then
      // begin
      // if length(UserId.Text)11=11 then
      // begin
      // dm.tbKsXxk.Active:=true;
      // if dm.tbKsXxk.Locate('zkh',UserID.Text,[loCaseInsensitive])  then
      // begin
      // dm.kszkh:=dm.tbKsXxk.FieldValues['zkh'];
      // dm.ksxm:=dm.tbKsXxk.FieldValues['xm'];
      // dm.kssj:=dm.tbKsXxk.FieldValues['zsj'];
      // dm.ksPath:='K:\'+dm.kszkh;
      // dm.ksStatus:=strtoint(DecryptStr(dm.tbksXxk.fieldbyname('status').AsString));
      //
      // SetSysConfig;
      //
      // sMessage:='你的姓名：'+dm.ksxm+#13+#13+'准考证号：'+dm.kszkh+#13;
      //
      // application.NormalizeTopMosts;
      // cc:=application.MessageBox(pchar(sMessage), '请确认:', mb_yesno);
      // if cc=6 then
      // begin
      // if dm.ksStatus>0 then
      // begin
      // ExamTypeForm:=TExamTypeForm.create(self);
      // dd:=examtypeForm.showmodal;
      // ExamTypeForm.Free;
      // if dd=-1 then
      // begin
      // dm.ksstatus:=-1;
      // dm.kssj:=5400;
      // btSubmit.enabled:=true;
      // end;
      // if dd=-2 then
      // begin
      // dm.ksstatus:=-2;
      // btSubmit.enabled:=true;
      // end;
      // if dd=-3 then
      // begin
      // dm.ksstatus:=-3;
      // btSubmit.enabled:=false;
      // end;
      //
      // end
      // else
      // begin
      // dm.ksstatus:=1;
      // btSubmit.enabled:=true;
      // end;
      //
      // end
      // else
      // begin
      // btSubmit.enabled:=false;
      // end;
      // application.RestoreTopMosts;
      // end
      // else
      // begin
      // sMessage:='你的准考证号有误，请重新输入！';
      // application.NormalizeTopMosts;
      // if application.MessageBox(pchar(sMessage), '请确认:', mb_Ok)=6 then
      //
      // application.RestoreTopMosts;
      // end;
      // end;
      // end;
   end;

function TFrmLogin.GetExamineeInfo(AExamineeID : string; out examineeInfo : Texaminee) : bool;
   var
      sMessage : string;
   begin
      if length(AExamineeID) = CONSTEXAMINEEIDLENGTH then
      begin
         if (TExamClientGlobal.ExamTCPClient.CommandGetExamineeInfo(AExamineeID, TExamClientGlobal.Examinee) = crOK) then
         begin
            examineeInfo := TExamClientGlobal.Examinee;
            result       := true;
         end
         else
         begin
            sMessage := '获取考生信息错误！请与老师确认考生号！';
            application.MessageBox(pchar(sMessage), '请确认:', mb_ok);
            result := false;
         end;
      end
      else
      begin
         sMessage := '准考证号长度不够！';
         application.MessageBox(pchar(sMessage), '请确认:', mb_ok);
         result := false;
      end;
   end;

function TFrmLogin.GetExamineePhoto(AExamineeID : string; photoStream : TmemoryStream) : Texaminee;
   begin
      if length(AExamineeID) = CONSTEXAMINEEIDLENGTH then
      begin
         if (TExamClientGlobal.ExamTCPClient.CommandGetExamineePhoto(AExamineeID, photoStream) = crOK) then
         begin
            result := TExamClientGlobal.Examinee;
            // begin
            // Result :='OK,'+ ID+','+Name+','+GetStatusDisplayValue(Status)+','+IntToStr(RemainTime);
            // end;
         end
         // else begin
         // Result := '获取考生信息错误！';
         // end;
         // end else begin
         // Result := '准考证号长度不够！';
      end;
   end;

function TFrmLogin.Login:TCommandResult;
   var
      mr          : integer;
      loginResult : TCommandResult;
      sExamPath   : string;
      aloginType  : TloginType;
      apwd        : string;
      atime       : integer;
   begin
      loginResult:=crRefuseLogin;
      apwd  := 'NULL';
      atime := 0;
      with TExamClientGlobal do
      begin
         if BaseConfig.LoginPermissionMode = 0 then
         begin
            case Examinee.Status of
               esNotLogined :
                  begin
                     LoginType := ltFirstLogin;
                  end;
               esDisConnect :
                  begin
                     if Examinee.ID = EmptyStr then
                        raise Exception.Create('考生ID不能为空');
                     sExamPath :=IncludeTrailingPathDelimiter(TExamClientGlobal.ExamPath)+ Examinee.ID;  // BaseConfig.ExamPath + '\' + Examinee.ID;
                     if DirectoryExists(sExamPath) then
                     begin
                        LoginType := ltContinuteInterupt;
                     end
                     else
                     begin
                        { TODO：中断换机续考 }
                        application.MessageBox(PWideChar('由于考试中断，但本地找不到中断的考生文件夹，不能进行继考！'#13#10+'请检查文件夹:'+sexampath+'是否存在！'), '提示:', mb_ok);
                     end;
                  end;
            else // esAllowContinuteExam ,esAllowReExam,esLogined
               begin
                  { TODO -ojp -cMust : 如果有考生已经用相同考号登录，使用密码强行登录续考或重考，前一个考生将出现问题，当然老师在强行登录时应该核对考生，前一考生应该是有问题的 }
                  // 如果是其它状态，则通过密码强行登录
                  if TExamTypeForm.ShowModelForm(aloginType, apwd, atime)= mrOk then
                  begin
                     LoginType := aloginType;
                     if atime>0 then
                        examinee.RemainTime:= examinee.RemainTime+atime;
                  end;
               end;
            end;
         end;
         // else
         // begin
         // loginResult := TExamClientGlobal.Login();
         // end;
         loginResult := TExamClientGlobal.Login(TExamClientGlobal.LoginType, apwd);
         result:=loginresult;
         if loginResult <> crOK then
         begin
            application.MessageBox('登录失败！', '请确认:', mb_ok);
            exit;
         end;
      end;
      // TExamClientGlobal.InitExam;
   end;

end.
