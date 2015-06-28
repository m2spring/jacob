MODULE M1;
IMPORT M2;
TYPE T=RECORD
       END;
     PT=POINTER TO T;
VAR rec:T;
    ptr:PT;
    p,q:PROCEDURE;
    a:ARRAY 20 OF PROCEDURE; 
    i:LONGINT; 
    pt:POINTER TO ARRAY 20 OF RECORD
                               x:LONGINT; 
                               p:PROCEDURE;
                              END;

PROCEDURE P;
BEGIN (* P *)
END P;

PROCEDURE (VAR r:T)P1;
BEGIN (* P1 *)
END P1;

PROCEDURE (p:PT)P2;
BEGIN (* P2 *)
END P2;

BEGIN (* M1 *)  
(*<<<<<<<<<<<<<<<
 p:=NIL; 
 p:=P; 
 q:=p; 
>>>>>>>>>>>>>>>*)
 M2.P;
 p;
 P;            
 a[i]; 
 pt[i].p;
 rec.P1;
 ptr.P2;
END M1.
