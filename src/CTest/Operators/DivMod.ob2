MODULE DivMod;
IMPORT O:=Out;

PROCEDURE P(x,y:LONGINT);
BEGIN (* P *)	       
 O.Int(x); 
 O.String(' DIV '); 
 O.Int(y); 
 O.String(' = '); 
 O.Int(x DIV y); 
 O.String(' ; '); 
 
 O.Int(x); 
 O.String(' MOD '); 
 O.Int(y); 
 O.String(' = '); 
 O.Int(x MOD y); 
 O.Ln;
END P;

BEGIN (* DivMod *)
 P(5,3); 
 P(-5,3); 
END DivMod.
