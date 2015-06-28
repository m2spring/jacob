MODULE M2;
IMPORT O:=Out;
TYPE T=ARRAY 7 OF CHAR;
VAR a1:ARRAY 4 OF T; 
    a2:ARRAY 5,6 OF T; 
    a3:ARRAY 7,8,9 OF T; 
    a4:ARRAY 10,11,12,13 OF T; 

PROCEDURE P1(a:ARRAY OF T);
BEGIN (* P1 *)
 O.Str('LEN(P1.a)='); O.Int(LEN(a)); O.Ln;
END P1;

PROCEDURE P(a:ARRAY OF ARRAY OF T);
BEGIN (* P *) 
 O.Int(LEN(a,0)); O.Char(' '); 
 O.Int(LEN(a,1)); O.Ln;
END P;

PROCEDURE Q(a:ARRAY OF ARRAY OF ARRAY OF T);
VAR i,j:LONGINT; 
BEGIN (* Q *)
 i:=5; j:=6; 
 P(a[i]); 
 P1(a[i,j]);
END Q;

BEGIN (* M2 *)                   
 P(a2); 
 Q(a3); 
END M2.
