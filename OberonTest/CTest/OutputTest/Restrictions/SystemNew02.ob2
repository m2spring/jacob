MODULE SystemNew02;
IMPORT SYSTEM;

TYPE T1 = RECORD
           bo:BOOLEAN; 
           ch:CHAR; 
           si:SHORTINT;
           in:INTEGER; 
           li:LONGINT; 
           re:REAL;
           lo:LONGREAL;
           se:SET;
          END;

     T2 = RECORD(T1)
          END;
     T3 = ARRAY 20 OF RECORD
                       i:INTEGER; 
                       e: RECORD
                           s: SET;
                           p: POINTER TO ARRAY OF CHAR;
                          END;
                       s:SET;
                      END; 
     T4 = RECORD(T2)
           f: T3;
          END;          

VAR p1:POINTER TO T1;
    p2:POINTER TO T2;
    p3:POINTER TO T3;
    p4:POINTER TO T4;

BEGIN (* SystemNew02 *)
 SYSTEM.NEW(p1,1000); 
 SYSTEM.NEW(p2,2000); 
 SYSTEM.NEW(p3,3000); 
 SYSTEM.NEW(p4,4000); 
END SystemNew02.

