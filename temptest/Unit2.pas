unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls,
  JvSpeedButton, JvButton, JvTransparentButton, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  Vcl.StdCtrls, JvExStdCtrls, JvEdit;

type
  TForm2 = class(Tform)
    btn: TJvSpeedButton;
    edt1: TJvEdit;
    cxtxtdt1: TcxTextEdit;
    edt2: TEdit;
    cxtxtdt2: TcxTextEdit;
  private
  protected

    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{ TForm2 }



end.
