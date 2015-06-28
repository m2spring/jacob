MODULE Shapes;
(*  Draw geometric shapes within a clipping rectangle *)
IMPORT Display, In, Out;
CONST white = Display.white;  repl = Display.replace;

VAR X, Y, W, H: INTEGER;  (* Clipping Rectangle *)

PROCEDURE Max(x, y: INTEGER): INTEGER;
BEGIN IF x > y THEN RETURN x ELSE RETURN y END
END Max;

PROCEDURE Min(x, y: INTEGER): INTEGER;
BEGIN IF x < y THEN RETURN x ELSE RETURN y END
END Min;

PROCEDURE SetClipping*(x, y, w, h: INTEGER);
BEGIN X := x;  Y := y;  W := w;  H := h
END SetClipping;

PROCEDURE Hline*(x, y, w: INTEGER);
VAR x1, x2: INTEGER;
BEGIN  (* w > 0 *)
   IF (y >= Y) & (y < Y + H) THEN
      x1 := Max(x, X);  x2 := Min(x + w, X + W);
      IF (x1 >= X) OR (x2 < X + W) THEN
         Display.ReplConst(white, x1, y, x2 - x1, 1, repl)
      END
   END
END Hline;

PROCEDURE Vline*(x, y, h: INTEGER);
VAR y1, y2: INTEGER;
BEGIN  (* h > 0 *)
   IF (x >= X) & (x < X + W) THEN
      y1 := Max(y, Y);  y2 := Min(y + h, Y + H);
      IF (y1 >= Y) OR (y2 < Y + H) THEN
         Display.ReplConst(white, x, y1, 1, y2 - y1, repl)
      END
   END
END Vline;

PROCEDURE Rect*(x, y, w, h: INTEGER);
BEGIN
   Hline(x, y, w);  Hline(x, y + h, w + 1);
   Vline(x, y, h);  Vline(x + w, y, h)
END Rect;

END Shapes.   (* Copyright M. Reiser, 1992 *)

