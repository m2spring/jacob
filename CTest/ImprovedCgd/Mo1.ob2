MODULE Mo1;
TYPE R=RECORD
	b:BOOLEAN; 
        bla:LONGINT; 
       END;
VAR a:LONGINT; 
    r:ARRAY 10 OF R;
    
PROCEDURE P(VAR i:LONGINT);
VAR b:LONGINT; 
BEGIN (* P *)  
END P;

PROCEDURE Q(VAR r:R);
BEGIN (* Q *)
END Q;

BEGIN (* Mo1 *)
 P(r[a].bla); 
 Q(r[a]); 
END Mo1.
