(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

MODULE NumConv;
IMPORT Strings1;

  CONST
    MaxBase* = 16;

  TYPE
    tBase* = SHORTINT;
    CARDINAL = LONGINT; 
    LONGCARD = LONGINT; 

  VAR
    DigitChar: ARRAY MaxBase+1 OF CHAR;  (* = "0123456789ABCDEF" *)


  PROCEDURE Str2Num*(VAR num: LONGCARD; base: tBase;
		    str: ARRAY OF CHAR;
		    VAR done: BOOLEAN);
    (* Convert 'str' to 'num' using 'base' *)
    VAR
      i: CARDINAL;
      digit: CARDINAL;
      ch: CHAR;
  BEGIN
    i	:= 0;
    num := 0;
    LOOP
      IF i < LEN(str) THEN ch := CAP(str[i])
			ELSE ch := 0X  (* fake an ASCIIZ string *)
      END;
      IF ("0" <= ch) & (ch <= "9") THEN
	digit := ORD(ch) - ORD("0")
      ELSIF ("A" <= ch) & (ch <= "F") THEN
	digit := ORD(ch) - ORD("A") + 10
      ELSE
        EXIT
      END;
      INC(i);

      IF (digit < base) & (num <= (MAX(LONGCARD) - digit) DIV base) THEN
        num := num * base + digit;
      ELSE  (* error: bad digit or overflow *)
        (* ch # 0X *)
        EXIT
      END;
    END;

    done := ch = 0X;
  END Str2Num;


  PROCEDURE Num2Str*(num: LONGCARD; base: tBase;
	            VAR str: ARRAY OF CHAR;
		    VAR done: BOOLEAN);
    (* Convert 'num' to 'str' using 'base' *)
    VAR i,j: CARDINAL;
  BEGIN
    done := TRUE;
    i := LEN(str);
    REPEAT  (* str[i..HIGH(str)] contains conversion result *)
      IF i <= 0 THEN  (* error: num does not fit into str *)
        done := FALSE;
        RETURN
      END;
      DEC(i);
      str[i] := DigitChar[num MOD base];
      num := num DIV base;
    UNTIL num = 0;

    (* copy conversion result from str[i..HIGH(str)] to str[0..] *)
    j := 0;
    WHILE i < LEN(str) DO
      str[j] := str[i];
      INC(i);
      INC(j)
    END;
    IF j < LEN(str) THEN  (* make ASCIIZ *)
      str[j] := 0X
    END
  END Num2Str;


  PROCEDURE AdjustWidth*(VAR str: ARRAY OF CHAR; width:LONGINT; filler: CHAR);
    (* make str at least abs(width) chars long
       width >= 0: insert filler chars to the left if necessary
       width < 0 : append filler chars if necessary 
     *)
    VAR
      LeftJustified: BOOLEAN;
      i, delta:LONGINT; 
      len, wid: CARDINAL;
  BEGIN
    LeftJustified := width < 0;
    wid := ABS(width);
    len := Strings1.Length(str);
    IF ~((len <= wid) & (wid < LEN(str))) THEN RETURN END;

    IF LeftJustified THEN
      FOR i := (len) TO (wid)-1 DO
        str[i] := filler
      END
    ELSE
      delta := wid - len;
      FOR i := (len)-1 TO 0 BY -1 DO
        str[i+delta] := str[i]
      END;
      FOR i := delta -1 TO 0 BY -1 DO
        str[i] := filler;
      END
    END;

    IF wid < LEN(str) THEN  (* make ASCIIZ *)
      str[wid] := 0X
    END
  END AdjustWidth;


BEGIN
  DigitChar := "0123456789ABCDEF";
END NumConv.
