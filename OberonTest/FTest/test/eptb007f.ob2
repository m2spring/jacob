(* 10.2 Type-bound procedures                                                 *)
(* If v is a designator and P is a type-bound procedure, then v.P denotes     *)
(* that procedure P which is bound to the dynamic type of v. [...] v is       *)
(* passed to P's receiver according to the parameter passing rules specified  *)
(* in 10.1 (Formal parameters)                                                *)

MODULE eptb007f;

TYPE T0 = RECORD END;
     P0 = POINTER TO T0;

VAR r:T0;
    p:P0;

PROCEDURE (p:P0) BoundPtrReceiver; BEGIN END BoundPtrReceiver;

BEGIN (* eptb007f *)

   r.BoundPtrReceiver;
(*                   ^--- Receiver parameter must be a pointer *)

(* p.BoundPtrReceiver;   --> OK see eptb008t *)
(* p^.BoundPtrReceiver;  --> OK see eptb008t *)
 
END eptb007f.

