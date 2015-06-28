(* 8. Expressions: 8.2 Operators                                            *)
(* 8.2.2 Arithmetic operators                                               *)
(* The operators +, -, * and / apply to operands of numeric types. The type *)
(* of the result is the type of that operand which includes the type of the *)
(* other operand, except for division (/), where the result is the smallest *)
(* real type which includes both operand types.                             *)

MODULE eeao001t;

VAR
   a, d    : SHORTINT;
   b       : INTEGER;
   c, e, g : REAL;
   f, h    : LONGREAL;

BEGIN
   a := 12 + 10;     (* SHORTINT *)
   b := 128 - 120;   (* INTEGER  *)
   c := 20 + 3.0;    (* REAL     *)
   d := 2 * 5;       (* SHORTINT *)
   e := 2 * 5.0;     (* REAL     *)
   f := 2 * 0.5D+1;  (* LONGREAL *)
   g := 10 / 2;      (* REAL     *)
   h := 10.0D-0 / 2; (* LONGREAL *)

END eeao001t.
