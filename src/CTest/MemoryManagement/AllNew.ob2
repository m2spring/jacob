MODULE AllNew;
IMPORT M1,StaticNew,OpenNew,SysNew,O:=Out,Storage;

VAR OldHandler:Storage.tAllocFailHandlerProc;

PROCEDURE Alloc;
BEGIN (* Alloc *)
 StaticNew.Alloc;
 OpenNew.Alloc;
 SysNew.Alloc;
END Alloc;

PROCEDURE Test1;
BEGIN (* Test1 *)
 O.String('The Heap:'); O.Ln;
 Storage.DumpHeap;
 
 Alloc; 

 Storage.MarkAll;
 O.String('The marked Heap:'); O.Ln;
 Storage.DumpHeap;
END Test1;

PROCEDURE Test2;
BEGIN (* Test2 *)
 Storage.DumpHeap;
 Storage.IncreaseHeap(1); 

 O.String("Increased Heap:"); O.Ln;
 Storage.DumpHeap;

 Storage.IncreaseHeap(1); 
 O.String("Increased Heap:"); O.Ln;
 Storage.DumpHeap;

 Storage.IncreaseHeap(1); 
 O.String("Increased Heap:"); O.Ln;
 Storage.DumpHeap;

 Storage.IncreaseHeap(1); 
 O.String("Increased Heap:"); O.Ln;
 Storage.DumpHeap;

 Storage.IncreaseHeap(1); 
 O.String("Increased Heap:"); O.Ln;
 Storage.DumpHeap;
END Test2;

PROCEDURE NewHandler(size,nofAttempts:LONGINT);
BEGIN (* NewHandler *)
 O.String("NewHandler("); 
 O.Int(size);
 O.String(","); 
 O.Int(nofAttempts);
 O.String(")"); 
 O.Ln;
 
 OldHandler(size,nofAttempts); 
END NewHandler;

PROCEDURE Test3;
VAR p:POINTER TO ARRAY OF CHAR;
BEGIN (* Test3 *)                     
 OldHandler:=Storage.SetAllocFailHandler(NewHandler); 
 
 Storage.DumpHeap;

 NEW(p,10000);
 Storage.DumpHeap;
 NEW(p,10000);
 Storage.DumpHeap;
 NEW(p,10000);
 Storage.DumpHeap;
 NEW(p,10000);
 Storage.DumpHeap;
 NEW(p,10000);
 Storage.DumpHeap;
END Test3;

PROCEDURE Test4;
BEGIN (* Test4 *)
 O.String('Initial Heap:'); O.Ln; Storage.DumpHeap;
 Storage.Sweep; O.String('Swept Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Storage.IncreaseHeap(1); O.String('Increased Heap:'); O.Ln; Storage.DumpHeap;
 Alloc; O.String('Alloced Heap:'); O.Ln; Storage.DumpHeap;
 Storage.Sweep; O.String('Swept Heap:'); O.Ln; Storage.DumpHeap;
END Test4;

PROCEDURE Test5;
VAR p1,p2:POINTER TO ARRAY 100 OF CHAR; 
BEGIN (* Test5 *)
 O.String('   Initial Heap:'); O.Ln; Storage.DumpHeap;
 Alloc;
 NEW(p1); NEW(p2); O.String('   Alloced Heap:'); O.Ln; Storage.DumpHeap;
 Storage.Mark(p2); O.String('   Marked Heap:'); O.Ln; Storage.DumpHeap;
 Alloc;
 Storage.Sweep; O.String('   Swept Heap:'); O.Ln; Storage.DumpHeap;
 NEW(p1); O.String('   Alloced Heap:'); O.Ln; Storage.DumpHeap;
END Test5;

PROCEDURE Test6;
BEGIN (* Test6 *)
END Test6;

BEGIN (* AllNew *)          
 Test5;
END AllNew.
