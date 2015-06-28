(*$! oc -it -kt -cmt -ic -nc M1 -ctei #*)
MODULE M1;

TYPE T=CHAR;

VAR a1:ARRAY 10 OF T; 
    a2:ARRAY 10,20 OF T; 
    a3:ARRAY 10,20,30 OF T; 
    a4:ARRAY 10,20,30,40 OF T; 
    p1:POINTER TO ARRAY OF T; 
    p2:POINTER TO ARRAY OF ARRAY OF T; 
    p3:POINTER TO ARRAY OF ARRAY OF ARRAY OF T; 
    p4:POINTER TO ARRAY OF ARRAY OF ARRAY OF ARRAY OF T; 
    i,j,k:LONGINT; 

PROCEDURE P1(p:ARRAY OF T);
BEGIN (* P1 *)
 P1(p); 
END P1;

PROCEDURE P2(p:ARRAY OF ARRAY OF T);
BEGIN (* P2 *)                        
 P2(p); 
 P1(p[i]); 
END P2;

PROCEDURE P3(p:ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P3 *)
 P3(p); 
 P2(p[i]); 
 P1(p[i,j]); 
END P3;

BEGIN (* M1 *)
 P1(a1); 
 P1(a2[i]); 
 P1(a3[i,j]); 
 P1(a4[i,j,k]); 

 P2(a2); 
 P2(a3[i]); 
 P2(a4[i,j]); 
 
 P3(a3); 
 P3(a4[i]); 
 
 P1(p1^); 
 P1(p2[i]); 
 P1(p3[i,j]); 
 P1(p4[i,j,k]); 
 
 P2(p2^); 
 P2(p3[i]); 
 P2(p4[i,j]); 
 
 P3(p3^); 
 P3(p4[i]); 

END M1.
