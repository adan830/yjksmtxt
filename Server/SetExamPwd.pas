unit SetExamPwd;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, Vcl.StdCtrls,
   dxSkinsCore, dxSkinsDefaultPainters;

type
   TResetExamPwdForm = class(TForm)
      edtAddTimePwd1 : TcxTextEdit;
      edtAddTimePwd : TcxTextEdit;
      lblAddTime : TcxLabel;
      lblRetry : TcxLabel;
      edtContPwd : TcxTextEdit;
      edtContPwd1 : TcxTextEdit;
      edtRetryPwd : TcxTextEdit;
      edtRetryPwd1 : TcxTextEdit;
      lblContinue : TcxLabel;
      btnYes : TButton;
      btnCancel : TButton;
      edtAdminPwd : TcxTextEdit;
      edtAdminPwd1 : TcxTextEdit;
      cxLabel1 : TcxLabel;
      edtOldAdminPwd : TcxTextEdit;
      cxLabel2 : TcxLabel;
      procedure btnYesClick(Sender : TObject);
      procedure FormCreate(Sender : TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

implementation

uses
   System.Hash, serverGlobal;

{$R *.dfm}

procedure TResetExamPwdForm.btnYesClick(Sender : TObject);
   var
      error : Boolean;
      pwd   : string;
   begin
      pwd := THashMD5.GetHashString(trim(edtOldAdminPwd.text));
      if pwd <> TExamServerGlobal.ServerCustomConfig.AdminPwd then
         application.MessageBox('原管理员密码不正确，请重新输入！', '提示:', mb_ok)
      else
      begin
         if (length(trim(edtAdminPwd.text)) = 0) or (edtAdminPwd.text <> trim(edtAdminPwd1.text)) then
            error := true;
         if TExamServerGlobal.ServerCustomConfig.LoginPermissionModel = 0 then
         begin
            if (length(trim(edtContPwd.text)) = 0) or (edtContPwd.text <> trim(edtContPwd1.text)) then
               error := true;
            if (length(trim(edtRetryPwd.text)) = 0) or (edtRetryPwd.text <> trim(edtRetryPwd1.text)) then
               error := true;
            if (length(trim(edtAddTimePwd.text)) = 0) or (edtAddTimePwd.text <> trim(edtAddTimePwd1.text)) then
               error := true;
         end;
         if error then
         begin
            ShowMessage('二次密码不一致，或密码不能为空，请检查！');
            exit;
         end;
         self.ModalResult := mrYes;
      end;
   end;

procedure TResetExamPwdForm.FormCreate(Sender : TObject);
   begin
      if TExamServerGlobal.ServerCustomConfig.LoginPermissionModel <> 0 then
      begin
         lblContinue.Visible    := false;
         lblAddTime.Visible     := false;
         lblRetry.Visible       := false;
         edtContPwd.Visible     := false;
         edtContPwd1.Visible    := false;
         edtRetryPwd.Visible    := false;
         edtRetryPwd1.Visible   := false;
         edtAddTimePwd.Visible  := false;
         edtAddTimePwd1.Visible := false;
      end;
   end;

end.
