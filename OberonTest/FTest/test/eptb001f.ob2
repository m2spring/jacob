(* 10.2 Type-bound procedures                                                 *)
(* Globally declared procedures may be associated with a record type          *)
(* declared in the same module. The procedures are said to be bound to the    *)
(* record type.                                                               *)

MODULE eptb001f;

TYPE
   Basistyp      = RECORD
                   END;

   Ableitung1    = RECORD(Basistyp)
                   END;

   Ableitung2    = RECORD(Ableitung1)
                   END;

   PtrAbleitung2 = POINTER TO Ableitung2;

PROCEDURE (VAR r:Basistyp) Basisproc;

 PROCEDURE (VAR r:Ableitung1) NotGlobal;
(*                            ^--- Bound procedure must be global *)

 END NotGlobal;

END Basisproc;

PROCEDURE Proc1;
 PROCEDURE (p: PtrAbleitung2) Bound;
(*                            ^--- Bound procedure must be global *)

 END Bound;

END Proc1;

END eptb001f.
