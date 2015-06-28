(* 8. Expressions: 8.2 Operators                                          *)
(* 8.2.2 Set Operators                                                    *)
(* Set operators apply to operands of type SET and yield a result of type *)
(* SET.                                                                   *)

MODULE eeso001f;

CONST
   a = {1,2,3,4,5,6,7,8,9};
   b = {1,3,5,7,9};
   c = {2,4,6,8};
   d = {};
   e = {1,2};

   f = a + 3;
(*       ^--- Operator not applicable - Pos: 15,10      *)

   g = + c;
(*       ^--- Invalid type of expression *)
(* Pos: 18,10                            *)

   h = {0,1,2,3,4,5,9999999};
(*                  ^--- Expression exceeds set bounds *)
(* Pos: 22,21                                          *)

END eeso001f.
