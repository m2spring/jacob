(* Appendix C: The module SYSTEM                                              *)
(* Module SYSTEM exports a type BYTE with the following characteristics:      *)
(* Variables of type CHAR or SHORTINT can be assigned to variables of type    *)
(* BYTE.                                                                      *)

MODULE eapc001f;
IMPORT SYS:=SYSTEM;

VAR
  c  : CHAR;
  si : SHORTINT;
  b  : SYS.BYTE;
  i  : INTEGER;
  r  : REAL;
  lr : LONGREAL;

PROCEDURE P(b:SYS.BYTE); END P;

BEGIN
  b:=i; 
(*   ^--- Expression not assignment compatible *)
(* Pos: 20,6                                   *)

  b:=r; 
(*   ^--- Expression not assignment compatible *)
(* Pos: 24,6                                   *)

  b:=lr; 
(*   ^--- Expression not assignment compatible *)
(* Pos: 28,6                                   *)

END eapc001f.

