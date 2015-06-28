(* 6. Type declarations : Procedure types                                     *)
(* If a procedure P is assigned to a variable of type T, the formal parameter *)
(* lists of P and T must MATCH.                                               *)
(* MATCHING formal parameter lists!                                           *)

MODULE etpr002f;

TYPE
 t1Proc = PROCEDURE;
 t2Proc = PROCEDURE(    x1: INTEGER);
 t3Proc = PROCEDURE(    x1: INTEGER): BOOLEAN;
 t4Proc = PROCEDURE(VAR x1: INTEGER; x2: CHAR);

VAR
 p1 : t1Proc;
 p2 : t2Proc;
 p3 : t3Proc;
 p4 : t4Proc;

PROCEDURE proc1(a: INTEGER);
END proc1;

PROCEDURE proc2;
END proc2;

PROCEDURE proc3(a: INTEGER; b: CHAR);
END proc3;


BEGIN (* fe16 *)
 p1 := proc1;
(*     ^--- Expression not assignment compatible *)
(* Pos: 31,8                                     *)

 p2 := proc2;
(*     ^--- Expression not assignment compatible *)
(* Pos: 35,8                                     *)

 p3 := proc1;
(*     ^--- Expression not assignment compatible *)
(* Pos: 39,8                                     *)

 p4 := proc3;
(*     ^--- Expression not assignment compatible *)
(* Pos: 43,8                                     *)

END etpr002f.
