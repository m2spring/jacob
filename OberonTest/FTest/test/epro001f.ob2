(* 10. Procedure declarations                                                 *)
(*     All constants, variables, types, and procedures                        *)
(*     declared within a procedure body are local to the procedure.           *)

MODULE epro001f;

PROCEDURE P;
CONST
 c = 10;
VAR
 a : INTEGER;
TYPE
 T = RECORD
      s:SET;
     END;
PROCEDURE I; BEGIN END I;

END P;

PROCEDURE Q;
VAR
 r : T;
(*   ^--- Identifier not declared *)

END Q;

BEGIN
  a:=c;
(*^--^--- Identifier not declared *)

  I;
(*^--- Identifier not declared *)

END epro001f.
