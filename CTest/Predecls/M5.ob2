MODULE M5;
IMPORT O:=Out; 
VAR si:SHORTINT; 

PROCEDURE P(i:LONGINT);
BEGIN (* P *)
END P;

BEGIN (* M5 *)	     
 P(ABS(si)); 
 O.Int(ABS(si)); 
END M5.
