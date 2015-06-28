MODULE Display;
IMPORT SYSTEM, DPMI(*XXX*), Kernel;

CONST black* = 0; white* = 15;
	replace* = 0; add = 1; paint* = 2; invert* = 3; (* VGA modes; see Data Rotate Register; FS field *)

CONST (* 80386 register information *)
	EAX = 0;	ECX = 1; 	EDX = 2;	EBX = 3; 
	ESP = 4;	EBP = 5; 	ESI = 6;	EDI = 7;


CONST
	MaxX = 1023; MaxY = 767; (* 0,0 is lower left corner of Display! *)
	VGARAM = 0A0000H; (* ADDRESS OF VGA RAM *)
	VGASEGMENT = 0A000H; (* ADDRESS OF VGA RAM *)

TYPE
	RamPointer = POINTER TO ARRAY 1 OF SYSTEM.BYTE; (* Video RAM pointer *)
	VideoMemory = LONGINT;
	Frame* = POINTER TO FrameDesc;
	FrameMsg* = RECORD END;
	Pattern* = LONGINT;
	Font* = POINTER TO Bytes;
	Bytes* = RECORD END;

	Handler* = PROCEDURE (f: Frame; VAR msg: FrameMsg);

	FrameDesc* = RECORD
		dsc*, next*: Frame;
		X*, Y*, W*, H*: INTEGER;
		handle*: Handler
	END;

VAR
	saveselector : INTEGER; (* saved selector used while accessing VGA memory *)
	selector : LONGINT; (* selector for accessing the VGA memory *)

VAR
	Unit*: LONGINT; (*RasterUnit = Unit/36000 mm*)
	Left*, ColLeft*, Bottom*, UBottom*, Width*, Height*: INTEGER;
	arrow*, star*, hook*, cross*, downArrow*: Pattern;
	grey0*, grey1*, grey2*, ticks*: Pattern;

PROCEDURE - VideoInterrupt 0CDH, 10H; (* INT 10H *)
PROCEDURE - InitMode 0B8H, 38H, 00H, 00H, 00H, 0CDH, 10H; (* MOV EAX, 38; INT 10H *)


PROCEDURE min(a, b : INTEGER) : INTEGER;
BEGIN IF a < b THEN RETURN a; ELSE RETURN b; END;
END min;

(* Changes a Ceres type Display byte into a VGA type Display byte.
   Bit 0 on Ceres is left most, bit 0 on VGA is rightmost 
*)
PROCEDURE InvertPatternByte*(VAR byte : SYSTEM.BYTE);
VAR s, ts : SET; i : LONGINT;
BEGIN
	ts := SYSTEM.VAL(SET, ORD(SYSTEM.VAL(CHAR, byte))) * {0..7};
	s := {}; i := 0;
	WHILE i < 8 DO 
		IF i IN ts THEN
			INCL(s, 8 - (i + 1));
		END;
		INC(i);
	END;
	byte := SYSTEM.VAL(SYSTEM.BYTE, s);
END InvertPatternByte;

PROCEDURE SetPattern*(VAR image: ARRAY OF SYSTEM.BYTE; W, H: INTEGER; VAR pat: Pattern);
VAR i, t1 : INTEGER; x : SYSTEM.BYTE; a : LONGINT; ptr : RamPointer;
BEGIN
	t1 := (W + 7) DIV 8 * H;
	SYSTEM.NEW(SYSTEM.VAL(SYSTEM.PTR, pat), 2 * SIZE(SHORTINT) + t1);
	SYSTEM.PUT(pat, SHORT(W)); SYSTEM.PUT(pat + SIZE(SHORTINT), SHORT(H));
	SYSTEM.MOVE(SYSTEM.ADR(image[0]), pat + 2 * SIZE(SHORTINT), t1);
	i := 0; ptr := SYSTEM.VAL(RamPointer, pat + 2 * SIZE(SHORTINT));
	WHILE i < t1 DO InvertPatternByte(ptr[0]); INC(SYSTEM.VAL(LONGINT, ptr)); INC(i); END;
END SetPattern;

PROCEDURE InitPatterns;
VAR pat : ARRAY 32 OF SYSTEM.BYTE;
BEGIN
	pat[00] := 000X;		pat[01] := 000X;	pat[02] := 000X;		pat[03] := 000X;
	pat[04] := 030X;		pat[05] := 000X;	pat[06] := 030X;		pat[07] := 000X;
	pat[08] := 030X;		pat[09] := 000X;	pat[10] := 0FFX;		pat[11] := 003X;
	pat[12] := 030X;		pat[13] := 000X;	pat[14] := 030X;		pat[15] := 000X;
	pat[16] := 030X;		pat[17] := 000X;	pat[18] := 000X;		pat[19] := 000X;
	pat[20] := 000X;		pat[21] := 000X;	pat[22] := 000X;		pat[23] := 000X;
	pat[24] := 000X;		pat[25] := 000X;	pat[26] := 000X;		pat[27] := 000X;
	pat[28] := 000X;		pat[29] := 000X;	pat[30] := 000X;		pat[31] := 000X;
	SetPattern(pat, 16, 16, cross);

	pat[00] := 000X;	pat[01] := 000X;	pat[02] := 001X;	pat[03] := 000X;
	pat[04] := 000X;	pat[05] := 000X;	pat[06] := 000X;	pat[07] := 000X;
	pat[08] := 000X;	pat[09] := 000X;	pat[10] := 000X;	pat[11] := 000X;
	pat[12] := 000X;	pat[13] := 000X;	pat[14] := 000X;	pat[15] := 000X;
	pat[16] := 000X;	pat[17] := 000X;	pat[18] := 000X;	pat[19] := 000X;
	pat[20] := 000X;	pat[21] := 000X;	pat[22] := 000X;	pat[23] := 000X;
	pat[24] := 000X;	pat[25] := 000X;	pat[26] := 000X;	pat[27] := 000X;
	pat[28] := 000X;	pat[29] := 000X;	pat[30] := 000X;	pat[31] := 000X;
	SetPattern(pat, 16, 16, ticks);

	pat[00] := 011X;	pat[01] := 011X;	pat[02] := 011X;	pat[03] := 011X;
	pat[04] := 000X;	pat[05] := 000X;	pat[06] := 000X;	pat[07] := 000X;
	SetPattern(pat, 16, 04, grey0);

	pat[00] := 011X;	pat[01] := 011X;	pat[02] := 011X;	pat[03] := 011X;
	pat[04] := 022X;	pat[05] := 022X;	pat[06] := 022X;	pat[07] := 022X;
	SetPattern(pat, 16, 04, grey1);

	pat[00] := 055X;	pat[01] := 055X;	pat[02] := 0AAX;	pat[03] := 0AAX;
	SetPattern(pat, 16, 02, grey2);

	pat[00] := 000X;	pat[01] := 000X;	pat[02] := 060X;	pat[03] := 000X;
	pat[04] := 0F0X;	pat[05] := 000X;	pat[06] := 0F0X;	pat[07] := 000X;
	pat[08] := 0F8X;	pat[09] := 001X;	pat[10] := 0F8X;	pat[11] := 001X;
	pat[12] := 0FCX;	pat[13] := 003X;	pat[14] := 0FCX;	pat[15] := 003X;
	pat[16] := 0FEX;	pat[17] := 007X;	pat[18] := 060X;	pat[19] := 000X;
	pat[20] := 060X;	pat[21] := 000X;	pat[22] := 060X;	pat[23] := 000X;
	pat[24] := 060X;	pat[25] := 000X;	pat[26] := 060X;	pat[27] := 000X;
	pat[28] := 060X;	pat[29] := 000X;	pat[30] := 000X;	pat[31] := 000X;
	SetPattern(pat, 12, 16, downArrow);

	pat[00] := 007X;	pat[01] := 00FX;	pat[02] := 087X;	pat[03] := 007X;	
	pat[04] := 0C7X;	pat[05] := 003X;	pat[06] := 0E7X;	pat[07] := 001X;	
	pat[08] := 0F7X;	pat[09] := 000X;	pat[10] := 07FX;	pat[11] := 000X;	
	pat[12] := 03FX;	pat[13] := 000X;	pat[14] := 01FX;	pat[15] := 000X;	
	pat[16] := 00FX;	pat[17] := 000X;	pat[18] := 007X;	pat[19] := 000X;	
	pat[20] := 003X;	pat[21] := 000X;	pat[22] := 001X;	pat[23] := 000X;	
	SetPattern(pat, 12, 12, hook);

	pat[00] := 080X;	pat[01] := 000X;	pat[02] := 080X;	pat[03] := 000X;
	pat[04] := 084X;	pat[05] := 010X;	pat[06] := 088X;	pat[07] := 008X;
	pat[08] := 090X;	pat[09] := 004X;	pat[10] := 0A0X;	pat[11] := 002X;
	pat[12] := 0C0X;	pat[13] := 001X;	pat[14] := 07FX;	pat[15] := 07FX;
	pat[16] := 0C0X;	pat[17] := 001X;	pat[18] := 0A0X;	pat[19] := 002X;
	pat[20] := 090X;	pat[21] := 004X;	pat[22] := 088X;	pat[23] := 008X;
	pat[24] := 084X;	pat[25] := 010X;	pat[26] := 080X;	pat[27] := 000X;
	pat[28] := 080X;	pat[29] := 000X;
	SetPattern(pat, 15, 15, star);

	(* page 7-24 of the MS-Mouse reference book *)
	pat[00] := 080X;	pat[01] := 001X;	pat[02] := 0C0X;	pat[03] := 000X;
	pat[04] := 0C0X;	pat[05] := 000X;	pat[06] := 060X;	pat[07] := 000X;
	pat[08] := 062X;	pat[09] := 000X;	pat[10] := 03EX;	pat[11] := 000X;
	pat[12] := 0FEX;	pat[13] := 003X;	pat[14] := 0FEX;	pat[15] := 001X;
	pat[16] := 0FEX;	pat[17] := 000X;	pat[18] := 07EX;	pat[19] := 000X;
	pat[20] := 03EX;	pat[21] := 000X;	pat[22] := 01EX;	pat[23] := 000X;
	pat[24] := 00EX;	pat[25] := 000X;	pat[26] := 006X;	pat[27] := 000X;
	pat[28] := 002X;	pat[29] := 000X;	pat[30] := 000X;	pat[31] := 000X;
	SetPattern(pat, 11, 16, arrow);

	(* I bar 
	pat[00] := 0E7X;	pat[01] := 018X;	pat[02] := 018X;	pat[03] := 018X;
	pat[04] := 018X;	pat[05] := 018X;	pat[06] := 018X;	pat[07] := 018X;
	pat[08] := 018X;	pat[09] := 018X;	pat[10] := 018X;	pat[11] := 018X;
	pat[12] := 018X;	pat[13] := 018X;	pat[14] := 018X;	pat[15] := 0E7X;
	SetPattern(pat, 8, 16, arrow);
	*)
END InitPatterns;

PROCEDURE Map*(X: INTEGER): LONGINT;
BEGIN RETURN selector;
END Map;

PROCEDURE SetMode*(X: INTEGER; s: SET);
BEGIN
	IF s = {} THEN (* on *)
	ELSIF 0 IN s THEN (* off *) HALT(20);
	ELSIF 2 IN s THEN (* inverse *) HALT(20);
	END;
END SetMode;

PROCEDURE SetColor*(col, red, green, blue: INTEGER); (*col < 0: overlay color*)
BEGIN HALT(20);
END SetColor;

PROCEDURE GetColor*(col: INTEGER; VAR red, green, blue: INTEGER);
BEGIN HALT(20);
END GetColor;

PROCEDURE SetCursor*(mode: SET);  (*color cursor; 0: crosshair, 1: arrow*)
BEGIN HALT(20);
END SetCursor;

PROCEDURE InitCC*;  (*default crosshair*)
BEGIN HALT(20);
END InitCC;

PROCEDURE InitCP*;  (*default arrow pattern*)
BEGIN HALT(20);
END InitCP;

PROCEDURE DefCC*(X, Y, W, H: INTEGER);  (*crosshair window*)
BEGIN HALT(20);
END DefCC;

PROCEDURE DefCP*(VAR raster: ARRAY OF SYSTEM.BYTE);  (*cursor pattern*)
BEGIN HALT(20);
END DefCP;

PROCEDURE DrawCX*(X, Y: INTEGER);
BEGIN HALT(20);
END DrawCX;

PROCEDURE FadeCX*(X, Y: INTEGER);
BEGIN HALT(20);
END FadeCX;

(*get raster data of character ch*)
PROCEDURE GetChar*(VAR f: Font; ch: CHAR; VAR dx, x, y, w, h: INTEGER; VAR p: Pattern);
VAR adr : LONGINT; ofs : INTEGER; sint : SHORTINT; t1 : INTEGER; t2 : SYSTEM.BYTE;
BEGIN
	adr := SYSTEM.VAL(LONGINT, f); (* address of Font record.  See PO, pg 141. *)
	SYSTEM.GET(adr + ORD(ch) * SIZE(INTEGER), ofs); (* offset in table of 'ch'th character *)
	INC(adr, LONG(ofs));
	(* INTEGER values are stored as one byte. *)
	SYSTEM.GET(adr - 3, sint); dx := sint;
	SYSTEM.GET(adr - 2, sint); x := sint;
	SYSTEM.GET(adr - 1, sint); y := sint;
	SYSTEM.GET(adr, sint); w := sint;
	SYSTEM.GET(adr + 1, sint); h := sint;
	p := adr;
END GetChar;

(* --------------------------- Display Support --------------------------- *)
PROCEDURE - GetES 66H, 8CH, 0C0H; (* MOV AX, ES *)
PROCEDURE - SetES 66H, 8EH, 0C0H; (* MOV ES, AX *)
PROCEDURE - SaveAndLoadDS 8CH, 0DBH, 8EH, 0D8H; (* mov bx, ds; mov ds, ax *)
PROCEDURE - RestoreSavedDS 8EH, 0DBH; (* mov ds, bx *)

PROCEDURE LoadSelector;
BEGIN GetES; SYSTEM.GETREG(EAX, saveselector); SYSTEM.PUTREG(EAX, selector); SetES;
END LoadSelector;

PROCEDURE RestoreSelector;
BEGIN SYSTEM.PUTREG(EAX, saveselector); SetES;
END RestoreSelector;

PROCEDURE LoadDS;
BEGIN SYSTEM.PUTREG(EAX, selector); SaveAndLoadDS;
END LoadDS;

PROCEDURE RestoreDS;
BEGIN RestoreSavedDS;
END RestoreDS;

PROCEDURE BothBanks(ysrc, ydest : LONGINT);
BEGIN SYSTEM.PORTOUT(3CDH, SHORT(SHORT(ysrc DIV 64) * 16 + SHORT(ydest DIV 64)));
END BothBanks;


(* --------------------- Display-proper procedures --------------------- *)
PROCEDURE - dotxor 26H, 30H, 18H; (* XOR es:[EAX], BL *) 
PROCEDURE - dotor  26H, 8H, 18H; (* OR es:[EAX], BL *)
PROCEDURE - dotmov 26H, 88H, 18H; (* MOV es:[EAX], BL *)
PROCEDURE Dot*(col: INTEGER; X, Y: LONGINT; mode: INTEGER);
VAR t1 : LONGINT;
BEGIN
	Y := MaxY - Y; BothBanks(Y, Y); t1 := (Y * Width) MOD 65536 + X;
	LoadSelector;
	CASE mode OF 
		replace: 
			SYSTEM.PUTREG(EBX, SHORT(col));
			SYSTEM.PUTREG(EAX, t1);
			dotmov;
	|	paint:
			SYSTEM.PUTREG(EBX, SHORT(col));
			SYSTEM.PUTREG(EAX, t1);
			dotor;
	| invert:
			SYSTEM.PUTREG(EBX, SHORT(col));
			SYSTEM.PUTREG(EAX, t1);
			dotxor;
	END;
	RestoreSelector;
END Dot;

PROCEDURE - CLD 0FCH;
PROCEDURE - STD 0FDH;
PROCEDURE - copyblockmov 0F2H, 0A4H; (* repne movsb *)
PROCEDURE - copyblockor 0ACH, 0AH, 7H, 0AAH, 0E2H, 0FAH; (* l1: lodsb; or al, [edi]; stosb; loop l1 *)
PROCEDURE - copyblockxor 0ACH, 32H, 7H, 0AAH, 0E2H, 0FAH; (* l1: lodsb; xor al, [edi]; stosb; loop l1 *)

PROCEDURE CopyBlock*(SX, SY, W, H, DX, DY, mode: INTEGER);
VAR sy, ey, sx, ex : INTEGER; rl : BOOLEAN;

	PROCEDURE CopyLine(RightLeft : BOOLEAN; sy, dy, sx, dx, w, mode : LONGINT);
	BEGIN
		BothBanks(sy, dy);
		IF RightLeft THEN	INC(sx, w); INC(dx, w);	END;
		CASE mode OF
			replace:
				SYSTEM.PUTREG(ESI, (sy * Width) MOD 65536 + sx);
				SYSTEM.PUTREG(EDI, (dy * Width) MOD 65536 + dx);
				SYSTEM.PUTREG(ECX, w);
				LoadDS; copyblockmov; RestoreDS;
		|	paint:
				SYSTEM.PUTREG(ESI, (sy * Width) MOD 65536 + sx);
				SYSTEM.PUTREG(EDI, (dy * Width) MOD 65536 + dx);
				SYSTEM.PUTREG(ECX, w);
				LoadDS; copyblockor; RestoreDS;
		|	invert:
				SYSTEM.PUTREG(ESI, (sy * Width) MOD 65536 + sx);
				SYSTEM.PUTREG(EDI, (dy * Width) MOD 65536 + dx);
				SYSTEM.PUTREG(ECX, w);
				LoadDS; copyblockxor; RestoreDS;
		ELSE
		END;
	END CopyLine;

BEGIN
	LoadSelector;
	SY := MaxY - SY; DY := MaxY - DY; (* Oberon->VGA coordinate system *)

	IF DX > SX THEN	rl := TRUE; STD; (* Right to left *) ELSE	rl := FALSE; CLD; (* Left to right *)	END;

	ey := SY - H;
	IF DY <= SY THEN
		(* top to bottom *)
		DY := DY - H;
		WHILE ey <= SY DO CopyLine(rl, ey, DY, SX, DX, W, mode); INC(ey); INC(DY); END;
	ELSE
		(* bottom to top *)
		WHILE SY >= ey DO CopyLine(rl, SY, DY, SX, DX, W, mode); DEC(SY); DEC(DY); END;
	END;
	CLD;
	RestoreSelector;
END CopyBlock;

PROCEDURE - bitbltxor 26H, 30H, 18H; (* XOR es:[EAX], BL *) 
PROCEDURE - bitbltor  26H, 8H, 18H; (* OR es:[EAX], BL *)
PROCEDURE - bitbltmov 26H, 88H, 18H; (* MOV es:[EAX], BL *)

(* Copy WxH block of bits from BitAdr to (X,Y).  OFS is used as a starting
   bit offset from the first byte of BitAdr.  Y is in VGA coords.  Block
	 is filled from the bottom up. (invariant: ye <= Y)
	 PW designates the width of the bitblk (in bits) which is to be copied
*)
PROCEDURE BitBlt(col : INTEGER; BitBlkAdr : LONGINT; OFS : INTEGER; X, Y, W, H, PW, mode : INTEGER);
VAR tcol : SHORTINT; ye, xe, xt, bit, ofsbyte : INTEGER; bitblk, yt, t1 : LONGINT;
BEGIN
	LoadSelector; PW :=	(PW + (-PW) MOD 8) DIV 8; ofsbyte := OFS DIV 8; OFS := OFS MOD 8;
	xe := X + W; ye := Y - H; yt := LONG(Y) * Width;
	WHILE Y > ye DO
		bitblk := BitBlkAdr + ofsbyte; xt := X; BothBanks(Y, Y); yt := yt MOD 65536;
		WHILE xt < xe DO
			bit := 7 - OFS;
			WHILE (bit >= 0) & (xt < xe) DO
				IF SYSTEM.BIT(bitblk, bit) THEN tcol := SHORT(col) ELSE tcol := black; END;
				t1 := xt + yt;
				CASE mode OF
					replace: SYSTEM.PUTREG(EBX, tcol);SYSTEM.PUTREG(EAX, t1);bitbltmov;
				|	paint: SYSTEM.PUTREG(EBX, tcol);SYSTEM.PUTREG(EAX, t1);bitbltor;
				| invert: SYSTEM.PUTREG(EBX, tcol);SYSTEM.PUTREG(EAX, t1);bitbltxor;
				END;
				INC(xt); DEC(bit);
			END;
			INC(bitblk); (* next byte in pattern *)
		END;
		DEC(Y); DEC(yt, LONG(Width)); INC(BitBlkAdr, LONG(PW));
	END;
	RestoreSelector;
END BitBlt;

(* Pours a Pattern to the Display at X, Y. *)
PROCEDURE PutPattern(col : INTEGER; pat : Pattern; X, Y, W, H, mode : INTEGER);
VAR w, h : SHORTINT;
BEGIN SYSTEM.GET(pat, w); SYSTEM.GET(pat + 1, h);
	BitBlt(col, pat + 2 * SIZE(SHORTINT), 0, X, Y, min(W, w), min(H, h), w, mode);
END PutPattern;

PROCEDURE CopyPattern*(col: INTEGER; pat: Pattern; X, Y, mode: INTEGER);
VAR w, h : SHORTINT;
BEGIN	
	Y := MaxY - Y; (* Oberon->VGA coordinate system *)
	PutPattern(col, pat, X, Y, MAX(INTEGER), MAX(INTEGER), mode);
END CopyPattern;

PROCEDURE ReplPattern*(col: INTEGER; pat: Pattern; X, Y, W, H, mode: INTEGER);
VAR ye, x, xe, wt : INTEGER; w, h : SHORTINT;
BEGIN
	Y := MaxY - Y; (* Oberon->VGA coordinate system *)
	SYSTEM.GET(pat, w); SYSTEM.GET(pat + SIZE(SHORTINT), h);
	ye := Y - H; (* ending scan line *)
	xe := X + W; (* end width column *)
	REPEAT
		x := X; wt := W; 
		REPEAT PutPattern(col, pat, x, Y, wt, H, mode); INC(x, LONG(w)); DEC(wt, LONG(w));
		UNTIL x >= xe;
		DEC(Y, LONG(h)); DEC(H, LONG(h));
	UNTIL Y <= ye;
END ReplPattern;


PROCEDURE ReplPatternC*(f : Frame; col : INTEGER; pat : Pattern; X, Y, W, H, mode, X0, Y0 : INTEGER);
VAR w, h : SHORTINT; tw, th, ofs : INTEGER;
BEGIN
	SYSTEM.GET(pat, w); SYSTEM.GET(pat + SIZE(SHORTINT), h); INC(pat, 2 * SIZE(SHORTINT));
	ofs := X - X0; (* invariant: X >= X0 *)
	tw := min(w, f.X + f.W - X); th := min(w, f.Y + f.W - Y);
	Y := MaxY - Y; BitBlt(col, pat, ofs, X, Y, tw, th, w, mode);
	CopyPattern(white, downArrow, 0, 0, invert);
END ReplPatternC;

PROCEDURE - vlinexor 26H, 30H, 18H; (* XOR es:[EAX], BL *)
PROCEDURE - vlineor 26H, 8H, 18H; (* XOR es:[EAX], BL *)
PROCEDURE - vlinemov 26H, 88H, 18H; (* XOR es:[EAX], BL *)
PROCEDURE VLine(col, ys, ye, x, mode : INTEGER); 
VAR t1, t2, t3 : LONGINT;
BEGIN
	t1 := x; t2 := LONG(ys) * Width;
	WHILE ys <= ye DO
		BothBanks(ys, ys); t3 := t1 + t2 MOD 65536;
		CASE mode OF
			replace:
				SYSTEM.PUTREG(EBX, SHORT(col));
				SYSTEM.PUTREG(EAX, t3);
				vlinemov;
		|	paint:
				SYSTEM.PUTREG(EBX, SHORT(col));
				SYSTEM.PUTREG(EAX, t3);
				vlineor;
		| invert:
				SYSTEM.PUTREG(EBX, SHORT(col));
				SYSTEM.PUTREG(EAX, t3);
				vlinexor;
		ELSE
		END;
		INC(t2, LONG(Width)); INC(ys);
	END;
END VLine;

PROCEDURE - hlinexor 26H, 30H, 18H, 40H, 0E2H, 0FAH; (* l1: XOR [EAX], BL; INC EAX; LOOP l1 *)
PROCEDURE - hlineor 26H, 8H, 18H, 40H, 0E2H, 0FAH; (* l1: XOR [EAX], BL; INC EAX; LOOP l1 *)
PROCEDURE - hlinemov 26H, 88H, 18H, 40H, 0E2H, 0FAH; (* l1: XOR [EAX], BL; INC EAX; LOOP l1 *)
PROCEDURE ReplConst*(col: INTEGER; X, Y, W, H, mode: INTEGER);
VAR y1 : INTEGER; t1, t2, t3 : LONGINT;
BEGIN
	LoadSelector;
	Y := MaxY - Y; y1 := Y - H + 1;(* Oberon->VGA coordinate system *)
	IF W = 1 THEN VLine(col, y1, Y, X, mode);
	ELSIF W > 1 THEN
		t2 := LONG(y1) * Width; t3 := LONG(X);
		WHILE y1 <= Y DO
			BothBanks(y1, y1);
			t1 := t3 + t2 MOD 65536;
			CASE mode OF
				replace: 
					SYSTEM.PUTREG(ECX, LONG(W));
					SYSTEM.PUTREG(EBX, SHORT(col));
					SYSTEM.PUTREG(EAX, t1);
					hlinemov;
			|	paint:
					SYSTEM.PUTREG(ECX, LONG(W));
					SYSTEM.PUTREG(EBX, SHORT(col));
					SYSTEM.PUTREG(EAX, t1);
					hlineor;
			| invert:
					SYSTEM.PUTREG(ECX, LONG(W));
					SYSTEM.PUTREG(EBX, SHORT(col));
					SYSTEM.PUTREG(EAX, t1);
					hlinexor;
			ELSE
			END;
			INC(y1); INC(t2, LONG(Width));
		END;
	END;
	RestoreSelector;
END ReplConst;

PROCEDURE FreeDisplay;
BEGIN Kernel.DebugWriteString('Closing display'); Kernel.DebugNL;
END FreeDisplay;

PROCEDURE GetDescriptor;
CONST access = {1, 4, 7, 14}; (* readable, must be set, present, 32bit, byte gran *)
VAR error : INTEGER; t : Kernel.Terminator;
BEGIN
	DPMI.GetLocalDescriptor(selector, error);
	IF error = 0 THEN
		DPMI.SetAccessRights(selector, access, error);
		IF error = 0 THEN
			DPMI.SetSegmentBase(selector, VGARAM, error);
			IF error = 0 THEN
				DPMI.SetSegmentLimit(selector, 0FFFFH, error);
				IF error # 0 THEN Kernel.DebugWriteString('Cannot set VGA limit: '); Kernel.DebugWriteHex(error); END;
			ELSE Kernel.DebugWriteString('Cannot set VGA base: '); Kernel.DebugWriteHex(error);
			END;
		ELSE Kernel.DebugWriteString('Cannot set VGA access: '); Kernel.DebugWriteHex(error);
		END;
	ELSE Kernel.DebugWriteString('Cannot get VGA selector: '); Kernel.DebugWriteHex(error);
	END;
	IF error # 0 THEN Kernel.DebugNL; Kernel.Terminate; END;
	NEW(t); (* assume memory avail *) t.proc := FreeDisplay; Kernel.RegisterTermination(t);
END GetDescriptor;

BEGIN
	Kernel.DebugWriteString('Initializing Display'); 
	GetDescriptor;
	Kernel.DebugWriteString(' descriptor allocated'); Kernel.DebugNL;
	InitMode; InitPatterns;
	Width := MaxX + 1; Height := MaxY + 1; Unit := 10000; Left := 0; ColLeft := 0; Bottom := 0; UBottom := 0;
END Display.
