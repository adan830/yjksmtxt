{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\FrameWork_New\authorization\ufrmRoleManager.pas
Author:    ��ƽ�� Camel_163@163.com
DateTime:  2004-3-8 12:16:20

Purpose:  Ȩ�޹���ģ��

OverView:

History:

Todo:

----------------------------------------------------------------------------- }

unit ufrmRoleManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmAppDlgBase, ExtCtrls, StdCtrls, Buttons, ComCtrls, 
  Mask, Role, ImgList, uClasses, CheckTreeView, cxButtons, Menus, cxLookAndFeelPainters;

type
  TfrmRoleManager = class(TfrmAppDlgBase)
    pnlLeft: TPanel;
    Splitter1: TSplitter;
    pnlClient: TPanel;
    pnlLeftTop: TPanel;
    btnNewUser: TSpeedButton;
    btnAddSubUser: TSpeedButton;
    SpeedButton7: TSpeedButton;
    pnlLeftClient: TPanel;
    tlUser: TTreeView;
    pnlClientTop: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnlClientClient: TPanel;
    ImageListTree: TImageList;
    Splitter2: TSplitter;
    btnSetPassword: TButton;
    btnUpdateUser: TButton;
    tlRights: TCheckTree;
    edtLoginName: TEdit;
    edtRealName: TEdit;
    edtDesc: TMemo;
    memoModuleDesc: TMemo;
    procedure btnSetPasswordClick(Sender: TObject);
    procedure tlUserChange(Sender: TObject; Node: TTreeNode);
    procedure btnNewUserClick(Sender: TObject);
    procedure btnAddSubUserClick(Sender: TObject);
    procedure btnUpdateUserClick(Sender: TObject);
    procedure tlRightsChange(Sender: TObject; Node: TTreeNode);
    procedure edtLoginNameChange(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure tlRightsStateChange(Sender: TObject; Node: TTreeNode;
      NewState: TCheckCheckState);
  private
    FUserManager: TUserManager;
    function GetCurSelectedUser: TUsers;
    function GetCurSelectedRight: TRights;
    { Private declarations }
  protected
    procedure AssignUsersToTreeView(Users : TUsers; TreeView : TTreeView);
    procedure AssignRightsToTreeView(Rights : TRights; TreeView : TCheckTree);
  public
    { Public declarations }
    class function ManagerUser(UserManager : TUserManager) : boolean;

    property CurSelectedUser : TUsers read GetCurSelectedUser;
    property CurSelectedRight : TRights read GetCurSelectedRight;
    property UserManager : TUserManager read FUserManager write FUserManager;
  end;

  TRoleManagerBaseCommand = class(TAuthObserverCommand)
  private
    function GetOwner : TfrmRoleManager;
    function GetCurUser: TUsers;
    function GetTreeViewUser: TTreeView;
    function GetTreeViewRigths: TCheckTree;
  public
    property Owner : TfrmRoleManager read GetOwner;
    property CurSelectUser : TUsers read GetCurUser;
    property tlUser : TTreeView read GetTreeViewUser;
    property tlRights : TCheckTree read GetTreeViewRigths;
  end;

  TSetPasswordCommand = class(TRoleManagerBaseCommand)
  private
    FUser: TUsers;
    FNeedOldPassword: boolean;
  public
    function Execute(Sender : TObject) : boolean; override;

    class function FriendName : string; override;
    class function Desc : string; override;

    property User : TUsers read FUser write FUser;
    property NeedOldPassword : boolean read FNeedOldPassword write FNeedOldPassword;
  end;

  TAddUserCommand = class(TRoleManagerBaseCommand)
  private
  protected
  public
    class function FriendName : string; override;
    class function Desc : string; override;

    function Execute(Sender : TObject) : boolean; override;
  end;

  TAddSubUserCommand = class(TRoleManagerBaseCommand)
  public
    class function FriendName : string; override;
    class function Desc : string; override;

    function Execute(Sender : TObject) : boolean; override;
  end;

  TDelUserCommand = class(TRoleManagerBaseCommand)
  public
    class function FriendName : string; override;
    class function Desc : string; override;

    function ToString : string; override;

    function Execute(Sender : TObject) : boolean; override;
  end;

  TUpdateUserCommand = class(TRoleManagerBaseCommand)
  private
    FNewUserRealName: string;
    FNewUserLoginName: string;
    FNewUserDesc: string;
  public
    class function FriendName : string; override;
    class function Desc : string; override;

    function ToString : string; override;

    function Execute(Sender : TObject) : boolean; override;

    property NewUserLoginName : string read FNewUserLoginName write FNewUserLoginName;
    property NewUserRealName : string read FNewUserRealName write FNewUserRealName;
    property NewUserDesc : string read FNewUserDesc write FNewUserDesc;
  end;

implementation

uses  ufrmChangePassword;

{$R *.dfm}

{ TSetPasswordCommand }

class function TSetPasswordCommand.Desc: string;
begin
  Result := '����ſ���Ȩ�ޣ���ô�û��������������Լ������룬����رգ���ôָ���û����޷��趨�Լ�������';
end;

function TSetPasswordCommand.Execute(Sender: TObject): boolean;
var
  newPassword : string;
begin
  result := inherited Execute(Sender);

  TfrmChangePassword.ChangePassword(newPassword, NeedOldPassword, User.Password);
  User.Password := NewPassword;
end;

class function TSetPasswordCommand.FriendName: string;
begin
  Result := '������������';
end;

{ TRoleManagerBaseCommand }

function TRoleManagerBaseCommand.GetCurUser: TUsers;
begin
  Result := Owner.CurSelectedUser;
end;

function TRoleManagerBaseCommand.GetOwner: TfrmRoleManager;
begin
  result := TfrmRoleManager(FOwner);
end;

procedure TfrmRoleManager.AssignUsersToTreeView(Users: TUsers;
  TreeView: TTreeView);
  procedure ProcessNode(AUsers : TUsers; Node : TTreeNode);
  var
    I: Integer;
  begin
    Node.Text := AUsers.RealName;
    Node.Data := Pointer(AUsers);

    for I := 0 to AUsers.Count - 1 do    // Iterate
    begin
      ProcessNode(AUsers[i], TreeView.Items.AddChild(Node, ''));
    end;    // for
  end;
begin
  TreeView.Items.Clear;

  ProcessNode(Users, TreeView.Items.AddChildFirst(nil, ''));

  TreeView.FullExpand;
end;

procedure TfrmRoleManager.btnSetPasswordClick(Sender: TObject);
var
  SetPasswordCommand : TSetPasswordCommand;
begin
  SetPasswordCommand := TSetPasswordCommand.Create(self);
  try
    SetPasswordCommand.User := CurSelectedUser;
    SetPasswordCommand.NeedOldPassword := true;
    SetPasswordCommand.Execute(self);
  finally // wrap up
    SetPasswordCommand.Free;
  end;    // try/finally
end;

function TfrmRoleManager.GetCurSelectedUser: TUsers;
begin
  if tlUser.Selected <> nil then
    Result := TUsers(tlUser.Selected.Data)
  else
  begin
    raise EAppException.Create('��������ѡ��һ���û���');
  end;
end;

class function TfrmRoleManager.ManagerUser(UserManager: TUserManager) : boolean;
var
  frmRoleManager: TfrmRoleManager;
begin
  frmRoleManager := TfrmRoleManager.Create(Application);
  try
    frmRoleManager.UserManager := UserManager;

    frmRoleManager.AssignUsersToTreeView(UserManager.Users, frmRoleManager.tlUser);
    Result := frmRoleManager.ShowModal = mrOK;
  finally // wrap up
    frmRoleManager.Free;
  end;    // try/finally
end;

procedure TfrmRoleManager.tlUserChange(Sender: TObject; Node: TTreeNode);
begin
  { TODO -o��ƽ�� : �ȵð��¼�����ȡ��������������   �´�����õĸķ� }
  edtLoginName.OnChange := nil;
  edtRealName.OnChange := nil;
  edtDesc.OnChange := nil;
  try
    edtLoginName.Text := CurSelectedUser.LoginName;
    edtRealName.Text := CurSelectedUser.RealName;
    edtDesc.Text := CurSelectedUser.Desc;

    self.AssignRightsToTreeView(CurSelectedUser.Rights, self.tlRights);
  finally
    edtLoginName.OnChange := self.edtLoginNameChange;
    edtRealName.OnChange := self.edtLoginNameChange;
    edtDesc.OnChange := self.edtLoginNameChange;
  end;
end;

function TRoleManagerBaseCommand.GetTreeViewRigths: TCheckTree;
begin
  Result := Owner.tlRights;
end;

function TRoleManagerBaseCommand.GetTreeViewUser: TTreeView;
begin
  Result := Owner.tlUser;
end;

{ TAddUserCommand }

class function TAddUserCommand.Desc: string;
begin
  Result := '������һ���û�����ָ���û������û���ʵ�������û�˵�������û����롣';
end;

function TAddUserCommand.Execute(Sender: TObject): boolean;
var
  NewUser : TUsers;
begin
  inherited Execute(Sender);

  if self.CurSelectUser.Owner = nil then
    raise ECommandExecuteExeception.Create(TUserManager.CurUser, Self.ToString, '�޷��������ڵ��ͬ���ڵ㡣');
    
  NewUser := TUsers(self.CurSelectUser.Owner).AddUser('��¼��', '��ʵ����', '', '�û�˵��');
  tlUser.Selected := tlUser.Items.AddObject(tlUser.Selected, '��ʵ����', NewUser);

  Result := true;
end;

class function TAddUserCommand.FriendName: string;
begin
  Result := '����һ���û�';
end;

procedure TfrmRoleManager.btnNewUserClick(Sender: TObject);
var
  AddUserCommand : TAddUserCommand;
begin
  AddUserCommand := TAddUserCommand.Create(self);
  try
    AddUserCommand.Execute(self);
  finally // wrap up
    AddUserCommand.Free;
  end;    // try/finally
end;

{ TAddSubUserCommand }

class function TAddSubUserCommand.Desc: string;
begin
  Result := '������һ����ǰѡ���û������û�����ָ���û������û���ʵ�������û�˵�������û����롣';
end;

function TAddSubUserCommand.Execute(Sender: TObject): boolean;
var
  NewUser : TUsers;
begin
  inherited Execute(Sender);

  NewUser := self.CurSelectUser.AddUser('��¼��', '��ʵ����', '', '�û�˵��');
  tlUser.Selected := tlUser.Items.AddChildObject(tlUser.Selected, '��ʵ����', NewUser);

  Result := true;
end;

class function TAddSubUserCommand.FriendName: string;
begin
  Result := '����һ�����û�';
end;

procedure TfrmRoleManager.btnAddSubUserClick(Sender: TObject);
var
  AddSubUserCommand : TAddSubUserCommand;
begin
  AddSubUserCommand := TAddSubUserCommand.Create(self);
  try
    AddSubUserCommand.Execute(self);
  finally // wrap up
    AddSubUserCommand.Free;
  end;    // try/finally
end;

{ TDelUserCommand }

class function TDelUserCommand.Desc: string;
begin
  Result := 'ɾ����ǰѡ����û����û�ɾ����';
end;

function TDelUserCommand.Execute(Sender: TObject): boolean;
begin
  inherited Execute(Sender);

  if self.CurSelectUser.Owner = nil then
    raise ECommandExecuteExeception.Create(TUserManager.CurUser, Self.ToString, '�����ܹ�ɾ�������û��ڵ㡣');

  TUsers(CurSelectUser.Owner).DelUser(self.CurSelectUser);
  tlUser.Items.Delete(tlUser.Selected);

  Result := true;
end;

class function TDelUserCommand.FriendName: string;
begin
  Result := 'ɾ���û�';
end;

function TDelUserCommand.ToString: string;
begin
  Result := inherited ToString();

  Result := Result + #13#10 +
            '��ǰ�û���Ϣ����¼����' + CurUser.LoginName + '����ʵ������' + CurUser.RealName + '���û�˵����' + CurUser.Desc + #13#10 +
            'Ҫɾ�����û���Ϣ����¼����' + CurSelectUser.LoginName + '����ʵ������' + CurSelectUser.RealName + '���û�˵����' + CurSelectUser.Desc + #13#10;

  { TODO -o��ƽ�� : ������Լ����û���Ȩ����Ϣ������������ʵ��ɾ���û��Ļ���ȡ������ }          
end;

{ TUpdateUserCommand }

class function TUpdateUserCommand.Desc: string;
begin
  Result := '�����û���Ϣ������ſ���Ȩ�ޣ���ô�û����������������û��ĵ�¼������ʵ�������û�˵���������û�Ȩ�����á�';
end;

function TUpdateUserCommand.Execute(Sender: TObject): boolean;
var
  I: Integer;
begin
  inherited Execute(Sender);

  CurSelectUser.LoginName := NewUserLoginName;
  CurSelectUser.RealName := NewUserRealName;
  CurSelectUser.Desc := NewUserDesc;

  self.tlUser.Selected.Text := NewUserRealName;

  for I := 0 to tlRights.Items.Count - 1 do    // Iterate
  begin
    if tlRights.ItemState[i] = csUnchecked then
    begin
      TRights(tlRights.Items[i].Data).Right := okHalt;
    end
    else
    begin
      TRights(tlRights.Items[i].Data).Right := okRun;
    end;
  end;    // for

  Result := true;
end;

class function TUpdateUserCommand.FriendName: string;
begin
  Result := '�����û���Ϣ';
end;

procedure TfrmRoleManager.btnUpdateUserClick(Sender: TObject);
var
  UpdateUserCommnad : TUpdateUserCommand;
begin
  UpdateUserCommnad := TUpdateUserCommand.Create(self);
  try
    UpdateUserCommnad.NewUserLoginName := edtLoginName.Text;
    UpdateUserCommnad.NewUserRealName := edtRealName.Text;
    UpdateUserCommnad.NewUserDesc := edtDesc.Text;
    UpdateUserCommnad.Execute(self);
  finally // wrap up
    UpdateUserCommnad.Free;
  end;    // try/finally
end;

procedure TfrmRoleManager.AssignRightsToTreeView(Rights: TRights;
  TreeView: TCheckTree);
  procedure ProcessNode(ARights : TRights; Node : TTreeNode);
  var
    I: Integer;
  begin
    Node.Text := ARights.Module.FriendName;
    case ARights.Right of    //
      okRun : Node.StateIndex := Integer(csChecked);
      okHalt : Node.StateIndex := Integer(csUnChecked);
    end;    // case
    Node.Data := Pointer(ARights);

    for I := 0 to ARights.Count - 1 do    // Iterate
    begin
      ProcessNode(ARights[i], TreeView.Items.AddChild(Node, ''));
    end;    // for
  end;
begin
  try
    TreeView.Items.BeginUpdate;

    TreeView.Items.Clear;

    ProcessNode(Rights, TreeView.Items.AddChild(nil, ''));

    TreeView.FullExpand;
  finally // wrap up
    TreeView.Items.EndUpdate;
  end;    // try/finally
end;

procedure TfrmRoleManager.tlRightsChange(Sender: TObject; Node: TTreeNode);
begin
  memoModuleDesc.Text := CurSelectedRight.Module.Desc;
end;

function TfrmRoleManager.GetCurSelectedRight: TRights;
begin
  Result := nil;

  if tlRights.Selected <> nil then
    Result := TRights(tlRights.Selected.Data);
end;

function TUpdateUserCommand.ToString: string;
begin
  Result := inherited ToString();

  Result := Result + #13#10 +
            '��ǰ�û���Ϣ����¼����' + CurUser.LoginName + '����ʵ������' + CurUser.RealName + '���û�˵����' + CurUser.Desc + #13#10 +
            'Ҫ�޸ĵ��û���Ϣ����¼����' + CurSelectUser.LoginName + '����ʵ������' + CurSelectUser.RealName + '���û�˵����' + CurSelectUser.Desc + #13#10;

  { TODO -o��ƽ�� : ������Լ����û���Ȩ����Ϣ������������ʵ��ɾ���û��Ļ���ȡ������ }
end;

procedure TfrmRoleManager.edtLoginNameChange(Sender: TObject);
begin
  btnUpdateUser.Click;
end;

procedure TfrmRoleManager.SpeedButton7Click(Sender: TObject);
var
  DelUserCommnad : TDelUserCommand;
begin
  DelUserCommnad := TDelUserCommand.Create(self);
  try
    DelUserCommnad.Execute(self);
  finally // wrap up
    DelUserCommnad.Free;
  end;    // try/finally
end;

procedure TfrmRoleManager.tlRightsStateChange(Sender: TObject;
  Node: TTreeNode; NewState: TCheckCheckState);
begin
  btnUpdateUser.Click;
end;

end.
