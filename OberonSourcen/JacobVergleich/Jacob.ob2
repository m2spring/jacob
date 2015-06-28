MODULE Jacob;

IMPORT 
Base,ConsBase,
Emit,GcgTab,
ARG,DRV,IO,O,STR,SysLib;

CONST Date = "11/09/95";

VAR i:LONGINT; 

(************************************************************************************************************************)
PROCEDURE Process(Filename:ARRAY OF CHAR);
BEGIN (* Process *)
 CASE ARG.Command OF
 |ARG.CommandDumpTokens: DRV.DumpTokens(Filename); 
 ELSE                    DRV.Compile(Filename); 
 END; (* CASE *)
END Process;

(************************************************************************************************************************)
BEGIN (* Jacob *)
 ARG.Init;
 DRV.Init;
 
 CASE ARG.Command OF
 |ARG.CommandShowUsage  : ARG.ShowUsage;
 |ARG.CommandShowVersion: O.Str('Jacob V0, '); O.StrLn(Date); 
 ELSE                     IF ARG.FileC<=0 THEN 
                             ARG.ShowUsage;
                          ELSE
                             FOR i:=0 TO ARG.FileC-1 DO 
                              Process(ARG.FileP^[i]^); 
                             END; (* FOR *)
                          END; (* IF *)
 END; (* CASE *)

 IO.CloseIO;
 SysLib.exit(DRV.ProgramReturnCode); 
END Jacob.

