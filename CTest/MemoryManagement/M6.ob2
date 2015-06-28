MODULE M6;
IMPORT O:=Out, ST:=Storage, SYSTEM; 

TYPE tP = POINTER TO tR;
     tR = RECORD
           p:tP;
          END;
VAR p:ARRAY 10 OF RECORD
                   i:BOOLEAN; 
		   p:ARRAY 3 OF tP;
                  END;
BEGIN (* M6 *)
 NEW(p[0].p[0]); 
 NEW(p[1].p[0]); 
(*<<<<<<<<<<<<<<<
ST.MarkBlock(SYSTEM.ADR(p^)); 
>>>>>>>>>>>>>>>*)
 
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Marking...');    ST.Mark;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
 O.StrLn('Sweeping...');   ST.Sweep;
 O.StrLn('Heap:'); 	   ST.DumpHeap;
END M6.
