MODULE M5;
IMPORT O:=Out, ST:=Storage; 

TYPE TM=POINTER TO ARRAY 10 OF CHAR;
VAR a:TM;
(*<<<<<<<<<<<<<<<
    b:TM;
>>>>>>>>>>>>>>>*)
    i:LONGINT; 
    ar:ARRAY 10 OF RECORD
                    p:ARRAY 5 OF RECORD
				  f:BOOLEAN; 
                                  p:TM;
                                 END;
		    f:BOOLEAN; 
                   END;
    b:TM;
TYPE TA=RECORD
	 i:LONGINT; 
         p:ARRAY 10 OF POINTER TO ARRAY OF CHAR; 
        END;
VAR pa:TA;
    arra:ARRAY 10 OF TA;

PROCEDURE Proc(x:BOOLEAN; p:TM; VAR y:LONGINT; n:INTEGER);
TYPE TP=POINTER TO ARRAY 10 OF CHAR;
VAR a:TP;
    ar:ARRAY 10 OF RECORD
                    p:ARRAY 5 OF RECORD
				  f:BOOLEAN; 
                                  p:TP;
                                 END;
		    f:INTEGER; 
                   END;
    br:ARRAY 13 OF TP; 
BEGIN (* Proc *)
 O.StrLn('Initial heap:'); ST.DumpHeap;
 O.StrLn('Allocating...'); 
 NEW(a);
 FOR i:=0 TO LEN(br)-1 DO NEW(br[i]); END; (* FOR *)
 FOR i:=1 TO LEN(br)-1 DO br[i]:=NIL;  END; (* FOR *)
 FOR i:=0 TO 9 DO NEW(ar[i].p[0].p); END; (* FOR *)
 FOR i:=0 TO 8 BY 2 DO ar[i].p[0].p:=NIL; END; (* FOR *)
 
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Marking...');    ST.Mark;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Sweeping...');   ST.Sweep;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
END Proc;

(************************************************************************************************************************)
PROCEDURE Open(a:ARRAY OF TA);
VAR i:LONGINT; 
BEGIN (* Open *)
 FOR i:=0 TO LEN(a)-1 DO NEW(a[i].p[0],10+i); END; (* FOR *)
 FOR i:=1 TO LEN(a)-2 BY 2 DO a[i].p[0]:=NIL;  END; (* FOR *)
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Marking...');    ST.Mark;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Sweeping...');   ST.Sweep;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
END Open;

(************************************************************************************************************************)
BEGIN (* M5 *)	  
 Open(arra); 
(*<<<<<<<<<<<<<<<
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Marking...');    ST.Mark;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Sweeping...');   ST.Sweep;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
>>>>>>>>>>>>>>>*)
END M5.

