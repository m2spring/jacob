(* 10.2 Type-bound procedures                                                 *)
(* If a procedure P is bound to a type T0, it is implicitly also bound to     *)
(* any type T1 which is an extension of T0.                                   *)
(* However, a procedure P' (with the same name as P) may be explicitly        *)
(* bound to T1 in which case it overrides the binding of P. P' is             *)
(* considered a redefinition of P for T1. The formal parameters of P and      *)
(* P' must match.                                                             *)

MODULE eptb003f;

TYPE
 T0  = RECORD
       END;

 T1  = RECORD(T0)
       END;

 T2  = RECORD(T1)
       END;

PROCEDURE (VAR r:T0) Bound;
END Bound;

PROCEDURE (VAR r:T2) Bound(I:INTEGER);
(*                   ^--- Non-matching formal parameters in redefinition *)

END Bound;


PROCEDURE (VAR r:T2) Another* (VAR s:SET):SET;
(*                   ^--- Non-matching formal parameters in redefinition *)

END Another;

PROCEDURE (VAR r:T0) Another (VAR s:SET);
END Another;

END eptb003f.
