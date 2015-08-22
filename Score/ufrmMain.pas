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
          �������
      }
  TfrmMainBaseCommand = class(TAuthObserverCommand)
  private
    function GetOwner: TfrmMain;
  public
    property Owner: TfrmMain read GetOwner;
  end;
      {
          �û���ɫ������
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
          ��������������
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
  Result := '��Ȩ��Ϊ����ϵͳ���ܵ���ڣ�������û��رձ�Ȩ�ޣ���ô�û������ܹ�ʹ���κ�ϵͳ�ṩ�Ĺ��ܡ����������ɹ�ִ�У���ô��־���û��Ѿ��ɹ���¼��Ӧ�ó����Ѿ�׼����Ϊ�û��ṩ���еķ���';
end;

function TfrmMainCommand.Execute(Sender : TObject): Boolean;
begin
  result := inherited Execute(Sender);

  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
end;

class function TfrmMainCommand.FriendName: string;
begin
  Result := '������';
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
  Result := '�����ȫ������Ȩ�ޣ���ô�û�������Խ����û���ɫȨ�޵����á�ɾ���������û���ɫ�����û���ɫ�������·���Ȳ���'
end;

function TRoleManagerCommand.Execute(Sender : TObject): Boolean;
begin
  inherited Execute(Sender);
  begin
    UserManager := TUserManager.Create;
    try
      if not FileExists(TAppUtils.AppPath + GlobalUserDatFileName) then
      begin
        raise ECommandExecuteExeception.Create(self.CurUser, Self.ToString, '�Ҳ��������û���Ϣ�ļ���');
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
  Result := '�û���ɫ����';
end;

end.
