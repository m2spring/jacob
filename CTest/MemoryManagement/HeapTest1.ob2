MODULE HeapTest1;
IMPORT O:=Out, ST:=Storage;
CONST n=1000;
TYPE tP = POINTER TO tR;
     tR = RECORD
           f:ARRAY 100 OF CHAR; 
           n:tP;
          END;        
VAR ar:ARRAY n OF POINTER TO tR;
    i,action,next:LONGINT;          

PROCEDURE Alloc;
VAR p:tP;
BEGIN (* Alloc *)
 p:=ar[next];
 NEW(ar[next]); 
 ar[next].n:=p;
 next:=(next+1) MOD n;
END Alloc;

BEGIN (* HeapTest1 *)
 next:=0; action:=0;
 LOOP
  IF action MOD 1024=0 THEN O.Int(action); O.Ln; END; (* IF *)
  IF action MOD (1024*1024)=0 THEN 
     FOR i:=0 TO n-1 DO
      ar[i]:=NIL;
     END; (* FOR *)
     ST.GC;
     i:=ST.ChangeHeapSize(-100000); 
  END; (* IF *)
  Alloc;
  INC(action); 
 END; (* LOOP *)
END HeapTest1.
