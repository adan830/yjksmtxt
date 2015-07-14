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
      Label1 : TLabel;
      edtAddTime : TEdit;
      procedure FormShow(Sender : TObject);
      procedure btRetryClick(Sender : TObject);
      procedure btContinueClick(Sender : TObject);
      procedure btnExitClick(Sender : TObject);
      procedure btnAddTimeClick(Sender : TObject);
   private
      { Private declarations }
   public
      { Public declarations }
      UserPwd   : string;
      Time:integer;
      loginType : TloginType;
      class function ShowModelForm(out aLoginType : TloginType; out aPwd : string; out atime : Integer) : Integer;
   end;

implementation

uses examClientGlobal;

{$R *.dfm}

procedure TExamTypeForm.FormShow(Sender : TObject);
   begin
      // if directoryExists(GlobalSysConfig.ClientPath) then
      // begin
      // btContinue.enabled:=true;
      // label3.caption:='你可以继续上次中断的考试！　　'
      // end
      // else
      // begin
      // btContinue.enabled:=false;
      // label3.caption:='　　　　　　　　　　　　　　　　　　'
      // end;
      if (TExamClientGlobal.Examinee.Status = esExamEnded) then
      begin
         Label2.caption := '你已成功完成了一次考试！　　　'; // 重考
      end
      else
      begin
         Label2.caption := '                              ';
      end;
   end;

class function TExamTypeForm.ShowModelForm(out aLoginType : TloginType; out aPwd : string; out atime : Integer) : Integer;
   var
      tf : TExamTypeForm;
   begin
      tf := TExamTypeForm.Create(nil);
      try
         result     := tf.ShowModal();
         aPwd       := tf.UserPwd;
         atime      := tf.Time;
         aLoginType := tf.loginType;
      finally
         tf.Free;
      end;
   end;

procedure TExamTypeForm.btRetryClick(Sender : TObject);
   begin
      if Length(trim(edtpw.Text)) = 0 then
      begin
         Label4.caption := '请输入密码！    ';
         exit;
      end;
      loginType   := ltReExamLogin;
      UserPwd     := trim(edtpw.Text);
      time:=0;
      modalresult := mrOK; // 8
   end;

procedure TExamTypeForm.btContinueClick(Sender : TObject);
   begin
      if Length(trim(edtpw.Text)) = 0 then
      begin
         Label4.caption := '请输入密码！    ';
         exit;
      end;
      loginType   := ltContinuteEndedExam;
      UserPwd     := trim(edtpw.Text);
      Time:=0;
      modalresult := mrOK; // 1
   end;

procedure TExamTypeForm.btnAddTimeClick(Sender : TObject);
   begin
      time := integer.Parse(edtAddTime.Text);
      if not((time >= 300) and (time <= 1800)) then
      begin
         Label4.caption := '请输入正确的时间！300秒<=时间<=1800秒!    ';
         exit;
      end;

      if Length(trim(edtpw.Text)) = 0 then
      begin
         Label4.caption := '请输入密码！    ';
         exit;
      end;
      loginType := ltAddTimeExam;
      UserPwd   := trim(edtpw.Text);
      modalresult := mrOK; // 1
   end;

procedure TExamTypeForm.btnExitClick(Sender : TObject);
   begin
      modalresult := mrAbort; // 3
   end;

end.
