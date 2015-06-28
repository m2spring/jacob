MODULE M1;

TYPE T*=RECORD f:ARRAY 10 OF CHAR; END;
VAR t*:T;
VAR i*:INTEGER; 

PROCEDURE P*;
VAR v:INTEGER; 

 PROCEDURE Q;
 VAR w:INTEGER; 
 BEGIN (* Q *)  
  v:=1; 
 END Q;

BEGIN (* P *)  
 v:=2; 
END P;

PROCEDURE P2(VAR i:INTEGER);
BEGIN (* P2 *)            
 i:=3; 
END P2;

PROCEDURE P3(r:T);
BEGIN (* P3 *)  
 r:=t; 
END P3;

BEGIN (* M1 *)
 i:=3; 
END M1.
