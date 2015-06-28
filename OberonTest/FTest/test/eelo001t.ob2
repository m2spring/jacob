(* 8. Expressions: 8.2 Operators                                         *)
(* 8.2.1 Logical operators                                               *)
(* These operators apply to BOOLEAN operands and yield a BOOLEAN result. *)

MODULE eelo001t;

CONST
  T = TRUE;
  F = FALSE;

  A = T OR F; (* TRUE  *)
  B = F OR T; (* TRUE  *)

  C = T & T;  (* TRUE  *)
  D = F & T;  (* FALSE *)

  E = ~C;     (* FALSE *)
  G = ~D;     (* TRUE  *)
END eelo001t.
