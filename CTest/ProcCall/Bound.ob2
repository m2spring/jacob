MODULE Bound;
TYPE tRec1* = RECORD f:LONGINT; END;
     tPtr1  = POINTER TO tRec1;
     tRec2* = RECORD(tRec1) END;
     tPtr2  = POINTER TO tRec2;
VAR  r1:tRec1;
     p1:tPtr1;     
     r2:tRec2;
     p2:tPtr2;     
     ap:ARRAY 20 OF RECORD
                     p:tPtr1; 
                    END;
     i:LONGINT; 
     
PROCEDURE (VAR r:tRec1)PR;
BEGIN (* PR *)
END PR;
     
PROCEDURE (r:tPtr1)PP;
BEGIN (* PP *)
END PP;

PROCEDURE (VAR r:tRec2)PR;
BEGIN (* PR *)
 r.PR^;
 r.PR;
END PR;
     
PROCEDURE (r:tPtr2)PP;
BEGIN (* PP *)
 r.PR^;
 r.PP^;

 r.PR;
 r.PP;
END PP;

PROCEDURE P2(VAR r:tRec1);

 PROCEDURE Q;
 BEGIN (* Q *)
  r.PR;
 END Q;

BEGIN (* P2 *)
 r.PR;
END P2;

BEGIN (* Bound *)

(*<<<<<<<<<<<<<<<
 P2(r1); 
 P2(r1);
 P2(r2);
 ap[i].p.PR;
 ap[i].p.PP;
 p1.PR;
 p1.PP;   
>>>>>>>>>>>>>>>*)
 P2(r1);
 P2(r2);
 r1.PR;   
END Bound.
