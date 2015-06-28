(* 5. Constant declarations                                                  *)
(* A constant expression is an expression that can be evaluated by a mere    *)
(* textual scan without actually executing the program. Its operands are     *)
(* constants or predeclared functions that can be evaluated at compile time. *)

MODULE econ001t;

TYPE
   A      = ARRAY 3, 4 OF CHAR;

CONST
  N       = 100;
  LIMIT   = 2*N-1;
  FULLSET = {MIN(SET)..MAX(SET)};
  ASIZE   = SIZE(A);
  BIGINT  = MAX(LONGINT);
  BOOL    = ODD(LIMIT);

END econ001t.
