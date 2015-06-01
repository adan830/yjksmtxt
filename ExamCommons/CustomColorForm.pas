unit CustomColorForm;
///from http://www.138soft.com
///  自定义窗口基类
interface

uses Windows,Messages,Vcl.Graphics,Vcl.Imaging.pngimage,System.Classes,Vcl.Controls, Vcl.Forms;
type
  TCustomColorForm = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    m_BackColor: TColorRef;
    //m_BackBMP: TBitmap;

    btn_min_down, btn_min_highlight, btn_min_normal: TPngImage;
    btn_max_down, btn_max_highlight, btn_max_normal: TPngImage;
    btn_Restore_down, btn_Restore_highlight, btn_Restore_normal: TPngImage;
    btn_close_down, btn_close_highlight, btn_close_normal: TPngImage;

    m_MiniButtonHover, m_MiniButtonDown: Boolean;
    m_MaxButtonHover, m_MaxButtonDown: Boolean;
    m_CloseButtonHover, m_CloseButtonDown: Boolean;

    function GetRectMiniButton: TRect;
    function GetRectMaxButton: TRect;
    function GetRectCloseButton: TRect;
  private
    { Private declarations }
    procedure WMNCCALCSIZE(var Message: TWMNCCALCSIZE); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMNCActivate(var Message: TWMNCActivate); message WM_NCACTIVATE;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHITTEST); message WM_NCHITTEST;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMGETMINMAXINFO(var Message: TMessage); message WM_GETMINMAXINFO;
    procedure WMNCMouseMove(var Message: TWMNCMousemove); message WM_NCMOUSEMOVE;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCLButtonUp(var Message: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure WMNCLBUTTONDBLCLK(var Message: TWMNCLButtonDblClk); message WM_NCLBUTTONDBLCLK;
    procedure WMLBUTTONUP(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure OnButtonUp(P: TPoint);
    procedure DrawClient(DC: HDC);
    procedure DrawTitle;
  protected
    procedure DoCreate; override;

  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }

  published

  end;


implementation

uses System.SysUtils,FormBmpUtils,System.Types;
const
  xTitleHeight: Integer = 50; //标题栏的高度
  xFramWidth: Integer = 10; //左、右、下边框的厚度
  xHitTestWidth: Integer = 5; //HitTest预留厚度

procedure TCustomColorForm.WMNCCALCSIZE(var Message: TWMNCCALCSIZE);
begin

    with TWMNCCALCSIZE(Message).CalcSize_Params^.rgrc[0] do
    begin
      Inc(Left, xFramWidth);
      Inc(Top, xTitleHeight);
      Dec(Right, xFramWidth);
      Dec(Bottom, xFramWidth);
    end;


  Message.Result := 0;
end;

procedure TCustomColorForm.DrawTitle;
var
  TitleBmp: TBitmap;
  DC: HDC;
  C: TCanvas;
var
  R: TRect;
  Style: DWORD;
begin
  TitleBmp := TBitmap.Create;
  TitleBmp.Width := Width;
  TitleBmp.Height := xTitleHeight;

  TitleBmp.Canvas.Brush.Color := m_BackColor;
  TitleBmp.Canvas.FillRect(Rect(0, 0, Width, xTitleHeight));//先用平均颜色填充整个标题区

  DC := GetWindowDC(Handle);
  C := TControlCanvas.Create;
  C.Handle := DC;
  try
    (*
        C.Brush.Color := clRed;
        C.FillRect(Rect(0, 0, Width, xTitleHeight)); //标题区域

        C.Brush.Color := clBlue;
        C.FillRect(Rect(0, xTitleHeight, xFramWidth, Height - xFramWidth)); //左边框

        C.Brush.Color := clGreen;
        C.FillRect(Rect(Width - xFramWidth, xTitleHeight, Width, Height - xFramWidth)); //右边框

        C.Brush.Color := clYellow;
        C.FillRect(Rect(0, Height - xFramWidth, Width, Height)); //下边框
       *)
       if m_BackColor=0 then
              exit;
      C.Brush.Color := m_BackColor;

      //BitBlt(TitleBmp.Canvas.Handle, 0, 0, Width, xTitleHeight, m_BackBMP.Canvas.Handle, 0, 0, SRCCOPY);
      DrawIconEx(TitleBmp.Canvas.Handle, 6, 6, Application.Icon.Handle, 16, 16, 0, 0, DI_NORMAL);
      TitleBmp.Canvas.Font.Assign(Font);
      TitleBmp.Canvas.Brush.Style := bsClear;
      ExtTextOut(TitleBmp.Canvas.Handle, 26, 6, TitleBmp.Canvas.TextFlags, nil, PChar(Caption), Length(Caption), nil);

         if biMinimize in self.BorderIcons then
         begin
             R := GetRectMiniButton;
              if m_MiniButtonDown then
              begin
                TitleBmp.Canvas.Draw(R.Left, R.Top, btn_min_down)
              end
              else if m_MiniButtonHover then
              begin
                TitleBmp.Canvas.Draw(R.Left, R.Top - 1, btn_min_highlight);
              end
              else
                TitleBmp.Canvas.Draw(R.Left, R.Top, btn_min_normal);
         end;

      if biMaximize in self.BorderIcons then
      begin
        R := GetRectMaxButton;

        Style := GetWindowLong(Handle, GWL_STYLE);
        if Style and WS_MAXIMIZE > 0 then
        begin
          if m_MaxButtonDown then
          begin
            TitleBmp.Canvas.Draw(R.Left, R.Top, btn_Restore_down)
          end
          else if m_MaxButtonHover then
          begin
            TitleBmp.Canvas.Draw(R.Left, R.Top - 1, btn_Restore_highlight);
          end
          else
            TitleBmp.Canvas.Draw(R.Left, R.Top, btn_Restore_normal);
        end
        else
        begin
          if m_MaxButtonDown then
          begin
            TitleBmp.Canvas.Draw(R.Left, R.Top, btn_max_down)
          end
          else if m_MaxButtonHover then
          begin
            TitleBmp.Canvas.Draw(R.Left, R.Top - 1, btn_max_highlight);
          end
          else
            TitleBmp.Canvas.Draw(R.Left, R.Top, btn_max_normal);
        end;
      end;

      R := GetRectCloseButton;
      if m_CloseButtonDown then
      begin
        TitleBmp.Canvas.Draw(R.Left, R.Top, btn_close_down);
      end
      else if m_CloseButtonHover then
      begin
        TitleBmp.Canvas.Draw(R.Left, R.Top - 1, btn_close_highlight);
      end
      else
        TitleBmp.Canvas.Draw(R.Left, R.Top, btn_close_normal);


      C.FillRect(Rect(0, 0, Width, xTitleHeight)); //标题区域
      BitBlt(DC, 0, 0, Width, xTitleHeight, TitleBmp.Canvas.Handle, 0, 0, SRCCOPY);

//      C.FillRect(Rect(0, xTitleHeight, xFramWidth, Height - xFramWidth)); //左边框
//      BitBlt(DC, 0, xTitleHeight, xFramWidth, Height - xFramWidth, m_BackBMP.Canvas.Handle, 0, xTitleHeight, SRCCOPY);
//
//      C.FillRect(Rect(Width - xFramWidth, xTitleHeight, Width, Height - xFramWidth)); //右边框
//      BitBlt(DC, Width - xFramWidth, xTitleHeight, Width, Height - xFramWidth, m_BackBMP.Canvas.Handle, Width - xFramWidth, xTitleHeight, SRCCOPY);
//
//      C.FillRect(Rect(0, Height - xFramWidth, Width, Height)); //下边框
//      BitBlt(DC, 0, Height - xFramWidth, Width, Height, m_BackBMP.Canvas.Handle, 0, Height - xFramWidth, SRCCOPY);


  finally
    C.Handle := 0;
    C.Free;
    ReleaseDC(Handle, DC);
    TitleBmp.Free;
  end;
end;

procedure TCustomColorForm.WMNCPaint(var Message: TWMNCPaint);
begin
  DrawTitle;
  Message.Result := 1;
end;

procedure TCustomColorForm.WMNCActivate(var Message: TWMNCActivate);
begin
  DrawTitle;
  Message.Result := 1;
end;

procedure TCustomColorForm.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  PS: TPaintStruct;
begin
  inherited;//调用系统默认处理。假如不处理，对于窗口上放置的从TGraphicControl继承下来的无句柄控件将无法显示。
  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);

  DrawClient(DC);

  if DC = 0 then EndPaint(Handle, PS);
  Message.Result := 1;
end;

procedure TCustomColorForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  DC: HDC;
begin
  DC := Message.DC;
  if DC <> 0 then DrawClient(DC);
  Message.Result := 1;
end;

procedure TCustomColorForm.WMActivate(var Message: TWMActivate);
begin
  inherited;
  DrawTitle;
end;

procedure TCustomColorForm.WMNCHitTest(var Message: TWMNCHITTEST);
var
  P: TPoint;
  R: TRect;
begin
  P := Point(Message.XPos - Left, Message.YPos - Top);
  if biMinimize in self.BorderIcons  then
  begin
    R := GetRectMiniButton;
    Inc(R.Top, xHitTestWidth);
    if PtInRect(R, P) then
    begin
      Message.Result := HTMINBUTTON;
        Exit;
    end;
  end;

  if biMaximize in BorderIcons then
  begin
     R := GetRectMaxButton;
    Inc(R.Top, xHitTestWidth);
    if PtInRect(R, P) then
    begin
      Message.Result := HTMAXBUTTON;
      Exit;
    end;
  end;


  R := GetRectCloseButton;
  Inc(R.Top, xHitTestWidth);
  Dec(R.Right, xHitTestWidth);
  if PtInRect(R, P) then
  begin
    Message.Result := HTCLOSE;
    Exit;
  end;
  if  (biMaximize in BorderIcons)  then
  begin
    if PtInRect(Rect(0, 0, xHitTestWidth, xHitTestWidth), P) and (WindowState <> wsMaximized) then Message.Result := HTTOPLEFT //左上角
    else if PtInRect(Rect(xHitTestWidth, 0, Width - xHitTestWidth, xHitTestWidth), P) and (WindowState <> wsMaximized) then Message.Result := HTTOP //上边
    else if PtInRect(Rect(Width - xHitTestWidth, 0, xHitTestWidth, xHitTestWidth), P) and (WindowState <> wsMaximized) then Message.Result := HTTOPRIGHT //右上角
    else if PtInRect(Rect(Width - xHitTestWidth, xHitTestWidth, Width, Height - xHitTestWidth), P) and (WindowState <> wsMaximized) then Message.Result := HTRIGHT //右边
    else if PtInRect(Rect(Width - xHitTestWidth, Height - xHitTestWidth, Width, Height), P)and (WindowState <> wsMaximized)  then Message.Result := HTBOTTOMRIGHT //右下角
    else if PtInRect(Rect(xHitTestWidth, Height - xHitTestWidth, Width - xHitTestWidth, Height), P)and (WindowState <> wsMaximized)  then Message.Result := HTBOTTOM //下边
    else if PtInRect(Rect(0, Height - xHitTestWidth, xHitTestWidth, Height), P)and (WindowState <> wsMaximized)  then Message.Result := HTBOTTOMLEFT //左下角
    else if PtInRect(Rect(0, xHitTestWidth, xHitTestWidth, Height - xHitTestWidth), P)and (WindowState <> wsMaximized)  then Message.Result := HTLEFT //左边
    else if PtInRect(Rect(0, 0, Width, xTitleHeight), P) then Message.Result := HTCAPTION //标题栏
    else inherited;
  end else
  begin
    if PtInRect(Rect(0, 0, Width, xTitleHeight), P) then Message.Result := HTCAPTION //标题栏
    else inherited;
  end;
end;

procedure TCustomColorForm.WMNCLBUTTONDBLCLK(var Message: TWMNCLButtonDblClk);
var
  P: TPoint;
  Style: DWORD;
begin
  inherited;
  if biMaximize in BorderIcons then
  begin
    P := Point(Message.XCursor - Left, Message.YCursor - Top);
    if PtInRect(Rect(0, 0, Width, xTitleHeight), P) then
    begin
      Style := GetWindowLong(Handle, GWL_STYLE);
      if Style and WS_MAXIMIZE > 0 then
        SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0)
      else
        SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    end;
  end;
end;

procedure TCustomColorForm.WMSize(var Message: TWMSize);
var
   Rgn: HRGN;
begin
  inherited;
  DrawTitle;
  Rgn := CreateRoundRectRgn(0, 0, Width, Height, 5, 5);
  SetWindowRgn(Handle, Rgn, True);
  DeleteObject(Rgn);
end;


constructor TCustomColorForm.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TCustomColorForm.DoCreate;
begin
  inherited;
  //  m_BackBMP := TBitmap.Create;
//  m_BackBMP.LoadFromResourceName(HInstance,'ClassicSkin_bmp_Theme');
//  FormBmpUtils.MakeBmp(m_BackBMP, m_BackColor);
  m_BackColor:=clGreen;
  if biMinimize in self.BorderIcons then
  begin
     btn_min_down := TPngImage.Create;
    btn_min_down.LoadFromResourceName(HInstance,'ClassicSkin_Png_Min_Down'); //.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Min_Down.png');

    btn_min_highlight := TPngImage.Create;
    btn_min_highlight.LoadFromResourceName(HInstance,'ClassicSkin_Png_Min_Hover'); //btn_min_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Min_Hover.png');

    btn_min_normal := TPngImage.Create;
    btn_min_normal.LoadFromResourceName(HInstance,'ClassicSkin_Png_Min_Normal'); //btn_min_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Min_Normal.png');
  end;


  btn_max_down := TPngImage.Create;
  btn_max_down.LoadFromResourceName(HInstance,'ClassicSkin_Png_Max_Down'); //btn_max_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Max_Down.png');

  btn_max_highlight := TPngImage.Create;
  btn_max_highlight.LoadFromResourceName(HInstance,'ClassicSkin_Png_Max_Hover'); //btn_max_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Max_Hover.png');

  btn_max_normal := TPngImage.Create;
  btn_max_normal.LoadFromResourceName(HInstance,'ClassicSkin_Png_Max_Normal'); //btn_max_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Max_Normal.png');


  btn_Restore_down := TPngImage.Create;
  btn_Restore_down.LoadFromResourceName(HInstance,'ClassicSkin_Png_Restore_Down'); //btn_Restore_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Restore_Down.png');

  btn_Restore_highlight := TPngImage.Create;
  btn_Restore_highlight.LoadFromResourceName(HInstance,'ClassicSkin_Png_Restore_Hover'); //btn_Restore_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Restore_Hover.png');

  btn_Restore_normal := TPngImage.Create;
  btn_Restore_normal.LoadFromResourceName(HInstance,'ClassicSkin_Png_Restore_Normal'); //btn_Restore_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Restore_Normal.png');


  btn_close_down := TPngImage.Create;
  btn_close_down.LoadFromResourceName(HInstance,'ClassicSkin_Png_Close_Down'); //btn_close_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Close_Down.png');

  btn_close_highlight := TPngImage.Create;
  btn_close_highlight.LoadFromResourceName(HInstance,'ClassicSkin_Png_Close_Hover'); //btn_close_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Close_Hover.png');

  btn_close_normal := TPngImage.Create;
  btn_close_normal.LoadFromResourceName(HInstance,'ClassicSkin_Png_Close_Normal'); //btn_close_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Close_Normal.png');

end;

procedure TCustomColorForm.DrawClient(DC: HDC);
var
  C: TCanvas;
begin
  C := TControlCanvas.Create;
  C.Handle := DC;
  try
    (*
        C.Brush.Color := clDkGray;
        C.FillRect(ClientRect);
    *)
    if Assigned(m_BackBMP) then
    begin
      C.Brush.Color := m_BackColor;
      C.FillRect(ClientRect);
      BitBlt(C.Handle, 0, 0, ClientWidth, ClientHeight, m_BackBMP.Canvas.Handle, xFramWidth, xTitleHeight, SRCCOPY);
    end;
  finally
    C.Handle := 0;
    C.Free;
  end;
end;

procedure TCustomColorForm.FormDestroy(Sender: TObject);
begin
  //m_BackBMP.Free;

  btn_min_down.Free;
  btn_min_highlight.Free;
  btn_min_normal.Free;

  btn_max_down.Free;
  btn_max_highlight.Free;
  btn_max_normal.Free;

  btn_Restore_down.Free;
  btn_Restore_highlight.Free;
  btn_Restore_normal.Free;

  btn_close_down.Free;
  btn_close_highlight.Free;
  btn_close_normal.Free;
end;

procedure TCustomColorForm.WMGETMINMAXINFO(var Message: TMessage);
var
  Rect: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Rect, 0);
  with PMINMAXINFO(Message.LParam)^ do
  begin
    //ptReserved: TPoint;//保留不用

    ptMaxSize.X := Rect.Right; //最大范围
    ptMaxSize.Y := Rect.Bottom;

    ptMaxPosition.X := 0; //最大的放置点
    ptMaxPosition.Y := 0;

    ptMinTrackSize.X := 200; //最小拖动范围
    ptMinTrackSize.Y := xTitleHeight;

    //ptMaxTrackSize: TPoint;//最大拖动范围
  end;
end;

procedure TCustomColorForm.OnButtonUp(P: TPoint);
var
  Style: DWORD;
begin
  if (biMinimize in self.BorderIcons) and PtInRect(GetRectMiniButton, P) and m_MiniButtonDown then
  begin
    ReleaseCapture;
    m_MiniButtonDown := False;
    DrawTitle;
    SendMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    Exit;
  end
  else if (biMaximize in BorderIcons) and  PtInRect(GetRectMaxButton, P) and m_MaxButtonDown then
  begin
    ReleaseCapture;
    m_MaxButtonDown := False;
    //    DrawTitle;
    Style := GetWindowLong(Handle, GWL_STYLE);
    if Style and WS_MAXIMIZE > 0 then SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0)
    else
      SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    Exit;
  end
  else if PtInRect(GetRectCloseButton, P) and m_CloseButtonDown then
  begin
    ReleaseCapture;
    m_CloseButtonDown := False;
    DrawTitle;
    SendMessage(Handle, WM_SYSCOMMAND, SC_CLOSE, 0);
    Exit;
  end;

  if m_MiniButtonDown or m_MaxButtonDown or m_CloseButtonDown then
  begin
    ReleaseCapture;
    m_MiniButtonDown := False;
    m_MaxButtonDown := False;
    m_CloseButtonDown := False;
    DrawTitle;
  end;
end;


procedure TCustomColorForm.WMLBUTTONUP(var Message: TWMLButtonUp);
var
  P: TPoint;
begin
  inherited;
  P.X := Mouse.CursorPos.X - Left;
  P.Y := Mouse.CursorPos.Y - Top;
  OnButtonUp(P);
end;

procedure TCustomColorForm.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  if (Message.HitTest = HTCAPTION) and (WindowState = wsMaximized) then
  begin
    Exit;
  end;

  if Message.HitTest = HTMINBUTTON then
  begin
    m_MiniButtonDown := True;
    SetCapture(Self.Handle);
    DrawTitle;
  end
  else if Message.HitTest = HTMAXBUTTON then
  begin
    m_MaxButtonDown := True;
    SetCapture(Self.Handle);
    DrawTitle;
  end
  else if Message.HitTest = HTCLOSE then
  begin
    m_CloseButtonDown := True;
    SetCapture(Self.Handle);
    DrawTitle;
  end
  else
    inherited;
end;

procedure TCustomColorForm.WMNCLButtonUp(var Message: TWMNCLButtonUp);
var
  P: TPoint;
begin
  DefaultHandler(Message);
  P.X := Mouse.CursorPos.X - Left;
  P.Y := Mouse.CursorPos.Y - Top;
  OnButtonUp(P);
end;

procedure TCustomColorForm.WMNCMouseMove(var Message: TWMNCMousemove);
var
  P: TPoint;
  R: TRect;
begin
  P.X := Mouse.CursorPos.X - Left;
  P.Y := Mouse.CursorPos.Y - Top;
  if biMinimize in self.BorderIcons  then
  begin
    R := GetRectMiniButton;
    Inc(R.Top,xHitTestWidth);
    if PtInRect(R, P) then
    begin
      if m_CloseButtonHover then m_CloseButtonHover := False;
      if m_MaxButtonHover then m_MaxButtonHover := False;
      if not m_MiniButtonHover then
      begin
        m_MiniButtonHover := True;
        DrawTitle;
        //Timer1.Enabled := True;
        Exit;
      end;
    end;
  end;

  if biMaximize in BorderIcons then
  begin
    R := GetRectMaxButton;
    Inc(R.Top,xHitTestWidth);
    if PtInRect(R, P) then
    begin
      if m_MiniButtonHover then m_MiniButtonHover := False;
      if m_MaxButtonHover then m_MaxButtonHover := False;
      if not m_MaxButtonHover then
      begin
        m_MaxButtonHover := True;
        DrawTitle;
        //Timer1.Enabled := True;
        Exit;
      end;
    end;
  end;


  R := GetRectCloseButton;
  Inc(R.Top,xHitTestWidth); Dec(R.Right,xHitTestWidth);
  if PtInRect(R, P) then
  begin
    if m_MiniButtonHover then m_MiniButtonHover := False;
    if m_MaxButtonHover then m_MaxButtonHover := False;
    if not m_CloseButtonHover then
    begin
      m_CloseButtonHover := True;
      DrawTitle;
      //Timer1.Enabled := True;
    end;
  end;
end;

procedure TCustomColorForm.Timer1Timer(Sender: TObject);
var
  P: TPoint;
  R: TRect;
begin
  P.X := (Mouse.CursorPos).X - Left;
  P.Y := (Mouse.CursorPos).Y - Top;

  R := GetRectCloseButton;
  Inc(R.Top, xHitTestWidth); Dec(R.Right, xHitTestWidth);
  if not PtInRect(R, P) then
  begin
    if m_CloseButtonHover then
    begin
      m_CloseButtonHover := False;
      //Timer1.Enabled := False;
      DrawTitle;
    end;
  end;

  R := GetRectMaxButton;
  Inc(R.Top, xHitTestWidth);
  if not PtInRect(R, P) then
  begin
    if m_MaxButtonHover then
    begin
      m_MaxButtonHover := False;
      //Timer1.Enabled := False;
      DrawTitle;
    end;
  end;

  R := GetRectMiniButton;
  Inc(R.Top, xHitTestWidth);
  if not PtInRect(R, P) then
  begin
    if m_MiniButtonHover then
    begin
      m_MiniButtonHover := False;
      //Timer1.Enabled := False;
      DrawTitle;
    end;
  end;
end;

function TCustomColorForm.GetRectCloseButton: TRect;
begin
  Result := Rect(Width - btn_close_normal.Width, 0, Width, btn_close_normal.Height);
end;

function TCustomColorForm.GetRectMaxButton: TRect;
begin
  Result := GetRectCloseButton;
    Dec(Result.Left, btn_max_normal.Width);
    Dec(Result.Right, btn_max_normal.Width);
end;

function TCustomColorForm.GetRectMiniButton: TRect;
begin
  if biMaximize in BorderIcons then
    Result:=  GetRectMaxButton
  else
    Result:= GetRectCloseButton;

  Dec(Result.Left, btn_min_normal.Width);
  Dec(Result.Right, btn_min_normal.Width);
end;

end.
