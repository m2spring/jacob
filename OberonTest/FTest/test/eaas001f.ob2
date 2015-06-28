(* Appendix A: Definition of terms: Assignment compatible                     *)
(* (An expression e of type Te is assignment compatible with a variable v     *)
(* of type Tv if one of the following conditions hold:                        *)
(*                                                                            *)
(* 1.  Te and Tv are the same type;                                           *)
(* 2.  Te and Tv are numeric types and Tv includes Te;                        *)
(* 3.  Te and Tv are record types and Te is an extension of Tv and the        *)
(*     dynamic type of v is Tv ;                                              *)
(* 4.  Te and Tv are pointer types and Te is an extension of Tv;              *)
(* 5.  Tv is a pointer or a procedure type and e is NIL;                      *)
(* 6.  Tv is ARRAY n OF CHAR, e is a string constant with m characters,       *)
(*     and m < n;                                                             *)
(* 7.  Tv is a procedure type and e is the name of a procedure whose formal   *)
(*     parameters match those of Tv.                                          *)

(* Assignments: The expression must be assignment compatible with the         *)
(* variable.                                                                  *)

MODULE eaas001f;

TYPE
 TR0 = RECORD
        f:INTEGER;
       END;
 TR1 = RECORD(TR0)
       END;

 PT0 = POINTER TO TR0;
 PT1 = POINTER TO TR1;

VAR
   r1, r2 : TR0;
   si     : SHORTINT;
   i      : INTEGER;
   p0     : PT0;
   p1     : PT1;
   proc   : PROCEDURE(VAR x:SET);
   a      : ARRAY 5 OF CHAR;

PROCEDURE Q (VAR s:SET); END Q;

PROCEDURE (VAR r:TR1) P;
VAR
   e : TR0;
BEGIN
 r:=e; 
(*  ^--- Expression not assignment compatible *)
(* Pos: 46,5                                  *)
END P;

BEGIN
 r1:=p1;
(*   ^--- Expression not assignment compatible *)
(* Pos: 52,6                                   *)

 si:=i; 
(*   ^--- Expression not assignment compatible *)
(* Pos: 56,6                                   *)

 p1:=p0;
(*   ^--- Expression not assignment compatible *)
(* Pos: 60,6                                   *)

 proc:=P; 
(*     ^--- Identifier not declared *)
(* Pos: 64,8                        *)

 a:='ZUGROSS'; 
(*  ^--- Expression not assignment compatible *)
(* Pos: 68,5                                  *)

END eaas001f.

