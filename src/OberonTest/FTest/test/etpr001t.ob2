(* 6. Type declarations : Procedure types                                     *)
(* Variables of a procedure type T have a procedure (or NIL) as value.        *)
(* If a procedure P is assigned to a variable of type T, the formal parameter *)
(* lists of P and T must MATCH.                                               *)

MODULE etpr001t;

TYPE
   tResultType = SHORTINT;
   tProc1 = PROCEDURE (VAR x : INTEGER; y: CHAR): SHORTINT;
   tProc2 = PROCEDURE (x : tProc1; VAR y : BOOLEAN);

VAR
   p1 : tProc1;
   p2 : tProc2;
   b  : BOOLEAN;

PROCEDURE proc1 (VAR a: INTEGER; b: CHAR): tResultType;
BEGIN
 RETURN 3;
END proc1;

PROCEDURE proc2 (p : tProc1; VAR l: BOOLEAN);
END proc2;

BEGIN (* te10 *)
 b  := TRUE;
 p1 := proc1;
 p2 := proc2;
 p2(p1,b);
END etpr001t.
