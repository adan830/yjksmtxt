unit ufrmException;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmAppDlgBase, ExtCtrls, StdCtrls, cxButtons, Menus, cxLookAndFeelPainters;

type
  TfrmException = class(TfrmAppDlgBase)
    memMsg: TMemo;
    btnSendBug: TButton;
  private
    function GetMsg: string;
    procedure SetMsg(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowException(Msg : string);

    property Msg : string read GetMsg write SetMsg;
  end;

implementation

{$R *.dfm}

{ TfrmException }

function TfrmException.GetMsg: string;
begin
  Result := memMsg.Lines.Text;
end;

procedure TfrmException.SetMsg(const Value: string);
begin
  memMsg.Lines.Text := Value;
end;

class procedure TfrmException.ShowException(Msg: string);
var
  frmException: TfrmException;
begin
  frmException := TfrmException.Create(Application);
  try
    frmException.Msg := Msg;
    frmException.ShowModal;
  finally // wrap up
    frmException.Free;
  end;    // try/finally
end;

end.
