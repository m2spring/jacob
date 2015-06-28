MODULE OCS;  (*NW 7.6.87 / 20.12.90*)

   IMPORT Files, Reals, Texts, Oberon;

   (*symbols:
       |  0          1          2           3            4
    ---|--------------------------------------------------------
     0 |  null       *          /           DIV          MOD
     5 |  &          +          -           OR           =
    10 |  #          <          <=          >            >=
    15 |  IN         IS         ^           .            ,
    20 |  :          ..         )           ]            }
    25 |  OF         THEN       DO          TO           (
    30 |  [          {          ~           :=           number
    35 |  NIL        string     ident       ;            |
    40 |  END        ELSE       ELSIF       UNTIL        IF
    45 |  CASE       WHILE      REPEAT      LOOP         WITH
    50 |  EXIT       RETURN     ARRAY       RECORD       POINTER
    55 |  BEGIN      CONST      TYPE        VAR          PROCEDURE
    60 |  IMPORT     MODULE     eof *)

   CONST KW = 43;  (*size of hash table*)
            maxDig = 32;
            maxInt = 7FFFH;
            maxShInt = 7FH;
            maxExp = 38; maxLExp = 308;
            maxStrLen = 128;

   (*name, numtyp, intval, realval, lrlval are implicit results of Get*)

   VAR numtyp* : INTEGER; (* 1 = char, 2 = integer, 3 = real, 4 = longreal*)
      intval* : LONGINT;
      realval*: REAL;
      lrlval* : LONGREAL;
      scanerr*: BOOLEAN;
      name*   : ARRAY maxStrLen OF CHAR;

      R: Texts.Reader;
      W: Texts.Writer;

      ch: CHAR;     (*current character*)
      lastpos: LONGINT; (*error position in source file*)

      i: INTEGER;
      keyTab  : ARRAY KW OF
                         RECORD symb, alt: INTEGER; id: ARRAY 12 OF CHAR END;

   PROCEDURE Mark*(n: INTEGER);
      VAR pos: LONGINT;
   BEGIN pos := Texts.Pos(R);
      IF lastpos + 8 < pos THEN
         Texts.WriteLn(W); Texts.WriteString(W, "  pos");
         Texts.WriteInt(W, pos, 6);
         IF n < 0 THEN Texts.WriteString(W, "  warning")
         ELSE Texts.WriteString(W, "  err"); scanerr := TRUE
         END ;
         Texts.WriteInt(W, ABS(n), 4); Texts.Append(Oberon.Log, W.buf); lastpos := pos
      END
   END Mark;

   PROCEDURE String(VAR sym: INTEGER);
      VAR i: INTEGER;
   BEGIN i := 0;
      LOOP Texts.Read(R, ch);
         IF ch = 22X THEN EXIT END ;
         IF ch < " " THEN Mark(3); EXIT END ;
         IF i < maxStrLen-1 THEN name[i] := ch; INC(i) ELSE Mark(212); i := 0 END
      END ;
      Texts.Read(R, ch);
      IF i = 1 THEN sym := 34; numtyp := 1; intval := ORD(name[0])
      ELSE sym := 36; name[i] := 0X (*string*)
      END
   END String;

   PROCEDURE Identifier(VAR sym: INTEGER);
      VAR i, k: INTEGER;
   BEGIN i := 0; k := 0;
      REPEAT
         IF i < 31 THEN name[i] := ch; INC(i); INC(k, ORD(ch)) END ;
         Texts.Read(R, ch)
      UNTIL (ch < "0") OR ("9" < ch) & (CAP(ch) < "A") OR ("Z" < CAP(ch));
      name[i] := 0X;
      k := (k+i) MOD KW;  (*hash function*)
      IF (keyTab[k].symb # 0) & (keyTab[k].id = name) THEN sym := keyTab[k].symb
      ELSE k := keyTab[k].alt;
         IF (keyTab[k].symb # 0) & (keyTab[k].id = name) THEN sym := keyTab[k].symb
         ELSE sym := 37 (*ident*)
         END
      END
   END Identifier;

   PROCEDURE Hval(ch: CHAR): INTEGER;
      VAR d: INTEGER;
   BEGIN d := ORD(ch) - 30H; (*d >= 0*)
      IF d >= 10 THEN
         IF (d >= 17) & (d < 23) THEN DEC(d, 7) ELSE d := 0; Mark(2) END
      END ;
      RETURN d
   END Hval;

   PROCEDURE Number;
      VAR i, j, h, d, e, n: INTEGER;
      x, f:   REAL;
      y, g: LONGREAL;
      lastCh: CHAR; neg: BOOLEAN;
      dig:    ARRAY maxDig OF CHAR;

      PROCEDURE ReadScaleFactor;
      BEGIN Texts.Read(R, ch);
         IF ch = "-" THEN neg := TRUE; Texts.Read(R, ch)
         ELSE neg := FALSE;
            IF ch = "+" THEN Texts.Read(R, ch) END
         END ;
         IF ("0" <= ch) & (ch <= "9") THEN
            REPEAT e := e*10 + ORD(ch)-30H; Texts.Read(R, ch)
            UNTIL (ch < "0") OR (ch >"9")
         ELSE Mark(2)
         END
      END ReadScaleFactor;

   BEGIN i := 0;
      REPEAT dig[i] := ch; INC(i); Texts.Read(R, ch)
      UNTIL (ch < "0") OR ("9" < ch) & (CAP(ch) < "A") OR ("Z" < CAP(ch));
      lastCh := ch; j := 0;
      WHILE (j < i-1) & (dig[j] = "0") DO INC(j) END ;
      IF ch = "." THEN Texts.Read(R, ch);
         IF ch = "." THEN lastCh := 0X; ch := 7FX END
      END ;
      IF lastCh = "." THEN (*decimal point*)
         h := i;
         WHILE ("0" <= ch) & (ch <= "9") DO (*read fraction*)
            IF i < maxDig THEN dig[i] := ch; INC(i) END ;
            Texts.Read(R, ch)
         END ;
         IF ch = "D" THEN
            y := 0; g := 1; e := 0;
            WHILE j < h DO y := y*10 + (ORD(dig[j])-30H); INC(j) END ;
            WHILE j < i DO g := g/10; y := (ORD(dig[j])-30H)*g + y; INC(j) END ;
            ReadScaleFactor;
            IF neg THEN
               IF e <= maxLExp THEN y := y / Reals.TenL(e) ELSE y := 0 END
            ELSIF e > 0 THEN
               IF e <= maxLExp THEN y := Reals.TenL(e) * y ELSE y := 0; Mark(203) END
            END ;
            numtyp := 4; lrlval := y
         ELSE x := 0; f := 1; e := 0;
            WHILE j < h DO x := x*10 + (ORD(dig[j])-30H); INC(j) END ;
            WHILE j < i DO f := f/10; x := (ORD(dig[j])-30H)*f + x; INC(j) END ;
            IF ch = "E" THEN ReadScaleFactor END ;
            IF neg THEN
               IF e <= maxExp THEN x := x / Reals.Ten(e) ELSE x := 0 END
            ELSIF e > 0 THEN
               IF e <= maxExp THEN x := Reals.Ten(e) * x ELSE x := 0; Mark(203) END
            END ;
            numtyp := 3; realval := x
         END
      ELSE (*integer*)
         lastCh := dig[i-1]; intval := 0;
         IF lastCh = "H" THEN
            IF j < i THEN
               DEC(i); intval := Hval(dig[j]); INC(j);
               IF i-j <= 7 THEN
                  IF (i-j = 7) & (intval >= 8) THEN DEC(intval, 16) END ;
                  WHILE j < i DO intval := Hval(dig[j]) + intval * 10H; INC(j) END
               ELSE Mark(203)
               END
            END
         ELSIF lastCh = "X" THEN
            DEC(i);
            WHILE j < i DO
               intval := Hval(dig[j]) + intval*10H; INC(j);
               IF intval > 0FFH THEN Mark(203); intval := 0 END
            END
         ELSE (*decimal*)
            WHILE j < i DO
               d := ORD(dig[j]) - 30H;
               IF d < 10 THEN
                  IF intval <= (MAX(LONGINT) - d) DIV 10 THEN intval := intval*10 + d
                  ELSE Mark(203); intval := 0
                  END
               ELSE Mark(2); intval := 0
               END ;
               INC(j)
            END
         END ;
         IF lastCh = "X" THEN numtyp := 1 ELSE numtyp := 2 END
      END
   END Number;

   PROCEDURE Get*(VAR sym: INTEGER);
      VAR s: INTEGER; xch: CHAR;

      PROCEDURE Comment;   (* do not read after end of file *)
      BEGIN Texts.Read(R, ch);
         LOOP
            LOOP
               WHILE ch = "(" DO Texts.Read(R, ch);
                  IF ch = "*" THEN Comment END
               END ;
               IF ch = "*" THEN Texts.Read(R, ch); EXIT END ;
               IF ch = 0X THEN EXIT END ;
               Texts.Read(R, ch)
            END ;
            IF ch = ")" THEN Texts.Read(R, ch); EXIT END ;
            IF ch = 0X THEN Mark(5); EXIT END
         END
      END Comment;

   BEGIN
      LOOP (*ignore control characters*)
         IF ch <= " " THEN
            IF ch = 0X THEN ch := " "; EXIT
            ELSE Texts.Read(R, ch)
            END
         ELSIF ch > 7FX THEN Texts.Read(R, ch)
         ELSE EXIT
         END
      END ;
      CASE ch OF   (* " " <= ch <= 7FX *)
            " "  : s := 62; ch := 0X (*eof*)
         | "!", "$", "%", "'", "?", "@", "\", "_", "`": s :=  0; Texts.Read(R, ch)
         | 22X  : String(s)
         | "#"  : s := 10; Texts.Read(R, ch)
         | "&"  : s :=  5; Texts.Read(R, ch)
         | "("  : Texts.Read(R, ch);
                      IF ch = "*" THEN Comment; Get(s)
                         ELSE s := 29
                      END
         | ")"  : s := 22; Texts.Read(R, ch)
         | "*"  : s :=  1; Texts.Read(R, ch)
         | "+"  : s :=  6; Texts.Read(R, ch)
         | ","  : s := 19; Texts.Read(R, ch)
         | "-"  : s :=  7; Texts.Read(R, ch)
         | "."  : Texts.Read(R, ch);
                      IF ch = "." THEN Texts.Read(R, ch); s := 21 ELSE s := 18 END
         | "/"  : s := 2;  Texts.Read(R, ch)
         | "0".."9": Number; s := 34
         | ":"  : Texts.Read(R, ch);
                      IF ch = "=" THEN Texts.Read(R, ch); s := 33 ELSE s := 20 END
         | ";"  : s := 38; Texts.Read(R, ch)
         | "<"  : Texts.Read(R, ch);
                      IF ch = "=" THEN Texts.Read(R, ch); s := 12 ELSE s := 11 END
         | "="  : s :=  9; Texts.Read(R, ch)
         | ">"  : Texts.Read(R, ch);
                      IF ch = "=" THEN Texts.Read(R, ch); s := 14 ELSE s := 13 END
         | "A".."Z": Identifier(s)
         | "["  : s := 30; Texts.Read(R, ch)
         | "]"  : s := 23; Texts.Read(R, ch)
         | "^"  : s := 17; Texts.Read(R, ch)
         | "a".."z": Identifier(s)
         | "{"  : s := 31; Texts.Read(R, ch)
         | "|"  : s := 39; Texts.Read(R, ch)
         | "}"  : s := 24; Texts.Read(R, ch)
         | "~"  : s := 32; Texts.Read(R, ch)
         | 7FX  : s := 21; Texts.Read(R, ch)
      END ;
      sym := s
   END Get;

   PROCEDURE Init*(source: Texts.Text; pos: LONGINT);
   BEGIN
      ch := " "; scanerr := FALSE; lastpos := -8;
      Texts.OpenReader(R, source, pos)
   END Init;

   PROCEDURE EnterKW(sym: INTEGER; name: ARRAY OF CHAR);
      VAR j, k: INTEGER;
   BEGIN j := 0; k := 0;
      REPEAT INC(k, ORD(name[j])); INC(j)
      UNTIL name[j] = 0X;
      k := (k+j) MOD KW;  (*hash function*)
      IF keyTab[k].symb # 0 THEN
         j := k;
         REPEAT INC(k) UNTIL keyTab[k].symb = 0;
         keyTab[j].alt := k
      END ;
      keyTab[k].symb := sym; COPY(name, keyTab[k].id)
   END EnterKW;

BEGIN i := KW;
   WHILE i > 0 DO
      DEC(i); keyTab[i].symb := 0; keyTab[i].alt := 0
   END ;
   keyTab[0].id := "";
   EnterKW(27, "DO");
   EnterKW(44, "IF");
   EnterKW(15, "IN");
   EnterKW(16, "IS");
   EnterKW(25, "OF");
   EnterKW( 8, "OR");
   EnterKW(40, "END");
   EnterKW( 4, "MOD");
   EnterKW(35, "NIL");
   EnterKW(58, "VAR");
   EnterKW(45, "CASE");
   EnterKW(41, "ELSE");
   EnterKW(50, "EXIT");
   EnterKW(26, "THEN");
   EnterKW(49, "WITH");
   EnterKW(52, "ARRAY");
   EnterKW(55, "BEGIN");
   EnterKW(56, "CONST");
   EnterKW(42, "ELSIF");
   EnterKW(43, "UNTIL");
   EnterKW(46, "WHILE");
   EnterKW(53, "RECORD");
   EnterKW(47, "REPEAT");
   EnterKW(51, "RETURN");
   EnterKW(59, "PROCEDURE");
   EnterKW(28, "TO");
   EnterKW( 3, "DIV");
   EnterKW(48, "LOOP");
   EnterKW(57, "TYPE");
   EnterKW(60, "IMPORT");
   EnterKW(61, "MODULE");
   EnterKW(54, "POINTER");
   Texts.OpenWriter(W)
END OCS.
