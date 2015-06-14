/// <summary>
/// 公用试题按钮框
/// </summary>
unit FrameTQButtons;

interface
uses Vcl.Forms,Vcl.Imaging.pngimage,System.Classes;
type
	TFrameTqbuttons=class(TFrame)
  private
    FButtonCount: Integer;
    pngNormal,
    pngDone:TPngImage;
    procedure SetCount(const Value: Integer);
    procedure CreateButtons;


    { Private declarations }
  public
    { Public declarations }
  published
    property Count:Integer   read FButtonCount write SetCount;
    constructor Create(AOwner: TComponent); override;
  end;
implementation

uses
  Vcl.Buttons;

constructor TFrameTqbuttons.Create(AOwner: TComponent);
begin
  inherited;
  pngNormal:=TPngImage.Create;
  pngDone:=TPngImage.Create;
  pngNormal.LoadFromFile('tqbutton.png');
  pngDone.LoadFromFile('tqbuttonDone.png');
end;

procedure TFrameTqbuttons.CreateButtons;
var
  I: Integer;
  hpos,vpos:Integer;
  btnTemp:TSpeedButton;
  stream:TMemoryStream;
const buttonWidth=26;
  buttonheight=23;
begin

hpos:=0;
vpos:=10;

  for I := 1 to 10 do
  begin
  btnTemp:= TSpeedButton.Create(Self);
    with btnTemp do
    begin
      parent := self;
      left :=hpos;
      top :=vpos;
      width:=buttonWidth;
      height:=buttonheight;

      Glyph.Assign(pngNormal);
      NumGlyphs:=4;
      flat:=true;
      GroupIndex:=1;
      tag:=i;
     // Down:=true;

      //HotTrackGlyph:=img1.Picture.Bitmap;
      //OnClick := btnTQButtonsClick;
//      if scoreinfo.IsRight=-1 then
//      begin
//        Score := score +1;
//        glyph:=image1.Picture.Bitmap
//      end
//      else
//      begin
//        glyph:=image2.Picture.Bitmap;
//      end;

    end;
    hpos:=hpos+buttonwidth+3;
  end;

end;

procedure TFrameTqbuttons.SetCount(const Value: Integer);
begin
  if FButtonCount<>Value then
  begin
    FButtonCount := Value;
    CreateButtons;
  end;
end;
end.
