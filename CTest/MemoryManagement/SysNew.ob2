MODULE SysNew;
IMPORT Storage, SYSTEM;

TYPE TP=ARRAY 10 OF CHAR;
VAR p:POINTER TO TP; i:LONGINT; 

PROCEDURE P1;
BEGIN (* P1 *)
 SYSTEM.NEW(p,5); 
END P1;

PROCEDURE P2;
BEGIN (* P2 *)
 SYSTEM.NEW(p,0);
 SYSTEM.NEW(p,1);
 SYSTEM.NEW(p,2);
 SYSTEM.NEW(p,3);
 Storage.Mark(p); 
 SYSTEM.NEW(p,4);
 SYSTEM.NEW(p,5);
 SYSTEM.NEW(p,6);
END P2;

PROCEDURE Alloc*;
BEGIN (* Alloc *)
 P1;
 P2;
END Alloc;

END SysNew.
