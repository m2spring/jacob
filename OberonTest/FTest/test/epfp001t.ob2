(* 10.1 Formal parameters                                                     *)
(* A function procedure without parameters must have an empty parameter       *)
(* list.  It must be called by a function designator whose actual             *)
(* parameter list is empty too.                                               *)

MODULE epfp001t;

VAR
 i:INTEGER;

PROCEDURE P():INTEGER;
BEGIN
 RETURN 1;
END P;

BEGIN
 i:=P(); 
END epfp001t.
