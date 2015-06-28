(* 6. Type declarations : Procedure types                                     *)
(* Variables of a procedure type T have a procedure P (or NIL) as value.      *)
(* P must not be a predeclared or type-bound, nor may it be local to another  *)
(* procedure.                                                                 *)

MODULE etpr001f;

TYPE
   tProc = PROCEDURE(VAR i: INTEGER);
   tRec  = RECORD
           END;

VAR
   p : tProc;

PROCEDURE (VAR r : tRec) bound(VAR i: INTEGER);
END bound;

PROCEDURE Outer;
 PROCEDURE Inner(i: INTEGER);
 END Inner;

BEGIN (* Outer *)
 p:=Inner;
(*  ^--- Expression not assignment compatible *)
(* Pos: 24,5                                  *)

END Outer;

BEGIN (* fe15 *)
 p:=bound;
(*  ^--- Identifier not declared *)
(* Pos: 31,5                     *)
 p:=DEC;
(*  ^--- Expression not assignment compatible *)
(* Pos: 34,5                                  *)

END etpr001f.
