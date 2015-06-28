MODULE M7;
IMPORT O:=Out, ST:=Storage, SYSTEM; 

TYPE 
     T0* = POINTER TO ARRAY OF CHAR;
     R1* = RECORD
            p:POINTER TO ARRAY OF CHAR;
           END;
     T1* = POINTER TO R1;
     R2* = RECORD
            h:BOOLEAN; 
	    i:ARRAY 10 OF T1;
           END;
     T2* = POINTER TO ARRAY OF R2;
     T3* = POINTER TO ARRAY OF ARRAY OF T1;

     T4* = POINTER TO R4;
     R4* = RECORD
            bla:BOOLEAN; 
	    next:T4;
           END;
     T5* = POINTER TO A5;
     A5* = ARRAY OF T5;
VAR 
    p0:T0;
    p1:T1;  
    p4:T4;
(*<<<<<<<<<<<<<<<
    a:ARRAY 10 OF R2;
>>>>>>>>>>>>>>>*)
    a5:T5;

(************************************************************************************************************************)
PROCEDURE GC;
BEGIN (* GC *)
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Marking...');    ST.Mark;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Sweeping...');   ST.Sweep;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
END GC;

(*<<<<<<<<<<<<<<<
PROCEDURE Proc(a1:ARRAY OF R2; a2:T0);
VAR p1:T1;
BEGIN (* Proc *)
 NEW(a1[0].i[0]);
 GC;
END Proc;
>>>>>>>>>>>>>>>*)

BEGIN (* M7 *)
(*<<<<<<<<<<<<<<<
 NEW(p0,10); 
 NEW(p1);
 NEW(a[9].i[0]);
 NEW(a[0].i[9]);
 Proc(a,p0); 
>>>>>>>>>>>>>>>*)

(*<<<<<<<<<<<<<<<
 NEW(p4);
 NEW(p4.next);
 NEW(p4.next.next);
 GC;		 
 p4:=NIL; 
 GC;		 
>>>>>>>>>>>>>>>*)

 NEW(a5,3);
 NEW(a5[0],3);
 a5[1]:=a5; 
 GC;		 
END M7.

