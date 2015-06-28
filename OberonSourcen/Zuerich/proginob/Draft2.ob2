MODULE Draft2;
(* Very tiny graphics editor with mouse support, Exercise 12.8, page 242.
     Note: In Programming in Oberon, this module is called Draw. It
     is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Display, MenuViewers, Oberon, TextFrames, Input, Graphs:=Graphs2, Shapes;
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
(* Viewer changes size or location*)
BEGIN
   IF (M.id = MenuViewers.extend) & (M.dY > 0) THEN
      (* clear area at top of viewer *)
      Display.ReplConst(Display.black, F.X, F.Y + F.H, F.W, M.dY, Display.replace)
   END;
   IF M.Y < F.Y THEN
      (* clear area at bottom of viewer *)
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
   x, y: INTEGER;
BEGIN
   Oberon.OpenTrack(Display.Left, span);  (* New overlay track *)
   menuF := TextFrames.NewMenu("Graph", "System.Close");  (* Title frame *)
   NEW(g);  g.handle := Handle;  (* create graphic, install handler *)
   Graphs.Open(g);
   Graphs.spanVect := SpanVect;
   Oberon.AllocateUserViewer(Display.Left, x, y);  (* Viewer position *)
   V := MenuViewers.New(menuF, g, TextFrames.menuH, x, y)
END Open;

END Draft2.     (* Copyright M. Reiser, 1992 *)
