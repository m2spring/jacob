MODULE Rects2;
(* Very tiny graphics editor, Exercise 12.5, page 241 (same as version 1).
   Note: In Programming in Oberon, this module is called Rectangles. It
   is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Graphs:=Graphs2, Shapes;
TYPE
   Rect* = POINTER TO RectDesc;
   RectDesc* = RECORD(Graphs.FigureDesc)
      x*, y*, w*, h*: INTEGER;
   END;

PROCEDURE Min(x, y: INTEGER): INTEGER;
BEGIN IF x < y THEN RETURN x ELSE RETURN y END
END Min;

PROCEDURE Draw*(r: Graphs.Figure);
BEGIN
   WITH r: Rect DO
      Shapes.Rect(r.x, r.y, r.w, r.h)
   END
END Draw;

PROCEDURE NewFigure*(): Graphs.Figure;
VAR r: Rect;  x1, y1, x2, y2: INTEGER;
BEGIN
   NEW(r);
   r.draw := Draw;
   Graphs.spanVect(x1, y1, x2, y2);
   r.x := Min(x1, x2);  r.y := Min(y1, y2);
   r.w := ABS(x2 - x1);  r.h := ABS(y2 - y1);
   RETURN r
END NewFigure;

PROCEDURE Set*;
BEGIN  Graphs.newFigure := NewFigure;
END Set;

END Rects2.     (* Copyright M. Reiser, 1992 *)
