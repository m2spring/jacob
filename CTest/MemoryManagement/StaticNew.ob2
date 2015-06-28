MODULE StaticNew;

TYPE Te*= RECORD
          END;       
     Tr*= RECORD(Te)
           a:ARRAY 13 OF CHAR; 
          END;
VAR pe:POINTER TO Te;
    pr:POINTER TO Tr;
    pa:POINTER TO ARRAY 100 OF CHAR; 
    po:POINTER TO ARRAY OF CHAR; 
    
PROCEDURE (VAR r:Te)P;
BEGIN (* P *)
END P;

PROCEDURE (VAR r:Tr)P;
BEGIN (* P *)
END P;

PROCEDURE Alloc*;
BEGIN (* Alloc *)
 NEW(pe);         
 NEW(pr);         
 NEW(pa); 
END Alloc;

END StaticNew.
