MODULE M2;
TYPE T=RECORD
        f:LONGINT; 
        g:ARRAY 10 OF RECORD
                       h:LONGINT; 
                       p:POINTER TO RECORD
                                     h:LONGINT; 
                                    END;
                      END;
       END;
VAR r:T; i:LONGINT; 

PROCEDURE P(r:T);
BEGIN (* P *)                        
 INC(r.g[r.f].h); 
(*<<<<<<<<<<<<<<<
>>>>>>>>>>>>>>>*)   
 INC(r.g[r.f].p.h); 
END P;


BEGIN (* M2 *)
END M2.
