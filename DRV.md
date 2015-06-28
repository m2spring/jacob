DEFINITION MODULE DRV; 
(* 
 * Front-End driver module 
 *)

IMPORT Idents, OB;

VAR ProgramReturnCode:INTEGER; 

PROCEDURE Compile(Filename : ARRAY OF CHAR);
(*
 * Compiles the module 'Filename' 
 *)

PROCEDURE Import(ServerIdent : Idents.tIdent; VAR ErrorMsg : SHORTCARD) : OB.tOB;
(*
 * Yields the export table of a server module.
 *)

PROCEDURE DumpTokens(Filename : ARRAY OF CHAR);
(*
 * Dumps the tokens found in file 'Filename'.
 *)

PROCEDURE Read(Filename : ARRAY OF CHAR);
PROCEDURE Scan(Filename : ARRAY OF CHAR);
PROCEDURE Parse(Filename : ARRAY OF CHAR); 

PROCEDURE Init;

PROCEDURE ShowCompiling(table : OB.tOB) : OB.tOB; 
PROCEDURE ShowProcCount(table : OB.tOB) : OB.tOB; 

END DRV.

