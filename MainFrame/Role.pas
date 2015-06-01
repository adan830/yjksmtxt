{ -----------------------------------------------------------------------------
Unit Name: I:\Delphi Studio Projects\framework\\Role.pas
Author:     贾平
DateTime:  2004-11-21 14:42:46

Purpose:
        本单元将通过一个统一的方式，完成用户管理、用户权限管理及操作日志
        为了能够增加用户使用的容易度，这里也将引入用户角色的概念

        本管理单元要能够很容易的使用到所有的DELPHI系统中，尽量减少与系统的
        耦合

        不依靠与不使用任何的数据库系统，将维护费用尽量降到最小

        尽量的能够适应以后的变化，提供尽可能多的扩展手段

        用户(程序员)使用简单

OverView:

History:

Todo:
        一、为了清除二义性，uPattern中的合成模式再实现出另一种实现方法，让树叶
        节点与树枝节点功能区分开来

Note:
        一、因为在uPattern中，合成模式的实现对于树叶节点与树技节点都是一样，所以
        下面有些地方可能会看不懂。如TUsers，他就是一组使用树进行组织的用户，但是
        在TUserManager中，又会看到CurUser : TUsers，这也就是说，一个TUsers也可以
        当成是一个用户，而不是一组

        二、为了能够让Modules模块与Rights权限独立发展，这里使用两个类来分类进行
        描述，而且在一个系统中，Modules在应用完全装载并且运行之后，Modules就已经
        确定下来，而且不会更改，但是Rights却不同，他会随用户的设置而且改动，所以
        这里也可以把TModules看成是无状态对象，而TRights做为TModules的状态对象
        出现

implementation:
        一、注册：
            // 2004-2-28 11:27:59 加入ISelfdescription接口，主要是为了让日志管理
            模块能够读取需要的信息。
            // 2004-3-1 9:18:55 在TAuthObserverCommand中加入虚拟类方法FriendName
            与Desc方法，将注册内容进行简化，注册内容减少为FatherProcessCommand与
            ProcessCommand

            应该有一种注册机制，让系统知道，你这个模块有哪些功能要参与到用户权限
            管理，这些功能显示给用户的名字是什么？

            这里最重要的一个原因是用户在进行权限设计的时候，与那个权限相关的
            模块根本就没有启动，当然，更加不会有实例，所以，这里只能够利用
            initialization和class function

            如果使用DELPHI模拟JAVA或者是C#的内部类，那么程序会怎么样？这种方式
            值得吗？或者是有没有更好的方法呢？

            每一个模块都告诉用户&权限管理者，我这个模块叫什么名字，显示给用户的
            又叫什么名字，处理本模块请求的是哪一个类

            内部会建立起这样的一个阶层组织：
            AAAA应用程序            TXXXXAppStartupCommand
              XXX1模块                TXXX1ModuleCommand
              XXX2模块                TXXX2ModuleCommand
                YYY1命令                TYYY1Command
                YYY2命令                TYYY2Command
                YYY3命令                TYYY3Command
              XXX3模块                TXXX3ModuleCommand

            上面的阶层组织会如何被完成创建呢？AAAA应用程序一定会先于应用程序完成
            运行之前被创建，并被归为整个应用的最顶层，那么XXX1..XXX3一定会在主
            模块中被创建，因为根据“自已管理自己的事物”原则，主模块只知道自己有
            XXX1..XXXN这些子模块，并不知道在XXX2下面还有更多的子模块，所以XXX1
            ..XXXN一定是在主模块中进行创建，并且也只会创建到这一层，而且还要能够
            正确的找到自己的父：AAAA应用程序

            注册自己的模块很简单，但是正确的找到自己的父，怎么实现最简单呢？
            先用最蠢的方法，然后再考虑，在注册一个模块的时候，注册方法要求输入
            父的友好显示名，通过这个名字来找到父亲，这就要求一个应用系统中不允许
            有同名的模块名出现，不然就会在加入子模块时无法找到正确的父结点
            // 2004-2-27 10:18:58 更改，传入的是父的处理方法，以此来形成阶层组织

        二、建立用户
            通过密码的校验，来完成用户建立过程
            对于系统来说，总是有一个CurUser，这个CurUser也是全局的，和Modules一样
            这个User也是在单元初始化的时候创建的。

        三、继续执行，不过现在所有注册的内容都会经过权限管理
            当然也包括主窗口的显示与否(这里就相当于一个登录的过程，只要代码控制
            得好，主窗口根本就不用知道是不是要登录，主窗口只要知道，现在这个用户
            有没有权限执行这个方法，如果是一个空白的用户，那自然是进不去的)


        系统的手动创建，与流读取创建
            TUserManager 在这里做为一个Facade类存在，那么，他也知道这个系统中的
            一切。

            要管理用户，那么必须创建TUserManger的实例，此时，就有一个Users属性是
            可用的，Users就是一个树状用户列表，使用本对象，可以删除、增加任何用
            户
            Modules是一定有了的，所以，我们可以通过
            Modules(TModulesManager.Modules)来取得所有的操作模块，有了系统中所有
            的操作模块后，就要以创建权限组了。


            首先，所有的用户信息都必须能够写入某个流，用户信息包括新建一个用户，
            删除一个用户，更改一个用户的信息等等，与用户相关的权限也是可以更改的
            权限也是一个树状结构，一个TRights表示整个系统中所有模块相对于指定用户
            的权限，因此TRights与必须是要能够写入某个流的，但是TModules就不同，
            TModules是与系统相关的，在应用程序初始化完成后，就已经确定了，而且
            根据应用系统的不同，TModules也会不同，因此TModules不会被流化，因为他
            是由系统创建的，这里存在一个问题，TRights中的一个Rights必须与一个模块
            关联，但是TModules是可能会更改的(比如当一个应用系统使用了插件，但是
            这个插件也是要使用权限管理的，那么TModules并非是系统完全初始化之后
            就已经固定。)，TModules的更改是不能够引起TRights的内容的，这里TRights
            使用Modules的FriendName来弱关联TModules


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
        角色管理者
    }
  TRoleManager = class(TNodes)
  end;
  
    {
        角色定义
    }
  TRole = class(TObject)
  end;
  
    {
        命令接口
    }
  ICommand = interface(IRTTIInterface)
    function Execute(Sender : TObject): Boolean;
  end;
  
    {
        如果DELPHI支持内部类，那么这种设计方式便能够更好的被实现
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
        模块管理者
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
  
    //一个命令(功能模块)可能的操作类型，这里只声明两个，允许与中断
  TOperationKind = ( okHalt,okRun);
    {
        权限定义
        TModules 其实是一个无状态对象，而TRight就是为TModules保存状态的，
        这里保存的状态暂时只是权限的设置，通过更改本类，可以保存更多的状态
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
          TUserManager中的N个Class Function也是基于内存或者是一般情况下的考虑，
          TUserManager一般情况下是不用创建的，因为用户管理只会在用户管理用户的
          时候才会真正的创建，但是“当前用户”CurUser却是在整个系统中存在的，所以
          这里会用Class function，而且也会多一个FUser变量

          因为Login必须要读取所有的用户信息(找出LoginName所指示的用户)，所以这里
          没有写成class function

          这里的CurUser只是指示当前的用户信息、当前用户的权限，本对象所有内容对
          于使用者来说，都应该是只读的，如果要更改用户信息，那么必须使用TUserManager
          来统一管理，程序对于CurUser的一切改动只会在当前会话有用，都不会被保存

          本类也可以看成是一个Facade类，所有用户与权限都可以使用本类做为切入口
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
  if not TUserManager.HasCurUser then raise ECommandExecuteExeception.Create(nil, Self.ToString, '可能是您还没有登录，系统无法找到当前用户，您不可以执行本操作。');
  
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
    raise ECommandExecuteExeception.Create(self.CurUser, Self.ToString, '您没有权限执行本操作，请向您的系统管理员联系。您的登录名为：' + CurUser.LoginName + '；真实姓名：' + CurUser.RealName);
  end;
  
    //通知所有观察者 TSubject
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
  Result := '命令友好名：' + FriendName + '。命令说明：' + Desc;
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
    raise ERoleException.Create(TUserManager.CurUser, '无法完全复制用户：' + SrcUser.LoginName);
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
    raise EUserLoginException.Create(CurUser, LoginName, Password, '在进行新的用户登录之前，必须先注销当前用户!');
  
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
    raise EUserLoginException.Create(nil, LoginName, Password, '密码或者是用户名错误，系统无法让您登录。');
  end;
end;

class function TUserManager.Logout(LoginName : string): Boolean;
begin
  if not HasCurUser then
    raise EUserLoginException.Create(CurUser, LoginName, '', '在注销或者是退出登录之前，您必须要先登录到系统。')
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
      {这里的代码主要是对管理模块动态增长的考虑，比如应用程序使用插件系统，而且这里
      的插件也是需要进行权限管理的，当有新的插件进入我们的系统后，Rights与BaseModule
      层次结构都有改变如果按照树的层次结构写入流的话，就会出现Rights与BaseModule不
      匹配的现象}
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
      {先求得有多少个Rights结点，然后将这些结点以扁平的结构写入流}
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
