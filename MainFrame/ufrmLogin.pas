unit ufrmLogin;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmAppDlgBase, StdCtrls, Buttons, ExtCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxButtons, jpeg, cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters,
  cxGraphics, cxLookAndFeels;

type
  TfrmLogin = class(TfrmAppDlgBase)
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    edtUserName: TcxTextEdit;
    edtPassword: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    class function Login(var UserName : string; var Password : string) : boolean;
  end;


implementation

{$R *.dfm}

{ TfrmLogin }

class function TfrmLogin.Login(var UserName, Password: string): boolean;
var
  frmLogin: TfrmLogin;
begin
  frmLogin := TfrmLogin.Create(nil);
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
