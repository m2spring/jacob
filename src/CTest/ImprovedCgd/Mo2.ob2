MODULE Mo2;
IMPORT O:=Out; 
VAR a,b:SHORTINT; 

PROCEDURE P(i:LONGINT);
VAR d:LONGINT; 
BEGIN (* P *)	     
 O.Int(i DIV 2); d:=2; O.Str(' '); O.Int(i DIV d); O.Ln;
 O.Int(i DIV 3); d:=3; O.Str(' '); O.Int(i DIV d); O.Ln;
END P;

BEGIN (* Mo2 *)  
 P(3); 
 P(2); 
 P(1); 
 P(0); 
 P(-1); 
 P(-2); 
 P(-3); 
END Mo2.
