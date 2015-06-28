MODULE Mem01;
(*% Allocating with fixed NEW *)

IMPORT O:=Out, S:=Storage, SYSTEM;

TYPE 
     tA0 = ARRAY 70 OF CHAR; 
     tP0 = POINTER TO ARRAY 20 OF tA0;
     tP1 = POINTER TO ARRAY 10000 OF tP0;

VAR 
    oldAllocFailHandler:S.tAllocFailHandler;
    i,j:LONGINT; 
    text:ARRAY 70 OF CHAR; 
    p0:tP0;
    p1:tP1;

(************************************************************************************************************************)
PROCEDURE Print(p:tP0);
BEGIN (* Print *)
 FOR i:=0 TO 19 DO
  O.StrLn(p[i]);
 END;
 O.StrLn('-----');
END Print;

(************************************************************************************************************************)
PROCEDURE NewAllocFailHandler(size,nofAttempts:LONGINT);
BEGIN (* NewAllocFailHandler *)
 O.StrLn('Alloc failed!');
 oldAllocFailHandler(size,nofAttempts);
 O.StrLn('Heap increased!'); O.Ln;
END NewAllocFailHandler;


BEGIN (* Mem01 *)
 oldAllocFailHandler:=S.SetAllocFailHandler(NewAllocFailHandler);
 text:='12345678 10 345678 20 345678 30 345678 40 345678 50 345678 60 3456 69'; 

 (* Fill p0 *)
 NEW(p0);
 FOR i:=0 TO 19 DO
  COPY(text,p0[i]);
 END;

 (* Fill p1 *)
 NEW(p1);
 FOR i:=0 TO 6999 DO
  NEW(p1[i]);
  FOR j:=0 TO 19 DO
   COPY(text,p1[i][j]);
  END;
 END;
 Print(p1[0]);
 Print(p1[3456]);
 Print(p1[6999]);

 S.MarkBlock(SYSTEM.ADR(p1[0]));
 S.Sweep;
 O.StrLn('Still there:');
 Print(p1[0]);
 
END Mem01.
