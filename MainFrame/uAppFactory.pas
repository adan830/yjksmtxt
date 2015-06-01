{ -----------------------------------------------------------------------------
Unit Name: G:\CurProjects\zs\\Source\uAppFactory.pas
Author:     贾平
DateTime:  2004-11-15 1:34:22

Purpose:   应用程序工厂对象，呵呵

OverView:   让一个程序，从在用户机器上只有一个可执行文件，到建立整套
            可以正确运行的支持环境的类

            本类的存在，可以有效的减少程序主单元的代码，保持清洁

History:

Todo:

----------------------------------------------------------------------------- }
unit uAppFactory;


interface
uses
  windows, classes, SysUtils, forms, dialogs, ADODB, DB, ufrmWelcome;

type
  TAppFactory = class
  private
    FInfo: string;
    procedure SetInfo(const Value: string);
  protected
        //欢迎封面
    frmWelcome: TfrmWelcome;
    
        //显示启封面
    procedure SetStartupInformation(Info : string);
        //设置启动封面的当前进程信息
    procedure SetStartupProcess(Process : integer);

        //模板子方法
    function ShowWelcome : boolean; virtual;
    function CreateMainForm : boolean; virtual;
    function SetApplicationSetting : boolean; virtual;

    property Info : string read FInfo write SetInfo;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function Factory : boolean; virtual;
  end;

implementation

uses
   uException;

{ TAppFactory }
function TAppFactory.Factory: boolean;
begin
  result := false;
  if not SetApplicationSetting then exit;

 // if not ShowWelcome then exit;
  if not CreateMainForm then exit;
  result := true;
end;

procedure TAppFactory.SetInfo(const Value: string);
begin
  FInfo := Value;

  self.SetStartupInformation(value);
end;

procedure TAppFactory.SetStartupInformation(Info: string);
begin
  frmWelcome.Info := Info;
end;

procedure TAppFactory.SetStartupProcess(Process: integer);
begin
  raise Exception.Create('不支持这种操作！');
end;

function TAppFactory.CreateMainForm : boolean;
begin
  //Application.CreateForm(InstanceClass, Reference);
  result := true;
end;

function TAppFactory.ShowWelcome : boolean;
begin
  frmWelcome.Info := '正在启动';
  result := true;
end;

constructor TAppFactory.Create;
begin
 // frmWelcome := TfrmWelcome.Create(nil);
 // frmWelcome.Show;
end;

destructor TAppFactory.Destroy;
begin
  frmWelcome.Free;

  inherited;
end;

function TAppFactory.SetApplicationSetting: boolean;
begin
  Application.Title := '一级Windows考试命题系统';
  Result := true;
end;

end.
