(* 7. Variable declarations                                                   *)
(* Record and pointer variables have both a static type and a dynamic type.   *)
(* For pointers and variable parameters of record type the dynamic type may   *)
(* be an extension of their static type. The static type determines which     *)
(* fields of a record are accessible.                                         *)

MODULE evar001f;

TYPE
   T0 = RECORD
         A : SET;
        END;

   T1 = RECORD(T0)
         B: INTEGER;
        END;

PROCEDURE DoNothing(VAR R : T0);
BEGIN
 R.A := {MIN(SET)};
 R.B := 0;
(* ^--- Record field not found *)
(* Pos: 21,4                   *)
END DoNothing;

BEGIN (* fe17 *)
END evar001f.
