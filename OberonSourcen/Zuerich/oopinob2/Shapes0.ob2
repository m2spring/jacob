MODULE Shapes0;   (*HM Mar-25-92*)
IMPORT OS, Viewers0;

TYPE
   Shape* = POINTER TO ShapeDesc;
   ShapeDesc* = RECORD (OS.ObjectDesc)
      selected*: BOOLEAN; (*TRUE: shape is selected*)
      next: Shape
   END;

   Graphic* = POINTER TO GraphicDesc;
   GraphicDesc* = RECORD
      shapes*: Shape
   END;

   NotifyChangeMsg* = RECORD (OS.Message) g*: Graphic END;

VAR
   curShape*: ARRAY 32 OF CHAR;  (*name of current shape type*)

PROCEDURE (s: Shape) Draw* (f: Viewers0.Frame); END Draw;
PROCEDURE (s: Shape) Move* (dx, dy: INTEGER); END Move;
PROCEDURE (s: Shape) Copy* (): Shape; END Copy;
PROCEDURE (s: Shape) SetSelection* (x, y, w, h: INTEGER); END SetSelection;
PROCEDURE (s: Shape) GetBox* (VAR x, y, w, h: INTEGER); END GetBox;

PROCEDURE (s: Shape) SetBox* (x, y, w, h: INTEGER);
BEGIN s.selected := FALSE;
END SetBox;

PROCEDURE (s: Shape) Neutralize*;
BEGIN s.selected := FALSE
END Neutralize;


PROCEDURE InitGraphic* (VAR g: Graphic);
BEGIN g.shapes := NIL
END InitGraphic;

PROCEDURE (g: Graphic) Insert* (s: Shape);
   VAR msg: NotifyChangeMsg;
BEGIN s.next := g.shapes; g.shapes := s; msg.g := g; Viewers0.Broadcast(msg)
END Insert;

PROCEDURE (g: Graphic) DeleteSelected*;
   VAR s, s0: Shape; msg: NotifyChangeMsg;
BEGIN s := g.shapes; s0 := NIL;
   WHILE s # NIL DO
      IF s.selected THEN
         IF s0 = NIL THEN g.shapes := s.next ELSE s0.next := s.next END
      ELSE s0 := s
      END;
      s := s.next
   END;
   msg.g := g; Viewers0.Broadcast(msg)
END DeleteSelected;

PROCEDURE (g: Graphic) MoveSelected* (dx, dy: INTEGER);
   VAR s: Shape; msg: NotifyChangeMsg;
BEGIN s := g.shapes;
   WHILE s # NIL DO
      IF s.selected THEN s.Move(dx, dy) END;
      s := s.next
   END;
   msg.g := g; Viewers0.Broadcast(msg)
END MoveSelected;

PROCEDURE (g: Graphic) Draw* (f: Viewers0.Frame);
   VAR s: Shape;
BEGIN s := g.shapes; WHILE s # NIL DO s.Draw(f); s := s.next END
END Draw;

PROCEDURE (g: Graphic) Copy* (): Graphic;
   VAR s, a, b: Shape; g1: Graphic;
BEGIN
   NEW(g1); g1.shapes := NIL;
   s := g.shapes;
   WHILE s # NIL DO
      a := s.Copy(); a.next := NIL;
      IF g1.shapes = NIL THEN g1.shapes := a ELSE b.next := a END;
      b := a; s := s.next
   END;
   RETURN g1
END Copy;

PROCEDURE (g: Graphic) Neutralize*;
   VAR s: Shape; msg: NotifyChangeMsg; changed: BOOLEAN;
BEGIN s := g.shapes; changed := FALSE;
   WHILE s # NIL DO changed := changed OR s.selected; s.Neutralize; s := s.next END;
   IF changed THEN msg.g := g; Viewers0.Broadcast(msg) END
END Neutralize;

PROCEDURE (g: Graphic) SetSelection* (x, y, w, h: INTEGER);
   VAR s: Shape; msg: NotifyChangeMsg;
BEGIN s := g.shapes;
   WHILE s # NIL DO s.SetSelection(x, y, w, h); s := s.next END;
   msg.g := g; Viewers0.Broadcast(msg)
END SetSelection;

PROCEDURE (g: Graphic) GetBox* (VAR x, y, w, h: INTEGER);
   VAR x0, y0, w0, h0: INTEGER; s: Shape;
BEGIN
   x := 0; y := 0; w := 12; h := 12;
   s := g.shapes;
   IF s # NIL THEN s.GetBox(x, y, w, h); s := s.next END;
   WHILE s # NIL DO s.GetBox(x0, y0, w0, h0);
      IF x0 < x THEN INC(w, x - x0); x := x0 END;
      IF y0 < y THEN INC(h, y - y0); y := y0 END;
      IF x0 + w0 > x + w THEN w := x0 + w0 - x END;
      IF y0 + h0 > y + h THEN h := y0 + h0 - y END;
      s := s.next
   END;
END GetBox;

PROCEDURE (g: Graphic) Load* (VAR r: OS.Rider);
   VAR s, last: Shape; x: OS.Object;
BEGIN last := NIL;
   REPEAT r.ReadObj(x);
      IF x = NIL THEN s := NIL ELSE s := x(Shape) END;
      IF last = NIL THEN g.shapes := s ELSE last.next := s END;
      last := s
   UNTIL x = NIL  (*terminated by a NIL shape*)
END Load;

PROCEDURE (g: Graphic) Store* (VAR r: OS.Rider);
   VAR s: Shape;
BEGIN s := g.shapes; WHILE s # NIL DO r.WriteObj(s); s := s.next END;
   r.WriteObj(NIL)
END Store;


BEGIN curShape := ""
END Shapes0.
