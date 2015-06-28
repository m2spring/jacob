MODULE Graphs1;
(* Very tiny graphics editor, Exercise 12.5, page 241.
     Note: In Programming in Oberon, this module is called Graphics. It
     is renamed to avoid naming conflict with the standard Draw package *)

TYPE
   Figure* = POINTER TO FigureDesc;
   FigureDesc* = RECORD
      draw*: PROCEDURE (fig: Figure);
      next: Figure
   END ;

   Graph* = POINTER TO GraphDesc;
   GraphDesc* = RECORD
      list: Figure
   END;

VAR
   newFigure*: PROCEDURE (): Figure;
   spanVect*: PROCEDURE (VAR x1, y1, x2, y2: INTEGER);

PROCEDURE InsertLast(VAR first: Figure; new: Figure);
VAR f: Figure;
BEGIN  (* new # NIL *)
   IF first = NIL THEN new.next := first;  first := new
   ELSE  f := first;
      WHILE f.next # NIL DO f := f.next END;
      new.next := f.next;  f.next := new
   END
END InsertLast;

PROCEDURE DrawAll*(g: Graph);
VAR f: Figure;
BEGIN  f := g.list;
   WHILE f # NIL DO  f.draw(f);  f := f.next  END
END DrawAll;

PROCEDURE NewFigure*(g: Graph);
VAR f: Figure;
BEGIN
   IF newFigure # NIL THEN
      f := newFigure();
      f.draw(f);  InsertLast(g.list, f)
   END
END NewFigure;

PROCEDURE Open*(VAR g: Graph);
BEGIN  g.list := NIL
END Open;

BEGIN newFigure := NIL
END Graphs1.    (* Copyright M. Reiser, 1992 *)
