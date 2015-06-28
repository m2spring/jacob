MODULE Win32;

   CONST
      Bold* = 0;
      Italics* = 1;
      LineCacheSize* = 256;
      ML* = 2;
      MM* = 1;
      MR* = 0;
      invert* = 2;
      opaque* = 2;
      paint* = 1;
      replace* = 0;
      transparent* = 1;

   TYPE
      COLORREF* = LONGINT;
      Font* = POINTER TO Bytes;
      PatternDesc* = RECORD
         x*, y*: LONGINT;
         w*, h*: INTEGER;
         bitmap*: LONGINT;
      END;
      MetricDesc* = RECORD
         dx*, x*, y*: INTEGER;
         p*: PatternDesc;
      END;
      Bytes* = RECORD
         metrics*: ARRAY 256 OF MetricDesc;
         hfont*: LONGINT;
         family*: ARRAY 32 OF CHAR;
         size*: LONGINT;
         style*: SET;
         oberon*: BOOLEAN;
      END;
      PRINTDLG* = RECORD
         size*, hwndOwner*, hDevMode*, hDevNames*, hdc*: LONGINT;
         flags*: SET;
         fromPage*, toPage*, minPage*, maxPage*, nofCopies*: INTEGER;
      END;
      Pattern* = LONGINT;
      PatternPtr* = POINTER TO PatternDesc;

   VAR
      Backg-: LONGINT;
      BackgRop-: LONGINT;
      BitBlt-: PROCEDURE (hdc, x, y, w, h, hdcSrc, xSrc, ySrc, rop: LONGINT);
      Black-: LONGINT;
      CloseClipboard-: PROCEDURE;
      CreateBitmap-: PROCEDURE (w, h, planes, bitsPerPixel, bits: LONGINT): LONGINT;
      CreateCompatibleBitmap-: PROCEDURE (hdc, w, h: LONGINT): LONGINT;
      CreateCompatibleDC-: PROCEDURE (hdc: LONGINT): LONGINT;
      CreatePalette-: PROCEDURE (ptrLogPalette: LONGINT): LONGINT;
      CreatePatternBrush-: PROCEDURE (bitmap: LONGINT): LONGINT;
      CreatePen-: PROCEDURE (style, width, color: LONGINT): LONGINT;
      CreateSolidBrush-: PROCEDURE (colorref: LONGINT): LONGINT;
      DeleteDC-: PROCEDURE (hdc: LONGINT);
      DeleteObject-: PROCEDURE (obj: LONGINT);
      Depth-: LONGINT;
      DispH-: LONGINT;
      DispW-: LONGINT;
      Display-: LONGINT;
      EmptyClipboard-: PROCEDURE;
      Foreg-: LONGINT;
      ForegRop-: LONGINT;
      GdiFlush-: PROCEDURE;
      GetClipboardData-: PROCEDURE (uFormat: LONGINT): LONGINT;
      GetDC-: PROCEDURE (win: LONGINT): LONGINT;
      GetDeviceCaps-: PROCEDURE (hdc, index: LONGINT): LONGINT;
      GetInputState-: PROCEDURE (): LONGINT;
      GetKeyState-: PROCEDURE (virtKey: LONGINT): INTEGER;
      GetPaletteEntries-: PROCEDURE (hpal, logIndex, nofEntries, ppe: LONGINT);
      GetStockObject-: PROCEDURE (objno: LONGINT): LONGINT;
      GetSystemMetrics-: PROCEDURE (index: LONGINT): LONGINT;
      GetTickCount-: PROCEDURE (): LONGINT;
      GlobalAlloc-: PROCEDURE (type, size: LONGINT): LONGINT;
      GlobalFree-: PROCEDURE (h: LONGINT);
      GlobalLock-: PROCEDURE (h: LONGINT): LONGINT;
      GlobalUnlock-: PROCEDURE (h: LONGINT);
      NumColors-: LONGINT;
      OS-: RECORD
         platform-, major-, minor-: LONGINT;
      END;
      OberonToWin-: ARRAY 256 OF CHAR;
      OpenClipboard-: PROCEDURE (window: LONGINT): BOOLEAN;
      PD: PRINTDLG;
      PaletteAvailable-: BOOLEAN;
      PatBlt-: PROCEDURE (hdc, x, y, w, h, rop: LONGINT);
      PrintDlg-: PROCEDURE (lppd: LONGINT): BOOLEAN;
      RealizePalette-: PROCEDURE (hdc: LONGINT): LONGINT;
      ReleaseCapture-: PROCEDURE;
      ReleaseDC-: PROCEDURE (win, hdc: LONGINT);
      ScreenToClient-: PROCEDURE (win, lpPoint: LONGINT);
      ScrollDC-: PROCEDURE (hdc, dx, dy, recScroll, recClip, hrgnUpdate, recUpdate: LONGINT);
      SelectObject-: PROCEDURE (hdc, obj: LONGINT): LONGINT;
      SelectPalette-: PROCEDURE (hdc, hpal, forceBkgnd: LONGINT);
      SetBkColor-: PROCEDURE (hdc, col: LONGINT);
      SetBkMode-: PROCEDURE (hdc, mode: LONGINT);
      SetBrushOrgEx-: PROCEDURE (hdc, x, y, lpPrev: LONGINT);
      SetCapture-: PROCEDURE (hwnd: LONGINT);
      SetClipboardData-: PROCEDURE (uFormat, hData: LONGINT): LONGINT;
      SetPaletteEntries-: PROCEDURE (hpal, logIndex, nofEntries, ppe: LONGINT): LONGINT;
      SetTextAlign-: PROCEDURE (hdc, mode: LONGINT);
      SetTextColor-: PROCEDURE (hdc, colorref: LONGINT);
      ShowCursor-: PROCEDURE (bShow: LONGINT): LONGINT;
      TextOut-: PROCEDURE (hdc, xstart, ystart, str, nofchar: LONGINT);
      UpdateDisplay: PROCEDURE;
      ValidateRect-: PROCEDURE (hWindow, lpRect: LONGINT);
      White-: LONGINT;
      WinToOberon-: ARRAY 256 OF CHAR;
      cc*: RECORD
         pat*: LONGINT;
         font*: Font;
         ch*: CHAR;
         dx*, x*, y*: INTEGER;
      END;
      dc*: RECORD
         hfont*, textCol*, brushCol*, bkCol*: LONGINT;
         bkMode*: INTEGER;
         penCol*: LONGINT;
         pat*: PatternPtr;
         x*, y*, w*, h*: LONGINT;
      END;
      hPalette-: LONGINT;
      hdcDisp-: LONGINT;
      lc*: RECORD
         len-: INTEGER;
      END;
      macroHook*: LONGINT;

   PROCEDURE Available* (): INTEGER;
   BEGIN
    RETURN 0;
   END Available;

   PROCEDURE BlackOnWhite*;
   BEGIN
   END BlackOnWhite;

   PROCEDURE CacheCharacter* (x, y, col, mode: INTEGER);
   BEGIN
   END CacheCharacter;

   PROCEDURE Exit* (err: LONGINT);
   BEGIN
   END Exit;

   PROCEDURE FlushCache*;
   BEGIN
   END FlushCache;

   PROCEDURE GetChar* (VAR ch: CHAR);
   BEGIN
   END GetChar;

   PROCEDURE GetClientSize* (VAR w, h: LONGINT);
   BEGIN
   END GetClientSize;

   PROCEDURE GetColor* (col: INTEGER; VAR red, green, blue: INTEGER);
   BEGIN
   END GetColor;

   PROCEDURE Mouse* (VAR keys: SET; VAR x, y: INTEGER);
   BEGIN
   END Mouse;

   PROCEDURE NewPattern* (image: ARRAY OF SET; w, h: INTEGER; VAR pat: LONGINT);
   BEGIN
   END NewPattern;

   PROCEDURE PaletteIndex* (index: LONGINT): LONGINT;
   BEGIN
    RETURN 0;
   END PaletteIndex;

   PROCEDURE RefreshDisplay*;
   BEGIN
   END RefreshDisplay;

   PROCEDURE SetBackgCol* (col: LONGINT);
   BEGIN
   END SetBackgCol;

   PROCEDURE SetBrushColor* (col: LONGINT);
   BEGIN
   END SetBrushColor;

   PROCEDURE SetClippingArea* (x, y, w, h: LONGINT);
   BEGIN
   END SetClippingArea;

   PROCEDURE SetPatternBrush* (pat: PatternPtr);
   BEGIN
   END SetPatternBrush;

   PROCEDURE SetPenColor* (col: LONGINT);
   BEGIN
   END SetPenColor;

   PROCEDURE SetTextCol* (col: LONGINT);
   BEGIN
   END SetTextCol;

   PROCEDURE SyncDisplay*;
   BEGIN
   END SyncDisplay;

   PROCEDURE UpdatePalette* (index: LONGINT; red, green, blue: INTEGER);
   BEGIN
   END UpdatePalette;

   PROCEDURE WhiteOnBlack*;
   BEGIN
   END WhiteOnBlack;

END Win32.
