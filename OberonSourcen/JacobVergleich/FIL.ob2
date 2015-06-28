MODULE FIL;

IMPORT Storage,ARG,BasicIO,Base,ErrLists,Idents,IO,O,OB,Scanner,STR,Strings,Strings1,SYSTEM,SysLib,Tree,UTI;

CONST  Extension*      = '.ob2';
       ErrorExtension* = '_errors';
TYPE   tElemPtr*       = POINTER TO tElem;
       tElem*          = RECORD
                         SourceDir*    ,
                         Filename*     ,
                         Modulename*   : STR.tStr;                                                (* Empty, if stdinput is used   *)
                         ModuleIdent*  : Idents.tIdent;                                           (* NoIdent, if stdinput is used *)
                         SourceTime*   ,
                         ObjectTime*   : SysLib.timeT;
                         IsForeign*    : BOOLEAN; 
                         TreeRoot*     : Tree.tTree;
                         MainTable*    ,
                         ModuleEntry*  : OB.tOB;
			 ConstTable*   : Base.tTable;
                         NextLocLabel* :LONGINT; 
                         ErrorList*    : ErrLists.tErrorList;
                         ProcCount*    : LONGINT; 
                         nofSpills*    ,
                         nofLRs*       : LONGINT; 
                         PrevP*        : tElemPtr;
                        END;
VAR    ActP*           : tElemPtr;                                                               (* Current active source file   *)
       NestingDepth*   :LONGINT; 

(************************************************************************************************************************)
PROCEDURE FileModificationTime*(fn:ARRAY OF CHAR) : SysLib.timeT;
VAR buf:SysLib.Stat;
BEGIN (* FileModificationTime *)
 IF SysLib.stat(SYSTEM.ADR(fn),buf)=0 THEN 
    RETURN buf.stMtime; 
 ELSE 
    RETURN MIN(INTEGER); 
 END; (* IF *)
END FileModificationTime;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ScanModulename(fn:ARRAY OF CHAR):STR.tStr;
VAR src,dst,high:LONGINT; c:CHAR; mn:ARRAY Strings.cMaxStrLength+1 OF CHAR;
BEGIN (* ScanModulename *)
 src:=Strings1.Length(fn)-5; dst:=0; high:=LEN(mn);

 LOOP
  IF (src<0) OR (dst>=high) THEN EXIT; END; (* IF *)
  CASE CAP(fn[src]) OF
  |'A'..'Z','0'..'9': mn[dst]:=fn[src]; DEC(src); INC(dst);
  ELSE                EXIT;
  END; (* CASE *)
 END; (* LOOP *)

 mn[dst]:=0X; DEC(dst); src:=0;
 WHILE src<dst DO
  c:=mn[src]; mn[src]:=mn[dst]; mn[dst]:=c;
  INC(src); DEC(dst);
 END; (* WHILE *)
 
 RETURN STR.Alloc(mn); 
END ScanModulename;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IsOpen*(moduleIdent:Idents.tIdent) : BOOLEAN;
VAR e:tElemPtr;
BEGIN (* IsOpen *)
 e:=ActP;
 WHILE e#NIL DO
  IF e^.ModuleIdent=moduleIdent THEN RETURN TRUE; END; (* IF *)
  e:=e^.PrevP;
 END; (* WHILE *)

 RETURN FALSE;
END IsOpen;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Open*(Filename:ARRAY OF CHAR) : BOOLEAN;
VAR i,p:LONGINT; dir,dn,fn,on:ARRAY Strings.cMaxStrLength+1 OF CHAR; e:tElemPtr;
BEGIN (* Open *)
 IF Filename[0]=0X THEN 
    IF ActP#NIL THEN RETURN FALSE; END; (* IF *)

    INC(NestingDepth);
    NEW(ActP);
     ActP^.SourceDir    := STR.Alloc(''); 
     ActP^.Filename     := STR.Alloc('<stdinput>');
     ActP^.Modulename   := STR.Alloc(''); 
     ActP^.ModuleIdent  := Idents.NoIdent;
     ActP^.SourceTime   := 0; 
     ActP^.IsForeign    := FALSE; 
     ActP^.ObjectTime   := 0; 
     ActP^.TreeRoot     := NIL;
     ActP^.MainTable    := NIL;
     ActP^.ModuleEntry  := NIL; 
     ActP^.ConstTable   := SYSTEM.VAL(SYSTEM.PTR,NIL); 
     ActP^.NextLocLabel := 0; 
     ActP^.ErrorList    := ErrLists.New();
     ActP^.ProcCount    := 0; 
     ActP^.nofSpills    := 0; 
     ActP^.nofLRs       := 0; 
     ActP^.PrevP        := NIL;
    RETURN TRUE;
 END; (* IF *)

 STR.Copy(fn,Filename);
 p:=Strings1.pos(Extension,fn);
 IF (p=LEN(fn)) OR (fn[p+4]#0X) THEN STR.Append(fn,Extension); END; (* IF *)

 FOR i:=0 TO ARG.ImportDirC-1 DO
  STR.Copy(dir,ARG.ImportDirP^[i]^); 
  IF (dir[0]#0X) & (dir[STR.Length(dir)]#'/') THEN STR.Append(dir,'/'); END; (* IF *)
  STR.Concat(dn,dir,fn); 

  IF BasicIO.Accessible(dn,FALSE) THEN 
     Scanner.BeginFile(dn);
         
     INC(NestingDepth);
     NEW(e);
     e^.SourceDir    := STR.Alloc(dir); 
     e^.Filename     := STR.Alloc(fn); 
     e^.Modulename   := ScanModulename(fn);
     e^.ModuleIdent  := UTI.IdentOf(e^.Modulename^);
     e^.SourceTime   := FileModificationTime(dn); 
     e^.IsForeign    := FALSE; 
     STR.Conc3(on,dir,e^.Modulename^,'.o'); 
     e^.ObjectTime   := FileModificationTime(on); 
     e^.TreeRoot     := NIL;
     e^.MainTable    := NIL;
     e^.ModuleEntry  := NIL; 
     e^.ConstTable   := SYSTEM.VAL(SYSTEM.PTR,NIL); 
     e^.NextLocLabel := 0; 
     e^.ErrorList    := ErrLists.New();
     e^.ProcCount    := 0; 
     e^.nofSpills    := 0; 
     e^.nofLRs       := 0; 
     e^.PrevP        := ActP;
     ActP:=e; Base.Init;
    
     RETURN TRUE;
  END; (* IF BasicIO.Accessible(fn,FALSE) *)
 END; (* FOR i *)
 
 RETURN FALSE; 
END Open;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE WriteErrorFile;
VAR f:IO.tFile; fn:ARRAY 201 OF CHAR; acc:BOOLEAN;
BEGIN (* WriteErrorFile *)
 IF ActP^.ModuleIdent=Idents.NoIdent THEN RETURN; END;

 STR.Conc3(fn,ActP^.SourceDir^,ActP^.Filename^,ErrorExtension);
 acc:=BasicIO.Accessible(fn,TRUE);

 IF ErrLists.Length(ActP^.ErrorList)=0 THEN 
    IF acc THEN BasicIO.Erase(fn,acc); END;
 ELSE 
    f:=IO.WriteOpen(fn);
    ErrLists.Write(f,ActP^.ErrorList,'');
    IO.WriteClose(f);

    IF ~ARG.OptionEagerErrorMsgs THEN 
       STR.Conc3(fn,ActP^.SourceDir^,ActP^.Filename^,': ');
       ErrLists.Write(2,ActP^.ErrorList,fn);
    END; (* IF *)
 END; (* IF *)
END WriteErrorFile;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Close*;
VAR e:tElemPtr;
BEGIN (* Close *)
 IF ActP=NIL THEN RETURN; END;

 WriteErrorFile;

 STR.Free(ActP^.SourceDir); 
 STR.Free(ActP^.Filename); 
 STR.Free(ActP^.Modulename); 
 ErrLists.Kill(ActP^.ErrorList);
(*<<<<<<<<<<<<<<<
 Tree.ReleaseTreeModule;
>>>>>>>>>>>>>>>*)

 e:=ActP; ActP:=ActP^.PrevP;
 Storage.DEALLOCATE(e,SIZE(tElem));
 DEC(NestingDepth);
END Close;

(*------------------------------------------------------------------------------------------------------------------------------*)
BEGIN (* FIL *)
 ActP         := NIL;
 NestingDepth := 0;
END FIL.


