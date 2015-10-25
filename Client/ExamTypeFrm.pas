unit ExamTypeFrm;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms, Dialogs, StdCtrls, ExtCtrls, NetGlobal, jpeg, CnButtons, Vcl.Controls,
   customcolorForm, JvExExtCtrls, JvRadioGroup;

type
   TExamTypeForm = class(TCustomColorForm)
      Panel1: TPanel;
      btnRetry: TCnSpeedButton;
      CnSpeedButton1: TCnSpeedButton;
      edtAddTime: TEdit;
      edtpw: TEdit;
      lbltime: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      lblID: TLabel;
      rgExamType: TJvRadioGroup;
      procedure FormShow(Sender: TObject);
      procedure btRetryClick(Sender: TObject);
      procedure btContinueClick(Sender: TObject);
      procedure btnExitClick(Sender: TObject);
      procedure btnAddTimeClick(Sender: TObject);
      procedure rgExamTypeClick(Sender: TObject);
   private
    procedure ChangeStatus;
      { Private declarations }
   public
      { Public declarations }
      UserPwd: string;
      SelectIndex: integer;
      Time: integer;
      loginType: TloginType;
      class function ShowModelForm(out aLoginType: TloginType; out aPwd: string; out atime: integer): integer;
   end;

implementation

uses examClientGlobal;

{$R *.dfm}

procedure TExamTypeForm.FormShow(Sender: TObject);
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
         Label2.caption := '���ѳɹ������һ�ο��ԣ�������';
      end
   else
      begin
         Label2.caption := '                              ';
      end;
   rgExamType.ItemIndex := 1;
    ChangeStatus;
end;

procedure TExamTypeForm.rgExamTypeClick(Sender: TObject);
begin
  ChangeStatus;
end;

class function TExamTypeForm.ShowModelForm(out aLoginType: TloginType; out aPwd: string; out atime: integer): integer;
var
   tf: TExamTypeForm;
begin
   tf := TExamTypeForm.Create(nil);
   try
      result := tf.ShowModal();
      aPwd := tf.UserPwd;
      atime := tf.Time;
      aLoginType := tf.loginType;
   finally
      tf.Free;
   end;
end;

procedure TExamTypeForm.ChangeStatus;
begin
  case rgExamType.ItemIndex of
    0:
      begin
        btnRetry.caption := '�ؿ�';
        lbltime.Visible := false;
        edtAddTime.Visible := false;
      end;
    1:
      begin
        btnRetry.caption := '����';
        lbltime.Visible := false;
        edtAddTime.Visible := false;
      end;
    2:
      begin
        btnRetry.caption := '��ʱ����';
        lbltime.Visible := true;
        edtAddTime.Visible := true;
      end;
  end;
end;

procedure TExamTypeForm.btRetryClick(Sender: TObject);
begin
   if Length(trim(edtpw.Text)) = 0 then
      begin
         Label4.caption := '���������룡    ';
         exit;
      end;
   UserPwd := trim(edtpw.Text);
   Time := 0;
   modalresult := mrOK;
   case rgExamType.ItemIndex of
      0:
         begin
            loginType := ltReExamLogin;
         end;
      1:begin
            loginType := ltContinuteEndedExam;
         end;
      2:
         begin
            Time := integer.Parse(edtAddTime.Text);
            if not((Time >= 300) and (Time <= 1800)) then
               begin
                  Label4.caption := '��������ȷ��ʱ�䣡300��<=ʱ��<=1800��!    ';
                  exit;
               end;
         end;
   else
      begin
         modalresult := mrAbort;
      end;
   end;
   // if Length(trim(edtpw.Text)) = 0 then
   // begin
   // Label4.caption := '���������룡    ';
   // exit;
   // end;
   // loginType   := ltReExamLogin;
   // UserPwd     := trim(edtpw.Text);
   // time:=0;
   // modalresult := mrOK; // 8
end;

procedure TExamTypeForm.btContinueClick(Sender: TObject);
begin
   if Length(trim(edtpw.Text)) = 0 then
      begin
         Label4.caption := '���������룡    ';
         exit;
      end;
   loginType := ltContinuteEndedExam;
   UserPwd := trim(edtpw.Text);
   Time := 0;
   modalresult := mrOK; // 1
end;

procedure TExamTypeForm.btnAddTimeClick(Sender: TObject);
begin
   Time := integer.Parse(edtAddTime.Text);
   if not((Time >= 300) and (Time <= 1800)) then
      begin
         Label4.caption := '��������ȷ��ʱ�䣡300��<=ʱ��<=1800��!    ';
         exit;
      end;

   if Length(trim(edtpw.Text)) = 0 then
      begin
         Label4.caption := '���������룡    ';
         exit;
      end;
   loginType := ltAddTimeExam;
   UserPwd := trim(edtpw.Text);
   modalresult := mrOK; // 1
end;

procedure TExamTypeForm.btnExitClick(Sender: TObject);
begin
   modalresult := mrAbort; // 3
end;

end.
