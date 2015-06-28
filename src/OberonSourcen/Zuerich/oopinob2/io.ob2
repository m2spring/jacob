MODULE io;   (* HM 17-Dec-91 *)
IMPORT Texts0, TextFrames0;

CONST
   none* = 0; integer* = 1; name* = 2; string* = 3; char* = 4;

TYPE
   Scanner* = RECORD
      text-: Texts0.Text;
      class-: INTEGER;
      int-: LONGINT;
      str-: ARRAY 32 OF CHAR;
      ch-: CHAR;
      c: CHAR
   END;

VAR
   out*: Texts0.Text;

PROCEDURE (VAR s: Scanner) Set* (t: Texts0.Text; pos: LONGINT);
BEGIN s.text := t; t.SetPos(pos); s.class := none; s.c := " "
END Set;

PROCEDURE (VAR s: Scanner) SetToParameters*;
BEGIN s.Set(TextFrames0.cmdFrame.text, TextFrames0.cmdPos)
END SetToParameters;

PROCEDURE (VAR s: Scanner) Pos* (): LONGINT;
BEGIN RETURN s.text.pos
END Pos;

PROCEDURE (VAR s: Scanner) Eot* (): BOOLEAN;
BEGIN RETURN s.text.pos >= s.text.len
END Eot;

PROCEDURE (VAR s: Scanner) Read*;
   VAR i: INTEGER; old: CHAR;
BEGIN
   WHILE (s.text.pos < s.text.len) & (s.c <= " ") DO s.text.Read(s.c) END;
   IF s.text.pos >= s.text.len THEN s.class := none
   ELSIF (CAP(s.c) >= "A") & (CAP(s.c) <= "Z") THEN i := 0;
      REPEAT s.str[i] := s.c; INC(i); s.text.Read(s.c)
      UNTIL ~((CAP(s.c) >= "A") & (CAP(s.c) <= "Z") OR (s.c >= "0") & (s.c <= "9") OR (s.c = "."));
      s.str[i] := 0X; s.class := name
   ELSIF (s.c >= "0") & (s.c <= "9") THEN s.int := 0; s.class := integer;
      REPEAT s.int := 10 * s.int + ORD(s.c) - ORD("0"); s.text.Read(s.c) UNTIL (s.c < "0") OR (s.c > "9")
   ELSIF (s.c = "'") OR (s.c = '"') THEN old := s.c; s.text.Read(s.c); i := 0;
      WHILE s.c # old DO s.str[i] := s.c; INC(i); s.text.Read(s.c) END;
      s.str[i] := 0X; s.text.Read(s.c); s.class := string
   ELSE s.ch := s.c; s.text.Read(s.c); s.class := char;
      IF ((s.ch = "-") OR (s.ch = "+")) & (s.c >= "0") & (s.c <= "9") THEN s.int := 0; s.class := integer;
         REPEAT s.int := 10 * s.int + ORD(s.c) - ORD("0"); s.text.Read(s.c) UNTIL (s.c < "0") OR (s.c > "9");
         IF s.ch = "-" THEN s.int := -s.int END
      END
   END
END Read;


PROCEDURE Ch* (ch: CHAR);
BEGIN out.Write(ch)
END Ch;

PROCEDURE Str* (s: ARRAY OF CHAR);
   VAR i: INTEGER;
BEGIN i := 0; WHILE s[i] # 0X DO out.Write(s[i]); INC(i) END
END Str;

PROCEDURE Int* (x: LONGINT; w: INTEGER);
   VAR a: ARRAY 10 OF CHAR; i: INTEGER;
BEGIN
   IF x < 0 THEN out.Write("-"); DEC(w); x := -x END;
   i := 0; REPEAT a[i] := CHR(ORD("0") + x MOD 10); INC(i); x := x DIV 10 UNTIL x = 0;
   WHILE w > i DO out.Write(" "); DEC(w) END;
   REPEAT DEC(i); out.Write(a[i]) UNTIL i = 0
END Int;

PROCEDURE Real* (x: REAL; w: INTEGER);
   VAR exp, i: INTEGER; d: REAL; a: ARRAY 16 OF CHAR; y: LONGINT;
BEGIN exp := 0;
   IF x < 0 THEN Ch("-"); DEC(w); x := -x END;
   d := 1; WHILE x >= 10*d DO d := d * 10; INC(exp) END; x := x / d;
   d := 1; WHILE x < d DO d := d / 10; DEC(exp) END; x := x * d;
   Int(ENTIER(x), 0); Ch("."); DEC(w, 6); (*x.E+yy*)
   x := (x - ENTIER(x)); i := w; WHILE i > 0 DO x := x * 10; DEC(i) END;
   y := ENTIER(x);
   i := 0; REPEAT a[i] := CHR(ORD("0") + y MOD 10); INC(i); y := y DIV 10 UNTIL y = 0;
   WHILE w > i DO out.Write("0"); DEC(w) END;
   REPEAT DEC(i); out.Write(a[i]) UNTIL i = 0;
   Ch("E");
   IF exp < 0 THEN Ch("-"); Int(-exp, 2) ELSE Ch("+"); Int(exp, 2) END
END Real;

PROCEDURE NL*;
BEGIN out.Write(0DX)
END NL;

END io.
