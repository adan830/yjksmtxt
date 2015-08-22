unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  cxControls, cxContainer, cxEdit, cxTextEdit, Vcl.Imaging.jpeg, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls,CustomQuestionLoginForm;

type
  TLoginForm = class(TCustomQuestionLoginForm)
    btnOk: TcxButton;
    btnCancel: TcxButton;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    edtUserName: TcxTextEdit;
    edtPassword: TcxTextEdit;
  private

  public
  class function Login(var UserName, Password: string): boolean; static;
  end;


implementation

{$R *.dfm}

class function TLoginForm.Login(var UserName, Password: string): boolean;
var
  frmLogin: TLoginForm;
begin
  frmLogin := TLoginForm.Create(nil);
  try
    frmLogin.edtUserName.Text := UserName;
    frmLogin.edtPassword.Text := Password;
    result := frmLogin.ShowModal = mrOK;
    UserName := frmLogin.edtUserName.Text;
    Password := frmLogin.edtPassword.Text;
  finally // wrap up
    frmLogin.Free;
  end;    // try/finally
end;
end.
