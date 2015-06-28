(* 9.7 Repeat statements                                                      *)
(* A repeat statement specifies the repeated execution of a statement         *)
(* sequence until a condition specified by a Boolean expression is satisfied. *)

MODULE esre001t;

VAR
   b: BOOLEAN;

BEGIN
 REPEAT
 UNTIL b;

 REPEAT
 UNTIL FALSE;

 REPEAT
 UNTIL 1<2;

END esre001t.
