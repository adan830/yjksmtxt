unit ufrmServerLogin;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvSpeedButton, CustomLoginForm;

type
   TFormServerLogin = class(TCustomLoginForm)
      lblID : TLabel;
      btnLogin : TJvSpeedButton;
      edtPwd : TEdit;
      procedure btnLoginClick(Sender : TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   FormServerLogin : TFormServerLogin;

implementation

uses
   System.Hash, ServerGlobal;

{$R *.dfm}

procedure TFormServerLogin.btnLoginClick(Sender : TObject);
   var
      pwd : string;
   begin
      pwd := THashMD5.GetHashString(trim(edtPwd.text));
      if pwd = TExamServerGlobal.ServerCustomConfig.AdminPwd then
         ModalResult := mrOk
      else
         application.MessageBox('密码错误，请重新输入！', '提示:', mb_ok);
   end;

end.
