(*$! oc -cmt -kt -it M4 #*)
MODULE M4;
IMPORT O:=Out;

TYPE T=ARRAY 1 OF CHAR;
VAR s:ARRAY 200 OF T; 
    a:ARRAY 10,20 OF T; 
    p:POINTER TO ARRAY OF T; 
    c:T; 
    i,j,k:LONGINT; 
    
PROCEDURE P(p:ARRAY OF T);

 PROCEDURE Q;
 BEGIN (* Q *)
  c:=p[i]; 
  p[i]:=c; 
 END Q;

BEGIN (* P *)                       
 c:=p[i]; 
 p[i]:=c; 
 p[3]:=c; 
END P;

PROCEDURE P2(p:ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P2 *)
 P(p[i,j,k]); 
END P2;

BEGIN (* M4 *)       
 NEW(p,10); 
 c:=p[i]; 
 p[i]:=c; 
 p[0]:=c; 
 p[1]:=c; 
END M4.
