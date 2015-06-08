unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,CustomLoginForm, Vcl.StdCtrls,
  Vcl.Buttons, JvExControls, JvSpeedButton, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxButtons,netglobal;

type
  TFrmLogin = class(TCustomLoginForm)
    edtExamineeID: TEdit;
    edtExamineeName: TEdit;
    lblID: TLabel;
    lblName: TLabel;
    btnStartExam: TJvSpeedButton;
    procedure edtExamineeIDKeyPress(Sender: TObject; var Key: Char);
    procedure edtExamineeNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnStartExamClick(Sender: TObject);
  private
    examineeID,
    examineeName:string;
    examineeInfo:Texaminee;

    function GetExamineeInfo(AExamineeID: string): TExaminee;
    procedure CreateEnvironment(const ALoginType: TLoginType);
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses ExamClientGlobal,clientmain,commons;

{$R *.dfm}



procedure TFrmLogin.btnStartExamClick(Sender: TObject);
begin
  try
      TExamClientGlobal.Login();

      CreateEnvironment(TExamClientGlobal.LoginType);
      TExamClientGlobal.ClientMainForm:=TClientMainForm.Create(self);
//       TExamClientGlobal.FloatWindow := TFloatWindow.Create(self);
//       TExamClientGlobal.SelectWindow := TSelectForm.Create(self);
       //TypeForm := TTypeForm.Create(self);
       TExamClientGlobal.Examinee.Status := esExamining;
       TExamClientGlobal.ExamTCPClient.CommandSendExamineeStatus(TExamClientGlobal.Examinee.ID,TExamClientGlobal.Examinee.Name,TExamClientGlobal.Examinee.status,TExamClientGlobal.Examinee.RemainTime);
       TExamClientGlobal.EnableTimer;
	     modalResult:=1;
   except
      application.NormalizeTopMosts;
      application.MessageBox('���ɿ��Ի����������⣬�����½���ϵͳ', '��ʾ:', mb_ok);
      application.RestoreTopMosts;
      modalResult:=-1;
   end;
end;

procedure TFrmLogin.edtExamineeIDKeyPress(Sender: TObject; var Key: Char);
var
 sMessage:string;
 cc,dd:integer;
begin
  if (key=#13) then
    begin
      if (length(edtExamineeID.Text)=11) then
      begin
         examineeinfo:= GetExamineeInfo(edtExamineeID.text);
         //if examineeName.Length>0 then
         begin
           edtExamineeName.text:=examineeInfo.Name;
           btnStartExam.Enabled:=true;
         end;

      end;
//      if (trim(edtExamineeName.text)=examineeInfo.Name) then
//        btnStartExam.Enabled:=true
//      else
//            begin
//          sMessage:='���׼��֤���������������룡';
//          application.NormalizeTopMosts;
//          if application.MessageBox(pchar(sMessage), '��ȷ��:', mb_Ok)=6 then
//
//          application.RestoreTopMosts;
//        end;
    end;

//if key=#13 then
//begin
//  if length(UserId.Text)11=11 then
//  begin
//    dm.tbKsXxk.Active:=true;
//    if dm.tbKsXxk.Locate('zkh',UserID.Text,[loCaseInsensitive])  then
//    begin
//        dm.kszkh:=dm.tbKsXxk.FieldValues['zkh'];
//        dm.ksxm:=dm.tbKsXxk.FieldValues['xm'];
//        dm.kssj:=dm.tbKsXxk.FieldValues['zsj'];
//        dm.ksPath:='K:\'+dm.kszkh;
//        dm.ksStatus:=strtoint(DecryptStr(dm.tbksXxk.fieldbyname('status').AsString));
//
//        SetSysConfig;
//
//        sMessage:='���������'+dm.ksxm+#13+#13+'׼��֤�ţ�'+dm.kszkh+#13;
//
//        application.NormalizeTopMosts;
//        cc:=application.MessageBox(pchar(sMessage), '��ȷ��:', mb_yesno);
//        if cc=6 then
//        begin
//          if dm.ksStatus>0 then
//          begin
//            ExamTypeForm:=TExamTypeForm.create(self);
//            dd:=examtypeForm.showmodal;
//            ExamTypeForm.Free;
//            if dd=-1 then
//            begin
//              dm.ksstatus:=-1;
//              dm.kssj:=5400;
//              btSubmit.enabled:=true;
//            end;
//            if dd=-2 then
//            begin
//              dm.ksstatus:=-2;
//              btSubmit.enabled:=true;
//            end;
//            if dd=-3 then
//            begin
//               dm.ksstatus:=-3;
//               btSubmit.enabled:=false;
//            end;
//
//          end
//          else
//          begin
//            dm.ksstatus:=1;
//            btSubmit.enabled:=true;
//          end;
//
//        end
//        else
//        begin
//          btSubmit.enabled:=false;
//        end;
//        application.RestoreTopMosts;
//    end
//    else
//    begin
//      sMessage:='���׼��֤���������������룡';
//      application.NormalizeTopMosts;
//      if application.MessageBox(pchar(sMessage), '��ȷ��:', mb_Ok)=6 then
//
//      application.RestoreTopMosts;
//    end;
//  end;
//end;
end;

procedure TFrmLogin.edtExamineeNameKeyPress(Sender: TObject; var Key: Char);
var
  sMessage:string;
begin




end;

function TFrmLogin.GetExamineeInfo(AExamineeID: string): TExaminee;
begin
  if length(AExamineeID) = CONSTEXAMINEEIDLENGTH  then
  begin
    if (TExamClientGlobal.ExamTCPClient.CommandGetExamineeInfo(AExamineeID, TExamClientGlobal.Examinee) = crOK) then
    begin
       result:= TExamClientGlobal.Examinee;
//       begin
//          Result :='OK,'+ ID+','+Name+','+GetStatusDisplayValue(Status)+','+IntToStr(RemainTime);
//       end;
    end
//    else begin
//       Result := '��ȡ������Ϣ����';
//    end;
//  end else begin
//     Result := '׼��֤�ų��Ȳ�����';
  end;
end;

procedure TFrmLogin.CreateEnvironment(const ALoginType: TLoginType);
begin
   TExamClientGlobal.SetGlobalExamPath;
   try
      case ALoginType of
        ltFirstLogin,ltReExamLogin,ltContinuteEndedExam: begin
                   TExamClientGlobal.CreateExamEnvironmentByTestFilepack(TExamClientGlobal.Examinee.ID,ALoginType,TExamClientGlobal.ExamPath);
                   TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);   //���ÿ������������
                   TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee);  //�Ա��ϱ�����ʱ��ÿ�����Ϣ
            end;
        ltContinuteInterupt: begin
                   if DirectoryExists(TExamClientGlobal.ExamPath) then begin
                     TExamClientGlobal.SetEQBConn(TExamClientGlobal.ExamPath);   //���ÿ������������
                     TExamClientGlobal.SetupExamineeInfoBase(TExamClientGlobal.Examinee);  //�Ա��ϱ�����ʱ��ÿ�����Ϣ
                   end else begin
                      MessageBoxOnTopForm(Application,'�Ҳ����ϴο����ļ�Ŀ¼��', '��ʾ:', mb_ok);
                      modalResult:= mrOk;
                   end;
            end;
      end;
   except
      MessageBoxOnTopForm(Application,'���ɿ��Ի����������⣬�����½���ϵͳ', '��ʾ:', mb_ok);
      modalResult:= mrOk;
   end;

end;

end.
