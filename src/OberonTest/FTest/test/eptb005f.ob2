(* 10.2 Type-bound procedures                                                 *)
(* If r is a receiver parameter declared with type T, r.P^ denotes            *)
(* the (redefined) procedure P bound to the base type of T.                   *)

MODULE eptb005f;

TYPE
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

PROCEDURE (VAR r:T0) Bound;
BEGIN
 r.Bound^;
(*      ^--- There is no redefined procedure to call *)

END Bound;

PROCEDURE (VAR r:T2) Another;
BEGIN
 r.Another^;
(*        ^--- There is no redefined procedure to call *)

END Another;

END eptb005f.
