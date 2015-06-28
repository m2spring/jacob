MODULE Rects3;
(* Very tiny graphics editor with  file I/O, Exercise 12.12, page 243.
   Note: In Programming in Oberon, this module is called Rectangles. It
   is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Files1:=Files, Graphs:=Graphs3, Shapes;
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

PROCEDURE Store*(r: Graphs.Figure);
(* Method to write a figure to disk *)
VAR cmd: ARRAY 32 OF CHAR;
BEGIN
   WITH r: Rect DO
      cmd := "Rects.Load";
      Files1.WriteString(Graphs.rider, cmd);
      Files1.WriteInt(Graphs.rider, r.x);
      Files1.WriteInt(Graphs.rider, r.y);
      Files1.WriteInt(Graphs.rider, r.w);
      Files1.WriteInt(Graphs.rider, r.h)
   END
END Store;

PROCEDURE NewFigure*(): Graphs.Figure;
VAR r: Rect;  x1, y1, x2, y2: INTEGER;
BEGIN
   NEW(r);
   r.draw := Draw;  r.store := Store;
   Graphs.spanVect(x1, y1, x2, y2);
   r.x := Min(x1, x2);  r.y := Min(y1, y2);
   r.w := ABS(x2 - x1);  r.h := ABS(y2 - y1);
   RETURN r
END NewFigure;

PROCEDURE LoadFigure*(): Graphs.Figure;
VAR r: Rect;  x1, y1, x2, y2: INTEGER;
BEGIN
   NEW(r);
   r.draw := Draw;  r.store := Store;
   Files1.ReadInt(Graphs.rider, r.x);
   Files1.ReadInt(Graphs.rider, r.y);
   Files1.ReadInt(Graphs.rider, r.w);
   Files1.ReadInt(Graphs.rider, r.h);
   RETURN r
END LoadFigure;

PROCEDURE Load*;
BEGIN  Graphs.loadFigure := LoadFigure
END Load;

PROCEDURE Set*;
BEGIN  Graphs.newFigure := NewFigure
END Set;

END Rects3.     (* Copyright M.Reiser, 1992 *)
