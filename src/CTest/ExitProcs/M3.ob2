MODULE M3;
IMPORT L:=Lib, O:=Out;
CONST Modulename='M3';
VAR OldExitProc:L.PROC;

PROCEDURE Exit;
BEGIN (* Exit *)   
 O.Str('Exit '); O.StrLn(Modulename); 
 OldExitProc;
END Exit;

BEGIN
 O.Str('Init '); O.StrLn(Modulename); 
 L.Terminate(Exit,OldExitProc); 
END M3.
