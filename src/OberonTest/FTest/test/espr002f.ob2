(* 9.2 Procedure calls                                                        *)
(*                                                                            *)
(* There are two kinds of parameters: variable and value parameters. If a     *)
(* formal parameter is a variable parameter, the corresponding actual         *)
(* parameter must be a designator denoting a variable.                        *)
 
MODULE espr002f;
 
PROCEDURE P(VAR p:INTEGER);
BEGIN
END P;
 
BEGIN
 P(1);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 14,4                                        *)
 
END espr002f.
