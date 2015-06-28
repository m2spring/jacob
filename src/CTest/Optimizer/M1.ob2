MODULE M1;
IMPORT SYS:=SYSTEM;

TYPE T=RECORD
        f:BOOLEAN; 
       END;
VAR a,b,i:LONGINT; 
    ar:ARRAY 10 OF T; 
    r:T;
    p:POINTER TO T;

PROCEDURE (VAR r:T)P;
BEGIN (* P *)
END P;

PROCEDURE P(s,t:ARRAY OF CHAR);

 PROCEDURE Q(VAR s:ARRAY OF CHAR);
 BEGIN (* Q *)
 END Q;

BEGIN (* P *)                
(*<<<<<<<<<<<<<<<
 COPY(s,t); 
 i:=SYS.ADR(t); 
 t[i]:=0X; 
>>>>>>>>>>>>>>>*)               
 Q(t); 
END P;

PROCEDURE P1(VAR s:ARRAY OF T);
BEGIN (* P1 *)
END P1;

BEGIN (* M1 *) 
 a:=b;   
 FOR i:=1 TO 10 DO
 END; (* FOR *)
 ar[i].P;
(*<<<<<<<<<<<<<<<
 P1(ar); 
>>>>>>>>>>>>>>>*)
 r.P;  
 p.P;
END M1.
