MODULE Files1; (* JTempl 31.1.91; TWH 931103 *)
IMPORT SYSTEM, Files, Kernel, Modules;

CONST (* register *)
	EAX = 0; ECX = 1; EDX = 2; EBX = 3; ESP = 4; EBP = 5; ESI = 6; EDI = 7;

TYPE
	Object* = POINTER TO ObjectDesc;
	ObjectDesc* = RECORD END;
	TDesc = POINTER TO RECORD (* no type tests allowed -- not a real pointer! *)
		name : ARRAY 32 OF CHAR; (* dependent upon OPL.Mod *)
		m : Kernel.Module;
		time : LONGINT;
	END;

VAR 
	module*, type* : ARRAY 24 OF CHAR;
	clock0, clock, noftypes : LONGINT; (* clock0 = clock - noftypes *)
	typTab : ARRAY 256 OF LONGINT;

PROCEDURE (obj : Object) Load*(VAR R : Files.Rider);
BEGIN HALT(20);
END Load;

PROCEDURE (obj : Object) Store*(VAR R : Files.Rider);
BEGIN HALT(20);
END Store;

PROCEDURE Reset*;
BEGIN noftypes := 0;
END Reset;

PROCEDURE New(typetag : LONGINT) : Object;
VAR o : Object;
BEGIN
	SYSTEM.PUTREG(EDX, typetag);
	SYSTEM.PUTREG(ECX, SYSTEM.ADR(o));
	Kernel.NewRecord;
	RETURN o;
END New;

PROCEDURE ThisType(m : Kernel.Module; VAR type : ARRAY OF CHAR) : LONGINT;
VAR RB, tagptr, tag : LONGINT; ch : CHAR; i : INTEGER;
BEGIN
	RB := m.RB; (* pointer reference block; 4 byte pointers -- depends on OPL.OutCode *)
	REPEAT
		SYSTEM.GET(RB, tagptr); INC(RB, 4);
		IF tagptr >= 0 THEN
			SYSTEM.GET(m.SB + tagptr, tag);
			i := 0;
			LOOP
				SYSTEM.GET(tag + 21CH + i, ch);
				IF ORD(type[i]) - ORD(ch) # 0 THEN EXIT;
				ELSIF ch = 0X THEN RETURN tag;
				ELSE INC(i);
				END;
			END;
		END;
	UNTIL tagptr < 0;
	RETURN 0;
END ThisType;

PROCEDURE Read*(VAR R: Files.Rider; VAR i : LONGINT);
VAR n : LONGINT; s : INTEGER; x : CHAR;
BEGIN
	s := 0; n := 0; Files.Read(R, x);
	WHILE ORD(x) >= 128 DO INC(n, ASH(ORD(x) - 128, s)); INC(s, 7); Files.Read(R, x); END;
	i := n + ASH(ORD(x) MOD 64 - ORD(x) DIV 64 * 64, s);
END Read;

PROCEDURE ReadSInt*(VAR R : Files.Rider; VAR i : SHORTINT);
BEGIN
END ReadSInt;

PROCEDURE ReadInt*(VAR R: Files.Rider; VAR i : INTEGER);
VAR x : CHAR; c, s : INTEGER;
BEGIN
	i := 0; s := 0; c := 0;
	WHILE c < 2 DO Files.Read(R, x); INC(i, SHORT(ASH(ORD(x), s))); INC(s, 8); INC(c); END;
END ReadInt;

PROCEDURE ReadLInt*(VAR R: Files.Rider; VAR i : LONGINT);
VAR x : CHAR; c, s : INTEGER;
BEGIN
	i := 0; s := 0; c := 0;
	WHILE c < 4 DO Files.Read(R, x); INC(i, ASH(ORD(x), s)); INC(s, 8); INC(c); END;
END ReadLInt;

PROCEDURE ReadReal*(VAR R: Files.Rider; VAR r : REAL);
VAR n : LONGINT;
BEGIN ReadLInt(R, n); SYSTEM.MOVE(SYSTEM.ADR(n), SYSTEM.ADR(r), SIZE(LONGINT));
END ReadReal;

PROCEDURE ReadLReal*(VAR R: Files.Rider; VAR r : LONGREAL);
VAR n : LONGINT;
BEGIN
	ReadLInt(R, n); SYSTEM.MOVE(SYSTEM.ADR(n), SYSTEM.ADR(r), SIZE(LONGINT));
	ReadLInt(R, n); SYSTEM.MOVE(SYSTEM.ADR(n), SYSTEM.ADR(r) + 4, SIZE(LONGINT));
END ReadLReal;

PROCEDURE ReadSet*(VAR R: Files.Rider; VAR i : SET);
VAR n : LONGINT;
BEGIN ReadLInt(R, n); i := SYSTEM.VAL(SET, n);
END ReadSet;

PROCEDURE ReadString*(VAR R: Files.Rider; VAR s: ARRAY OF CHAR);
 VAR i : INTEGER; ch : CHAR;
BEGIN i := 0; REPEAT Files.Read(R, ch); s[i] := ch; INC(i); UNTIL (ch = 0X) OR (i = LEN(s));
END ReadString;

PROCEDURE ReadObj*(VAR R: Files.Rider; VAR o: Object);
VAR ref, tag : LONGINT; m : Kernel.Module;
BEGIN
	Read(R, ref);
	IF ref = noftypes THEN
		ReadString(R, module); ReadString(R, type);
		m := Modules.ThisMod(module);
		IF m # NIL THEN
			tag := ThisType(m, type);
			IF tag # 0 THEN typTab[ref] := tag; INC(noftypes); o := New(typTab[ref]); o.Load(R);
			ELSE R.res := 1; o := NIL;
			END;
		ELSE o := NIL; R.res := 2;
		END;
	ELSIF ref # -1 THEN o := New(typTab[ref]); o.Load(R);
	ELSE o := NIL;
	END;
END ReadObj;

PROCEDURE Write*(VAR R: Files.Rider; i : LONGINT);
BEGIN
	WHILE (i < -64) OR (i > 63) DO Files.Write(R, CHR(i MOD 128 + 128)); i := i DIV 128; END;
	Files.Write(R, CHR(i MOD 128));
END Write;

PROCEDURE WriteInt*(VAR R: Files.Rider; i : INTEGER);
BEGIN Files.Write(R, SHORT(i MOD 100H)); Files.Write(R, SHORT(i DIV 100H));
END WriteInt;

PROCEDURE WriteLInt*(VAR R: Files.Rider; i : LONGINT);
BEGIN
	Files.Write(R, SHORT(SHORT(i MOD 100H))); Files.Write(R, SHORT(SHORT(i DIV 100H)));
	i := i DIV 10000H;
	Files.Write(R, SHORT(SHORT(i MOD 100H))); Files.Write(R, SHORT(SHORT(i DIV 100H)));
END WriteLInt;

PROCEDURE WriteReal*(VAR R: Files.Rider; r : REAL);
BEGIN WriteLInt(R, SYSTEM.VAL(LONGINT, r));
END WriteReal;

PROCEDURE WriteLReal*(VAR R: Files.Rider; r : LONGREAL);
VAR i : LONGINT;
BEGIN
	SYSTEM.MOVE(SYSTEM.ADR(r), SYSTEM.ADR(i), SIZE(LONGINT)); WriteLInt(R, i);
	SYSTEM.MOVE(SYSTEM.ADR(r) + 4, SYSTEM.ADR(i), SIZE(LONGINT)); WriteLInt(R, i);
END WriteLReal;

PROCEDURE WriteSet*(VAR R: Files.Rider; i : SET);
BEGIN WriteLInt(R, SYSTEM.VAL(LONGINT, i));
END WriteSet;

PROCEDURE WriteString*(VAR R: Files.Rider; VAR s: ARRAY OF CHAR);
VAR i : INTEGER; ch : CHAR;
BEGIN i := 0; REPEAT ch := s[i]; INC(i); Files.Write(R, ch); UNTIL ch = 0X;
END WriteString;

PROCEDURE WriteObj*(VAR R: Files.Rider; o: Object);
VAR tag : TDesc; t : LONGINT;
BEGIN
	IF o # NIL THEN
		SYSTEM.GET(SYSTEM.VAL(LONGINT, o) - 4, t);
		tag := SYSTEM.VAL(TDesc, t + 21CH (* offset to typename field *));
		IF tag.time < clock - noftypes THEN
			Write(R, noftypes);
			tag.time := clock; INC(noftypes); INC(clock); 
			WriteString(R, tag.m.name); WriteString(R, tag.name);
		ELSE Write(R, tag.time - (clock - noftypes)); 
		END;
		o.Store(R);
	ELSE Write(R, -1);
	END;
END WriteObj;

BEGIN clock := 1; noftypes := 0; module[0] := 0X; type[0] := 0X;
END Files1.
