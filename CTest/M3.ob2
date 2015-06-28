(*$!oc -kt -cmt -nc -ic M3 #*)
MODULE M3;
IMPORT Out,SYSTEM;

TYPE T0 = ARRAY 7 OF CHAR;
     T1 = ARRAY OF T0;
     T2 = ARRAY OF T1;
     T3 = ARRAY OF T2;
     T4 = ARRAY OF T3;
VAR a1:ARRAY 10 OF T0;
    a2:ARRAY 10,20 OF T0;
    a3:ARRAY 10,20,30 OF T0;
    a4:ARRAY 10,20,30,40 OF T0;
    p1:POINTER TO T1;
    p2:POINTER TO T2;
    p3:POINTER TO T3;
    p4:POINTER TO T4;
    i,j,k,l:LONGINT; c:T0;
 
PROCEDURE B(VAR s:ARRAY OF SYSTEM.BYTE);
BEGIN (* B *)
 Out.Int(LEN(s)); Out.Ln;
END B;

PROCEDURE P1(p:ARRAY OF T0);
BEGIN (* P1 *)
END P1;

PROCEDURE P2(p:ARRAY OF ARRAY OF T0);
BEGIN (* P2 *)
 B(p[i]); 
END P2;

PROCEDURE P3(p:ARRAY OF ARRAY OF ARRAY OF T0);
BEGIN (* P3 *)
 B(p); 
 B(p[i]); 
 B(p[i,j]); 
END P3;

PROCEDURE P4(p:ARRAY OF ARRAY OF ARRAY OF ARRAY OF T0);
BEGIN (* P4 *)
 B(p); 
 B(p[i]); 
 B(p[i,j]); 
 B(p[i,j,k]); 
END P4;
             
BEGIN      
 NEW(p2,10,20); 
 B(p2[i]); 
 NEW(p3,3,4,5); 
 B(p3[i,j]); 
END M3.
