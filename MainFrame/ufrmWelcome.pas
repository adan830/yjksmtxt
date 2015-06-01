unit ufrmWelcome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls;

type
  TfrmWelcome = class(TForm)
    Image1: TImage;
    lblInfo: TLabel;
    Shape1: TShape;
  private
    function GetInfo: string;
    procedure SetInfo(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Info : string read GetInfo write SetInfo;
  end;

implementation

{$R *.dfm}

{ TfrmWelcome }

function TfrmWelcome.GetInfo: string;
begin
  result := lblInfo.Caption;
end;

procedure TfrmWelcome.SetInfo(const Value: string);
begin
  lblInfo.Caption := Value;

  Application.ProcessMessages;
end;

end.
