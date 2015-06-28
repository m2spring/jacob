(* 8. Expressions: 8.2 Operators                                              *)
(* 8.2.1 Logical operators                                                    *)

MODULE eelo001f;

CONST
   T = TRUE;
   F = FALSE;

   A = T OR 3;
(*          ^--- Invalid type of expression *)
(* Pos: 10,13                               *)

   B = F & {2};
(*         ^--- Invalid type of expression *)
(* Pos: 14,12                              *)
END eelo001f.
