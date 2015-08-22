unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, dxBar, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxBarPainter, cxClasses, 
  Role;

type
  TfrmMain = class(TForm)
    dxBarManager1: TdxBarManager;
    mnConfig: TdxBarButton;
    mnReceive: TdxBarButton;
    mnStatistics: TdxBarButton;
    mnSystem: TdxBarSubItem;
    mnBrowseSource: TdxBarButton;
    mnScore: TdxBarButton;
    mnbtnEQUseInfo: TdxBarButton;
    dxBarButton1: TdxBarButton;
    mnbtnRestoreExamFolder: TdxBarButton;
    procedure mnbtnEQUseInfoClick(Sender: TObject);
    procedure mnScoreClick(Sender: TObject);
    procedure mnReceiveClick(Sender: TObject);
    procedure mnBrowseSourceClick(Sender: TObject);
    procedure mnConfigClick(Sender: TObject);
    procedure mnbtnRestoreExamFolderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

       {
          命令基类
      }
  TfrmMainBaseCommand = class(TAuthObserverCommand)
  private
    function GetOwner: TfrmMain;
  public
    property Owner: TfrmMain read GetOwner;
  end;
      {
          用户角色管理者
      }
  TRoleManagerCommand = class(TfrmMainBaseCommand)
  private
    FUserManager: TUserManager;
  public
    class function Desc: string; override;
    function Execute(Sender : TObject): Boolean; override;
    class function FriendName: string; override;
    property UserManager: TUserManager read FUserManager write FUserManager;
  end;
  {
          创建主窗口命令
      }
  TfrmMainCommand = class(TAuthObserverCommand)
  public
    class function Desc: string; override;
    function Execute(Sender : TObject): Boolean; override;
    class function FriendName: string; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses ufrmConfig, ufrmBrowseSource, ufrmScoreReceive, ufrmScore,
  ufrmReceiveEQUseInfo, udmMain, uAppUtils, ufrmRoleManager, GlobalScore, ufrmRestoreExamFolder;

{$R *.dfm}

procedure TfrmMain.mnConfigClick(Sender: TObject);
begin
  frmConfig := TfrmConfig.create(application);
  frmConfig.ShowModal;
end;

procedure TfrmMain.mnBrowseSourceClick(Sender: TObject);
begin
  frmBrowseSource := TfrmBrowseSource.Create(application);
  frmBrowseSource.ShowModal;
end;

procedure TfrmMain.mnReceiveClick(Sender: TObject);
begin
   frmScoreReceive := TfrmScoreReceive.create(application);
   frmScoreReceive.ShowModal;
end;

procedure TfrmMain.mnScoreClick(Sender: TObject);
begin
  frmScore := TfrmScore.Create(application);
  frmScore.ShowModal;
end;

procedure TfrmMain.mnbtnEQUseInfoClick(Sender: TObject);
begin
  frmReceiveEQUseInfo:=TfrmReceiveEQUseInfo.Create(nil);
  try
    frmReceiveEQUseInfo.ShowModal;
  finally
    frmReceiveEQUseInfo.Free;
  end;

end;

procedure TfrmMain.mnbtnRestoreExamFolderClick(Sender: TObject);
begin
   frmRestoreExamFolder := TfrmRestoreExamFolder.Create(application);
   frmRestoreExamFolder.ShowModal;
end;

{ TfrmMainCommand }

{
******************************* TfrmMainCommand ********************************
}
class function TfrmMainCommand.Desc: string;
begin
  Result := '开权限为所有系统功能的入口，如果对用户关闭本权限，那么用户将不能够使用任何系统提供的功能。如果本命令成功执行，那么标志着用户已经成功登录，应用程序已经准备好为用户提供所有的服务。';
end;

function TfrmMainCommand.Execute(Sender : TObject): Boolean;
begin
  result := inherited Execute(Sender);

  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
end;

class function TfrmMainCommand.FriendName: string;
begin
  Result := '主程序';
end;

{ TfrmMainBaseCommand }

function TfrmMainBaseCommand.GetOwner: TfrmMain;
begin
  result := TfrmMain(FOwner);
end;

{ TRoleManagerCommand }

{
***************************** TRoleManagerCommand ******************************
}
class function TRoleManagerCommand.Desc: string;
begin
  Result := '如果完全开启本权限，那么用户将会可以进行用户角色权限的设置、删除、增加用户角色，对用户角色进行重新分组等操作'
end;

function TRoleManagerCommand.Execute(Sender : TObject): Boolean;
begin
  inherited Execute(Sender);
  begin
    UserManager := TUserManager.Create;
    try
      if not FileExists(TAppUtils.AppPath + GlobalUserDatFileName) then
      begin
        raise ECommandExecuteExeception.Create(self.CurUser, Self.ToString, '找不到您的用户信息文件。');
      end;

      UserManager.LoadFromFile(TAppUtils.AppPath + GlobalUserDatFileName);

      if TfrmRoleManager.ManagerUser(UserManager) then
        UserManager.SaveToFile(TAppUtils.AppPath + GlobalUserDatFileName);
    finally // wrap up
      UserManager.Free;
    end;    // try/finally
  end ;
end;

class function TRoleManagerCommand.FriendName: string;
begin
  Result := '用户角色管理';
end;

end.
