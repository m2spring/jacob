MODULE PR;








IMPORT SYSTEM, System, IO, OB,
(* line 23 "PR.pum" *)
 Base             ,
               ERR             ,
	       LAB             ,
               OT              ,
               Idents,POS,UTI             ;

        TYPE   tIdent*          = Idents.tIdent;                             (* These types are re-declared due to the fact that *)
               tParMode*        = OB.tParMode;                               (* qualidents are illegal in a puma specification.  *)
               tPosition*       = POS.tPosition; 
(* line 16 "PR.pum" *)
 VAR    IdentCASEFAULT* ,
               IdentWITHFAULT* ,
               IdentPREDECL*    ,
               IdentSYSTEM*     : Idents.tIdent; 
               ModuleSYSTEM*    ,
               ModulePREDECL*   : OB.tOB; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;

        CONST  Name_CASEFAULT  = '_CASEFAULT';
               Name_WITHFAULT  = '_WITHFAULT';
        TYPE   tName           = ARRAY 16 OF CHAR;
               tLabel          = LAB.T;
        VAR    TablePREDECL    ,
               TableSYSTEM     : OB.tOB; 


































































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module PR, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi	:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE^BuildTables ();

PROCEDURE GetTablePREDECL* (): OB.tOB;
 VAR yyTempo: RECORD 
 END; 
 BEGIN
(* line 47 "PR.pum" *)
(* line 47 "PR.pum" *)
      IF TablePREDECL=NIL THEN BuildTables; END; ;
      RETURN TablePREDECL;

 END GetTablePREDECL;

PROCEDURE GetTableSYSTEM* (): OB.tOB;
 VAR yyTempo: RECORD 
 END; 
 BEGIN
(* line 51 "PR.pum" *)
(* line 51 "PR.pum" *)
      IF TableSYSTEM=NIL THEN BuildTables; END; ;
      RETURN TableSYSTEM;

 END GetTableSYSTEM;

PROCEDURE bC (n: tName; t: OB.tOB; v: OB.tOB): OB.tOB;
 VAR yyTempo: RECORD 
  yyR1: RECORD
  yyV1: OB.tOB;
  END;
 END; 
 BEGIN
(* line 56 "PR.pum" 
    WITH yyTempo.yyR1 DO
*)
       yyTempo.yyR1.yyV1  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR1.yyV1 ) >=  OB .yyPoolMaxPtr THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . ConstEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . ConstEntry ; 
      yyTempo.yyR1.yyV1^.ConstEntry.prevEntry := OB.NoOB;
       yyTempo.yyR1.yyV1^.ConstEntry.module  := NIL; 
      yyTempo.yyR1.yyV1^.ConstEntry.ident := UTI . IdentOf (n);
      yyTempo.yyR1.yyV1^.ConstEntry.exportMode := OB.PUBLIC;
      yyTempo.yyR1.yyV1^.ConstEntry.level := 0;
      yyTempo.yyR1.yyV1^.ConstEntry.declStatus := OB.DECLARED;
      yyTempo.yyR1.yyV1^.ConstEntry.typeRepr := t;
      yyTempo.yyR1.yyV1^.ConstEntry.value := v;
      yyTempo.yyR1.yyV1^.ConstEntry.label := LAB.MT;
      RETURN yyTempo.yyR1.yyV1;

 END bC;

PROCEDURE bI (n: tName; val: LONGINT): OB.tOB;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 END; 
 BEGIN
(* line 70 "PR.pum" *)
       yyTempo.yyR1.yyV1  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR1.yyV1 ) >=  OB .yyPoolMaxPtr THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . ConstEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . ConstEntry ; 
      yyTempo.yyR1.yyV1^.ConstEntry.prevEntry := OB.NoOB;
       yyTempo.yyR1.yyV1^.ConstEntry.module  := NIL; 
      yyTempo.yyR1.yyV1^.ConstEntry.ident := UTI . IdentOf (n);
      yyTempo.yyR1.yyV1^.ConstEntry.exportMode := OB.PUBLIC;
      yyTempo.yyR1.yyV1^.ConstEntry.level := 0;
      yyTempo.yyR1.yyV1^.ConstEntry.declStatus := OB.DECLARED;
      yyTempo.yyR1.yyV1^.ConstEntry.typeRepr := OB.MinimalIntegerType(val);
       yyTempo.yyR1.yyV1^.ConstEntry.value  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR1.yyV1^.ConstEntry.value ) >=  OB .yyPoolMaxPtr THEN  yyTempo.yyR1.yyV1^.ConstEntry.value  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerValue ]);  yyTempo.yyR1.yyV1^.ConstEntry.value ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1^.ConstEntry.value ^.Kind :=  OB . IntegerValue ; 
      yyTempo.yyR1.yyV1^.ConstEntry.value^.IntegerValue.v := val;
      yyTempo.yyR1.yyV1^.ConstEntry.label := LAB.MT;
      RETURN yyTempo.yyR1.yyV1;

 END bI;

PROCEDURE bT (n: tName; t: OB.tOB): OB.tOB;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 END; 
 BEGIN
(* line 84 "PR.pum" *)
       yyTempo.yyR1.yyV1  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR1.yyV1 ) >=  OB .yyPoolMaxPtr THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . TypeEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . TypeEntry ; 
      yyTempo.yyR1.yyV1^.TypeEntry.prevEntry := OB.NoOB;
       yyTempo.yyR1.yyV1^.TypeEntry.module  := NIL; 
      yyTempo.yyR1.yyV1^.TypeEntry.ident := UTI . IdentOf (n);
      yyTempo.yyR1.yyV1^.TypeEntry.exportMode := OB.PUBLIC;
      yyTempo.yyR1.yyV1^.TypeEntry.level := 0;
      yyTempo.yyR1.yyV1^.TypeEntry.declStatus := OB.DECLARED;
      yyTempo.yyR1.yyV1^.TypeEntry.typeRepr := t;
      RETURN yyTempo.yyR1.yyV1;

 END bT;

PROCEDURE^bP1 (i: tIdent; t: OB.tOB): OB.tOB;

PROCEDURE bP (n: tName; kind:INTEGER): OB.tOB;
 VAR yyTempo: RECORD 
 END;
 BEGIN
(* line 96 "PR.pum" *)
      RETURN bP1(UTI.IdentOf(n),OB.MakeOB(kind));

 END bP;

PROCEDURE bP1 (i: tIdent; t: OB.tOB): OB.tOB;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
(* line 100 "PR.pum" *)
(* line 121 "PR.pum" *)
       t^.PreDeclProcTypeRepr.entry          := OB.cNonameEntry;
                                         t^.PreDeclProcTypeRepr.size           := OT.SIZEoPROCEDURE;
                                         t^.PreDeclProcTypeRepr.typeBlocklists := OB.cmtTypeBlocklist; 
                                         t^.PreDeclProcTypeRepr.isInTDescList  := FALSE; 
                                         t^.PreDeclProcTypeRepr.label          := LAB.MT; 
                                         t^.PreDeclProcTypeRepr.signatureRepr  := OB.cGenericSignature;
                                         t^.PreDeclProcTypeRepr.resultType     := OB.cmtTypeRepr; 
                                         t^.PreDeclProcTypeRepr.paramSpace     := 0; ;
       yyTempo.yyR1.yyV1  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR1.yyV1 ) >=  OB .yyPoolMaxPtr THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . ProcedureEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . ProcedureEntry ; 
      yyTempo.yyR1.yyV1^.ProcedureEntry.prevEntry := OB.NoOB;
       yyTempo.yyR1.yyV1^.ProcedureEntry.module  := NIL; 
      yyTempo.yyR1.yyV1^.ProcedureEntry.ident := i;
      yyTempo.yyR1.yyV1^.ProcedureEntry.exportMode := OB.PUBLIC;
      yyTempo.yyR1.yyV1^.ProcedureEntry.level := 0;
      yyTempo.yyR1.yyV1^.ProcedureEntry.declStatus := OB.DECLARED;
      yyTempo.yyR1.yyV1^.ProcedureEntry.typeRepr := t;
      yyTempo.yyR1.yyV1^.ProcedureEntry.complete := TRUE;
      	
      yyTempo.yyR1.yyV1^.ProcedureEntry.label := LAB.MT;
      yyTempo.yyR1.yyV1^.ProcedureEntry.namePath := OB.cmtEntry;
      yyTempo.yyR1.yyV1^.ProcedureEntry.env := NIL;
      RETURN yyTempo.yyR1.yyV1;

 END bP1;

PROCEDURE EnterPRE (entry: OB.tOB);
 VAR yyTempo: RECORD 
 END;
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF (entry^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (entry^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 133 "PR.pum" *)
(* line 140 "PR.pum" *)
       entry^.TypeEntry.prevEntry         := TablePREDECL; 
                                                     entry^.TypeEntry.module       := OB.cPredeclModuleEntry; 
                                                     entry^.TypeEntry.exportMode   := OB.PRIVATE; 
                                                     entry^.TypeEntry.typeRepr^.TypeRepr.entry  := entry; 
                                                     TablePREDECL := entry; ;
      RETURN;

  END;
  END;
  IF OB.IsType (entry, OB.DataEntry) THEN
(* line 145 "PR.pum" *)
(* line 150 "PR.pum" *)
       entry^.DataEntry.prevEntry         := TablePREDECL; 
                                                     entry^.DataEntry.module       := OB.cPredeclModuleEntry;
                                                     entry^.DataEntry.exportMode   := OB.PRIVATE; ; 
                                                     TablePREDECL := entry; ;
      RETURN;

  END;
(* line 155 "PR.pum" *)
(* line 155 "PR.pum" *)
       ERR.Fatal('PR.EnterPRE'); ;
      RETURN;

 END EnterPRE;

PROCEDURE EnterSYS (entry: OB.tOB);
 VAR yyTempo: RECORD 
 END;
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF (entry^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (entry^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 160 "PR.pum" *)
(* line 167 "PR.pum" *)
       entry^.TypeEntry.prevEntry         := TableSYSTEM; 
                                                     entry^.TypeEntry.module       := OB.cSystemModuleEntry; 
                                                     entry^.TypeEntry.typeRepr^.TypeRepr.entry  := entry; 
                                                     TableSYSTEM  := entry; ;
      RETURN;

  END;
  END;
  IF OB.IsType (entry, OB.DataEntry) THEN
(* line 171 "PR.pum" *)
(* line 174 "PR.pum" *)
       entry^.DataEntry.prevEntry         := TableSYSTEM; 
                                                     entry^.DataEntry.module       := OB.cSystemModuleEntry;
                                                     TableSYSTEM  := entry; ;
      RETURN;

  END;
(* line 178 "PR.pum" *)
(* line 178 "PR.pum" *)
       ERR.Fatal('PR.EnterSYS'); ;
      RETURN;

 END EnterSYS;

PROCEDURE DefLabel (entry: OB.tOB; label: tLabel);
 VAR yyTempo: RECORD 
 END;
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF (entry^.Kind = OB.ProcedureEntry) THEN
(* line 183 "PR.pum" *)
(* line 194 "PR.pum" *)
      entry^.ProcedureEntry.label := label;
      RETURN;

  END;
 END DefLabel;

PROCEDURE DefEmptySignature (yyP1: OB.tOB);
 VAR yyTempo: RECORD 
 END;
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN; END;
  IF (yyP1^.Kind = OB.ProcedureEntry) THEN
  IF OB.IsType (yyP1^.ProcedureEntry.typeRepr, OB.PreDeclProcTypeRepr) THEN
(* line 199 "PR.pum" *)
(* line 215 "PR.pum" *)
       yyP1^.ProcedureEntry.typeRepr^.PreDeclProcTypeRepr.signatureRepr:=OB.cmtSignature; ;
      RETURN;

  END;
  END;
 END DefEmptySignature;

PROCEDURE BuildTables ();
 VAR yyTempo: RECORD 
 END;
 BEGIN
(* line 219 "PR.pum" *)
(* line 219 "PR.pum" *)
      

 (*** runtime library procedures ***)

    EnterPRE( bP('_CASEFAULT',OB.CaseFaultTypeRepr)); DefLabel(TablePREDECL,LAB.CaseFault); DefEmptySignature(TablePREDECL); 
    EnterPRE( bP('_WITHFAULT',OB.WithFaultTypeRepr)); DefLabel(TablePREDECL,LAB.WithFault); DefEmptySignature(TablePREDECL); 

 (*** predeclared constants ***)

    EnterPRE( bC('FALSE'     ,OB.cBooleanTypeRepr,OB.cFalseValue));
    EnterPRE( bC('TRUE'      ,OB.cBooleanTypeRepr,OB.cTrueValue ));

 (*** predeclared types ***)

    EnterPRE( bT('BOOLEAN'   ,OB.cBooleanTypeRepr               ));
    EnterPRE( bT('CHAR'      ,OB.cCharTypeRepr                  ));
    EnterPRE( bT('SET'       ,OB.cSetTypeRepr                   ));
    EnterPRE( bT('SHORTINT'  ,OB.cShortintTypeRepr              ));
    EnterPRE( bT('INTEGER'   ,OB.cIntegerTypeRepr               ));
    EnterPRE( bT('LONGINT'   ,OB.cLongintTypeRepr               ));
    EnterPRE( bT('REAL'      ,OB.cRealTypeRepr                  ));
    EnterPRE( bT('LONGREAL'  ,OB.cLongrealTypeRepr              ));

 (*** predeclared function procedures ***)

    EnterPRE( bP('ABS'       ,OB.AbsTypeRepr                    ));
    EnterPRE( bP('ASH'       ,OB.AshTypeRepr                    ));
    EnterPRE( bP('CAP'       ,OB.CapTypeRepr                    ));
    EnterPRE( bP('CHR'       ,OB.ChrTypeRepr                    ));
    EnterPRE( bP('ENTIER'    ,OB.EntierTypeRepr                 ));
    EnterPRE( bP('LEN'       ,OB.LenTypeRepr                    ));
    EnterPRE( bP('LONG'      ,OB.LongTypeRepr                   ));
    EnterPRE( bP('MAX'       ,OB.MaxTypeRepr                    ));
    EnterPRE( bP('MIN'       ,OB.MinTypeRepr                    ));
    EnterPRE( bP('ODD'       ,OB.OddTypeRepr                    ));
    EnterPRE( bP('ORD'       ,OB.OrdTypeRepr                    ));
    EnterPRE( bP('SHORT'     ,OB.ShortTypeRepr                  ));
    EnterPRE( bP('SIZE'      ,OB.SizeTypeRepr                   ));

 (*** predeclared proper procedures ***)

    EnterPRE( bP('ASSERT'    ,OB.AssertTypeRepr                 ));
    EnterPRE( bP('COPY'      ,OB.CopyTypeRepr                   ));
    EnterPRE( bP('DEC'       ,OB.DecTypeRepr                    ));
    EnterPRE( bP('EXCL'      ,OB.ExclTypeRepr                   ));
    EnterPRE( bP('HALT'      ,OB.HaltTypeRepr                   ));
    EnterPRE( bP('INC'       ,OB.IncTypeRepr                    ));
    EnterPRE( bP('INCL'      ,OB.InclTypeRepr                   ));
    EnterPRE( bP('NEW'       ,OB.NewTypeRepr                    ));

 (*** SYSTEM constants ***)
 
    EnterSYS( bI('eax'       ,Base.codeEAX                       ));
    EnterSYS( bI('ebx'       ,Base.codeEBX                       ));
    EnterSYS( bI('ecx'       ,Base.codeECX                       ));
    EnterSYS( bI('edx'       ,Base.codeEDX                       ));
    EnterSYS( bI('esi'       ,Base.codeESI                       ));
    EnterSYS( bI('edi'       ,Base.codeEDI                       ));
    EnterSYS( bI('ebp'       ,Base.codeEBP                       ));
    EnterSYS( bI('esp'       ,Base.codeESP                       ));
    EnterSYS( bI('eflags'    ,Base.codeEFLAGS                    ));

    EnterSYS( bI('st0'       ,Base.codeST0                       ));
    EnterSYS( bI('st1'       ,Base.codeST1                       ));
    EnterSYS( bI('st2'       ,Base.codeST2                       ));
    EnterSYS( bI('st3'       ,Base.codeST3                       ));
    EnterSYS( bI('st4'       ,Base.codeST4                       ));
    EnterSYS( bI('st5'       ,Base.codeST5                       ));
    EnterSYS( bI('st6'       ,Base.codeST6                       ));
    EnterSYS( bI('st7'       ,Base.codeST7                       ));

    EnterSYS( bI('cf'        ,Base.codeCF                        ));
    EnterSYS( bI('pf'        ,Base.codePF                        ));
    EnterSYS( bI('af'        ,Base.codeAF                        ));
    EnterSYS( bI('zf'        ,Base.codeZF                        ));
    EnterSYS( bI('sf'        ,Base.codeSF                        ));
    EnterSYS( bI('tf'        ,Base.codeTF                        ));
    EnterSYS( bI('if'        ,Base.codeIF                        ));
    EnterSYS( bI('df'        ,Base.codeDF                        ));
    EnterSYS( bI('of'        ,Base.codeOF                        ));
    EnterSYS( bI('nt'        ,Base.codeNT                        ));
    EnterSYS( bI('rf'        ,Base.codeRF                        ));
    EnterSYS( bI('vm'        ,Base.codeVM                        ));
    EnterSYS( bI('ac'        ,Base.codeAC                        ));

 (*** SYSTEM types ***)

    EnterSYS( bT('BYTE'      ,OB.cByteTypeRepr                  ));
    EnterSYS( bT('PTR'       ,OB.cPtrTypeRepr                   ));

 (*** SYSTEM function procedures ***)

    EnterSYS( bP('ADR'       ,OB.SysAdrTypeRepr                 ));
    EnterSYS( bP('BIT'       ,OB.SysBitTypeRepr                 ));
    EnterSYS( bP('CC'        ,OB.SysCcTypeRepr                  ));
    EnterSYS( bP('LSH'       ,OB.SysLshTypeRepr                 ));
    EnterSYS( bP('ROT'       ,OB.SysRotTypeRepr                 ));
    EnterSYS( bP('VAL'       ,OB.SysValTypeRepr                 ));

 (*** SYSTEM proper procedures ***)

    EnterSYS( bP('GET'       ,OB.SysGetTypeRepr                 ));
    EnterSYS( bP('PUT'       ,OB.SysPutTypeRepr                 ));
    EnterSYS( bP('GETREG'    ,OB.SysGetregTypeRepr              ));
    EnterSYS( bP('PUTREG'    ,OB.SysPutregTypeRepr              ));
    EnterSYS( bP('MOVE'      ,OB.SysMoveTypeRepr                ));
    EnterSYS( bP('NEW'       ,OB.SysNewTypeRepr                 ));
    EnterSYS( bP('Base'       ,OB.SysAsmTypeRepr                 ));
 ;
      RETURN;

 END BuildTables;

PROCEDURE BeginPR*;
 BEGIN
(* line 38 "PR.pum" *)
  IdentCASEFAULT := UTI.IdentOf('_CASEFAULT');
        IdentWITHFAULT := UTI.IdentOf('_WITHFAULT');
        IdentPREDECL    := UTI.IdentOf('_PREDECL'  );
        IdentSYSTEM     := UTI.IdentOf('SYSTEM'    );
        TablePREDECL    := NIL;
        TableSYSTEM     := NIL; 
 END BeginPR;

PROCEDURE ClosePR*;
 BEGIN
 END ClosePR;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginPR;
END PR.

