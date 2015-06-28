(* 10.2 Type-bound procedures                                                 *)
(* In a forward declaration of a type-bound procedure the receiver            *)
(* parameter must be of the same type as in the actual procedure              *)
(* declaration.  The formal parameter lists of both declarations must         *)
(* match (App. A).                                                            *)

MODULE eptb007t;

TYPE
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

 PT0 = POINTER TO T0;

 PTX = PT0;

PROCEDURE^ (p:PT0) Bound():PTX;

PROCEDURE (q:PTX) Bound():PT0;
END Bound;

PROCEDURE^(VAR r: T2) P*(s:SET; VAR i:INTEGER);

PROCEDURE (VAR r: T2) P(s:SET; VAR i:INTEGER);
END P;

END eptb007t.

