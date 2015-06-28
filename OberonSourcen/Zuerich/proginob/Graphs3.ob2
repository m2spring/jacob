MODULE Graphs3;
(* Very tiny graphics editor with  file I/O, Exercise 12.12, page 243.
   Note: In Programming in Oberon, this module is called Graphics. It
   is renamed to avoid naming conflict with the standard Draw package *)

IMPORT Oberon, Files, Files1:=Files, Display;
TYPE
   Figure* = POINTER TO FigureDesc;
   FigureDesc* = RECORD
      draw*, store*: PROCEDURE (fig: Figure);
      next: Figure
   END ;

   Graph* = POINTER TO GraphDesc;
   GraphDesc* = RECORD (Display.FrameDesc)
      list: Figure
   END;

VAR
   newFigure*: PROCEDURE (): Figure;  (* up-call to create new figure *)
   loadFigure*: PROCEDURE (): Figure;  (* up-call to read figure from file *)
   spanVect*: PROCEDURE (VAR x1, y1, x2, y2: INTEGER);  (* up-call to define vector *)
   rider*: Files.Rider;

PROCEDURE InsertLast(VAR first: Figure; new: Figure);
VAR f: Figure;
BEGIN  (* new # NIL *)
   IF first = NIL THEN new.next := NIL;  first := new
   ELSE  f := first;
      WHILE f.next # NIL DO f := f.next END;
      new.next := NIL;  f.next := new
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

PROCEDURE Open*(name: ARRAY OF CHAR; g: Graph);
VAR f: Figure; file: Files.File;  cmd: ARRAY 32 OF CHAR;  res: INTEGER;
BEGIN g.list := NIL;
   file := Files.Old(name);
   IF file # NIL THEN
      Files.Set(rider, file, 0);
      Files1.ReadString(rider, cmd);
      WHILE ~rider.eof DO
         Oberon.Call(cmd, Oberon.Par, FALSE, res);
         f := loadFigure();  InsertLast(g.list, f);
         Files1.ReadString(rider, cmd)
      END
   END
END Open;

PROCEDURE Store*(name: ARRAY OF CHAR; g: Graph);
VAR file: Files.File;  f: Figure;
BEGIN
   file := Files.New(name);  Files.Set(rider, file, 0);
   f := g.list;
   WHILE f # NIL DO  f.store(f);  f := f.next  END;
   Files.Register(file);
END Store;

BEGIN newFigure := NIL
END Graphs3.    (* Copyright M. Reiser, 1992 *)
