MODULE XYplane;
(* Graphic output to screen, Input from keyboard, page 91, 100, 311 *)
IMPORT Display, MenuViewers, Oberon, TextFrames, Input;
CONST
   max = 32768;  closed = 0;  displayed = 2;
   black = Display.black;  white = Display.white;  replace = Display.replace;
   erase* = 0;  draw* = 1; (* values for parameter mode in Dot *)

TYPE
   XYframe = POINTER TO XYframeDesc;
   XYframeDesc = RECORD (Display.FrameDesc) END;

VAR
   F: XYframe;  V: MenuViewers.Viewer;
   bitmap: ARRAY max OF SET;
   X*, Y*, W*, H*: INTEGER;

PROCEDURE Modify(F: XYframe; VAR M: MenuViewers.ModifyMsg);
BEGIN
   IF (M.id = MenuViewers.extend) & (M.dY > 0) THEN
      Display.ReplConst(black, F.X, F.Y + F.H, F.W, M.dY, replace)
   END;
   IF M.Y < F.Y THEN
      Display.ReplConst(black, F.X, M.Y, F.W, F.Y - M.Y, replace)
   END;
   X := F.X;  Y := M.Y;  W := F.W;  H := M.H
END Modify;

PROCEDURE XYhandle*(F: Display.Frame; VAR M: Display.FrameMsg);
BEGIN
   WITH F: XYframe DO
      IF M IS Oberon.InputMsg THEN
         WITH M: Oberon.InputMsg DO
            IF M.id = Oberon.track THEN
               Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y)
            END
         END
      ELSIF M IS MenuViewers.ModifyMsg THEN
         WITH M: MenuViewers.ModifyMsg DO
            Modify(F, M)
         END
      END
   END
END XYhandle;

PROCEDURE Clear*;
VAR j: LONGINT;
BEGIN
   Display.ReplConst(black, F.X, F.Y, F.X + F.W, F.Y + F.H, replace);
   j := 0;  WHILE j < max DO  bitmap[j] := {}; INC(j) END
END Clear;

PROCEDURE Open*;
VAR menuF: TextFrames.Frame;  x, y: INTEGER;
BEGIN
   IF V.state # displayed THEN
      Oberon.OpenTrack(Display.Left, 0);
      menuF := TextFrames.NewMenu("XY Plane", "System.Close");
      NEW(F);  F.handle := XYhandle;
      Oberon.AllocateUserViewer(Display.Left, x, y);
      V := MenuViewers.New(menuF, F, TextFrames.menuH, x, y)
   END;
   Clear
END Open;

PROCEDURE Dot*(x, y, mode: INTEGER);
VAR k, i, j: LONGINT;
BEGIN
   IF (x >= F.X) & (x < F.X + F.W) & (y >= F.Y) & (y < F.Y + F.H) THEN
      k := LONG(y)*F.W + x;  i := k DIV MAX(SET);  j := k MOD MAX(SET);
      CASE mode OF
           0: Display.Dot(black, x, y, replace); EXCL(bitmap[i], j)
         |1: Display.Dot(white, x, y, replace); INCL(bitmap[i], j)
      END
   END
END Dot;

PROCEDURE IsDot*(x, y: INTEGER): BOOLEAN;
VAR k, i, j: LONGINT;
BEGIN
   IF (x >= F.X) & (x < F.X + F.W) & (y >= F.Y) & (y < F.Y + F.H) THEN
      k := LONG(y)*F.W + x;  i := k DIV MAX(SET);  j := k MOD MAX(SET);
      IF j IN bitmap[i] THEN RETURN TRUE  ELSE RETURN FALSE END
   ELSE RETURN FALSE
   END
END IsDot;

PROCEDURE Key*(): CHAR;
VAR ch: CHAR;
BEGIN  ch := 0X;
   IF Input.Available() > 0 THEN  Input.Read(ch)  END;
   RETURN ch
END Key;

BEGIN
   NEW(F);  F.H := 0;  NEW(V);  V.state := closed;
END XYplane.   (* Copyright M. Reiser, 1992 *)

