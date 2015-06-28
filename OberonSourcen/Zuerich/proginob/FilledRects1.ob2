MODULE FilledRects1;
(* Extension of very tiny graphics editor, Exercise 12.7, page 242.
   Note: In Programming in Oberon, this module is called FilledRectangles. It
   is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Graphs:=Graphs1, Rects:=Rects1, Display;
CONST white = Display.white;  repl = Display.replace;
TYPE
   FilledRect* = POINTER TO RectDesc;
   RectDesc* = RECORD(Rects.RectDesc)
      pat*: Display.Pattern
   END;

PROCEDURE Min(x, y: INTEGER): INTEGER;
BEGIN IF x < y THEN RETURN x ELSE RETURN y END
END Min;

PROCEDURE Draw*(r: Graphs.Figure);
BEGIN
   WITH r: FilledRect DO
      Rects.Draw(r);
      Display.ReplPattern(white, r.pat, r.x+1, r.y + 1, r.w - 2, r.h - 2, repl)
   END
END Draw;

PROCEDURE NewFigure*(): Graphs.Figure;
VAR r: FilledRect;  x1, y1, x2, y2: INTEGER;
BEGIN
   NEW(r);
   r.draw := Draw;
   r.pat := Display.grey0;  (* light grey pattern *)
   Graphs.spanVect(x1, y1, x2, y2);
   r.x := Min(x1, x2);  r.y := Min(y1, y2);
   r.w := ABS(x2 - x1);  r.h := ABS(y2 - y1);
   RETURN r
END NewFigure;

PROCEDURE Set*;
BEGIN  Graphs.newFigure := NewFigure;
END Set;

END FilledRects1.    (* Copyright M. Reiser, 1992 *)
