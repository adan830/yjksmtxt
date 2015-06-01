//9558-8040-0011-9229-876

unit ufrmChangePassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmAppDlgBase, ExtCtrls, StdCtrls, cxButtons, Menus, cxLookAndFeelPainters;

type
  TfrmChangePassword = class(TfrmAppDlgBase)
    Label2: TLabel;
    edtOldPassword: TEdit;
    Label3: TLabel;
    edtNewPassword: TEdit;
    Label4: TLabel;
    edtNewPasswordRep: TEdit;
    procedure btnOKClick(Sender: TObject);
  private
    FNeedOldPassword: boolean;
    FOldPassword: string;
    procedure SetNeedOldPassword(const Value: boolean);
    { Private declarations }
  public
    { Public declarations }
    class function ChangePassword(var NewPassword : string; NeedOldPassword : boolean = false; OldPassword : string = '') : boolean;

    property NeedOldPassword : boolean read FNeedOldPassword write SetNeedOldPassword;
    property OldPassword : string read FOldPassword write FOldPassword;
  end;

implementation

{$R *.dfm}

{ TfrmChangePassword }

class function TfrmChangePassword.ChangePassword(var NewPassword: string;
  NeedOldPassword: boolean; OldPassword: string): boolean;
var
  frmChangePassword: TfrmChangePassword;
begin
  frmChangePassword := TfrmChangePassword.Create(nil);
  try
    frmChangePassword.NeedOldPassword := NeedOldPassword;
    frmChangePassword.OldPassword := OldPassword;

    result := frmChangePassword.ShowModal = mrOK;

    NewPassword := frmChangePassword.edtNewPassword.Text;
  finally // wrap up
    frmChangePassword.Free;
  end;    // try/finally
end;

procedure TfrmChangePassword.SetNeedOldPassword(const Value: boolean);
begin
  FNeedOldPassword := Value;

  edtOldPassword.ReadOnly := not NeedOldPassword;
end;

procedure TfrmChangePassword.btnOKClick(Sender: TObject);
begin
  inherited;

  if NeedOldPassword then
    if edtOldPassword.Text <> OldPassword then
    begin
      ShowMessage('您输入的旧密码与原密码不符！');
      self.ModalResult := mrNone;
    end;

  if edtNewPassword.Text <> edtNewPasswordRep.Text then
  begin
    ShowMessage('您两次输入的密码不相同！');
    self.ModalResult := mrNone;
  end;
end;

end.
