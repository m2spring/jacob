(* 10.2 Type-bound procedures                                                 *)
(* If v is a designator and P is a type-bound procedure, then v.P denotes     *)
(* that procedure P which is bound to the dynamic type of v. [...] v is       *)
(* passed to P's receiver according to the parameter passing rules specified  *)
(* in 10.1 (Formal parameters)                                                *)

MODULE eptb009t;

TYPE BoundRecType = RECORD END;
     BoundPtrType = POINTER TO T0;

     T0 = RECORD
           i:INTEGER; 
           r:BoundRecType;
           p:BoundPtrType;
          END;

     T1 = RECORD
           h:RECORD
              r:BoundRecType;
              p:BoundPtrType;
             END;
           s:SET;
          END;
          
     T2 = ARRAY 12 OF T0;

     T3 = ARRAY 10, 5  OF RECORD
                           a:ARRAY 2 OF T0;
                           e:RECORD
                              a:ARRAY 2,3 OF T0; 
                             END;
                          END;
VAR 
 r0:T0;
 r1:T1;
 r2:T2;
 r3:T3;
 
PROCEDURE (VAR r:BoundRecType) BoundRecReceiver; BEGIN END BoundRecReceiver;
PROCEDURE (    p:BoundPtrType) BoundPtrReceiver; BEGIN END BoundPtrReceiver;



BEGIN (* eptb009t *)
 r0.r.BoundRecReceiver;
 r0.p.BoundPtrReceiver;
 
 r1.h.r.BoundRecReceiver;
 r1.h.p.BoundPtrReceiver;
 
 r2[3].r.BoundRecReceiver;           
 
 r3[2,3].a[1].r.BoundRecReceiver;
 r3[1,1].e.a[1,2].p.BoundPtrReceiver;
END eptb009t.

