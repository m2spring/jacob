(* 4. Declaration and scope rules *)
MODULE edec003f;

TYPE
   a = INTEGER;

CONST
VAR
TYPE

VAR
  I           : INTEGER;
  L           : LONGINT;
  C           : CHAR;
  e,d,c,b,a,f : REAL;
(*        ^---- Identifier already declared *)
(* Pos 15,11                                *)

TYPE
  r = RECORD
       a : INTEGER;
       x : REAL;
       a : SHORTINT;
(*     ^---- Identifier already declared *)
(* Pos 23,8                              *)
      END;

VAR
   hurga : BOOLEAN;

PROCEDURE hurga;
(*        ^---- Identifier already declared *)
(* Pos 31,11                                *)

VAR
   c : CHAR;
   l : REAL;

BEGIN
END hurga;

PROCEDURE bla;
 VAR
   l   : LONGREAL;
   bla : INTEGER;
 TYPE
   l = SHORTINT;
(* ^---- Identifier already declared *)
(* Pos 47,4                          *)

BEGIN
END bla;

END edec003f.
