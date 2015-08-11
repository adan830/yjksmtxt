unit ufrmServerLock;

interface

   uses
      Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
      Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvSpeedButton, CustomColorForm,
      CnButtons, Vcl.ExtCtrls;

   type
      TFormServerLock = class(TCustomColorForm)
         lblID: TLabel;
         edtPwd: TEdit;
         btnGrade: TCnSpeedButton;
    Panel1: TPanel;
         procedure btnLoginClick(Sender: TObject);
         procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
         private
            { Private declarations }
         public
            { Public declarations }
      end;

implementation

   uses
      System.Hash, ServerGlobal;

   {$R *.dfm}

   procedure TFormServerLock.btnLoginClick(Sender: TObject);
      var
         pwd: string;
      begin
         pwd := THashMD5.GetHashString(trim(edtPwd.text));
         if pwd = TExamServerGlobal.ServerCustomConfig.AdminPwd then
            ModalResult := mrOk
         else
            application.MessageBox('����������������룡', '��ʾ:', mb_ok);
      end;

   procedure TFormServerLock.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      begin
         CanClose := false;
         if ModalResult = mrOk then
            CanClose := true;
      end;

end.
