MODULE ManyNew;
IMPORT M1, O:=Out, Storage;

VAR n:LONGINT; 
VAR oldHandler:Storage.tAllocFailHandlerProc;
    p:POINTER TO ARRAY OF CHAR; 

PROCEDURE newHandler(size,nofAttempts:LONGINT);
BEGIN (* newHandler *)                       
 O.String('Increasing heap...'); O.Ln;
 M1.PrintInfo;
 
 oldHandler(size,nofAttempts); 
 O.String('Heap increased...'); O.Ln;
 M1.PrintInfo;
END newHandler;

PROCEDURE P0;
BEGIN (* P0 *)
 NEW(p,n); n:=((n+1) MOD 1024)+1; Storage.Mark(p); 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
 NEW(p,n); n:=((n+1) MOD 1024)+1; 
END P0;

PROCEDURE P1;
BEGIN (* P1 *)
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
 P0;
END P1;

PROCEDURE P2;
BEGIN (* P2 *)
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
 P1;
END P2;

PROCEDURE P3;
BEGIN (* P3 *)
 O.String('   Allocating...'); O.Ln;
 P2; 
 O.String('   Sweeping...'); O.Ln;
 Storage.Sweep;
END P3;

PROCEDURE P4;
BEGIN (* P4 *)
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
 P3; 
END P4;

BEGIN (* ManyNew *)
 n:=1; 
 oldHandler:=Storage.SetAllocFailHandler(newHandler); 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 P4; 
 Storage.DumpHeap;
END ManyNew.
