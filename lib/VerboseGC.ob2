MODULE VerboseGC;
IMPORT O:=Out,ST:=Storage;

VAR old:ST.tAllocFailHandler;

PROCEDURE Free():LONGINT; 
VAR inf:ST.tHeapInfo;
BEGIN (* Free *)     
 ST.GetInfo(inf); 
 RETURN inf.TotalFreeBytes; 
END Free;

PROCEDURE GcFirstHandler(size,nofAttempts:LONGINT);
VAR oFree:LONGINT; 
BEGIN (* GcFirstHandler *)
 IF nofAttempts=0 THEN 
    O.Str('Collecting garbage... '); 
    oFree:=Free(); 
    ST.GC;      
    O.Int((Free()-oFree) DIV 1024); O.Str('kB freed. '); 
 ELSE     
    O.Str('Increasing heap... '); 
    IF ST.ChangeHeapSize(4*1024*1024)=0 THEN 
       O.StrLn('Impossible!'); 
       HALT(1); 
    END; (* IF *)
 END; (* IF *)
 O.StrLn('Done.'); 
END GcFirstHandler;

PROCEDURE IncrFirstHandler(size,nofAttempts:LONGINT);
BEGIN (* IncrFirstHandler *)
 O.Str('Increasing heap... '); 
 IF ST.ChangeHeapSize(2*1024*1024)=0 THEN 
    O.Str('Collecting garbage... '); 
    ST.GC;
 END; (* IF *)
 O.StrLn('Done.'); 
END IncrFirstHandler;

BEGIN (* VerboseGC *)
 old:=ST.SetAllocFailHandler(GcFirstHandler); 
END VerboseGC.
