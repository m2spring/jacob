MODULE M4;
TYPE TS=POINTER TO ARRAY OF CHAR;
(*<<<<<<<<<<<<<<<
TYPE TS=PROCEDURE;
>>>>>>>>>>>>>>>*)
TYPE T0=RECORD
         f0:LONGINT; 
         f1:ARRAY 10 OF TS;
         f2:LONGINT; 
         f3:ARRAY 20 OF TS;
        END;       
     A01=ARRAY OF T0;
     A02=ARRAY OF ARRAY OF T0;
     
TYPE T1=RECORD
         f1:ARRAY 10 OF TS;
         f3:ARRAY 20 OF TS;
        END;       
     A1=ARRAY OF ARRAY OF T1;
     
TYPE T2=RECORD
         f1:TS;
         f2:LONGINT; 
        END;       
     A2=ARRAY OF T2;

VAR a01:POINTER TO A01;
(*<<<<<<<<<<<<<<<
    a02:POINTER TO A02;
    a1:POINTER TO A1;
    a2:POINTER TO A2;
>>>>>>>>>>>>>>>*)
BEGIN (* M4 *)                                     
(*<<<<<<<<<<<<<<<
 NEW(a01,10);
 NEW(a02,10,20);
 NEW(a1,5);
 NEW(a2,6);
>>>>>>>>>>>>>>>*)
END M4.
