(* Appendix A: Definition of terms: Integer-, Real-, Numeric types            *)
(* Integer types  SHORTINT, INTEGER, LONGINT                                  *)
(* Real types     REAL, LONGREAL                                              *)
(* Numeric types  integer types, real types                                   *)

(* If a designates an array, then a[e] denotes that element of a whose        *)
(* index is the current value of the expression e. The type of e must be an   *)
(* INTEGER TYPE.                                                              *)
(* The operators +, -, *, and / apply to operands of NUMERIC TYPES.           *)

MODULE eapa001t;

TYPE
   tarray = ARRAY 3 OF CHAR;

VAR
   a : tarray;
   si: SHORTINT;
   i : INTEGER;
   li: LONGINT;
   r : REAL;
   lr: LONGREAL;

BEGIN
 a[si] := 0X;
 a[i]  := 0X;
 a[li] := 0X;

 si := si+si;
 i  := i*i;
 li := li+li;
 r  := r+r;
 lr := lr-lr;
END eapa001t.
