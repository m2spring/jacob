(* 9.2 Procedure calls                                                        *)
(*                                                                            *)
(* There are two kinds of parameters: variable and value parameters. If a     *)
(* formal parameter is a variable parameter, the corresponding actual         *)
(* parameter must be a designator denoting a variable.                        *)

MODULE espr002t;

VAR
   i:INTEGER;

PROCEDURE P(VAR p:INTEGER);
BEGIN
END P;

PROCEDURE Q(p:INTEGER);
BEGIN
END Q;

BEGIN
 P(i);
 Q(i);
 Q(1);
END espr002t.
