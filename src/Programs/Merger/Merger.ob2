MODULE Merger;
IMPORT Merge,F:=RawFiles,L:=Lib,O:=Out;

VAR i:LONGINT; fn:ARRAY 200 OF CHAR; 

(************************************************************************************************************************)
PROCEDURE UsageHalt;
BEGIN (* UsageHalt *)
 O.StrLn('Usage: Merger [m|u] <filename> {<filename>}'); 
 HALT(1); 
END UsageHalt;

(************************************************************************************************************************)
BEGIN (* Merger *)
 IF L.ParamCount()<3 THEN UsageHalt; END; (* IF *)					     
 
 FOR i:=2 TO L.ParamCount()-1 DO
  L.ParamStr(fn,i); 
  Merge.Do(fn); 
 END; (* IF *)
END Merger.
