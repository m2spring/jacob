(* Appendix A: Definition of terms: Array compatible                          *)
(* An actual parameter a of type Ta is array compatible with a formal         *)
(* parameter f of type Tf if                                                  *)
(* 1.  Tf and Ta are the same type, or                                        *)
(* 2.  Tf is an open array, Ta is any array, and their element types are      *)
(*     array compatible, or                                                   *)
(* 3.  Tf is ARRAY OF CHAR and a is a string.                                 *)

MODULE eaar001t;

TYPE
  TA = ARRAY 5 OF INTEGER;

VAR
   a : TA;


PROCEDURE P(a:TA); END P;
PROCEDURE Q(VAR x: ARRAY OF INTEGER); END Q;
PROCEDURE R(VAR a: ARRAY OF CHAR); END R;

BEGIN
(* 1. *)
 P(a);

(* 2. *)
 Q(a);

(* 3. *)
 R('Dies ist ein String!');
END eaar001t.
