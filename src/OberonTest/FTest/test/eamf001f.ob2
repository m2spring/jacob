(* Appendix A: Definition of terms: Matching formal parameter lists           *)
(* Two formal parameter lists match if                                        *)
(* 1.  they have the same number of parameters, and                           *)
(* 2.  they have either the same function result type or none, and            *)
(* 3.  parameters at corresponding positions have equal types, and            *)
(* 4.  parameters at corresponding positions are both either value or         *)
(*     variable parameters.                                                   *)

(* Procedure Types: If a procedure P is assigned to a variable of type T,     *)
(* the formal parameter lists of P and T must MATCH.                          *)

MODULE eamf001f;

TYPE 
 TPROC1 = PROCEDURE(A:INTEGER; B:SET);
 TPROC2 = PROCEDURE():INTEGER;
 TPROC3 = PROCEDURE(A:SHORTINT; B:REAL);
 TPROC4 = PROCEDURE(VAR X:SET; Y:INTEGER; VAR Z:REAL);

VAR
 proc1 : TPROC1;
 proc2 : TPROC2;
 proc3 : TPROC3;
 proc4 : TPROC4;

PROCEDURE P1(x:INTEGER; y:SET; z:CHAR);
END P1;

PROCEDURE P2;
END P2;

PROCEDURE P3(x:INTEGER; y:LONGREAL);
END P3;

PROCEDURE P4(x:SET; VAR y:INTEGER; z:REAL);
END P4;

BEGIN
(* 1. *)
 proc1:=P1;
(*      ^--- Expression not assignment compatible *)
(* Pos: 40,9                                      *)

(* 2. *)
 proc2:=P2;
(*      ^--- Expression not assignment compatible *)
(* Pos: 45,9                                      *)


(* 3. *)
 proc3:=P3;
(*      ^--- Expression not assignment compatible *)
(* Pos: 51,9                                      *)


(* 4. *)
 proc4:=P4;
(*      ^--- Expression not assignment compatible *)
(* Pos: 57,9                                      *)

END eamf001f.

