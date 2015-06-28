MODULE DRV;

IMPORT ARG,CODE,ERR,ErrLists,Eval,FIL,Idents,InOut,IO,O,OD,OB,OT,Parser,PR,Scanner,STR,Strings,SysLib,Target,TBL,Tree,TD;
                    
VAR    linkable     : BOOLEAN; 
       youngestTime : SysLib.timeT;
VAR ProgramReturnCode*:INTEGER; 

PROCEDURE^WrCompiling;

(************************************************************************************************************************)
PROCEDURE stage(s:ARRAY OF CHAR);
BEGIN (* stage *)
 IF ARG.OptionTraceStages THEN 
    O.St3(s,' ',FIL.ActP^.Modulename^); O.Ln;
 END; (* IF *)
END stage;

(************************************************************************************************************************)
PROCEDURE ErrorOccurred;
BEGIN (* ErrorOccurred *)
 ProgramReturnCode:=1; linkable:=FALSE; 
END ErrorOccurred;

(************************************************************************************************************************)
PROCEDURE ShowStatistics;
BEGIN (* ShowStatistics *)
 O.Str('   Spill:'); O.Int(FIL.ActP^.nofSpills); 
 O.Str(' LR:'); O.Int(FIL.ActP^.nofLRs); 
 O.Ln;
END ShowStatistics;

(************************************************************************************************************************)
PROCEDURE Compile*(Filename : ARRAY OF CHAR);
VAR xn:ARRAY Strings.cMaxStrLength+1 OF CHAR; UsedHeap:LONGINT; 

(*----------------------------------------------------------------------------*)
 PROCEDURE compile;
 BEGIN (* compile *)
  stage('P');
  IF Parser.Parser()#0 THEN WrCompiling; ErrorOccurred; RETURN; END; (* IF *)
  IF ARG.Command=ARG.CommandDumpParseTree THEN TD.Dump(FIL.ActP^.TreeRoot); RETURN; END; (* IF *)
  
  stage('E');
  Eval.BeginEval; Eval.Eval(FIL.ActP^.TreeRoot); Eval.CloseEval;
  IF ARG.Command=ARG.CommandDumpDecoratedTree THEN TD.Dump(FIL.ActP^.TreeRoot); RETURN; END; (* IF *)  
  
  IF (ErrLists.Length(FIL.ActP^.ErrorList)>0)
  OR (ARG.Command<=ARG.CommandNoCodeGeneration) THEN ErrorOccurred; RETURN; END; (* IF *)
  
  IF ~ARG.OptionIgnoreTimeStamps & (FIL.ActP^.SourceTime<=FIL.ActP^.ObjectTime) THEN 
     Target.AddToLinklist(FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^); 
     RETURN; 
  END; (* IF *)             
  
  IF FIL.ActP^.IsForeign THEN linkable:=FALSE; RETURN; END; (* IF *)

  stage('C'); 
  IF ARG.OptionShowProcCounter THEN O.Str(' C'); InOut.WriteBf; END; (* IF *)
  IF ~CODE.Coder() THEN ErrorOccurred; RETURN; END; (* IF *)   
  
  IF ARG.Command<=ARG.CommandDontAssemble THEN linkable:=FALSE; RETURN; END; (* IF *)

  stage('A'); 
  IF ARG.OptionShowProcCounter THEN O.Str(' A'); InOut.WriteBf; END; (* IF *)
  IF ~Target.Assemble() THEN linkable:=FALSE; RETURN; END; (* IF *)

  Target.AddToLinklist(FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^); 
 END compile;

(*----------------------------------------------------------------------------*)
BEGIN (* Compile *)
 IF ~FIL.Open(Filename) THEN O.St3("Unable to open '",Filename,"'."); O.Ln; ErrorOccurred; RETURN; END; (* IF *)

 Target.ClearLinklist; linkable:=TRUE; youngestTime:=FIL.ActP^.SourceTime; 
 compile;   
 IF ARG.OptionShowProcCounter THEN O.Ln; END; (* IF *)
 IF ARG.OptionShowStatistics THEN ShowStatistics; END; (* IF *)
 
 STR.Concat(xn,FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^); 
 IF (ARG.Command >= ARG.CommandMake) & linkable
 &  (ARG.OptionIgnoreTimeStamps OR (FIL.FileModificationTime(xn)<youngestTime)) THEN 
    O.St2('Linking ',FIL.ActP^.Modulename^); O.Ln;
    IF ~Target.Link(FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^) THEN ErrorOccurred; END; (* IF *)
 END; (* IF *)
 
 Parser.CloseParser;
 FIL.Close;
END Compile;

(************************************************************************************************************************)
PROCEDURE Import*(ServerIdent : Idents.tIdent; VAR ErrorMsg :INTEGER) : OB.tOB;
VAR s:Strings.tString; Filename:ARRAY Strings.cMaxStrLength+1 OF CHAR; Result:OB.tOB;
VAR UsedHeap:LONGINT; 
    
(*----------------------------------------------------------------------------*)
 PROCEDURE import;
 BEGIN (* import *)
  stage('P'); 
  IF Parser.Parser()#0 THEN WrCompiling; ErrorOccurred; RETURN; END; (* IF *)

  stage('E'); 
  Eval.BeginEval; Eval.Eval(FIL.ActP^.TreeRoot); Eval.CloseEval;
  Result:=FIL.ActP^.MainTable;
  
  IF (ErrLists.Length(FIL.ActP^.ErrorList)>0)
  OR (ARG.Command <= ARG.CommandSingleCompile) THEN ErrorOccurred; RETURN; END; (* IF *)
  
  IF ~ARG.OptionIgnoreTimeStamps & (FIL.ActP^.SourceTime<=FIL.ActP^.ObjectTime) THEN 
     Target.AddToLinklist(FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^); 
     RETURN; 
  END; (* IF *)

  IF FIL.ActP^.IsForeign THEN RETURN; END; (* IF *)

  stage('C'); 
  IF ARG.OptionShowProcCounter THEN O.Str(' C'); InOut.WriteBf; END; (* IF *)
  IF ~CODE.Coder() THEN ErrorOccurred; RETURN; END; (* IF *)
  
  stage('A'); 
  IF ARG.OptionShowProcCounter THEN O.Str(' A'); InOut.WriteBf; END; (* IF *)
  IF ~Target.Assemble() THEN ErrorOccurred; RETURN; END; (* IF *)
  
  Target.AddToLinklist(FIL.ActP^.SourceDir^,FIL.ActP^.Modulename^); 
 END import;
    
(*----------------------------------------------------------------------------*)
BEGIN (* Import *)
 ErrorMsg:=ERR.NoErrorMsg;

 IF ServerIdent=PR.IdentSYSTEM THEN RETURN PR.GetTableSYSTEM(); END;
 IF TBL.Retrieve(Result,ServerIdent) THEN RETURN Result; END;

 IF FIL.IsOpen(ServerIdent)THEN 
    ErrorMsg:=ERR.MsgCyclicImport;                                                                        (* !CyclicImport *)
    ErrorOccurred;
    RETURN OB.cErrorEntry;
 END; (* IF *)

 Idents.GetString(ServerIdent,s); Strings.StringToArray(s,Filename);
 IF ~FIL.Open(Filename) THEN 
    ErrorMsg:=ERR.MsgFileNotFound;                                                                     (* !ServerFileAvail *)
    ErrorOccurred;
    RETURN OB.cErrorEntry;
 END; (* IF *)

 IF FIL.ActP^.SourceTime > youngestTime THEN youngestTime:=FIL.ActP^.SourceTime; END; (* IF *)
 Result:=OB.cErrorEntry;
 import;    
 IF ARG.OptionShowProcCounter THEN O.Ln; END; (* IF *)
 IF ARG.OptionShowStatistics THEN ShowStatistics; END; (* IF *)
 
 Parser.CloseParser;
 FIL.Close;

 TBL.Store(Result,ServerIdent);
 RETURN Result;
END Import;

(************************************************************************************************************************)
PROCEDURE DumpTokens*(Filename : ARRAY OF CHAR);
VAR token:LONGINT; s:ARRAY 501 OF CHAR; indent:ARRAY Scanner.TokenNameMaxLength+1 OF CHAR;
BEGIN (* DumpTokens *)
 IF ~FIL.Open(Filename) THEN O.St3("Unable to open '",Filename,"'."); O.Ln; ErrorOccurred; RETURN; END; (* IF *)

 O.St2('File ',FIL.ActP^.Filename^); O.Ln;

 STR.DoString(indent,Scanner.TokenNameMaxLength+1,' ');
 Scanner.BeginScanner;
 LOOP
  token:=Scanner.GetToken();

  O.Num(Scanner.Attribute.Position.Line,4);
  O.Char(',');
  O.Num(Scanner.Attribute.Position.Column,3);
  O.Str(': ');

  Scanner.TokenNum2TokenName(token,s);
  IF (s[0]='<') & (s[1]#'=') THEN 
     STR.DoLb(s,Scanner.TokenNameMaxLength+1);
  ELSE 
     STR.Insert(s,indent,0);
  END; (* IF *)
  O.Str(s);

  CASE token OF
  |Scanner.EofToken     : O.Ln; EXIT;
  |Scanner.IdentToken   : O.Ident       (Scanner.Attribute.Ident         );
  |Scanner.IntegerToken : O.LngInt      (Scanner.Attribute.Integer       );
  |Scanner.RealToken    : O.Real        (Scanner.Attribute.Real    ,-5 ,0);
  |Scanner.LongrealToken: O.oLngReal    (Scanner.Attribute.Longreal,-13,0);
  |Scanner.CharToken    : OT.oCHAR2ARR  (Scanner.Attribute.Char,s        );
                          O.Str(s);
  |Scanner.StringToken  : OT.oSTRING2ARR(Scanner.Attribute.String,s      );
                          O.Str(s);
  ELSE
  END; (* CASE *)
  O.Ln;
 END; (* LOOP *)
 FIL.Close;
 O.Ln;
END DumpTokens;

(************************************************************************************************************************)
PROCEDURE Init*;
VAR dir:ARRAY Strings.cMaxStrLength+1 OF CHAR; 
BEGIN (* Init *)
 IF ARG.TableDir^[0]#0X THEN 
    STR.Copy(dir,ARG.TableDir^); 
    IF dir[STR.Length(dir)-1]#'/' THEN STR.Append(dir,'/'); END; (* IF *)
    STR.Prepend(Scanner.ScanTabName,dir);
    STR.Prepend(Parser .ParsTabName,dir);
    STR.Prepend(ERR    .ErrTabName ,dir);
 END; (* IF *)         
END Init;

(************************************************************************************************************************)
PROCEDURE WrCompiling;
BEGIN (* WrCompiling *)
 O.St2('Compiling ',FIL.ActP^.Modulename^);
 IF FIL.ActP^.SourceDir^[0]#0X THEN O.St3(' (',FIL.ActP^.SourceDir^,')'); END; (* IF *)
 IF ~ARG.OptionShowProcCounter THEN O.Ln; END; (* IF *)
END WrCompiling;

(************************************************************************************************************************)
PROCEDURE ShowCompiling*(table : OB.tOB) : OB.tOB; 
BEGIN (* ShowCompiling *)                         
 WrCompiling;
 IF ARG.OptionShowProcCounter THEN 
    O.Str(' E'); 
    InOut.WriteBf;
 END; (* IF *)
 RETURN table; 
END ShowCompiling;

(************************************************************************************************************************)
PROCEDURE ShowProcCount*(table : OB.tOB) : OB.tOB; 
CONST width=4;
VAR i,n,p:LONGINT; s:ARRAY 2*width+1 OF CHAR; 
BEGIN (* ShowProcCount *)      
 IF ARG.OptionShowProcCounter THEN 
    INC(FIL.ActP^.ProcCount); n:=FIL.ActP^.ProcCount; 
   
    IF n>1 THEN 
       FOR i:=0 TO width-1 DO s[i]:=O.BS; END; (* FOR *) 
       p:=width; 
    ELSE 
       p:=0; 
    END; (* IF *)
   
    s[p+width]:=0X; 
    FOR i:=p+width-1 TO p BY -1 DO
     s[i]:=CHR(48+(n MOD 10)); n:=n DIV 10; 
    END; (* FOR *)                        
    O.Str(s); InOut.WriteBf;
 END; (* IF *)
 RETURN table; 
END ShowProcCount;

(************************************************************************************************************************)
BEGIN (* DRV *)
 ProgramReturnCode:=0; 
END DRV.

