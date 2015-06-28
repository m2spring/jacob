(* 9.8 For statements                                                         *)
(* A for statement specifies the repeated execution of a statement            *)
(* sequence while a progression of values is assigned to an integer           *)
(* variable called the control variable of the for statement                  *)

MODULE esfo001f;

TYPE l = SET;

VAR m :l;
    r : REAL;
    i : INTEGER;
    s : SHORTINT;
BEGIN
 FOR l :=m     TO 2           DO END;
(*   ^--- Variable expected, Integer type expected                     *)
(* Pos: 15,6                                                           *)
(*                ^--- Expression not compatible with control variable *)
(* Pos: 15,19                                                          *)

 FOR r :=1.0   TO 2           DO END;
(*   ^--- Integer type expected *)
(* Pos: 21,6                    *)

 FOR i :=1     TO 2    BY 1.0 DO END;
(*                        ^--- Expression not compatible with control variable *)
(* Pos: 25,27                                                                  *)

 FOR i :=1     TO 2    BY 0   DO END;
(*                        ^--- BY expression must be non-zero *)
(* Pos: 29,27                                                 *)

 FOR s := 1000 TO 2000 BY 128 DO END;
(*        ^--- Expression not assignment compatible                            *)
(* Pos: 33,11                                                                  *)
(*                ^--- Expression not compatible with control variable         *)
(* Pos: 33,19                                                                  *)
(*                        ^--- Expression not compatible with control variable *)
(* Pos: 33,27                                                                  *)

 FOR i := 2.3  TO {0}         DO END;
(*        ^--- Expression not assignment compatible                            *)
(* Pos: 41,11                                                                  *)
(*                ^--- Expression not compatible with control variable         *)
(* Pos: 41,19                                                                  *)

 FOR i :=1     TO 2    BY r   DO END;
(*                        ^--- Expression not compatible with control variable *)
(* Pos: 47,27                  Expression not constant                         *)

END esfo001f.
