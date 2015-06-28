(* 8. Expressions: 8.2 Operators                                        *)
(* 8.2.2 Arithmetic operators                                           *)
(* The operators DIV and MOD apply to integer operands only. They are   *)
(* related by the following formulas defined for any x and positive     *)
(* divisors y:    x = (x DIV y) * y + (x MOD y)    |    0<=(x MOD y) <y *)

MODULE eeao002f;

CONST
   a = 10 DIV 2.0;
(*        ^--- Operator not applicable *)
(* Pos: 10,11                          *)

   b = 20 MOD (-2);
(*        ^--- Const arithmetic error *)
(* Pos: 14,11                         *)

END eeao002f.
