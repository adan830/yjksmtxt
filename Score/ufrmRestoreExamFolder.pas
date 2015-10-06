unit ufrmRestoreExamFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinsDefaultPainters, ComCtrls, ShlObj, cxShellCommon, cxDropDownEdit, cxShellComboBox, cxLabel, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxButtonEdit, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, 
  ExamGlobal, ufrmException, cxGraphics, cxLookAndFeels;

type
  TfrmRestoreExamFolder = class(TForm)
    bedtSourceFile: TcxButtonEdit;
    lbl1: TcxLabel;
    lbl2: TcxLabel;
    cbbPathTarget: TcxShellComboBox;
    btnRestore: TcxButton;
    dlgOpen1: TOpenDialog;
    procedure bedtSourceFileClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
  private
    procedure RestoreFolder(AFile:string;ATargetPath:string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRestoreExamFolder: TfrmRestoreExamFolder;

implementation

uses
  compress, Commons;

{$R *.dfm}

procedure TfrmRestoreExamFolder.bedtSourceFileClick(Sender: TObject);
begin
   if  dlgOpen1.Execute then
     bedtSourceFile.Text := dlgOpen1.FileName
   else
     bedtSourceFile.Text := '';
end; 

procedure TfrmRestoreExamFolder.btnRestoreClick(Sender: TObject);
begin
   if (bedtSourceFile.Text <> EmptyStr) and (cbbPathTarget.Text <>EmptyStr) then  begin
      RestoreFolder(bedtSourceFile.Text,cbbPathTarget.Text);
   end;
end;

procedure TfrmRestoreExamFolder.RestoreFolder(AFile:string;ATargetPath:string);
var
   AStream:TMemoryStream;
   fileName:string;
begin
   try
      UnZipExamPackFile2Dir(AFile,ATargetPath);
   except
      on E:Exception do
         Application.MessageBox(PChar('解压考生文件包错误！'+CR+e.Message), '解压考生文件包错误', MB_OK + MB_ICONSTOP + MB_TOPMOST);
   end;
end;

end.
