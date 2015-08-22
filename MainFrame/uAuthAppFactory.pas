{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\authorization\uAuthAppFactory.pas
Author:     贾平
DateTime:  2004-11-23 18:31:06

Purpose:    加入用户权限管理后的应用程序工厂

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
    FMainCommandClass : TAuthCommandClass;  //保存主程序中传递来的，启动主窗口命令类
  protected
    function CreateMainForm: Boolean; override;
    function CreateUser: Boolean;
  public
    constructor Create(userDataFileName:string;AMainCommandClass : TAuthCommandClass);
    function Factory: Boolean; override;

  end;
  
      //在用户登录后调用，在这里可以运行用户登录后的第一条命令
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
              begin //如果是第一次运行本程序，那么就创建一个超级用户给用户用
                UserManager.Users.RealName := '权限管理程序';
                User := UserManager.Users.AddUser('超级用户组', '超级用户组', '', '在本目录下的用户，都享有超级用户的特别权限');
                User.Rights.SetAllRight(User.Rights, okRun);
                user:=User.AddUser('Admin', '超级用户', 'admin', '本用户拥有系统中所有模块的所有权限，为系统中的最高级别用户');
                user.rights.setAllright(user.rights,okRun);
                User := UserManager.Users.AddUser('User', 'User', 'user', '一般用户组');

                UserManager.SaveToFile(TAppUtils.AppPath + FUserDataFileName);
              end;
        EFileNotExistException.IfFalse(FileExists(TAppUtils.AppPath + FUserDataFileName),Format(RSFileNotExist,[TAppUtils.AppPath + FUserDataFileName]));

        //        if not FileExists(TAppUtils.AppPath + FUserDataFileName) then
//        begin
////          application.MessageBox(pchar('系统文件被破坏！'),'出错啦！');
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
             raise euserloginexception.create(user,username,'','用户名不能为空');
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
          {TODO 考虑是否把超级权限直接自动生成到dat中，或提取成资源字符串}
            if (UserName ='JIAPING') and (UserPassword ='thisprogramiscreatedbyjiaping!7311') then begin
              if not FileExists(TAppUtils.AppPath + FUserDataFileName) then
              begin //如果是第一次运行本程序，那么就创建一个超级用户给用户用
                UserManager.Users.RealName := '权限管理程序';
                User := UserManager.Users.AddUser('超级用户组', '超级用户组', '', '在本目录下的用户，都享有超级用户的特别权限');
                User.Rights.SetAllRight(User.Rights, okRun);
                user:=User.AddUser('Admin', '超级用户', 'admin', '本用户拥有系统中所有模块的所有权限，为系统中的最高级别用户');
                user.rights.setAllright(user.rights,okRun);
                User := UserManager.Users.AddUser('User', 'User', 'user', '一般用户组');

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
        //application.MessageBox(pchar(e.message),'出错啦！');
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
//      Application.MessageBox('注册表失败！','注册表错误',MB_OK);
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
  Result := '如果放开本权限，那么本用户将会允许登录，如果关闭本权限，那么相关用户将无法登录。如果您的系统正在维护，不允许特定用户登录，那么可以对其关闭本权限。';
end;

function TUserLoginCommand.Execute(Sender : TObject): Boolean;
begin
{$IFNDEF NOLOGIN }
  result := inherited Execute(Sender);
{$ENDIF}
end;

class function TUserLoginCommand.FriendName: string;
begin
  Result := '用户登录';
end;

end.
