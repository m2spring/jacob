   
(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

MODULE Strings1;
(* Contains the same types, procedures etc. as module 'Strings'.
 * This module is needed to avoid name clashes with the 'reuse' library.
*)

   TYPE String* = ARRAY 256 OF CHAR;
        SHORTCARD = LONGINT;
        CARDINAL = LONGINT;
        LONGCARD = LONGINT;

   PROCEDURE EmptyString* (VAR str: ARRAY OF CHAR);
   (* str := "" *)
   BEGIN
      str[0] := 0X;
   END EmptyString;

   PROCEDURE Assign* (VAR dst:ARRAY OF CHAR; src: ARRAY OF CHAR);
   (* assign string 'src' to string 'dst'. 'src' must be terminated by 0C *)
     VAR
       i: SHORTCARD;
       high: SHORTCARD;
   BEGIN
     (* high := max (HIGH(dst), HIGH(src)) *)
     high := LEN(dst);
     IF high >= LEN(src) THEN
       high := LEN(src);
     END;
     (* copy string, max. 0..high, stopp on 0C *)
     i := 0;
     WHILE (i <= high) & (src[i] # 0X) DO
       dst[i] := src[i];
       INC(i);
     END;
     IF i < LEN(dst) THEN
       dst[i] := 0X;
     END;
   END Assign;
   
   PROCEDURE Append* (VAR dest:ARRAY OF CHAR;  suffix: ARRAY OF CHAR);
   (* append 'suffix' to 'dest' *)
      VAR i,k,suffixhigh: SHORTCARD;
   BEGIN
      i := 0; suffixhigh := LEN(suffix);
      WHILE dest[i] # 0X DO INC(i) END;
      k := 0;
      LOOP
         IF k > suffixhigh THEN dest[i] := 0X; EXIT END;
         dest[i] := suffix[k]; INC(i);
	 IF suffix[k] = 0X THEN EXIT END;
         INC(k);
      END;
   END Append;

   PROCEDURE StrEq* (VAR x, y: ARRAY OF CHAR): BOOLEAN;
   (* x = y *)
      VAR i, xhigh, yhigh : SHORTCARD;
   BEGIN
      xhigh := LEN(x); yhigh := LEN(y);
      i := 0;
      LOOP
	 IF (i > xhigh) OR (x[i] =0X) THEN
	    RETURN (i > yhigh) OR (y[i] = 0X)
	 END;
	 IF (i > yhigh) OR (y[i] = 0X) THEN
	    RETURN (i > xhigh) OR (x[i] = 0X)
         END;
	 IF x[i] # y[i] THEN RETURN FALSE END;
	 INC(i);
      END;
   END StrEq;

PROCEDURE Length* (VAR str : ARRAY OF CHAR) : CARDINAL;
(* returns number of significant characters of str *)
VAR i, len : CARDINAL;
BEGIN
  i := 0;
  LOOP
    IF    str [i] = 0X
    THEN  len := i; EXIT       (* the 0X does not belong to the string !!!   *)
    ELSIF i = LEN(str)
    THEN  len := i + 1; EXIT   
          (* here str [HIGH (str)] # 0X, str starts with index 0 *)
    ELSE  INC (i)
    END
  END;
  RETURN len
END Length;

  PROCEDURE Insert* (substr: ARRAY OF CHAR; VAR str: ARRAY OF CHAR;
		    Inx: CARDINAL);
    VAR inx, i, l, L: CARDINAL;
  BEGIN
    inx := Inx;
    L := Length (str);
    l := Length (substr);
    IF (inx > L) OR (l = 0) THEN RETURN END;
    IF L >= LEN(str) - l THEN L := LEN(str) - l END;
    FOR i := L TO inx BY -1 DO str[i+l] := str[i] END;
    IF l >= LEN(str) - inx THEN l := LEN(str) - inx END;
    FOR i := 0 TO l - 1 DO str[inx+i] := substr[i] END;
  END Insert;

  PROCEDURE Delete* (VAR str: ARRAY OF CHAR; inx, len: CARDINAL);
    VAR i, L: CARDINAL;
  BEGIN
    IF len = 0 THEN RETURN END;
    L := Length (str);
    IF (inx > L) OR (L = 0) THEN RETURN END;
    IF inx + len >= L THEN str[inx] := 0X; RETURN END;
    FOR i := inx + len TO L - 1 DO
      str[i-len] := str[i];
    END;
    str[L-len] := 0X;
  END Delete;

  PROCEDURE pos* (substr, str: ARRAY OF CHAR): CARDINAL;
    VAR Found, i, j, NotFound: CARDINAL;
  BEGIN
    Found := 0;
    NotFound := LEN(str);
    LOOP
      (* Look for next substr[0] in str *)
      WHILE str[Found] # substr[0] DO
	IF (str[Found] = 0X) OR (Found = LEN(str)) THEN
	  RETURN NotFound;
	END;
	INC (Found);
      END;
      (* Scan substr *)
      i := Found + 1;  j := 1;
      LOOP
	IF (j >= LEN(substr)) OR (substr[j] = 0X) THEN
	  RETURN Found;
	ELSIF (i >= LEN(str)) OR (str[i] = 0X) THEN
	  RETURN NotFound;
	END;
	IF str[i] # substr[j] THEN EXIT END;
	INC (i);  INC (j);
      END;
      INC (Found);
    END;
  END pos;

  PROCEDURE Copy* (str: ARRAY OF CHAR; inx, len: CARDINAL;
		  VAR res: ARRAY OF CHAR);
    VAR i, L: CARDINAL;
  BEGIN res[0] := 0X;     (* For premature RETURNs *)
    (* Anything to copy? *)
    IF len = 0 THEN RETURN END;
    L := Length (str);
    (* Start after end of str? *)
    IF inx >= L THEN RETURN END;
    (* More than remainder of str? *)
    IF len > L - inx THEN len := L - inx END;
    (* Copy how much? *)
    IF len >= LEN(res) THEN
      len := LEN(res);
    ELSE (* len <= HIGH (res) *)
      res[len] := 0X;
    END;
    FOR i := 0 TO len - 1 DO res[i] := str[i+inx] END;
  END Copy;

  PROCEDURE Concat* (s1, s2: ARRAY OF CHAR;
		    VAR result: ARRAY OF CHAR);
    VAR i, j: CARDINAL;
  BEGIN
    (* Copy s1 to result *)
    i := 0;
    LOOP
      result[i] := s1[i];
      IF s1[i] = 0X THEN EXIT END;
      IF i = LEN(result) THEN RETURN END;
      INC (i);
      IF i >= LEN(s1) THEN EXIT END;
    END;
    (* Append s2 to result *)
    FOR j := 0 TO LEN(s2) DO
      result[i] := s2[j];
      IF s2[j] = 0X THEN RETURN END;
      INC (i);
      IF i >= LEN(result) THEN RETURN END;
    END;
    result[i] := 0X;
  END Concat;

  PROCEDURE compare* (s1, s2: ARRAY OF CHAR): INTEGER;
    VAR ix: CARDINAL;
  BEGIN
    ix := 0;
    WHILE (ix < LEN(s1)) & (ix < LEN(s2)) DO
      IF s1[ix] < s2[ix] THEN
	RETURN -1;
      ELSIF s1[ix] > s2[ix] THEN
	RETURN  1;
      ELSIF s1[ix] = 0X (* => s2[ix] = 0X *) THEN
	RETURN  0;
      END;
      INC (ix);
    END;
    IF ix < LEN(s1) THEN
      IF s1[ix] = 0X THEN RETURN 0 ELSE RETURN  1 END;
    ELSIF ix < LEN(s2) THEN
      IF s2[ix] = 0X THEN RETURN 0 ELSE RETURN -1 END;
    ELSE
      RETURN 0;
    END;
  END compare;

  PROCEDURE CAPS* (VAR str: ARRAY OF CHAR);
    (* CAP for an entire string *)
    VAR ix: CARDINAL;
  BEGIN
    FOR ix := 0 TO LEN(str) DO
      IF str[ix] = 0X THEN RETURN END;
      str[ix] := CAP (str[ix]);
    END;
  END CAPS;

BEGIN (* Strings1 *)
END Strings1.
