(* 9.10 Return and exit statements                                            *)
(* A return statement indicates the termination of a procedure. It is         *)
(* denoted by the symbol RETURN, followed by an expression if the             *)
(* procedure is a function procedure.                                         *)

MODULE esrt001t;

PROCEDURE Proc;
BEGIN
 RETURN;
END Proc;

PROCEDURE Func(): INTEGER;
BEGIN
 RETURN 2000;
END Func;

END esrt001t.
