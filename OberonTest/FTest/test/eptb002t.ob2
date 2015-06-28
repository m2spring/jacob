(* 10.2 Type-bound procedures                                                 *)
(* The binding is expressed by the type of the receiver in the heading of a   *)
(* procedure declaration.  The receiver may be either a variable parameter    *)
(* of record type T or a value parameter of type POINTER TO T (where T is a   *)
(* record type).                                                              *)

MODULE eptb002t;

TYPE 
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

 PT0 = POINTER TO T0;

 PT1 = POINTER TO T1;

 PROCEDURE (VAR r:T0) Bound0;
 END Bound0;

 PROCEDURE (p:PT0) Bound1;
 END Bound1;

 PROCEDURE (VAR r:T2) Bound2;
 END Bound2;

 PROCEDURE (p:PT1) Bound3;
 END Bound3;

END eptb002t.

