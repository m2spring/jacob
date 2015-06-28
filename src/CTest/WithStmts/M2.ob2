MODULE M2;
TYPE T0* = RECORD     a:LONGINT; END; P0* = POINTER TO T0;
     T1* = RECORD(T0) b:LONGINT; END; P1* = POINTER TO T1;
     T2* = RECORD(T1) c:LONGINT; END; P2* = POINTER TO T2;
     T3* = RECORD(T2) d:LONGINT; END; P3* = POINTER TO T3;
     T4* = RECORD(T3) e:LONGINT; END; P4* = POINTER TO T4;
     T5* = RECORD(T4) f:LONGINT; END; P5* = POINTER TO T5;
     T6* = RECORD(T5) g:LONGINT; END; P6* = POINTER TO T6;
     T7* = RECORD(T6) h:LONGINT; END; P7* = POINTER TO T7;
     T8* = RECORD(T7) i:LONGINT; END; P8* = POINTER TO T8;
VAR  p0 : P0;
     p1 : P1;
     p2 : P2;
     p3 : P3;
     p4 : P4;
     p5 : P5;
     p6 : P6;
     p7 : P7;
     p8 : P8;
     i:LONGINT; 

PROCEDURE Proc(VAR r:T0);
BEGIN (* Proc *)
 IF r IS T1
    THEN i:=1; 
    ELSE i:=2; 
 END; (* IF *)
 
 WITH r:T1 DO
  IF r IS T1
     THEN 
     ELSE 
  END; (* IF *)
  r.b:=0;  
 END; (* WITH *)
END Proc;

BEGIN (* M2 *)
 p0(P0).a:=0; 
 p0(P1).b:=0; 
 p0(P2).b:=0; 
END M2.
