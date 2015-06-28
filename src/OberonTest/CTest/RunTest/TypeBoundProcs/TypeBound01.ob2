MODULE TypeBound01;

IMPORT O:=Out;

TYPE BoundRecType = RECORD END;
     BoundPtrType = POINTER TO BoundRecType;

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
 r : BoundRecType;
 p : BoundPtrType;
 r0:T0;
 r1:T1;
 r2:T2;
 r3:T3;
 
PROCEDURE (VAR r:BoundRecType) BoundRecReceiver; 
BEGIN 
 O.String('Procedure: BoundRecReceiver!'); O.Ln;
END BoundRecReceiver;

PROCEDURE (p:BoundPtrType) BoundPtrReceiver; 
BEGIN 
 O.String('Procedure: BoundPtrReceiver!'); O.Ln;
END BoundPtrReceiver;



BEGIN (* TypeBound01 *)
 r.BoundRecReceiver;

 NEW(p);
 p.BoundRecReceiver;
 p.BoundPtrReceiver;
 
 r0.r.BoundRecReceiver;
 NEW(r0.p);
 r0.p.BoundPtrReceiver;
 
 r1.h.r.BoundRecReceiver;
 NEW(r1.h.p);
 r1.h.p.BoundPtrReceiver;
 
 r2[3].r.BoundRecReceiver;           
 
 r3[2,3].a[1].r.BoundRecReceiver;
 NEW(r3[1,1].e.a[1,2].p);
 r3[1,1].e.a[1,2].p.BoundPtrReceiver;
END TypeBound01.

