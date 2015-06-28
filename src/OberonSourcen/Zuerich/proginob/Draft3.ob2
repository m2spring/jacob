MODULE Draft3;
(* Very tiny graphics editor with  file I/O, Exercise 12.12, page 243.
   Note: In Programming in Oberon, this module is called Draw. It
   is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Display, Viewers, MenuViewers, Oberon, TextFrames, Input, Graphs:=Graphs3, Shapes, In, Out;
CONST  right* = 0;  middle* = 1;  left* = 2;

PROCEDURE SpanVect(VAR x1, y1, x2, y2: INTEGER);
VAR keys: SET;
BEGIN
   Input.Mouse(keys, x1, y1);
   WHILE left IN keys DO
      Input.Mouse(keys, x2, y2);
      Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x2, y2)
   END
END SpanVect;

PROCEDURE Modify(F: Graphs.Graph; VAR M: MenuViewers.ModifyMsg);
BEGIN
   IF (M.id = MenuViewers.extend) & (M.dY > 0) THEN
      Display.ReplConst(Display.black, F.X, F.Y + F.H, F.W, M.dY, Display.replace)
   END;
   IF M.Y < F.Y THEN
      Display.ReplConst(Display.black, F.X, M.Y, F.W, F.Y - M.Y, Display.replace)
   END;
   Shapes.SetClipping(F.X, M.Y, F.W, M.H);
   Graphs.DrawAll(F)
END Modify;

PROCEDURE Handle*(F: Display.Frame; VAR M: Display.FrameMsg);
VAR x, y, x1, y1, x2, y2: INTEGER;
BEGIN
   WITH F: Graphs.Graph DO
      IF M IS Oberon.InputMsg THEN
         WITH M: Oberon.InputMsg DO
            IF M.id = Oberon.track THEN
               Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, M.X, M.Y);
               IF left IN M.keys THEN Graphs.NewFigure(F)
               END
            END
         END
      ELSIF M IS MenuViewers.ModifyMsg THEN
         Modify(F, M(MenuViewers.ModifyMsg))
      END
   END
END Handle;

PROCEDURE Open*;
CONST span = 0;
VAR
   g: Graphs.Graph;
   menuF: TextFrames.Frame;
   V: MenuViewers.Viewer;
   x, y: INTEGER;  name: ARRAY 32 OF CHAR;
BEGIN
   In.Open;  In.Name(name);
   Oberon.OpenTrack(Display.Left, span);
   menuF := TextFrames.NewMenu(name, "System.Close");
   NEW(g);  g.handle := Handle;  Graphs.Open(name, g);
   Graphs.spanVect := SpanVect;
   Oberon.AllocateUserViewer(Display.Left, x, y);
   V := MenuViewers.New(menuF, g, TextFrames.menuH, x, y)
END Open;

PROCEDURE Store*;
(* Store the marked viewer in file name *)
VAR V: Viewers.Viewer;  name: ARRAY 32 OF CHAR;
BEGIN
   In.Open;  In.Name(name);
   Out.String("Draft.Store ");  Out.String(name);  Out.Ln;
   V := Oberon.MarkedViewer();
   Graphs.Store(name, V.dsc.next(Graphs.Graph))
END Store;


END Draft3.     (* Copyright M. Reiser, 1992 *)
