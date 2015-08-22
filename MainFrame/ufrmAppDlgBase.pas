unit ufrmAppDlgBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmAppBase, ExtCtrls, StdCtrls, Buttons, ComCtrls, Menus,cxbuttons, cxLookAndFeelPainters,
  cxGraphics, cxLookAndFeels, dxSkinsCore, dxSkinsDefaultPainters;

type
  TfrmAppDlgBase = class(TfrmAppBase)
    pnlTop: TPanel;
    Label1: TLabel;
    Image1: TImage;
    pnlBottom: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnOk: TcxButton;
    btnCancel: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAppDlgBase: TfrmAppDlgBase;

implementation

{$R *.dfm}

end.
