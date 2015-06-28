(* Appendix A: Definition of terms: Equal types                               *)
(* Two types Ta and Tb are equal if                                           *)
(* 1.  Ta and Tb are the same type,  or                                       *)
(* 2.  Ta and Tb are open array types with equal element types, or            *)
(* 3.  Ta and Tb are procedure types whose formal parameter lists match.      *)

(* Two formal parameter lists match if                                        *)
(* [...]                                                                      *)
(* 3.  parameters at corresponding positions have EQUAL TYPES, and            *)
(* [...]                                                                      *)

MODULE eaet001t;

TYPE
  T = INTEGER;

(* 1. *)
PROCEDURE^ P(VAR x:T);
PROCEDURE  P(VAR x:T); END P;

(* 2. *)
PROCEDURE^ Q(VAR a: ARRAY OF CHAR);
PROCEDURE  Q(VAR a: ARRAY OF CHAR); END Q;

(* 3. *)
PROCEDURE^ R(p: PROCEDURE (VAR z: T));
PROCEDURE  R(q: PROCEDURE (VAR x: T)); END R;
END eaet001t.
