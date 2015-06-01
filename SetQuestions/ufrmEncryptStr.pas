unit ufrmEncryptStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinsDefaultPainters, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, cxLabel, cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine, dxSkinXmas2008Blue;

type
  TfrmStrEncrypt = class(TForm)
    mmSourceStr: TcxMemo;
    lblSourceStr: TcxLabel;
    mmTargetStr: TcxMemo;
    lblTargetStr: TcxLabel;
    btnEncrypt: TcxButton;
    btnDecrypt: TcxButton;
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Commons;

{$R *.dfm}

procedure TfrmStrEncrypt.btnDecryptClick(Sender: TObject);
begin
  mmTargetStr.Lines.Text :=DecryptStr(mmSourceStr.Lines.Text);
end;

procedure TfrmStrEncrypt.btnEncryptClick(Sender: TObject);
begin
  mmTargetStr.Lines.Text :=EncryptStr(mmSourceStr.Lines.Text);
end;

end.
