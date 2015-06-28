MODULE PrintServer;  (*NW 17.4.89 / 12.9.91*)
   IMPORT SYSTEM, Core, Display, Printmaps, Files, Fonts, Texts, Oberon;

   CONST maxFnt = 32;
      N = 32; (*max dim of splines*)
      PR0 = 0FFF600H;
      proff = 0; prdy = 1; sbusy = 2; end = 3;  (*printer status*)
      BMwidth = 2336; BMheight = 3425;

   TYPE RealVector = ARRAY N OF REAL;
      Poly = RECORD a, b, c, d, t: REAL END ;
      PolyVector = ARRAY N OF Poly;

   VAR W: Texts.Writer;
      handler: Oberon.Task;

      uno, nofcopies, nofpages: INTEGER;
      PR: Files.Rider;  (*print rider*)
      font: ARRAY maxFnt OF Fonts.Font;
      map: ARRAY 256 OF INTEGER;

   PROCEDURE circle(x0, y0, r: LONGINT);
      VAR x, y, u: LONGINT;
   BEGIN u := 1 - r; x := r; y := 0;
      WHILE y <= x DO
         Printmaps.Dot(x0+x, y0+y); Printmaps.Dot(x0+y, y0+x);
         Printmaps.Dot(x0-y, y0+x); Printmaps.Dot(x0-x, y0+y);
         Printmaps.Dot(x0-x, y0-y); Printmaps.Dot(x0-y, y0-x);
         Printmaps.Dot(x0+y, y0-x); Printmaps.Dot(x0+x, y0-y);
         IF u < 0 THEN INC(u, 2*y+3) ELSE INC(u, 2*(y-x)+5); DEC(x) END ;
         INC(y)
      END
   END circle;

   PROCEDURE ellipse(x0, y0, a, b: LONGINT);
      VAR x, y, y1, aa, bb, d, g, h: LONGINT;
   BEGIN aa := a*a; bb := b*b;
      h := (aa DIV 4) - b*aa + bb; g := (9*aa DIV 4) - 3*b*aa + bb; x := 0; y := b;
      WHILE g < 0 DO
         Printmaps.Dot(x0+x, y0+y); Printmaps.Dot(x0-x, y0+y);
         Printmaps.Dot(x0-x, y0-y); Printmaps.Dot(x0+x, y0-y);
         IF h < 0 THEN d := (2*x+3)*bb; INC(g, d)
         ELSE d := (2*x+3)*bb - 2*(y-1)*aa; INC(g, d + 2*aa); DEC(y)
         END ;
         INC(h, d); INC(x)
      END ;
      y1 := y; h := (bb DIV 4) - a*bb + aa; x := a; y := 0;
      WHILE y <= y1 DO
         Printmaps.Dot(x0+x, y0+y); Printmaps.Dot(x0-x, y0+y);
         Printmaps.Dot(x0-x, y0-y); Printmaps.Dot(x0+x, y0-y);
         IF h < 0 THEN INC(h, (2*y+3)*aa) ELSE INC(h, (2*y+3)*aa - 2*(x-1)*bb); DEC(x) END ;
         INC(y)
      END
   END ellipse;

   PROCEDURE ShowPoly(VAR p, q: Poly; lim: REAL);
      VAR t: REAL; x, y: LONGINT;
   BEGIN t := 0;
      REPEAT
         Printmaps.Dot(ENTIER(((p.a * t + p.b) * t + p.c) * t + p.d),
            ENTIER(((q.a * t + q.b) * t + q.c) * t + q.d));
         t := t + 1.0
      UNTIL t >= lim
   END ShowPoly;

   PROCEDURE SolveTriDiag(VAR a, b, c, y: RealVector; n: INTEGER);
      VAR i: INTEGER;
   BEGIN (*a, b, c of tri-diag matrix T; solve Ty' = y for y', assign y' to y*)
      i := 1;
      WHILE i < n DO y[i] := y[i] - c[i-1]*y[i-1]; INC(i) END ;
      i := n-1; y[i] := y[i]/a[i];
      WHILE i > 0 DO DEC(i); y[i] := (y[i] - b[i]*y[i+1])/a[i] END
   END SolveTriDiag;

   PROCEDURE OpenSpline(VAR x, y, d: RealVector; n: INTEGER);
      VAR i: INTEGER; d1, d2: REAL;
         a, b, c: RealVector;
   BEGIN (*from x, y compute d = y'*)
      b[0] := 1.0/(x[1] - x[0]); a[0] := 2.0*b[0]; c[0] := b[0];
      d1 := (y[1] - y[0])*3.0*b[0]*b[0]; d[0] := d1; i := 1;
      WHILE i < n-1 DO
         b[i] := 1.0/(x[i+1] - x[i]);
         a[i] := 2.0*(c[i-1] + b[i]);
         c[i] := b[i];
         d2 := (y[i+1] - y[i])*3.0*b[i]*b[i];
         d[i] := d1 + d2; d1 := d2; INC(i)
      END ;
      a[i] := 2.0*b[i-1]; d[i] := d1; i := 0;
      WHILE i < n-1 DO c[i] := c[i]/a[i]; a[i+1] := a[i+1] - c[i]*b[i]; INC(i) END ;
      SolveTriDiag(a, b, c, d, n)
   END OpenSpline;

   PROCEDURE ClosedSpline(VAR x, y, d: RealVector; n: INTEGER);
      VAR i: INTEGER; d1, d2, hn, dn: REAL;
         a, b, c, w: RealVector;
   BEGIN (*from x, y compute d = y'*)
      hn := 1.0/(x[n-1] - x[n-2]);
      dn := (y[n-1] - y[n-2])*3.0*hn*hn;
      b[0] := 1.0/(x[1] - x[0]);
      a[0] := 2.0*b[0] + hn;
      c[0] := b[0];
      d1 := (y[1] - y[0])*3.0*b[0]*b[0]; d[0] := dn + d1;
      w[0] := 1.0; i := 1;
      WHILE i < n-2 DO
         b[i] := 1.0/(x[i+1] - x[i]);
         a[i] := 2.0*(c[i-1] + b[i]);
         c[i] := b[i];
         d2 := (y[i+1] - y[i])*3.0*b[i]*b[i]; d[i] := d1 + d2; d1 := d2;
         w[i] := 0; INC(i)
      END ;
      a[i] := 2.0*b[i-1] + hn; d[i] := d1 + dn;
      w[i] := 1.0; i := 0;
      WHILE i < n-2 DO c[i] := c[i]/a[i]; a[i+1] := a[i+1] - c[i]*b[i]; INC(i) END ;
      SolveTriDiag(a, b, c, d, n-1); SolveTriDiag(a, b, c, w, n-1);
      d1 := (d[0] + d[i])/(w[0] + w[i] + x[i+1] - x[i]); i := 0;
      WHILE i < n-1 DO d[i] := d[i] - d1*w[i]; INC(i) END ;
      d[i] := d[0]
   END ClosedSpline;

   PROCEDURE CompSpline(x0, y0, n, open: INTEGER);
      VAR i, k: INTEGER; dx, dy, ds: REAL;
         x, xd, y, yd, s: RealVector;
         p, q: PolyVector;
   BEGIN (*from u, v compute x, y, s*)
      Files.ReadBytes(PR, k, 2); x[0] := k + x0;
      Files.ReadBytes(PR, k, 2); y[0] := k + y0; s[0] := 0; i := 1;
      WHILE i < n DO
         Files.ReadBytes(PR, k, 2); x[i] := k + x0; dx := x[i] - x[i-1];
         Files.ReadBytes(PR, k, 2); y[i] := k + y0; dy := y[i] - y[i-1];
         s[i] := ABS(dx) + ABS(dy) + s[i-1]; INC(i)
      END ;
      IF open = 1 THEN OpenSpline(s, x, xd, n); OpenSpline(s, y, yd, n)
      ELSE ClosedSpline(s, x, xd, n); ClosedSpline(s, y, yd, n)
      END ;
      (*compute coefficients from x, y, xd, yd, s*)  i := 0;
      WHILE i < n-1 DO
         ds := 1.0/(s[i+1] - s[i]);
         dx := (x[i+1] - x[i])*ds;
         p[i].a := ds*ds*(xd[i] + xd[i+1] - 2.0*dx);
         p[i].b := ds*(3.0*dx - 2.0*xd[i] -xd[i+1]);
         p[i].c := xd[i];
         p[i].d := x[i];
         p[i].t := s[i];
         dy := ds*(y[i+1] - y[i]);
         q[i].a := ds*ds*(yd[i] + yd[i+1] - 2.0*dy);
         q[i].b := ds*(3.0*dy - 2.0*yd[i] - yd[i+1]);
         q[i].c := yd[i];
         q[i].d := y[i];
         q[i].t := s[i]; INC(i)
      END ;
      p[i].t := s[i]; q[i].t := s[i];
      (*display polynomials*)
      i := 0;
      WHILE i < n-1 DO ShowPoly(p[i], q[i], p[i+1].t - p[i].t); INC(i) END
   END CompSpline;

   PROCEDURE^ ProcessPage;
   PROCEDURE^ PrintPage;
   PROCEDURE^ WaitForCompletion;

   PROCEDURE Terminate;
      VAR i: INTEGER;
   BEGIN Core.RemoveTask(Core.PrintQueue); i := 0;
      REPEAT font[i] := NIL; INC(i) UNTIL i = maxFnt  (*release fonts*)
   END Terminate;

   PROCEDURE Append(src: ARRAY OF CHAR; VAR dst: ARRAY OF SYSTEM.BYTE; VAR k: INTEGER);
      VAR i: INTEGER; ch: CHAR;
   BEGIN i := 0;
      REPEAT ch := src[i]; dst[k] := ch; INC(i); INC(k) UNTIL ch = 0X
   END Append;

   PROCEDURE PickTask;
      VAR F: Files.File;
         Id: Core.ShortName;
         tag: CHAR;
   BEGIN
      IF (Core.PrintQueue.n > 0) & ~SYSTEM.BIT(PR0, proff) & SYSTEM.BIT(PR0, prdy) THEN
         Core.GetTask(Core.PrintQueue, F, Id, uno); nofpages := 0;
         Files.Set(PR, F, 0); Files.Read(PR, tag);
         IF tag = 0FCX THEN handler.handle := ProcessPage
         ELSE Texts.WriteString(W, Id); Texts.WriteString(W, " not a print file");
            Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf); Terminate
         END
      END
   END PickTask;

   PROCEDURE ProcessPage;
      VAR i, x, y, w, h, x0, x1, y0, y1: INTEGER;
         a, a0, a1: LONGINT;
         d, u: INTEGER;
         typ, sp: SHORTINT;
         ch: CHAR;
         fnt: Fonts.Font;
         fname: Core.Name;

      PROCEDURE String;
         VAR ch: CHAR;
            dx, x0, y0, w, h: INTEGER;
            fnt: Fonts.Font;
            pat: LONGINT;
      BEGIN fnt := font[sp MOD maxFnt];
         IF (x >= 0) & (y >= 0) & (fnt # NIL) & (y + fnt.height < BMheight) THEN
            LOOP Files.Read(PR, ch);
               IF ch = 0X THEN EXIT END ;
               Display.GetChar(fnt.raster, ch, dx, x0, y0, w, h, pat);
               IF (x + x0 + w <= BMwidth) & (h > 0) THEN
                  Printmaps.CopyPattern(pat, x+x0, y+y0)
               END ;
               INC(x, dx)
            END
         END
      END String;

   BEGIN Printmaps.ClearPage;
      LOOP Files.Read(PR, typ);
         IF PR.eof THEN
            Core.IncPageCount(uno, nofpages); Terminate; handler.handle := PickTask; EXIT
         END ;
         Files.Read(PR, sp);
         IF typ = 0 THEN String
         ELSIF typ = 1 THEN
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2); String
         ELSIF typ = 2 THEN
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2);
            Files.ReadBytes(PR, w, 2); Files.ReadBytes(PR, h, 2);
            IF x < 0 THEN INC(w, x); x := 0 END ;
            IF x+w > BMwidth THEN w := BMwidth - x END ;
            IF y < 0 THEN INC(h, y); y := 0 END ;
            IF y+h > BMheight THEN h := BMheight - y END ;
            Printmaps.ReplConst(x, y, w, h)
         ELSIF typ = 3 THEN
            i := 0;
            REPEAT Files.Read(PR, fname[i]); INC(i) UNTIL fname[i-1] < "0";
            DEC(i); Append(".Pr3.Fnt", fname, i);
            fnt := Fonts.This(fname);
            IF fnt = Fonts.Default THEN fnt := Fonts.This("Syntax10.Pr3.Fnt") END ;
            font[sp MOD maxFnt] := fnt
         ELSIF typ = 4 THEN
            nofcopies := sp; handler.handle := PrintPage; EXIT
         ELSIF typ = 5 THEN  (*shaded area*)
            IF (sp < 0) OR (sp > 9) THEN sp := 2 END ;
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2);
            Files.ReadBytes(PR, w, 2); Files.ReadBytes(PR, h, 2);
            IF x < 0 THEN INC(w, x); x := 0 END ;
            IF x+w > BMwidth THEN w := BMwidth - x END ;
            IF y < 0 THEN INC(h, y); y := 0 END ;
            IF y+h > BMheight THEN h := BMheight - y END ;
            Printmaps.ReplPattern(Printmaps.Pat[sp], x, y, w, h)
         ELSIF typ = 6 THEN  (*line*)
            Files.ReadBytes(PR, x0, 2); Files.ReadBytes(PR, y0, 2);
            Files.ReadBytes(PR, x1, 2); Files.ReadBytes(PR, y1, 2);
            w := ABS(x1-x0); h := ABS(y1-y0);
            IF h <= w THEN
               IF x1 < x0 THEN u := x0; x0 := x1; x1 := u; u := y0; y0 := y1; y1 := u END ;
               IF y0 <= y1 THEN d := 1 ELSE d := -1 END ;
               u := (h-w) DIV 2;
               WHILE x0 < x1 DO
                  Printmaps.Dot(x0, y0); INC(x0);
                  IF u < 0 THEN INC(u, h) ELSE INC(u, h-w); INC(y0, d) END
               END
            ELSE
               IF y1 < y0 THEN u := x0; x0 := x1; x1 := u; u := y0; y0 := y1; y1 := u END ;
               IF x0 <= x1 THEN d := 1 ELSE d := -1 END ;
               u := (w-h) DIV 2;
               WHILE y0 < y1 DO
                  Printmaps.Dot(x0, y0); INC(y0);
                  IF u < 0 THEN INC(u, w) ELSE INC(u, w-h); INC(x0, d) END
               END
            END
         ELSIF typ = 7 THEN  (*ellipse*)
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2);
            Files.ReadBytes(PR, w, 2); Files.ReadBytes(PR, h, 2);
            ellipse(x, y, w, h)
         ELSIF typ = 8 THEN  (*picture*)
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2);
            Files.ReadBytes(PR, w, 2); Files.ReadBytes(PR, h, 2);
            IF sp = 1 THEN (*enlarge factor 2*)
               IF (x >= 0) & (w+x < BMwidth DIV 2) & (y >= 0) & (h+y < BMheight DIV 2) THEN
                  a := Printmaps.Map() + LONG(BMheight -1 - y)*(BMwidth DIV 8) + (x DIV 4);
                  w := (w + 7) DIV 8 * 2;
                  WHILE h > 0 DO
                     a0 := a; a1 := a + w;
                     WHILE a0 < a1 DO
                        Files.Read(PR, ch); SYSTEM.PUT(a0, map[ORD(ch)]);
                        SYSTEM.PUT(a0 + (BMwidth DIV 8), map[ORD(ch)]); INC(a0, 2)
                     END ;
                     DEC(a, BMwidth DIV 4); DEC(h)
                  END
               END
            ELSIF (x >= 0) & (w+x < BMwidth) & (y >= 0) & (h+y < BMheight) THEN
               a := Printmaps.Map() + LONG(BMheight -1 - y)*(BMwidth DIV 8) + (x DIV 8);
               w := (w + 7) DIV 8;
               WHILE h > 0 DO
                  a0 := a; a1 := a + w;
                  WHILE a0 < a1 DO
                     Files.Read(PR, ch); SYSTEM.PUT(a0, ch); INC(a0)
                  END ;
                  DEC(a, BMwidth DIV 8); DEC(h)
               END
            END
         ELSIF typ = 9 THEN  (*circle*)
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2);
            Files.ReadBytes(PR, w, 2); circle(x, y, w)
         ELSIF typ = 10 THEN (*spline*)
            Files.ReadBytes(PR, x, 2); Files.ReadBytes(PR, y, 2);
            Files.ReadBytes(PR, u, 2);
            IF (u >= 0) & (u <= N) THEN CompSpline(x, y, u, sp)
            ELSE Files.Set(PR, Files.Base(PR), Files.Pos(PR) + 4*u)  (*skip*)
            END
         ELSE
            Texts.WriteString(W, " error in print file at");
            Texts.WriteInt(W, Files.Pos(PR), 6); Texts.WriteInt(W, typ, 5);
            Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf);
            Terminate; handler.handle := PickTask; EXIT
         END
      END
   END ProcessPage;

   PROCEDURE PrintPage;
   BEGIN
      IF SYSTEM.BIT(PR0, prdy) THEN
         SYSTEM.PUT(PR0, Printmaps.Map()); handler.handle := WaitForCompletion;
         REPEAT UNTIL SYSTEM.BIT(PR0, end)
      END
   END PrintPage;

   PROCEDURE WaitForCompletion;
   BEGIN
      IF ~SYSTEM.BIT(PR0, end) THEN
         DEC(nofcopies); INC(nofpages);
         IF nofcopies > 0 THEN handler.handle := PrintPage; DEC(nofcopies)
         ELSE handler.handle := ProcessPage
         END
      END
   END WaitForCompletion;

   (*------------------------ Commands -------------------------*)

   PROCEDURE Start*;
   BEGIN
      IF ~SYSTEM.BIT(PR0, proff) THEN
         handler.handle := PickTask; Oberon.Remove(handler); Oberon.Install(handler);
         Texts.WriteString(W, "Printer started  (NW 12.9.91)")
      ELSE Texts.WriteString(W, "Printer off")
      END ;
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Start;

   PROCEDURE State*;
      VAR s: SHORTINT;
   BEGIN Texts.WriteString(W, "Printer Queue:");
      Texts.WriteInt(W, Core.PrintQueue.n, 4); Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END State;

   PROCEDURE Reset*;
   BEGIN; handler.handle := PickTask;
   END Reset;

   PROCEDURE Stop*;
   BEGIN Oberon.Remove(handler); Texts.WriteString(W, "Printer stopped");
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Stop;

   PROCEDURE RemoveTask*;
      VAR F: Files.File; id: Core.ShortName; uno: INTEGER;
   BEGIN
      IF Core.PrintQueue.n > 0 THEN
         Core.GetTask(Core.PrintQueue, F, id, uno); Core.RemoveTask(Core.PrintQueue);
         Texts.WriteString(W, id); Texts.WriteString(W, " print task removed");
         Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
      END
   END RemoveTask;

   PROCEDURE InitMap;  (*map for picture enlargement and patterns*)
      VAR i, k, s, t: INTEGER;
   BEGIN i := 0;
      REPEAT k := i; s := 0; t := 3;
         WHILE k > 0 DO
            IF ODD(k) THEN INC(s, t) END ;
            t := 4*t; k := k DIV 2
         END ;
         map[i] := s; INC(i)
      UNTIL i = 256
   END InitMap;

BEGIN Texts.OpenWriter(W); InitMap; NEW(handler)
END PrintServer.
