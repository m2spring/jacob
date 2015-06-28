(* Appendix A: Definition of terms: Integer-, Real-, Numeric types            *)
(* Integer types  SHORTINT, INTEGER, LONGINT                                  *)
(* Real types     REAL, LONGREAL                                              *)
(* Numeric types  integer types, real types                                   *)

(* If a designates an array, then a[e] denotes that element of a whose        *)
(* index is the current value of the expression e. The type of e must be an   *)
(* INTEGER TYPE.                                                              *)
(* The operators +, -, *, and / apply to operands of NUMERIC TYPES.           *)

MODULE eapa001f;

TYPE
   tarray = ARRAY 3 OF CHAR;

VAR
   a : tarray;
   si: SHORTINT;
   i : INTEGER;
   r : REAL;
   lr: LONGREAL;
   b : BOOLEAN;
   c : CHAR;

BEGIN
 a[r] := 0X;
(* ^--- Invalid type of expression *)
(* Pos: 26,4                       *)

 a[lr]  := 0X;
(* ^--- Invalid type of expression *)
(* Pos: 30,4                       *)

 si := b+si;
(*      ^--- Operator not applicable *)
(* Pos: 34,9                         *)

 i  := i*c;
(*      ^--- Operator not applicable *)
(* Pos: 38,9                         *)
END eapa001f.

