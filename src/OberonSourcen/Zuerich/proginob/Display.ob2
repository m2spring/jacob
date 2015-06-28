MODULE Display;

   CONST
      black* = 0;
      invert* = 2;
      paint* = 1;
      replace* = 0;
      white* = 15;

   TYPE
      Frame* = POINTER TO FrameDesc;
      FrameMsg* = RECORD END;
      Handler* = PROCEDURE (f: Frame; VAR msg: FrameMsg);
      Font* = POINTER TO Bytes;
      Bytes* = RECORD END;
      FrameDesc* = RECORD
         dsc*, next*: Frame;
         X*, Y*, W*, H*: INTEGER;
         handle*: Handler;
      END;
      Pattern* = LONGINT;

   VAR
      Bottom*: INTEGER;
      ColLeft*: INTEGER;
      Height*: INTEGER;
      Left*: INTEGER;
      UBottom*: INTEGER;
      Unit*: LONGINT;
      Width*: INTEGER;
      arrow*: LONGINT;
      cross*: LONGINT;
      downArrow*: LONGINT;
      grey0*: LONGINT;
      grey1*: LONGINT;
      grey2*: LONGINT;
      hook*: LONGINT;
      star*: LONGINT;
      ticks*: LONGINT;

   PROCEDURE CopyBlock* (sx, sy, w, h, dx, dy, mode: INTEGER);
   BEGIN
   END CopyBlock;

   PROCEDURE CopyBlockC* (F: Frame; sx, sy, w, h, dx, dy, mode: INTEGER);
   BEGIN
   END CopyBlockC;

   PROCEDURE CopyPattern* (col: INTEGER; pat: LONGINT; x, y, mode: INTEGER);
   BEGIN
   END CopyPattern;

   PROCEDURE CopyPatternC* (F: Frame; col: INTEGER; pat: LONGINT; x, y, mode: INTEGER);
   BEGIN
   END CopyPatternC;

   PROCEDURE Dot* (col, x, y, mode: INTEGER);
   BEGIN
   END Dot;

   PROCEDURE DotC* (F: Frame; col, x, y, mode: INTEGER);
   BEGIN
   END DotC;

   PROCEDURE GetChar* (f: Font; ch: CHAR; VAR dx, x, y, w, h: INTEGER; VAR p: LONGINT);
   BEGIN
   END GetChar;

   PROCEDURE GetColor* (col: INTEGER; VAR red, green, blue: INTEGER);
   BEGIN
   END GetColor;

   PROCEDURE Map* (X: INTEGER): LONGINT;
   BEGIN
    RETURN 0;
   END Map;

   PROCEDURE NewPattern* (VAR image: ARRAY OF SET; w, h: INTEGER): LONGINT;
   BEGIN
    RETURN 0;
   END NewPattern;

   PROCEDURE ReplConst* (col, x, y, w, h, mode: INTEGER);
   BEGIN
   END ReplConst;

   PROCEDURE ReplConstC* (F: Frame; col, x, y, w, h, mode: INTEGER);
   BEGIN
   END ReplConstC;

   PROCEDURE ReplPattern* (col: INTEGER; pat: LONGINT; x, y, w, h, mode: INTEGER);
   BEGIN
   END ReplPattern;

   PROCEDURE ReplPatternC* (F: Frame; col: INTEGER; pat: LONGINT; x, y, w, h, xp, yp, mode: INTEGER);
   BEGIN
   END ReplPatternC;

   PROCEDURE SetColor* (col, red, green, blue: INTEGER);
   BEGIN
   END SetColor;

   PROCEDURE SetMode* (X: INTEGER; s: SET);
   BEGIN
   END SetMode;

END Display.
