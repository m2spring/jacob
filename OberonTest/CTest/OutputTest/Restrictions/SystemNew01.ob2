MODULE SystemNew01;
IMPORT SYSTEM;

TYPE T1 = RECORD
           f:INTEGER; 
          END;	      
     T2 = RECORD
           p:POINTER TO T1;
          END;	  
VAR p1:POINTER TO T1;
    p2:POINTER TO T2;
BEGIN (* SystemNew01 *)
 SYSTEM.NEW(p1,1000); 
 SYSTEM.NEW(p2,2000); 
END SystemNew01.
