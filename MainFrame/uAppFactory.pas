{ -----------------------------------------------------------------------------
Unit Name: G:\CurProjects\zs\\Source\uAppFactory.pas
Author:     ��ƽ
DateTime:  2004-11-15 1:34:22

Purpose:   Ӧ�ó��򹤳����󣬺Ǻ�

OverView:   ��һ�����򣬴����û�������ֻ��һ����ִ���ļ�������������
            ������ȷ���е�֧�ֻ�������

            ����Ĵ��ڣ�������Ч�ļ��ٳ�������Ԫ�Ĵ��룬�������

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
        //��ӭ����
    frmWelcome: TfrmWelcome;
    
        //��ʾ������
    procedure SetStartupInformation(Info : string);
        //������������ĵ�ǰ������Ϣ
    procedure SetStartupProcess(Process : integer);

        //ģ���ӷ���
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
  raise Exception.Create('��֧�����ֲ�����');
end;

function TAppFactory.CreateMainForm : boolean;
begin
  //Application.CreateForm(InstanceClass, Reference);
  result := true;
end;

function TAppFactory.ShowWelcome : boolean;
begin
  frmWelcome.Info := '��������';
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
  Application.Title := 'һ��Windows��������ϵͳ';
  Result := true;
end;

end.
