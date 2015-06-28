MODULE OD;








IMPORT SYSTEM, System, IO, OB,
(* line 23 "OD.pum" *)
 ARG           ,
	       BL            ,
               ED            ,
               Idents        ,
               O             ,
               OT            ,
               PR            ,
               STR           ,
               T             ,
               StringMem,
               UTI           ;

        TYPE   tIdent        = Idents.tIdent;
               tStringRef    = StringMem.tStringRef;
               STRING        = ARRAY 101 OF CHAR; 
        TYPE   tLabel        = OB.tLabel;
        CONST  AddressWidth  = 4;
               SizeWidth     = 4;
        VAR    E             : ED.tEditor;
               ModuleIdent   : tIdent;

(* line 21 "OD.pum" *)
 VAR    MaxLineLength* :INTEGER; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;

PROCEDURE^DumpExportModeOfEntry (yyP6: OB.tOB);
PROCEDURE^DumpFields (f: OB.tOB);
PROCEDURE^DumpTypeReprList (e: OB.tOB);
PROCEDURE^DumpFieldTable (f: OB.tOB);
PROCEDURE^DumpBoundProcEntry (yyP5: OB.tOB);
PROCEDURE^DumpTypeSize (type: OB.tOB);
PROCEDURE^DumpBlocklist (bl: OB.tOB);
PROCEDURE^DumpType (o: OB.tOB; TypeIdent: tIdent);
PROCEDURE^DumpIdentOfEntry (o: OB.tOB);
PROCEDURE^DumpRanges (o: OB.tOB);
PROCEDURE^DumpOB (o: OB.tOB);
PROCEDURE^DumpOB0 (o: OB.tOB);
PROCEDURE^DumpObject (o: OB.tOB);

        PROCEDURE MaxSC(a, b : INTEGER) : INTEGER;
        BEGIN
         IF a>b THEN RETURN a; ELSE RETURN b; END; 
        END MaxSC; 








































































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module OD, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE WrObjName* (yyP1: OB.tOB);
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN; END;

  CASE yyP1^.Kind OF
  | OB.mtEntry:
(* line 49 "OD.pum" *)
(* line 49 "OD.pum" *)
       O.Str('<mtEntry>'); ;
      RETURN;

  | OB.ErrorEntry:
(* line 50 "OD.pum" *)
(* line 50 "OD.pum" *)
       O.Str('<ErrorEntry>'); ;
      RETURN;

  | OB.ModuleEntry:
(* line 51 "OD.pum" *)
(* line 52 "OD.pum" *)
       O.Ident(yyP1^.ModuleEntry.name); ;
      RETURN;

  | OB.DataEntry
  , OB.ServerEntry
  , OB.ConstEntry
  , OB.TypeEntry
  , OB.VarEntry
  , OB.ProcedureEntry
  , OB.BoundProcEntry
  , OB.InheritedProcEntry:
(* line 51 "OD.pum" *)
(* line 52 "OD.pum" *)
       O.Ident(yyP1^.DataEntry.ident); ;
      RETURN;

  | OB.mtTypeRepr:
(* line 53 "OD.pum" *)
(* line 53 "OD.pum" *)
       O.Str('<mtTypeRepr>'); ;
      RETURN;

  | OB.ErrorTypeRepr:
(* line 54 "OD.pum" *)
(* line 54 "OD.pum" *)
       O.Str('<ErrorTypeRepr>'); ;
      RETURN;

  | OB.TypeRepr
  , OB.ForwardTypeRepr
  , OB.NilTypeRepr
  , OB.ByteTypeRepr
  , OB.PtrTypeRepr
  , OB.BooleanTypeRepr
  , OB.CharTypeRepr
  , OB.CharStringTypeRepr
  , OB.StringTypeRepr
  , OB.SetTypeRepr
  , OB.IntTypeRepr
  , OB.ShortintTypeRepr
  , OB.IntegerTypeRepr
  , OB.LongintTypeRepr
  , OB.FloatTypeRepr
  , OB.RealTypeRepr
  , OB.LongrealTypeRepr
  , OB.ArrayTypeRepr
  , OB.RecordTypeRepr
  , OB.PointerTypeRepr
  , OB.ProcedureTypeRepr
  , OB.PreDeclProcTypeRepr
  , OB.CaseFaultTypeRepr
  , OB.WithFaultTypeRepr
  , OB.AbsTypeRepr
  , OB.AshTypeRepr
  , OB.CapTypeRepr
  , OB.ChrTypeRepr
  , OB.EntierTypeRepr
  , OB.LenTypeRepr
  , OB.LongTypeRepr
  , OB.MaxTypeRepr
  , OB.MinTypeRepr
  , OB.OddTypeRepr
  , OB.OrdTypeRepr
  , OB.ShortTypeRepr
  , OB.SizeTypeRepr
  , OB.AssertTypeRepr
  , OB.CopyTypeRepr
  , OB.DecTypeRepr
  , OB.ExclTypeRepr
  , OB.HaltTypeRepr
  , OB.IncTypeRepr
  , OB.InclTypeRepr
  , OB.NewTypeRepr
  , OB.SysAdrTypeRepr
  , OB.SysBitTypeRepr
  , OB.SysCcTypeRepr
  , OB.SysLshTypeRepr
  , OB.SysRotTypeRepr
  , OB.SysValTypeRepr
  , OB.SysGetTypeRepr
  , OB.SysPutTypeRepr
  , OB.SysGetregTypeRepr
  , OB.SysPutregTypeRepr
  , OB.SysMoveTypeRepr
  , OB.SysNewTypeRepr
  , OB.SysAsmTypeRepr:
(* line 55 "OD.pum" *)
(* line 55 "OD.pum" *)
      WrObjName (yyP1^.TypeRepr.entry);
      RETURN;

  ELSE END;

(* line 56 "OD.pum" *)
(* line 56 "OD.pum" *)
       O.Str('<OB>'); ;
      RETURN;

 END WrObjName;

PROCEDURE MaxIdentLen (yyP2: OB.tOB): INTEGER;
 BEGIN
  IF OB.IsType (yyP2, OB.DataEntry) THEN
  IF (yyIsEqual ( yyP2^.DataEntry.declStatus ,   OB.DECLARED ) ) THEN
(* line 60 "OD.pum" *)
      RETURN MaxSC(SHORT(UTI.IdentLength(yyP2^.DataEntry.ident)),MaxIdentLen(yyP2^.DataEntry.prevEntry));

  END;
(* line 61 "OD.pum" *)
      RETURN MaxSC(2+SHORT(UTI.IdentLength(yyP2^.DataEntry.ident)),MaxIdentLen(yyP2^.DataEntry.prevEntry));

  END;
  IF OB.IsType (yyP2, OB.Entry) THEN
(* line 62 "OD.pum" *)
      RETURN MaxIdentLen (yyP2^.Entry.prevEntry);

  END;
(* line 63 "OD.pum" *)
      RETURN 0;

 END MaxIdentLen;

PROCEDURE MaxIdentLen0 (yyP3: OB.tOB): INTEGER;
 BEGIN
  IF OB.IsType (yyP3, OB.DataEntry) THEN
  IF (yyIsEqual ( yyP3^.DataEntry.declStatus ,   OB.DECLARED ) ) THEN
(* line 67 "OD.pum" *)
      RETURN MaxSC(SHORT(UTI.IdentLength(yyP3^.DataEntry.ident)),MaxIdentLen0(yyP3^.DataEntry.prevEntry));

  END;
(* line 68 "OD.pum" *)
      RETURN MaxSC(2+SHORT(UTI.IdentLength(yyP3^.DataEntry.ident)),MaxIdentLen0(yyP3^.DataEntry.prevEntry));

  END;
(* line 69 "OD.pum" *)
      RETURN 0;

 END MaxIdentLen0;

PROCEDURE IsEmpty (yyP4: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN FALSE; END;
  IF yyP4 = NIL THEN
(* line 73 "OD.pum" *)
      RETURN TRUE;

  END;

  CASE yyP4^.Kind OF
  | OB.mtObject:
(* line 74 "OD.pum" *)
      RETURN TRUE;

  | OB.mtEntry:
(* line 75 "OD.pum" *)
      RETURN TRUE;

  | OB.mtTypeReprList:
(* line 76 "OD.pum" *)
      RETURN TRUE;

  | OB.mtTypeRepr:
(* line 77 "OD.pum" *)
      RETURN TRUE;

  | OB.mtSignature:
(* line 78 "OD.pum" *)
      RETURN TRUE;

  | OB.mtValue:
(* line 79 "OD.pum" *)
      RETURN TRUE;

  | OB.mtLabelRange:
(* line 80 "OD.pum" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsEmpty;

PROCEDURE DumpLabelRange* (s: STRING; o: OB.tOB);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
(* line 84 "OD.pum" *)
(* line 84 "OD.pum" *)
      
    E:=ED.Create();

    ED.Text(E,s);
    ED.CR(E);

    DumpRanges(o);

    ED.Dump(E);
    ED.Kill(E);
 ;
      RETURN;

 END DumpLabelRange;

PROCEDURE DumpRanges (o: OB.tOB);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
  IF (o^.Kind = OB.mtLabelRange) THEN
(* line 100 "OD.pum" *)
(* line 100 "OD.pum" *)
      
    ED.Text(E,'<EmptyLabelRange>');
    ED.CR(E);
 ;
      RETURN;

  END;
  IF (o^.Kind = OB.CharRange) THEN
(* line 106 "OD.pum" *)
(* line 106 "OD.pum" *)
      
    ED.Text(E,'['); ED.Char(E,o^.CharRange.a); ED.Text(E,'..'); ED.Char(E,o^.CharRange.b); ED.Text(E,']');
    ED.CR(E);

    IF ~IsEmpty(o^.CharRange.Next) THEN DumpRanges(o^.CharRange.Next); END; (* IF *)
 ;
      RETURN;

  END;
  IF (o^.Kind = OB.IntegerRange) THEN
(* line 114 "OD.pum" *)
(* line 114 "OD.pum" *)
      
    ED.Text(E,'['); ED.Longint(E,o^.IntegerRange.a); ED.Text(E,'..'); ED.Longint(E,o^.IntegerRange.b); ED.Text(E,']');
    ED.CR(E);

    IF ~IsEmpty(o^.IntegerRange.Next) THEN DumpRanges(o^.IntegerRange.Next); END; (* IF *)
 ;
      RETURN;

  END;
 END DumpRanges;

PROCEDURE DumpTable* (moduleIdent: tIdent; o: OB.tOB; text: tStringRef; ident: tIdent);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
(* line 126 "OD.pum" *)
(* line 126 "OD.pum" *)
      
    E:=ED.Create();
    ModuleIdent:=moduleIdent;

    ED.CR(E);
    ED.String(E,text);
    ED.Text(E,' ');
    ED.Ident(E,ident);
    ED.CR(E);

    ED.SetTab(E,1,2+MaxIdentLen(o));
    ED.Line(E);
    DumpOB(o);
    ED.Line(E);

    ED.Dump(E);
    ED.Kill(E);
 ;
      RETURN;

 END DumpTable;

PROCEDURE DumpTable0* (moduleIdent: tIdent; o: OB.tOB; text: tStringRef; ident: tIdent);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
(* line 150 "OD.pum" *)
(* line 150 "OD.pum" *)
      
    E:=ED.Create();
    ModuleIdent:=moduleIdent;

    ED.CR(E);
    ED.String(E,text);
    ED.Text(E,' ');
    ED.Ident(E,ident);
    ED.CR(E);

    ED.SetTab(E,1,2+MaxIdentLen0(o));
    ED.Line(E);
    DumpOB0(o);
    ED.Line(E);

    ED.Dump(E);
    ED.Kill(E);
 ;
      RETURN;

 END DumpTable0;

PROCEDURE DumpOB (o: OB.tOB);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
  IF (o^.Kind = OB.ScopeEntry) THEN
(* line 172 "OD.pum" *)
(* line 172 "OD.pum" *)
      
    DumpOB(o^.ScopeEntry.prevEntry);
    ED.Line(E);
 ;
      RETURN;

  END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 177 "OD.pum" *)
(* line 177 "OD.pum" *)
      
    IF ~IsEmpty(o^.DataEntry.prevEntry) THEN DumpOB(o^.DataEntry.prevEntry); END; (* IF *)
    DumpObject(o);
 ;
      RETURN;

  END;
 END DumpOB;

PROCEDURE DumpOB0 (o: OB.tOB);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 185 "OD.pum" *)
(* line 185 "OD.pum" *)
      
    IF ~IsEmpty(o^.DataEntry.prevEntry) THEN DumpOB0(o^.DataEntry.prevEntry); END; (* IF *)
    DumpObject(o);
 ;
      RETURN;

  END;
 END DumpOB0;

PROCEDURE ObjectDumped* (s: STRING; o: OB.tOB): OB.tOB;
 BEGIN
(* line 192 "OD.pum" *)
(* line 192 "OD.pum" *)
      
    E:=ED.Create();
    ModuleIdent:=Idents.NoIdent;

    ED.Text(E,s);
    ED.CR(E);

    DumpObject(o);
    ED.CR(E);

    ED.Dump(E);
    ED.Kill(E);
 ;
      RETURN o;

 END ObjectDumped;

PROCEDURE DumpObject (o: OB.tOB);
(* line 208 "OD.pum" *)
 VAR arr:ARRAY 21 OF CHAR; 
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
  IF o = NIL THEN
(* line 211 "OD.pum" *)
(* line 211 "OD.pum" *)
      
    ED.Text(E,'<NoObject>');
 ;
      RETURN;

  END;

  CASE o^.Kind OF
  | OB.ServerEntry:
(* line 216 "OD.pum" *)
(* line 216 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    ED.Text(E,' SERVER    ');
    ED.Ident(E,o^.ServerEntry.serverId);
    ED.CR(E);
 ;
      RETURN;

  | OB.ConstEntry:
(* line 224 "OD.pum" *)
(* line 224 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    ED.Text(E,' CONST     ');

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.ConstEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.ConstEntry.typeRepr,Idents.NoIdent);

    ED.Text(E,' = ');
    DumpObject(o^.ConstEntry.value);
    ED.CR(E);
    
(*<<<<<<<<<<<<<<<
    IF o^.ConstEntry.label#OB.NOLABEL
       THEN ED.Text(E,'           ');
            ED.String(E,o^.ConstEntry.label); 
            ED.CR(E);
    END; (* IF *)
>>>>>>>>>>>>>>>*)
 ;
      RETURN;

  | OB.TypeEntry:
(* line 245 "OD.pum" *)
(* line 245 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    ED.Text(E,' TYPE      ');

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.TypeEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)

    DumpTypeSize(o^.TypeEntry.typeRepr);

    DumpType(o^.TypeEntry.typeRepr,o^.TypeEntry.ident);
    ED.CR(E);      
    
    IF ARG.OptionShowBlocklists THEN 
       ED.Tab(E,1);
       ED.Text(E,'  PtrBL     ');
       ED.IndentCur(E);
       DumpBlocklist(BL.PtrBlocklistOfType(o^.TypeEntry.typeRepr)); 
       ED.Undent(E);
       ED.CR(E); 

       ED.Tab(E,1);
       ED.Text(E,'  ProcBL    ');
       ED.IndentCur(E);
       DumpBlocklist(BL.ProcBlocklistOfType(o^.TypeEntry.typeRepr)); 
       ED.Undent(E);
       ED.CR(E); 
    END; (* IF *)
 ;
      RETURN;

  | OB.VarEntry:
(* line 274 "OD.pum" *)
(* line 274 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    IF o^.VarEntry.isReceiverPar
       THEN ED.Text(E,' RECEIVER  ');
    ELSIF o^.VarEntry.isParam
       THEN IF o^.VarEntry.parMode=OB.VALPAR
               THEN ED.Text(E,' VALPARAM  ');
               ELSE ED.Text(E,' REFPARAM  ');
            END; (* IF *)
       ELSE ED.Text(E,' VAR       ');
    END; (* IF *)

    DumpTypeSize(o^.VarEntry.typeRepr);

    IF ARG.OptionShowVarAddrs
       THEN ED.Text(E,'A=');
            UTI.Longint2Arr(o^.VarEntry.address,arr); STR.DoRb(arr,AddressWidth); 
            ED.Text(E,arr);
            ED.Text(E,' ');

            IF o^.VarEntry.refMode=OB.VALPAR
               THEN ED.Text(E,' VAL ');
               ELSE ED.Text(E,' REF ');
            END; (* IF *)
    END; (* IF *)

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.VarEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.VarEntry.typeRepr,Idents.NoIdent);
    ED.CR(E);

    IF ARG.OptionShowBlocklists & (o^.VarEntry.level>0) THEN 
       ED.Tab(E,1);
       ED.Text(E,' PtrBL     ');
       ED.IndentCur(E);
       DumpBlocklist(BL.PtrBlocklistOfType(o^.VarEntry.typeRepr)); 
       ED.Undent(E);

       ED.Tab(E,1);
       ED.Text(E,'  ProcBL    ');
       ED.IndentCur(E);
       DumpBlocklist(BL.ProcBlocklistOfType(o^.VarEntry.typeRepr)); 
       ED.Undent(E);
       ED.CR(E); 
    END; (* IF *)
 ;
      RETURN;

  | OB.ProcedureEntry:
(* line 321 "OD.pum" *)
(* line 321 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    ED.Text(E,' PROCEDURE ');

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.ProcedureEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.ProcedureEntry.typeRepr,Idents.NoIdent);
    IF ~o^.ProcedureEntry.complete THEN ED.Text(E,' <uncomplete>'); END; (* IF *)
    ED.CR(E);
 ;
      RETURN;

  | OB.BoundProcEntry:
(* line 332 "OD.pum" *)
(* line 332 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    ED.Text(E,' BOUND     ');

    IF ARG.OptionShowProcNums THEN 
       ED.Longint(E,o^.BoundProcEntry.procNum); 
       ED.Text(E,' '); 
    END; (* IF *)

    DumpObject(o^.BoundProcEntry.receiverSig);
    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.BoundProcEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.BoundProcEntry.typeRepr,Idents.NoIdent);
    IF ~o^.BoundProcEntry.complete THEN ED.Text(E,' <uncomplete>'); END; (* IF *)

    IF ARG.OptionShowProcNums & ~IsEmpty(o^.BoundProcEntry.redefinedProc) THEN 
       ED.Text(E,' redefines '); 
       DumpBoundProcEntry(o^.BoundProcEntry.redefinedProc);
    END; (* IF *)

    ED.CR(E);
 ;
      RETURN;

  | OB.InheritedProcEntry:
  IF (o^.InheritedProcEntry.boundProcEntry^.Kind = OB.BoundProcEntry) THEN
(* line 355 "OD.pum" *)
(* line 357 "OD.pum" *)
      
    DumpIdentOfEntry(o);
    ED.Text(E,' INHERITED ');

    IF ARG.OptionShowProcNums THEN 
       ED.Longint(E,o^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.procNum); 
       ED.Text(E,' '); 
    END; (* IF *)

    DumpObject(o^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.receiverSig);
    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.typeRepr,Idents.NoIdent);
    IF ~o^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.complete THEN ED.Text(E,' <uncomplete>'); END; (* IF *)
    ED.CR(E);
 ;
      RETURN;

  END;
  | OB.TypeReprs
  , OB.mtTypeRepr
  , OB.ErrorTypeRepr
  , OB.TypeRepr
  , OB.ForwardTypeRepr
  , OB.NilTypeRepr
  , OB.ByteTypeRepr
  , OB.PtrTypeRepr
  , OB.BooleanTypeRepr
  , OB.CharTypeRepr
  , OB.CharStringTypeRepr
  , OB.StringTypeRepr
  , OB.SetTypeRepr
  , OB.IntTypeRepr
  , OB.ShortintTypeRepr
  , OB.IntegerTypeRepr
  , OB.LongintTypeRepr
  , OB.FloatTypeRepr
  , OB.RealTypeRepr
  , OB.LongrealTypeRepr
  , OB.ArrayTypeRepr
  , OB.RecordTypeRepr
  , OB.PointerTypeRepr
  , OB.ProcedureTypeRepr
  , OB.PreDeclProcTypeRepr
  , OB.CaseFaultTypeRepr
  , OB.WithFaultTypeRepr
  , OB.AbsTypeRepr
  , OB.AshTypeRepr
  , OB.CapTypeRepr
  , OB.ChrTypeRepr
  , OB.EntierTypeRepr
  , OB.LenTypeRepr
  , OB.LongTypeRepr
  , OB.MaxTypeRepr
  , OB.MinTypeRepr
  , OB.OddTypeRepr
  , OB.OrdTypeRepr
  , OB.ShortTypeRepr
  , OB.SizeTypeRepr
  , OB.AssertTypeRepr
  , OB.CopyTypeRepr
  , OB.DecTypeRepr
  , OB.ExclTypeRepr
  , OB.HaltTypeRepr
  , OB.IncTypeRepr
  , OB.InclTypeRepr
  , OB.NewTypeRepr
  , OB.SysAdrTypeRepr
  , OB.SysBitTypeRepr
  , OB.SysCcTypeRepr
  , OB.SysLshTypeRepr
  , OB.SysRotTypeRepr
  , OB.SysValTypeRepr
  , OB.SysGetTypeRepr
  , OB.SysPutTypeRepr
  , OB.SysGetregTypeRepr
  , OB.SysPutregTypeRepr
  , OB.SysMoveTypeRepr
  , OB.SysNewTypeRepr
  , OB.SysAsmTypeRepr:
(* line 374 "OD.pum" *)
(* line 374 "OD.pum" *)
      
    DumpType(o,Idents.NoIdent);
 ;
      RETURN;

  | OB.Signature:
(* line 379 "OD.pum" *)
(* line 379 "OD.pum" *)
      

    IF o^.Signature.VarEntry^.VarEntry.parMode=OB.REFPAR THEN ED.Text(E,'VAR '); END; (* IF *)
    IF o^.Signature.VarEntry^.VarEntry.ident#Idents.NoIdent
       THEN ED.Ident(E,o^.Signature.VarEntry^.VarEntry.ident);
            ED.Text(E,':');
    END; (* IF *)

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.Signature.VarEntry^.VarEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.Signature.VarEntry^.VarEntry.typeRepr,Idents.NoIdent);

    IF ~IsEmpty(o^.Signature.next)
       THEN IF o^.Signature.VarEntry^.VarEntry.ident#Idents.NoIdent
               THEN ED.Text(E,'; ');
               ELSE ED.Text(E,',');
            END; (* IF *)
            DumpObject(o^.Signature.next);
    END; (* IF *)
 ;
      RETURN;

  | OB.mtValue:
(* line 400 "OD.pum" *)
(* line 400 "OD.pum" *)
      
    ED.Text(E,'<EmptyValue>');
 ;
      RETURN;

  | OB.ErrorValue:
(* line 405 "OD.pum" *)
(* line 405 "OD.pum" *)
      
    ED.Text(E,'<?Value>');
 ;
      RETURN;

  | OB.BooleanValue:
(* line 410 "OD.pum" *)
(* line 410 "OD.pum" *)
      
    ED.Boolean(E,o^.BooleanValue.v);
 ;
      RETURN;

  | OB.CharValue:
(* line 415 "OD.pum" *)
(* line 415 "OD.pum" *)
      
    ED.Char(E,o^.CharValue.v);
 ;
      RETURN;

  | OB.StringValue:
(* line 420 "OD.pum" *)
(* line 420 "OD.pum" *)
      
    ED.String(E,o^.StringValue.v);
 ;
      RETURN;

  | OB.SetValue:
(* line 425 "OD.pum" *)
(* line 425 "OD.pum" *)
      
    ED.Set(E,o^.SetValue.v);
 ;
      RETURN;

  | OB.IntegerValue:
(* line 430 "OD.pum" *)
(* line 430 "OD.pum" *)
      
    IF    o^.IntegerValue.v=OT.MINoSHORTINT THEN ED.Text(E,'MIN(SHORTINT)');
    ELSIF o^.IntegerValue.v=OT.MAXoSHORTINT THEN ED.Text(E,'MAX(SHORTINT)');
    ELSIF o^.IntegerValue.v=OT.MINoINTEGER  THEN ED.Text(E,'MIN(INTEGER)');
    ELSIF o^.IntegerValue.v=OT.MAXoINTEGER  THEN ED.Text(E,'MAX(INTEGER)');
    ELSIF o^.IntegerValue.v=OT.MINoLONGINT  THEN ED.Text(E,'MIN(LONGINT)');
    ELSIF o^.IntegerValue.v=OT.MAXoLONGINT  THEN ED.Text(E,'MAX(LONGINT)');
                            ELSE ED.Longint(E,o^.IntegerValue.v);
    END; (* IF *)
 ;
      RETURN;

  | OB.RealValue:
(* line 442 "OD.pum" *)
(* line 442 "OD.pum" *)
      
    IF    o^.RealValue.v=OT.MINoREAL THEN ED.Text(E,'MIN(REAL)');
    ELSIF o^.RealValue.v=OT.MAXoREAL THEN ED.Text(E,'MAX(REAL)');
                        ELSE ED.Real(E,o^.RealValue.v);
    END; (* IF *)
 ;
      RETURN;

  | OB.LongrealValue:
(* line 450 "OD.pum" *)
(* line 450 "OD.pum" *)
      
    IF    OT.EqualoLONGREAL(o^.LongrealValue.v,OT.MINoLONGREAL) THEN ED.Text(E,'MIN(LONGREAL)');
    ELSIF OT.EqualoLONGREAL(o^.LongrealValue.v,OT.MAXoLONGREAL) THEN ED.Text(E,'MAX(LONGREAL)');
                                               ELSE ED.Longreal(E,o^.LongrealValue.v);
    END; (* IF *)
 ;
      RETURN;

  | OB.NilValue:
(* line 458 "OD.pum" *)
(* line 458 "OD.pum" *)
       ED.Text(E,'<NIL>'  ); ;
      RETURN;

  | OB.NilPointerValue:
(* line 459 "OD.pum" *)
(* line 459 "OD.pum" *)
       ED.Text(E,'NIL'    ); ;
      RETURN;

  | OB.NilProcedureValue:
(* line 460 "OD.pum" *)
(* line 460 "OD.pum" *)
       ED.Text(E,'NILPROC'); ;
      RETURN;

  ELSE END;

 END DumpObject;

PROCEDURE DumpType (o: OB.tOB; TypeIdent: tIdent);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
  IF (o^.Kind = OB.mtTypeRepr) THEN
(* line 466 "OD.pum" *)
(* line 466 "OD.pum" *)
      
    ED.Text(E,'<EmptyType>');
 ;
      RETURN;

  END;
  IF (o^.Kind = OB.ErrorTypeRepr) THEN
(* line 471 "OD.pum" *)
(* line 471 "OD.pum" *)
      
    ED.Text(E,'<ErrorType>');
 ;
      RETURN;

  END;
  IF OB.IsType (o, OB.TypeRepr) THEN
  IF (o^.TypeRepr.entry^.Kind = OB.TypeEntry) THEN
(* line 476 "OD.pum" *)
   LOOP
(* line 477 "OD.pum" *)
      IF ~((o^.TypeRepr.entry^.TypeEntry.level <= 0) OR (o^.TypeRepr.entry^.TypeEntry.ident # TypeIdent)) THEN EXIT; END;
(* line 478 "OD.pum" *)
      
    IF (o^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name#ModuleIdent) & (o^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name#Idents.NoIdent) & (o^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name#PR.IdentPREDECL) THEN 
       ED.Ident(E,o^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name); ED.Text(E,'$');
    END; (* IF *)
    ED.Ident(E,o^.TypeRepr.entry^.TypeEntry.ident);
 ;
      RETURN;
   END;

  END;
  END;

  CASE o^.Kind OF
  | OB.NilTypeRepr:
(* line 486 "OD.pum" *)
(* line 486 "OD.pum" *)
      
    ED.Text(E,'<NIL>');
 ;
      RETURN;

  | OB.ForwardTypeRepr:
(* line 491 "OD.pum" *)
(* line 491 "OD.pum" *)
      
    ED.Text(E,'<Forward>');
 ;
      RETURN;

  | OB.CharStringTypeRepr:
(* line 496 "OD.pum" *)
(* line 496 "OD.pum" *)
      
    ED.Text(E,'<Char>');
 ;
      RETURN;

  | OB.StringTypeRepr:
(* line 501 "OD.pum" *)
(* line 501 "OD.pum" *)
      
    ED.Text(E,'<String>');
 ;
      RETURN;

  | OB.ArrayTypeRepr:
(* line 506 "OD.pum" *)
(* line 506 "OD.pum" *)
      
    ED.Text(E,'ARRAY ');
    IF o^.ArrayTypeRepr.len>0 THEN ED.Longint(E,o^.ArrayTypeRepr.len); ED.Text(E,' '); END; (* IF *)
    ED.Text(E,'OF ');

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.ArrayTypeRepr.elemTypeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.ArrayTypeRepr.elemTypeRepr,Idents.NoIdent);
 ;
      RETURN;

  | OB.RecordTypeRepr:
(* line 516 "OD.pum" *)
(* line 516 "OD.pum" *)
      
    ED.IndentCur(E);
    ED.Text(E,'RECORD');
    IF ~IsEmpty(o^.RecordTypeRepr.baseTypeRepr) THEN 
       ED.Text(E,'(');

       IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.RecordTypeRepr.baseTypeRepr); ED.Text(E,'/'); END; (* IF *)
       DumpType(o^.RecordTypeRepr.baseTypeRepr,Idents.NoIdent);
       ED.Text(E,')');
    END; (* IF *)
    ED.CR(E);

    ED.Indent(E,1);
    DumpFieldTable(o^.RecordTypeRepr.fields);
    ED.Undent(E);

    ED.Text(E,'END');

    IF ~IsEmpty(o^.RecordTypeRepr.extTypeReprList) THEN 
       ED.CR(E);
       ED.Text(E,'(-->');
       DumpTypeReprList(o^.RecordTypeRepr.extTypeReprList);
       ED.Text(E,')');
       ED.CR(E);
    END; (* IF *)

    IF ARG.OptionShowProcNums THEN 
       ED.Text(E,'nofBoundProcs='); 
       ED.Longint(E,o^.RecordTypeRepr.nofBoundProcs); 
    END; (* IF *)

    ED.Undent(E);
 ;
      RETURN;

  | OB.PointerTypeRepr:
  IF (o^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 551 "OD.pum" *)
(* line 551 "OD.pum" *)
      
    ED.Text(E,'POINTER TO ');

    IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr); ED.Text(E,'/'); END; (* IF *)
    DumpType(o^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr,Idents.NoIdent);
 ;
      RETURN;

  END;
(* line 559 "OD.pum" *)
(* line 559 "OD.pum" *)
      
    ED.Text(E,'POINTER TO ?');
 ;
      RETURN;

  | OB.CaseFaultTypeRepr:
(* line 564 "OD.pum" *)
(* line 564 "OD.pum" *)
       ED.Text(E, ';'                                                       ); ;
      RETURN;

  | OB.WithFaultTypeRepr:
(* line 565 "OD.pum" *)
(* line 565 "OD.pum" *)
       ED.Text(E, ';'                                                       ); ;
      RETURN;

  | OB.AbsTypeRepr:
(* line 566 "OD.pum" *)
(* line 566 "OD.pum" *)
       ED.Text(E, '(<Numeric>) : <Numeric>;'                                ); ;
      RETURN;

  | OB.AshTypeRepr:
(* line 567 "OD.pum" *)
(* line 567 "OD.pum" *)
       ED.Text(E, '(<Integer>) : LONGINT;'                                  ); ;
      RETURN;

  | OB.CapTypeRepr:
(* line 568 "OD.pum" *)
(* line 568 "OD.pum" *)
       ED.Text(E, '(CHAR) : CHAR;'                                          ); ;
      RETURN;

  | OB.ChrTypeRepr:
(* line 569 "OD.pum" *)
(* line 569 "OD.pum" *)
       ED.Text(E, '(<Integer>) : CHAR;'                                     ); ;
      RETURN;

  | OB.EntierTypeRepr:
(* line 570 "OD.pum" *)
(* line 570 "OD.pum" *)
       ED.Text(E, '(<Real>) : LONGINT;'                                     ); ;
      RETURN;

  | OB.LenTypeRepr:
(* line 571 "OD.pum" *)
(* line 571 "OD.pum" *)
       ED.Text(E, '(VAR ARRAY OF SYSTEM$BYTE[,<Integer>]) : LONGINT;'       ); ;
      RETURN;

  | OB.LongTypeRepr:
(* line 572 "OD.pum" *)
(* line 572 "OD.pum" *)
       ED.Text(E, '(<Shortint,Integer,Real>) : <Integer,Longint,Longreal>;' ); ;
      RETURN;

  | OB.MaxTypeRepr:
(* line 573 "OD.pum" *)
(* line 573 "OD.pum" *)
       ED.Text(E, '(<Type>) : <Generic>;'                                   ); ;
      RETURN;

  | OB.MinTypeRepr:
(* line 574 "OD.pum" *)
(* line 574 "OD.pum" *)
       ED.Text(E, '(<Type>) : <Generic>;'                                   ); ;
      RETURN;

  | OB.OddTypeRepr:
(* line 575 "OD.pum" *)
(* line 575 "OD.pum" *)
       ED.Text(E, '(<Integer>) : BOOLEAN;'                                  ); ;
      RETURN;

  | OB.OrdTypeRepr:
(* line 576 "OD.pum" *)
(* line 576 "OD.pum" *)
       ED.Text(E, '(CHAR) : INTEGER;'                                       ); ;
      RETURN;

  | OB.ShortTypeRepr:
(* line 577 "OD.pum" *)
(* line 577 "OD.pum" *)
       ED.Text(E, '(<Integer,Longint,Longreal>) : <Shortint,Integer,Real>;' ); ;
      RETURN;

  | OB.SizeTypeRepr:
(* line 578 "OD.pum" *)
(* line 578 "OD.pum" *)
       ED.Text(E, '(<Type>) : <Integer>;'                                   ); ;
      RETURN;

  | OB.AssertTypeRepr:
(* line 579 "OD.pum" *)
(* line 579 "OD.pum" *)
       ED.Text(E, '(<Integer>[,<Integer>]);'                                ); ;
      RETURN;

  | OB.CopyTypeRepr:
(* line 580 "OD.pum" *)
(* line 580 "OD.pum" *)
       ED.Text(E, '(ARRAY OF CHAR,VAR ARRAY OF CHAR);'                      ); ;
      RETURN;

  | OB.DecTypeRepr:
(* line 581 "OD.pum" *)
(* line 581 "OD.pum" *)
       ED.Text(E, '(VAR <Integer>[,<Integer>]);'                            ); ;
      RETURN;

  | OB.ExclTypeRepr:
(* line 582 "OD.pum" *)
(* line 582 "OD.pum" *)
       ED.Text(E, '(VAR SET, <Integer>);'                                   ); ;
      RETURN;

  | OB.HaltTypeRepr:
(* line 583 "OD.pum" *)
(* line 583 "OD.pum" *)
       ED.Text(E, '(INTEGER);'                                              ); ;
      RETURN;

  | OB.IncTypeRepr:
(* line 584 "OD.pum" *)
(* line 584 "OD.pum" *)
       ED.Text(E, '(VAR <Integer>[,<Integer>]);'                            ); ;
      RETURN;

  | OB.InclTypeRepr:
(* line 585 "OD.pum" *)
(* line 585 "OD.pum" *)
       ED.Text(E, '(VAR SET, <Integer>);'                                   ); ;
      RETURN;

  | OB.NewTypeRepr:
(* line 586 "OD.pum" *)
(* line 586 "OD.pum" *)
       ED.Text(E, '(<Pointer>{,<Integer>});'                                ); ;
      RETURN;

  | OB.SysAdrTypeRepr:
(* line 587 "OD.pum" *)
(* line 587 "OD.pum" *)
       ED.Text(E, '(VAR ARRAY OF SYSTEM$BYTE) : LONGINT;'                   ); ;
      RETURN;

  | OB.SysBitTypeRepr:
(* line 588 "OD.pum" *)
(* line 588 "OD.pum" *)
       ED.Text(E, '(LONGINT,<Integer>) : BOOLEAN;'                          ); ;
      RETURN;

  | OB.SysCcTypeRepr:
(* line 589 "OD.pum" *)
(* line 589 "OD.pum" *)
       ED.Text(E, '(<Integer>) : BOOLEAN;'                                  ); ;
      RETURN;

  | OB.SysLshTypeRepr:
(* line 590 "OD.pum" *)
(* line 590 "OD.pum" *)
       ED.Text(E, '(<Integer,Char,Byte>,<Integer>) : <Generic>;'            ); ;
      RETURN;

  | OB.SysRotTypeRepr:
(* line 591 "OD.pum" *)
(* line 591 "OD.pum" *)
       ED.Text(E, '(<Integer,Char,Byte>,<Integer>) : <Generic>;'            ); ;
      RETURN;

  | OB.SysValTypeRepr:
(* line 592 "OD.pum" *)
(* line 592 "OD.pum" *)
       ED.Text(E, '(<Type>,VAR ARRAY OF SYSTEM$BYTE) : <Generic>;'          ); ;
      RETURN;

  | OB.SysGetTypeRepr:
(* line 593 "OD.pum" *)
(* line 593 "OD.pum" *)
       ED.Text(E, '(LONGINT,<Generic>);'                                    ); ;
      RETURN;

  | OB.SysPutTypeRepr:
(* line 594 "OD.pum" *)
(* line 594 "OD.pum" *)
       ED.Text(E, '(LONGINT,<Generic>);'                                    ); ;
      RETURN;

  | OB.SysGetregTypeRepr:
(* line 595 "OD.pum" *)
(* line 595 "OD.pum" *)
       ED.Text(E, '(<Integer>,<Generic>);'                                  ); ;
      RETURN;

  | OB.SysPutregTypeRepr:
(* line 596 "OD.pum" *)
(* line 596 "OD.pum" *)
       ED.Text(E, '(<Integer>,<Generic>);'                                  ); ;
      RETURN;

  | OB.SysMoveTypeRepr:
(* line 597 "OD.pum" *)
(* line 597 "OD.pum" *)
       ED.Text(E, '(LONGINT,LONGINT,<Integer>);'                            ); ;
      RETURN;

  | OB.SysNewTypeRepr:
(* line 598 "OD.pum" *)
(* line 598 "OD.pum" *)
       ED.Text(E, '(<Pointer>,<Integer>);'                                  ); ;
      RETURN;

  | OB.SysAsmTypeRepr:
(* line 599 "OD.pum" *)
(* line 599 "OD.pum" *)
       ED.Text(E, '(ARRAY OF CHAR {, ARRAY OF CHAR});'                      ); ;
      RETURN;

  | OB.ProcedureTypeRepr
  , OB.PreDeclProcTypeRepr:
(* line 602 "OD.pum" *)
(* line 602 "OD.pum" *)
      
    ED.Text(E,'(');
    DumpObject(o^.ProcedureTypeRepr.signatureRepr);
    IF IsEmpty(o^.ProcedureTypeRepr.resultType)
       THEN ED.Text(E,')');
       ELSE ED.Text(E,') : ');

            IF ARG.OptionShowTypeAddrs THEN ED.Addr(E,o^.ProcedureTypeRepr.resultType); ED.Text(E,'/'); END; (* IF *)
            DumpType(o^.ProcedureTypeRepr.resultType,Idents.NoIdent);
    END; (* IF *)
 ;
      RETURN;

  ELSE END;

(* line 615 "OD.pum" *)
(* line 615 "OD.pum" *)
      
    ED.Text(E,'?TypeRepr');
 ;
      RETURN;

 END DumpType;

PROCEDURE DumpFieldTable (f: OB.tOB);
 BEGIN
  IF f = OB.NoOB THEN RETURN; END;
(* line 621 "OD.pum" *)
(* line 621 "OD.pum" *)
      
    ED.SetTab(E,1,2+MaxIdentLen0(f));
    DumpFields(f);
 ;
      RETURN;

 END DumpFieldTable;

PROCEDURE DumpFields (f: OB.tOB);
 BEGIN
  IF f = OB.NoOB THEN RETURN; END;
  IF (f^.Kind = OB.ScopeEntry) THEN
(* line 629 "OD.pum" *)
      RETURN;

  END;
  IF OB.IsType (f, OB.DataEntry) THEN
  IF OB.IsType (f^.DataEntry.prevEntry, OB.Entry) THEN
(* line 631 "OD.pum" *)
(* line 631 "OD.pum" *)
      
    IF ~IsEmpty(f^.DataEntry.prevEntry) THEN DumpFields(f^.DataEntry.prevEntry); END; (* IF *)
    DumpObject(f);
 ;
      RETURN;

  END;
  END;
 END DumpFields;

PROCEDURE DumpTypeReprList (e: OB.tOB);
 BEGIN
  IF e = OB.NoOB THEN RETURN; END;
  IF (e^.Kind = OB.TypeReprList) THEN
(* line 638 "OD.pum" *)
(* line 638 "OD.pum" *)
      
    IF ~IsEmpty(e^.TypeReprList.prev)
       THEN DumpTypeReprList(e^.TypeReprList.prev);
            ED.Text(E,',');
    END; (* IF *)
    DumpType(e^.TypeReprList.typeRepr,Idents.NoIdent);
 ;
      RETURN;

  END;
 END DumpTypeReprList;

PROCEDURE DumpIdentOfEntry (o: OB.tOB);
 BEGIN
  IF o = OB.NoOB THEN RETURN; END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 648 "OD.pum" *)
(* line 648 "OD.pum" *)
      
    IF o^.DataEntry.declStatus#OB.DECLARED THEN ED.Text(E,'<'); END; (* IF *)

    IF ((o^.DataEntry.level>0) OR (o^.DataEntry.level=OB.FIELDLEVEL)) & (o^.DataEntry.module^.ModuleEntry.name#ModuleIdent)
       THEN ED.Ident(E,o^.DataEntry.module^.ModuleEntry.name);
            ED.Text(E,'$');
    END; (* IF *)
    ED.Ident(E,o^.DataEntry.ident);
    IF o^.DataEntry.declStatus#OB.DECLARED THEN ED.Text(E,'>'); END; (* IF *)
    ED.Tab(E,1);
    DumpExportModeOfEntry(o);
 ;
      RETURN;

  END;
 END DumpIdentOfEntry;

PROCEDURE DumpBoundProcEntry (yyP5: OB.tOB);
 BEGIN
  IF yyP5 = OB.NoOB THEN RETURN; END;
  IF (yyP5^.Kind = OB.BoundProcEntry) THEN
  IF (yyP5^.BoundProcEntry.receiverSig^.Kind = OB.Signature) THEN
  IF OB.IsType (yyP5^.BoundProcEntry.receiverSig^.Signature.VarEntry^.VarEntry.typeRepr, OB.TypeRepr) THEN
  IF (yyP5^.BoundProcEntry.receiverSig^.Signature.VarEntry^.VarEntry.typeRepr^.TypeRepr.entry^.Kind = OB.TypeEntry) THEN
(* line 664 "OD.pum" *)
(* line 672 "OD.pum" *)
      
    ED.Ident(E,yyP5^.BoundProcEntry.receiverSig^.Signature.VarEntry^.VarEntry.typeRepr^.TypeRepr.entry^.TypeEntry.module^.ModuleEntry.name); 
    ED.Text(E,'.'); 
    ED.Ident(E,yyP5^.BoundProcEntry.receiverSig^.Signature.VarEntry^.VarEntry.typeRepr^.TypeRepr.entry^.TypeEntry.ident); 
    ED.Text(E,'.'); 
    ED.Ident(E,yyP5^.BoundProcEntry.ident); 
 ;
      RETURN;

  END;
  END;
  END;
  END;
(* line 680 "OD.pum" *)
(* line 680 "OD.pum" *)
      
    ED.Text(E,'?BoundProcEntry'); 
 ;
      RETURN;

 END DumpBoundProcEntry;

PROCEDURE DumpExportModeOfEntry (yyP6: OB.tOB);
 BEGIN
  IF yyP6 = OB.NoOB THEN RETURN; END;
  IF (yyIsEqual ( yyP6^.DataEntry.exportMode ,   OB.PUBLIC   ) ) THEN
(* line 687 "OD.pum" *)
(* line 687 "OD.pum" *)
       ED.Text(E,'*'); ;
      RETURN;

  END;
  IF (yyIsEqual ( yyP6^.DataEntry.exportMode ,   OB.READONLY ) ) THEN
(* line 688 "OD.pum" *)
(* line 688 "OD.pum" *)
       ED.Text(E,'-'); ;
      RETURN;

  END;
(* line 689 "OD.pum" *)
(* line 689 "OD.pum" *)
       ED.Text(E,' '); ;
      RETURN;

 END DumpExportModeOfEntry;

PROCEDURE DumpTypeSize (type: OB.tOB);
(* line 693 "OD.pum" *)
VAR size :LONGINT; s: ARRAY SizeWidth+2 OF CHAR;  
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
(* line 695 "OD.pum" *)
(* line 695 "OD.pum" *)
      
    IF ARG.OptionShowTypeSizes
       THEN size:=T.SizeOfType(type);
            ED.Text(E,'S=');
            IF size#OT.ObjectTooBigSize
               THEN ED.Num(E,size,SizeWidth);
               ELSE STR.DoString(s,SizeWidth,'*');
                    ED.Text(E,s);
            END; (* IF *)
            ED.Text(E,' ');
    END; (* IF ARG.OptionShowTypeSizes *)
 ;
      RETURN;

 END DumpTypeSize;

PROCEDURE DumpBlocklist (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.NoBlocklist) THEN
(* line 711 "OD.pum" *)
(* line 711 "OD.pum" *)
       
    ED.Text(E,'-'); 
 ;
      RETURN;

  END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 715 "OD.pum" *)
(* line 715 "OD.pum" *)
       

    ED.Text(E,'('); ED.Longint(E,bl^.Blocklist.ofs); 
    ED.Text(E,','); ED.Longint(E,bl^.Blocklist.count); 
    ED.Text(E,','); ED.Longint(E,bl^.Blocklist.incr); 
    ED.Text(E,',H'); ED.Longint(E,bl^.Blocklist.height); 
    ED.Text(E,','); 
    IF IsEmpty(bl^.Blocklist.sub)
       THEN ED.Text(E,'-'); 
       ELSE DumpBlocklist(bl^.Blocklist.sub); 
    END; (* IF *)
    ED.Text(E,')'); 

    IF ~IsEmpty(bl^.Blocklist.prev) THEN 
       ED.Text(E,','); 
       DumpBlocklist(bl^.Blocklist.prev); 
    END; (* IF *)
 ;
      RETURN;

  END;
 END DumpBlocklist;

PROCEDURE MaxEntryIdLen (o: OB.tOB): INTEGER;
(* line 736 "OD.pum" *)
VAR len:LONGINT; 
 BEGIN
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 738 "OD.pum" *)
(* line 740 "OD.pum" *)
       IF o^.DataEntry.module^.ModuleEntry.name#ModuleIdent
         THEN len := UTI.IdentLength(o^.DataEntry.module^.ModuleEntry.name)+1;
         ELSE len := 0;
      END; (* IF *)
      INC(len,UTI.IdentLength(o^.DataEntry.ident));
      IF o^.DataEntry.exportMode#OB.PRIVATE THEN INC(len,2); END; (* IF *)
      len:=MaxSC(MaxEntryIdLen(o^.DataEntry.prevEntry),SHORT(len));
    ;
      RETURN SHORT(len);

  END;
  IF OB.IsType (o, OB.Entry) THEN
(* line 749 "OD.pum" *)
      RETURN MaxEntryIdLen (o^.Entry.prevEntry);

  END;
(* line 752 "OD.pum" *)
      RETURN 0;

 END MaxEntryIdLen;

PROCEDURE ImportsExists (o: OB.tOB): BOOLEAN;
 BEGIN
  IF o = OB.NoOB THEN RETURN FALSE; END;
  IF (o^.Kind = OB.ServerEntry) THEN
(* line 756 "OD.pum" *)
      RETURN TRUE;

  END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 757 "OD.pum" *)
   LOOP
(* line 757 "OD.pum" *)
      IF ~(ImportsExists (o^.DataEntry.prevEntry)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END ImportsExists;

PROCEDURE ConstsExists (o: OB.tOB): BOOLEAN;
 BEGIN
  IF o = OB.NoOB THEN RETURN FALSE; END;
  IF (o^.Kind = OB.ConstEntry) THEN
  IF (yyIsEqual ( o^.ConstEntry.exportMode ,   OB.PUBLIC ) ) THEN
(* line 761 "OD.pum" *)
      RETURN TRUE;

  END;
  END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 762 "OD.pum" *)
   LOOP
(* line 762 "OD.pum" *)
      IF ~(ConstsExists (o^.DataEntry.prevEntry)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END ConstsExists;

PROCEDURE TypesExists (o: OB.tOB): BOOLEAN;
 BEGIN
  IF o = OB.NoOB THEN RETURN FALSE; END;
  IF (o^.Kind = OB.TypeEntry) THEN
  IF (yyIsEqual ( o^.TypeEntry.exportMode ,   OB.PUBLIC ) ) THEN
(* line 766 "OD.pum" *)
      RETURN TRUE;

  END;
  END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 767 "OD.pum" *)
   LOOP
(* line 767 "OD.pum" *)
      IF ~(TypesExists (o^.DataEntry.prevEntry)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END TypesExists;

PROCEDURE VarsExists (o: OB.tOB): BOOLEAN;
 BEGIN
  IF o = OB.NoOB THEN RETURN FALSE; END;
  IF (o^.Kind = OB.VarEntry) THEN
  IF (yyIsEqual ( o^.VarEntry.exportMode ,   OB.PUBLIC   ) ) THEN
(* line 771 "OD.pum" *)
      RETURN TRUE;

  END;
  IF (yyIsEqual ( o^.VarEntry.exportMode ,   OB.READONLY ) ) THEN
(* line 772 "OD.pum" *)
      RETURN TRUE;

  END;
  END;
  IF OB.IsType (o, OB.DataEntry) THEN
(* line 773 "OD.pum" *)
   LOOP
(* line 773 "OD.pum" *)
      IF ~(VarsExists (o^.DataEntry.prevEntry)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END VarsExists;

PROCEDURE BeginOD*;
 BEGIN
(* line 45 "OD.pum" *)
  MaxLineLength := 80; 
 END BeginOD;

PROCEDURE CloseOD*;
 BEGIN
 END CloseOD;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginOD;
END OD.

