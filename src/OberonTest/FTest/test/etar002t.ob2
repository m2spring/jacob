(* 6. Type declarations : Array types                                         *)
(* Arrays declared without length are called open arrays. They are restricted *)
(* to pointer base types, element types of open array types, and formal       *)
(* parameter types.                                                           *)

MODULE etar002t;

TYPE
 T1 = ARRAY OF CHAR;
 T2 = ARRAY OF ARRAY OF SET;
 T3 = ARRAY OF T2;
 T4 = T3;
 T5 = POINTER TO ARRAY OF CHAR;
 T6 = PROCEDURE(P1: ARRAY OF CHAR; VAR P2: T2);

END etar002t.
