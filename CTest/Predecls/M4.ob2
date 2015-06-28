MODULE M4;
IMPORT O:=Out; 
VAR a:ARRAY 10,20,30 OF CHAR; 
    i:LONGINT; 

PROCEDURE F():LONGINT; 
BEGIN (* F *)	       
 O.String('F'); O.Ln;
 RETURN 1; 
END F;

BEGIN (* M4 *) 
 i:=LEN(a[F()]); 
END M4.
