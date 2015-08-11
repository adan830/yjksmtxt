unit CustomLoginForm;

/// from http://www.138soft.com
/// 自定义窗口基类
interface

   uses Windows, Messages, Vcl.Graphics, Vcl.Imaging.pngimage, System.Classes, Vcl.Controls, Vcl.Forms, ShadowFrame;

   type
      TColor32 = record
         b, g, r, a: Byte;
      end;

      PColor32 = ^TColor32;

      TCustomLoginForm = class(TForm)
         procedure Timer1Timer(Sender: TObject);
         private
            FShadowed                                                  : Boolean;
            ShadowFrame                                                : TShadowFrame;
            m_BackColor                                                : TColorRef;
            m_BackBMP                                                  : TBitmap;
            btn_min_down, btn_min_highlight, btn_min_normal            : TPngImage;
            btn_max_down, btn_max_highlight, btn_max_normal            : TPngImage;
            btn_Restore_down, btn_Restore_highlight, btn_Restore_normal: TPngImage;
            btn_close_down, btn_close_highlight, btn_close_normal      : TPngImage;

            m_MiniButtonHover, m_MiniButtonDown  : Boolean;
            m_MaxButtonHover, m_MaxButtonDown    : Boolean;
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

            procedure SetShadowed(const Value: Boolean);

            procedure GaussianBlur(Bmp: TBitmap; Amount: Integer);
            procedure Blur(SrcBmp: TBitmap);
            procedure RGB2BGR(const Bitmap: TBitmap);
            procedure Grayscale(const Bitmap: TBitmap);
            procedure Negative(Bmp: TBitmap);
            procedure DrawShadow(canvas: TCanvas; rect: TRect; direction: Integer);
            procedure AlphaBlendDraw(destCanvas: TCanvas);
            procedure DrawAlphaBlend(destHandle: hwnd; sourceDc: HDC);
         protected
            procedure InitializeNewForm; override;
         public
            destructor Destroy; override;

            property Shadowed: Boolean read FShadowed write SetShadowed;

         published

      end;

implementation

   uses System.SysUtils, FormBmpUtils, System.Types;

   const
      xTitleHeight: Integer  = 108; // 标题栏的高度
      xFramWidth: Integer    = 0;   // 左、右、下边框的厚度
      xHitTestWidth: Integer = 5;   // HitTest预留厚度

   procedure TCustomLoginForm.WMNCCALCSIZE(var Message: TWMNCCALCSIZE);
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

   procedure TCustomLoginForm.DrawTitle;
      var
         TitleBmp: TBitmap;
         DC      : HDC;
         C       : TCanvas;
      var
         r          : TRect;
         Style      : DWORD;
         BrushHandle: HBRUSH;
      begin
         TitleBmp                    := TBitmap.Create;
         TitleBmp.Width              := Width;
         TitleBmp.Height             := xTitleHeight;
         TitleBmp.Transparent        := True;
         TitleBmp.TransparentColor   := clBlack;
         TitleBmp.canvas.Brush.Style := bsSolid;
         TitleBmp.canvas.Brush.Color := clBlack;
         TitleBmp.canvas.FillRect(TitleBmp.canvas.ClipRect);

         // TitleBmp.Canvas.Brush.Color := m_BackColor;
         // TitleBmp.Canvas.FillRect(Rect(0, 0, Width, xTitleHeight));//先用平均颜色填充整个标题区

         DC       := GetWindowDC(Handle);
         C        := TControlCanvas.Create;
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
            if Assigned(m_BackBMP) then
            begin
               // BitBlt(TitleBmp.Canvas.Handle, 0, 0, Width, xFramWidth, m_BorderYYTopPng.Canvas.Handle, 0, 0, SRCCOPY);

               BitBlt(TitleBmp.canvas.Handle, 0, 0, Width, xTitleHeight, m_BackBMP.canvas.Handle, 0, 0, SRCCOPY);

               if biMinimize in self.BorderIcons then
               begin
                  r := GetRectMiniButton;
                  if m_MiniButtonDown then
                  begin
                     TitleBmp.canvas.Draw(r.Left, r.Top, btn_min_down)
                  end else if m_MiniButtonHover then
                  begin
                     TitleBmp.canvas.Draw(r.Left, r.Top - 1, btn_min_highlight);
                  end
                  else
                     TitleBmp.canvas.Draw(r.Left, r.Top, btn_min_normal);
               end;

               if biMaximize in self.BorderIcons then
               begin
                  r := GetRectMaxButton;

                  Style := GetWindowLong(Handle, GWL_STYLE);
                  if Style and WS_MAXIMIZE > 0 then
                  begin
                     if m_MaxButtonDown then
                     begin
                        TitleBmp.canvas.Draw(r.Left, r.Top, btn_Restore_down)
                     end else if m_MaxButtonHover then
                     begin
                        TitleBmp.canvas.Draw(r.Left, r.Top - 1, btn_Restore_highlight);
                     end
                     else
                        TitleBmp.canvas.Draw(r.Left, r.Top, btn_Restore_normal);
                  end else begin
                     if m_MaxButtonDown then
                     begin
                        TitleBmp.canvas.Draw(r.Left, r.Top, btn_max_down)
                     end else if m_MaxButtonHover then
                     begin
                        TitleBmp.canvas.Draw(r.Left, r.Top - 1, btn_max_highlight);
                     end
                     else
                        TitleBmp.canvas.Draw(r.Left, r.Top, btn_max_normal);
                  end;
               end;

               r := GetRectCloseButton;
               if m_CloseButtonDown then
               begin
                  TitleBmp.canvas.Draw(r.Left, r.Top, btn_close_down);
               end else if m_CloseButtonHover then
               begin
                  TitleBmp.canvas.Draw(r.Left, r.Top - 1, btn_close_highlight);
               end
               else
                  TitleBmp.canvas.Draw(r.Left, r.Top, btn_close_normal);

               // C.FillRect(Rect(0, 0, Width, xTitleHeight)); //标题区域
               // BitBlt(DC, xFramWidth, xFramWidth, Width, xTitleHeight, TitleBmp.Canvas.Handle, 0, 0, SRCCOPY);
               BitBlt(DC, xFramWidth, xFramWidth, Width, xTitleHeight, TitleBmp.canvas.Handle, 0, 0, SRCCOPY);

               // TitleBmp.SaveToFile('title.bmp');
               // C.FillRect(Rect(0, xTitleHeight, xFramWidth, Height - xFramWidth)); //左边框
               // BitBlt(DC, 0, xTitleHeight, xFramWidth, Height - xFramWidth, m_BackBMP.Canvas.Handle, 0, xTitleHeight, SRCCOPY);
               //
               // C.FillRect(Rect(Width - xFramWidth, xTitleHeight, Width, Height - xFramWidth)); //右边框
               // BitBlt(DC, Width - xFramWidth, xTitleHeight, Width, Height - xFramWidth, m_BackBMP.Canvas.Handle, Width - xFramWidth, xTitleHeight, SRCCOPY);
               //
               // C.FillRect(Rect(0, Height - xFramWidth, Width, Height)); //下边框
               // BitBlt(DC, 0, Height - xFramWidth, Width, Height, m_BackBMP.Canvas.Handle, 0, Height - xFramWidth, SRCCOPY);
            end;

         finally
            C.Handle := 0;
            C.Free;
            ReleaseDC(Handle, DC);
            TitleBmp.Free;
         end;
      end;

   procedure TCustomLoginForm.WMNCPaint(var Message: TWMNCPaint);
      begin
         DrawTitle;
         Message.Result := 1;
      end;

   procedure TCustomLoginForm.WMNCActivate(var Message: TWMNCActivate);
      begin
         if Message.Active then
            DrawTitle;
         Message.Result := 1;
      end;

   procedure TCustomLoginForm.WMPaint(var Message: TWMPaint);
      var
         DC: HDC;
         PS: TPaintStruct;
      begin
         inherited; // 调用系统默认处理。假如不处理，对于窗口上放置的从TGraphicControl继承下来的无句柄控件将无法显示。
         DC := Message.DC;
         if DC = 0 then
            DC := BeginPaint(Handle, PS);

         DrawClient(DC);

         if DC = 0 then
            EndPaint(Handle, PS);
         Message.Result := 1;
      end;

   procedure TCustomLoginForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
      var
         DC: HDC;
      begin
         DC := Message.DC;
         if DC <> 0 then
            DrawClient(DC);
         Message.Result := 1;
      end;

   procedure TCustomLoginForm.WMActivate(var Message: TWMActivate);
      begin
         inherited;
//         if mess then

         //DrawTitle;
      end;

   procedure TCustomLoginForm.WMNCHitTest(var Message: TWMNCHITTEST);
      var
         P: TPoint;
         r: TRect;
      begin
         P := Point(Message.XPos - Left, Message.YPos - Top);
         if biMinimize in self.BorderIcons then
         begin
            r := GetRectMiniButton;
            Inc(r.Top, xHitTestWidth);
            if PtInRect(r, P) then
            begin
               Message.Result := HTMINBUTTON;
               Exit;
            end;
         end;

         if biMaximize in BorderIcons then
         begin
            r := GetRectMaxButton;
            Inc(r.Top, xHitTestWidth);
            if PtInRect(r, P) then
            begin
               Message.Result := HTMAXBUTTON;
               Exit;
            end;
         end;

         r := GetRectCloseButton;
         Inc(r.Top, xHitTestWidth);
         Dec(r.Right, xHitTestWidth);
         if PtInRect(r, P) then
         begin
            Message.Result := HTCLOSE;
            Exit;
         end;
         if (biMaximize in BorderIcons) then
         begin
            if PtInRect(rect(0, 0, xHitTestWidth, xHitTestWidth), P) and (WindowState <> wsMaximized) then
               Message.Result := HTTOPLEFT // 左上角
            else if PtInRect(rect(xHitTestWidth, 0, Width - xHitTestWidth, xHitTestWidth), P) and (WindowState <> wsMaximized) then
               Message.Result := HTTOP // 上边
            else if PtInRect(rect(Width - xHitTestWidth, 0, xHitTestWidth, xHitTestWidth), P) and (WindowState <> wsMaximized) then
               Message.Result := HTTOPRIGHT // 右上角
            else if PtInRect(rect(Width - xHitTestWidth, xHitTestWidth, Width, Height - xHitTestWidth), P) and (WindowState <> wsMaximized) then
               Message.Result := HTRIGHT // 右边
            else if PtInRect(rect(Width - xHitTestWidth, Height - xHitTestWidth, Width, Height), P) and (WindowState <> wsMaximized) then
               Message.Result := HTBOTTOMRIGHT // 右下角
            else if PtInRect(rect(xHitTestWidth, Height - xHitTestWidth, Width - xHitTestWidth, Height), P) and (WindowState <> wsMaximized) then
               Message.Result := HTBOTTOM // 下边
            else if PtInRect(rect(0, Height - xHitTestWidth, xHitTestWidth, Height), P) and (WindowState <> wsMaximized) then
               Message.Result := HTBOTTOMLEFT // 左下角
            else if PtInRect(rect(0, xHitTestWidth, xHitTestWidth, Height - xHitTestWidth), P) and (WindowState <> wsMaximized) then
               Message.Result := HTLEFT // 左边
            else if PtInRect(rect(0, 0, Width, xTitleHeight), P) then
               Message.Result := HTCAPTION // 标题栏
            else
               inherited;
         end else begin
            if PtInRect(rect(0, 0, Width, xTitleHeight), P) then
               Message.Result := HTCAPTION // 标题栏
            else
               inherited;
         end;
      end;

   procedure TCustomLoginForm.WMNCLBUTTONDBLCLK(var Message: TWMNCLButtonDblClk);
      var
         P    : TPoint;
         Style: DWORD;
      begin
         inherited;
         if biMaximize in BorderIcons then
         begin
            P := Point(Message.XCursor - Left, Message.YCursor - Top);
            if PtInRect(rect(0, 0, Width, xTitleHeight), P) then
            begin
               Style := GetWindowLong(Handle, GWL_STYLE);
               if Style and WS_MAXIMIZE > 0 then
                  SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0)
               else
                  SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
            end;
         end;
      end;

   procedure TCustomLoginForm.WMSize(var Message: TWMSize);
      var
         Rgn: HRGN;
      begin
         inherited;
         if fsCreating in FormState then
            exit;

         // DrawTitle;
         // cndebugger.LogMsg('WMSize');
         // Rgn := CreateRoundRectRgn(0, 0, Width, Height, 5, 5);
         // SetWindowRgn(Handle, Rgn, True);
         // DeleteObject(Rgn);
      end;

   destructor TCustomLoginForm.Destroy;
      begin
         m_BackBMP.Free;

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
         inherited;
      end;

   procedure TCustomLoginForm.DrawClient(DC: HDC);
      var
         C: TCanvas;
      begin
         C        := TControlCanvas.Create;
         C.Handle := DC;
         try
            (* *)
            C.Brush.Color := $00FAFAFA;
            C.FillRect(ClientRect);

            // if Assigned(m_BackBMP) then
            // begin
            // C.Brush.Color := m_BackColor;
            // C.FillRect(ClientRect);
            // BitBlt(C.Handle, 0, 0, ClientWidth, ClientHeight, m_BackBMP.Canvas.Handle, xFramWidth, xTitleHeight, SRCCOPY);
            // end;
         finally
            C.Handle := 0;
            C.Free;
         end;
      end;

   procedure TCustomLoginForm.DrawShadow(canvas: TCanvas; rect: TRect; direction: Integer);
      var
         i: Integer;
      begin
         with canvas do
         begin
            pen.Width       := 1;
            canvas.pen.Mode := pmMaskPenNot;

            i         := 5;
            pen.Color := $00C8C8C8;
            MoveTo(rect.Left, rect.Top + i);
            LineTo(rect.Width, rect.Top + i);
            Dec(i);
            pen.Color := $00D6D6D6;
            MoveTo(rect.Left, rect.Top + i);
            LineTo(rect.Width, rect.Top + i);
            Dec(i);
            pen.Color := $00E2E2E2;
            MoveTo(rect.Left, rect.Top + i);
            LineTo(rect.Width, rect.Top + i);
            Dec(i);
            pen.Color := $00ECECEC;
            MoveTo(rect.Left, rect.Top + i);
            LineTo(rect.Width, rect.Top + i);
            Dec(i);
            pen.Color := $00F4F4F4;
            MoveTo(rect.Left, rect.Top + i);
            LineTo(rect.Width, rect.Top + i);
            Dec(i);
            pen.Color := $00F9F9F9;
            MoveTo(rect.Left, rect.Top + i);
            LineTo(rect.Width, rect.Top + i);
            Dec(i);

         end;
      end;

   procedure TCustomLoginForm.WMGETMINMAXINFO(var Message: TMessage);
      var
         rect: TRect;
      begin
         SystemParametersInfo(SPI_GETWORKAREA, 0, @rect, 0);
         with PMINMAXINFO(Message.LParam)^ do
         begin
            // ptReserved: TPoint;//保留不用

            ptMaxSize.X := rect.Right; // 最大范围
            ptMaxSize.Y := rect.Bottom;

            ptMaxPosition.X := 0; // 最大的放置点
            ptMaxPosition.Y := 0;

            ptMinTrackSize.X := 200; // 最小拖动范围
            ptMinTrackSize.Y := xTitleHeight;

            // ptMaxTrackSize: TPoint;//最大拖动范围
         end;
      end;

   procedure TCustomLoginForm.OnButtonUp(P: TPoint);
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
         end else if (biMaximize in BorderIcons) and PtInRect(GetRectMaxButton, P) and m_MaxButtonDown then
         begin
            ReleaseCapture;
            m_MaxButtonDown := False;
            // DrawTitle;
            Style := GetWindowLong(Handle, GWL_STYLE);
            if Style and WS_MAXIMIZE > 0 then
               SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0)
            else
               SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
            Exit;
         end else if PtInRect(GetRectCloseButton, P) and m_CloseButtonDown then
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
            m_MiniButtonDown  := False;
            m_MaxButtonDown   := False;
            m_CloseButtonDown := False;
            DrawTitle;
         end;
      end;

   procedure TCustomLoginForm.WMLBUTTONUP(var Message: TWMLButtonUp);
      var
         P: TPoint;
      begin
         inherited;
         P.X := Mouse.CursorPos.X - Left;
         P.Y := Mouse.CursorPos.Y - Top;
         OnButtonUp(P);
      end;

   procedure TCustomLoginForm.WMNCLButtonDown(var Message: TWMNCLButtonDown);
      begin
         if (Message.HitTest = HTCAPTION) and (WindowState = wsMaximized) then
         begin
            Exit;
         end;

         if Message.HitTest = HTMINBUTTON then
         begin
            m_MiniButtonDown := True;
            SetCapture(self.Handle);
            DrawTitle;
         end else if Message.HitTest = HTMAXBUTTON then
         begin
            m_MaxButtonDown := True;
            SetCapture(self.Handle);
            DrawTitle;
         end else if Message.HitTest = HTCLOSE then
         begin
            m_CloseButtonDown := True;
            SetCapture(self.Handle);
            DrawTitle;
         end
         else
            inherited;
      end;

   procedure TCustomLoginForm.WMNCLButtonUp(var Message: TWMNCLButtonUp);
      var
         P: TPoint;
      begin
         DefaultHandler(Message);
         P.X := Mouse.CursorPos.X - Left;
         P.Y := Mouse.CursorPos.Y - Top;
         OnButtonUp(P);
      end;

   procedure TCustomLoginForm.WMNCMouseMove(var Message: TWMNCMousemove);
      var
         P: TPoint;
         r: TRect;
      begin
         P.X := Mouse.CursorPos.X - Left;
         P.Y := Mouse.CursorPos.Y - Top;
         if biMinimize in self.BorderIcons then
         begin
            r := GetRectMiniButton;
            Inc(r.Top, xHitTestWidth);
            if PtInRect(r, P) then
            begin
               if m_CloseButtonHover then
                  m_CloseButtonHover := False;
               if m_MaxButtonHover then
                  m_MaxButtonHover := False;
               if not m_MiniButtonHover then
               begin
                  m_MiniButtonHover := True;
                  DrawTitle;
                  // Timer1.Enabled := True;
                  Exit;
               end;
            end;
         end;

         if biMaximize in BorderIcons then
         begin
            r := GetRectMaxButton;
            Inc(r.Top, xHitTestWidth);
            if PtInRect(r, P) then
            begin
               if m_MiniButtonHover then
                  m_MiniButtonHover := False;
               if m_MaxButtonHover then
                  m_MaxButtonHover := False;
               if not m_MaxButtonHover then
               begin
                  m_MaxButtonHover := True;
                  DrawTitle;
                  // Timer1.Enabled := True;
                  Exit;
               end;
            end;
         end;

         r := GetRectCloseButton;
         Inc(r.Top, xHitTestWidth);
         Dec(r.Right, xHitTestWidth);
         if PtInRect(r, P) then
         begin
            if m_MiniButtonHover then
               m_MiniButtonHover := False;
            if m_MaxButtonHover then
               m_MaxButtonHover := False;
            if not m_CloseButtonHover then
            begin
               m_CloseButtonHover := True;
               DrawTitle;
               // Timer1.Enabled := True;
            end;
         end else begin
            if m_MiniButtonHover then
               m_MiniButtonHover := False;
            if m_MaxButtonHover then
               m_MaxButtonHover := False;
            m_CloseButtonHover  := False;
            DrawTitle;
         end;

      end;

   procedure TCustomLoginForm.Timer1Timer(Sender: TObject);
      var
         P: TPoint;
         r: TRect;
      begin
         P.X := (Mouse.CursorPos).X - Left;
         P.Y := (Mouse.CursorPos).Y - Top;

         r := GetRectCloseButton;
         Inc(r.Top, xHitTestWidth);
         Dec(r.Right, xHitTestWidth);
         if not PtInRect(r, P) then
         begin
            if m_CloseButtonHover then
            begin
               m_CloseButtonHover := False;
               // Timer1.Enabled := False;
               DrawTitle;
            end;
         end;

         r := GetRectMaxButton;
         Inc(r.Top, xHitTestWidth);
         if not PtInRect(r, P) then
         begin
            if m_MaxButtonHover then
            begin
               m_MaxButtonHover := False;
               // Timer1.Enabled := False;
               DrawTitle;
            end;
         end;

         r := GetRectMiniButton;
         Inc(r.Top, xHitTestWidth);
         if not PtInRect(r, P) then
         begin
            if m_MiniButtonHover then
            begin
               m_MiniButtonHover := False;
               // Timer1.Enabled := False;
               DrawTitle;
            end;
         end;
      end;

   function TCustomLoginForm.GetRectCloseButton: TRect;
      begin
         Result := rect(Width - btn_close_normal.Width, 0, Width, btn_close_normal.Height);
      end;

   function TCustomLoginForm.GetRectMaxButton: TRect;
      begin
         Result := GetRectCloseButton;
         Dec(Result.Left, btn_max_normal.Width);
         Dec(Result.Right, btn_max_normal.Width);
      end;

   function TCustomLoginForm.GetRectMiniButton: TRect;
      begin
         if biMaximize in BorderIcons then
            Result := GetRectMaxButton
         else
            Result := GetRectCloseButton;

         Dec(Result.Left, btn_min_normal.Width);
         Dec(Result.Right, btn_min_normal.Width);
      end;

   procedure TCustomLoginForm.GaussianBlur(Bmp: TBitmap; Amount: Integer);
      var
         i: Integer;

         function TrimRow(n: Integer): Integer;
            begin
               if n < 0 then
                  Result := 0
               else if n >= Bmp.Height then
                  Result := Bmp.Height - 1
               else
                  Result := n;
            end;

         function TrimCol(n: Integer): Integer;
            begin
               if n < 0 then
                  Result := 0
               else if n >= Bmp.Width then
                  Result := Bmp.Width - 1
               else
                  Result := n;
            end;

         procedure SplitBlur(Amount: Integer);
            var
               X, Y              : Integer;
               tl, tr, bl, br    : PColor32;
               line, line1, line2: PIntegerArray;
            begin
               for Y := 0 to Bmp.Height - 1 do
               begin
                  line  := PIntegerArray(Bmp.ScanLine[Y]);
                  line1 := PIntegerArray(Bmp.ScanLine[TrimRow(Y - Amount)]);
                  line2 := PIntegerArray(Bmp.ScanLine[TrimRow(Y + Amount)]);
                  for X := 0 to Bmp.Width - 1 do
                  begin
                     tl := PColor32(@line1[TrimCol(X - Amount)]);
                     tr := PColor32(@line1[TrimCol(X + Amount)]);
                     bl := PColor32(@line2[TrimCol(X - Amount)]);
                     br := PColor32(@line2[TrimCol(X + Amount)]);
                     with PColor32(@line[X])^ do
                     begin
                        r := (tl.r + tr.r + bl.r + br.r) shr 2;
                        g := (tl.g + tr.g + bl.g + br.g) shr 2;
                        b := (tl.b + tr.b + bl.b + br.b) shr 2;
                     end;
                  end;
                  CreateHatchBrush(1, 1)
               end;
            end;

      begin
         for i := 1 to Amount do
            SplitBlur(i);
      end;

   // 模糊
   procedure TCustomLoginForm.Blur(SrcBmp: TBitmap);
      var
         i, j      : Integer;
         SrcRGB    : pRGBTriple;
         SrcNextRGB: pRGBTriple;
         SrcPreRGB : pRGBTriple;
         Value     : Integer;
         procedure IncRGB;
            begin
               Inc(SrcPreRGB);
               Inc(SrcRGB);
               Inc(SrcNextRGB);
            end;
         procedure DecRGB;
            begin
               Inc(SrcPreRGB, -1);
               Inc(SrcRGB, -1);
               Inc(SrcNextRGB, -1);
            end;

      begin
         SrcBmp.PixelFormat := pf24Bit;
         for i              := 0 to SrcBmp.Height - 1 do
         begin
            if i > 0 then
               SrcPreRGB := SrcBmp.ScanLine[i - 1]
            else
               SrcPreRGB := SrcBmp.ScanLine[i];
            SrcRGB       := SrcBmp.ScanLine[i];
            if i < SrcBmp.Height - 1 then
               SrcNextRGB := SrcBmp.ScanLine[i + 1]
            else
               SrcNextRGB := SrcBmp.ScanLine[i];
            for j         := 0 to SrcBmp.Width - 1 do
            begin
               if j > 0 then
                  DecRGB;
               Value := SrcPreRGB.rgbtRed + SrcRGB.rgbtRed + SrcNextRGB.rgbtRed;
               if j > 0 then
                  IncRGB;
               Value := Value + SrcPreRGB.rgbtRed + SrcRGB.rgbtRed + SrcNextRGB.rgbtRed;
               if j < SrcBmp.Width - 1 then
                  IncRGB;
               Value := (Value + SrcPreRGB.rgbtRed + SrcRGB.rgbtRed + SrcNextRGB.rgbtRed) div 9;
               DecRGB;
               SrcRGB.rgbtRed := Value;
               if j > 0 then
                  DecRGB;
               Value := SrcPreRGB.rgbtGreen + SrcRGB.rgbtGreen + SrcNextRGB.rgbtGreen;
               if j > 0 then
                  IncRGB;
               Value := Value + SrcPreRGB.rgbtGreen + SrcRGB.rgbtGreen + SrcNextRGB.rgbtGreen;
               if j < SrcBmp.Width - 1 then
                  IncRGB;
               Value := (Value + SrcPreRGB.rgbtGreen + SrcRGB.rgbtGreen + SrcNextRGB.rgbtGreen) div 9;
               DecRGB;
               SrcRGB.rgbtGreen := Value;
               if j > 0 then
                  DecRGB;
               Value := SrcPreRGB.rgbtBlue + SrcRGB.rgbtBlue + SrcNextRGB.rgbtBlue;
               if j > 0 then
                  IncRGB;
               Value := Value + SrcPreRGB.rgbtBlue + SrcRGB.rgbtBlue + SrcNextRGB.rgbtBlue;
               if j < SrcBmp.Width - 1 then
                  IncRGB;
               Value := (Value + SrcPreRGB.rgbtBlue + SrcRGB.rgbtBlue + SrcNextRGB.rgbtBlue) div 9;
               DecRGB;
               SrcRGB.rgbtBlue := Value;
               IncRGB;
            end;
         end;
      end;

   // RGB<=>BGR
   procedure TCustomLoginForm.RGB2BGR(const Bitmap: TBitmap);
      var
         X    : Integer;
         Y    : Integer;
         PRGB : pRGBTriple;
         Color: Byte;
      begin
         for Y := 0 to (Bitmap.Height - 1) do
         begin
            PRGB  := Bitmap.ScanLine[Y];
            for X := 0 to (Bitmap.Width - 1) do
            begin
               Color          := PRGB^.rgbtRed;
               PRGB^.rgbtRed  := PRGB^.rgbtBlue;
               PRGB^.rgbtBlue := Color;
               Inc(PRGB);
            end;
         end
      end;

   procedure TCustomLoginForm.SetShadowed(const Value: Boolean);
      begin
         if FShadowed <> Value then
            FShadowed := Value
         else
            Exit;
         if FShadowed then
         begin
            ShadowFrame            := TShadowFrame.Create(self);
            ShadowFrame.ParentForm := self;
            // shadowframe.ParentWindow:=self.Handle;
            ShadowFrame.Active := True;
            ShadowFrame.show();
         end else begin
            FreeAndNil(ShadowFrame);
         end;
      end;

   // 灰度化(加权)
   procedure TCustomLoginForm.Grayscale(const Bitmap: TBitmap);
      var
         X   : Integer;
         Y   : Integer;
         PRGB: pRGBTriple;
         Gray: Byte;
      begin
         Bitmap.PixelFormat := pf24Bit;
         for Y              := 0 to (Bitmap.Height - 1) do
         begin
            PRGB  := Bitmap.ScanLine[Y];
            for X := 0 to (Bitmap.Width - 1) do
            begin
               Gray            := (77 * PRGB.rgbtRed + 151 * PRGB.rgbtGreen + 28 * PRGB.rgbtBlue) shr 8;
               PRGB^.rgbtRed   := Gray;
               PRGB^.rgbtGreen := Gray;
               PRGB^.rgbtBlue  := Gray;
               Inc(PRGB);
            end;
         end;
      end;

   procedure TCustomLoginForm.InitializeNewForm;
      begin
         inherited;
         m_BackBMP := TBitmap.Create;
         m_BackBMP.LoadFromResourceName(HInstance, 'Login_caption');
         // m_BackBMP.LoadFromFile('../../examcommons/skins/login_caption.bmp');
         // bmp:=TBitmap.Create;
         // BMP.Width:= 100;
         // BMP.Height:= 100;
         // BMP.Transparent:= True;
         // BMP.TransparentColor:= clWhite;
         // BMP.Canvas.Brush.Style:= bsSolid;
         // BMP.Canvas.Brush.Color:= clWhite;
         // BMP.Canvas.FillRect(BMP.Canvas.ClipRect);
         // BMP.Canvas.Brush.Color:= clBlue;
         // BMP.Canvas.Ellipse(0, 0, 90, 90);

         if biMinimize in self.BorderIcons then
         begin
            btn_min_down := TPngImage.Create;
            btn_min_down.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Min_Down');
            // btn_min_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Min_Down.png');

            btn_min_highlight := TPngImage.Create;
            btn_min_highlight.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Min_Hover');
            // btn_min_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Min_Hover.png');

            btn_min_normal := TPngImage.Create;
            btn_min_normal.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Min_Normal');
            // btn_min_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Min_Normal.png');
         end;

         if biMaximize in self.BorderIcons then
         begin
            btn_max_down := TPngImage.Create;
            btn_max_down.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Max_Down');
            // btn_max_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Max_Down.png');

            btn_max_highlight := TPngImage.Create;
            btn_max_highlight.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Max_Hover');
            // btn_max_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Max_Hover.png');

            btn_max_normal := TPngImage.Create;
            btn_max_normal.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Max_Normal');
            // btn_max_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Max_Normal.png');

            btn_Restore_down := TPngImage.Create;
            btn_Restore_down.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Restore_Down');
            // btn_Restore_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Restore_Down.png');

            btn_Restore_highlight := TPngImage.Create;
            btn_Restore_highlight.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Restore_Hover');
            // btn_Restore_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Restore_Hover.png');

            btn_Restore_normal := TPngImage.Create;
            btn_Restore_normal.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Restore_Normal');
            // btn_Restore_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Restore_Normal.png');
         end;

         btn_close_down := TPngImage.Create;
         btn_close_down.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Close_Down');
         // btn_close_down.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Close_Down.png');
         // btn_close_down.LoadFromFile('../../examcommons/skins/Close_Down.png');
         btn_close_highlight := TPngImage.Create;
         btn_close_highlight.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Close_Hover');
         // btn_close_highlight.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Close_Hover.png');
         // btn_close_highlight.LoadFromFile('../../examcommons/skins/Close_Hover.png');
         btn_close_normal := TPngImage.Create;
         btn_close_normal.LoadFromResourceName(HInstance, 'ClassicSkin_Png_Close_Normal');
         // btn_close_normal.LoadFromFile(ExtractFilePath(Application.ExeName) + 'SysButton\Close_Normal.png');
         // btn_close_normal.LoadFromFile('../../examcommons/skins/Close_Normal.png');
      end;

   // 反色
   procedure TCustomLoginForm.Negative(Bmp: TBitmap);
      var
         i, j: Integer;
         PRGB: pRGBTriple;
      begin
         Bmp.PixelFormat := pf24Bit;
         for i           := 0 to Bmp.Height - 1 do
         begin
            PRGB  := Bmp.ScanLine[i];
            for j := 0 to Bmp.Width - 1 do
            begin
               PRGB^.rgbtRed   := not PRGB^.rgbtRed;
               PRGB^.rgbtGreen := not PRGB^.rgbtGreen;
               PRGB^.rgbtBlue  := not PRGB^.rgbtBlue;
               Inc(PRGB);
            end;
         end;
      end;

   procedure TCustomLoginForm.AlphaBlendDraw(destCanvas: TCanvas);
      var
         Blend: TBlendFunction; { 定义 AlphaBlend 要使用的 TBlendFunction 结构 }
      begin
         { 给 TBlendFunction 结构赋值 }
         Blend.BlendOp             := AC_SRC_OVER;
         Blend.BlendFlags          := 0;
         Blend.AlphaFormat         := 0;
         Blend.SourceConstantAlpha := 100;
         // m_BorderYYTopPng.SaveToFile('abc.png');
         // Windows.AlphaBlend(destCanvas.Handle, {因 VCL 有同名属性, 所以指定了是来自 Windows 单元}
         // 0,
         // 0,
         // m_BorderYYTopPng.Width ,
         // m_BorderYYTopPng.Height ,
         // m_BorderYYTopPng.Canvas.Handle,
         // 0,
         // 0,
         // m_BorderYYTopPng.Width,
         // m_BorderYYTopPng.Height,
         // Blend
         // );
      end;

   procedure TCustomLoginForm.DrawAlphaBlend(destHandle: hwnd; sourceDc: HDC);
      var
         Ahdc                         : HDC;           // handle of the DC we will create
         bf                           : BLENDFUNCTION; // structure for alpha blending
         Ahbitmap                     : HBITMAP;       // bitmap handle
         bmi                          : BITMAPINFO;    // bitmap header
         pvBits                       : pointer;       // pointer to DIB section
         ulWindowWidth, ulWindowHeight: ULONG;         // window width/height
         ulBitmapWidth, ulBitmapHeight: ULONG;         // bitmap width/height
         rt                           : TRect;         // used for getting window dimensions
         bm, bm1                      : TBitmap;
      begin
         ulWindowWidth  := Width;
         ulWindowHeight := xTitleHeight;

         // divide the window into 3 horizontal areas
         ulWindowHeight := trunc(ulWindowHeight / 3);

         // create a DC for our bitmap -- the source DC for AlphaBlend
         Ahdc := CreateCompatibleDC(sourceDc);

         // zero the memory for the bitmap info
         ZeroMemory(@bmi, sizeof(BITMAPINFO));

         // setup bitmap info
         bmi.bmiHeader.biSize        := sizeof(BITMAPINFOHEADER);
         bmi.bmiHeader.biWidth       := trunc(ulWindowWidth - (ulWindowWidth / 5) * 2);
         ulBitmapWidth               := trunc(ulWindowWidth - (ulWindowWidth / 5) * 2);
         bmi.bmiHeader.biHeight      := trunc(ulWindowHeight - (ulWindowHeight / 5) * 2);
         ulBitmapHeight              := trunc(ulWindowHeight - (ulWindowHeight / 5) * 2);
         bmi.bmiHeader.biPlanes      := 1;
         bmi.bmiHeader.biBitCount    := 32; // four 8-bit components
         bmi.bmiHeader.biCompression := BI_RGB;
         bmi.bmiHeader.biSizeImage   := ulBitmapWidth * ulBitmapHeight * 4;

         // create our DIB section and select the bitmap into the dc
         Ahbitmap := CreateDIBSection(Ahdc, bmi, DIB_RGB_COLORS, pvBits, 0, 0);

         // SelectObject(Ahdc, Ahbitmap);

         // bm:=TBitmap.Create;
         // bm.Assign(m_BorderYYTopPng);
         // bm1:=TBitmap.Create;
         // bm1.Width:=width;
         // bm1.Height:=xFramWidth;

         SelectObject(Ahdc, bm.Handle);

         bf.BlendOp             := AC_SRC_OVER;
         bf.BlendFlags          := 0;
         bf.SourceConstantAlpha := $FF;          // half of 0xff = 50% transparency
         bf.AlphaFormat         := AC_SRC_ALPHA; // 0;           //0: ignore source alpha channel;AC_SRC_ALPHA:use source alpha value
         // bm1.SaveToFile('abc.bmp');
         Windows.AlphaBlend(destHandle, 0, 0, 450, xFramWidth, Ahdc, 0, 0, 450, xFramWidth, bf);
         // StretchBlt(bm1.Canvas.Handle,0,0,450,6,bm.Canvas.Handle,0,0,450,xFramWidth,SRCCOPY);
         // bm1.SaveToFile('abc.bmp');
         // UpdateLayeredWindow()
         // SelectObject(ahdc,bm1.Handle);
         // Windows.AlphaBlend(destHandle, 0, 0,
         // width, ulBitmapHeight,    Ahdc, 0, 0, width, xFramWidth, bf);
         // Ahdc, 0, 0, ulBitmapWidth, ulBitmapHeight, bf);

         // Windows.AlphaBlend(destHandle, trunc(ulWindowWidth/5), trunc(ulWindowHeight/5),
         // ulBitmapWidth, ulBitmapHeight,
         // Ahdc, 0, 0, ulBitmapWidth, ulBitmapHeight, bf);
         // bm :=TBitmap.Create;
         // bm.Width:=ulBitmapWidth;
         // bm.Height:=ulBitmapHeight;
         // BitBlt(bm.Canvas.Handle,0,0,ulBitmapWidth, ulBitmapHeight,ahdc,0,0,SRCCOPY);
         // bm.SaveToFile('abcdef1.bmp');

         // bf.BlendOp := AC_SRC_OVER;
         // bf.BlendFlags := 0;
         // bf.AlphaFormat := AC_SRC_ALPHA;  // use source alpha
         // bf.SourceConstantAlpha := $ff;  // opaque (disable constant alpha)
         //
         // Windows.AlphaBlend(destHandle, trunc(ulWindowWidth/5),
         // trunc(ulWindowHeight/5+ulWindowHeight), ulBitmapWidth, ulBitmapHeight,
         // Ahdc, 0, 0, ulBitmapWidth, ulBitmapHeight, bf);
         //
         // bf.BlendOp := AC_SRC_OVER;
         // bf.BlendFlags := 0;
         // bf.AlphaFormat := 0;
         // bf.SourceConstantAlpha := $3A;
         //
         // Windows.AlphaBlend(destHandle, trunc(ulWindowWidth/5),
         // trunc(ulWindowHeight/5+2*ulWindowHeight), ulBitmapWidth,
         // ulBitmapHeight, Ahdc, 0, 0, ulBitmapWidth,
         // ulBitmapHeight, bf);
         // do cleanup
         DeleteObject(Ahbitmap);
         DeleteDC(Ahdc);

      end;

end.
