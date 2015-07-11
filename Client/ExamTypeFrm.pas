unit ExamTypeFrm;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,
   Dialogs, StdCtrls, ExtCtrls, NetGlobal, jpeg, CnButtons, Vcl.Controls;

type
   TExamTypeForm = class(TForm)
      Label2 : TLabel;
      Label3 : TLabel;
      btnRetry : TCnSpeedButton;
      btnContinue : TCnSpeedButton;
      btnAddTime : TCnSpeedButton;
      CnSpeedButton1 : TCnSpeedButton;
      lblID : TLabel;
      edtpw : TEdit;
      Label4 : TLabel;
      procedure FormShow(Sender : TObject);
      procedure btRetryClick(Sender : TObject);
      procedure btContinueClick(Sender : TObject);
      procedure btnExitClick(Sender : TObject);
   private
      { Private declarations }
   public
      { Public declarations }
      UserPwd   : string;
      loginType : TloginType;
      class function ShowModelForm(out aPwd : string) : integer;
   end;

implementation

uses examClientGlobal;

{$R *.dfm}

procedure TExamTypeForm.FormShow(Sender : TObject);
   begin
      // if directoryExists(GlobalSysConfig.ClientPath) then
      // begin
      // btContinue.enabled:=true;
      // label3.caption:='����Լ����ϴ��жϵĿ��ԣ�����'
      // end
      // else
      // begin
      // btContinue.enabled:=false;
      // label3.caption:='������������������������������������'
      // end;
      if (TExamClientGlobal.Examinee.Status = esExamEnded) then
      begin
         Label2.caption := '���ѳɹ������һ�ο��ԣ�������'; // �ؿ�
      end
      else
      begin
         Label2.caption := '                              ';
      end;
   end;

class function TExamTypeForm.ShowModelForm(out aPwd : string) : integer;
   var
      tf : TExamTypeForm;
   begin
      tf := TExamTypeForm.Create(nil);
      try
         result := tf.ShowModal();
         aPwd   := trim(tf.edtpw.Text);
      finally
         tf.Free;
      end;
   end;

procedure TExamTypeForm.btRetryClick(Sender : TObject);
   var
      pwd : string;
   begin
      if Length(edtpw.Text) > 0 then
      begin
         loginType   := ltReExamLogin;
         UserPwd     := edtpw.Text;
         modalresult := 8;
      end
      else
      begin
         Label4.caption := '���������룡    ';
      end;
   end;

procedure TExamTypeForm.btContinueClick(Sender : TObject);
   var
      pwd : string;
   begin
      if Length(edtpw.Text) > 0 then
      begin
         loginType   := ltContinuteEndedExam;
         UserPwd     := edtpw.Text;
         modalresult := 1;
      end
      else
      begin
         Label4.caption := '���������룡    ';
      end;
   end;

procedure TExamTypeForm.btnExitClick(Sender : TObject);
   begin
      modalresult := -3;
   end;

end.
