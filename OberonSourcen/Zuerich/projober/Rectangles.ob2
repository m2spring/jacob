MODULE Rectangles;  (*NW 25.2.90 / 1.2.92*)
   IMPORT Display, Files, Input, Printer, Texts, Oberon, Graphics, GraphicFrames;

   TYPE
      Rectangle* = POINTER TO RectDesc;

      RectDesc* = RECORD (Graphics.ObjectDesc)
            lw*, vers*: INTEGER
         END ;

   VAR
      method*: Graphics.Method;
      shade: INTEGER;

   PROCEDURE New*;
      VAR r: Rectangle;
   BEGIN NEW(r); r.do := method; Graphics.new := r
   END New;

   PROCEDURE Copy(src, dst: Graphics.Object);
   BEGIN dst.x := src.x; dst.y := src.y; dst.w := src.w; dst.h := src.h; dst.col := src.col;
      dst(Rectangle).lw := src(Rectangle).lw; dst(Rectangle).vers := src(Rectangle).vers
   END Copy;

   PROCEDURE mark(col, x, y: INTEGER);
   BEGIN Display.ReplConst(col, x-4, y, 4, 4, 0)
   END mark;

   PROCEDURE Draw(obj: Graphics.Object; VAR M: Graphics.Msg);
      VAR x, y, w, h, lw, col: INTEGER; s: SET; f: GraphicFrames.Frame;

      PROCEDURE draw(col: INTEGER);
      BEGIN
         IF 0 IN s THEN Display.ReplConst(col, x, y, w, lw, 0) END ;
         IF 1 IN s THEN Display.ReplConst(col, x+w-lw, y, lw, h, 0) END ;
         IF 2 IN s THEN Display.ReplConst(col, x, y+h-lw, w, lw, 0) END ;
         IF 3 IN s THEN Display.ReplConst(col, x, y, lw, h, 0) END
      END draw;

   BEGIN
      WITH M: GraphicFrames.DrawMsg DO
         x := obj.x + M.x; y := obj.y + M.y; w := obj.w; h := obj.h; f := M.f;
         lw := obj(Rectangle).lw; s := {0..3};
         IF x+w < f.X THEN s := {}
         ELSIF x < f.X THEN DEC(w, f.X-x); x := f.X; EXCL(s, 3)
         END ;
         IF x >= f.X1 THEN s := {}
         ELSIF x+w > f.X1 THEN w := f.X1-x; EXCL(s, 1)
         END ;
         IF y+h < f.Y THEN s := {}
         ELSIF y < f.Y THEN DEC(h, f.Y-y); y := f.Y; EXCL(s, 0)
         END ;
         IF y >= f.Y1 THEN s := {}
         ELSIF y+h > f.Y1 THEN h := f.Y1-y; EXCL(s, 2)
         END ;
         IF s # {} THEN
            IF M.col = Display.black THEN col := obj.col ELSE col := M.col END ;
            IF M.mode = 0 THEN
               draw(col);
               IF obj.selected THEN mark(Display.white, x+w-lw, y+lw) END ;
               IF obj(Rectangle).vers # 0 THEN Display.ReplPattern(col, Display.grey0, x, y, w, h, 1) END
            ELSIF M.mode = 1 THEN mark(Display.white, x+w-lw, y+lw)
            ELSIF M.mode = 2 THEN mark(Display.black, x+w-lw, y+lw)
            ELSIF obj(Rectangle).vers = 0 THEN draw(Display.black); mark(Display.black, x+w-lw, y+lw)
            ELSE Display.ReplConst(Display.black, x, y, w, h, 0)
            END
         END
      END
   END Draw;

   PROCEDURE Selectable(obj: Graphics.Object; x, y: INTEGER): BOOLEAN;
   BEGIN
      RETURN (obj.x + obj.w - 4 <= x) & (x <= obj.x + obj.w) & (obj.y <= y) & (y <= obj.y + 4)
   END Selectable;

   PROCEDURE Handle(obj: Graphics.Object; VAR M: Graphics.Msg);
      VAR x0, y0, x1, y1, dx, dy: INTEGER; k: SET;
   BEGIN
      IF M IS Graphics.WidMsg THEN obj(Rectangle).lw := M(Graphics.WidMsg).w
      ELSIF M IS Graphics.ColorMsg THEN obj.col := M(Graphics.ColorMsg).col
      ELSIF M IS GraphicFrames.CtrlMsg THEN
         WITH M: GraphicFrames.CtrlMsg DO
            WITH obj: Rectangle DO
               M.res := 1; x0 := obj.x + obj.w + M.f.x; y0 := obj.y + M.f.y;
               mark(Display.white, x0 - obj.lw, y0 + obj.lw);
               REPEAT Input.Mouse(k, x1, y1);
                  DEC(x1, (x1-M.f.x) MOD 4); DEC(y1, (y1-M.f.y) MOD 4);
                  Oberon.DrawCursor(Oberon.Mouse, GraphicFrames.Crosshair, x1, y1)
               UNTIL k = {};
               mark(Display.black, x0 - obj.lw, y0 + obj.lw);
               IF (x0 - obj.w < x1) & (y1 < y0+ obj.h) THEN
                  GraphicFrames.EraseObj(M.f, obj);
                  dx := x1 - x0; dy := y1 - y0;
                  INC(obj.y, dy); INC(obj.w, dx); DEC(obj.h, dy);
                  GraphicFrames.DrawObj(M.f, obj)
               END
            END
         END
      END
   END Handle;

   PROCEDURE Read(obj: Graphics.Object; VAR R: Files.Rider; VAR C: Graphics.Context);
      VAR w, v: SHORTINT; len: INTEGER;
   BEGIN Graphics.ReadInt(R, len); Files.Read(R, w); Files.Read(R, v);
      obj(Rectangle).lw := w; obj(Rectangle).vers := v
   END Read;

   PROCEDURE Write(obj: Graphics.Object; cno: SHORTINT; VAR W: Files.Rider; VAR C: Graphics.Context);
   BEGIN Graphics.WriteObj(W, cno, obj); Graphics.WriteInt(W, 2);
      Files.Write(W, SHORT(obj(Rectangle).lw)); Files.Write(W, SHORT(obj(Rectangle).vers))
   END Write;

   PROCEDURE Print(obj: Graphics.Object; x, y: INTEGER);
      VAR w, h, lw, s: INTEGER;
   BEGIN INC(x, obj.x * 4); INC(y, obj.y * 4); w := obj.w * 4; h := obj.h * 4;
      lw := obj(Rectangle).lw * 2; s := obj(Rectangle).vers;
      Printer.ReplConst(x, y, w, lw);
      Printer.ReplConst(x+w-lw, y, lw, h);
      Printer.ReplConst(x, y+h-lw, w, lw);
      Printer.ReplConst(x, y, lw, h);
      IF s > 0 THEN Printer.ReplPattern(x, y, w, h, s) END
   END Print;

   PROCEDURE Make*;  (*command*)
      VAR x0, x1, y0, y1: INTEGER;
         R: Rectangle;
         G: GraphicFrames.Frame;
   BEGIN G := GraphicFrames.Focus();
      IF (G # NIL) & (G.mark.next # NIL) THEN
         GraphicFrames.Deselect(G);
         x0 := G.mark.x; y0 := G.mark.y; x1 := G.mark.next.x; y1 := G.mark.next.y;
         NEW(R); R.col := Oberon.CurCol;
         R.w := ABS(x1-x0); R.h := ABS(y1-y0);
         IF x1 < x0 THEN x0 := x1 END ;
         IF y1 < y0 THEN y0 := y1 END ;
         R.x := x0 - G.x; R.y := y0 - G.y;
         R.lw := Graphics.width; R.vers := shade; R.do := method;
         Graphics.Add(G.graph, R);
         GraphicFrames.Defocus(G); GraphicFrames.DrawObj(G, R)
      END
   END Make;

   PROCEDURE SetShade*;
      VAR S: Texts.Scanner;
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Int THEN shade := SHORT(S.i) END
   END SetShade;

BEGIN shade := 0; NEW(method);
   method.module := "Rectangles"; method.allocator := "New";
   method.new := New; method.copy := Copy; method.draw := Draw;
   method.selectable := Selectable; method.handle := Handle;
   method.read := Read; method.write := Write; method.print := Print
END Rectangles.
