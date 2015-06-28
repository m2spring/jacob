(* 8. Expressions: 8.2 Operators                                        *)
(* 8.2.2 Arithmetic operators                                           *)
(* The operands DIV and MOD apply to integer operands only. They are    *)
(* related by the following formulas defined for any x and positive     *)
(* divisors y:    x = (x DIV y) * y + (x MOD y)    |    0<=(x MOD y) <y *)

MODULE eeao003t;

CONST
   a =  5 DIV 3; (* 1 *)
   b =  5 MOD 3; (* 2 *)

   c = (-5) DIV 3; (* -2 *)
   d = (-5) MOD 3; (*  1 *)
END eeao003t.
