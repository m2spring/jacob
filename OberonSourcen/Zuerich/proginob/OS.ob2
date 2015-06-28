MODULE OS;   (*HM Mar-25-92*)
IMPORT SYSTEM, Display, Files, Fonts, Input, Oberon, Types, Modules;

CONST
   left* = 2; middle* = 1; right* = 0; (*mouse button codes*)
   ticks* = 300;  (*time unit of OS.Time = 1/ticks*)

TYPE
   File* = Files.File;
   Font* = Fonts.Font;
   Object* = POINTER TO ObjectDesc;
   ObjectDesc* = RECORD END;
   Message* = RECORD END;
   Pattern* = Display.Pattern;
   Rider* = RECORD (Files.Rider)
      tab: ARRAY 16, 32 OF CHAR;
      end: INTEGER
   END;

VAR
   screenH-, screenW-: INTEGER;
   Caret-: Display.Pattern; (* x = 0, y = -10, w = 12, h = 12 *)

(*Object*)

PROCEDURE (x: Object) Load* (VAR r: Rider); END Load;

PROCEDURE (x: Object) Store* (VAR r: Rider); END Store;

(*Rider*)

PROCEDURE (VAR r: Rider) Set* (f: File; pos: LONGINT);
BEGIN Files.Set(r, f, pos)
END Set;

PROCEDURE (VAR r: Rider) Read* (VAR x: CHAR);
BEGIN Files.Read(r, x)
END Read;

PROCEDURE (VAR r: Rider) ReadChars* (VAR x: ARRAY OF CHAR; n: LONGINT);
BEGIN Files.ReadBytes(r, x, n)
END ReadChars;

PROCEDURE (VAR r: Rider) ReadLInt* (VAR x: LONGINT);
   VAR n: LONGINT; s: INTEGER; ch: CHAR;
BEGIN
   s := 0; n := 0; Files.Read(r, ch);
   WHILE ORD(ch) >= 128 DO
      INC(n, ASH(ORD(ch) - 128, s)); INC(s, 7); Files.Read(r, ch)
   END;
   x := n + ASH(ORD(ch) MOD 64 - ORD(ch) DIV 64 * 64, s)
END ReadLInt;

PROCEDURE (VAR r: Rider) ReadInt* (VAR x: INTEGER);
   VAR n: LONGINT;
BEGIN r.ReadLInt(n); x := SHORT(n)
END ReadInt;

PROCEDURE (VAR r: Rider) ReadString* (VAR name: ARRAY OF CHAR);
   VAR i: INTEGER; ch: CHAR;
BEGIN r.Read(ch);
   IF ORD(ch) = r.end THEN
      i := -1; REPEAT INC(i); r.Read(name[i]) UNTIL name[i] = 0X;
      COPY(name, r.tab[r.end]); INC(r.end)
   ELSE COPY(r.tab[ORD(ch)], name)
   END
END ReadString;

PROCEDURE (VAR r: Rider) ReadObj* (VAR x: Object);
   VAR name1, name2: ARRAY 32 OF CHAR; type: Types.Type;
BEGIN r.ReadString(name1);
   IF name1 = "" THEN x := NIL
   ELSE r.ReadString(name2); type := Types.This(Modules.ThisMod(name1), name2);
      Types.NewObj(x, type); x.Load(r)
   END
END ReadObj;

PROCEDURE (VAR r: Rider) Write* (x: CHAR);
BEGIN Files.Write(r, x)
END Write;

PROCEDURE (VAR r: Rider) WriteChars* (VAR x: ARRAY OF CHAR; n: LONGINT);
BEGIN Files.WriteBytes(r, x, n)
END WriteChars;

PROCEDURE (VAR r: Rider) WriteLInt* (x: LONGINT);
BEGIN
   WHILE (x < -64) OR (x > 63) DO
      Files.Write(r, CHR(x MOD 128 + 128)); x := x DIV 128
   END;
   Files.Write(r, CHR(x MOD 128))
END WriteLInt;

PROCEDURE (VAR r: Rider) WriteInt* (x: INTEGER);
BEGIN r.WriteLInt(x)
END WriteInt;

PROCEDURE (VAR r: Rider) WriteString* (name: ARRAY OF CHAR);
   VAR i: INTEGER;
BEGIN i := 0;
   LOOP
      IF i = r.end THEN r.Write(CHR(i));
         i := -1; REPEAT INC(i); r.Write(name[i]) UNTIL name[i] = 0X;
         COPY(name, r.tab[r.end]); INC(r.end); EXIT
      ELSIF r.tab[i] = name THEN r.Write(CHR(i)); EXIT
      ELSE INC(i)
      END
   END
END WriteString;

PROCEDURE (VAR r: Rider) WriteObj* (x: Object);
   VAR type: Types.Type;
BEGIN
   IF x = NIL THEN r.Write(0X)
   ELSE type := Types.TypeOf(x); r.WriteString(type.module.name); r.WriteString(type.name); x.Store(r)
   END
END WriteObj;

PROCEDURE InitRider* (VAR r: Rider);
BEGIN r.tab[0] := ""; r.end := 1
END InitRider;

(*other procedures*)

PROCEDURE FillBlock* (X, Y, W, H: INTEGER);
BEGIN Display.ReplConst (Display.white, X, Y, W, H, Display.replace)
END FillBlock;

PROCEDURE EraseBlock* (X, Y, W, H: INTEGER);
BEGIN Display.ReplConst (Display.black, X, Y, W, H, Display.replace)
END EraseBlock;

PROCEDURE InvertBlock* (X, Y, W, H: INTEGER);
BEGIN Display.ReplConst (Display.white, X, Y, W, H, Display.invert)
END InvertBlock;

PROCEDURE CopyBlock* (SX, SY, W, H, DX, DY: INTEGER);
BEGIN Display.CopyBlock (SX, SY, W, H, DX, DY, Display.replace)
END CopyBlock;

PROCEDURE DrawPattern* (pat: Pattern; x, y: INTEGER);
BEGIN Display.CopyPattern(Display.white, pat, x, y, Display.invert)
END DrawPattern;

PROCEDURE GetCharMetric* (f: Font; ch: CHAR; VAR dx, x, y, w, h: INTEGER; VAR pat: LONGINT);
BEGIN Display.GetChar(f.raster, ch, dx, x, y, w, h, pat)
END GetCharMetric;

PROCEDURE OldFile* (name: ARRAY OF CHAR): File;
BEGIN RETURN Files.Old(name)
END OldFile;

PROCEDURE NewFile* (name: ARRAY OF CHAR): File;
BEGIN RETURN Files.New(name)
END NewFile;

PROCEDURE Register* (f: File);
BEGIN Files.Register(f)
END Register;

PROCEDURE DefaultFont* (): Font;
BEGIN RETURN Fonts.Default
END DefaultFont;

PROCEDURE FontWithName* (name: ARRAY OF CHAR): Font;
BEGIN RETURN Fonts.This(name)
END FontWithName;

PROCEDURE GetMouse* (VAR buttons: SET; VAR x, y: INTEGER);
BEGIN Input.Mouse(buttons, x, y)
END GetMouse;

PROCEDURE AvailChars* (): INTEGER;
BEGIN RETURN Input.Available()
END AvailChars;

PROCEDURE ReadKey* (VAR ch: CHAR);
BEGIN Input.Read(ch)
END ReadKey;

PROCEDURE FadeCursor*;
BEGIN Oberon.FadeCursor(Oberon.Mouse)
END FadeCursor;

PROCEDURE DrawCursor* (x, y: INTEGER);
BEGIN Oberon.DrawCursor(Oberon.Mouse, Oberon.Arrow, x, y)
END DrawCursor;

PROCEDURE Call* (command: ARRAY OF CHAR);
   VAR res: INTEGER;
BEGIN Oberon.Call(command, Oberon.Par, FALSE, res)
END Call;

PROCEDURE Time* (): LONGINT;
BEGIN RETURN Oberon.Time()
END Time;

PROCEDURE NameToObj* (name: ARRAY OF CHAR; VAR obj: Object);
   VAR type: Types.Type; mod: Modules.Module; i, j: INTEGER; tname: ARRAY 32 OF CHAR;
BEGIN
   i := 0; WHILE (name[i] # 0X) & (name[i] # ".") DO INC(i) END;
   IF name[i] = "." THEN
      name[i] := 0X; INC(i); j := 0;
      WHILE name[i] # 0X DO tname[j] := name[i]; INC(i); INC(j) END;
      tname[j] := 0X;
      mod := Modules.ThisMod(name); type := NIL;
      IF mod # NIL THEN type := Types.This(mod, tname) END;
      IF type # NIL THEN Types.NewObj(obj, type) ELSE obj := NIL END
   ELSE obj := NIL
   END
END NameToObj;

PROCEDURE Move* (VAR fromBuf: ARRAY OF CHAR; from: LONGINT; VAR toBuf: ARRAY OF CHAR; to, n: LONGINT);
   VAR d: LONGINT;
BEGIN from := SYSTEM.ADR(fromBuf) + from; to := SYSTEM.ADR(toBuf) + to;
   IF from < to THEN d := to - from; from := from + n; to := to + n;
      WHILE n > 0 DO IF d > n THEN d := n END;
         from := from - d; to := to - d;
         SYSTEM.MOVE(from, to, d); n := n - d
      END
   ELSIF from > to THEN SYSTEM.MOVE(from, to, n)
   END
END Move;

BEGIN
   screenH := Display.Height; screenW := Display.Width * 5 DIV 8; Caret := Display.hook
END OS.
