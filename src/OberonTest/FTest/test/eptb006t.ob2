(* 10.2 Type-bound procedures                                                 *)
(* If r is a receiver parameter declared with type T, r.P^ denotes            *)
(* the (redefined) procedure P bound to the base type of T.                   *)

MODULE eptb006t;

TYPE
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

PROCEDURE (VAR r:T0) Bound;
END Bound;

PROCEDURE (VAR r:T2) Bound;
BEGIN
 r.Bound^;
END Bound;

PROCEDURE (VAR r:T2) Another;
BEGIN 
 r.Bound;
 r.Bound^;
END Another;


PROCEDURE (VAR r:T0) P0;
END P0;

PROCEDURE (VAR r:T2) P2;
BEGIN
 r.P0^;
END P2;

END eptb006t.
