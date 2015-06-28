(* 10.2 Type-bound procedures                                                 *)
(* If a procedure P is bound to a type T0, it is implicitly also bound to     *)
(* any type T1 which is an extension of T0.                                   *)

MODULE eptb003t;

TYPE
 T0  = RECORD
       END;                  (*  The Extension Relation *)
                             (*                         *)
 T1  = RECORD(T0)            (*          T0             *)
       END;                  (*          |              *)
                             (*     +----T1---+         *)                                      
 U1  = RECORD(T1)            (*     |         |         *)
       END;                  (*     U1        V1        *)
                             (*     |         |         *)                                      
 V1 =  RECORD(T1)            (*     U2        V2        *)
       END;                  (*     |     +---+---+     *)
                             (*     |     |   |   |     *)                                      
 U2 =  RECORD(U1)            (*     U3    W1  X1  Y1    *)
       END;                  (*     |             |     *)
                             (*     U4            Y2    *)                                      
 U3 =  RECORD(U2)            (*                   |     *)
       END;                  (*                   Y3    *)

 U4 =  RECORD(U3)
       END;

 V2 =  RECORD(V1)
       END;

 W1 =  RECORD(V2)
       END;

 X1 =  RECORD(V2)
       END;

 Y1 =  RECORD(V2)
       END;

 Y2 =  RECORD(Y1)
       END;

 Y3 =  RECORD(Y2)
       END;


PROCEDURE (VAR r:T0) BoundToT0;
END BoundToT0;

PROCEDURE (VAR r:T1) BoundToT1;
END BoundToT1;

PROCEDURE (VAR r:U2) BoundToU2;
END BoundToU2;

PROCEDURE (VAR r:V2) BoundToV2;
END BoundToV2;

PROCEDURE (VAR r:Y1) BoundToY1;
END BoundToY1;

END eptb003t.

