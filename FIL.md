DEFINITION MODULE FIL;
(*
 * Provides functionality for the file handling of nested source files during compilation.
 *)

IMPORT CV,ErrLists,Idents,OB,OT,STR,SysLib,Tree;

CONST  Extension      = '.ob2';
       ErrorExtension = '_errors';
TYPE   tElemPtr       = POINTER TO tElem;
       tElem          = RECORD
                         SourceDir    ,
                         Filename     ,
                         Modulename   : STR.tStr;                 (* Empty, if stdinput is used   *)
                         ModuleIdent  : Idents.tIdent;            (* NoIdent, if stdinput is used *)
                         SourceTime   ,
                         ObjectTime   : SysLib.timeT;
                         IsForeign    : BOOLEAN; 
                         Library      : OT.oSTRING;
                         TreeRoot     : Tree.tTree;
                         MainTable    ,
                         ModuleEntry  : OB.tOB;
                         ConstTable   : CV.tTable;
                         NextLocLabel : LONGCARD; 
                         ErrorList    : ErrLists.tErrorList;
                         ProcCount    : LONGINT; 
                         nofSpills    ,
                         nofLRs       : LONGINT; 
                         PrevP        : tElemPtr;
                        END;
VAR    ActP           : tElemPtr;                                 (* Current active source file   *)
       NestingDepth   : CARDINAL;

PROCEDURE FileModificationTime(fn:ARRAY OF CHAR) : SysLib.timeT;
(*
 * Returns the modification time stamp of file 'fn'.
 * MIN(INTEGER), if 'fn' doesn't exist
 *)

PROCEDURE AdjustClientSourceTime(time : SysLib.timeT); 
(*
 * If client exists and is older the 'time', its 'SourceTime' gets 'time'.
 *)
 
PROCEDURE IsOpen(moduleIdent : Idents.tIdent) : BOOLEAN;
(*
 * Is the module with the name 'moduleIdent' already open?
 *)

PROCEDURE Open(Filename : ARRAY OF CHAR) : BOOLEAN;
(*
 * Opens the file 'Filename'.
 * If 'Filename' is empty, stdinput is used for input.
 * Fails, if 'Filename' is not accessible.
 *)

PROCEDURE Close;
(*
 * Writes an error file, if errors occurred. Erases the old error file, if no errors occurred.
 * Closes the last opened file.
 *)

END FIL.

