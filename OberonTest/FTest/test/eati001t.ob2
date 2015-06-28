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

MODULE eati001t;

VAR
 si: SHORTINT;
 i : INTEGER;
 li: LONGINT;
 r : REAL;
 lr: LONGREAL;

BEGIN
 lr:=r;
 lr:=li;
 lr:=i;
 lr:=si;

 r:=li;
 r:=i;
 r:=si;

 li:=i;
 li:=si;

 i:=si;
END eati001t.
