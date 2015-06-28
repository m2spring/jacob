(* Appendix A: Definition of terms: Equal types                               *)
(* Two types Ta and Tb are equal if                                           *)
(* 1.  Ta and Tb are the same type,  or                                       *)
(* 2.  Ta and Tb are open array types with equal element types, or            *)
(* 3.  Ta and Tb are procedure types whose formal parameter lists match.      *)

(* Two formal parameter lists match if                                        *)
(* [...]                                                                      *)
(* 3.  parameters at corresponding positions have EQUAL TYPES, and            *)
(* [...]                                                                      *)

MODULE eaet001f;
IMPORT SYS:=SYSTEM;

TYPE
  T = INTEGER;

(* 1. *)
PROCEDURE^ P(VAR x:T);
PROCEDURE  P(VAR x:SHORTINT); END P;
(*         ^--- Actual declaration doesn't match with forward decl *)
(* Pos: 20,12                                                      *)

(* 2. *)
PROCEDURE^ Q(VAR a: ARRAY OF SYS.BYTE);
PROCEDURE  Q(VAR a: ARRAY OF CHAR); END Q;
(*         ^--- Actual declaration doesn't match with forward decl *)
(* Pos: 26,12                                                      *)

(* 3. *)
PROCEDURE^ R(p: PROCEDURE (VAR z: REAL));
PROCEDURE  R(q: PROCEDURE (VAR x: T)); END R;
(*         ^--- Actual declaration doesn't match with forward decl *)
(* Pos: 32,12                                                      *)

END eaet001f.

