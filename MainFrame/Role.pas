{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\framework\\Role.pas
Author:     ��ƽ
DateTime:  2004-11-21 14:42:46

Purpose:
        ����Ԫ��ͨ��һ��ͳһ�ķ�ʽ������û������û�Ȩ�޹���������־
        Ϊ���ܹ������û�ʹ�õ����׶ȣ�����Ҳ�������û���ɫ�ĸ���

        ������ԪҪ�ܹ������׵�ʹ�õ����е�DELPHIϵͳ�У�����������ϵͳ��
        ���

        �������벻ʹ���κε����ݿ�ϵͳ����ά�����þ���������С

        �������ܹ���Ӧ�Ժ�ı仯���ṩ�����ܶ����չ�ֶ�

        �û�(����Ա)ʹ�ü�

OverView:

History:

Todo:
        һ��Ϊ����������ԣ�uPattern�еĺϳ�ģʽ��ʵ�ֳ���һ��ʵ�ַ���������Ҷ
        �ڵ�����֦�ڵ㹦�����ֿ���

Note:
        һ����Ϊ��uPattern�У��ϳ�ģʽ��ʵ�ֶ�����Ҷ�ڵ��������ڵ㶼��һ��������
        ������Щ�ط����ܻῴ��������TUsers��������һ��ʹ����������֯���û�������
        ��TUserManager�У��ֻῴ��CurUser : TUsers����Ҳ����˵��һ��TUsersҲ����
        ������һ���û���������һ��

        ����Ϊ���ܹ���Modulesģ����RightsȨ�޶�����չ������ʹ�����������������
        ������������һ��ϵͳ�У�Modules��Ӧ����ȫװ�ز�������֮��Modules���Ѿ�
        ȷ�����������Ҳ�����ģ�����Rightsȴ��ͬ���������û������ö��ҸĶ�������
        ����Ҳ���԰�TModules��������״̬���󣬶�TRights��ΪTModules��״̬����
        ����

implementation:
        һ��ע�᣺
            // 2004-2-28 11:27:59 ����ISelfdescription�ӿڣ���Ҫ��Ϊ������־����
            ģ���ܹ���ȡ��Ҫ����Ϣ��
            // 2004-3-1 9:18:55 ��TAuthObserverCommand�м��������෽��FriendName
            ��Desc��������ע�����ݽ��м򻯣�ע�����ݼ���ΪFatherProcessCommand��
            ProcessCommand

            Ӧ����һ��ע����ƣ���ϵͳ֪���������ģ������Щ����Ҫ���뵽�û�Ȩ��
            ������Щ������ʾ���û���������ʲô��

            ��������Ҫ��һ��ԭ�����û��ڽ���Ȩ����Ƶ�ʱ�����Ǹ�Ȩ����ص�
            ģ�������û����������Ȼ�����Ӳ�����ʵ�������ԣ�����ֻ�ܹ�����
            initialization��class function

            ���ʹ��DELPHIģ��JAVA������C#���ڲ��࣬��ô�������ô�������ַ�ʽ
            ֵ���𣿻�������û�и��õķ����أ�

            ÿһ��ģ�鶼�����û�&Ȩ�޹����ߣ������ģ���ʲô���֣���ʾ���û���
            �ֽ�ʲô���֣�����ģ�����������һ����

            �ڲ��Ὠ����������һ���ײ���֯��
            AAAAӦ�ó���            TXXXXAppStartupCommand
              XXX1ģ��                TXXX1ModuleCommand
              XXX2ģ��                TXXX2ModuleCommand
                YYY1����                TYYY1Command
                YYY2����                TYYY2Command
                YYY3����                TYYY3Command
              XXX3ģ��                TXXX3ModuleCommand

            ����Ľײ���֯����α���ɴ����أ�AAAAӦ�ó���һ��������Ӧ�ó������
            ����֮ǰ��������������Ϊ����Ӧ�õ���㣬��ôXXX1..XXX3һ��������
            ģ���б���������Ϊ���ݡ����ѹ����Լ������ԭ����ģ��ֻ֪���Լ���
            XXX1..XXXN��Щ��ģ�飬����֪����XXX2���滹�и������ģ�飬����XXX1
            ..XXXNһ��������ģ���н��д���������Ҳֻ�ᴴ������һ�㣬���һ�Ҫ�ܹ�
            ��ȷ���ҵ��Լ��ĸ���AAAAӦ�ó���

            ע���Լ���ģ��ܼ򵥣�������ȷ���ҵ��Լ��ĸ�����ôʵ������أ�
            ��������ķ�����Ȼ���ٿ��ǣ���ע��һ��ģ���ʱ��ע�᷽��Ҫ������
            �����Ѻ���ʾ����ͨ������������ҵ����ף����Ҫ��һ��Ӧ��ϵͳ�в�����
            ��ͬ����ģ�������֣���Ȼ�ͻ��ڼ�����ģ��ʱ�޷��ҵ���ȷ�ĸ����
            // 2004-2-27 10:18:58 ���ģ�������Ǹ��Ĵ��������Դ����γɽײ���֯

        ���������û�
            ͨ�������У�飬������û���������
            ����ϵͳ��˵��������һ��CurUser�����CurUserҲ��ȫ�ֵģ���Modulesһ��
            ���UserҲ���ڵ�Ԫ��ʼ����ʱ�򴴽��ġ�

        ��������ִ�У�������������ע������ݶ��ᾭ��Ȩ�޹���
            ��ȻҲ���������ڵ���ʾ���(������൱��һ����¼�Ĺ��̣�ֻҪ�������
            �úã������ڸ����Ͳ���֪���ǲ���Ҫ��¼��������ֻҪ֪������������û�
            ��û��Ȩ��ִ����������������һ���հ׵��û�������Ȼ�ǽ���ȥ��)


        ϵͳ���ֶ�������������ȡ����
            TUserManager ��������Ϊһ��Facade����ڣ���ô����Ҳ֪�����ϵͳ�е�
            һ�С�

            Ҫ�����û�����ô���봴��TUserManger��ʵ������ʱ������һ��Users������
            ���õģ�Users����һ����״�û��б�ʹ�ñ����󣬿���ɾ���������κ���
            ��
            Modules��һ�����˵ģ����ԣ����ǿ���ͨ��
            Modules(TModulesManager.Modules)��ȡ�����еĲ���ģ�飬����ϵͳ������
            �Ĳ���ģ��󣬾�Ҫ�Դ���Ȩ�����ˡ�


            ���ȣ����е��û���Ϣ�������ܹ�д��ĳ�������û���Ϣ�����½�һ���û���
            ɾ��һ���û�������һ���û�����Ϣ�ȵȣ����û���ص�Ȩ��Ҳ�ǿ��Ը��ĵ�
            Ȩ��Ҳ��һ����״�ṹ��һ��TRights��ʾ����ϵͳ������ģ�������ָ���û�
            ��Ȩ�ޣ����TRights�������Ҫ�ܹ�д��ĳ�����ģ�����TModules�Ͳ�ͬ��
            TModules����ϵͳ��صģ���Ӧ�ó����ʼ����ɺ󣬾��Ѿ�ȷ���ˣ�����
            ����Ӧ��ϵͳ�Ĳ�ͬ��TModulesҲ�᲻ͬ�����TModules���ᱻ��������Ϊ��
            ����ϵͳ�����ģ��������һ�����⣬TRights�е�һ��Rights������һ��ģ��
            ����������TModules�ǿ��ܻ���ĵ�(���統һ��Ӧ��ϵͳʹ���˲��������
            ������Ҳ��Ҫʹ��Ȩ�޹���ģ���ôTModules������ϵͳ��ȫ��ʼ��֮��
            ���Ѿ��̶���)��TModules�ĸ����ǲ��ܹ�����TRights�����ݵģ�����TRights
            ʹ��Modules��FriendName��������TModules


----------------------------------------------------------------------------- }

unit Role;

interface

uses
  Classes, SysUtils, uClasses, uPattern;

type
  ERoleException = class;
  TAuthObserverCommand = class;
  TBaseModules = class;
  TModules = class;
  TModuleManager = class;
  TUserManager = class;
  TUsers = class;
  TRights = class;


  ERoleException = class(EAppException)
  private
    FUser: TUsers;
  public
    constructor Create(AUser : TUsers; Msg : string);
    property User: TUsers read FUser write FUser;
  end;
  
  ECommandExecuteExeception = class(ERoleException)
  private
    FDesc: string;
  public
    constructor Create(AUser : TUsers; ADesc, Msg : string);
    property Desc: string read FDesc;
  end;
  
    {
        ��ɫ������
    }
  TRoleManager = class(TNodes)
  end;
  
    {
        ��ɫ����
    }
  TRole = class(TObject)
  end;
  
    {
        ����ӿ�
    }
  ICommand = interface(IRTTIInterface)
    function Execute(Sender : TObject): Boolean;
  end;
  
    {
        ���DELPHI֧���ڲ��࣬��ô������Ʒ�ʽ���ܹ����õı�ʵ��
    }
  IAuthCommand = interface(ICommand)
    function Authorization: Boolean;
  end;
  
  TAuthCommandClass = class of TAuthObserverCommand;

  TAuthObserverCommand = class(TSubject, IAuthCommand, ISelfDescription)
  private
    function GetCurUser: TUsers;
  protected
    FOwner: TObject;
    function AddLogListener: Boolean; virtual;
  public
    constructor Create(AOwner: TObject); virtual;
    destructor Destroy; override;
    function Authorization: Boolean; virtual;
    class function Desc: string; virtual;
    function Execute(Sender : TObject): Boolean; virtual;
    class function FriendName: string; virtual;
    function ToString: string; virtual;
    property CurUser: TUsers read GetCurUser;
  end;
  
    {
        ģ�������
    }
  TModuleManager = class(TObject)
  public
    class function Modules: TModules;
    class function RegistModule(FatherProcesser, Processer :
            TAuthCommandClass): TModules;
  end;
  
  TBaseModules = class(TNodes)
  private
    FProcessCommandClass: TAuthCommandClass;
    function GetDesc: string;
    function GetFriendName: string;
    function GetModulesByIndex(Index : integer): TBaseModules;
  protected
    function CreateNode: TNodes; override;
  public
    function FindModuleByFriendName(aFriendName : string): TBaseModules;
    function FindModuleByProcessCommandClass(aProcessCommandClass :
            TAuthCommandClass): TBaseModules;
    property Desc: string read GetDesc;
    property FriendName: string read GetFriendName;
    property Modules[Index : integer]: TBaseModules read GetModulesByIndex;
            default;
    property ProcessCommandClass: TAuthCommandClass read FProcessCommandClass
            write FProcessCommandClass;
  end;
  
  TModules = class(TBaseModules)
  end;
  
    //һ������(����ģ��)���ܵĲ������ͣ�����ֻ�����������������ж�
  TOperationKind = ( okHalt,okRun);
    {
        Ȩ�޶���
        TModules ��ʵ��һ����״̬���󣬶�TRight����ΪTModules����״̬�ģ�
        ���ﱣ���״̬��ʱֻ��Ȩ�޵����ã�ͨ�����ı��࣬���Ա�������״̬
    }
  TRights = class(TNodes)
  private
    FModule: TBaseModules;
    FRight: TOperationKind;
    function GetRightsByIndex(Index : integer): TRights;
  protected
    function CreateNode: TNodes; override;
  public
    function AssignTo(DestRights : TRights): Boolean;
    class function CreateRightsFromModules(aModules : TBaseModules): TRights;
    function FindRightByModuleFriendName(FriendName : string): TRights;
    function FindRightByProcessCommandClass(aProcessCommandClass :
            TAuthCommandClass): TRights;
    class procedure SetAllRight(Rights : TRights; aRight : TOperationKind);
    property Module: TBaseModules read FModule write FModule;
    property Right: TOperationKind read FRight write FRight;
    property Rights[Index : integer]: TRights read GetRightsByIndex; default;
  end;
  
  EUserLoginException = class(ERoleException)
  private
    FLoginName: string;
    FPassword: string;
  public
    constructor Create(User : TUsers; LoginName, Password, Msg : string);
    property LoginName: string read FLoginName;
    property Password: string read FPassword;
  end;
  
      {
          TUserManager�е�N��Class FunctionҲ�ǻ����ڴ������һ������µĿ��ǣ�
          TUserManagerһ��������ǲ��ô����ģ���Ϊ�û�����ֻ�����û������û���
          ʱ��Ż������Ĵ��������ǡ���ǰ�û���CurUserȴ��������ϵͳ�д��ڵģ�����
          �������Class function������Ҳ���һ��FUser����

          ��ΪLogin����Ҫ��ȡ���е��û���Ϣ(�ҳ�LoginName��ָʾ���û�)����������
          û��д��class function

          �����CurUserֻ��ָʾ��ǰ���û���Ϣ����ǰ�û���Ȩ�ޣ��������������ݶ�
          ��ʹ������˵����Ӧ����ֻ���ģ����Ҫ�����û���Ϣ����ô����ʹ��TUserManager
          ��ͳһ�����������CurUser��һ�иĶ�ֻ���ڵ�ǰ�Ự���ã������ᱻ����

          ����Ҳ���Կ�����һ��Facade�࣬�����û���Ȩ�޶�����ʹ�ñ�����Ϊ�����
      }
  TUserManager = class(TObject)
  private
    FUsers: TUsers;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function CloneUser(SrcUser : TUsers): TUsers;
    class function CurUser: TUsers;
    class function HasCurUser: Boolean;
    function LoadFromFile(FileName : string): Boolean;
    function LoadFromStream(Strm : TStream): Boolean;
    function Login(LoginName : string; Password : string): Boolean;
    class function Logout(LoginName : string): Boolean;
    function SaveToFile(FileName : string): Boolean;
    function SaveToStream(Strm : TStream): Boolean;
    property Users: TUsers read FUsers write FUsers;
  end;
  
  TUsers = class(TNodes)
  private
    FDesc: string;
    FLoginName: string;
    FPassword: string;
    FRealName: string;
    FRights: TRights;
    function GetUsersByIndex(Index : integer): TUsers;
  protected
    function CreateNode: TNodes; override;
    procedure DoLoadFromStream(Strm : TStream); override;
    procedure DoSaveToStream(Strm : TStream); override;
    procedure LoadDescFromStream(Strm : TStream);
    procedure LoadLoginNameFromStream(Strm : TStream);
    procedure LoadPasswordFromStream(Strm : TStream);
    procedure LoadRealNameFromStream(Strm : TStream);
    procedure LoadRightsFromStream(Strm : TStream);
    procedure SaveDescToStream(Strm : TStream);
    procedure SaveLoginNameToStream(Strm : TStream);
    procedure SavePasswordToStream(Strm : TStream);
    procedure SaveRealNameToStream(Strm : TStream);
    procedure SaveRightsToStream(Strm : TStream);
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddUser(LoginName, RealName, Password, Desc : string): TUsers;
            overload;
    function AddUser(LoginName, RealName, Password, Desc : string; Rights :
            TRights): TUsers; overload;
    procedure DelUser(Index : integer); overload;
    procedure DelUser(AUser : TUsers); overload;
    function FindUserByLoginName(LoginName : string): TUsers;
    property Desc: string read FDesc write FDesc;
    property LoginName: string read FLoginName write FLoginName;
    property Password: string read FPassword write FPassword;
    property RealName: string read FRealName write FRealName;
    property Rights: TRights read FRights;
    property Users[Index : integer]: TUsers read GetUsersByIndex; default;
  end;
  

implementation

uses streamio, Commons,windows;

var
  FGlobalModules : TModules;
  FGlobalUser : TUsers;


{ TModuleManager }

{
******************************** TModuleManager ********************************
}
class function TModuleManager.Modules: TModules;
begin
  result := FGlobalModules;
end;

class function TModuleManager.RegistModule(FatherProcesser, Processer :
        TAuthCommandClass): TModules;
var
  FatherModule: TModules;
begin
  if not Assigned(FGlobalModules) then
  begin
    FGlobalModules := TModules.Create;
  end;
  
  if not Assigned(FatherProcesser) then
  begin
    Modules.ProcessCommandClass := Processer;
    Result := Modules;
  end
  else
  begin
    FatherModule := TModules(Modules.FindModuleByProcessCommandClass(FatherProcesser));
    if not Assigned(FatherModule) then
      FatherModule := Modules;
  
    result := TModules(FatherModule.AddNode);
    result.ProcessCommandClass := Processer;
  end;
end;

{ TAuthObserverCommand }

{
***************************** TAuthObserverCommand *****************************
}
constructor TAuthObserverCommand.Create(AOwner: TObject);
begin
  inherited Create;
  
  FOwner := AOwner;
  
  self.AddLogListener;
end;

destructor TAuthObserverCommand.Destroy;
begin
  
  inherited;
end;

function TAuthObserverCommand.AddLogListener: Boolean;
begin
  //no log
  //self.AddListener(TLogManager.LogManager);
  Result := true;
end;

function TAuthObserverCommand.Authorization: Boolean;
begin
  if not TUserManager.HasCurUser then raise ECommandExecuteExeception.Create(nil, Self.ToString, '����������û�е�¼��ϵͳ�޷��ҵ���ǰ�û�����������ִ�б�������');
  
  result := CurUser.Rights.FindRightByProcessCommandClass(TAuthCommandClass(self.ClassType)).Right = okRun;
end;

class function TAuthObserverCommand.Desc: string;
begin
  Result := self.ClassName;
end;

function TAuthObserverCommand.Execute(Sender : TObject): Boolean;
begin
  if not Authorization then
  begin
    raise ECommandExecuteExeception.Create(self.CurUser, Self.ToString, '��û��Ȩ��ִ�б���������������ϵͳ����Ա��ϵ�����ĵ�¼��Ϊ��' + CurUser.LoginName + '����ʵ������' + CurUser.RealName);
  end;
  
    //֪ͨ���й۲��� TSubject
  Notify;

  result := true;
end;

class function TAuthObserverCommand.FriendName: string;
begin
  Result := self.ClassName;
end;

function TAuthObserverCommand.GetCurUser: TUsers;
begin
  result := TUserManager.CurUser;
end;

function TAuthObserverCommand.ToString: string;
begin
  Result := '�����Ѻ�����' + FriendName + '������˵����' + Desc;
end;

{ TUserManager }

{
********************************* TUserManager *********************************
}
constructor TUserManager.Create;
begin
  inherited;
  FUsers := TUsers.Create;
end;

destructor TUserManager.Destroy;
begin
  FUsers.Free;
  inherited;
end;

class function TUserManager.CloneUser(SrcUser : TUsers): TUsers;
  
  procedure ProcessNode(aSrcUser, DestUser : TUsers);
  var
    I: Integer;
  begin
    DestUser.LoginName := aSrcUser.LoginName;
    DestUser.RealName := aSrcUser.RealName;
    DestUser.Password := aSrcUser.Password;
    DestUser.Desc := aSrcUser.Desc;
    aSrcUser.Rights.AssignTo(DestUser.Rights);
  
    for I := 0 to aSrcUser.Count - 1 do    // Iterate
    begin
      ProcessNode(aSrcUser[i], TUsers(DestUser.AddNode));
    end;    // for
  end;
  
begin
  result := TUsers.Create;
  try
    ProcessNode(SrcUser, result);
  except
    result.Free;
    raise ERoleException.Create(TUserManager.CurUser, '�޷���ȫ�����û���' + SrcUser.LoginName);
  end;    // try/except
end;

class function TUserManager.CurUser: TUsers;
begin
  result := FGlobalUser;
end;

class function TUserManager.HasCurUser: Boolean;
var
  tmpUser: TUsers;
begin
  tmpUser := self.CurUser;
  result := Assigned(tmpUser);
end;

function TUserManager.LoadFromFile(FileName : string): Boolean;
begin
  result := Users.LoadFromFile(FileName);
end;

function TUserManager.LoadFromStream(Strm : TStream): Boolean;
begin
  result := Users.LoadFromStream(Strm);
end;

function TUserManager.Login(LoginName : string; Password : string): Boolean;
var
  tmpUser: TUsers;
begin
  result := false;
  
  if HasCurUser then
    raise EUserLoginException.Create(CurUser, LoginName, Password, '�ڽ����µ��û���¼֮ǰ��������ע����ǰ�û�!');
  
  tmpUser := Users.FindUserByLoginName(LoginName);
  if Assigned(tmpUser) then
  begin
    if tmpUser.Password = Password then
    begin
      FGlobalUser := self.CloneUser(tmpUser);
      result := true;
    end;
  end;
  
  if (not Assigned(tmpUser)) or (not Assigned(FGlobalUser)) then
  begin
    raise EUserLoginException.Create(nil, LoginName, Password, '����������û�������ϵͳ�޷�������¼��');
  end;
end;

class function TUserManager.Logout(LoginName : string): Boolean;
begin
  if not HasCurUser then
    raise EUserLoginException.Create(CurUser, LoginName, '', '��ע���������˳���¼֮ǰ��������Ҫ�ȵ�¼��ϵͳ��')
  else
  begin
    FGlobalUser.Free;
    FGlobalUser := nil;
    result := true;
  end;
end;

function TUserManager.SaveToFile(FileName : string): Boolean;
begin
  result := Users.SaveToFile(FileName);
end;

function TUserManager.SaveToStream(Strm : TStream): Boolean;
begin
  result := Users.SaveToStream(Strm);
end;

{ TModules }

{
********************************* TBaseModules *********************************
}
function TBaseModules.CreateNode: TNodes;
begin
  result := TBaseModules.Create;
end;


function TBaseModules.FindModuleByFriendName(aFriendName : string):
        TBaseModules;
var
  theResult: TBaseModules;
  
  procedure ProcessNode(mm : TBaseModules);
  var
    I: Integer;
  begin
    if Uppercase(mm.FriendName) = Uppercase(aFriendName) then
      theResult := mm;
  
    for I := 0 to mm.Count - 1 do    // Iterate
    begin
      ProcessNode(mm[i]);
    end;    // for
  end;
  
begin
  ProcessNode(self);
  result := theResult;
end;

function TBaseModules.FindModuleByProcessCommandClass(aProcessCommandClass :
        TAuthCommandClass): TBaseModules;
var
  theResult: TBaseModules;
  Found: Boolean;
  
  procedure ProcessNode(mm : TBaseModules);
  var
    I: Integer;
  begin
    if Found then
      exit;
  
    if mm.ProcessCommandClass = aProcessCommandClass then
    begin
      theResult := mm;
      Found := true;
    end;
  
    for I := 0 to mm.Count - 1 do    // Iterate
    begin
      ProcessNode(TBaseModules(mm[i]));
    end;    // for
  end;
  
begin
  Found := false;
  ProcessNode(self);
  result := theResult;
end;

function TBaseModules.GetDesc: string;
begin
  Result := self.ProcessCommandClass.Desc;
end;

function TBaseModules.GetFriendName: string;
begin
  Result := self.ProcessCommandClass.FriendName;
end;

function TBaseModules.GetModulesByIndex(Index : integer): TBaseModules;
begin
  result := TBaseModules(Nodes[Index]);
end;

{ TUsers }

{
************************************ TUsers ************************************
}
constructor TUsers.Create;
begin
  inherited;
  FRights := TRights.CreateRightsFromModules(TModuleManager.Modules);
end;

destructor TUsers.Destroy;
begin
  FRights.Free;
  inherited;
end;

function TUsers.AddUser(LoginName, RealName, Password, Desc : string): TUsers;
var
  aRights: TRights;
begin
  result := TUsers(self.AddNode);
  result.LoginName := LoginName;
  result.RealName := RealName;
  result.Password := Password;
  result.Desc := Desc;
end;

function TUsers.AddUser(LoginName, RealName, Password, Desc : string; Rights :
        TRights): TUsers;
begin
  Result := AddUser(LoginName, RealName, Password, Desc);
  if Assigned(Result.FRights) then
    Result.FRights.Free;
  
  result.FRights := Rights;
end;

function TUsers.CreateNode: TNodes;
begin
  result := TUsers.Create;
end;

procedure TUsers.DelUser(Index : integer);
begin
  self.DelNode(Index);
end;

procedure TUsers.DelUser(AUser : TUsers);
begin
  self.DelNode(AUser);
end;

procedure TUsers.DoLoadFromStream(Strm : TStream);
begin
  inherited;
  
  self.LoadLoginNameFromStream(Strm);
  self.LoadRealNameFromStream(Strm);
  self.LoadPasswordFromStream(Strm);
  self.LoadDescFromStream(Strm);
  self.LoadRightsFromStream(Strm);
end;

procedure TUsers.DoSaveToStream(Strm : TStream);
begin
  inherited;
  
  self.SaveLoginNameToStream(Strm);
  self.SaveRealNameToStream(Strm);
  self.SavePasswordToStream(Strm);
  self.SaveDescToStream(Strm);
  self.SaveRightsToStream(Strm);
end;

function TUsers.FindUserByLoginName(LoginName : string): TUsers;
var
  theResult: TUsers;
  Found: Boolean;
  
  procedure ProcessNode(us : TUsers);
  var
    I: Integer;
  begin
    if Found then
      exit;
  
    if Uppercase(us.LoginName) = Uppercase(LoginName) then
    begin
      theResult := us;
      Found := true;
      exit;
    end;
  
    for I := 0 to us.Count - 1 do    // Iterate
    begin
      ProcessNode(us[i]);
    end;    // for
  end;
  
begin
  Found := false;
  ProcessNode(self);
  result := theResult;
end;

function TUsers.GetUsersByIndex(Index : integer): TUsers;
begin
  result := TUsers(Nodes[Index]);
end;

procedure TUsers.LoadDescFromStream(Strm : TStream);
var
  I: Integer;
begin
  self.Desc := TStreamIO.StringFromStream(Strm);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].LoadDescFromStream(Strm);
  end;    // for
end;

procedure TUsers.LoadLoginNameFromStream(Strm : TStream);
var
  I: Integer;
begin
  self.LoginName := TStreamIO.StringFromStream(Strm);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].LoadLoginNameFromStream(Strm);
  end;    // for
end;

procedure TUsers.LoadPasswordFromStream(Strm : TStream);
var
  I: Integer;
  pwd:string;
begin
  pwd:= TStreamIO.StringFromStream(Strm);
  self.Password:=DecryptStr(pwd);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].LoadPasswordFromStream(Strm);
  end;    // for
end;

procedure TUsers.LoadRealNameFromStream(Strm : TStream);
var
  I: Integer;
begin
  self.RealName := TStreamIO.StringFromStream(Strm);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].LoadRealNameFromStream(Strm);
  end;    // for
end;

procedure TUsers.LoadRightsFromStream(Strm : TStream);
  
    procedure LoadARight(ARight : TRights);
    var
      I: Integer;
      AllCount : integer;
      Right : TOperationKind;
      FriendName : string;
      RootRights : TRights;
    begin
      {����Ĵ�����Ҫ�ǶԹ���ģ�鶯̬�����Ŀ��ǣ�����Ӧ�ó���ʹ�ò��ϵͳ����������
      �Ĳ��Ҳ����Ҫ����Ȩ�޹���ģ������µĲ���������ǵ�ϵͳ��Rights��BaseModule
      ��νṹ���иı�����������Ĳ�νṹд�����Ļ����ͻ����Rights��BaseModule��
      ƥ�������}
      RootRights := TRights(ARight.GetRootNode);
      AllCount := TStreamIO.IntFromStream(Strm);
      for I := 0 to AllCount - 1 do    // Iterate
      begin
        FriendName := TStreamIO.StringFromStream(Strm);
        Right := TOperationKind(TStreamIO.IntFromStream(Strm));
        if RootRights.FindRightByModuleFriendName(FriendName) <> nil then
        begin
          RootRights.FindRightByModuleFriendName(FriendName).Right := Right;
        end;
      end;    // for
    end;
  var
    I: Integer;
  
begin
  LoadARight(self.Rights);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].LoadRightsFromStream(Strm);
  end;    // for
end;

procedure TUsers.SaveDescToStream(Strm : TStream);
var
  I: Integer;
begin
  TStreamIO.StringToStream(Strm, self.Desc);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].SaveDescToStream(Strm);
  end;    // for
end;

procedure TUsers.SaveLoginNameToStream(Strm : TStream);
var
  i: Integer;
begin
  TStreamIO.StringToStream(Strm, self.LoginName);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].SaveLoginNameToStream(Strm);
  end;    // for
end;

procedure TUsers.SavePasswordToStream(Strm : TStream);
var
  i: Integer;
  pwd:string;
begin
  pwd:= EncryptStr(self.Password); //mo by jp

  TStreamIO.StringToStream(Strm, pwd);      //modify  j p
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].SavePasswordToStream(Strm);
  end;    // for
end;

procedure TUsers.SaveRealNameToStream(Strm : TStream);
var
  i: Integer;
begin
  TStreamIO.StringToStream(Strm, self.RealName);
  for I := 0 to Count - 1 do    // Iterate
  begin
    Users[i].SaveRealNameToStream(Strm);
  end;    // for
end;

procedure TUsers.SaveRightsToStream(Strm : TStream);
  
    procedure SaveARight(ARight : TRights);
      procedure ProcessNodes(ARights : TRights);
      var
        I: Integer;
      begin
        TStreamIO.StringToStream(Strm, ARights.Module.FriendName);
        TStreamIO.IntToStream(Strm, Integer(ARights.Right));
        for I := 0 to ARights.Count - 1 do    // Iterate
        begin
          ProcessNodes(ARights[i]);
        end;    // for
      end;
    begin
      {������ж��ٸ�Rights��㣬Ȼ����Щ����Ա�ƽ�Ľṹд����}
      TStreamIO.IntToStream(Strm, ARight.GetAllChildrenCount);
  
      ProcessNodes(ARight);
    end;
  var
    I: Integer;
  
begin
  SaveARight(Self.Rights);
  for I := 0 to self.Count - 1 do    // Iterate
  begin
    Users[i].SaveRightsToStream(Strm);
  end;    // for
end;

{ EUserLoginException }

{
***************************** EUserLoginException ******************************
}
constructor EUserLoginException.Create(User : TUsers; LoginName, Password, Msg
        : string);
begin
  inherited Create(User, Msg);
  
  FLoginName := LoginName;
  FPassword := Password;
end;

{ TRights }

{
*********************************** TRights ************************************
}
function TRights.AssignTo(DestRights : TRights): Boolean;
  
  procedure ProcessNode(aDestRights, SrcRights : TRights);
  var
    I: Integer;
  begin
    aDestRights.Right := SrcRights.Right;
    aDestRights.Module := SrcRights.Module;
    for I := 0 to aDestRights.Count - 1 do    // Iterate
    begin
      ProcessNode(aDestRights[i], SrcRights[i]);
    end;    // for
  end;
  
begin
  processNode(DestRights, self);
  result := true;
end;

function TRights.CreateNode: TNodes;
begin
  result := TRights.Create;
end;

class function TRights.CreateRightsFromModules(aModules : TBaseModules):
        TRights;
  
    procedure ProcessNode(aModule : TBaseModules; aRights : TRights);
    var
      I: Integer;
    begin
      for I := 0 to aModule.Count - 1 do    // Iterate
      begin
        with aRights.AddNode as TRights do
        begin
          Module := aModule[i];
        end;
  
        if aModule[i].HasChild then
          ProcessNode(aModule[i], aRights[i]);
      end;    // for
    end;
  var
    theResult : TRights;
  
begin
  theResult := TRights.Create;
  theResult.Module := aModules;
  ProcessNode(aModules, theResult);
  result := theResult;
end;

function TRights.FindRightByModuleFriendName(FriendName : string): TRights;
var
  theResult: TRights;
  hasFound: Boolean;
  
  procedure ProcessNode(Right : TRights);
  var
    I: Integer;
  begin
    if hasFound then
      exit;
  
    if Right.Module.FriendName = FriendName then
    begin
      theResult := Right;
      hasFound := true;
    end;
  
    for I := 0 to Right.Count - 1 do    // Iterate
    begin
      ProcessNode(Right[i]);
    end;    // for
  end;
  
begin
  hasFound := false;
  ProcessNode(self);
  result := theResult;
end;

function TRights.FindRightByProcessCommandClass(aProcessCommandClass :
        TAuthCommandClass): TRights;
var
  theResult: TRights;
  hasFound: Boolean;
  
  procedure ProcessNode(Right : TRights);
  var
    I: Integer;
  begin
    if hasFound then
      exit;
  
    if Right.Module.ProcessCommandClass = aProcessCommandClass then
    begin
      theResult := Right;
      hasFound := true;
    end;
  
    for I := 0 to Right.Count - 1 do    // Iterate
    begin
      ProcessNode(Right[i]);
    end;    // for
  end;
  
begin
  hasFound := false;
  ProcessNode(self);
  result := theResult;
end;

function TRights.GetRightsByIndex(Index : integer): TRights;
begin
  result := TRights(Nodes[Index]);
end;

class procedure TRights.SetAllRight(Rights : TRights; aRight : TOperationKind);
  
  procedure ProcessNode(aRights : TRights);
  var
    I: Integer;
  begin
    for I := 0 to aRights.Count - 1 do    // Iterate
    begin
      aRights.Rights[i].Right := aRight;
      if aRights[i].HasChild then
        ProcessNode(aRights[i]);
    end;    // for
  end;
  
begin
  Rights.Right := aRight;
  ProcessNode(Rights);
end;

{ ERoleException }

{
******************************** ERoleException ********************************
}
constructor ERoleException.Create(AUser : TUsers; Msg : string);
begin
  inherited Create(Msg);
  
  self.User := AUser;
end;

{ ECommandExecuteExeception }

{
************************** ECommandExecuteExeception ***************************
}
constructor ECommandExecuteExeception.Create(AUser : TUsers; ADesc, Msg :
        string);
begin
  inherited Create(AUser, Msg);
  
  FDesc := ADesc;
end;

initialization
  //FGlobalModules := TModules.Create;
  FGlobalModules := nil;
  FGlobalUser := nil;

finalization
  if TUserManager.HasCurUser then
    TUserManager.Logout(TUserManager.CurUser.LoginName);

  if Assigned(FGlobalModules) then
    FGlobalModules.Free;
end.
