(* Appendix A: Definition of terms: Array compatible                          *)
(* An actual parameter a of type Ta is array compatible with a formal         *)
(* parameter f of type Tf if                                                  *)
(* 1.  Tf and Ta are the same type, or                                        *)
(* 2.  Tf is an open array, Ta is any array, and their element types are      *)
(*     array compatible, or                                                   *)
(* 3.  Tf is ARRAY OF CHAR and a is a string.                                 *)

MODULE eaar001f;

TYPE
  TA = ARRAY 5 OF INTEGER;

VAR
   a : ARRAY 5 OF INTEGER;
   b : ARRAY 1,2 OF CHAR;

PROCEDURE P(a:TA); END P;
PROCEDURE Q(VAR x: ARRAY OF ARRAY OF INTEGER); END Q;

BEGIN
 P(a);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 22,4                                        *)

 Q(b);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 26,4                                        *)

END eaar001f.
