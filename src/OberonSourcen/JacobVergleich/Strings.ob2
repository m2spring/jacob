(* $Id: Strings.mi,v 1.3 1991/11/21 14:33:17 grosch rel $ *)

(* $Log: Strings.mi,v $
 * Revision 1.3  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.2  90/06/26  12:25:13  grosch
 * StringToArray: terminate Array with 0C
 * 
 * Revision 1.1  89/05/22  10:45:49  grosch
 * added procedure IntToString
 * 
 * Revision 1.0  88/10/04  11:47:20  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE Strings;
IMPORT General,IO;

CONST	cMaxStrLength*	= 255;

TYPE	tStringIndex*	= INTEGER;

TYPE	tString*	= RECORD
		     	     Chars*  : ARRAY cMaxStrLength+1 OF CHAR;
		     	     Length* : tStringIndex;
		  	  END;

CARDINAL=LONGINT;
LONGCARD=LONGINT;
CONST	EolCh	= 0AX;

VAR	reported: BOOLEAN;
VAR	MyCHR	: ARRAY 16 OF CHAR;

PROCEDURE Error;
   BEGIN
      IO.WriteS (IO.StdError, "string too long, max. 255");
      IO.WriteNl (IO.StdError);
   END Error;

PROCEDURE Assign*	(VAR s1, s2: tString);
   (* Zuweisung von Zeichenketten			*)
   VAR i : tStringIndex;
   BEGIN
   (* s1 := s2; *)
	 FOR i := 1 TO s2.Length DO
	    s1.Chars [i] := s2.Chars [i];
	 END;
	 s1.Length := s2.Length;
   END Assign;

PROCEDURE AssignEmpty*	(VAR s: tString);
   (* leere Zeichenkette erzeugen 			*)
   BEGIN
      s.Length := 0;
      reported := FALSE;
   END AssignEmpty;

PROCEDURE Concatenate*	(VAR s1, s2: tString);
   (* Returns in parameter 's1' the concatenation	*)
   (* of the strings 's1' and 's2'.			*)
   VAR i : tStringIndex;
   BEGIN
      IF s1.Length + s2.Length > cMaxStrLength THEN
	 Error;
      ELSE
	    FOR i := 1 TO s2.Length DO
	       s1.Chars [s1.Length+i] := s2.Chars [i];
	    END;
	    INC (s1.Length, s2.Length);
      END;
   END Concatenate;

PROCEDURE Append*	(VAR s: tString; c: CHAR);
   (* 1 Zeichen an eine Zeichenkette anhaengen 		*)
   BEGIN
      IF s.Length = cMaxStrLength THEN
	 IF ~reported THEN
	    Error;
	    reported := TRUE;
	 END;
      ELSE
	 INC (s.Length);
	 s.Chars [s.Length] := c;
      END;
   END Append;

PROCEDURE Length*	(VAR s: tString)			: CARDINAL;
   (* Laenge einer Zeichenkette 			*)
   BEGIN
      RETURN s.Length;
   END Length;

PROCEDURE IsEqual*	(VAR s1, s2: tString)			: BOOLEAN;
   (* Pruefung von 2 Zeichenketten auf Gleichheit 	*)
   VAR i: tStringIndex;
   BEGIN
      IF s1.Length # s2.Length THEN
	 RETURN FALSE;
      ELSE
	 FOR i := 1 TO s1.Length DO
	    IF s1.Chars [i] # s2.Chars [i] THEN
	       RETURN FALSE;
	    END;
	 END;
      END;
      RETURN TRUE;
   END IsEqual;

PROCEDURE Rank (ch: CHAR): CARDINAL;
   (* Abbildung aller Zeichen auf einen Rang
      gemaess ihrer lexikographischen Ordnung		*)
   BEGIN
      RETURN ORD (ch);   (* maschinenabhaengig *)
   END Rank;

PROCEDURE IsInOrder*	(VAR s1, s2: tString)			: BOOLEAN;
   (* Pruefung von 2 Zeichenketten auf lexikographische Ordnung *)
   VAR
      i           :LONGINT; 
      rank1, rank2: CARDINAL;
   BEGIN
      FOR i := 1 TO General.Min (s1.Length, s2.Length) DO
	 rank1 := Rank (s1.Chars [i]);
	 rank2 := Rank (s2.Chars [i]);
	 IF rank1 < rank2 THEN
	    RETURN TRUE;
	 ELSIF rank1 > rank2 THEN
	    RETURN FALSE;
	 END;
      END;
      RETURN s1.Length <= s2.Length;
   END IsInOrder;

PROCEDURE Exchange*	(VAR s1, s2: tString);
   (* Vertauschen von 2 Zeichenketten 			*)
   VAR temp: tString;
   BEGIN
      Assign (temp, s1  );
      Assign (s1  , s2  );
      Assign (s2  , temp);
   END Exchange;

PROCEDURE SubString*	(VAR s1: tString; from, to: tStringIndex; VAR s2: tString);
   (* Returns in 's2' the substring from 's1' com-	*)
   (* prising the characters between 'from' and 'to'.	*)
   (* PRE 1 <= from <= Length (s1)			*)
   (* PRE 1 <=  to  <= Length (s1)			*)
   VAR i: tStringIndex;
   BEGIN
	 s2.Length := 0;
	 FOR i := from TO to DO
	    INC (s2.Length);
	    s2.Chars [s2.Length] := s1.Chars [i];
      END;
   END SubString;

PROCEDURE Char*		(VAR s: tString; i: tStringIndex)	: CHAR;
   (* liefert ein Zeichen einer Zeichenkette: s [index] *)
   (* PRE 1 <= index <= Length (s) 			*)
   BEGIN
      RETURN s.Chars [i];
   END Char;

PROCEDURE ArrayToString*	(a: ARRAY OF CHAR; VAR s: tString);
   VAR i: tStringIndex;
   BEGIN
      i := 0;
      LOOP
	 IF a [i] = 0X THEN EXIT; END;
	 s.Chars [i+1] := a [i];
	 INC (i);
	 IF i > LEN(a) THEN EXIT; END;
      END;
      s.Length := i;
   END ArrayToString;

PROCEDURE StringToArray*	(VAR s: tString; VAR a: ARRAY OF CHAR);
   VAR i: tStringIndex;
   BEGIN
      FOR i := 1 TO s.Length DO
	 a [i-1] := s.Chars [i];
      END;
      a [s.Length] := 0X;
   END StringToArray;

PROCEDURE StringToInt*	(VAR s: tString)			:LONGINT; 
   (* Returns the integer value represented by 's'.	*)
   VAR
      i, start	: tStringIndex;
      n		:LONGINT; 
      negative	: BOOLEAN;
   BEGIN
      CASE s.Chars [1] OF
      | '+' : negative := FALSE; start := 2;
      | '-' : negative := TRUE ; start := 2;
      ELSE    negative := FALSE; start := 1;
      END;
      n := 0;
      FOR i := start TO s.Length DO
	 n := n * 10 + (ORD (s.Chars [i]) - ORD ('0'));
      END;
      IF negative
      THEN RETURN - n;
      ELSE RETURN   n;
      END;
   END StringToInt;

PROCEDURE StringToNumber* (VAR s: tString; Base: CARDINAL)	: CARDINAL;
   (* Returns the integer value represented by 's'	*)
   (* to the base 'Base'.				*)
   VAR
      i	: tStringIndex;
      n	: CARDINAL;
      ch: CHAR;
   BEGIN
      n := 0;
      FOR i := 1 TO s.Length DO
	 ch := s.Chars [i];
	 IF ('A' <= ch) & (ch <= 'F') THEN
	    n := n * Base + ORD (ch) - ORD ('A') + 10;
	 ELSIF ('a' <= ch) & (ch <= 'f') THEN
	    n := n * Base + ORD (ch) - ORD ('a') + 10;
	 ELSE
	    n := n * Base + ORD (ch) - ORD ('0');
	 END;
      END;
      RETURN n;
   END StringToNumber;

PROCEDURE StringToReal*	(VAR s: tString)			: REAL;
   (* Returns the real value represented by 's'.	*)
   CONST
      MaxInt		= 2147483647;	(* 2 ** 31 - 1 *)
      MaxIntDiv10	= MaxInt DIV 10;
   VAR
      n			: REAL;
      Mantissa		: LONGCARD;
      Exponent		:LONGINT; 
      MantissaNeg	: BOOLEAN;
      ExponentNeg	: BOOLEAN;
      FractionDigits	: CARDINAL;
      TruncatedDigits	: CARDINAL;
      ch		: CHAR;
      i			: tStringIndex;
   BEGIN
      MantissaNeg	:= FALSE;
      Mantissa		:= 0;
      Exponent		:= 0;
      FractionDigits	:= 0;
      TruncatedDigits	:= 0;
      i			:= 0;

      Append (s, ' ');		(* ASSERT Length (s) < cMaxStrLength	*)
      INC (i); ch := s.Chars [i];

      CASE ch OF				(* handle sign		*)
      | '+' : INC (i); ch := s.Chars [i];
      | '-' : INC (i); ch := s.Chars [i]; MantissaNeg := TRUE;
      | 'E' ,
	'e' : Mantissa := 1;
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
	 INC (i); ch := s.Chars [i];
      END;

      IF ch = '.' THEN INC (i); ch := s.Chars [i]; END;	(* decimal point	*)

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
	 INC (i); ch := s.Chars [i];
      END;

      IF ch = 'E' THEN				(* exponent		*)
	 INC (i); ch := s.Chars [i];

	 CASE ch OF
	 |  '+' : ExponentNeg := FALSE; INC (i); ch := s.Chars [i];
	 |  '-' : ExponentNeg := TRUE ; INC (i); ch := s.Chars [i];
	 ELSE     ExponentNeg := FALSE;
	 END;

	 WHILE ('0' <= ch) & (ch <= '9') DO
	    Exponent := 10 * Exponent + (ORD (ch) - ORD ('0'));
	    INC (i); ch := s.Chars [i];
	 END;

	 IF ExponentNeg THEN
	    Exponent := - Exponent;
	 END;
      END;

      DEC (Exponent, FractionDigits - TruncatedDigits);
      n := (1.0*Mantissa) * General.Exp10 (Exponent);
      IF MantissaNeg
      THEN RETURN - n;
      ELSE RETURN   n;
      END;
   END StringToReal;

PROCEDURE IntToString*	(n:LONGINT; VAR s: tString);
   (* Returns in 's' the string representation of 'n'.	*)
   VAR
      i, j	:LONGINT; 
      length	: CARDINAL;
      digits	: ARRAY 11 OF CHAR;
   BEGIN
      IF n < 0 THEN
	 s.Chars [1] := '-';
	 j := 1;
	 n := - n;
      ELSE
	 j := 0;
      END;
      length := 0;
      REPEAT
	 INC (length);
	 digits [length] := MyCHR [n MOD 10];
	 n := n DIV 10;
      UNTIL n = 0;
      FOR i := (length) TO 1 BY -1 DO
	 INC (j);
	 s.Chars [j] := digits [i];
      END;
      s.Length := SHORT(j);
   END IntToString;

PROCEDURE ReadS*		(f: IO.tFile; VAR s: tString; FieldWidth: tStringIndex);
   (* Read 'FieldWidth' characters as string 's' 	*)
   (* from file 'f'.					*)
   VAR i: tStringIndex;
   BEGIN
      FOR i := 1 TO FieldWidth DO
	 s.Chars [i] := IO.ReadC (f);
      END;
      s.Length := FieldWidth;
   END ReadS;

PROCEDURE ReadL*		(f: IO.tFile; VAR s: tString);
   (* Read rest of line as string 's' from file 'f'.	*)
   VAR
      i : tStringIndex;
      ch: CHAR;
   BEGIN
      i := 0;
      LOOP
	 ch := IO.ReadC (f);
	 IF ch = EolCh THEN EXIT; END;
	 IF i = cMaxStrLength THEN
	    REPEAT
	    UNTIL IO.ReadC (f) = EolCh;
	    EXIT;
	 END;
	 INC (i);
	 s.Chars [i] := ch;
      END;
      s.Length := i;
   END ReadL;

PROCEDURE WriteS*	(f: IO.tFile; VAR s: tString);
   (* Write string 's' to file 'f'.			*)
   VAR i: tStringIndex;
   BEGIN
      FOR i := 1 TO s.Length DO
	 IO.WriteC (f, s.Chars [i]);
      END;
   END WriteS;

PROCEDURE WriteL*	(f: IO.tFile; VAR s: tString);
   (* Write string 's' as complete line to file 'f'. 	*)
   BEGIN
      WriteS (f, s);
      IO.WriteNl (f);
   END WriteL;

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
END Strings.
