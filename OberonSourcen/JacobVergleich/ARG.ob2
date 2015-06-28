MODULE ARG;
IMPORT Arguments, Base, O, Storage, STR, Strings1, SYSTEM;

(*
 * Handles command line arguments
 *)

TYPE  tTable*                  = POINTER TO ARRAY 100 OF STR.tStr;

(*** The raw arguments ***)

VAR   C*                       : INTEGER; 
      P*                       : tTable;
                               
(*** "Parsed" options ***)     
                               
CONST CommandShowVersion*       = 1;         (* -v        *)
      CommandShowUsage*         = 2;         (* -h        *)
      CommandShowArgs*          = 3;         (* -args     *)
      CommandDumpTokens*        = 4;         (* -t        *)
      CommandDumpParseTree*     = 5;         (* -pt       *)
      CommandDumpDecoratedTree* = 6;         (* -dt       *)
      CommandNoCodeGeneration*  = 7;         (* -cg       *)
      CommandDontAssemble*      = 8;         (* -S        *)
      CommandSingleCompile*     = 9;         (* -c        *)
      CommandMakeButDontLink*   = 10;        (* -m        *)
      CommandMake*              = 11;        (* <nothing> *)
VAR   Command*                  : INTEGER; 
CONST DefaultCommand*           = CommandMake;
                               
VAR   OptionTraceStages*        ,            (* -Ts       *)
      OptionShowPredeclTable*   ,            (* -Dp       *)
      OptionShowImportTables*   ,            (* -Di       *)
      OptionShowStmtTables*     ,            (* -Ds       *)
      OptionShowWithTables*     ,            (* -Dw       *)
      OptionShowTypeAddrs*      ,            (* -DA       *)
      OptionShowTypeSizes*      ,            (* -DS       *)
      OptionShowVarAddrs*       ,            (* -DV       *)
      OptionShowBlocklists*     ,            (* -BL       *)
      OptionShowProcNums*       ,            (* -PN       *)
      OptionTraceEdCalls*       ,            (* -E        *)
      OptionEagerErrorMsgs*     ,            (* -ee       *)
      OptionKeepTemporaries*    ,            (* -kt       *)
      OptionIgnoreTimeStamps*   ,            (* -it       *)
      OptionCommentsInAsm*      ,            (* -cmt      *)
      OptionShowProcCounter*    ,            (* -dp       *)
      OptionShowStatistics*     ,            (* -Ss       *)
      
      OptionIndexChecking*      ,            (* -ic       *)
      OptionRangeChecking*      ,            (* -rc       *)
      OptionNilChecking*        ,            (* -nc       *)
      OptionAssertionChecking*  : BOOLEAN;   (* -ac       *)

      TableDir*                 : STR.tStr;  (* -tab <dir> *)

      ImportDirC*               : INTEGER;   (* -I<dir>     *)
      ImportDirP*               : tTable;    (* ImportDirP^[0]^ always "" *)
                               
      AsmScript*                ,            (* -asm <cmd>  *)
      LinkScript*               : STR.tStr;  (* -link <cmd> *)

VAR   FileC*                    : INTEGER; 
      FileP*                    : tTable;

(************************************************************************************************************************)
PROCEDURE ShowUsage*;
BEGIN (* ShowUsage *)
 O.StrLn("Usage: Jacob {<filename[.ob2]>|<command>|<option>}");
 O.StrLn("Commands   : -v          show Version");
 O.StrLn("             -h          show usage (Help)");
 O.StrLn("             -cg         No Code generation");
 O.StrLn("             -S          don't aSsemble");
 O.StrLn("             -c          single Compile");
 O.StrLn("             -m          Make but don't link");
 O.StrLn("Options    : -kt         Keep Temporary files (*.s)");
 O.StrLn("             -it         Ignore Time stamps");
 O.StrLn("             -dp         Disable Procedure counting info");
 O.StrLn("             -ic         disable Index Checks");
 O.StrLn("             -rc         disable Range Checks");
 O.StrLn("             -nc         disable Nil Checks");
 O.StrLn("             -ac         disable Assertion Checks");
 O.StrLn("Directories: -tab <dir>  scanner, parser, error table are in <dir>");
 O.StrLn("             -I<dir>     search imports in <dir> (multiple)");
 O.StrLn("Scripts    : -asm <cmd>  assembler invocation script");
 O.StrLn("             -link <cmd> linker invocation script");
 O.StrLn("------------------------------------------------------------------"); 
 O.StrLn("For compiler debugging purposes:"); 
 O.StrLn("Commands   : -t          dump Tokens");
 O.StrLn("             -pt         dump Parse Tree");
 O.StrLn("             -dt         dump Decorated Tree");
 O.StrLn("Options    : -Ts         Trace compiling Stages");
 O.StrLn("             -Dp         show predeclared table");
 O.StrLn("             -Di         show imported tables");
 O.StrLn("             -Ds         show statement tables");
 O.StrLn("             -Dw         show WITH tables");
 O.StrLn("             -DA         show type addresses");
 O.StrLn("             -BL         show Block Lists");
 O.StrLn("             -PN         show bound Procedure Numbers");
 O.StrLn("             -DS         show type sizes");
 O.StrLn("             -DV         show variable addresses");
 O.StrLn("             -Ss         show statistics");
 O.StrLn("             -E          trace ED procedure calls");
 O.StrLn("             -ee         Eager Error messages (not lazy) ;-)");
 O.StrLn("             -cmt        produce assembler CoMmenTs");
 O.StrLn("             -ctei       show Coder Test output Emit Ir");
 O.StrLn("             -ctem       show Coder Test output Emit Match");
 O.StrLn("             -ctra       show Coder Test output Reg Alloc");
END ShowUsage;

(************************************************************************************************************************)
PROCEDURE IsArg(VAR arg:ARRAY OF CHAR; s:ARRAY OF CHAR):BOOLEAN; 
BEGIN (* IsArg *)
 RETURN Strings1.StrEq(arg,s); 
END IsArg;

(************************************************************************************************************************)
PROCEDURE IsPre(VAR arg:ARRAY OF CHAR; pre:ARRAY OF CHAR; VAR suffix:STR.tStr):BOOLEAN; 
VAR i,n,aLen,pLen:LONGINT; 
BEGIN (* IsPre *)
 aLen:=STR.Length(arg); pLen:=STR.Length(pre); 
 IF aLen<pLen THEN RETURN FALSE; END; (* IF *)
 FOR i:=0 TO pLen-1 DO
  IF (arg[i]=0X) OR (arg[i]#pre[i]) THEN RETURN FALSE; END; (* IF *)
 END; (* FOR *)

 n:=aLen-pLen; 

 Storage.ALLOCATE(suffix,1+n); 
 FOR i:=0 TO n-1 DO suffix^[i]:=arg[pLen+i]; END; (* FOR *)
 suffix^[n]:=0X;
 RETURN TRUE; 
END IsPre;

(************************************************************************************************************************)
PROCEDURE SetCmd(cmd:INTEGER);
BEGIN (* SetCmd *)            
 IF Command=DefaultCommand THEN Command:=cmd; END; (* IF *)
END SetCmd;

(************************************************************************************************************************)
PROCEDURE GetArg(VAR i:LONGINT; VAR Command:INTEGER):STR.tStr;
BEGIN (* GetArg *)
 INC(i); 
 IF i<C THEN RETURN STR.Dup(P^[i]); END; (* IF *)
 Command:=CommandShowUsage; 
 RETURN NIL; 
END GetArg;

(************************************************************************************************************************)
PROCEDURE Append(VAR c:INTEGER; VAR p:tTable; s:STR.tStr);
VAR i:LONGINT; x:LONGINT; t:tTable;
BEGIN (* Append *)
 Storage.ALLOCATE(t,(c+1)*SIZE(STR.tStr)); 
 IF c#0
    THEN FOR i:=0 TO c-1 DO t^[i]:=p^[i]; END; (* FOR *)
         Storage.DEALLOCATE(p,c*SIZE(STR.tStr)); 
 END; (* IF *)
 p:=t; p^[c]:=s; INC(c); 
END Append;

(************************************************************************************************************************)
PROCEDURE Init*;
VAR argc:LONGINT; argp:Arguments.ArgTable; i:LONGINT; s:STR.tStr; 
BEGIN (* Init *)
 Arguments.GetArgs(argc,argp);  C:=SHORT(argc); P:=SYSTEM.VAL(tTable,argp); 

 i:=1; 
 WHILE i<C DO
  IF    IsArg(P^[i]^,"-v"   ) THEN SetCmd(CommandShowVersion      ); 
  ELSIF IsArg(P^[i]^,"-h"   ) THEN SetCmd(CommandShowUsage        ); 
  ELSIF IsArg(P^[i]^,"-t"   ) THEN SetCmd(CommandDumpTokens       ); 
  ELSIF IsArg(P^[i]^,"-pt"  ) THEN SetCmd(CommandDumpParseTree    ); 
  ELSIF IsArg(P^[i]^,"-dt"  ) THEN SetCmd(CommandDumpDecoratedTree); 
  ELSIF IsArg(P^[i]^,"-cg"  ) THEN SetCmd(CommandNoCodeGeneration ); 
  ELSIF IsArg(P^[i]^,"-S"   ) THEN SetCmd(CommandDontAssemble     ); 
  ELSIF IsArg(P^[i]^,"-c"   ) THEN SetCmd(CommandSingleCompile    ); 
  ELSIF IsArg(P^[i]^,"-m"   ) THEN SetCmd(CommandMakeButDontLink  ); 
                            
  ELSIF IsArg(P^[i]^,"-Ts"  ) THEN OptionTraceStages       := TRUE; 
  ELSIF IsArg(P^[i]^,"-Dp"  ) THEN OptionShowPredeclTable  := TRUE; 
  ELSIF IsArg(P^[i]^,"-Di"  ) THEN OptionShowImportTables  := TRUE; 
  ELSIF IsArg(P^[i]^,"-Ds"  ) THEN OptionShowStmtTables    := TRUE; 
  ELSIF IsArg(P^[i]^,"-Dw"  ) THEN OptionShowWithTables    := TRUE; 
  ELSIF IsArg(P^[i]^,"-DA"  ) THEN OptionShowTypeAddrs     := TRUE; 
  ELSIF IsArg(P^[i]^,"-DS"  ) THEN OptionShowTypeSizes     := TRUE; 
  ELSIF IsArg(P^[i]^,"-DV"  ) THEN OptionShowVarAddrs      := TRUE; 
  ELSIF IsArg(P^[i]^,"-BL"  ) THEN OptionShowBlocklists    := TRUE; 
  ELSIF IsArg(P^[i]^,"-PN"  ) THEN OptionShowProcNums      := TRUE; 
  ELSIF IsArg(P^[i]^,"-E"   ) THEN OptionTraceEdCalls      := TRUE; 
  ELSIF IsArg(P^[i]^,"-ee"  ) THEN OptionEagerErrorMsgs    := TRUE; 
  ELSIF IsArg(P^[i]^,"-kt"  ) THEN OptionKeepTemporaries   := TRUE; 
  ELSIF IsArg(P^[i]^,"-it"  ) THEN OptionIgnoreTimeStamps  := TRUE; 
  ELSIF IsArg(P^[i]^,"-cmt" ) THEN OptionCommentsInAsm     := TRUE; 
  ELSIF IsArg(P^[i]^,"-dp"  ) THEN OptionShowProcCounter   := FALSE; 
  ELSIF IsArg(P^[i]^,"-Ss"  ) THEN OptionShowStatistics    := TRUE; 
							   
  ELSIF IsArg(P^[i]^,"-ic"  ) THEN OptionIndexChecking     := FALSE; 
  ELSIF IsArg(P^[i]^,"-rc"  ) THEN OptionRangeChecking     := FALSE; 
  ELSIF IsArg(P^[i]^,"-nc"  ) THEN OptionNilChecking       := FALSE; 
  ELSIF IsArg(P^[i]^,"-ac"  ) THEN OptionAssertionChecking := FALSE; 
							   
  ELSIF IsArg(P^[i]^,"-ctei") THEN Base.OptEmitIR            := TRUE; 
  ELSIF IsArg(P^[i]^,"-ctem") THEN Base.OptEmitMatch         := TRUE; 
  ELSIF IsArg(P^[i]^,"-ctra") THEN Base.OptRegAlloc          := TRUE; 

  ELSIF IsArg(P^[i]^,"-tab" ) THEN TableDir   := GetArg(i,Command); 
  ELSIF IsPre(P^[i]^,"-I",s ) THEN Append(ImportDirC,ImportDirP,s); 
                            
  ELSIF IsArg(P^[i]^,"-asm" ) THEN AsmScript  := GetArg(i,Command); 
  ELSIF IsArg(P^[i]^,"-link") THEN LinkScript := GetArg(i,Command); 
                            
  ELSIF P^[i]^[0]="-"         THEN Command:=CommandShowUsage; 
                            
                              ELSE Append(FileC,FileP,STR.Dup(P^[i])); 
  END; (* IF *)                         
  INC(i); 
 END; (* WHILE *)
 
 IF TableDir  =NIL THEN TableDir   := STR.Alloc(""); END; (* IF *)
 IF AsmScript =NIL THEN AsmScript  := STR.Alloc(""); END; (* IF *)
 IF LinkScript=NIL THEN LinkScript := STR.Alloc(""); END; (* IF *)
END Init;

(************************************************************************************************************************)
BEGIN (* ARG *)  
 Command                  := CommandMake; 
 OptionShowPredeclTable   := FALSE; 
 OptionShowImportTables   := FALSE; 
 OptionShowStmtTables     := FALSE; 
 OptionShowWithTables     := FALSE; 
 OptionShowTypeAddrs      := FALSE; 
 OptionShowTypeSizes      := FALSE; 
 OptionShowVarAddrs       := FALSE; 
 OptionShowBlocklists     := FALSE; 
 OptionShowProcNums       := FALSE; 
 OptionTraceEdCalls       := FALSE; 
 OptionEagerErrorMsgs     := FALSE; 
 OptionKeepTemporaries    := FALSE; 
 OptionIgnoreTimeStamps   := FALSE; 
 OptionCommentsInAsm      := FALSE; 
 OptionShowProcCounter    := TRUE; 
 OptionShowStatistics     := FALSE; 

 OptionIndexChecking      := TRUE; 
 OptionRangeChecking      := TRUE; 
 OptionNilChecking        := TRUE; 
 OptionAssertionChecking  := TRUE; 
 
 TableDir                 := NIL; 
 ImportDirC               := 0; 
 ImportDirP               := NIL; 
 Append(ImportDirC,ImportDirP,STR.Alloc("")); 
 AsmScript                := NIL; 
 LinkScript               := NIL;                
 FileC                    := 0; 
 FileP                    := NIL; 
END ARG.

