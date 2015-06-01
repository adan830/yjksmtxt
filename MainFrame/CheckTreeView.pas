unit CheckTreeView;

interface

{$DEFINE VCL70_OR_HIGHER}
{$DEFINE VCL60_OR_HIGHER}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  CommCtrl,
  Menus,
  ImgList;

const
  STATE_UNCHECKED   = 1;
  STATE_CHECKED     = 2;
  STATE_PARTCHECKED = 3;

type
  TCheckTvOnNodeContextMenuEvent = procedure( aSender: TObject; aNode: TTreeNode; var aPos: TPoint;
                                           var aMenu: TPopupMenu ) of object;

  TCheckCustomTreeView = class( TCustomTreeView )
  private
    FUpdatingColor: Boolean;
    FDisabledColor: TColor;
    FFocusColor: TColor;
    FNormalColor: TColor;

    FAutoSelect: Boolean;
    FSelectionPen: TPen;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

    FRClickNode: TTreeNode;
    FOnNodeContextMenu: TCheckTvOnNodeContextMenuEvent;
    FMenuAlreadyHandled: Boolean;
    procedure CMSysColorChange( var Msg: TMessage ); message cm_SysColorChange;
    procedure CNNotify( var Msg: TWMNotify ); message cn_Notify;
    procedure WMRButtonUp( var Msg: TWMRButtonUp ); message wm_RButtonUp;
    procedure WMContextMenu( var Msg: TMessage ); message wm_ContextMenu;

    { Internal Event Handlers }
    procedure PenChanged( Sender: TObject );

    { Message Handling Methods }
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure WMPaint( var Msg: TWMPaint ); message wm_Paint;
    procedure WMNCPaint( var Msg: TWMNCPaint ); message wm_NCPaint;
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
  protected
    FCanvas: TControlCanvas;
    FOverControl: Boolean;
    FRecreating: Boolean;

    procedure CreateParams( var Params: TCreateParams ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure UpdateColors; virtual;

    { Event Dispatch Methods }
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    procedure Collapse( Node: TTreeNode ); override;
    procedure Expand( Node: TTreeNode ); override;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    procedure DoPreNodeContextMenu; dynamic;
    procedure DoNodeContextMenu( Node: TTreeNode; P: TPoint ); dynamic;
    procedure KeyDown( var Key: Word;  ShiftState: TShiftState ); override;
    procedure NodeContextMenu( Node: TTreeNode; var Pos: TPoint; var Menu: TPopupMenu ); dynamic;

    function GetSelected: TTreeNode;
    procedure SetSelected( Value: TTreeNode );

    { Property Access Methods }
    function GetColor: TColor; virtual;
    procedure SetColor( Value: TColor ); virtual;
    function IsColorStored: Boolean;
    function IsFocusColorStored: Boolean;
    function GetAutoExpand: Boolean; virtual;
    procedure SetAutoExpand( Value: Boolean ); virtual;
    procedure SetAutoSelect( Value: Boolean ); virtual;
    procedure SetDisabledColor( Value: TColor ); virtual;
    procedure SetFocusColor( Value: TColor ); virtual;
    procedure SetSelectionPen( Value: TPen ); virtual;

    { Property Declarations }

    property AutoExpand: Boolean
      read GetAutoExpand
      write SetAutoExpand
      default False;

    property AutoSelect: Boolean
      read FAutoSelect
      write SetAutoSelect
      default False;

    property Color: TColor
      read GetColor
      write SetColor
      stored IsColorStored
      default clWindow;

    property DisabledColor: TColor
      read FDisabledColor
      write SetDisabledColor
      default clBtnFace;

    property FocusColor: TColor
      read FFocusColor
      write SetFocusColor
      stored IsFocusColorStored
      default clWindow;

    property SelectionPen: TPen
      read FSelectionPen
      write SetSelectionPen;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    { Inherited Properties & Events }
    property ParentColor default False;
    property TabStop default True;

    property OnMouseWheelUp;
    property OnMouseWheelDown;

    property OnNodeContextMenu: TCheckTvOnNodeContextMenuEvent
      read FOnNodeContextMenu
      write FOnNodeContextMenu;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function UseThemes: Boolean; virtual;

    function NodeFromPath( Path: string ): TTreeNode;
    function PathFromNode( Node: TTreeNode ): string;
    procedure SelectByPath( const Path: string );

    procedure UpdateStateIndexDisplay( Node: TTreeNode );

    procedure FullCollapse;
    procedure FullExpand;

    procedure InvalidateNode( Node: TTreeNode; TextOnly: Boolean; EraseBkgnd: Boolean );

    property Selected: TTreeNode
      read GetSelected
      write SetSelected;
  end;

  TCheckCheckState = ( csUnknown, csUnchecked, csChecked, csPartiallyChecked );

  TCheckTreeChangingEvent = procedure( Sender: TObject; Node: TTreeNode; NewState: TCheckCheckState;
                                         var AllowChange: Boolean ) of object;

  TCheckTreeChangeEvent = procedure( Sender: TObject; Node: TTreeNode; NewState: TCheckCheckState ) of object;

  TCheckTree = class( TCheckCustomTreeView )
  private
    FSelectedItem: Integer;
    FBmpWidth: Integer;
    FImageWidth: Integer;
    FChangingState: Boolean;
    FSuspendCascades: Boolean;
    FCheckImages: TImageList;
    FCascadeChecks: Boolean;
    FSilentStateChanges: Boolean;
    FHighlightColor: TColor;

    FOnStateChanging: TCheckTreeChangingEvent;
    FOnStateChange: TCheckTreeChangeEvent;
    FOnUpdateChildren: TNotifyEvent;

    function GetItemState( AbsoluteIndex: Integer ): TCheckCheckState;
    procedure SetItemState( AbsoluteIndex: Integer; Value: TCheckCheckState );
    procedure SetNodeCheckState( Node:TTreeNode; NewState: TCheckCheckState );
    procedure RecurseChildren( Node: TTreeNode; NodeChecked: Boolean );
    procedure SetAllChildren( Node: TTreeNode; NewState: TCheckCheckState );

    procedure WMPaint( var Msg: TWMPaint ); message wm_Paint;
  protected
    procedure Loaded; override;

    procedure UpdateImageWidth; virtual;
    procedure InitStateImages; virtual;
    procedure UpdateParents( Node: TTreeNode; NodeChecked: Boolean ); virtual;
    procedure UpdateChildren( Node: TTreeNode; NodeChecked: Boolean ); virtual;

    { Event Dispatch Methods }
    function  CanChangeState( Node: TTreeNode; NewState: TCheckCheckState ): Boolean; dynamic;
    procedure StateChange( Node: TTreeNode; NewState: TCheckCheckState ); dynamic;

    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure KeyUp( var Key: Word; Shift: TShiftState ); override;
    procedure WMChar( var Msg: TWMChar ); message wm_Char ;

    { Property Access Methods }
    function GetImages: TCustomImageList;
    procedure SetImages( Value: TCustomImageList );
    procedure SetHighlightColor( Value: TColor );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure ToggleCheckState( Node: TTreeNode );
    procedure ChangeNodeCheckState( Node: TTreeNode; NewState: TCheckCheckState );
    procedure ForceCheckState( Node : TTreeNode; NewState: TCheckCheckState );
    procedure SetAllNodes( NewState: TCheckCheckState );

    procedure UpdateCascadingStates( Node: TTreeNode );
    procedure UpdateChildrenCascadingStates( ParentNode: TTreeNode );

    procedure LoadFromFile( const FileName: string );
    procedure LoadFromStream( Stream: TStream );
    procedure SaveToFile( const FileName: string );
    procedure SaveToStream( Stream: TStream );

    property ItemState[ Index: Integer ]: TCheckCheckState
      read GetItemState
      write SetItemState;

    property SilentCheckChanges: Boolean
      read FSilentStateChanges
      write FSilentStateChanges;
  published
    property CascadeChecks: Boolean
      read FCascadeChecks
      write FCascadeChecks
      default True;

    property HighlightColor: TColor
      read FHighlightColor
      write SetHighlightColor
      default clHighlight;

    property Images: TCustomImageList
      read GetImages
      write SetImages;

    property OnStateChanging: TCheckTreeChangingEvent
      read FOnStateChanging
      write FOnStateChanging;

    property OnStateChange: TCheckTreeChangeEvent
      read FOnStateChange
      write FOnStateChange;

    property OnUpdateChildren: TNotifyEvent
      read FOnUpdateChildren
      write FOnUpdateChildren;

    { Inherited Properties and Events }
    property Align;
    property Anchors;
    property AutoExpand;
    property AutoSelect;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property ChangeDelay;
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FocusColor;
    property HideSelection;
    property HotTrack;
    property Indent;

    property MultiSelect;
    property MultiSelectStyle;

    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly default True;
    property RightClickSelect;
    property RowSelect;
    property SelectionPen;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnAddition;

    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;

    property OnCancelEdit;

    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnCompare;
    property OnContextPopup;

    property OnCreateNodeClass;

    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;

    property Items;
  end;


function LastChar( const S: string ): Char;
function CountChar( C: Char; const S: string ): Integer;
function CopyEx( const S: string; Start: Integer; C: Char; Count: Integer ): string;
function RemoveChar( var S: string; C: Char ): Boolean;

function IsWin95: Boolean;
function IsOSR2OrGreater: Boolean;          // Returns TRUE if running Win95 OSR2 or higher.
function IsWinNT: Boolean;
function IsWin2000: Boolean;
function HasWin95Shell: Boolean;

procedure Register;

implementation

uses
  Themes,
  TypInfo,
  ComStrs;

procedure Register;
begin
  RegisterComponents('FrameWork', [TCheckTree]);
end;

{$R checkcommonbitmap.res}

{-- General Utilities ----------------}
var
  gOSVer: TOSVersionInfo;
  //g_IShm: IMalloc_NRC = nil;

function IsWin95: Boolean;
begin
  Result := ( gOSVer.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS );
end;

function IsOSR2OrGreater: Boolean;          // Returns TRUE if running Win95 OSR2 or higher.
begin
  Result := IsWin95 and ( LoWord( gOsVer.dwBuildNumber ) > 1000 );
end;

function IsWinNT: Boolean;
begin
  Result := ( gOSVer.dwPlatformId = VER_PLATFORM_WIN32_NT );
end;

function IsWin2000: Boolean;
begin
  Result := ( gOSVer.dwPlatformId = VER_PLATFORM_WIN32_NT ) and ( gOsVer.dwMajorVersion >= 5 );
end;

function HasWin95Shell: Boolean;
begin
  Result := IsWin95 or ( IsWinNT and ( gOSVer.dwMajorVersion >= 4 ) );
end;


function LastChar( const S: string ): Char;
begin
  Result := S[ Length( S ) ];
end;


function CountChar( C: Char; const S: string ): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length( S ) do
  begin
    if S[ I ] = C then
      Inc( Result );
  end;
end;


{===============================================================================
  function CopyEx

  This function is an enhanced version of the Copy function. Instead of
  specifying the number of characters to copy, the last character copied is
  determined by the Count instance of the C character in the string.

  For example,
    S := CopyEx( 'C:\Windows\System, 1, '\', 2 );

    S will be 'C:\Windows\'
===============================================================================}

function CopyEx( const S: string; Start: Integer; C: Char; Count: Integer ): string;
var
  I, J: Integer;
begin
  Result := S;
  J := 0;
  for I := Start to Length( S ) do
  begin
    if S[ I ] = C then
      Inc( J );

    if J = Count then
    begin
      Result := Copy( S, Start, I );
      Break;
    end;
  end;
end;


function RemoveChar( var S: string; C: Char ): Boolean;
var
  I: Integer;
begin
  I := Pos( C, S );
  Result := I > 0;
  if Result then
    Delete( S, I, 1 );
end;

constructor TCheckCustomTreeView.Create( AOwner: TComponent );
begin
  inherited;
  {&RCI}
  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;

  FSelectionPen := TPen.Create;
  FSelectionPen.Color := clBtnShadow;
  FSelectionPen.Style := psSolid;
  FSelectionPen.OnChange := PenChanged;

  FDisabledColor := clBtnFace;
  FFocusColor := clWindow;
  FNormalColor := clWindow;

  TabStop := True;
  ParentColor := False;
end;


destructor TCheckCustomTreeView.Destroy;
  {$IFDEF DELPHI5}
  procedure FreeNode(ANode: TTreeNode);
  var
    NextChild: TTreeNode;
  begin
    NextChild := ANode.GetFirstChild;
    while Assigned(NextChild) do
    begin
      FreeNode(NextChild);
      NextChild := NextChild.GetNext;
    end;
    Self.Delete(ANode);
  end;

  procedure FreeNodeData;
  var
    RootNode: TTreeNode;
  begin
    RootNode := Items.GetFirstNode;
    while Assigned(RootNode) do
    begin
      FreeNode(RootNode);
      RootNode := RootNode.GetNextSibling;
    end;
  end;
  {$ENDIF}

begin
  FCanvas.Free;
  FSelectionPen.Free;

  {$IFDEF DELPHI5}
  if HandleAllocated and Assigned( Items ) then
    FreeNodeData;
  {$ENDIF}

  inherited;
end;

procedure TCheckCustomTreeView.Loaded;
begin
  inherited;
  UpdateColors;
end;


procedure TCheckCustomTreeView.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
end;


function TCheckCustomTreeView.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
var
  Info: TScrollInfo;
begin
  Info.cbSize := SizeOf( Info );
  Info.fMask := sif_Pos;

  if GetScrollInfo( Handle, sb_Vert, Info ) then
  begin
    Info.nPos := Info.nPos + Mouse.WheelScrollLines;
    SendMessage( Handle, wm_VScroll, MakeLong( sb_ThumbPosition, Info.nPos ), 0 );

    SetScrollInfo( Handle, sb_Vert, Info, True );
  end;
  Result := True;
end;


function TCheckCustomTreeView.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
var
  Info: TScrollInfo;
begin
  Info.cbSize := SizeOf( Info );
  Info.fMask := sif_Pos;

  if GetScrollInfo( Handle, sb_Vert, Info ) then
  begin
    Info.nPos := Info.nPos - Mouse.WheelScrollLines;
    if Info.nPos >= 0 then
    begin
      SendMessage( Handle, wm_VScroll, MakeLong( sb_ThumbPosition, Info.nPos ), 0 );
      SetScrollInfo( Handle, sb_Vert, Info, True );
    end;
  end;
  Result := True;
end;


function TCheckCustomTreeView.GetAutoExpand: Boolean;
begin
  Result := inherited AutoExpand;
end;


procedure TCheckCustomTreeView.SetAutoExpand( Value: Boolean );
begin
  inherited AutoExpand := Value;
  if AutoExpand then
    FAutoSelect := False;
end;


procedure TCheckCustomTreeView.SetAutoSelect( Value: Boolean );
begin
  if FAutoSelect <> Value then
  begin
    FAutoSelect := Value;
    if FAutoSelect then
      AutoExpand := False;
  end;
end;


function TCheckCustomTreeView.GetColor: TColor;
begin
  Result := inherited Color;
end;


procedure TCheckCustomTreeView.SetColor( Value: TColor );
begin
  if Color <> Value then
  begin
    inherited Color := Value;
    if not FUpdatingColor then
    begin
      if FFocusColor = FNormalColor then
        FFocusColor := Value;
      FNormalColor := Value;
    end;
  end;
end;


function TCheckCustomTreeView.IsColorStored: Boolean;
begin
  Result := Enabled;
end;


function TCheckCustomTreeView.IsFocusColorStored: Boolean;
begin
  Result := ( ColorToRGB( FFocusColor ) <> ColorToRGB( Color ) );
end;

procedure TCheckCustomTreeView.SetDisabledColor( Value: TColor );
begin
  FDisabledColor := Value;
  if not Enabled then
    UpdateColors;
end;


procedure TCheckCustomTreeView.SetFocusColor( Value: TColor );
begin
  FFocusColor := Value;
  if Focused then
    UpdateColors;
end;

procedure TCheckCustomTreeView.SetSelectionPen( Value: TPen );
begin
  FSelectionPen.Assign( Value );
  Invalidate;
end;


procedure TCheckCustomTreeView.PenChanged( Sender: TObject );
begin
  Invalidate;
end;


function TCheckCustomTreeView.UseThemes: Boolean;
begin
  Result := ThemeServices.ThemesEnabled;
end;


procedure TCheckCustomTreeView.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  UpdateColors;
end;


procedure TCheckCustomTreeView.WMNCPaint( var Msg: TWMNCPaint );
begin
  inherited;
end; 

procedure TCheckCustomTreeView.WMPaint( var Msg: TWMPaint );
var
  R: TRect;
begin
  inherited;

  if not HideSelection and not Focused and ( Selected <> nil ) then
  begin
    FCanvas.Handle := Msg.DC;                 { Map canvas onto device context }
    try
      R := Selected.DisplayRect( True );

      FCanvas.Pen := FSelectionPen;
      FCanvas.Brush.Style := bsClear;
      FCanvas.Rectangle( R.Left, R.Top, R.Right, R.Bottom );
      FCanvas.Pen.Width := 1;
      FCanvas.Pen.Style := psSolid;
    finally
      FCanvas.Handle := 0;
    end;
  end;
end;


procedure TCheckCustomTreeView.UpdateColors;
begin
  if csLoading in ComponentState then
    Exit;

  FUpdatingColor := True;
  try
    if not Enabled then
      Color := FDisabledColor
    else if Focused then
      Color := FFocusColor
    else
      Color := FNormalColor;
  finally
    FUpdatingColor := False;
  end;
end;

procedure TCheckCustomTreeView.CMEnter( var Msg: TCMEnter );
begin
  inherited;
end;

procedure TCheckCustomTreeView.CMExit( var Msg: TCMExit );
begin
  inherited;
end;


procedure TCheckCustomTreeView.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;

procedure TCheckCustomTreeView.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  MouseEnter;
end;

procedure TCheckCustomTreeView.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;


procedure TCheckCustomTreeView.Collapse( Node: TTreeNode );
begin
  if FAutoSelect then
    Node.Selected := True;
  inherited;
end;


procedure TCheckCustomTreeView.Expand( Node: TTreeNode );
begin
  inherited;
  if FAutoSelect then
    Node.Selected := True;
end;


procedure TCheckCustomTreeView.FullCollapse;
var
  SaveAutoSelect: Boolean;
begin
  SaveAutoSelect := FAutoSelect;
  FAutoSelect := False;
  inherited;
  FAutoSelect := SaveAutoSelect;
end;


procedure TCheckCustomTreeView.FullExpand;
var
  SaveAutoSelect: Boolean;
begin
  SaveAutoSelect := FAutoSelect;
  FAutoSelect := False;
  inherited;
  FAutoSelect := SaveAutoSelect;
end;


procedure TCheckCustomTreeView.CMMouseLeave( var Msg: TMessage );
begin
  {&RV}
  inherited;
  MouseLeave;
end;

procedure TCheckCustomTreeView.WMSize( var Msg: TWMSize );
begin
  inherited;
end;


function TCheckCustomTreeView.PathFromNode( Node: TTreeNode ): string;
begin
  if Node <> nil then
  begin
    Result := Node.Text + '\';
    while Node.Parent <> nil do
    begin
      Node := Node.Parent;
      Result := Node.Text + '\' + Result;
    end;
  end
  else
    Result := '';
end;


function TCheckCustomTreeView.NodeFromPath( Path: string ): TTreeNode;
var
  OldCursor: TCursor;
  I: Integer;
  Found: Boolean;
  Node, SearchNode, MatchingNode: TTreeNode;
  FindPath: string;
begin
  Result := nil;

  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if LastChar( Path ) <> '\' then
      Path := Path + '\';
    Path := AnsiUpperCase( Path );

    Node := nil;

    for I := 1 to CountChar( '\', Path ) do
    begin
      FindPath := CopyEx( Path, 1, '\', I );
      MatchingNode := nil;
      if Items.Count > 0 then
      begin
        if Node <> nil then
          SearchNode := Node.GetFirstChild
        else
          SearchNode := Items[ 0 ];

        Found := False;
        while not Found and ( SearchNode <> nil ) do
        begin
          if AnsiUpperCase( PathFromNode( SearchNode ) ) = FindPath then
          begin
            MatchingNode := SearchNode;
            Found := True;
          end;
          SearchNode := SearchNode.GetNextSibling;
        end;
      end;

      Node := MatchingNode;
      if Node = nil then
        Exit;
    end;
    Result := Node;
  finally
    Screen.Cursor := OldCursor;
  end;
end;


procedure TCheckCustomTreeView.SelectByPath( const Path: string );
var
  Node: TTreeNode;
begin
  Node := NodeFromPath( Path );
  if Node <> nil then
    Node.Selected := True;
end;


procedure TCheckCustomTreeView.UpdateStateIndexDisplay( Node: TTreeNode );
var
  I: Integer;
  Item: TTVItem;
  Value: Integer;
begin
  Value := Node.StateIndex;
  if Value >= 0 then
    Dec( Value );
  with Item do
  begin
    mask := TVIF_STATE or TVIF_HANDLE;
    stateMask := TVIS_STATEIMAGEMASK;
    hItem := Node.ItemId;
    state := IndexToStateImageMask( Value + 1 );
  end;
  TreeView_SetItem( Node.TreeView.Handle, Item );

  for I := 0 to Node.Count - 1 do
  begin
    if Node.Item[ I ].HasChildren then
      UpdateStateIndexDisplay( Node.Item[ I ] )
    else
    begin
      Value := Node.Item[ I ].StateIndex;
      if Value >= 0 then
        Dec( Value );
      with Item do
      begin
        mask := TVIF_STATE or TVIF_HANDLE;
        stateMask := TVIS_STATEIMAGEMASK;
        hItem := Node.Item[ I ].ItemId;
        state := IndexToStateImageMask( Value + 1 );
      end;
      TreeView_SetItem( Node.TreeView.Handle, Item );
    end;
  end;
end;


procedure TCheckCustomTreeView.InvalidateNode( Node: TTreeNode; TextOnly: Boolean; EraseBkgnd: Boolean );
var
  R: TRect;
begin
  R := Node.DisplayRect( TextOnly );
  InvalidateRect( Handle, @R, EraseBkgnd );
end;


procedure TCheckCustomTreeView.CMSysColorChange( var Msg: TMessage );
begin
  inherited;
  if Color < 0 then
    Perform( cm_ColorChanged, Msg.wParam, Msg.lParam );
end;


procedure TCheckCustomTreeView.CNNotify( var Msg: TWMNotify );
var
  Node: TTreeNode;
  P: TPoint;
  Mnu: TPopupMenu;
  OldGetImageEvent: TTVExpandedEvent;
  OldGetSelectedImageEvent: TTVExpandedEvent;

  function GetNodeFromItem( const Item: TTVItem ): TTreeNode;
  begin
    with Item do
      if (state and TVIF_PARAM) <> 0 then
        Result := Pointer(lParam)
      else
        Result := Items.GetNode(hItem);
  end;

begin {= TCheckCustomTreeView.CNNotify =}
  with Msg.NMHdr^ do
    case Code of

      tvn_GetDispInfo:
      begin
        with PTVDispInfo( Pointer( Msg.NMHdr ) )^ do
        begin
          Node := GetNodeFromItem( Item );

          if Assigned( Node ) then
          begin
            if (item.mask and TVIF_IMAGE) <> 0 then
            begin
              GetImageIndex( Node );
              Item.iImage := Node.ImageIndex;
            end;

            if ( Item.mask and tvif_SelectedImage ) <> 0 then
            begin
              GetSelectedIndex( Node );
              Item.iSelectedImage := Node.SelectedIndex;
            end;
          end;

          oldGetImageEvent := OnGetImageIndex;
          oldGetSelectedImageEvent := OnGetSelectedIndex;
          OnGetImageIndex:=nil;
          OnGetSelectedIndex:=nil;
          try
            inherited;
          finally
            OnGetImageIndex := oldGetImageEvent;
            OnGetSelectedIndex := oldGetSelectedImageEvent;
          end;
        end;
      end;

      nm_RClick:
      begin
        // Note: The RightClickSelect property introduced in Delphi 3 can do some of this. We don't use it
        //       in order to maintain Delphi 2 and C++Builder compatibility.
        if not (csDesigning in ComponentState) then
        begin
          GetCursorPos( p );
          p := ScreenToClient( p );
          FRClickNode := GetNodeAt( p.x, p.y );
          if not Assigned( FRClickNode ) then
            FRClickNode := inherited Selected;
          if Assigned( FRClickNode ) then
          begin
            mnu := PopupMenu; // Default is normal popup
            NodeContextMenu( FRClickNode, p, mnu );
            if Assigned( mnu ) then
              with ClientToScreen( p ) do
              begin
                mnu.PopupComponent := self;
                mnu.Popup( x, y );
              end;
            FRClickNode := nil;
            FMenuAlreadyHandled := TRUE;
          end;
        end;

        inherited;
      end;

      else
        inherited;
    end; {case}
end; {TCheckCustomTreeView.CNNotify}


procedure TCheckCustomTreeView.WMRButtonUp( var Msg: TWMRButtonUp );
var
  OldAutoPopup: Boolean;
begin
  if FMenuAlreadyHandled and Assigned(PopupMenu) then
  begin
    OldAutoPopup := PopupMenu.AutoPopup;
    PopupMenu.AutoPopup := FALSE;
    try
      inherited;
    finally
      PopupMenu.AutoPopup := OldAutoPopup;
      FMenuAlreadyHandled := FALSE;
    end;
  end
  else
    inherited;
end;


procedure TCheckCustomTreeView.WMContextMenu( var Msg: TMessage );
begin
  if not ( csDesigning in ComponentState ) and not Assigned( Selected ) and not FMenuAlreadyHandled then
  begin
    if Msg.lParam = -1 then
      DoPreNodeContextMenu
    else
      DoNodeContextMenu( Selected, ScreenToClient( Point( Msg.lParamLo, Msg.lParamHi ) ) );
  end;
end;


// Work around a bug with tooltips in NT4. We just disable them. The bug was fixed around v4.72 of
// comctl32.dll so we don't disable the tooltips for this and later versions.

procedure TCheckCustomTreeView.CreateParams( var Params: TCreateParams );
begin
  inherited;
end;


procedure TCheckCustomTreeView.DoPreNodeContextMenu;
var
  P: TPoint;

  procedure DoDefault;
  begin
    if Assigned( PopupMenu ) then
    begin
      PopupMenu.PopupComponent := Self;
      with ClientToScreen( Point( 0, 0 ) ) do
        PopupMenu.Popup( X, Y );
    end;
  end;

begin
  if Assigned( Selected ) then
  begin
    with Selected.DisplayRect( True ) do
      P := Point( ( Left + Right) div 2, ( Bottom + Top ) div 2 )
  end
  else
  begin
    DoDefault;
    Exit;
  end;
  DoNodeContextMenu( Selected, p );
end; {= TCheckCustomTreeView.DoPreNodeContextMenu =}


procedure TCheckCustomTreeView.DoNodeContextMenu( Node: TTreeNode; P: TPoint );
var
  Menu: TPopupMenu;
begin
  Menu := PopupMenu; // Default to normal popup
  NodeContextMenu( Node, P, Menu );
  if Menu <> PopupMenu then
    FMenuAlreadyHandled := True;
  if Assigned( Menu ) then
  begin
    Menu.PopupComponent := Self;
    with ClientToScreen( P ) do
      Menu.Popup( X, Y );
  end;
end;


procedure TCheckCustomTreeView.KeyDown( var Key: Word; ShiftState: TShiftState );
begin
  if ( ( Key = VK_APPS ) and ( ShiftState = [] ) ) or
     ( ( Key = VK_F10 ) and ( ShiftState = [ ssShift ] ) ) then
  begin
    Key := 0;
    DoPreNodeContextMenu;
  end;
  inherited;
end;


procedure TCheckCustomTreeView.NodeContextMenu( Node: TTreeNode; var Pos: TPoint; var Menu: TPopupMenu );
begin
  if Assigned( FOnNodeContextMenu ) then
    FOnNodeContextMenu( Self, Node, Pos, Menu );
end;


function TCheckCustomTreeView.GetSelected: TTreeNode;
begin
  if HandleAllocated then
  begin
    if RightClickSelect and Assigned( FRClickNode ) then
      Result := FRClickNode
    else
      Result := Items.GetNode( TreeView_GetSelection( Handle ) );
  end
  else
    Result := nil;
end;


procedure TCheckCustomTreeView.SetSelected( Value: TTreeNode );
begin
  inherited Selected := Value;
end;



{=======================================================}
{== TCheckTreeStrings Class Declaration and Methods ==}
{=======================================================}

procedure TreeViewError( const Msg: string );
begin
  raise ETreeViewError.Create( Msg );
end;

procedure TreeViewErrorFmt( const Msg: string; Format: array of const );
begin
  raise ETreeViewError.CreateFmt( Msg, Format );
end;


type
  TCheckTreeStrings = class( TStrings )
  private
    FOwner: TTreeNodes;
  protected
    function Get( Index: Integer ): string; override;
    function GetBufStart( Buffer: PChar; var Level: Integer ): PChar;
    function GetCount: Integer; override;
    function GetObject( Index: Integer ): TObject; override;
    procedure PutObject( Index: Integer; AObject: TObject ); override;
    procedure SetUpdateState( Updating: Boolean ); override;
  public
    constructor Create( AOwner: TTreeNodes );

    function Add( const S: string ): Integer; override;
    procedure Clear; override;
    procedure Delete( Index: Integer ); override;
    procedure Insert( Index: Integer; const S: string ); override;
    procedure LoadTreeFromStream( Stream: TStream );
    procedure SaveTreeToStream( Stream: TStream );
    property Owner: TTreeNodes
      read FOwner;
  end;

constructor TCheckTreeStrings.Create( AOwner: TTreeNodes );
begin
  inherited Create;
  FOwner := AOwner;
end;


function TCheckTreeStrings.Get( Index: Integer ): string;
const
  TabChar = #9;
var
  Level, I: Integer;
  Node: TTreeNode;
begin
  Result := '';
  Node := Owner.Item[ Index ];
  Level := Node.Level;
  for I := 0 to Level - 1 do
    Result := Result + TabChar;
  Result := Result + Node.Text;
end;


function TCheckTreeStrings.GetBufStart( Buffer: PChar; var Level: Integer ): PChar;
begin
  Level := 0;
  while Buffer^ in [' ', #9] do
  begin
    Inc( Buffer );
    Inc( Level );
  end;
  Result := Buffer;
end;


function TCheckTreeStrings.GetObject( Index: Integer ): TObject;
begin
  Result := Owner.Item[ Index ].Data;
end;


procedure TCheckTreeStrings.PutObject( Index: Integer; AObject: TObject );
begin
  Owner.Item[ Index ].Data := AObject;
end;


function TCheckTreeStrings.GetCount: Integer;
begin
  Result := Owner.Count;
end;


procedure TCheckTreeStrings.Clear;
begin
  Owner.Clear;
end;


procedure TCheckTreeStrings.Delete( Index: Integer );
begin
  Owner.Item[ Index ].Delete;
end;


procedure TCheckTreeStrings.SetUpdateState( Updating: Boolean );
begin
  SendMessage( Owner.Handle, WM_SETREDRAW, Ord( not Updating ), 0 );
  if not Updating then
    Owner.Owner.Refresh;
end;


function TCheckTreeStrings.Add( const S: string ): Integer;
var
  Level, OldLevel, I: Integer;
  NewStr: string;
  Node: TTreeNode;
begin
  Result := GetCount;
  if ( Length( S ) = 1 ) and ( S[ 1 ] = Chr( $1A ) ) then
    Exit;
  Node := nil;
  OldLevel := 0;
  NewStr := GetBufStart( PChar( S ), Level );
  if Result > 0 then
  begin
    Node := Owner.Item[ Result - 1 ];
    OldLevel := Node.Level;
  end;
  if ( Level > OldLevel ) or ( Node = nil ) then
  begin
    if Level - OldLevel > 1 then
      TreeViewError( sInvalidLevel );
  end
  else begin
    for I := OldLevel downto Level do
    begin
      Node := Node.Parent;
      if ( Node = nil ) and ( I - Level > 0 ) then
        TreeViewError( sInvalidLevel );
    end;
  end;
  Owner.AddChild( Node, NewStr );
end;


procedure TCheckTreeStrings.Insert( Index: Integer; const S: string );
begin
  Owner.Insert( Owner.Item[ Index ], S );
end;


procedure TCheckTreeStrings.LoadTreeFromStream( Stream: TStream );
var
  List: TStringList;
  ANode, NextNode: TTreeNode;
  ALevel, I, P, NodeState, NodeImage, NodeImageSel: Integer;
  CurrStr: string;
begin
  List := TStringList.Create;
  Owner.BeginUpdate;
  try
    try
      Clear;
      List.LoadFromStream( Stream );
      ANode := nil;
      for I := 0 to List.Count - 1 do
      begin
        CurrStr := GetBufStart( PChar( List[ I ] ), ALevel );

        NodeState := -1;
        NodeImage := -1;
        NodeImageSel := -1;
        P := Pos( '|', CurrStr );
        if P > 0 then
        begin
          NodeState := StrToInt( Copy( CurrStr, 1, P - 1 ) );
          System.Delete( CurrStr, 1, P );

          P := Pos( '|', CurrStr );
          if P > 0 then
          begin
            NodeImage := StrToInt( Copy( CurrStr, 1, P - 1 ) );
            System.Delete( CurrStr, 1, P );

            P := Pos( '|', CurrStr );
            if P > 0 then
            begin
              NodeImageSel := StrToInt( Copy( CurrStr, 1, P - 1 ) );
              System.Delete( CurrStr, 1, P );
            end;
          end;
        end;

        if ANode = nil then
          ANode := Owner.AddChild( nil, CurrStr )
        else if ANode.Level = ALevel then
          ANode := Owner.AddChild( ANode.Parent, CurrStr )
        else if ANode.Level = ( ALevel - 1 ) then
          ANode := Owner.AddChild( ANode, CurrStr )
        else if ANode.Level > ALevel then
        begin
          NextNode := ANode.Parent;
          while NextNode.Level > ALevel do
            NextNode := NextNode.Parent;
          ANode := Owner.AddChild( NextNode.Parent, CurrStr );
        end
        else
          TreeViewErrorFmt( sInvalidLevelEx, [ ALevel, CurrStr ] );

        if ANode <> nil then
        begin
          ANode.StateIndex := NodeState;
          ANode.ImageIndex := NodeImage;
          ANode.SelectedIndex := NodeImageSel;
        end;
      end;
    finally
      Owner.EndUpdate;
      List.Free;
    end;
  except
    Owner.Owner.Invalidate;  // force repaint on exception
    raise;
  end;
end;


procedure TCheckTreeStrings.SaveTreeToStream( Stream: TStream );
const
  TabChar = #9;
  EndOfLine = #13#10;
var
  I: Integer;
  ANode: TTreeNode;
  NodeState, NodeImage, NodeImageSel, NodeStr: string;
begin
  if Count > 0 then
  begin
    ANode := Owner[ 0 ];
    while ANode <> nil do
    begin
      NodeStr := '';
      for I := 0 to ANode.Level - 1 do
        NodeStr := NodeStr + TabChar;
      NodeState := IntToStr( ANode.StateIndex );
      NodeImage := IntToStr( ANode.ImageIndex );
      NodeImageSel := IntToStr( ANode.SelectedIndex );
      NodeStr := NodeStr + NodeState + '|' + NodeImage + '|' + NodeImageSel + '|' + ANode.Text + EndOfLine;
      Stream.Write( Pointer( NodeStr )^, Length( NodeStr ) );
      ANode := ANode.GetNext;
    end;
  end;
end;




{==========================}
{== TCheckTree Methods ==}
{==========================}

constructor TCheckTree.Create( AOwner: TComponent );
begin
  inherited;

  FAutoSelect := False;
  FHighlightColor := clHighlight;
  FCheckImages := TImageList.Create( Self );
  FCheckImages.Name := 'CheckImages';
  StateImages := FCheckImages;
  InitStateImages;
  FBmpWidth := FCheckImages.Width;

  ReadOnly := True;
  FSuspendCascades := False;
  FCascadeChecks := True;
  FSilentStateChanges := False;
  {&RCI}
end;


procedure TCheckTree.InitStateImages;
const
  BaseColors: array[ 0..6 ] of TColor = ( clWhite, clGray, clRed, clFuchsia, clBlue, clTeal, clOlive );
  ResNames: array[ TCheckBoxState ] of PChar = ( 'CheckCOMMON_CHECKBOX_UNCHECKED',
                                                 'CheckCOMMON_CHECKBOX_CHECKED',
                                                 'CheckCOMMON_CHECKBOX_GRAYED' );
var
  R: TRect;
  ReplaceColors: array[ 0..6 ] of TColor;
  ElementDetails: TThemedElementDetails;
  ChkBmp, ImgBmp: TBitmap;

  function CheckColor( Value: TColor ): TColor;
  begin
    if ( ColorToRGB( Value ) = ColorToRGB( clOlive ) ) or
       ( ColorToRGB( Value ) = ColorToRGB( clGray ) ) then
    begin
      Result := ColorToRGB( Value ) + 1;
    end
    else
      Result := Value;
  end;


begin
  FCheckImages.Clear;

  ChkBmp := TBitmap.Create;
  try
    ChkBmp.Width := 16;
    ChkBmp.Height := 16;
    R := Rect( 0, 0, 16, 16 );

    if ThemeServices.ThemesEnabled then
    begin
      ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedNormal );
      ThemeServices.DrawElement( ChkBmp.Canvas.Handle, ElementDetails, R );
      FCheckImages.Add( ChkBmp, nil );

      ThemeServices.DrawElement( ChkBmp.Canvas.Handle, ElementDetails, R );
      FCheckImages.Add( ChkBmp, nil );

      ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedNormal );
      ThemeServices.DrawElement( ChkBmp.Canvas.Handle, ElementDetails, R );
      FCheckImages.Add( ChkBmp, nil );

      ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedNormal );
      ThemeServices.DrawElement( ChkBmp.Canvas.Handle, ElementDetails, R );
      FCheckImages.Add( ChkBmp, nil );

    end
    else // No Themes, but use HotTrack style check boxes
    begin
      ReplaceColors[ 0 ] := clWindow;
      ReplaceColors[ 1 ] := clBtnShadow;
      ReplaceColors[ 2 ] := clWindow;
      ReplaceColors[ 3 ] := clWindow;
      ReplaceColors[ 4 ] := CheckColor( FHighlightColor );

      ImgBmp := TBitmap.Create;
      try
        ImgBmp.Width := 16;
        ImgBmp.Height := 16;
        ImgBmp.Canvas.Brush.Color := clOlive;
        ImgBmp.Canvas.FillRect( R );

        ChkBmp.Handle := CreateMappedRes( HInstance, ResNames[ cbUnchecked ], BaseColors, ReplaceColors  );
        ImgBmp.Canvas.Draw( 2, 2, ChkBmp );
        FCheckImages.AddMasked( ImgBmp, clOlive );

        ChkBmp.Handle := CreateMappedRes( HInstance, ResNames[ cbUnchecked ], BaseColors, ReplaceColors  );
        ImgBmp.Canvas.Draw( 2, 2, ChkBmp );
        FCheckImages.AddMasked( ImgBmp, clOlive );

        ChkBmp.Handle := CreateMappedRes( HInstance, ResNames[ cbChecked ], BaseColors, ReplaceColors  );
        ImgBmp.Canvas.Draw( 2, 2, ChkBmp );
        FCheckImages.AddMasked( ImgBmp, clOlive );

        ChkBmp.Handle := CreateMappedRes( HInstance, ResNames[ cbGrayed ], BaseColors, ReplaceColors  );
        ImgBmp.Canvas.Draw( 2, 2, ChkBmp );
        FCheckImages.AddMasked( ImgBmp, clOlive );
      finally
        ImgBmp.Free;
      end;
    end;
  finally
    ChkBmp.Free;
  end;

end; {= TCheckTree.InitStateImages =}


destructor TCheckTree.Destroy;
begin
  FCheckImages.Free;
  inherited;
end;


procedure TCheckTree.Loaded;
begin
  inherited;

  UpdateImageWidth;
  {&RV}
end;


procedure TCheckTree.UpdateImageWidth;
begin
  if Images = nil then
    FImageWidth := 0
  else
    FImageWidth := Images.Width;
end;


procedure TCheckTree.SetHighlightColor( Value: TColor );
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    InitStateImages;
    Invalidate;
  end;
end;


procedure TCheckTree.WMPaint( var Msg: TWMPaint );
var
  I: Integer;
begin
  // Since we cannot hook into the TreeNodes themselves, we will hook
  // into the paint processing to ensure that all nodes have their
  // StateIndex set to a valid value.
  for I := 0 to Items.Count - 1 do
  begin
    if Items[ I ].StateIndex = -1 then
      Items[ I ].StateIndex := Ord( csUnchecked );
  end;
  inherited;
end;


function TCheckTree.GetItemState( AbsoluteIndex: Integer ): TCheckCheckState;
begin
  Result := TCheckCheckState( Items[ AbsoluteIndex ].StateIndex );
end;


procedure TCheckTree.SetItemState( AbsoluteIndex: Integer; Value: TCheckCheckState );
begin
  if TCheckCheckState( Items[ AbsoluteIndex ].StateIndex ) <> Value then
    ChangeNodeCheckState( Items[ AbsoluteIndex ], Value );
end;


procedure TCheckTree.SetNodeCheckState( Node:TTreeNode; NewState: TCheckCheckState );
begin
  if CanChangeState( Node, NewState ) then
  begin
    Node.StateIndex := Ord( NewState );
    if not FSilentStateChanges then
      StateChange( Node, NewState );
  end;
end;


function TCheckTree.CanChangeState( Node: TTreeNode; NewState: TCheckCheckState ): Boolean;
begin
  Result := True;
  if not FSilentStateChanges and Assigned( FOnStateChanging ) then
    FOnStateChanging( Self, Node, NewState, Result );
end;


procedure TCheckTree.StateChange( Node: TTreeNode; NewState: TCheckCheckState );
begin
  if Assigned( FOnStateChange ) then
    FOnStateChange( Self, Node, NewState );
end;


// Public method used to set a node and potentially parents in code

procedure TCheckTree.ForceCheckState( Node: TTreeNode;
                                        NewState: TCheckCheckState );
begin
  if Node.StateIndex <> Ord( NewState ) then
  begin
    Node.StateIndex := Ord( NewState );
    if not FSilentStateChanges then
      StateChange( Node, NewState );
  end;
end;


// Toggles state and cascades throughout tree
// The check state is actually stored in the StateIndex field

procedure TCheckTree.ToggleCheckState( Node: TTreeNode );
begin
  FChangingState := False;
  if Node.StateIndex = 0 then
    Exit;

  if Node.StateIndex = STATE_CHECKED then
    SetNodeCheckState( Node, csUnchecked )
  else
    SetNodeCheckState( Node, csChecked );
  if FCascadeChecks then
  begin
    UpdateChildren( Node, Node.StateIndex = STATE_CHECKED );
    UpdateParents( Node, Node.StateIndex = STATE_CHECKED );
  end;
end;


procedure TCheckTree.UpdateCascadingStates( Node: TTreeNode );
begin
  if FCascadeChecks then
  begin
    if ( Node.StateIndex = STATE_CHECKED ) or ( Node.StateIndex = STATE_UNCHECKED ) then
    begin
      UpdateChildren( Node, Node.StateIndex = STATE_CHECKED );
      UpdateParents( Node, Node.StateIndex = STATE_CHECKED );
    end;
  end;
end;


procedure TCheckTree.UpdateChildrenCascadingStates( ParentNode: TTreeNode );
var
  Node: TTreeNode;
begin
  if ( ParentNode = nil ) or not FCascadeChecks then
    Exit;

  Node := ParentNode.GetFirstChild;
  if Node = nil then
    UpdateCascadingStates( ParentNode )
  else
  begin
    while Node <> nil do
    begin
      if Node.HasChildren then
        UpdateChildrenCascadingStates( Node )
      else
        UpdateCascadingStates( Node );
      Node := Node.GetNextSibling;
    end;
  end;
end;



// Changes state and cascades throughout tree
// The check state is actually stored in the StateIndex field

procedure TCheckTree.ChangeNodeCheckState( Node: TTreeNode; NewState: TCheckCheckState );
begin
  FChangingState := False;
  if Node.StateIndex <> Ord( NewState ) then
    SetNodeCheckState( Node, NewState );
  if FCascadeChecks then
  begin
    UpdateChildren( Node, Node.StateIndex = STATE_CHECKED );
    UpdateParents( Node, Node.StateIndex = STATE_CHECKED );
  end;
end;


procedure TCheckTree.UpdateParents( Node: TTreeNode; NodeChecked: Boolean );
var
  CheckedCount, UnCheckedCount, NewState: Integer;
begin
  NewState := STATE_UNCHECKED;

  while ( Node <> nil ) and ( Node.Parent <> nil ) do
  begin
    Node := Node.Parent.GetFirstChild;
    CheckedCount := 0;
    UnCheckedCount := 0;
    while True do
    begin
      Inc( UnCheckedCount, Ord( Node.StateIndex = STATE_UNCHECKED ) );
      Inc( CheckedCount, Ord( Node.StateIndex = STATE_CHECKED ) );
      if ( Node.StateIndex = STATE_PARTCHECKED ) or
         ( ( CheckedCount > 0 ) and ( UnCheckedCount > 0 ) ) then
      begin
        NewState := STATE_PARTCHECKED;
        Break;
      end;
      if Node.GetNextSibling = nil then
      begin
        if CheckedCount > 0 then
          NewState := STATE_CHECKED
        else
          NewState := STATE_UNCHECKED;
        Break;
      end
      else
        Node := Node.GetNextSibling;
    end;
    Node := Node.Parent;
    if Node <> nil then
      SetNodeCheckState( Node, TCheckCheckState( NewState ) );
  end;
end;


procedure TCheckTree.RecurseChildren( Node: TTreeNode; NodeChecked: Boolean );
begin
  while Node <> nil do
  begin
    if NodeChecked then
      SetNodeCheckState( Node, csChecked )
    else
      SetNodeCheckState( Node, csUnchecked );
    if Node.GetFirstChild <> nil then
      RecurseChildren( Node.GetFirstChild, NodeChecked );
    Node := Node.GetNextSibling;
  end;
end;


procedure TCheckTree.UpdateChildren( Node: TTreeNode; NodeChecked: Boolean );
var
  WasSuspended: Boolean;
begin
  WasSuspended := FSuspendCascades;
  FSuspendCascades := True;
  RecurseChildren( Node.GetFirstChild, NodeChecked );
  FSuspendCascades := WasSuspended;

  if Assigned( FOnUpdateChildren ) then
    FOnUpdateChildren( Self );
end;


procedure TCheckTree.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  R: TRect;
  Idx: Integer;
begin
  if Selected <> nil then
  begin
    if Selected.AbsoluteIndex > -1 then
    begin
      Idx := Selected.AbsoluteIndex;
      R := Selected.DisplayRect( True );
      if ( Button = mbLeft ) and ( X <= R.Left - FImageWidth ) and
         ( X > R.Left - FBmpWidth - FImageWidth ) and
         ( Y >= R.Top ) and ( Y <= R.Bottom ) then
      begin
        FChangingState := True;
        FSelectedItem := Idx;
      end;
    end;
  end;
  inherited;
end;


procedure TCheckTree.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  if ( Button = mbLeft ) and FChangingState and ( Selected.AbsoluteIndex = FSelectedItem ) and
     PtInRect( ClientRect, Point( X, Y ) ) then
  begin
    ToggleCheckState( Selected );
  end;
  inherited;
end;


procedure TCheckTree.KeyUp( var Key: Word; Shift: TShiftState );
begin
  if ( Key = vk_Space ) and not IsEditing and ( Selected <> nil ) then
    ToggleCheckState( Selected );
  inherited;
end;


procedure TCheckTree.WMChar( var Msg: TWMChar );
begin
  if Msg.CharCode <> vk_Space then
    inherited;
end;


procedure TCheckTree.SetAllChildren( Node: TTreeNode; NewState: TCheckCheckState );
begin
  while Node <> nil do
  begin
    Node.StateIndex := Ord( NewState );
    if Node.GetFirstChild <> nil then
      SetAllChildren( Node.GetFirstChild, NewState );          // Recursive call
    Node := Node.GetNextSibling;
  end;
end;


procedure TCheckTree.SetAllNodes( NewState: TCheckCheckState );
begin
  SetAllChildren( Items[ 0 ], NewState );
end;


function TCheckTree.GetImages: TCustomImageList;
begin
  Result := inherited Images;
end;


procedure TCheckTree.SetImages( Value: TCustomImageList );
begin
  inherited Images := Value;
  UpdateImageWidth;
end;


procedure TCheckTree.LoadFromFile( const FileName: string );
var
  Stream: TStream;
begin
  Stream := TFileStream.Create( FileName, fmOpenRead );
  try
    LoadFromStream( Stream );
  finally
    Stream.Free;
  end;
end;


procedure TCheckTree.LoadFromStream( Stream: TStream );
var
  S: TCheckTreeStrings;
begin
  S := TCheckTreeStrings.Create( Items );
  try
    S.LoadTreeFromStream( Stream );
  finally
    S.Free;
  end;
end;


procedure TCheckTree.SaveToFile( const FileName: string );
var
  Stream: TStream;
begin
  Stream := TFileStream.Create( FileName, fmCreate );
  try
    SaveToStream( Stream );
  finally
    Stream.Free;
  end;
end;


procedure TCheckTree.SaveToStream( Stream: TStream );
var
  S: TCheckTreeStrings;
begin
  S := TCheckTreeStrings.Create( Items );
  try
    S.SaveTreeToStream( Stream );
  finally
    S.Free;
  end;
end;


{&RUIF}
end.
