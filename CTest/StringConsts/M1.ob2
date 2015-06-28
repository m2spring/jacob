MODULE M1;
IMPORT O:=Out;
CONST s="";

PROCEDURE P(s:ARRAY OF CHAR);
BEGIN (* P *) 
 O.String(s); O.Ln;
END P;

BEGIN (* M1 *)
 P(s); 
 P(''); 
 P('A'); 
END M1.
