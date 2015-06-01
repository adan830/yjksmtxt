unit ufrmModifyTQNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinsDefaultPainters, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxTextEdit, cxControls, cxContainer, cxEdit, cxLabel, 
  ADODB;

type
  TfrmModifyTQNo = class(TForm)
    lblcxlbl1: TcxLabel;
    edtOldStNo: TcxTextEdit;
    lblcxlbl11: TcxLabel;
    edtNewStNo: TcxTextEdit;
    btnSave: TcxButton;
    btnCancel: TcxButton;
    procedure btnSaveClick(Sender: TObject);
  private
    FDs:TADODataSet;
    { Private declarations }
  public
    class function FrmShow(ATQNo: string; ADs: TADODataSet):string;
  end;

implementation

uses
  DataFieldConst;

{$R *.dfm}

{ TForm1 }

procedure TfrmModifyTQNo.btnSaveClick(Sender: TObject);
var
   len :Integer ;
   stno:string;
begin
   len := Length(Trim(edtNewStNo.Text));
   if (len =6) then begin
     if  not FDs.Locate(DFNTQ_ST_NO,Trim(edtNewStNo.Text),[]) then begin
         ModalResult := mrOk;
         Exit;
     end  else begin
       Application.MessageBox('试题编号不正确，请重新输入','错误！') ;
       Exit;
     end;
   end;
   if (len =0 ) then  ModalResult := mrCancel ;
end;

class function TfrmModifyTQNo.FrmShow(ATQNo: string; ADs: TADODataSet): string;
var
  frm:TfrmModifyTQNo;
begin
  frm := TfrmModifyTQNo.Create(nil);
  try
    frm.edtOldStNo.Text := ATQNo;
    frm.FDs := ADs;
    if frm.ShowModal = mrOk then
      Result := Trim(frm.edtNewStNo.Text)
    else
      Result := frm.edtOldStNo.Text;
  finally
     frm.Free;
  end;
end;

end.
