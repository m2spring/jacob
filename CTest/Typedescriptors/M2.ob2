MODULE M2;

TYPE T1* = RECORD     f:INTEGER; END;                
     T2* = RECORD(T1)            END;
     T3* = RECORD(T2)            END;
     T4* = RECORD(T3)            END;
     T5* = RECORD(T4)            END;
     T6* = RECORD(T5)            END;
     T7* = RECORD(T6)            END;
     T8* = RECORD(T7)            END;

     A1 = ARRAY OF INTEGER;
VAR v1:POINTER TO RECORD
                   h:INTEGER; 
                  END;          

BEGIN (* M2 *)
END M2.
