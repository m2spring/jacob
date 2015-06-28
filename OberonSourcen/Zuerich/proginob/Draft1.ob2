MODULE Draft1;
(* Very tiny graphics editor, Exercise 12.5, page 241.
     Note: In Programming in Oberon, this module is called Draw. It
     is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Graphs:=Graphs1, Shapes,  XYplane, In;
VAR g: Graphs.Graph;

PROCEDURE SpanVect(VAR x1, y1, x2, y2: INTEGER);
BEGIN In.Open;  In.Int(x1);  In.Int(y1);  In.Int(x2);  In.Int(y2)
END SpanVect;

PROCEDURE Open*;
BEGIN
     XYplane.Open;
     Shapes.SetClipping(XYplane.X, XYplane.Y, XYplane.W, XYplane.H);
     NEW(g);  Graphs.Open(g);
     Graphs.spanVect := SpanVect
END Open;

PROCEDURE DrawAll*;
(* Redraws graphic after part of it was cleared through repositioning of
    title bar or clearing of overlapping viewers *)
BEGIN
     Shapes.SetClipping(XYplane.X, XYplane.Y, XYplane.W, XYplane.H);
     Graphs.DrawAll(g)
END DrawAll;

PROCEDURE New*;
BEGIN Graphs.NewFigure(g)
END New;

END Draft1.     (* Copyright M. Reiser, 1992 *)
