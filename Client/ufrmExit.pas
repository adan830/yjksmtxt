unit ufrmExit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmExit = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
   msg :string ;
    { Public declarations }
  end;

var
  frmExit: TfrmExit;

implementation

{$R *.dfm}

procedure TfrmExit.Button1Click(Sender: TObject);
begin
modalresult := 1;
close;
end;

procedure TfrmExit.FormCreate(Sender: TObject);
begin
  label1.Caption := msg;
end;

end.
SQLSTR_GETCLIENT_EXAMINEEINFO, AConn
