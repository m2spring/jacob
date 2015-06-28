(* Appendix A: Definition of terms: Type inclusion                            *)
(* Numeric types include (the values of) smaller numeric types according      *)
(* to the following hierarchy:                                                *)
(*                                                                            *)
(*      LONGREAL >= REAL >= LONGINT >= INTEGER >= SHORTINT                    *)

(* Assignment compatible                                                      *)
(* An expression e of type Te is assignment compatible with a variable v of   *)
(* type Tv if one of the following conditions hold:                           *)
(* [...]                                                                      *)
(* 2.  Te and Tv are numeric types and Tv includes Te [...]                   *)

MODULE eati001f;

VAR
 si: SHORTINT;
 i : INTEGER;
 li: LONGINT;
 r : REAL;
 lr: LONGREAL;

BEGIN
 si:=i;
(*   ^--- Expression not assignment compatible *)
(* Pos: 23,6                                   *)

 si:=li;
(*   ^--- Expression not assignment compatible *)
(* Pos: 27,6                                   *)

 si:=r;
(*   ^--- Expression not assignment compatible *)
(* Pos: 31,6                                   *)

 si:=lr;
(*   ^--- Expression not assignment compatible *)
(* Pos: 35,6                                   *)


 i:=li;
(*  ^--- Expression not assignment compatible *)
(* Pos: 40,5                                  *)

 i:=r;
(*  ^--- Expression not assignment compatible *)
(* Pos: 44,5                                  *)

 i:=lr;
(*  ^--- Expression not assignment compatible *)
(* Pos: 48,5                                  *)


 li:=r;
(*   ^--- Expression not assignment compatible *)
(* Pos: 53,6                                   *)

 li:=lr;
(*   ^--- Expression not assignment compatible *)
(* Pos: 57,6                                   *)

 r:=lr;
(*  ^--- Expression not assignment compatible *)
(* Pos: 61,5                                  *)

END eati001f.

