unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,CustomLoginForm, Vcl.StdCtrls,
  Vcl.Buttons, JvExControls, JvSpeedButton, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxButtons;

type
  TFrmLogin = class(TCustomLoginForm)
    edtExamineeID: TEdit;
    edtExamineeName: TEdit;
    lblID: TLabel;
    lblName: TLabel;
    btnStartExam: TJvSpeedButton;
    procedure btnStartExamClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TFrmLogin;

implementation

{$R *.dfm}

procedure TFrmLogin.btnStartExamClick(Sender: TObject);
begin
  edtExamineeID.Color
end;

end.
