unit ExamTypeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,NetGlobal, jpeg;

type
  TExamTypeForm = class(TForm)
    btRetry: TButton;
    btContinue: TButton;
    btExit: TButton;
    edtPw: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure btRetryClick(Sender: TObject);
    procedure btContinueClick(Sender: TObject);
    procedure btExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UserPwd:string;
    loginType: TloginType

  end;

var
  ExamTypeForm: TExamTypeForm;

implementation

uses examClientGlobal;

{$R *.dfm}

procedure TExamTypeForm.FormShow(Sender: TObject);
begin
//  if directoryExists(GlobalSysConfig.ClientPath) then
//  begin
//    btContinue.enabled:=true;
//    label3.caption:='你可以继续上次中断的考试！　　'
//  end
//  else
//  begin
//    btContinue.enabled:=false;
//    label3.caption:='　　　　　　　　　　　　　　　　　　'
//  end;
  if (TExamClientGlobal.Examinee.Status=esExamEnded) then
  begin
    label2.caption:='你已成功完成了一次考试！　　　';        //重考
  end
  else
  begin
    label2.caption:='                              ';
  end;
end;

procedure TExamTypeForm.btRetryClick(Sender: TObject);
var
  pwd: string;
begin
   if Length(edtPw.Text)>0 then begin
      loginType := ltReExamLogin;
      UserPwd := edtPw.Text;
      modalresult:=8;
   end  else  begin
      label4.caption:='请输入密码！    ';
   end;
end;

procedure TExamTypeForm.btContinueClick(Sender: TObject);
var
   pwd :string;
begin
   if Length(edtPw.Text)>0 then begin
      loginType := ltContinuteEndedExam;
      UserPwd := edtPw.Text;
      modalresult:=1;
   end  else  begin
      label4.caption:='请输入密码！    ';
   end;
end;

procedure TExamTypeForm.btExitClick(Sender: TObject);
begin
    modalresult:=-3;
end;

end.
