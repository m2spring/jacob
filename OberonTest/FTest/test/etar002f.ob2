(* 6. Type declarations : Array types                                         *)
(* Arrays declared without length are called open arrays. They are restricted *)
(* to pointer base types, element types of open array types, and formal       *)
(* parameter types.                                                           *)
 
MODULE etar002f;
 
TYPE
 T1 = ARRAY OF CHAR;
 
VAR
 v1:T1;
(*  ^--- Open arrays are not allowed here *)
(*  Pos: 12,5                             *)
 
 v2:ARRAY 3 OF ARRAY OF CHAR;
(*                   ^--- Missing array length *)
(* Pos: 16,22                                  *)
 
 
PROCEDURE P(VAR a:ARRAY OF CHAR):T1;
(*                               ^--- Open arrays are not allowed here *)
(* Pos: 21,34                    ^--- Illegal type of function result  *)
 
BEGIN
 RETURN a;
(*      ^--- RETURN expression not compatible with formal result type *)
(* Pos: 26,9                                                          *)
 
END P;
 
END etar002f.
