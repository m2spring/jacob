(* 10.2 Type-bound procedures                                                 *)
(* The binding is expressed by the type of the receiver in the heading of a   *)
(* procedure declaration.  The receiver may be either a variable parameter    *)
(* of record type T or a value parameter of type POINTER TO T (where T is a   *)
(* record type).                                                              *)

MODULE eptb002f;

TYPE
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

 PT1 = POINTER TO T1;

VAR
 p: PT1;

PROCEDURE (r:T0) Bound1;
(*           ^--- Invalid type *)

END Bound1;

PROCEDURE (VAR r: INTEGER) Bound2;
(*                ^--- Invalid type *)

END Bound2;


END eptb002f.
