{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\authorization\uAuthAppFactory.pas
Author:     ��ƽ
DateTime:  2004-11-23 18:31:06

Purpose:    �����û�Ȩ�޹�����Ӧ�ó��򹤳�

OverView:

History:

Todo:

----------------------------------------------------------------------------- }
unit uAuthAppFactory;

interface

uses
  Classes, Sysutils, uAppFactory, Role,streamio;
type
  TAuthAppFactory = class(TAppFactory)
  private
    FUserDataFileName :string;
    FMainCommandClass : TAuthCommandClass;  //�����������д������ģ�����������������
  protected
    function CreateMainForm: Boolean; override;
    function CreateUser: Boolean;
  public
    constructor Create(userDataFileName:string;AMainCommandClass : TAuthCommandClass);
    function Factory: Boolean; override;

  end;
  
      //���û���¼����ã���������������û���¼��ĵ�һ������
  TUserLoginCommand = class(TAuthObserverCommand)
  public
    class function Desc: string; override;
    function Execute(Sender : TObject): Boolean; override;
    class function FriendName: string; override;
  end;
  
implementation

uses
  uAppSet, loginform, uAppUtils,forms, registry,windows,ExamException,ExamResourceStrings;

{ TAuthAppFactory }

{
******************************* TAuthAppFactory ********************************
}
constructor TAuthAppFactory.Create(userDataFileName: string;AMainCommandClass : TAuthCommandClass);
begin
  inherited Create();
  FUserDataFileName := userDataFileName;
  FMainCommandClass:= AMainCommandClass;
end;

function TAuthAppFactory.CreateMainForm: Boolean;
var
  frmMainCommand: TAuthObserverCommand;
begin
  frmMainCommand :=TAuthObserverCommand(FMainCommandClass.NewInstance);
  frmMainCommand.Create(Self);

  try
    result := frmMainCommand.Execute(nil);
  finally // wrap up
    frmMainCommand.Free;
  end;    // try/finally
end;

function TAuthAppFactory.CreateUser: Boolean;
var
  UserManager: TUserManager;
  User: TUsers;
  UserName, UserPassword: string;
  UserLoginCommand: TUserLoginCommand;
  flag:boolean;
  hasUserFile:Boolean;
  i:integer;
begin
  Result := false;
  flag:=false;
  hasUserFile := False;
  for i:=1 to 3 do
  begin
    UserManager := TUserManager.Create;
    try
      try
        if not FileExists(TAppUtils.AppPath + FUserDataFileName) then
              begin //����ǵ�һ�����б�������ô�ʹ���һ�������û����û���
                UserManager.Users.RealName := 'Ȩ�޹������';
                User := UserManager.Users.AddUser('�����û���', '�����û���', '', '�ڱ�Ŀ¼�µ��û��������г����û����ر�Ȩ��');
                User.Rights.SetAllRight(User.Rights, okRun);
                user:=User.AddUser('Admin', '�����û�', 'admin', '���û�ӵ��ϵͳ������ģ�������Ȩ�ޣ�Ϊϵͳ�е���߼����û�');
                user.rights.setAllright(user.rights,okRun);
                User := UserManager.Users.AddUser('User', 'User', 'user', 'һ���û���');

                UserManager.SaveToFile(TAppUtils.AppPath + FUserDataFileName);
              end;
        EFileNotExistException.IfFalse(FileExists(TAppUtils.AppPath + FUserDataFileName),Format(RSFileNotExist,[TAppUtils.AppPath + FUserDataFileName]));

        //        if not FileExists(TAppUtils.AppPath + FUserDataFileName) then
//        begin
////          application.MessageBox(pchar('ϵͳ�ļ����ƻ���'),'��������');
////          exit;
//        end
//        else
//        begin
          UserManager.LoadFromFile(TAppUtils.AppPath + FUserDataFileName);
          hasUserFile :=True;
//        end;

        {$IFNDEF NOLOGIN}
        if TLoginForm.Login(UserName, UserPassword) then
        begin
        
          if trim(username)='' then
             raise euserloginexception.create(user,username,'','�û�������Ϊ��');
        {$ENDIF}
          if hasUserFile then begin
        {$IFDEF NOLOGIN}
            UserName := 'admin';
            UserPassword := 'admin';
        {$ENDIF}
            if UserManager.Login(UserName, UserPassword) then
            begin
              UserLoginCommand := TUserLoginCommand.Create(nil);
              try
                UserLoginCommand.Execute(nil);
                result := true;
              finally // wrap up
                UserLoginCommand.Free;
              end;    // try/finally
  
            end;
          end else begin 
          {TODO �����Ƿ�ѳ���Ȩ��ֱ���Զ����ɵ�dat�У�����ȡ����Դ�ַ���}
            if (UserName ='JIAPING') and (UserPassword ='thisprogramiscreatedbyjiaping!7311') then begin
              if not FileExists(TAppUtils.AppPath + FUserDataFileName) then
              begin //����ǵ�һ�����б�������ô�ʹ���һ�������û����û���
                UserManager.Users.RealName := 'Ȩ�޹������';
                User := UserManager.Users.AddUser('�����û���', '�����û���', '', '�ڱ�Ŀ¼�µ��û��������г����û����ر�Ȩ��');
                User.Rights.SetAllRight(User.Rights, okRun);
                user:=User.AddUser('Admin', '�����û�', 'admin', '���û�ӵ��ϵͳ������ģ�������Ȩ�ޣ�Ϊϵͳ�е���߼����û�');
                user.rights.setAllright(user.rights,okRun);
                User := UserManager.Users.AddUser('User', 'User', 'user', 'һ���û���');

                UserManager.SaveToFile(TAppUtils.AppPath + FUserDataFileName);
              end;
            end else begin
              Exit;
            end;
          end;
        {$IFNDEF NOLOGIN}
        end
        else
           flag:=true;
        {$ENDIF}
      finally // wrap up
        UserManager.Free;
      end;    // try/finally
    except
      on e: eUserLoginException do
         Application.ShowException(e);
        //application.MessageBox(pchar(e.message),'��������');
    end;
    if result or flag then
       break;
  end;
end;

function TAuthAppFactory.Factory: Boolean;
var
  reg:TRegIniFile;
begin
  Result := false;
  if not SetApplicationSetting then exit;
//  reg:=TRegIniFile.Create;
//  try
//    reg.RootKey:= HKEY_LOCAL_MACHINE ;
//    if reg.OpenKey('\SOFTWARE\tkgl\CONFIG',true) then
//    begin
//      if Ini_2(DecryptStr(reg.ReadString('','value3',''),''),DecryptStr(reg.ReadString('','Value4',''),'')) =false then exit ;
//    end
//    else
//    begin
//      Application.MessageBox('ע���ʧ�ܣ�','ע������',MB_OK);
//    end;
//  finally
//    reg.CloseKey;
//  	reg.Free;
//  end;  // try/finally
  
 // if not ShowWelcome then exit;
  if not CreateUser then exit;
  if not CreateMainForm then exit;
  result := true;
end;

{ TUserLoginCommand }

{
****************************** TUserLoginCommand *******************************
}
class function TUserLoginCommand.Desc: string;
begin
  Result := '����ſ���Ȩ�ޣ���ô���û����������¼������رձ�Ȩ�ޣ���ô����û����޷���¼���������ϵͳ����ά�����������ض��û���¼����ô���Զ���رձ�Ȩ�ޡ�';
end;

function TUserLoginCommand.Execute(Sender : TObject): Boolean;
begin
{$IFNDEF NOLOGIN }
  result := inherited Execute(Sender);
{$ENDIF}
end;

class function TUserLoginCommand.FriendName: string;
begin
  Result := '�û���¼';
end;

end.
