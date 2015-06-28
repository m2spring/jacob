(* 10.1 Formal parameters                                                     *)
(* A function procedure without parameters must have an empty parameter       *)
(* list.  It must be called by a function designator whose actual             *)
(* parameter list is empty too.                                               *)

MODULE epfp001f;

VAR
 i:INTEGER;

PROCEDURE P:INTEGER;
(*         ^--- Expected: ; ( *)

BEGIN
END P;
(*   ^--- Expected: . *)

END epfp001f.
