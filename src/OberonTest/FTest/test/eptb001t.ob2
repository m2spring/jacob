(* 10.2 Type-bound procedures                                                 *)
(* Globally declared procedures may be associated with a record type          *)
(* declared in the same module. The procedures are said to be bound to the    *)
(* record type.                                                               *)

MODULE eptb001t;

TYPE
   Basistyp      = RECORD
                   END;

   Ableitung1    = RECORD(Basistyp)
                   END;

   Ableitung2    = RECORD(Ableitung1)
                   END;

   PtrBasistyp   = POINTER TO Basistyp;

   PtrAbleitung1 = POINTER TO Ableitung1;

   PtrAbleitung2 = POINTER TO Ableitung2;


PROCEDURE (VAR r:Basistyp) Basisproc; BEGIN END Basisproc;

PROCEDURE (VAR r:Ableitung1) BoundTo1proc; BEGIN END BoundTo1proc;

PROCEDURE (VAR r:Ableitung2) BoundTo2proc; BEGIN END BoundTo2proc;

PROCEDURE (p:PtrAbleitung2) TestPreRedef; BEGIN END TestPreRedef;

PROCEDURE (p:PtrAbleitung1) TestPreRedef; BEGIN END TestPreRedef;

PROCEDURE (p:PtrBasistyp) TestPreRedef; BEGIN END TestPreRedef;

END eptb001t.

