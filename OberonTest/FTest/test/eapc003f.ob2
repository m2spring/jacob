(* Appendix C: The module SYSTEM                                              *)
(* Another type exported by module SYSTEM is the type PTR. Variables of       *)
(* any pointer type may be assigned to variables of type PTR.                 *)

MODULE eapc003f;
IMPORT SYS:=SYSTEM;

VAR
  P  : SYS.PTR;
  c  : CHAR;
  si : SHORTINT;
  i  : INTEGER;
  r  : REAL;
  lr : LONGREAL;

BEGIN
 P:=c;
(*  ^--- Expression not assignment compatible *)
(* Pos: 17,5                                  *)

 P:=si;
(*  ^--- Expression not assignment compatible *)
(* Pos: 21,5                                  *)

 P:=i;
(*  ^--- Expression not assignment compatible *)
(* Pos: 25,5                                  *)

 P:=r;
(*  ^--- Expression not assignment compatible *)
(* Pos: 29,5                                  *)

 P:=lr;
(*  ^--- Expression not assignment compatible *)
(* Pos: 33,5                                  *)

END eapc003f.

