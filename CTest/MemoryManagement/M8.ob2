MODULE M8;
IMPORT M1, O:=Out, ST:=Storage, SYSTEM; 

CONST n = 3;
      maxdepth = 5;
TYPE tP = POINTER TO tR;
     tR = RECORD
           p:ARRAY n OF tP; 
          END;
VAR root:tP; i,count:LONGINT; oldHandler:ST.tAllocFailHandler;
    dummy,hcount:LONGINT; 

PROCEDURE Handler(size,nofAttempts:LONGINT);
BEGIN (* Handler *)
 IF nofAttempts=0 THEN 
(*<<<<<<<<<<<<<<<
    O.Str('Marking... '); 
>>>>>>>>>>>>>>>*)
    ST.Mark;
(*<<<<<<<<<<<<<<<
    O.Str('Sweeping... ');
>>>>>>>>>>>>>>>*)
    ST.Sweep;
 ELSE
(*<<<<<<<<<<<<<<<
    O.Str('Increasing heap... '); 
>>>>>>>>>>>>>>>*)
    IF ST.ChangeHeapSize(size+64*1024)=0 THEN 
       O.StrLn('Unable to increase heap!'); 
       HALT(1); 
    END; (* IF *)
 END; (* IF *)
 
(*<<<<<<<<<<<<<<<
 O.StrLn('Done.'); 
 M1.PrintInfo;
>>>>>>>>>>>>>>>*)
END Handler;

PROCEDURE Generate(depth:LONGINT):tP;
VAR p:tP; i:LONGINT; 
BEGIN (* Generate *) 
 IF depth<=maxdepth THEN 
    INC(count); 
(*<<<<<<<<<<<<<<<
O.Int(count); O.Ln;
    NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); NEW(p); 
>>>>>>>>>>>>>>>*)
    NEW(p); 
    NEW(p); 
    NEW(p); 
    FOR i:=0 TO n-1 DO
     p.p[i]:=Generate(depth+1); 
    END; (* FOR *)		  
 END; (* IF *)
 
 RETURN p; 
END Generate;
	  
PROCEDURE Do;
BEGIN (* Do *)
 O.StrLn('Generating...'); 
 count:=0; 
 root:=Generate(1); 
 O.Int(count); O.StrLn(' elements'); 
END Do;

BEGIN (* M8 *)
 hcount:=0; 
 oldHandler:=ST.SetAllocFailHandler(Handler); 

 ST.DumpHeap;
 LOOP
  Do;
  M1.PrintInfo;
O.StrLn('a'); 
  ST.GC;
(*<<<<<<<<<<<<<<<
  ST.Mark;
  ST.Sweep;
>>>>>>>>>>>>>>>*)
O.StrLn('b'); 
  dummy:=ST.ChangeHeapSize(-10000000); 
O.StrLn('c'); 
 END; (* LOOP *)
END M8.
