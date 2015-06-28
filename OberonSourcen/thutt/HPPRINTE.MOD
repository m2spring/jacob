MODULE Printer;  (*NW 27.6.88 / 11.3.91, TWH 931003 (using postscript header from jtempl) *)
IMPORT SYSTEM, Input, Files, Kernel;

CONST
	maxfonts = 16;

VAR 
	res*: INTEGER; (*0 = done, 1 = not done*)
	(* (0,0) is the upper left corner 
		 (PageWidth - 1, PageHeight - 1) is lower right corner
	*)
	PageWidth*, PageHeight*: INTEGER;
	nofonts: INTEGER;
	seqno: SHORTINT;
	in: INTEGER;
	PrinterName: ARRAY 10 OF CHAR;
	fontname: ARRAY maxfonts, 32 OF CHAR;


CONST (* Postscript commands *)
	moveto				= 'm';
	string				= 's';
	dieresis			= 'd';
	line					= 'l';
	xline					= 'x';
	scaledcircle	= 'c';
	shadedbox			= 'b';
	patternimage	= 'i';
	page					= 'p';
	font					= 'f';
	bezier				= 'z';
	char					= 'k';

CONST (* register *)
	EAX = 0; ECX = 1; EDX = 2; EBX = 3; ESP = 4; EBP = 5; ESI = 6; EDI = 7;

PROCEDURE - DOSInterrupt 0CDH, 21H;

PROCEDURE Send(ch: SYSTEM.BYTE);
BEGIN SYSTEM.PUTREG(EDX, ch); SYSTEM.PUTREG(EAX, 500H); DOSInterrupt;
END Send;

(*
PROCEDURE Send(ch : SYSTEM.BYTE);
BEGIN Kernel.DebugWrite(SYSTEM.VAL(CHAR, ch)); 
END Send;
*)

PROCEDURE SendInt(x: INTEGER);
VAR	i: SHORTINT; y: LONGINT; a : ARRAY 5 OF CHAR;
BEGIN i := 0;
	REPEAT y := x MOD 10; a[i] := CHR(y + 30H); x := x DIV 10; INC(i);
	UNTIL (x = 0) OR (i > LEN(a));
	REPEAT DEC(i); Send(a[i]); UNTIL i = 0;
	Send(' ');
END SendInt;

PROCEDURE SendHex(x : INTEGER);
VAR	i: SHORTINT; y: LONGINT; a : ARRAY 2 OF CHAR;
BEGIN i := 0;
	REPEAT 
		y := x MOD 10H;
		IF y < 10 THEN a[i] := CHR(y + 30H) ELSE a[i] := CHR(y + 37H) END;
		x := x DIV 10H; INC(i);
	UNTIL i = LEN(a);
	Send(a[0]); Send(a[1]); Send(' ');
END SendHex;

PROCEDURE SendCommand(ch : CHAR);
BEGIN Send(ch); Send(' ');
END SendCommand;

PROCEDURE MoveTo(x, y : INTEGER);
BEGIN SendInt(x); SendInt(y); SendCommand(moveto);
END MoveTo;

PROCEDURE NL;
BEGIN Send(0DX); Send(0AX);
END NL;

PROCEDURE SendBytes(VAR x: ARRAY OF SYSTEM.BYTE; n: INTEGER);
END SendBytes;

PROCEDURE SendString(VAR s: ARRAY OF CHAR);
VAR i : INTEGER; ch : CHAR;
BEGIN 
	Send('('); 
	i := 0;
	ch := s[i];
	WHILE (i < LEN(s)) & (ch # 0X) DO
		IF (ch= ')') OR (ch = '(') THEN Send('\'); END;
		Send(ch); INC(i); ch := s[i];
	END;
	Send(')'); Send(' ');
END SendString;

PROCEDURE ReplConst*(x, y, w, h: INTEGER);
BEGIN SendInt(x); SendInt(y); SendInt(w); SendInt(h); SendCommand(line); NL;
END ReplConst;

PROCEDURE fontno(VAR name: ARRAY OF CHAR): SHORTINT;
END fontno;

PROCEDURE UseListFont*(VAR name: ARRAY OF CHAR);
END UseListFont;

PROCEDURE String*(x, y: INTEGER; VAR s, fname: ARRAY OF CHAR);
BEGIN MoveTo(x, y); SendString(fname); SendCommand(font); SendString(s); SendCommand('s'); NL;
END String;

PROCEDURE ContString*(VAR s, fname: ARRAY OF CHAR);
BEGIN SendString(fname); SendCommand(font); SendString(s); SendCommand('s'); NL;
END ContString;

PROCEDURE ReplPattern*(x, y, w, h, col: INTEGER);
BEGIN SendInt(x); SendInt(y); SendInt(w); SendInt(h); SendInt(col); SendCommand(shadedbox);
END ReplPattern;

PROCEDURE Line*(x0, y0, x1, y1: INTEGER);
BEGIN SendInt(x0); SendInt(y0); SendInt(x1); SendInt(y1); SendCommand(xline); NL;
END Line;

PROCEDURE Circle*(x0, y0, r: INTEGER);
BEGIN SendInt(x0); SendInt(y0); SendInt(r); SendInt(r); SendCommand(scaledcircle); NL;
END Circle;

PROCEDURE Ellipse*(x0, y0, a, b: INTEGER);
BEGIN SendInt(x0); SendInt(y0); SendInt(a); SendInt(b); SendCommand(scaledcircle); NL;
END Ellipse;

PROCEDURE Spline*(x0, y0, n, open: INTEGER; VAR X, Y: ARRAY OF INTEGER);
BEGIN HALT(45);
END Spline;

PROCEDURE Picture*(x, y, w, h, mode: INTEGER; adr: LONGINT);
VAR b: CHAR; i,l,xe,ye: INTEGER;
BEGIN SendInt(x); SendInt(y); SendInt(w); SendInt(h); SendInt(mode); Send(' '); SendCommand(patternimage); NL;
	xe := x + w DIV 8; ye := y + h;
	WHILE y < ye DO 
		i := x; WHILE i < xe DO SYSTEM.GET(adr, b); INC(adr); SendHex(ORD(b)); INC(i); END;
		NL; INC(y);
	END;
END Picture;

PROCEDURE Page*(nofcopies: INTEGER);
BEGIN SendInt(nofcopies); SendCommand(page); NL;
END Page;

PROCEDURE Open*(VAR name, user: ARRAY OF CHAR; password: LONGINT);
VAR f : Files.File; r : Files.Rider; ch : CHAR;
BEGIN
	f := Files.Old("psheader.Text");
	IF f # NIL THEN
		Files.Set(r, f, 0);
		Files.Read(r, ch); WHILE ~r.eof DO Send(ch); Files.Read(r, ch); END;
		Files.Close(f);
	END;
END Open;

PROCEDURE Close*;
END Close;

PROCEDURE Init;
END Init;

BEGIN Init; PageWidth := 2550; PageHeight := 3300; in := 0; PrinterName[0] := 0X;	res := 0;
END Printer.
