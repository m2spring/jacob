MODULE M3;
IMPORT S:=SYSTEM; 

TYPE T=ARRAY 17 OF CHAR; 
VAR i,j,k:LONGINT; 

PROCEDURE P1(s:ARRAY OF ARRAY OF ARRAY OF ARRAY OF ARRAY OF T);
BEGIN (* P1 *)  
 i:=S.ADR(s[i,j]); 
END P1;

BEGIN (* M3 *)
END M3.
