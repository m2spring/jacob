MODULE M9;
IMPORT M1, O:=Out, ST:=Storage, SYSTEM; 

TYPE tP = POINTER TO tR;
     tR = RECORD
           p:tP;
          END;  
VAR p:tP;	  

PROCEDURE Info;
BEGIN (* Info *)
 M1.PrintInfo;
 ST.DumpHeap;
 O.Ln;
END Info;

PROCEDURE Change(i:LONGINT);
BEGIN (* Change *)	  
 O.Str('Changing heap by '); 
 O.Int(ST.ChangeHeapSize(i));
 O.StrLn(' bytes'); 
 Info;
END Change;

BEGIN (* M9 *)
 Info;
 NEW(p);
 Info;  
 Change(-100000); 
 Change(10); 
END M9.
