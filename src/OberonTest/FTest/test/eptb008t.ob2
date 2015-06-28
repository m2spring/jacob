(* 10.2 Type-bound procedures                                                 *)
(* If v is a designator and P is a type-bound procedure, then v.P denotes     *)
(* that procedure P which is bound to the dynamic type of v. [...] v is       *)
(* passed to P's receiver according to the parameter passing rules specified  *)
(* in 10.1 (Formal parameters)                                                *)

MODULE eptb008t;

TYPE T0 = RECORD END;
     P0 = POINTER TO T0;

VAR r:T0;
    p:P0;

PROCEDURE (VAR r:T0) BoundRecReceiver;
BEGIN (* BoundRecReceiver *)
END BoundRecReceiver;
         
PROCEDURE (p:P0) BoundPtrReceiver;
BEGIN (* BoundPtrReceiver *)
END BoundPtrReceiver;

BEGIN (* eptb008t *)

   r.BoundRecReceiver;
   p.BoundRecReceiver;
   p^.BoundRecReceiver;
 
(* r.BoundPtrReceiver --> Error: see eptb007f *)
   p.BoundPtrReceiver;
   p^.BoundPtrReceiver;
 
END eptb008t.
