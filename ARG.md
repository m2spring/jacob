DEFINITION MODULE ARG;
(*
 * Handles command line arguments
 *)

IMPORT STR;

TYPE  tTable                   = POINTER TO ARRAY [0..1000000] OF STR.tStr;

(*** The raw arguments ***)

VAR   C                        : INTEGER; 
      P                        : tTable;
                               
(*** "Parsed" options ***)     
                               
CONST CommandShowVersion       = 1;         (* -v        *)
      CommandShowUsage         = 2;         (* -h        *)
      CommandShowArgs          = 3;         (* -args     *)
      CommandDumpTokens        = 4;         (* -t        *)
      CommandDumpParseTree     = 5;         (* -pt       *)
      CommandDumpDecoratedTree = 6;         (* -dt       *)
      CommandNoCodeGeneration  = 7;         (* -cg       *)
      CommandDontAssemble      = 8;         (* -S        *)
      CommandSingleCompile     = 9;         (* -c        *)
      CommandMakeButDontLink   = 10;        (* -m        *)
      CommandMake              = 11;        (* <nothing> *)
      CommandReadOnly          = 12;        (* -read     *)
      CommandScanOnly          = 13;        (* -scan     *)
      CommandParseOnly         = 14;        (* -parse    *)
VAR   Command                  : SHORTCARD; 
CONST DefaultCommand           = CommandMake;
                               
VAR   OptionTraceStages        ,            (* -Ts       *)
      OptionTraceProcNames     ,            (* -Tp       *)
      OptionShowPredeclTable   ,            (* -Dp       *)
      OptionShowImportTables   ,            (* -Di       *)
      OptionShowStmtTables     ,            (* -Ds       *)
      OptionShowWithTables     ,            (* -Dw       *)
      OptionShowTypeAddrs      ,            (* -DA       *)
      OptionShowTypeSizes      ,            (* -DS       *)
      OptionShowVarAddrs       ,            (* -DV       *)
      OptionShowBlocklists     ,            (* -BL       *)
      OptionShowProcNums       ,            (* -PN       *)
      OptionTraceEdCalls       ,            (* -E        *)
      OptionEagerErrorMsgs     ,            (* -ee       *)
      OptionKeepTemporaries    ,            (* -kt       *)
      OptionIgnoreTimeStamps   ,            (* -it       *)
      OptionCommentsInAsm      ,            (* -cmt      *)
      OptionShowProcCounter    ,            (* -dp       *)
      OptionShowStatistics     ,            (* -Ss       *)
      
      OptionElf                ,            (* -elf      *)
      OptionIndexChecking      ,            (* -ic       *)
      OptionRangeChecking      ,            (* -rc       *)
      OptionNilChecking        ,            (* -nc       *)
      OptionAssertionChecking  ,            (* -ac       *)
      OptionOptRefdValParam    :BOOLEAN;    (* -op       *)

      TableDir                 : STR.tStr;  (* -tab <dir> *)

      ImportDirC               : INTEGER;   (* -I<dir>     *)
      ImportDirP               : tTable;    (* ImportDirP^[0]^ always "" *)
                               
      AsmScript                ,            (* -asm <cmd>  *)
      LinkScript               : STR.tStr;  (* -link <cmd> *)

VAR   FileC                    : INTEGER; 
      FileP                    : tTable;

(*** Other stuff ***)

PROCEDURE ShowUsage;

PROCEDURE Init;

END ARG.
