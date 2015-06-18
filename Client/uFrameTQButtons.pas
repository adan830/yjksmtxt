unit uFrameTQButtons;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, System.Generics.Collections,
  ExamGlobal;

type
  TTqButtonClickEvent = procedure(sender: TObject) of Object;

  TFrameTQButtons = class(TFrame)
    grdpnlTQButtons: TGridPanel;
    procedure grdpnlTQButtonsCanResize(sender: TObject;
      var NewWidth, NewHeight: Integer; var Resize: Boolean);
  private
    FButtonCount: Integer;
    FTQList: TObjectList<TTQNode>;
    FGridRowCount, FGridColCount: Integer;
    // pngNormal, pngDone: TPngImage;
    FButtonClickProc: TTqButtonClickEvent;
    procedure SetButtonCount(const Value: Integer);
    procedure CreateButtons();
    procedure CalGridRowCol(gridWidth: Integer);
    function CalGridHeight(): Integer;
    procedure UpdateGridRowCol;
    procedure UpdateCompletedFlag; overload;

  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateCompletedFlag(buttonIndex, typeFlag: Integer); overload;
    property TQList: TObjectList<TTQNode> read FTQList write FTQList;
    property ButtonCount: Integer read FButtonCount write SetButtonCount;
    property ButtonClickProc: TTqButtonClickEvent read FButtonClickProc
      write FButtonClickProc;

  end;

implementation

{$R *.dfm}

uses
  System.Math, CnButtons;

const
  BUTTONWIDTH: Integer = 26;
  BUTTONHEIGHT: Integer = 23;
  BUTTONPADING: Integer = 3;
  GRIDROWHEIGHT: Integer = 26 + 3;

constructor TFrameTQButtons.Create(AOwner: TComponent);
begin
  inherited;
  // pngNormal := TPngImage.Create;
  // pngDone := TPngImage.Create;
  // pngNormal.LoadFromFile('tqbutton.png');
  // pngDone.LoadFromFile('tqbuttonDone.png');
end;

procedure TFrameTQButtons.CreateButtons();
var
  I: Integer;
  btnTemp: TCnSpeedButton;
begin
  for I := 0 to FButtonCount - 1 do
  begin
    btnTemp := TCnSpeedButton.Create(Self.grdpnlTQButtons);
    with btnTemp do
    begin
      parent := Self.grdpnlTQButtons;
      width := BUTTONWIDTH;
      height := BUTTONHEIGHT;
      top := 0;
      left := 0;
      Anchors := [akLeft, akTop];
      // Align:= alClient;
      // AlignWithMargins:=true;
      // Margins.Left:=0;
      // Margins.Right:=0;
      // Margins.Top:=0;
      Color := clRed;
      Font.Color := clWhite;
      // Glyph.Assign(pngNormal);
      // NumGlyphs:=4;
      flat := true;
      GroupIndex := 1;
      Caption := IntToStr(I + 1);
      tag := I;
      OnClick := FButtonClickProc;
      // if scoreinfo.IsRight=-1 then
      // begin
      // Score := score +1;
      // glyph:=image1.Picture.Bitmap
      // end
      // else
      // begin
      // glyph:=image2.Picture.Bitmap;
      // end;
    end;
  end;

end;

procedure TFrameTQButtons.grdpnlTQButtonsCanResize(sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if NewWidth <> grdpnlTQButtons.width then
  begin
    CalGridRowCol(NewWidth);
    NewHeight := CalGridHeight();
    UpdateGridRowCol;
  end;
end;

procedure TFrameTQButtons.SetButtonCount(const Value: Integer);
begin
  if FButtonCount <> Value then
  begin
    FButtonCount := Value;
    CalGridRowCol(grdpnlTQButtons.width);
    grdpnlTQButtons.height := CalGridHeight;
    Self.height := grdpnlTQButtons.height;
    UpdateGridRowCol();
    CreateButtons();
    UpdateCompletedFlag;
  end;
end;

procedure TFrameTQButtons.CalGridRowCol(gridWidth: Integer);
var
  wi: Integer;
begin
  FGridColCount := gridWidth div (BUTTONWIDTH + BUTTONPADING);
  FGridColCount := Min(FGridColCount, FButtonCount);
  FGridRowCount := Ceil(FButtonCount / FGridColCount);
end;

function TFrameTQButtons.CalGridHeight(): Integer;
begin
  if FGridRowCount = 1 then
    result := 38
  else
    result := FGridRowCount * 30;
end;

procedure TFrameTQButtons.UpdateCompletedFlag;
var
  index: Integer;
  controlItem: TCnSpeedButton;
begin
  if (FTQList <> nil) and (FTQList.Count > 0) then
  begin
    for index := 0 to FTQList.Count - 1 do
    begin
      if FTQList[index].flag then
      begin
        controlItem := grdpnlTQButtons.ControlCollection.Items[index].Control as TCnSpeedButton;
        controlItem.Color := clBlue;
      end;
    end;
  end;
end;

procedure TFrameTQButtons.UpdateCompletedFlag(buttonIndex, typeFlag: Integer);
var
  controlItem: TCnSpeedButton;
begin
   controlItem := grdpnlTQButtons.ControlCollection.Items[buttonIndex].Control as TCnSpeedButton;
   case typeFlag of
      1:controlItem.Color := clBlue;
      2:controlItem.Color := clLime;
      else
        controlItem.Color := clRed;
   end;
end;

procedure TFrameTQButtons.UpdateGridRowCol;
var
  I, row, col: Integer;
  rowItem: TRowItem;
  colItem: TColumnItem;
  controlItem: TControlItem;
begin
  with grdpnlTQButtons do
    if ControlCollection.Count > 0 then // update
    begin
      if (FGridRowCount > RowCollection.Count) then
      begin
        for I := RowCollection.Count to FGridRowCount - 1 do
        begin
          rowItem := RowCollection.Add;
          rowItem.SizeStyle := ssAbsolute;
          rowItem.Value := 30;
        end;

      end;
      if (FGridColCount > ColumnCollection.Count) then
      begin
        for I := ColumnCollection.Count to FGridColCount - 1 do
        begin
          colItem := ColumnCollection.Add;
          colItem.SizeStyle := ssAbsolute;
          colItem.Value := BUTTONWIDTH + BUTTONPADING;
        end;

      end;
      for I := ControlCollection.Count - 1 downto 0 do
      begin
        controlItem := ControlCollection.Items[I];
        controlItem.row := I div FGridColCount;
        controlItem.Column := I mod FGridColCount;
      end;
    end
    else
    begin // create
      grdpnlTQButtons.RowCollection.Clear;
      grdpnlTQButtons.ColumnCollection.Clear;
      for I := 0 to FGridRowCount - 1 do
      begin
        rowItem := RowCollection.Add;
        rowItem.SizeStyle := ssAbsolute;
        rowItem.Value := 30;
      end;
      if FGridRowCount = 1 then
        rowItem.Value := 38;

      for I := 0 to FGridColCount - 1 do
      begin
        colItem := ColumnCollection.Add;
        colItem.SizeStyle := ssAbsolute;
        colItem.Value := BUTTONWIDTH + BUTTONPADING;
      end;
    end;
end;

end.
