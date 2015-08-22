unit ufrmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, ShlObj, cxShellCommon, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxShellComboBox, StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxLabel, dxSkinsCore, dxSkinsDefaultPainters, Menus;

type
  TfrmConfig = class(TForm)
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxButton1: TcxButton;
    cbPathSource: TcxShellComboBox;
    cbPathTarget: TcxShellComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

uses uPubFn;

{$R *.dfm}

procedure TfrmConfig.cxButton1Click(Sender: TObject);
var
  ConfigList : TStringList;
begin
  ConfigList:=TStringList.Create;
  try
    ConfigList.Add(cbPathSource.Text);
    ConfigList.Add(cbPathTarget.Text);
    ConfigList.SaveToFile(ExtractFilePath(application.ExeName)+'config.txt');
  finally
    ConfigList.Free;
  end;
end;


procedure TfrmConfig.FormCreate(Sender: TObject);
var
  srcpath,
  tagpath : string;
begin
  GetDBPath(srcpath,tagpath);
  cbPathSource.text := srcpath;
  cbpathTarget.text := tagpath;
end;

end.
