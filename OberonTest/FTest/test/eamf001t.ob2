(* Appendix A: Definition of terms: Matching formal parameter lists           *)
(* Two formal parameter lists match if                                        *)
(* 1.  they have the same number of parameters, and                           *)
(* 2.  they have either the same function result type or none, and            *)
(* 3.  parameters at corresponding positions have equal types, and            *)
(* 4.  parameters at corresponding positions are both either value or         *)
(*     variable parameters.                                                   *)

(* Procedure Types: If a procedure P is assigned to a variable of type T,     *)
(* the formal parameter lists of P and T must MATCH.                          *)

MODULE eamf001t;

TYPE 
 TPROC = PROCEDURE(VAR A:INTEGER; B:SET):INTEGER;

VAR
 proc : TPROC;

PROCEDURE P(VAR x: INTEGER; y:SET):INTEGER;
BEGIN
 RETURN 1;
END P;

BEGIN
 proc:=P; 
END eamf001t.
