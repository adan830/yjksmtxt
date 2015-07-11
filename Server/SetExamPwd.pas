unit SetExamPwd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, Vcl.StdCtrls;

type
  TResetExamPwdForm = class(TForm)
    edtAddTimePwd1: TcxTextEdit;
    edtAddTimePwd: TcxTextEdit;
    cxLabel13: TcxLabel;
    cxLabel5: TcxLabel;
    edtContPwd: TcxTextEdit;
    edtContPwd1: TcxTextEdit;
    edtRetryPwd: TcxTextEdit;
    edtRetryPwd1: TcxTextEdit;
    cxLabel6: TcxLabel;
    btnYes: TButton;
    btnCancel: TButton;
    procedure btnYesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TResetExamPwdForm.btnYesClick(Sender: TObject);
var
   error:Boolean;
begin
         if (length(trim(edtContPwd.text))=0) or (edtContPwd.text<>trim(edtContPwd1.text)) then error:=true;
         if (length(trim(edtRetryPwd.text))=0) or (edtRetryPwd.text<>trim(edtRetryPwd1.text)) then error:=true;
         if (length(trim(edtAddTimePwd.text))=0) or (edtAddTimePwd.text<>trim(edtAddTimePwd1.text)) then error:=true;

      if error then
      begin
         ShowMessage('二次密码不一致，或密码不能为空，请检查！');
         exit;
      end;
      self.ModalResult:=mrYes;
end;

end.
