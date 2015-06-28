(* 8. Expressions: 8.2 Operators                                            *)
(* 8.2.2 Arithmetic operators                                               *)
(* The operators +, -, * and / apply to operands of numeric types. The type *)
(* of the result is the type of that operand which includes the type of the *)
(* other operand, except for division (/), where the result is the smallest *)
(* real type which includes both operand types.                             *)

MODULE eeao001f;

CONST
  a = 3.4 + TRUE;
(*        ^--- Operator not applicable *)
(* Pos: 11,11                          *)

  b = 2 - 3 * 5.0 / {0};
(*                ^--- Operator not applicable *)
(* Pos: 15,19                                  *)

END eeao001f.
