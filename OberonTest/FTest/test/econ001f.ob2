(* 5. Constant declarations                                                  *)
(* A constant expression is an expression that can be evaluated by a mere    *)
(* textual scan without actually executing the program. Its operands are     *)
(* constants or predeclared functions that can be evaluated at compile time. *)

MODULE econ001f;

TYPE
  T     = ARRAY OF CHAR;

VAR
  A     : INTEGER;

CONST
  N     = 3*A;
(*        ^--- Expression not constant *)
(* Pos: 15,11                          *)

  C     = CHR(N);
(*        ^--- Expression not constant *)
(* Pos: 19,11                          *)

  TSIZE = SIZE(T);
(*             ^--- Open arrays are not allowed here *)
(* Pos: 23,16                                        *)
END econ001f.
