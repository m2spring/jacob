MODULE TstLib;
IMPORT L:=Lib,O:=Out; 
VAR s:ARRAY 100 OF CHAR; 
BEGIN (* TstLib *)
 L.EnvironmentFind('TERM',s); 
 O.StrLn(s); 
END TstLib.
