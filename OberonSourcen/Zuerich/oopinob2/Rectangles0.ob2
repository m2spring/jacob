MODULE Rectangles0;   (*HM Mar-25-92*)
IMPORT OS, Viewers0, Shapes0, GraphicFrames0;

TYPE
   Rectangle* = POINTER TO RectDesc;
   RectDesc* = RECORD (Shapes0.ShapeDesc)
      x, y, w, h: INTEGER
   END;

PROCEDURE (r: Rectangle) Draw* (f: Viewers0.Frame);
BEGIN
   WITH f: GraphicFrames0.Frame DO
      IF r.selected THEN f.InvertBlock(r.x, r.y, r.w, r.h)
      ELSE
         f.InvertBlock(r.x, r.y, r.w, 1); f.InvertBlock(r.x, r.y + r.h - 1, r.w, 1);
         f.InvertBlock(r.x, r.y + 1, 1, r.h - 2); f.InvertBlock(r.x + r.w - 1, r.y + 1, 1, r.h - 2)
      END
   END
END Draw;

PROCEDURE (r: Rectangle) Copy* (): Shapes0.Shape;
   VAR r1: Rectangle;
BEGIN NEW(r1); r1.selected := r.selected; r1.x := r.x; r1.y := r.y; r1.w := r.w; r1.h := r.h; RETURN r1
END Copy;

PROCEDURE (r: Rectangle) Move* (dx, dy: INTEGER);
BEGIN INC(r.x, dx); INC(r.y, dy)
END Move;

PROCEDURE (r: Rectangle) SetBox* (x, y, w, h: INTEGER);
BEGIN r.SetBox^ (x, y, w, h);
   r.x := x; r.y := y; r.w := w; r.h := h
END SetBox;

PROCEDURE (r: Rectangle) SetSelection* (x, y, w, h: INTEGER);
BEGIN
   r.selected := (r.x >= x) & (r.x+r.w <= x+w) & (r.y >= y) & (r.y+r.h <= y+h)
END SetSelection;

PROCEDURE (r: Rectangle) GetBox* (VAR x, y, w, h: INTEGER);
BEGIN x := r.x; y := r.y; w := r.w; h := r.h
END GetBox;

PROCEDURE (r: Rectangle) Load* (VAR R: OS.Rider);
BEGIN R.ReadInt(r.x); R.ReadInt(r.y); R.ReadInt(r.w); R.ReadInt(r.h)
END Load;

PROCEDURE (r: Rectangle) Store* (VAR R: OS.Rider);
BEGIN R.WriteInt(r.x); R.WriteInt(r.y); R.WriteInt(r.w); R.WriteInt(r.h)
END Store;

PROCEDURE Set*;
BEGIN Shapes0.curShape := "Rectangles0.RectDesc"
END Set;

END Rectangles0.
