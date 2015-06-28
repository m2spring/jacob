MODULE Texts; (** CAS 30-Sep-91 / interface based on Texts by JG / NW 6.12.91**)
   IMPORT
      Files, Modules, Fonts, Display, Reals;


   CONST
      Tag* = -4095; ElemChar* = 1CX;
      TAB = 9X; CR = 0DX; maxD = 9;
      (**FileMsg.id**)
         load* = 0; store* = 1;
      (**Notifier op**)
         replace* = 0; insert* = 1; delete* = 2;
      (**Scanner.class**)
         Inval* = 0; Name* = 1; String* = 2; Int* = 3; Real* = 4; LongReal* = 5; Char* = 6;


   TYPE
      Run = POINTER TO RunDesc;
      RunDesc = RECORD
         prev, next: Run;
         len: LONGINT;
         fnt: Fonts.Font;
         col, voff: SHORTINT
      END;

      Piece = POINTER TO PieceDesc;
      PieceDesc = RECORD (RunDesc)
         file: Files.File;
         org: LONGINT
      END;

      Elem* = POINTER TO ElemDesc;
      Buffer* = POINTER TO BufDesc;
      Text* = POINTER TO TextDesc;

      ElemMsg* = RECORD END;
      Handler* = PROCEDURE (e: Elem; VAR msg: ElemMsg);

      ElemDesc* = RECORD (RunDesc)
         W*, H*: LONGINT;
         handle*: Handler;
         base: Text
      END;

      FileMsg* = RECORD (ElemMsg)
         id*: INTEGER;
         pos*: LONGINT;
         r*: Files.Rider
      END;

      CopyMsg* = RECORD (ElemMsg)
         e*: Elem
      END;

      IdentifyMsg* = RECORD (ElemMsg)
         mod*, proc*: ARRAY 32 OF CHAR
      END;


      BufDesc* = RECORD
         len*: LONGINT;
         head: Run
      END;

      Notifier* = PROCEDURE (T: Text; op: INTEGER; beg, end: LONGINT);

      TextDesc* = RECORD
         len*: LONGINT;
         notify*: Notifier;
         head, cache: Run;
         corg: LONGINT
      END;

      Reader* = RECORD (Files.Rider)
         eot*: BOOLEAN;
         fnt*: Fonts.Font;
         col*, voff*: SHORTINT;
         elem*: Elem;
         run: Run;
         org, off: LONGINT
      END;

      Scanner* = RECORD (Reader)
         nextCh*: CHAR;
         line*, class*: INTEGER;
         i*: LONGINT;
         x*: REAL;
         y*: LONGREAL;
         c*: CHAR;
         len*: SHORTINT;
         s*: ARRAY 32 OF CHAR
      END;

      Writer* = RECORD (Files.Rider)
         buf*: Buffer;
         fnt*: Fonts.Font;
         col*, voff*: SHORTINT;
         file: Files.File
      END;

      Alien = POINTER TO RECORD (ElemDesc)
         file: Files.File;
         org, span: LONGINT;
         mod, proc: ARRAY 32 OF CHAR
      END;


   VAR
      new*: Elem;
      del: Buffer;


   (* file primitives, portable *)

   PROCEDURE RdString (VAR r: Files.Rider; VAR s: ARRAY OF CHAR);
      VAR i: INTEGER; ch: CHAR;
   BEGIN i := 0;
      REPEAT Files.Read(r, ch); s[i] := ch; INC(i) UNTIL (ch = 0X) OR (i = LEN(s));
      WHILE ~r.eof & (ch # 0X) DO Files.Read(r, ch) END;   (*synch if string too long*)
      s[i] := 0X
   END RdString;

   PROCEDURE RdInt (VAR r: Files.Rider; VAR n: INTEGER);
      VAR c0: CHAR; s1: SHORTINT;
   BEGIN Files.Read(r, c0); Files.Read(r, s1);
      n := LONG(s1) * 100H + ORD(c0)
   END RdInt;

   PROCEDURE RdLong (VAR r: Files.Rider; VAR n: LONGINT);
      VAR c0, c1, c2: CHAR; s3: SHORTINT;
   BEGIN Files.Read(r, c0); Files.Read(r, c1); Files.Read(r, c2); Files.Read(r, s3);
      n := ( (LONG(s3) * 100H + ORD(c2)) * 100H + ORD(c1) ) * 100H + ORD(c0)
   END RdLong;


   PROCEDURE WrtString (VAR r: Files.Rider; VAR s: ARRAY OF CHAR);
      VAR i: INTEGER;
   BEGIN i := 0;
      REPEAT INC(i) UNTIL s[i] = 0X;
      Files.WriteBytes(r, s, i + 1)
   END WrtString;

   PROCEDURE WrtInt (VAR r: Files.Rider; n: INTEGER);
   BEGIN Files.Write(r, CHR(n MOD 100H)); Files.Write(r, SHORT(n DIV 100H))
   END WrtInt;

   PROCEDURE WrtLong (VAR r: Files.Rider; n: LONGINT);
   BEGIN Files.Write(r, CHR(n MOD 100H)); Files.Write(r, CHR(n DIV 100H MOD 100H));
      Files.Write(r, CHR(n DIV 10000H MOD 100H)); Files.Write(r, SHORT(SHORT((n DIV 1000000H))) )
   END WrtLong;


   (* run primitives *)

   PROCEDURE Find (T: Text; VAR pos: LONGINT; VAR u: Run; VAR org, off: LONGINT);
      VAR v: Run; m: LONGINT;
   BEGIN
      IF pos >= T.len THEN pos := T.len; u := T.head; org := T.len; off := 0; T.cache := T.head; T.corg := 0
      ELSE v := T.cache.next; m := pos - T.corg;
         IF pos >= T.corg THEN
            WHILE m >= v.len DO DEC(m, v.len); v := v.next END
         ELSE
            WHILE m < 0 DO v := v.prev; INC(m, v.len) END;
         END;
         u := v; org := pos - m; off := m; T.cache := v.prev; T.corg := org
      END
   END Find;

   PROCEDURE Split (off: LONGINT; VAR u, un: Run);
      VAR p: Piece;
   BEGIN
      IF off = 0 THEN un := u; u := un.prev
      ELSIF off >= u.len THEN un := u.next
      ELSE NEW(p); un := p;
         WITH u: Piece DO p^ := u^; INC(p.org, off); DEC(p.len, off); DEC(u.len, p.len);
            p.prev := u; p.next := u.next; p.next.prev := p; u.next := p
         END
      END
   END Split;

   PROCEDURE Merge (T: Text; u: Run; VAR v: Run);
      VAR p, q: Piece;
   BEGIN
      IF (u IS Piece) & (v IS Piece) & (u.fnt.name = v.fnt.name) & (u.col = v.col) & (u.voff = v.voff) THEN
         p := u(Piece); q := v(Piece);
         IF (p.file = q.file) & (p.org + p.len = q.org) THEN
            IF T.cache = u THEN INC(T.corg, q.len)
            ELSIF T.cache = v THEN T.cache := T.head; T.corg := 0
            END;
            INC(p.len, q.len); v := v.next
         END
      END
   END Merge;

   PROCEDURE Splice (un, v, w: Run; base: Text);   (* (u, un) -> (u, v, w, un) *)
      VAR u: Run;
   BEGIN
      IF v # w.next THEN u := un.prev;
         u.next := v; v.prev := u; un.prev := w; w.next := un;
         REPEAT
            IF v IS Elem THEN v(Elem).base := base END;
            v := v.next
         UNTIL v = un
      END
   END Splice;

   PROCEDURE ClonePiece (p: Piece): Piece;
      VAR q: Piece;
   BEGIN NEW(q); q^ := p^; RETURN q
   END ClonePiece;

   PROCEDURE CloneElem (e: Elem): Elem;
      VAR msg: CopyMsg;
   BEGIN msg.e := NIL; e.handle(e, msg); RETURN msg.e
   END CloneElem;


   (** Elements **)

   PROCEDURE CopyElem* (SE, DE: Elem);
   BEGIN DE.len := SE.len; DE.fnt := SE.fnt; DE.col := SE.col; DE.voff := SE.voff;
      DE.W := SE.W; DE.H := SE.H; DE.handle := SE.handle
   END CopyElem;

   PROCEDURE ElemBase* (E: Elem): Text;
   BEGIN RETURN E.base
   END ElemBase;


 PROCEDURE HandleAlien (E: Elem; VAR msg: ElemMsg);
      VAR e: Alien; r: Files.Rider; i: LONGINT; w, h: INTEGER; ch: CHAR;
   BEGIN
      WITH E: Alien DO
         IF msg IS CopyMsg THEN
            WITH msg: CopyMsg DO NEW(e); CopyElem(E, e);
               e.file := E.file; e.org := E.org; e.span := E.span; e.mod := E.mod; e.proc := E.proc;
               msg.e := e
            END
         ELSIF msg IS IdentifyMsg THEN
            WITH msg: IdentifyMsg DO COPY(E.mod, msg.mod); COPY(E.proc, msg.proc) END
         ELSIF msg IS FileMsg THEN
            WITH msg: FileMsg DO
               IF msg.id = store THEN Files.Set(r, E.file, E.org); i := E.span;
                  WHILE i > 0 DO Files.Read(r, ch); Files.Write(msg.r, ch); DEC(i) END
               END
            END
         END
      END
   END HandleAlien;


   (** Buffers **)

   PROCEDURE OpenBuf* (B: Buffer);
      VAR u: Run;
   BEGIN NEW(u); u.next := u; u.prev := u; B.head := u; B.len := 0
   END OpenBuf;

   PROCEDURE Copy* (SB, DB: Buffer);
      VAR u, v, vn: Run;
   BEGIN u := SB.head.next; v := DB.head.prev;
      WHILE u # SB.head DO
         IF u IS Piece THEN vn := ClonePiece(u(Piece)) ELSE vn := CloneElem(u(Elem)) END;
         v.next := vn; vn.prev := v; v := vn; u := u.next
      END;
      v.next := DB.head; DB.head.prev := v;
      INC(DB.len, SB.len)
   END Copy;

   PROCEDURE Recall* (VAR B: Buffer);
   BEGIN B := del; del := NIL
   END Recall;


   (** Texts **)

   PROCEDURE Save* (T: Text; beg, end: LONGINT; B: Buffer);
      VAR u, v, w, wn: Run; uo, ud, vo, vd: LONGINT;
   BEGIN Find(T, beg, u, uo, ud); Find(T, end, v, vo, vd);
      w := B.head.prev;
      WHILE u # v DO
         IF u IS Piece THEN wn := ClonePiece(u(Piece)); DEC(wn.len, ud); INC(wn(Piece).org, ud)
         ELSE wn := CloneElem(u(Elem))
         END;
         w.next := wn; wn.prev := w; w := wn; u := u.next; ud := 0
      END;
      IF vd > 0 THEN (*v IS Piece*) wn := ClonePiece(v(Piece)); wn.len := vd - ud; INC(wn(Piece).org, ud);
         w.next := wn; wn.prev := w; w := wn
      END;
      w.next := B.head; B.head.prev := w;
      INC(B.len, end - beg)
   END Save;

   PROCEDURE Insert* (T: Text; pos: LONGINT; B: Buffer);
      VAR u, un, v: Run; p, q: Piece; uo, ud, len: LONGINT;
   BEGIN Find(T, pos, u, uo, ud); Split(ud, u, un);
      len := B.len; v := B.head.next;
      Merge(T, u, v); Splice(un, v, B.head.prev, T);
      INC(T.len, len); B.head.next := B.head; B.head.prev := B.head; B.len := 0;
      T.notify(T, insert, pos, pos + len)
   END Insert;

   PROCEDURE Append* (T: Text; B: Buffer);
      VAR v: Run; pos, len: LONGINT;
   BEGIN pos := T.len; len := B.len; v := B.head.next;
      Merge(T, T.head.prev, v); Splice(T.head, v, B.head.prev, T);
      INC(T.len, len); B.head.next := B.head; B.head.prev := B.head; B.len := 0;
      T.notify(T, insert, pos, pos + len)
   END Append;

   PROCEDURE Delete* (T: Text; beg, end: LONGINT);
      VAR c, u, un, v, vn: Run; co, uo, ud, vo, vd: LONGINT;
   BEGIN Find(T, beg, u, uo, ud); Split(ud, u, un); c := T.cache; co := T.corg;
      Find(T, end, v, vo, vd); Split(vd, v, vn); T.cache := c; T.corg := co;
      NEW(del); OpenBuf(del); del.len := end - beg;
      Splice(del.head, un, v, NIL);
      Merge(T, u, vn); u.next := vn; vn.prev := u;
      DEC(T.len, end - beg);
      T.notify(T, delete, beg, end)
   END Delete;

   PROCEDURE ChangeLooks* (T: Text; beg, end: LONGINT; sel: SET; fnt: Fonts.Font; col, voff: SHORTINT);
      VAR c, u, un, v, vn: Run; co, uo, ud, vo, vd: LONGINT;
   BEGIN Find(T, beg, u, uo, ud); Split(ud, u, un); c := T.cache; co := T.corg;
      Find(T, end, v, vo, vd); Split(vd, v, vn); T.cache := c; T.corg := co;
      WHILE un # vn DO
         IF 0 IN sel THEN un.fnt := fnt END;
         IF 1 IN sel THEN un.col := col END;
         IF 2 IN sel THEN un.voff := voff END;
         Merge(T, u, un);
         IF u.next = un THEN u := un; un := un.next ELSE u.next := un; un.prev := u END
      END;
      Merge(T, u, un); u.next := un; un.prev := u;
      T.notify(T, replace, beg, end)
   END ChangeLooks;


   (** Readers **)

   PROCEDURE OpenReader* (VAR R: Reader; T: Text; pos: LONGINT);
      VAR u: Run;
   BEGIN
      IF pos >= T.len THEN pos := T.len END;
      Find(T, pos, u, R.org, R.off); R.run := u; R.eot := FALSE;
      IF u IS Piece THEN
         WITH u: Piece DO Files.Set(R, u.file, u.org + R.off) END
      END
   END OpenReader;

   PROCEDURE Read* (VAR R: Reader; VAR ch: CHAR);
      VAR u: Run;
   BEGIN u := R.run; R.fnt := u.fnt; R.col := u.col; R.voff := u.voff; INC(R.off);
      IF u IS Piece THEN Files.Read(R, ch); R.elem := NIL
      ELSIF u IS Elem THEN ch := ElemChar; R.elem := u(Elem)
      ELSE ch := 0X; R.elem := NIL; R.eot := TRUE
      END;
      IF R.off = u.len THEN INC(R.org, u.len); u := u.next;
         IF u IS Piece THEN
            WITH u: Piece DO Files.Set(R, u.file, u.org) END
         END;
         R.run := u; R.off := 0
      END
   END Read;

   PROCEDURE ReadElem* (VAR R: Reader);
      VAR u, un: Run;
   BEGIN u := R.run;
      WHILE u IS Piece DO INC(R.org, u.len); u := u.next END;
      IF u IS Elem THEN un := u.next; R.run := un; INC(R.org); R.off := 0;
         R.fnt := u.fnt; R.col := u.col; R.voff := u.voff; R.elem := u(Elem);
         IF un IS Piece THEN
            WITH un: Piece DO Files.Set(R, un.file, un.org) END
         END
      ELSE R.eot := TRUE; R.elem := NIL
      END
   END ReadElem;

   PROCEDURE ReadPrevElem* (VAR R: Reader);
      VAR u: Run;
   BEGIN u := R.run.prev;
      WHILE u IS Piece DO DEC(R.org, u.len); u := u.prev END;
      IF u IS Elem THEN R.run := u; DEC(R.org); R.off := 0;
         R.fnt := u.fnt; R.col := u.col; R.voff := u.voff; R.elem := u(Elem)
      ELSE R.eot := TRUE; R.elem := NIL
      END
   END ReadPrevElem;

   PROCEDURE Pos* (VAR R: Reader): LONGINT;
   BEGIN RETURN R.org + R.off
   END Pos;


   (** Scanners --------------- NW --------------- **)

   PROCEDURE OpenScanner* (VAR S: Scanner; T: Text; pos: LONGINT);
   BEGIN OpenReader(S, T, pos); S.line := 0; S.nextCh := " "
   END OpenScanner;

   (*IEEE floating point formats:
      x = 2^(e-127) * 1.m    bit 0: sign, bits 1- 8: e, bits  9-31: m
      x = 2^(e-1023) * 1.m   bit 0: sign, bits 1-11: e, bits 12-63: m *)

   PROCEDURE Scan* (VAR S: Scanner);
      CONST maxD = 32;
      VAR ch, term: CHAR;
         neg, negE, hex: BOOLEAN;
         i, j, h: SHORTINT;
         e: INTEGER; k: LONGINT;
         x, f: REAL; y, g: LONGREAL;
         d: ARRAY maxD OF CHAR;

      PROCEDURE ReadScaleFactor;
      BEGIN Read(S, ch);
         IF ch = "-" THEN negE := TRUE; Read(S, ch)
         ELSE negE := FALSE;
            IF ch = "+" THEN Read(S, ch) END
         END;
         WHILE ("0" <= ch) & (ch <= "9") DO
            e := e*10 + ORD(ch) - 30H; Read(S, ch)
         END
      END ReadScaleFactor;

   BEGIN ch := S.nextCh; i := 0;
      LOOP
         IF ch = CR THEN INC(S.line)
         ELSIF (ch # " ") & (ch # TAB) THEN EXIT
         END ;
         Read(S, ch)
      END;
      IF ("A" <= CAP(ch)) & (CAP(ch) <= "Z") THEN (*name*)
         REPEAT S.s[i] := ch; INC(i); Read(S, ch)
         UNTIL (CAP(ch) > "Z")
            OR ("A" > CAP(ch)) & (ch > "9")
            OR ("0" > ch) & (ch # ".")
            OR (i = 31);
         S.s[i] := 0X; S.len := i; S.class := 1
      ELSIF ch = 22X THEN (*literal string*)
         Read(S, ch);
         WHILE (ch # 22X) & (ch >= " ") & (i # 31) DO
            S.s[i] := ch; INC(i); Read(S, ch)
         END;
         S.s[i] := 0X; S.len := i+1; Read(S, ch); S.class := 2
      ELSE
         IF ch = "-" THEN neg := TRUE; Read(S, ch) ELSE neg := FALSE END ;
         IF ("0" <= ch) & (ch <= "9") THEN (*number*)
            hex := FALSE; j := 0;
            LOOP d[i] := ch; INC(i); Read(S, ch);
               IF ch < "0" THEN EXIT END;
               IF "9" < ch THEN
                  IF ("A" <= ch) & (ch <= "F") THEN hex := TRUE; ch := CHR(ORD(ch)-7)
                  ELSIF ("a" <= ch) & (ch <= "f") THEN hex := TRUE; ch := CHR(ORD(ch)-27H)
                  ELSE EXIT
                  END
               END
            END;
            IF ch = "H" THEN (*hex number*)
               Read(S, ch); S.class := 3;
               IF i-j > 8 THEN j := i-8 END ;
               k := ORD(d[j]) - 30H; INC(j);
               IF (i-j = 7) & (k >= 8) THEN DEC(k, 16) END ;
               WHILE j < i DO k := k*10H + (ORD(d[j]) - 30H); INC(j) END ;
               IF neg THEN S.i := -k ELSE S.i := k END
            ELSIF ch = "." THEN (*read real*)
               Read(S, ch); h := i;
               WHILE ("0" <= ch) & (ch <= "9") DO d[i] := ch; INC(i); Read(S, ch) END ;
               IF ch = "D" THEN
                  e := 0; y := 0; g := 1;
                  REPEAT y := y*10 + (ORD(d[j]) - 30H); INC(j) UNTIL j = h;
                  WHILE j < i DO g := g/10; y := (ORD(d[j]) - 30H)*g + y; INC(j) END ;
                  ReadScaleFactor;
                  IF negE THEN
                     IF e <= 308 THEN y := y / Reals.TenL(e) ELSE y := 0 END
                  ELSIF e > 0 THEN
                     IF e <= 308 THEN y := Reals.TenL(e) * y ELSE HALT(40) END
                  END ;
                  IF neg THEN y := -y END ;
                  S.class := 5; S.y := y
               ELSE e := 0; x := 0; f := 1;
                  REPEAT x := x*10 + (ORD(d[j]) - 30H); INC(j) UNTIL j = h;
                  WHILE j < i DO f := f/10; x := (ORD(d[j])-30H)*f + x; INC(j) END;
                  IF ch = "E" THEN ReadScaleFactor END ;
                  IF negE THEN
                     IF e <= 38 THEN x := x / Reals.Ten(e) ELSE x := 0 END
                  ELSIF e > 0 THEN
                     IF e <= 38 THEN x := Reals.Ten(e) * x ELSE HALT(40) END
                  END ;
                  IF neg THEN x := -x END ;
                  S.class := 4; S.x := x
               END ;
               IF hex THEN S.class := 0 END
            ELSE (*decimal integer*)
               S.class := 3; k := 0;
               REPEAT k := k*10 + (ORD(d[j]) - 30H); INC(j) UNTIL j = i;
               IF neg THEN S.i := -k ELSE S.i := k END;
               IF hex THEN S.class := 0 ELSE S.class := 3 END
            END
         ELSE S.class := 6;
            IF neg THEN S.c := "-" ELSE S.c := ch; Read(S, ch) END
         END
      END;
      S.nextCh := ch
   END Scan;


   (** Writers **)

   PROCEDURE OpenWriter* (VAR W: Writer);
   BEGIN NEW(W.buf); OpenBuf(W.buf);
      W.fnt := Fonts.Default; W.col := Display.white; W.voff := 0;
      W.file := Files.New(""); Files.Set(W, W.file, 0)
   END OpenWriter;

   PROCEDURE SetFont* (VAR W: Writer; fnt: Fonts.Font);
   BEGIN W.fnt := fnt
   END SetFont;

   PROCEDURE SetColor* (VAR W: Writer; col: SHORTINT);
   BEGIN W.col := col
   END SetColor;

   PROCEDURE SetOffset* (VAR W: Writer; voff: SHORTINT);
   BEGIN W.voff := voff
   END SetOffset;


   PROCEDURE Write* (VAR W: Writer; ch: CHAR);
      VAR u, un: Run; p: Piece;
   BEGIN Files.Write(W, ch); INC(W.buf.len); un := W.buf.head; u := un.prev;
      IF (u IS Piece) & (u(Piece).file = W.file) & (u.fnt.name = W.fnt.name) & (u.col = W.col) & (u.voff = W.voff) THEN
         INC(u.len)
      ELSE NEW(p); u.next := p; p.prev := u; p.next := un; un.prev := p;
         p.len := 1; p.fnt := W.fnt; p.col := W.col; p.voff := W.voff;
         p.file := W.file; p.org := Files.Length(W.file) - 1
      END
   END Write;

   PROCEDURE WriteElem* (VAR W: Writer; e: Elem);
      VAR u, un: Run;
   BEGIN
      IF e.base # NIL THEN HALT(99) END;
      INC(W.buf.len); e.len := 1; e.fnt := W.fnt; e.col := W.col; e.voff := W.voff;
      un := W.buf.head; u := un.prev; u.next := e; e.prev := u; e.next := un; un.prev := e
   END WriteElem;

   PROCEDURE WriteLn* (VAR W: Writer);
   BEGIN Write(W, CR)
   END WriteLn;

   PROCEDURE WriteString* (VAR W: Writer; s: ARRAY OF CHAR);
      VAR i: INTEGER;
   BEGIN i := 0;
      WHILE s[i] >= " " DO Write(W, s[i]); INC(i) END
   END WriteString;

   PROCEDURE WriteInt* (VAR W: Writer; x, n: LONGINT);
      VAR i: INTEGER; x0: LONGINT;
         a: ARRAY 11 OF CHAR;
   BEGIN i := 0;
      IF x < 0 THEN
         IF x = MIN(LONGINT) THEN WriteString(W, " -2147483648"); RETURN
         ELSE DEC(n); x0 := -x
         END
      ELSE x0 := x
      END;
      REPEAT
         a[i] := CHR(x0 MOD 10 + 30H); x0 := x0 DIV 10; INC(i)
      UNTIL x0 = 0;
      WHILE n > i DO Write(W, " "); DEC(n) END;
      IF x < 0 THEN Write(W, "-") END;
      REPEAT DEC(i); Write(W, a[i]) UNTIL i = 0
   END WriteInt;

   PROCEDURE WriteHex* (VAR W: Writer; x: LONGINT);
      VAR i: INTEGER; y: LONGINT;
         a: ARRAY 10 OF CHAR;
   BEGIN i := 0; Write(W, " ");
      REPEAT y := x MOD 10H;
         IF y < 10 THEN a[i] := CHR(y + 30H) ELSE a[i] := CHR(y + 37H) END;
         x := x DIV 10H; INC(i)
      UNTIL i = 8;
      REPEAT DEC(i); Write(W, a[i]) UNTIL i = 0
   END WriteHex;

   PROCEDURE WriteReal* (VAR W: Writer; x: REAL; n: INTEGER);
      VAR e: INTEGER; x0: REAL;
         d: ARRAY maxD OF CHAR;
   BEGIN e := Reals.Expo(x);
      IF e = 0 THEN
         WriteString(W, "  0");
         REPEAT Write(W, " "); DEC(n) UNTIL n <= 3
      ELSIF e = 255 THEN
         WriteString(W, " NaN");
         WHILE n > 4 DO Write(W, " "); DEC(n) END
      ELSE
         IF n <= 9 THEN n := 3 ELSE DEC(n, 6) END;
         REPEAT Write(W, " "); DEC(n) UNTIL n <= 8;
         (*there are 2 < n <= 8 digits to be written*)
         IF x < 0.0 THEN Write(W, "-"); x := -x ELSE Write(W, " ") END;
         e := (e - 127) * 77  DIV 256;
         IF e >= 0 THEN x := x / Reals.Ten(e) ELSE x := Reals.Ten(-e) * x END;
         IF x >= 10.0 THEN x := 0.1*x; INC(e) END;
         x0 := Reals.Ten(n-1); x := x0*x + 0.5;
         IF x >= 10.0*x0 THEN x := x*0.1; INC(e) END;
         Reals.Convert(x, n, d);
         DEC(n); Write(W, d[n]); Write(W, ".");
         REPEAT DEC(n); Write(W, d[n]) UNTIL n = 0;
         Write(W, "E");
         IF e < 0 THEN Write(W, "-"); e := -e ELSE Write(W, "+") END;
         Write(W, CHR(e DIV 10 + 30H)); Write(W, CHR(e MOD 10 + 30H))
      END
   END WriteReal;

   PROCEDURE WriteRealFix* (VAR W: Writer; x: REAL; n, k: INTEGER);
      VAR e, i: INTEGER; sign: CHAR; x0: REAL;
         d: ARRAY maxD OF CHAR;

      PROCEDURE seq(ch: CHAR; n: INTEGER);
      BEGIN WHILE n > 0 DO Write(W, ch); DEC(n) END
      END seq;

      PROCEDURE dig(n: INTEGER);
      BEGIN
         WHILE n > 0 DO
            DEC(i); Write(W, d[i]); DEC(n)
         END
      END dig;

   BEGIN e := Reals.Expo(x);
      IF k < 0 THEN k := 0 END;
      IF e = 0 THEN seq(" ", n-k-2); Write(W, "0"); seq(" ", k+1)
      ELSIF e = 255 THEN WriteString(W, " NaN"); seq(" ", n-4)
      ELSE e := (e - 127) * 77 DIV 256;
         IF x < 0 THEN sign := "-"; x := -x ELSE sign := " " END;
         IF e >= 0 THEN  (*x >= 1.0,  77/256 = log 2*) x := x/Reals.Ten(e)
            ELSE (*x < 1.0*) x := Reals.Ten(-e) * x
         END;
         IF x >= 10.0 THEN x := 0.1*x; INC(e) END;
         (* 1 <= x < 10 *)
         IF k+e >= maxD-1 THEN k := maxD-1-e
            ELSIF k+e < 0 THEN k := -e; x := 0.0
         END;
         x0 := Reals.Ten(k+e); x := x0*x + 0.5;
         IF x >= 10.0*x0 THEN INC(e) END;
         (*e = no. of digits before decimal point*)
         INC(e); i := k+e; Reals.Convert(x, i, d);
         IF e > 0 THEN
            seq(" ", n-e-k-2); Write(W, sign); dig(e);
            Write(W, "."); dig(k)
         ELSE seq(" ", n-k-3);
            Write(W, sign); Write(W, "0"); Write(W, ".");
            seq("0", -e); dig(k+e)
         END
      END
   END WriteRealFix;

   PROCEDURE WriteRealHex* (VAR W: Writer; x: REAL);
      VAR i: INTEGER;
         d: ARRAY 8 OF CHAR;
   BEGIN Reals.ConvertH(x, d); i := 0;
      REPEAT Write(W, d[i]); INC(i) UNTIL i = 8
   END WriteRealHex;

   PROCEDURE WriteLongReal* (VAR W: Writer; x: LONGREAL; n: INTEGER);
      CONST maxD = 16;
      VAR e: INTEGER; x0: LONGREAL;
         d: ARRAY maxD OF CHAR;
   BEGIN e := Reals.ExpoL(x);
      IF e = 0 THEN
         WriteString(W, "  0");
         REPEAT Write(W, " "); DEC(n) UNTIL n <= 3
      ELSIF e = 2047 THEN
         WriteString(W, " NaN");
         WHILE n > 4 DO Write(W, " "); DEC(n) END
      ELSE
         IF n <= 10 THEN n := 3 ELSE DEC(n, 7) END;
         REPEAT Write(W, " "); DEC(n) UNTIL n <= maxD;
         (*there are 2 <= n <= maxD digits to be written*)
         IF x < 0 THEN Write(W, "-"); x := -x ELSE Write(W, " ") END;
         e := SHORT(LONG(e - 1023) * 77 DIV 256);
         IF e >= 0 THEN x := x / Reals.TenL(e) ELSE x := Reals.TenL(-e) * x END ;
         IF x >= 10.0D0 THEN x := 0.1D0 * x; INC(e) END ;
         x0 := Reals.TenL(n-1); x := x0*x + 0.5D0;
         IF x >= 10.0D0*x0 THEN x := 0.1D0 * x; INC(e) END ;
         Reals.ConvertL(x, n, d);
         DEC(n); Write(W, d[n]); Write(W, ".");
         REPEAT DEC(n); Write(W, d[n]) UNTIL n = 0;
         Write(W, "D");
         IF e < 0 THEN Write(W, "-"); e := -e ELSE Write(W, "+") END;
         Write(W, CHR(e DIV 100 + 30H)); e := e MOD 100;
         Write(W, CHR(e DIV 10 + 30H));
         Write(W, CHR(e MOD 10 + 30H))
      END
   END WriteLongReal;

   PROCEDURE WriteLongRealHex* (VAR W: Writer; x: LONGREAL);
      VAR i: INTEGER;
         d: ARRAY 16 OF CHAR;
   BEGIN Reals.ConvertHL(x, d); i := 0;
      REPEAT Write(W, d[i]); INC(i) UNTIL i = 16
   END WriteLongRealHex;

   PROCEDURE WriteDate* (VAR W: Writer; t, d: LONGINT);

      PROCEDURE WritePair(ch: CHAR; x: LONGINT);
      BEGIN Write(W, ch);
        Write(W, CHR(x DIV 10 + 30H)); Write(W, CHR(x MOD 10 + 30H))
      END WritePair;

   BEGIN
      WritePair(" ", d MOD 32); WritePair(".", d DIV 32 MOD 16); WritePair(".", d DIV 512 MOD 128);
      WritePair(" ", t DIV 4096 MOD 32); WritePair(":", t DIV 64 MOD 64); WritePair(":", t MOD 64)
   END WriteDate;


   (** Text Filing **)

   PROCEDURE Load* (T: Text; f: Files.File; pos: LONGINT; VAR len: LONGINT);
      VAR u, un: Run; p: Piece; e: Elem;
         org, hlen, plen: LONGINT; ecnt, fno, fcnt, col, voff: SHORTINT;
         msg: FileMsg;
         mods, procs: ARRAY 64, 32 OF CHAR;
         name: ARRAY 32 OF CHAR;
         fnts: ARRAY 32 OF Fonts.Font;

      PROCEDURE LoadElem (VAR r: Files.Rider; pos, span: LONGINT; VAR e: Elem);
         VAR M: Modules.Module; Cmd: Modules.Command; a: Alien;
            org, ew, eh: LONGINT; eno: SHORTINT;
      BEGIN new := NIL;
         RdLong(r, ew); RdLong(r, eh); Files.Read(r, eno);
         IF eno > ecnt THEN ecnt := eno; RdString(r, mods[eno]); RdString(r, procs[eno]) END;
         org := Files.Pos(r); M := Modules.ThisMod(mods[eno]);
         IF M # NIL THEN Cmd := Modules.ThisCommand(M, procs[eno]);
            IF Cmd # NIL THEN Cmd END
         END;
         e := new;
         IF new # NIL THEN new.W := ew; new.H := eh; new.base := T;
            msg.pos := pos; new.handle(new, msg);
            IF Files.Pos(r) # org + span THEN e := NIL END
         END;
         IF e = NIL THEN Files.Set(r, f, org + span);
            NEW(a); a.W := ew; a.H := eh; a.handle := HandleAlien; a.base := T;
            a.file := f; a.org := org; a.span := span;
            COPY(mods[eno], a.mod); COPY(procs[eno], a.proc);
            e := a
         END
      END LoadElem;

   BEGIN NEW(u); u.len := MAX(LONGINT); (*u.fnt := Fonts.Default;*)u.fnt := NIL; u.col := Display.white;
      T.head := u; ecnt := 0; fcnt := 0;
      msg.id := load; Files.Set(msg.r, f, pos); RdLong(msg.r, hlen); org := (pos - 2) + hlen; Files.Read(msg.r, fno);
      WHILE fno # 0 DO
         IF fno > fcnt THEN fcnt := fno; RdString(msg.r, name); fnts[fno] := Fonts.This(name) END;
         Files.Read(msg.r, col); Files.Read(msg.r, voff); RdLong(msg.r, plen);
         IF plen > 0 THEN NEW(p); p.file := f; p.org := org; un := p; un.len := plen
         ELSE LoadElem(msg.r, org - ((pos - 2) + hlen), -plen, e); un := e; un.len := 1
         END;
         un.fnt := fnts[fno]; un.col := col; un.voff := voff;
         INC(org, un.len); u.next := un; un.prev := u; u := un; Files.Read(msg.r, fno)
      END;
      u.next := T.head; T.head.prev := u; T.cache := T.head; T.corg := 0;
      len := org - pos; RdLong(msg.r, T.len)
   END Load;

   PROCEDURE Open* (T: Text; name: ARRAY OF CHAR);
      VAR f: Files.File; r: Files.Rider; u: Run; p: Piece; len: LONGINT; tag: INTEGER; x: CHAR;
   BEGIN f := Files.Old(name);
      IF f = NIL THEN f := Files.New("") END;
      Files.Set(r, f, 0); RdInt(r, tag);
      IF tag = Tag THEN Load(T, f, 2, len)
      ELSE NEW(u); u.len := MAX(LONGINT); (*u.fnt := Fonts.Default;*)u.fnt := NIL; u.col := Display.white;
         T.len := Files.Length(f);
         IF T.len > 0 THEN NEW(p); p.len := T.len; p.fnt := Fonts.Default;
            p.col := Display.white; p.voff := 0; p.file := f; p.org := 0;
            u.next := p; u.prev := p; p.next := u; p.prev := u
         ELSE u.next := u; u.prev := u
         END;
         T.head := u; T.cache := T.head; T.corg := 0
      END
   END Open;


   PROCEDURE Store* (T: Text; f: Files.File; pos: LONGINT; VAR len: LONGINT);
      VAR r1: Files.Rider; u, un: Run; e: Elem; org, delta, hlen, rlen: LONGINT; ecnt, fno, fcnt: SHORTINT;
         msg: FileMsg; iden: IdentifyMsg;
         mods, procs: ARRAY 64, 32 OF CHAR;
         fnts: ARRAY 32 OF Fonts.Font;
         block: ARRAY 1024 OF CHAR;

      PROCEDURE StoreElem (VAR r: Files.Rider; pos: LONGINT; e: Elem);
         VAR r1: Files.Rider; org, span: LONGINT; eno: SHORTINT;
      BEGIN COPY(iden.mod, mods[ecnt]); COPY(iden.proc, procs[ecnt]); eno := 1;
         WHILE (mods[eno] # iden.mod) OR (procs[eno] # iden.proc) DO INC(eno) END;
         Files.Set(r1, f, Files.Pos(r)); WrtLong(r, 0); (*fixup slot*)
         WrtLong(r, e.W); WrtLong(r, e.H); Files.Write(r, eno);
         IF eno = ecnt THEN INC(ecnt); WrtString(r, iden.mod); WrtString(r, iden.proc) END;
         msg.pos := pos; org := Files.Pos(r); e.handle(e, msg); span := Files.Pos(r) - org;
         WrtLong(r1, -span) (*fixup*)
      END StoreElem;

   BEGIN msg.id := store; Files.Set(msg.r, f, pos); WrtInt(msg.r, Tag); WrtLong(msg.r, 0); (*fixup slot*)
      u := T.head.next; org := 0; delta := 0; fcnt := 1; ecnt := 1;
      WHILE u # T.head DO
         IF u IS Elem THEN iden.mod[0] := 0X; u(Elem).handle(u(Elem), iden) ELSE iden.mod[0] := 1X END;
         IF iden.mod[0] # 0X THEN
            fnts[fcnt] := u.fnt; fno := 1;
            WHILE fnts[fno].name # u.fnt.name DO INC(fno) END;
            Files.Write(msg.r, fno);
            IF fno = fcnt THEN INC(fcnt); WrtString(msg.r, u.fnt.name) END;
            Files.Write(msg.r, u.col); Files.Write(msg.r, u.voff)
         END;
         IF u IS Piece THEN rlen := u.len; un := u.next;
            WHILE (un IS Piece) & (un.fnt = u.fnt) & (un.col = u.col) & (un.voff = u.voff) DO
               INC(rlen, un.len); un := un.next
            END;
            WrtLong(msg.r, rlen); INC(org, rlen); u := un
         ELSIF iden.mod[0] # 0X THEN StoreElem(msg.r, org, u(Elem)); INC(org); u := u.next
         ELSE INC(delta); u := u.next
         END
      END;
      Files.Write(msg.r, 0); WrtLong(msg.r, T.len - delta);
      hlen := Files.Pos(msg.r) - pos;
      u := T.head.next;
      WHILE u # T.head DO
         IF u IS Piece THEN
            WITH u: Piece DO Files.Set(r1, u.file, u.org); delta := u.len;
               WHILE delta > LEN(block) DO Files.ReadBytes(r1, block, LEN(block));
                  Files.WriteBytes(msg.r, block, LEN(block)); DEC(delta, LEN(block))
               END;
               Files.ReadBytes(r1, block, delta); Files.WriteBytes(msg.r, block, delta)
            END
         ELSE iden.mod[0] := 0X; u(Elem).handle(u(Elem), iden);
            IF iden.mod[0] # 0X THEN Files.Write(msg.r, ElemChar) END
         END;
         u := u.next
      END;
      len := Files.Pos(msg.r) - pos;
      Files.Set(r1, f, pos + 2); WrtLong(r1, hlen); (*fixup*)
      Files.Close(f)
   END Store;

BEGIN del := NIL
END Texts.
