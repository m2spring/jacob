MODULE M1;
IMPORT SYSTEM;

TYPE T0 = RECORD
           f:BOOLEAN; 
          END;
     T1 = RECORD(T0)
           b:BOOLEAN; 
          END;	      
VAR v0:T0; v1:T1;
	  
PROCEDURE Size(VAR a:ARRAY OF SYSTEM.BYTE);
BEGIN (* Size *)				    
END Size;

PROCEDURE P(VAR r:T0);
BEGIN (* P *)	    
 Size(r);
END P;
	  
PROCEDURE Q(s:ARRAY OF ARRAY OF CHAR);
VAR i:LONGINT; 
BEGIN (* Q *)			
 Size(s); 
 Size(s[i]); 
END Q;

BEGIN (* M1 *)
 P(v0);
 P(v1);
END M1.
