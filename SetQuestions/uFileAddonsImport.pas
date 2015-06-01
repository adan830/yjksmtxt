unit uFileAddonsImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinsDefaultPainters, cxGraphics, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxDropDownEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxControls, cxContainer, cxEdit, cxLabel;

type
  TfrmAddonsFile = class(TForm)
    cxLabel3: TcxLabel;
    bedtSourceFile: TcxButtonEdit;
    cxLabel1: TcxLabel;
    btnEQImport: TcxButton;
    edtFileID: TcxTextEdit;
    btnExport: TcxButton;
    OpenDialog1: TOpenDialog;
    procedure btnEQImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddonsFile: TfrmAddonsFile;

implementation

uses
  ADODB, uDmSetQuestion, DB;

{$R *.dfm}

procedure TfrmAddonsFile.btnEQImportClick(Sender: TObject);
var
  ds :TADODataSet;
begin
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName);
    //OpenDialog1.FileName:=trim(edtStNo.Text);
    OpenDialog1.Filter:='*.*';
    if OpenDialog1.Execute then begin
      if Trim(edtFileID.Text) <> '' then begin
        ds:=TADODataSet.Create(nil);
        ds.Connection:=dmSetQuestion.stkConn;
        ds.CommandText:='select guid,filestream from 附加文件 where Guid='+Trim(edtFileID.Text);
        ds.Active:=true;
        if not ds.IsEmpty then
        begin
          ds.Edit;
          (ds.FieldByName('filestream') as TBlobField).LoadFromFile(OpenDialog1.FileName);
          ds.Post;
          Application.MessageBox('import success!','OK');
        end
      end;
    end;
end;

procedure TfrmAddonsFile.btnExportClick(Sender: TObject);
var
  setTemp:TADODataset;
begin
  if Trim(edtFileID.Text) <> '' then begin
    OpenDialog1.InitialDir:=extractFilePath(application.ExeName);
    //OpenDialog1.FileName:=trim(edtStNo.Text);
    OpenDialog1.Filter:='*.*';
    if OpenDialog1.Execute then
    begin
      begin
          settemp:=TADODataSet.Create(nil);
          setTemp.Connection:=dmSetQuestion.stkConn;
          settemp.CommandText:='select guid,filestream from 附加文件 where Guid='+ trim(edtFileID.Text);
          setTemp.Active:=true;
          if not setTemp.IsEmpty then
          begin
            (setTemp.FieldByName('filestream') as TBlobField).SaveToFile(OpenDialog1.FileName);
          end;
      end;
    end;
  end;
end;

end.
(, )
