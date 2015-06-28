MODULE M3;

VAR i:LONGINT; 

PROCEDURE P;
BEGIN (* P *)
END P;

PROCEDURE F():LONGINT; 
BEGIN (* F *)          
 LOOP
  EXIT; 
  RETURN 0; 
 END; (* LOOP *)
END F;

BEGIN (* M3 *)
 P;
 i:=F(); 
END M3.
