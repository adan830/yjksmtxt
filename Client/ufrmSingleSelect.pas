unit ufrmSingleSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,frameTQModule, Commons;

type
  TfrmSingleSelect = class(TFrameTQModule)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent;em:TExamModule);
  end;

implementation

{$R *.dfm}

{ TfrmSingleSelect }

constructor TfrmSingleSelect.Create(AOwner: TComponent;em:TExamModule);
begin
  inherited ;
   //frmTQButtons1.Count:=20;
end;

end.
