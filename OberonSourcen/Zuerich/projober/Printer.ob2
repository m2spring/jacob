MODULE Printer;  (*NW 27.6.88 / 11.3.91*)
   IMPORT SYSTEM, Input, SCC;

   CONST maxfonts = 16;
      PakSize = 512; Broadcast = -1;
      T0 = 300; T1 = 1200;
      ACK = 10H; NAK = 25H;
      NRQ = 34H; NRS = 35H;
      PRT = 43H; NPR = 26H; TOT = 7FH;

   VAR res*: INTEGER; (*0 = done, 1 = not done*)
      PageWidth*, PageHeight*: INTEGER;
      nofonts: INTEGER;
      seqno: SHORTINT;
      head0: SCC.Header;  (*sender*)
      head1: SCC.Header;  (*receiver*)
      in: INTEGER;
      PrinterName: ARRAY 10 OF CHAR;
      fontname: ARRAY maxfonts, 32 OF CHAR;
      buf: ARRAY PakSize OF SYSTEM.BYTE;

   PROCEDURE ReceiveHead;
      VAR time: LONGINT;
   BEGIN time := Input.Time() + T0;
      LOOP SCC.ReceiveHead(head1);
         IF head1.valid THEN
            IF head1.sadr = head0.dadr THEN EXIT ELSE SCC.Skip(head1.len) END
         ELSIF Input.Time() >= time THEN head1.typ := TOT; EXIT
         END
      END
   END ReceiveHead;

   PROCEDURE FindPrinter(VAR name: ARRAY OF CHAR);
      VAR time: LONGINT;
         id: ARRAY 10 OF CHAR;
   BEGIN head0.typ := NRQ; head0.dadr := Broadcast; head0.len := 10;
      head0.destLink := 0; COPY(name, id); id[8] := 6X; id[9] := 0X;
      SCC.Skip(SCC.Available()); SCC.SendPacket(head0, id); time := Input.Time() + T1;
      LOOP SCC.ReceiveHead(head1);
         IF head1.valid THEN
            IF head1.typ = NRS THEN head0.dadr := head1.sadr; res := 0; EXIT
            ELSE SCC.Skip(head1.len)
            END
         ELSIF Input.Time() >= time THEN res := 1; EXIT
         END
      END
   END FindPrinter;

   PROCEDURE SendPacket;
   BEGIN head0.typ := seqno; head0.len := in;
      REPEAT SCC.SendPacket(head0, buf); ReceiveHead;
      UNTIL head1.typ # seqno + ACK;
      seqno := (seqno+1) MOD 8;
      IF head1.typ # seqno + ACK THEN res := 1 END
   END SendPacket;

   PROCEDURE Send(x: SYSTEM.BYTE);
   BEGIN buf[in] := x; INC(in);
      IF in = PakSize THEN SendPacket; in := 0 END
   END Send;

   PROCEDURE SendInt(k: INTEGER);
   BEGIN Send(SHORT(k MOD 100H)); Send(SHORT(k DIV 100H))
   END SendInt;

   PROCEDURE SendBytes(VAR x: ARRAY OF SYSTEM.BYTE; n: INTEGER);
      VAR i: INTEGER;
   BEGIN i := 0;
      WHILE i < n DO Send(x[i]); INC(i) END
   END SendBytes;

   PROCEDURE SendString(VAR s: ARRAY OF CHAR);
      VAR i: INTEGER;
   BEGIN i := 0;
      WHILE s[i] > 0X DO Send(s[i]); INC(i) END ;
      Send(0)
   END SendString;


   PROCEDURE Open*(VAR name, user: ARRAY OF CHAR; password: LONGINT);
      VAR i, j: INTEGER; faxno: ARRAY 32 OF CHAR;
   BEGIN i := 0; j := 0;
      WHILE (name[i] # 0X) & (name[i] # ".") DO INC(i) END;
      IF name[i] # 0X THEN name[i] := 0X; INC(i);
         WHILE name[i] # 0X DO faxno[j] := name[i]; INC(i); INC(j) END
      END;
      faxno[j] := 0X; nofonts := 0; in := 0; seqno := 0; SCC.Skip(SCC.Available());
      IF name # PrinterName THEN FindPrinter(name) ELSE res := 0 END ;
      IF res = 0 THEN
         SendString(user); SendBytes(password, 4);
         head0.typ := PRT; head0.len := in; SCC.SendPacket(head0, buf); in := 0;
         ReceiveHead;
         IF head1.typ = ACK THEN Send(0FCX); (*printfileid*)
            IF faxno[0] # 0X THEN Send(1); Send(0); SendInt(0); SendInt(0); SendString(faxno) END
         ELSIF head1.typ = NPR THEN res := 4 (*no permission*)
         ELSE res := 2 (*no printer*)
         END
      END
   END Open;

   PROCEDURE ReplConst*(x, y, w, h: INTEGER);
   BEGIN Send(2); Send(0);
      SendInt(x); SendInt(y); SendInt(w); SendInt(h)
   END ReplConst;

   PROCEDURE fontno(VAR name: ARRAY OF CHAR): SHORTINT;
      VAR i, j: INTEGER;
   BEGIN i := 0;
      WHILE (i < nofonts) & (fontname[i] # name) DO INC(i) END ;
      IF i = nofonts THEN
         IF nofonts < maxfonts THEN
            COPY(name, fontname[i]); INC(nofonts);
            Send(3); Send(SHORT(i)); j := 0;
            WHILE name[j] >= "0" DO Send(name[j]); INC(j) END ;
            Send(0)
         ELSE i := 0
         END
      END ;
      RETURN SHORT(i)
   END fontno;

   PROCEDURE UseListFont*(VAR name: ARRAY OF CHAR);
      VAR i: INTEGER;
         listfont: ARRAY 10 OF CHAR;
   BEGIN listfont := "Gacha10l"; i := 0;
      WHILE (i < nofonts) & (fontname[i] # name) DO INC(i) END ;
      IF i = nofonts THEN
         COPY(name, fontname[i]); INC(nofonts);
         Send(3); Send(SHORT(i)); SendBytes(listfont, 9)
      END ;
   END UseListFont;

   PROCEDURE String*(x, y: INTEGER; VAR s, fname: ARRAY OF CHAR);
      VAR fno: SHORTINT;
   BEGIN fno := fontno(fname); Send(1); Send(fno); SendInt(x); SendInt(y); SendString(s)
   END String;

   PROCEDURE ContString*(VAR s, fname: ARRAY OF CHAR);
      VAR fno: SHORTINT;
   BEGIN fno := fontno(fname); Send(0); Send(fno); SendString(s)
   END ContString;

   PROCEDURE ReplPattern*(x, y, w, h, col: INTEGER);
   BEGIN Send(5); Send(SHORT(col)); SendInt(x); SendInt(y); SendInt(w); SendInt(h)
   END ReplPattern;

   PROCEDURE Line*(x0, y0, x1, y1: INTEGER);
   BEGIN Send(6); Send(0); SendInt(x0); SendInt(y0); SendInt(x1); SendInt(y1)
   END Line;

   PROCEDURE Circle*(x0, y0, r: INTEGER);
   BEGIN Send(9); Send(0); SendInt(x0); SendInt(y0); SendInt(r)
   END Circle;

   PROCEDURE Ellipse*(x0, y0, a, b: INTEGER);
   BEGIN Send(7); Send(0); SendInt(x0); SendInt(y0); SendInt(a); SendInt(b)
   END Ellipse;

   PROCEDURE Spline*(x0, y0, n, open: INTEGER; VAR X, Y: ARRAY OF INTEGER);
      VAR i: INTEGER;
   BEGIN Send(10); Send(SHORT(open)); SendInt(x0); SendInt(y0); SendInt(n); i := 0;
      WHILE i < n DO SendInt(X[i]); SendInt(Y[i]); INC(i) END
   END Spline;

   PROCEDURE Picture*(x, y, w, h, mode: INTEGER; adr: LONGINT);
      VAR a0, a1: LONGINT; b: SHORTINT;
   BEGIN Send(8); Send(SHORT(mode));
      SendInt(x); SendInt(y); SendInt(w); SendInt(h);
      a0 := adr; a1 := LONG((w+7) DIV 8) * h + a0;
      WHILE (a0 < a1) & (res = 0) DO SYSTEM.GET(a0, b); Send(b); INC(a0) END
   END Picture;

   PROCEDURE Page*(nofcopies: INTEGER);
   BEGIN Send(4); Send(SHORT(nofcopies))
   END Page;

   PROCEDURE Close*;
   BEGIN SendPacket;
      WHILE nofonts > 0 DO DEC(nofonts); fontname[nofonts, 0] := " " END
   END Close;

BEGIN PageWidth := 2336; PageHeight := 3425; in := 0; PrinterName[0] := 0X
END Printer.
