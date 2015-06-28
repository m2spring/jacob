MODULE M1;
TYPE T1 = POINTER TO RECORD
                      f:INTEGER; 
                     END;	 
     T2 = RECORD
           h:INTEGER; 
          END;	      
     T3 = INTEGER;  
     T4 = T2;	  
VAR v1:POINTER TO T2;
    v2:POINTER TO T2;
VAR v:POINTER TO ARRAY OF RECORD
                           f:POINTER TO ARRAY OF POINTER TO RECORD
                                                             g:INTEGER; 
                                                            END;
                          END;
PROCEDURE Proc(ptr:POINTER TO RECORD END);
VAR loc:POINTER TO ARRAY OF CHAR;
BEGIN (* Proc *)
END Proc;

BEGIN (* M1 *)
END M1.
