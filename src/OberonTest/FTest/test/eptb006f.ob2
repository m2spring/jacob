(* 10.2 Type-bound procedures                                                 *)
(* In a forward declaration of a type-bound procedure the receiver            *)
(* parameter must be of the same type as in the actual procedure              *)
(* declaration.  The formal parameter lists of both declarations must         *)
(* match (App. A).                                                            *)

MODULE eptb006f;

TYPE
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

 PT0 = POINTER TO T0;

 PT1 = POINTER TO T1;

PROCEDURE^(VAR r: T2) P(s:SET; i:INTEGER);

PROCEDURE (VAR r: T2) P(s:SET; VAR i:INTEGER);
(*                    ^--- Actual declaration doesn't match with forward decl *)

END P;

END eptb006f.
