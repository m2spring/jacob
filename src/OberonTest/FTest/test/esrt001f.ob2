(* 9.10 Return and exit statements                                            *)
(* A return statement indicates the termination of a procedure. It is         *)
(* denoted by the symbol RETURN, followed by an expression if the             *)
(* procedure is a function procedure.                                         *)

MODULE esrt001f;

PROCEDURE Proc;
VAR
 i: INTEGER;
BEGIN
 RETURN i;
(*      ^--- Misplaced RETURN expression *)

END Proc;

PROCEDURE Func1(): INTEGER;
BEGIN
 RETURN;
(*--- Missing RETURN expression *)

END Func1;

END esrt001f.
