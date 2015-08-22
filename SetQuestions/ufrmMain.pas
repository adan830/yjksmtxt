unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxBarPainter, cxClasses, 
  Role, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver,CustomColorForm,cndebug;

type
  TfrmMain = class(TForm)
    dxBarManager1: TdxBarManager;
    bsiTestQuestion: TdxBarSubItem;
    bbtnWord: TdxBarButton;
    bbtnWindows: TdxBarButton;
    bbtnExcel: TdxBarButton;
    mmbtnSysConfig: TdxBarButton;
    mmbtnSingleSelect: TdxBarButton;
    mmbtnMultiSelect: TdxBarButton;
    mmbtnType: TdxBarButton;
    bbtnPpt: TdxBarButton;
    mnbtnFileCheck: TdxBarButton;
    mnbtnEQimport: TdxBarButton;
    dxBarButton1: TdxBarButton;
    mnbtnSelectConfig: TdxBarButton;
    mnSubTQBSystem: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    mnbtnTestStrategy: TdxBarButton;
    mnbtnConvertToRTF: TdxBarButton;
    mnbtnAddonsFile: TdxBarButton;
    mnbtnEncrypt: TdxBarButton;
    mnbtnEncryptStr: TdxBarButton;
    mnsubSystem: TdxBarSubItem;
    mnbtnUserManager: TdxBarButton;
    mnbtnExpression: TdxBarButton;
    procedure mnbtnEQimportClick(Sender: TObject);
    procedure mnbtnFileCheckClick(Sender: TObject);
    procedure bbtnWordClick(Sender: TObject);
    procedure mmbtnSysConfigClick(Sender: TObject);
    procedure mmbtnSingleSelectClick(Sender: TObject);
    procedure mmbtnMultiSelectClick(Sender: TObject);
    procedure mmbtnTypeClick(Sender: TObject);
    procedure bbtnWindowsClick(Sender: TObject);
    procedure bbtnExcelClick(Sender: TObject);
    procedure bbtnPptClick(Sender: TObject);
    procedure mnbtnSelectConfigClick(Sender: TObject);
    procedure mnbtnTestStrategyClick(Sender: TObject);
    procedure mnbtnConvertToRTFClick(Sender: TObject);
    procedure mnbtnAddonsFileClick(Sender: TObject);
    procedure mnbtnEncryptStrClick(Sender: TObject);
    procedure mnbtnUserManagerClick(Sender: TObject);
    procedure mnbtnExpressionClick(Sender: TObject);
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

uses uSysConfig, ufrmType,
  ufrmWord,ufrmWin,
  Commons, ufrmSelect, ufrmExcel, ufrmPpt, ufrmFileCheck, 
  ufrmEQImport, ufrmEQBUseInfo, ufrmTestStrategy, uConvertDBtoRTF, 
  uFileAddonsImport, ufrmEncryptStr, uDmSetQuestion, ufrmRoleManager, 
  uAppUtils, SetQuestionGlobal, SetQuestionsResoureStrings, ufrmExpressionTree;

{$R *.dfm}

procedure TfrmMain.bbtnWordClick(Sender: TObject);
begin
  TfrmWord.FormShowMode('WORDMODULE.DLL',WORD_MODEL);
end;

procedure TfrmMain.mmbtnSysConfigClick(Sender: TObject);
begin
  frmSysConfig:=TfrmSysConfig.Create(application);
  try
    frmSysConfig.ShowModal;
  finally // wrap up
    frmSysConfig.Free;
  end;    // try/finally
end;

procedure TfrmMain.mmbtnSingleSelectClick(Sender: TObject);
begin
  TfrmSelect.FormShowMode('',SINGLESELECT_MODEL);
end;

procedure TfrmMain.mmbtnMultiSelectClick(Sender: TObject);
begin
  TfrmSelect.FormShowMode('',MULTISELECT_MODEL);
end;

procedure TfrmMain.mmbtnTypeClick(Sender: TObject);
begin
  TfrmType.FormShowMode('',TYPE_MODEL);
end;

procedure TfrmMain.bbtnWindowsClick(Sender: TObject);
begin
  TfrmWin.FormShowMode('WINDOWSMODULE.DLL',WINDOWS_MODEL);
end;

procedure TfrmMain.bbtnExcelClick(Sender: TObject);
begin
  TfrmExcel.FormShowMode('EXCELMODULE.DLL',EXCEL_MODEL);
end;

procedure TfrmMain.bbtnPptClick(Sender: TObject);
begin
  TfrmPpt.FormShowMode('PPTMODULE.DLL',POWERPOINT_MODEL);
end;

procedure TfrmMain.mnbtnFileCheckClick(Sender: TObject);
begin
  frmFileCheck := TfrmFileCheck.Create(nil);
  try
    frmfilecheck.ShowModal
  finally
    frmfilecheck.Free;
  end;

end;

procedure TfrmMain.mnbtnSelectConfigClick(Sender: TObject);
var
  frmEQBUseInfo : TfrmEQBUseInfo;
begin
  frmEQBUseInfo:=TfrmEQBUseInfo.Create(nil);
  try
    frmEQBUseInfo.showmodal;
  finally
    frmEQBUseInfo.Free;
  end;
end;

procedure TfrmMain.mnbtnTestStrategyClick(Sender: TObject);
var
  frmTestStrategy:TfrmTestStrategy;
begin
//  frmTestStrategy:=TfrmTestStrategy.Create(nil);
//  try
//    frmTestStrategy.showmodal;
//  finally
//    frmTestStrategy.Free;
//  end;
end;

procedure TfrmMain.mnbtnUserManagerClick(Sender: TObject);
var
  RoleManagerCommand: TRoleManagerCommand;
begin
  RoleManagerCommand := TRoleManagerCommand.Create(self);
  try
    RoleManagerCommand.Execute(self);
  finally // wrap up
    RoleManagerCommand.Free;
  end;
end;

procedure TfrmMain.mnbtnAddonsFileClick(Sender: TObject);
var
  frmAddonsFile:TfrmAddonsFile;
begin
  frmAddonsFile:=TfrmAddonsFile.Create(nil);
  try
    frmAddonsFile.showmodal;
  finally
    frmAddonsFile.Free;
  end;
end;

procedure TfrmMain.mnbtnConvertToRTFClick(Sender: TObject);
var
  frmConvert:TfrmConverttoRTF;
begin
  frmConvert:=TfrmConverttoRTF.Create(nil);
  try
    frmConvert.showmodal;
  finally
    frmConvert.Free;
  end;
end;

procedure TfrmMain.mnbtnEncryptStrClick(Sender: TObject);
var
  frmEncryptStr:TfrmStrEncrypt;
begin
  frmEncryptStr:=TfrmStrEncrypt.Create(nil);
  try
    frmEncryptStr.showmodal;
  finally
    frmEncryptStr.Free;
  end;

end;

procedure TfrmMain.mnbtnEQimportClick(Sender: TObject);
var
  frmEQImport:TfrmeqImport;
begin
  frmEQImport:=TfrmEQImport.Create(nil);
  try
    frmEqimport.showmodal;
  finally
    frmEQImport.Free;
  end;

end;

procedure TfrmMain.mnbtnExpressionClick(Sender: TObject);
var
  frmExpressionTree:TfrmExpressionTree;
begin
  frmExpressionTree:=TfrmExpressionTree.Create(nil);
  try
    frmExpressionTree.showmodal;
  finally
    frmExpressionTree.Free;
  end;
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

  Application.CreateForm(TdmSetQuestion, dmSetQuestion);
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
      if not FileExists(TAppUtils.AppPath + RSUserDataFileName) then
      begin
        raise ECommandExecuteExeception.Create(self.CurUser, Self.ToString, '�Ҳ��������û���Ϣ�ļ���');
      end;

      UserManager.LoadFromFile(TAppUtils.AppPath + RSUserDataFileName);

      if TfrmRoleManager.ManagerUser(UserManager) then
        UserManager.SaveToFile(TAppUtils.AppPath + RSUserDataFileName);
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
