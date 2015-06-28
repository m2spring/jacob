(* $Id: IO.mi,v 1.9 1992/01/30 13:23:29 grosch rel $ *)

(* $Log: IO.mi,v $
 * Revision 1.9  1992/01/30  13:23:29  grosch
 * redesign of interface to operating system
 *
 * Revision 1.8  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.7  91/06/07  12:19:51  grosch
 * decreased bounds of flexible arrays
 * 
 * Revision 1.6  91/06/07  11:37:42  grosch
 * increased bounds of flexible arrays
 * 
 * Revision 1.5  91/01/16  17:11:13  grosch
 * fixed range check problem with BytesRead
 * 
 * Revision 1.4  89/08/18  11:11:48  grosch
 * make Write work for Size = 0
 * 
 * Revision 1.3  89/07/14  16:27:15  grosch
 * made WriteN work for numbers with MSBit set
 * 
 * Revision 1.2  89/01/25  19:37:28  grosch
 * tuning: ReadC inline in Read and ReadS, WriteC inline in Write and WriteS
 * 
 * Revision 1.1  89/01/24  19:04:35  grosch
 * added procedure UnRead
 * 
 * Revision 1.0  88/10/04  11:46:58  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE IO;
IMPORT General,Memory,System,SYSTEM;

CONST
   StdInput*	= System.StdInput;
   StdOutput*	= System.StdOutput;
   StdError*	= System.StdError;

TYPE
   tFile*	= System.tFile;
   ADDRESS  = LONGINT;
   CARDINAL = LONGINT;
   LONGCARD = LONGINT;

CONST
   EolCh		= 0AX;
   TabCh		= 9X;
   BufferSize		= 1024;
   MaxInt		= 2147483647;	(* 2 ** 31 - 1 *)
   MaxPow10		= 1000000000;
   MaxIntDiv10		= MaxInt DIV 10;

TYPE
   tBuffer = POINTER TO ARRAY BufferSize+1 OF CHAR;
   BufferDescriptor	= RECORD
	 Buffer		: tBuffer;
	 BufferIndex	:LONGINT; 
	 BytesRead	:LONGINT; 
	 OpenForOutput	: BOOLEAN;
	 EndOfFile	: BOOLEAN;
	 FlushLine	: BOOLEAN;
      END;

   (* INV BufferIndex points before the character to be read next *)

VAR
   BufferPool	: ARRAY System.cMaxFile+1 OF BufferDescriptor;
   i		: tFile;
   MyCHR	: ARRAY 16 OF CHAR;

PROCEDURE^WriteFlush*	(f: tFile);		(* flush output buffer	*)
PROCEDURE^CheckFlushLine (f: tFile);
PROCEDURE^WriteN*	(f: tFile; n: LONGCARD; FieldWidth, Base: CARDINAL);

PROCEDURE FillBuffer	(f: tFile);
   VAR w:BufferDescriptor;
   BEGIN
	 IF BufferPool [f].FlushLine THEN
	    WriteFlush (StdOutput);
	    WriteFlush (StdError );
	 END;
	 BufferPool [f].BufferIndex := 0;
	 BufferPool [f].BytesRead := System.Read (f, SYSTEM.ADR (BufferPool [f].Buffer^ [1]), BufferSize);
	 IF BufferPool [f].BytesRead <= 0 THEN
	    BufferPool [f].BytesRead := 0;
	    BufferPool [f].EndOfFile := TRUE;
	 END;
   END FillBuffer;

PROCEDURE ReadOpen*	(VAR FileName: ARRAY OF CHAR): tFile;
   VAR						(* open  input file	*)
      f		: tFile;
   BEGIN
      f := System.OpenInput (FileName);
	 BufferPool [f].Buffer		:= SYSTEM.VAL(tBuffer,Memory.Alloc (BufferSize + 1));
	 BufferPool [f].BufferIndex	:= 0;
	 BufferPool [f].BytesRead	:= 0;
	 BufferPool [f].OpenForOutput	:= FALSE;
	 BufferPool [f].EndOfFile	:= FALSE;
      CheckFlushLine (f);
      RETURN f;
   END ReadOpen;

PROCEDURE ReadClose*	(f: tFile);		(* close input file	*)
   BEGIN
      System.Close (f);
	 Memory.Free (BufferSize + 1, SYSTEM.VAL(LONGINT,BufferPool [f].Buffer));
	 BufferPool [f].Buffer := NIL;
   END ReadClose;

PROCEDURE Read*		(f: tFile; Buffer: ADDRESS; Size: CARDINAL):LONGINT; 
   VAR						(* binary		*)
      BufferPtr : tBuffer;
      i		: CARDINAL;
   BEGIN
      BufferPtr := BufferPool [f].Buffer;
	 i := 0;
	 LOOP
	    IF i = Size THEN RETURN i; END;
	    IF BufferPool [f].BufferIndex = BufferPool [f].BytesRead THEN	(* ReadC inline		*)
	       FillBuffer (f);
	       IF BufferPool [f].EndOfFile THEN BufferPool [f].Buffer^ [1] := 0X; END;
	    END;
	    INC (BufferPool [f].BufferIndex);
	    BufferPtr^ [i] := BufferPool [f].Buffer^ [BufferPool [f].BufferIndex];
	    IF BufferPool [f].EndOfFile THEN RETURN i; END;
	    INC (i);
	 END;
   END Read;

PROCEDURE ReadC*		(f: tFile): CHAR;	(* character		*)
   BEGIN
	 IF BufferPool [f].BufferIndex = BufferPool [f].BytesRead THEN
	    FillBuffer (f);
	    IF BufferPool [f].EndOfFile THEN BufferPool [f].Buffer^ [1] := 0X; END;
	 END;
	 INC (BufferPool [f].BufferIndex);
	 RETURN BufferPool [f].Buffer^ [BufferPool [f].BufferIndex];
   END ReadC;

PROCEDURE ReadI*		(f: tFile): LONGINT;	(* integer  number	*)
   VAR
      n		: LONGINT;
      ch	: CHAR;
      negative	: BOOLEAN;
   BEGIN
      REPEAT
         ch := ReadC (f);
      UNTIL (ch # ' ') & (ch # TabCh) & (ch # EolCh);
      CASE ch OF
      |  '+' : negative := FALSE; ch := ReadC (f);
      |  '-' : negative := TRUE ; ch := ReadC (f);
      ELSE     negative := FALSE;
      END;
      n := 0;
      WHILE ('0' <= ch) & (ch <= '9') DO
	 n := 10 * n + (ORD (ch) - ORD ('0'));
	 ch := ReadC (f);
      END;
      DEC (BufferPool [f].BufferIndex);
      IF negative
      THEN RETURN - n;
      ELSE RETURN   n;
      END;
   END ReadI;

PROCEDURE ReadR*		(f: tFile): REAL;	(* real     number	*)
   VAR
      n			: REAL;
      Mantissa		: LONGCARD;
      Exponent		:LONGINT; 
      MantissaNeg	: BOOLEAN;
      ExponentNeg	: BOOLEAN;
      FractionDigits	: CARDINAL;
      TruncatedDigits	: CARDINAL;
      ch		: CHAR;
   BEGIN
      MantissaNeg	:= FALSE;
      Mantissa		:= 0;
      Exponent		:= 0;
      FractionDigits	:= 0;
      TruncatedDigits	:= 0;

      REPEAT					(* skip white space	*)
	 ch := ReadC (f);
      UNTIL (ch # ' ') & (ch # TabCh) & (ch # EolCh);

      CASE ch OF				(* handle sign		*)
      | '+' : ch := ReadC (f);
      | '-' : ch := ReadC (f); MantissaNeg := TRUE;
      | 'E' : Mantissa := 1;
      ELSE
      END;

      WHILE ('0' <= ch) & (ch <= '9') DO	(* integer part		*)
	 IF Mantissa <= MaxIntDiv10 THEN
	    Mantissa := 10 * Mantissa;
	    IF Mantissa <= MaxInt - (ORD (ch) - ORD ('0')) THEN
	       INC (Mantissa, LONG(ORD (ch) - ORD ('0')));
	    ELSE
	       INC (TruncatedDigits);
	    END;
	 ELSE
	    INC (TruncatedDigits);
	 END;
	 ch := ReadC (f);
      END;

      IF ch = '.' THEN ch := ReadC (f); END;	(* decimal point	*)

      WHILE ('0' <= ch) & (ch <= '9') DO	(* fractional part	*)
	 IF Mantissa <= MaxIntDiv10 THEN
	    Mantissa := 10 * Mantissa;
	    IF Mantissa <= MaxInt - (ORD (ch) - ORD ('0')) THEN
	       INC (Mantissa, LONG(ORD (ch) - ORD ('0')));
	    ELSE
	       INC (TruncatedDigits);
	    END;
	 ELSE
	    INC (TruncatedDigits);
	 END;
	 INC (FractionDigits);
	 ch := ReadC (f);
      END;

      IF ch = 'E' THEN				(* exponent		*)
	 ch := ReadC (f);

	 CASE ch OF
	 |  '+' : ExponentNeg := FALSE; ch := ReadC (f);
	 |  '-' : ExponentNeg := TRUE ; ch := ReadC (f);
	 ELSE     ExponentNeg := FALSE;
	 END;

	 WHILE ('0' <= ch) & (ch <= '9') DO
	    Exponent := 10 * Exponent + (ORD (ch) - ORD ('0'));
	    ch := ReadC (f);
	 END;

	 IF ExponentNeg THEN
	    Exponent := - Exponent;
	 END;
      END;

      DEC (BufferPool [f].BufferIndex);
      DEC (Exponent, FractionDigits - TruncatedDigits);
      n := (1.0*Mantissa) * General.Exp10 (Exponent);
      IF MantissaNeg
      THEN RETURN - n;
      ELSE RETURN   n;
      END;
   END ReadR;

PROCEDURE ReadB*		(f: tFile): BOOLEAN;	(* boolean		*)
   BEGIN
      RETURN ReadC (f) = 'T';
   END ReadB;

PROCEDURE ReadN*		(f: tFile; Base: LONGINT): LONGINT;
   VAR						(* number of base 'Base'*)
      n		: LONGINT;
      ch	: CHAR;
      digit	: LONGINT;
   BEGIN
      REPEAT
	 ch := ReadC (f);
      UNTIL (ch # ' ') & (ch # TabCh) & (ch # EolCh);
      n := 0;
      LOOP
	 IF ('0' <= ch) & (ch <= '9') THEN
	    digit := ORD (ch) - ORD ('0');
	 ELSIF ('A' <= ch) & (ch <= 'F') THEN
	    digit := ORD (ch) - ORD ('A') + 10;
	 ELSE
	    digit := 99;
	 END;
	 IF digit >= Base THEN EXIT; END;
	 n := Base * n + digit;
	 ch := ReadC (f);
      END;
      DEC (BufferPool [f].BufferIndex);
      RETURN n;
   END ReadN;

PROCEDURE ReadS*		(f: tFile; VAR s: ARRAY OF CHAR);
   VAR i	: CARDINAL;			(* string		*)
   BEGIN
	 FOR i := 0 TO LEN(s) DO
	    IF BufferPool [f].BufferIndex = BufferPool [f].BytesRead THEN	(* ReadC inline		*)
	       FillBuffer (f);
	       IF BufferPool [f].EndOfFile THEN BufferPool [f].Buffer^ [1] := 0X; END;
	    END;
	    INC (BufferPool [f].BufferIndex);
	    s [i] := BufferPool [f].Buffer^ [BufferPool [f].BufferIndex];
	 END;
   END ReadS;

PROCEDURE ReadShort*	(f: tFile):LONGINT; 	(* shortint number	*)
   BEGIN
      RETURN ReadI (f);
   END ReadShort;

PROCEDURE ReadLong*	(f: tFile): LONGINT;	(* longint  number	*)
   BEGIN
      RETURN ReadI (f);
   END ReadLong;

PROCEDURE ReadCard*	(f: tFile): CARDINAL;	(* cardinal number	*)
   BEGIN
      RETURN ReadI (f);
   END ReadCard;

PROCEDURE ReadNl*	(f: tFile);		(* new line		*)
   BEGIN
      REPEAT
      UNTIL ReadC (f) = EolCh;
   END ReadNl;

PROCEDURE UnRead*	(f: tFile);		(* backspace 1 char.	*)
   BEGIN
      DEC (BufferPool [f].BufferIndex);
   END UnRead;


PROCEDURE EndOfLine*	(f: tFile): BOOLEAN;	(* end of line ?	*)
   VAR ch : CHAR;
   BEGIN
	 IF BufferPool [f].BufferIndex = BufferPool [f].BytesRead THEN
	    FillBuffer (f);
	    IF BufferPool [f].EndOfFile THEN BufferPool [f].Buffer^ [1] := 0X; END;
	 END;
	 RETURN BufferPool [f].Buffer^ [BufferPool [f].BufferIndex + 1] = EolCh;
   END EndOfLine;

PROCEDURE EndOfFile*	(f: tFile): BOOLEAN;	(* end of file ?	*)
   VAR ch : CHAR;
   BEGIN
      ch := ReadC (f);
      DEC (BufferPool [f].BufferIndex);
      RETURN BufferPool [f].EndOfFile;
   END EndOfFile;


PROCEDURE CheckFlushLine (f: tFile);
   BEGIN
      BufferPool [f].FlushLine := System.IsCharacterSpecial (f);
   END CheckFlushLine;

PROCEDURE WriteOpen*	(VAR FileName: ARRAY OF CHAR): tFile;
   VAR						(* open  output file	*)
      f		: tFile;
   BEGIN
      f := System.OpenOutput (FileName);
	 BufferPool [f].Buffer		:= SYSTEM.VAL(tBuffer,Memory.Alloc (BufferSize + 1));
	 BufferPool [f].BufferIndex	:= 0;
	 BufferPool [f].OpenForOutput	:= TRUE;
      CheckFlushLine (f);
      RETURN f;
   END WriteOpen;

PROCEDURE WriteClose*	(f: tFile);		(* close output file	*)
   BEGIN
      WriteFlush (f);
      System.Close (f);
	 Memory.Free (BufferSize + 1, SYSTEM.VAL(LONGINT,BufferPool [f].Buffer));
	 BufferPool [f].Buffer := NIL;
   END WriteClose;

PROCEDURE WriteFlush*	(f: tFile);		(* flush output buffer	*)
   BEGIN
	 BufferPool [f].BytesRead := System.Write (f, SYSTEM.ADR (BufferPool [f].Buffer^ [1]), BufferPool [f].BufferIndex);
	 BufferPool [f].BufferIndex := 0;
   END WriteFlush;

PROCEDURE Write*		(f: tFile; Buffer: ADDRESS; Size:LONGINT):LONGINT; 
   VAR						(* binary		*)
      BufferPtr : tBuffer;
      i		: LONGINT;
   BEGIN
      BufferPtr := SYSTEM.VAL(tBuffer,Buffer);
	 FOR i := 0 TO Size - 1 DO
	    INC (BufferPool [f].BufferIndex);			(* WriteC inline	*)
	    BufferPool [f].Buffer^ [BufferPool [f].BufferIndex] := BufferPtr^ [i];
	    IF (BufferPool [f].BufferIndex = BufferSize) THEN WriteFlush (f); END;
	 END;
      RETURN Size;
   END Write;

PROCEDURE WriteC*	(f: tFile; c: CHAR);	(* character		*)
   BEGIN
	 INC (BufferPool [f].BufferIndex);
	 BufferPool [f].Buffer^ [BufferPool [f].BufferIndex] := c;
	 IF (BufferPool [f].BufferIndex = BufferSize) OR BufferPool [f].FlushLine & (c = EolCh) THEN
	    WriteFlush (f);
	 END;
   END WriteC;

PROCEDURE WriteI*	(f: tFile; n:LONGINT; FieldWidth: CARDINAL);
   VAR						(* integer  number	*)
      i		:LONGINT; 
      length	: CARDINAL;
      negative	: CARDINAL;
      digits	: ARRAY 11 OF CHAR;
   BEGIN
      IF n < 0 THEN
	 negative := 1;
	 n := - n;
      ELSE
	 negative := 0;
      END;
      length := 0;
      REPEAT
	 INC (length);
	 digits [length] := MyCHR [n MOD 10];
	 n := n DIV 10;
      UNTIL n = 0;
      FOR i := 1 TO (FieldWidth - length - negative) DO
	 WriteC (f, ' ');
      END;
      IF negative = 1 THEN WriteC (f, '-'); END;
      FOR i := (length) TO 1 BY -1 DO
	 WriteC (f, digits [i]);
      END;
   END WriteI;

PROCEDURE WriteR*	(f: tFile; n: REAL; Before, After, Exp: CARDINAL);
   CONST					(* real   number	*)
      StartIndex	= 100;
   VAR
      i			: CARDINAL;
      j			:LONGINT; 
      FirstDigit	: CARDINAL;
      IntegerDigits	: CARDINAL;
      TotalDigits	: CARDINAL;
      IsNegative	: CARDINAL;
      Digits		: ARRAY 201 OF CARDINAL;
      MaxCard		: REAL;
      MaxCardDiv10	: REAL;
      Mantissa		: LONGCARD;
      Exponent		: LONGINT;
   BEGIN
      MaxCard		:= (MaxInt);
      MaxCardDiv10	:= (MaxIntDiv10);

      IF n < 0.0 THEN				(* determine sign	*)
	 IsNegative := 1;
	 n := - n;
      ELSE
	 IsNegative := 0;
      END;

      IF n = 0.0 THEN		(* determine mantissa and exponent	*)
	 Mantissa := 0;
	 Exponent := 1;
      ELSE
	 Exponent := 10;			(* normalize mantissa	*)
	 WHILE n > MaxCard DO
	    n := n / 10.0;
	    INC (Exponent);
	 END;
	 WHILE n <= MaxCardDiv10 DO
	    n := n * 10.0;
	    DEC (Exponent);
	 END;
	 Mantissa := ENTIER(n);
	 IF Mantissa < MaxPow10 THEN
	    DEC (Exponent);
	 END;
      END;
      						(* determine size of:	*)
      IF (Exp > 0) OR (Exponent <= 0) THEN	(* integer part		*)
	 IntegerDigits := 1;
      ELSE
	 IntegerDigits := Exponent;
      END;
      IF After = 0 THEN After := 1; END;	(* fractional part	*)
      TotalDigits := IntegerDigits + After;	(* total # of digits	*)

      FirstDigit := StartIndex;			(* convert mantissa	*)
      REPEAT
	 DEC (FirstDigit);
	 Digits [FirstDigit] := Mantissa MOD 10;
	 Mantissa := Mantissa DIV 10;
      UNTIL Mantissa = 0;
      IF Exp = 0 THEN				(* add leading zeroes	*)
	 FOR j := 1 TO 1 - Exponent DO
	    DEC (FirstDigit);
	    Digits [FirstDigit] := 0;
	 END;
      END;
      FOR i := StartIndex TO FirstDigit + TotalDigits DO
	 Digits [i] := 0;			(* add trailing zeroes	*)
      END;

      Digits [FirstDigit - 1] := 0;		(* round mantissa	*)
      IF Digits [FirstDigit + TotalDigits] >= 5 THEN
	 i := FirstDigit + TotalDigits - 1;
	 WHILE Digits [i] = 9 DO		(* carry		*)
	    Digits [i] := 0;
	    DEC (i);
	 END;
	 INC (Digits [i]);
	 IF i = FirstDigit - 1 THEN (* carry at most significant pos.	*)
	    FirstDigit := i;
	    IF Exp > 0 THEN
	       INC (Exponent);
	    ELSIF Exponent > 0 THEN
	       INC (IntegerDigits);
	    END;
	 END;
      END;
						(* print mantissa	*)
      FOR j := 1 TO (Before - IsNegative - IntegerDigits) DO
	 WriteC (f, ' ');			(* leading spaces	*)
      END;
      IF IsNegative = 1 THEN WriteC (f, '-'); END;	(* sign		*)
      FOR i :=  1 TO IntegerDigits DO		(* integer part		*)
	 WriteC (f, MyCHR [Digits [FirstDigit]]);
	 INC (FirstDigit);
      END;
      WriteC (f, '.');				(* decimal point	*)
      FOR i :=  1 TO After DO			(* fractional part	*)
	 WriteC (f, MyCHR [Digits [FirstDigit]]);
	 INC (FirstDigit);
      END;

      IF Exp > 0 THEN				(* print exponent	*)
	 DEC (Exponent);
	 WriteC (f, 'E');
	 IF Exponent < 0 THEN
	    WriteC (f, '-');
	    Exponent := - Exponent;
	 ELSE
	    WriteC (f, '+');
	 END;
	 WriteN (f, Exponent, Exp - 1, 10);
      END;
   END WriteR;

PROCEDURE WriteB*	(f: tFile; b: BOOLEAN);	(* boolean		*)
   BEGIN
      IF b
      THEN WriteC (f, 'T');
      ELSE WriteC (f, 'F');
      END;
   END WriteB;

PROCEDURE WriteN*	(f: tFile; n: LONGCARD; FieldWidth, Base: CARDINAL);
   VAR						(* number of base 'Base'*)
      i		:LONGINT; 
      length	: CARDINAL;
      digits	: ARRAY 33 OF CHAR;
   BEGIN
      length := 0;
      REPEAT
	 INC (length);
	 digits [length] := MyCHR [n MOD Base];
	 n := n DIV Base;
      UNTIL n = 0;
      FOR i := 1 TO (FieldWidth - length) DO
	 WriteC (f, '0');
      END;
      FOR i := (length) TO 1 BY -1 DO
	 WriteC (f, digits [i]);
      END;
   END WriteN;

PROCEDURE WriteS*	(f: tFile; s: ARRAY OF CHAR); 
   VAR i	: CARDINAL;			(* string		*)
   VAR c	: CHAR;
   BEGIN
	 FOR i := 0 TO LEN(s) DO
	    c := s [i];
	    IF c = 0X THEN RETURN; END;
	    INC (BufferPool [f].BufferIndex);			(* WriteC inline	*)
	    BufferPool [f].Buffer^ [BufferPool [f].BufferIndex] := c;
	    IF (BufferPool [f].BufferIndex = BufferSize) OR BufferPool [f].FlushLine & (c = EolCh) THEN
	       WriteFlush (f);
	    END;
	 END;
   END WriteS;

PROCEDURE WriteShort*	(f: tFile; n: SHORTINT; FieldWidth: CARDINAL);
   BEGIN					(* shortint number	*)
      WriteI (f, n, FieldWidth);
   END WriteShort;

PROCEDURE WriteLong*	(f: tFile; n: LONGINT ; FieldWidth: CARDINAL);
   BEGIN					(* longint  number	*)
      WriteI (f, n, FieldWidth);
   END WriteLong;

PROCEDURE WriteCard*	(f: tFile; n: CARDINAL; FieldWidth: CARDINAL);
   VAR						(* cardinal number	*)
      i		:LONGINT; 
      length	: CARDINAL;
      digits	: ARRAY 11 OF CHAR;
   BEGIN
      length := 0;
      REPEAT
	 INC (length);
	 digits [length] := MyCHR [n MOD 10];
	 n := n DIV 10;
      UNTIL n = 0;
      FOR i := 1 TO (FieldWidth - length) DO
	 WriteC (f, ' ');
      END;
      FOR i := (length) TO 1 BY -1 DO
	 WriteC (f, digits [i]);
      END;
   END WriteCard;

PROCEDURE WriteNl*	(f: tFile);		(* new line		*)
   BEGIN
      WriteC (f, EolCh);
   END WriteNl;


PROCEDURE CloseIO*;				(* close all files	*)
   VAR i	: tFile;
   BEGIN
      FOR i := 0 TO System.cMaxFile DO
	    IF BufferPool [i].Buffer # NIL THEN
	       IF BufferPool [i].OpenForOutput THEN
		  WriteClose (i);
	       ELSE
		  ReadClose (i);
	       END;
	    END;
      END;
   END CloseIO;

BEGIN
   MyCHR [ 0] := '0';
   MyCHR [ 1] := '1';
   MyCHR [ 2] := '2';
   MyCHR [ 3] := '3';
   MyCHR [ 4] := '4';
   MyCHR [ 5] := '5';
   MyCHR [ 6] := '6';
   MyCHR [ 7] := '7';
   MyCHR [ 8] := '8';
   MyCHR [ 9] := '9';
   MyCHR [10] := 'A';
   MyCHR [11] := 'B';
   MyCHR [12] := 'C';
   MyCHR [13] := 'D';
   MyCHR [14] := 'E';
   MyCHR [15] := 'F';

   FOR i := 0 TO System.cMaxFile DO
	 BufferPool [i].Buffer		:= NIL;
	 BufferPool [i].BufferIndex	:= 0;
	 BufferPool [i].BytesRead	:= 0;
	 BufferPool [i].OpenForOutput	:= FALSE;
	 BufferPool [i].EndOfFile	:= FALSE;
	 BufferPool [i].FlushLine	:= FALSE;
   END;

   BufferPool [StdInput ].Buffer := SYSTEM.VAL(tBuffer,Memory.Alloc (BufferSize + 1));
   BufferPool [StdOutput].Buffer := SYSTEM.VAL(tBuffer,Memory.Alloc (BufferSize + 1));
   BufferPool [StdError ].Buffer := SYSTEM.VAL(tBuffer,Memory.Alloc (BufferSize + 1));

   BufferPool [StdInput ].OpenForOutput := FALSE;
   BufferPool [StdOutput].OpenForOutput := TRUE;
   BufferPool [StdError ].OpenForOutput := TRUE;

   CheckFlushLine (StdInput );
   CheckFlushLine (StdOutput);
   CheckFlushLine (StdError );
END IO.
