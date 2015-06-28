MODULE Display;
IMPORT SYSTEM, DPMI, Kernel;

CONST
	TextPlane = 14;
	BackgroundPlane = 1;
	AllPlane = 15;

CONST
	MaxX = 639; MaxY = 479; (* 0,0 is lower left corner of display! *)
	VGARAM = 0A0000H; (* ADDRESS OF VGA RAM *)
	VGASEGMENT = 0A000H; (* ADDRESS OF VGA RAM *)

CONST
	EAX = 0; ECX = 1; EDX = 2; EBX = 3; 
	ESP = 4; EBP = 5; ESI = 6; EDI = 7;

CONST black* = 0; white* = 15;
	replace* = 0; add = 1; paint* = 2; invert* = 3; (* VGA modes; see Data Rotate Register; FS field; Ferraro, page 395 *)

TYPE
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

(* 640x480 16 colors *)
PROCEDURE - InitMode 0B8H, 12H, 00H, 00H, 00H, 0CDH, 10H; (* MOV EAX, 12; INT 10H *)
PROCEDURE - VideoInterrupt 0CDH, 10H; (* INT 10H *)

PROCEDURE min(a, b : INTEGER) : INTEGER;
BEGIN IF a < b THEN RETURN a; ELSE RETURN b; END;
END min;

PROCEDURE max(a, b : INTEGER) : INTEGER;
BEGIN IF a < b THEN RETURN b; ELSE RETURN a; END;
END max;

(* Changes a Ceres type display byte into a VGA type display byte.
   Bit 0 on Ceres is left most, bit 0 on VGA is rightmost 
*)
PROCEDURE InvertPatternByte*(VAR byte : SYSTEM.BYTE);
VAR s, ts : SET; i : LONGINT;
BEGIN
	ts := SYSTEM.VAL(SET, ORD(SYSTEM.VAL(CHAR, byte))) * {0..7}; s := {}; i := 0;
	WHILE i < 8 DO 
		IF i IN ts THEN
			INCL(s, 8 - (i + 1));
		END;
		INC(i);
	END;
	byte := SYSTEM.VAL(SYSTEM.BYTE, s);
END InvertPatternByte;

PROCEDURE SetPattern*(VAR image: ARRAY OF SYSTEM.BYTE; W, H: INTEGER; VAR pat: Pattern);
VAR i, t1 : INTEGER; x : SYSTEM.BYTE; a : LONGINT; p : LONGINT;
BEGIN
	t1 := (W + 7) DIV 8 * H;
	SYSTEM.NEW(SYSTEM.VAL(SYSTEM.PTR, pat), 2 * SIZE(SHORTINT) + t1);
	SYSTEM.PUT(pat, SHORT(W)); SYSTEM.PUT(pat + SIZE(SHORTINT), SHORT(H));
	SYSTEM.MOVE(SYSTEM.ADR(image[0]), pat + 2 * SIZE(SHORTINT), t1);
	i := 0; p := pat + 2 * SIZE(SHORTINT);
	WHILE i < t1 DO SYSTEM.GET(p, x); InvertPatternByte(x); SYSTEM.PUT(p, x); INC(p); INC(i); END;
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
BEGIN RETURN 0;
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

(* -------------------------- Selector Support -------------------------- *)
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

(* --------------------------- Display Support --------------------------- *)
PROCEDURE LoadReadMode(mode : SHORTINT);
VAR v : SHORTINT;
BEGIN
	SYSTEM.PORTOUT(3CEH, 5); SYSTEM.PORTIN(3CFH, v);
	v := SYSTEM.VAL(SHORTINT, SYSTEM.VAL(SET, v) - {3});
	INC(v, mode * 8);
	SYSTEM.PORTOUT(3CEH, 4); SYSTEM.PORTOUT(3CFH, v);
END LoadReadMode;

PROCEDURE LoadReadSelect(plane : SHORTINT);
BEGIN SYSTEM.PORTOUT(3CEH, 4); SYSTEM.PORTOUT(3CFH, plane);
END LoadReadSelect;

PROCEDURE LoadSetReset(v : SHORTINT);
BEGIN SYSTEM.PORTOUT(3CEH, 0); SYSTEM.PORTOUT(3CFH, v);
END LoadSetReset;

(* This procedure takes the input and turns on the corresponding bit planes *)
PROCEDURE LoadMapMask(v : SHORTINT);
BEGIN SYSTEM.PORTOUT(3C4H, 2); SYSTEM.PORTOUT(3C5H, v);
END LoadMapMask;

PROCEDURE LoadEnableSetReset(v : SHORTINT);
BEGIN SYSTEM.PORTOUT(3CEH, 1); SYSTEM.PORTOUT(3CFH, v);
END LoadEnableSetReset;

PROCEDURE LoadBitMask(v : SYSTEM.BYTE);
BEGIN SYSTEM.PORTOUT(3CEH, 8); SYSTEM.PORTOUT(3CFH, v);
END LoadBitMask;

PROCEDURE - ReadThenWrite     26H, 8AH, 18H, 26H, 88H, 18H; (* mov bl, es:[eax]; mov es:[eax], bl *)
PROCEDURE - CopyReadThenWrite 26H, 8AH, 38H, 26H, 88H, 18H; (* mov bl, es:[eax]; mov es:[eax], bl *)
PROCEDURE - Read 26H, 8AH, 18H; (* mov bl, es:[eax] *)

(* set up VGA to perform writes of type 'mode' (see PO pg 79)
	Set FS field of Data Rotate, leaving data rotate field intact (page 392 of Ferraro)
*)
PROCEDURE SetWriteMode(mode : INTEGER);
VAR v : SHORTINT;
BEGIN
	SYSTEM.PORTOUT(3CEH, 3); SYSTEM.PORTIN(3CFH, v);
	v := ABS(v) MOD 8H + SHORT(mode * 8H);
	SYSTEM.PORTOUT(3CEH, 3); SYSTEM.PORTOUT(3CFH, v);
END SetWriteMode;

(* bl = data to write, edi = screen memory address, esi = color, ecx = # of bit planes *)
PROCEDURE - BitPlaneWrite 81H, 0E7H, 0FFH, 0FFH, 00H, 00H,	(* 						and edi, 0000ffffh ; 64K selector *)
												81H, 0E3H, 0FFH, 00H, 00H, 00H,			(* t:					and ebx, 0ffH *)
												0FH, 0A3H, 0CEH,										(*						bt esi, ecx (is plane IN col) *)
												72H, 03H,														(* 						jc store *)
												0C1H, 0CBH, 08H,										(*						ror ebx, 8 *)
												66H, 0BAH, 0C4H, 03H,								(* store:			mov dx, 3c4 *)
												0B0H, 02H,													(* 						mov al, 2 *)
												0EEH, 															(* 						out dx, al *)
												0B0H, 01H,													(* 						mov al, 1 *)
												0D2H, 0E0H,													(* 						shl al, cl *)
												66H, 0BAH, 0C5H, 03H,								(* 						mov dx, 3c5 *)
												0EEH, 															(* 						out dx, al *)
												26H, 8AH, 3FH,											(* 						mov bh, es:[edi] *)
												26H, 88H, 1FH,											(* 						mov es:[edi], bl *)
												0FH, 0A3H, 0CEH,										(* 						bt esi, ecx (is plane IN col) *)
												72H, 03H,														(* 						jc continue *)
												0C1H, 0C3H, 08H,										(*						rol ebx, 8 *)
												083H, 0E9H, 01H,										(* continue:	sub ecx, 1 *)
												73H, 0CFH;													(* 						jnc t *)

PROCEDURE HLine(col, sx, w, y, mode : INTEGER);
CONST offset = 80; (* 640 DIV 8 *)
VAR m1, m2 : SET; p : LONGINT; d : SYSTEM.BYTE; ex, dx, nbyte : LONGINT;
BEGIN
	ex := sx + w - 1;
	dx := ex DIV 8 - sx DIV 8;
	m1 := {0..7 - sx MOD 8}; m2 := {7 - ex MOD 8..7}; (* see page 512 of VGA book by Ferraro *)
	p := LONG(y) * offset + sx DIV 8; (* must be <65536, due to 64K selector *)
	SetWriteMode(mode); LoadEnableSetReset(15); LoadSetReset(SHORT(col));

	CASE dx OF
		0:
		LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m1 * m2)); SYSTEM.PUTREG(EAX, p); ReadThenWrite;
	|	1:
		LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m1)); SYSTEM.PUTREG(EAX, p); ReadThenWrite;
		INC(p); LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m2)); SYSTEM.PUTREG(EAX, p); ReadThenWrite;
	ELSE
		LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m1)); SYSTEM.PUTREG(EAX, p); ReadThenWrite;
		LoadBitMask(0FFX);
		nbyte := dx - 1; WHILE nbyte > 0 DO INC(p); DEC(nbyte); SYSTEM.PUTREG(EAX, p); ReadThenWrite; END;
		INC(p); LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m2)); SYSTEM.PUTREG(EAX, p); ReadThenWrite;
	END;
	LoadBitMask(0FFX); LoadEnableSetReset(0);
END HLine;

(*XXX
PROCEDURE HLine(col, sx, w, y, mode : INTEGER);
CONST offset = 80; (* 640 DIV 8 *)
VAR m1, m2 : SET; p : LONGINT; d : SYSTEM.BYTE; ex, dx, nbyte : LONGINT;
BEGIN
	ex := sx + w - 1;
	dx := ex DIV 8 - sx DIV 8;
	m1 := {0..7 - sx MOD 8}; m2 := {7 - ex MOD 8..7}; (* see page 512 of VGA book by Ferraro *)
	p := LONG(y) * offset + sx DIV 8; (* must be <65536, due to 64K selector *)
	SetWriteMode(mode);

	CASE dx OF
		0:
			LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m1 * m2));
			SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 4);
			SYSTEM.PUTREG(EDI, p); SYSTEM.PUTREG(EBX, m1 * m2);
			BitPlaneWrite;
	|	1:
			LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m1));
			SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 4);
			SYSTEM.PUTREG(EDI, p); SYSTEM.PUTREG(EBX, m1);
			BitPlaneWrite; INC(p);
			LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m2));
			SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 4);
			SYSTEM.PUTREG(EDI, p); SYSTEM.PUTREG(EBX, m2);
			BitPlaneWrite;
	ELSE
			LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m1));
			SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 4);
			SYSTEM.PUTREG(EDI, p); SYSTEM.PUTREG(EBX, m1);
			BitPlaneWrite;

			LoadBitMask(0FFX); nbyte := dx - 1; 
			WHILE nbyte > 0 DO
				INC(p); DEC(nbyte);
				SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 4);
				SYSTEM.PUTREG(EDI, p); SYSTEM.PUTREG(EBX, 0FFX);
				BitPlaneWrite;
			END;
			INC(p); LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, m2));
			SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 4);
			SYSTEM.PUTREG(EDI, p); SYSTEM.PUTREG(EBX, m2);
			BitPlaneWrite;
	END;
	LoadBitMask(0FFX); LoadEnableSetReset(0);
END HLine;
XXX*)

PROCEDURE VLine(col, ys, ye, x, mode : INTEGER); 
CONST offset = 80; (* 640 DIV 8 *)
VAR p : LONGINT; d, mask : SYSTEM.BYTE; i, dy, t1 : LONGINT;
BEGIN
	IF ys > ye THEN p := ys; ys := ye; ye := SHORT(p); END;
	t1 := -SYSTEM.VAL(LONGINT, SYSTEM.VAL(SET, x) * {0..2});
	mask := SYSTEM.VAL(SYSTEM.BYTE, SYSTEM.LSH(80H, t1));
	SetWriteMode(mode); LoadEnableSetReset(15); LoadBitMask(mask); LoadSetReset(SHORT(col));
	dy := 1 + ye - ys; p := LONG(ys) * offset + x DIV 8;
	WHILE dy > 0 DO SYSTEM.PUTREG(EAX, p); ReadThenWrite; INC(p, offset); DEC(dy);
	END;
	LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, 255)); LoadEnableSetReset(0);
END VLine;

(*raster operations*)
PROCEDURE CopyBlock*(SX, SY, W, H, DX, DY, mode: INTEGER);
CONST offset = 80; (* 640 DIV 8 *)

VAR
	ls, rs, lm, rm : SYSTEM.BYTE;
	sx, dx, t1, shift : SHORTINT;
	t2 : INTEGER;
	S1, S2, Dest : LONGINT;

	PROCEDURE CopyLineRL(src, dest : LONGINT; DestWidth, SourceWidth, shift : SHORTINT; rightmask, leftmask : SYSTEM.BYTE);
	VAR plane, tDestWidth : SHORTINT; t1, s1, s2 : SYSTEM.BYTE; sb : LONGINT; sp, dp : LONGINT;
	BEGIN
		plane := 0;
		WHILE plane < 4 DO
			dp := dest + DestWidth; sp := src + SourceWidth; LoadReadSelect(plane);
			LoadMapMask(SYSTEM.VAL(SHORTINT, {plane})); LoadBitMask(rightmask);

			SYSTEM.PUTREG(EAX, sp); Read; SYSTEM.GETREG(EBX, s1);
			SYSTEM.PUTREG(EAX, sp - 1); Read; SYSTEM.GETREG(EBX, s2); DEC(sp, 2);

			sb := ORD(SYSTEM.VAL(CHAR, s1)) * 100H + ORD(SYSTEM.VAL(CHAR, s2)) * 10000H;
			sb := SYSTEM.ROT(sb, -shift); (* shift right *)
			SYSTEM.PUTREG(EBX, sb DIV 100H); SYSTEM.PUTREG(EAX, dp); CopyReadThenWrite; 
			
			LoadBitMask(0FFX); sb := SYSTEM.ROT(sb, 8);
			INC(sp); tDestWidth := DestWidth - 1; (* number of middle bytes *)
			WHILE tDestWidth > 0 DO
				SYSTEM.PUTREG(EAX, sp); Read; SYSTEM.GETREG(EBX, s2); DEC(sp);
				sb := sb MOD 100H + ORD(SYSTEM.VAL(CHAR, s2)) * 100H;
				SYSTEM.PUTREG(EBX, sb DIV 100H); SYSTEM.PUTREG(EAX, dp); CopyReadThenWrite;
				DEC(dp); sb := SYSTEM.ROT(sb, 8); (* shift left *)
				DEC(tDestWidth);
			END;
			IF DestWidth # SourceWidth THEN
				SYSTEM.PUTREG(EAX, sp); Read; SYSTEM.GETREG(EBX, s2); 
				sb := SYSTEM.ROT(sb, shift); sb := sb MOD 100H + ORD(SYSTEM.VAL(CHAR, s2)) * 100H;
				sb := SYSTEM.ROT(sb, -shift); (* shift right *)
			END;
			LoadBitMask(leftmask);
			SYSTEM.PUTREG(EBX, sb DIV 100H); SYSTEM.PUTREG(EAX, dp); CopyReadThenWrite;
			INC(plane);
		END;
	END CopyLineRL;

	PROCEDURE CopyLineLR(src, dest : LONGINT; DestWidth, SourceWidth, shift : SHORTINT; rightmask, leftmask : SYSTEM.BYTE);
	VAR plane, tDestWidth : SHORTINT; t1, s1, s2 : SYSTEM.BYTE; sb : LONGINT; sp, dp : LONGINT;
	BEGIN
		plane := 0;
		WHILE plane < 4 DO
			dp := dest; sp := src;
			LoadReadSelect(plane); LoadMapMask(SYSTEM.VAL(SHORTINT, {plane})); LoadBitMask(leftmask);
			SYSTEM.PUTREG(EAX, sp); Read; SYSTEM.GETREG(EBX, s1);
			SYSTEM.PUTREG(EAX, sp + 1); Read; SYSTEM.GETREG(EBX, s2); INC(sp, 2);
			sb := ORD(SYSTEM.VAL(CHAR, s1)) * 100H + ORD(SYSTEM.VAL(CHAR, s2));
			sb := SYSTEM.ROT(sb, -shift); (* shift right *)
			SYSTEM.PUTREG(EBX, sb DIV 100H); SYSTEM.PUTREG(EAX, dp); CopyReadThenWrite; INC(dp);
			
			LoadBitMask(0FFX); sb := SYSTEM.ROT(sb, 8);
			tDestWidth := DestWidth - 1; (* number of middle bytes *)
			WHILE tDestWidth > 0 DO
				sb := SYSTEM.ROT(sb, shift);
				SYSTEM.PUTREG(EAX, sp); Read; SYSTEM.GETREG(EBX, s2); INC(sp);
				sb := (sb DIV 100H) * 100H + ORD(SYSTEM.VAL(CHAR, s2)); sb := SYSTEM.ROT(sb, -shift);
				SYSTEM.PUTREG(EBX, sb DIV 100H); SYSTEM.PUTREG(EAX, dp); CopyReadThenWrite;
				INC(dp); sb := SYSTEM.ROT(sb, 8); (* shift left *) DEC(tDestWidth);
			END;

			IF DestWidth # SourceWidth THEN
				SYSTEM.PUTREG(EAX, sp); Read; SYSTEM.GETREG(EBX, s1); 
				sb := SYSTEM.ROT(sb, shift);
				sb := (sb DIV 100H) * 100H + ORD(SYSTEM.VAL(CHAR, s1));
				sb := SYSTEM.ROT(sb, -shift);
			END;
			LoadBitMask(rightmask);
			SYSTEM.PUTREG(EBX, sb DIV 100H); SYSTEM.PUTREG(EAX, dp); CopyReadThenWrite;
			INC(plane);
		END;
	END CopyLineLR;

BEGIN
	LoadSelector;
	SY := MaxY - SY; DY := MaxY - DY; (* Oberon->VGA coordinate system *)

	dx := SHORT((DX + W) DIV 8 - DX DIV 8); (* bytes in destination line *)
	sx := SHORT((SX + W) DIV 8 - SX DIV 8); (* bytes in source line *)
	t1 := SHORT(((DX + W) MOD 8 - ((SX + W) MOD 8)) + 32);
	shift := t1 MOD 32;

	t1 := SHORT(DX MOD 8); (* even source byte shift *)
	lm := SYSTEM.VAL(SYSTEM.BYTE, {0..7-t1})(*SYSTEM.LSH(0FFH, -t1))*);
	t1 := SHORT((DX + W) MOD 8); rm := SYSTEM.VAL(SYSTEM.BYTE, {7-t1..7});

	t1 := SHORT((DX + W) MOD 8); (* right most shift *)
	t1 := SHORT(DX MOD 8 - SX MOD 8); (* even source byte shift *)
	ls := t1; rs := t1 - 8;

	Dest := LONG(DY) * offset + DX DIV 8;
	S1 := LONG(SY) * offset + SX DIV 8;
	S2 := S1 - LONG(H) * offset;

	SetWriteMode(mode); LoadEnableSetReset(0);
	IF DX <= SX THEN (* Copy highest Y to lowest Y *)
		IF DY > SY THEN
			WHILE S1 >= S2 DO
				CopyLineLR(S1, Dest, dx, sx, shift, rm, lm);
				DEC(S1, offset); DEC(Dest, offset);
			END;
		ELSE
			DEC(Dest, LONG(H) * offset);
			WHILE S2 <= S1 DO
				CopyLineLR(S2, Dest, dx, sx, shift, rm, lm);
				INC(S2, offset); INC(Dest, offset);
			END;
		END;
	ELSE
		IF DY > SY THEN
			WHILE S1 >= S2 DO
				CopyLineRL(S1, Dest, dx, sx, shift, rm, lm);
				DEC(S1, offset); DEC(Dest, offset);
			END;
		ELSE
			DEC(Dest, LONG(H) * offset);
			WHILE S2 <= S1 DO
				CopyLineRL(S2, Dest, dx, sx, shift, rm, lm);
				INC(S2, offset); INC(Dest, offset);
			END;
		END;
	END;
	LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, 255)); LoadEnableSetReset(0); LoadMapMask(AllPlane);
	RestoreSelector;
END CopyBlock;

(* Copy WxH block of bits from BitAdr to (X,Y).  OFS is used as a starting
   bit offset from the first byte of BitAdr.  Y is in VGA coords.  Block
	 is filled from the bottom up. (invariant: ye <= Y)
	 PW designates the width of the bitblk (in bits) which is to be copied
*)
PROCEDURE BitBlt(col : INTEGER; BitBlkAdr : LONGINT; OFS : INTEGER; X, Y, W, H, PW, mode : INTEGER);
CONST offset = 80; (* 640 DIV 8 *)
VAR s1, s2 : SYSTEM.BYTE;  lm, rm : SET; shift : SHORTINT;  tW, i : INTEGER; 
	sb, st, y, ye, dp, sp : LONGINT; mb : INTEGER; (* multi byte *)
BEGIN
	SetWriteMode(mode); LoadEnableSetReset(0H); LoadSetReset(SHORT(col));
	LoadMapMask(AllPlane); LoadSelector;
	LoadReadSelect(AllPlane);
	shift := SHORT(X MOD 8 - OFS MOD 8 + 32) MOD 32; OFS := OFS DIV 8;
	y := LONG(Y) * offset + X DIV 8; ye := LONG(max(0, Y - H)) * offset + X DIV 8;
	PW := (PW + (-PW) MOD 8) DIV 8; (* pattern width in bytes *)
	mb := (X + W - 1) DIV 8 - X DIV 8;
	lm := {0..7 - X MOD 8}; rm := {7 - (X + W - 1) MOD 8..7};

	WHILE y > ye DO
		sp := BitBlkAdr + OFS; dp := y;
		SYSTEM.GET(sp, s1); 
		IF PW > 1 THEN SYSTEM.GET(sp + 1, s2); i := 2; ELSE s2 := 0X; i := 1; END;
		sb := ORD(SYSTEM.VAL(CHAR, s1)) * 100H + ORD(SYSTEM.VAL(CHAR, s2)); 
		sb := SYSTEM.VAL(LONGINT, SYSTEM.VAL(SET, sb) - {16..31});
		sb := SYSTEM.ROT(sb, -shift); st := sb DIV 100H;
		CASE mb OF
			0:
				LoadBitMask(SYSTEM.VAL(SHORTINT, lm * rm)); 
				SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 3);
				SYSTEM.PUTREG(EDI, dp); SYSTEM.PUTREG(EBX, st);
				BitPlaneWrite;
		|	1:
				LoadBitMask(SYSTEM.VAL(SHORTINT, lm)); 
				SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 3);
				SYSTEM.PUTREG(EDI, dp); SYSTEM.PUTREG(EBX, st);
				BitPlaneWrite; INC(dp);
				sb := SYSTEM.ROT(sb, 8); st := sb DIV 100H; LoadBitMask(SYSTEM.VAL(SHORTINT, rm)); 
				SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 3);
				SYSTEM.PUTREG(EDI, dp); SYSTEM.PUTREG(EBX, st);
				BitPlaneWrite; INC(dp);
		ELSE
				LoadBitMask(SYSTEM.VAL(SHORTINT, lm)); 
				SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 3);
				SYSTEM.PUTREG(EDI, dp); SYSTEM.PUTREG(EBX, st);
				BitPlaneWrite; INC(dp);
				sb := SYSTEM.ROT(sb, 8); st := sb DIV 100H; LoadBitMask(0FFX); 

				tW := mb - 1;
				WHILE tW > 0 DO
					sb := SYSTEM.ROT(sb, shift);
					IF i >= PW THEN s2 := 0X; ELSE SYSTEM.GET(sp + i, s2); INC(i); END;
					sb := (sb DIV 100H) * 100H + ORD(SYSTEM.VAL(CHAR, s2));
					sb := SYSTEM.ROT(sb, -shift); st := sb DIV 100H;
					SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 3);
					SYSTEM.PUTREG(EDI, dp); SYSTEM.PUTREG(EBX, st);
					BitPlaneWrite; INC(dp);
					sb := SYSTEM.ROT(sb, 8); DEC(tW);
				END;

				st := sb DIV 100H;
				LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, rm)); 
				SYSTEM.PUTREG(ESI, col); SYSTEM.PUTREG(ECX, 3);
				SYSTEM.PUTREG(EDI, dp); SYSTEM.PUTREG(EBX, st);
				BitPlaneWrite;
		END;
		INC(BitBlkAdr, LONG(PW)); DEC(y, offset);
	END;
	LoadBitMask(SYSTEM.VAL(SYSTEM.BYTE, 255)); LoadEnableSetReset(0); LoadMapMask(AllPlane); RestoreSelector;
END BitBlt;

PROCEDURE PutPattern(col : INTEGER; pat : Pattern; X, Y, W, H, mode : INTEGER);
CONST offset = 80; (* 640 DIV 8 *)
VAR w, h : SHORTINT;
BEGIN
	SYSTEM.GET(pat, w); SYSTEM.GET(pat + 1, h);
	BitBlt(col, pat + 2 * SIZE(SHORTINT), 0, X, Y, min(W, w), min(H, h), w, mode);
END PutPattern;

(* Pours a Pattern to the VGA at X, Y.
	 This routine must take care of the following situations:
		o pattern is 1 byte wide
		o pattern is >1 byte wide
		o pattern is >2 bytes wide

		o In all cases, it must be independant of the starting position
		  (byte boundary or not...)
*)
PROCEDURE CopyPattern*(col: INTEGER; pat: Pattern; X, Y, mode: INTEGER);
BEGIN
	Y := MaxY - Y; (* Oberon->VGA coordinate system *)
	PutPattern(col, pat, X, Y, MAX(INTEGER), MAX(INTEGER), mode);
END CopyPattern;

PROCEDURE ReplPattern*(col: INTEGER; pat: Pattern; X, Y, W, H, mode: INTEGER);
VAR ye, x, xe, wt : INTEGER; w, h : SHORTINT;
BEGIN
	Y := MaxY - Y; (* Oberon->VGA coordinate *)
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
BEGIN HALT(20);
END ReplPatternC;

PROCEDURE ReplConst*(col: INTEGER; X, Y, W, H, mode: INTEGER);
VAR y1 : INTEGER;
BEGIN
	LoadSelector;
	Y := MaxY - Y; y1 := Y - H + 1; (* Oberon->VGA coordinate system *)
	IF W = 1 THEN VLine(col, y1, Y, X, mode);
	ELSIF W > 0 THEN WHILE y1 <= Y DO HLine(col, X, W, y1, mode); INC(y1);	END;
	END;
	RestoreSelector;
END ReplConst;

PROCEDURE Dot*(col: INTEGER; X, Y: LONGINT; mode: INTEGER);
BEGIN
	SetWriteMode(mode);
	SYSTEM.PUTREG(ECX, X);
	SYSTEM.PUTREG(EDX, MaxY - Y); (* Oberon->VGA coordinate system *)
	SYSTEM.PUTREG(EBX, 0);
	SYSTEM.PUTREG(EAX, 0C00H + col);
	VideoInterrupt;
END Dot;

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
	Width := MaxX + 1; Height := MaxY + 1; Unit := 10000;
	Left := 0; ColLeft := 0; Bottom := 0; UBottom := 0;
END Display.