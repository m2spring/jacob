(* 10.2 Type-bound procedures                                                 *)
(* [ If a procedure P is bound to a type T0, it is implicitly also bound to   *)
(* any type T1 which is an extension of T0.                                   *)
(* However, a procedure P' (with the same name as P) may be explicitly        *)
(* bound to T1 in which case it overrides the binding of P. P' is             *)
(* considered a redefinition of P for T1. The formal parameters of P and      *)
(* P' must match. ]                                                           *)
(* If P and T1 are exported P' must be exported too.                          *)

MODULE eptb005t;

TYPE
 T0   = RECORD
        END;

 T1*  = RECORD(T0)
        END;

PROCEDURE (VAR r:T0) Bound*;
END Bound;

PROCEDURE (VAR r:T1) Bound*;
END Bound;

END eptb005t.
