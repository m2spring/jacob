MODULE Main;

IMPORT SYSTEM;

VAR p1:POINTER TO ARRAY OF CHAR;
    i :INTEGER; 
    p2:POINTER TO ARRAY OF CHAR;

TYPE 
   P  = POINTER TO ARRAY OF CHAR;

   r1 = RECORD
        END;
   r2 = RECORD
         f:BOOLEAN; 
        END;
   r3 = RECORD
         f:P;
        END;
   r4 = RECORD
         h:BOOLEAN; 
         f:P;
        END;
   r5 = RECORD
         g:BOOLEAN; 
(*<<<<<<<<<<<<<<<
         f:P;
         h:P;
>>>>>>>>>>>>>>>*)
         i:r3; 
         j:ARRAY 10 OF r3;
        END;  
   a1 = ARRAY 4 OF r5;     
(*<<<<<<<<<<<<<<<
   bo = BOOLEAN; 
   ch = CHAR; 
   si = SHORTINT; 
   in = INTEGER; 
   li = LONGINT; 
   re = REAL;
   lr = LONGREAL;
   se = SET;  
   by = SYSTEM.BYTE;
   pt = SYSTEM.PTR;
   p1 = POINTER TO ARRAY OF CHAR;
   r1 = RECORD f:p1; END;
   a1 = ARRAY 10 OF p1;
   a2 = ARRAY 10 OF r1;
   a3 = ARRAY 10 OF RECORD f1:SHORTINT; f2:p1; END;
   a4 = ARRAY 10 OF a1;
>>>>>>>>>>>>>>>*)

PROCEDURE Proc;
VAR p1:POINTER TO ARRAY OF CHAR;
    i :INTEGER; 
    p2:POINTER TO ARRAY OF CHAR;
BEGIN (* Proc *)
END Proc;

BEGIN (* Main *)
END Main.
