MODULE M2;
IMPORT M1,ST:=Storage,O:=Out;
TYPE T=ARRAY 100 OF CHAR;
VAR p:POINTER TO T;

VAR OldHandler:ST.tAllocFailHandlerProc;

PROCEDURE NewHandler(size,nofAttempts:LONGINT);
BEGIN (* NewHandler *)
 O.StrLn("Increasing heap..."); M1.PrintInfo;
 OldHandler(size,nofAttempts); 
 O.StrLn("Heap increased:"); M1.PrintInfo;
END NewHandler;

PROCEDURE P1;
BEGIN (* P1 *)
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
 NEW(p); ST.Mark(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
END P1;

PROCEDURE P2;
BEGIN (* P2 *)
 P1; P1; P1; P1; P1; P1; P1; P1; P1; P1; P1; P1; P1; P1; P1; P1;
END P2;
                                                                
PROCEDURE P3;
BEGIN (* P3 *)
 P2;
 P2;
 P2;
 P2;
 P2;
END P3;

BEGIN (* M2 *)
(*<<<<<<<<<<<<<<<
 OldHandler:=ST.SetAllocFailHandler(NewHandler); 
>>>>>>>>>>>>>>>*)

(*<<<<<<<<<<<<<<<
 M1.PrintInfo;
 P2;
 ST.IncreaseHeap(4096);
 M1.PrintInfo;
 O.StrLn("Sweeping..."); ST.Sweep; M1.PrintInfo;
 O.StrLn("Sweeping..."); ST.Sweep; M1.PrintInfo; 
 ST.DumpHeap;
>>>>>>>>>>>>>>>*)

 ST.DumpHeap;
 O.Ln;
 O.StrLn("Increasing..."); ST.IncreaseHeap(4096); ST.DumpHeap;
 O.Ln;
 O.StrLn("Sweeping..."); ST.Sweep; ST.DumpHeap;
END M2.

