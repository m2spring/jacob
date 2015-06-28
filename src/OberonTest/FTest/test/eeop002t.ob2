(* 8. Expressions: 8.1 Operands                                               *)
(* A type guard v(T) asserts that the dynamic type of v is T (or an           *)
(* extension of T)                                                            *)

MODULE eeop002t;

TYPE
   T0 = RECORD
         A : SET;
        END;

   T1 = RECORD(T0)
         B: INTEGER;
        END;

PROCEDURE DoNothing(VAR R : T0);
BEGIN
 R.A     := {MIN(SET)};
 R(T1).B := 0;
END DoNothing;

BEGIN (* te13 *)
END eeop002t.
