MODULE E;








IMPORT SYSTEM, System, IO, OB,
(* line 94 "E.pum" *)
 ERR         ,
                Idents      ,
		LAB         ,
                O           ,
                OT          ,
                POS         ,
                T           ; 

        TYPE    tIdent      = Idents.tIdent  ;                      (* These types are re-declared due to the fact that         *)
                tAddress    = OB.tAddress    ;                      (* qualidents are illegal in a puma specification.          *)
                tDeclStatus = OB.tDeclStatus ; 
                tExportMode = OB.tExportMode ;                      
                tLabel      = OB.tLabel      ; 
                tLevel      = OB.tLevel      ;
                tParMode    = OB.tParMode    ;
                tSize       = OB.tSize       ;
                tPosition   = POS.tPosition  ; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;





PROCEDURE^MaxExportMode* (yyP41: tExportMode; yyP40: tExportMode): tExportMode;
















































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module E, routine ');
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

PROCEDURE LinkTypeToEntry* (type: OB.tOB; entry: OB.tOB);
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF entry = OB.NoOB THEN RETURN; END;
  IF OB.IsType (type, OB.TypeRepr) THEN
(* line 106 "E.pum" *)
(* line 107 "E.pum" *)
      IF type^.TypeRepr.entry=OB.cNonameEntry THEN type^.TypeRepr.entry:=entry END; ;
      RETURN;

  END;
 END LinkTypeToEntry;

PROCEDURE DefineConstEntry* (entry: OB.tOB; level: tLevel; ident: tIdent; type: OB.tOB; value: OB.tOB): OB.tOB;
 BEGIN
  IF (entry^.Kind = OB.ConstEntry) THEN
  IF ( entry^.ConstEntry.ident  =   ident  ) THEN
  IF (yyIsEqual ( entry^.ConstEntry.level ,   level ) ) THEN
(* line 116 "E.pum" *)
(* line 128 "E.pum" *)
       IF entry^.ConstEntry.declStatus=OB.TOBEDECLARED
                            THEN entry^.ConstEntry.declStatus := OB.DECLARED;
                                 entry^.ConstEntry.typeRepr := type;
                                 entry^.ConstEntry.value := value;
                         END; (* IF *)
                       ;
      RETURN entry;

  END;
  END;
  END;
  yyAbort ('DefineConstEntry');
 END DefineConstEntry;

PROCEDURE DefineTypeEntry* (table: OB.tOB; entry: OB.tOB; forwardEntry: OB.tOB; level: tLevel; ident: tIdent; type: OB.tOB): OB.tOB;
 BEGIN
  IF (entry^.Kind = OB.TypeEntry) THEN
  IF ( entry^.TypeEntry.ident  =   ident  ) THEN
  IF (yyIsEqual ( entry^.TypeEntry.level ,   level ) ) THEN
  IF (forwardEntry^.Kind = OB.TypeEntry) THEN
  IF (forwardEntry^.TypeEntry.typeRepr^.Kind = OB.ForwardTypeRepr) THEN
(* line 145 "E.pum" *)
(* line 164 "E.pum" *)
       forwardEntry^.TypeEntry.typeRepr := type;                                   
                         IF entry^.TypeEntry.declStatus=OB.TOBEDECLARED
                            THEN entry^.TypeEntry.declStatus := OB.DECLARED;                     
                                 entry^.TypeEntry.typeRepr := type;
                                 LinkTypeToEntry(entry^.TypeEntry.typeRepr,entry);
                         END;
                       ;
      RETURN table;

  END;
  END;
  END;
  END;
  IF ( entry^.TypeEntry.ident  =   ident  ) THEN
  IF (yyIsEqual ( entry^.TypeEntry.level ,   level ) ) THEN
(* line 173 "E.pum" *)
(* line 184 "E.pum" *)
       IF entry^.TypeEntry.declStatus=OB.TOBEDECLARED
                            THEN entry^.TypeEntry.declStatus := OB.DECLARED;                    
                                 entry^.TypeEntry.typeRepr := type;
                                 LinkTypeToEntry(entry^.TypeEntry.typeRepr,entry);
                         END;
                       ;
      RETURN table;

  END;
  END;
  END;
  yyAbort ('DefineTypeEntry');
 END DefineTypeEntry;

PROCEDURE DefineVarEntry* (table: OB.tOB; entry: OB.tOB; level: tLevel; ident: tIdent; type: OB.tOB; addr: tAddress; refMode: tParMode): OB.tOB;
 BEGIN
  IF (entry^.Kind = OB.VarEntry) THEN
  IF ( entry^.VarEntry.ident  =   ident  ) THEN
  IF (yyIsEqual ( entry^.VarEntry.level ,   level ) ) THEN
(* line 201 "E.pum" *)
(* line 219 "E.pum" *)
       IF entry^.VarEntry.declStatus=OB.TOBEDECLARED
                            THEN entry^.VarEntry.declStatus := OB.DECLARED;
                                 entry^.VarEntry.typeRepr := type;
                                 entry^.VarEntry.address := addr;     
                                 entry^.VarEntry.refMode := refMode;
                         END;
                       ;
      RETURN table;

  END;
  END;
  END;
  yyAbort ('DefineVarEntry');
 END DefineVarEntry;

PROCEDURE ChooseProcedureEntry* (table: OB.tOB; entry: OB.tOB; forwardEntry: OB.tOB): OB.tOB;
 BEGIN
  IF (forwardEntry^.Kind = OB.ProcedureEntry) THEN
  IF ( forwardEntry^.ProcedureEntry.complete  =   FALSE  ) THEN
(* line 232 "E.pum" *)
      RETURN table;

  END;
  END;
(* line 246 "E.pum" *)
      RETURN entry;

 END ChooseProcedureEntry;

PROCEDURE DefineProcedureEntry* (table: OB.tOB; entry: OB.tOB; forwardEntry: OB.tOB; level: tLevel; ident: tIdent; exportMode: tExportMode; label: tLabel; type: OB.tOB; env: OB.tOB): OB.tOB;
 BEGIN
  IF (forwardEntry^.Kind = OB.ProcedureEntry) THEN
(* line 260 "E.pum" *)
(* line 277 "E.pum" *)
       IF ~forwardEntry^.ProcedureEntry.complete THEN 
                            forwardEntry^.ProcedureEntry.complete := TRUE;                                                 
                            IF (forwardEntry^.ProcedureEntry.exportMode#OB.PUBLIC) & (exportMode=OB.PUBLIC) THEN forwardEntry^.ProcedureEntry.label:=label; END;
                            forwardEntry^.ProcedureEntry.exportMode := MaxExportMode(forwardEntry^.ProcedureEntry.exportMode,exportMode);                          
                            forwardEntry^.ProcedureEntry.env := env;
                         END;
                       ;
      RETURN table;

  END;
  IF (entry^.Kind = OB.ProcedureEntry) THEN
  IF ( entry^.ProcedureEntry.ident  =   ident  ) THEN
  IF (yyIsEqual ( entry^.ProcedureEntry.level ,   level ) ) THEN
(* line 286 "E.pum" *)
(* line 302 "E.pum" *)
       IF entry^.ProcedureEntry.declStatus=OB.TOBEDECLARED THEN 
                            entry^.ProcedureEntry.declStatus := OB.DECLARED;                                          
                            entry^.ProcedureEntry.typeRepr := type;
                            LinkTypeToEntry(entry^.ProcedureEntry.typeRepr,entry);
                            entry^.ProcedureEntry.env := env;
                         END;
                       ;
      RETURN table;

  END;
  END;
  END;
  yyAbort ('DefineProcedureEntry');
 END DefineProcedureEntry;

PROCEDURE Lookup* (yyP1: OB.tOB; Ident: tIdent): OB.tOB;
 BEGIN
  IF yyP1 = NIL THEN
(* line 313 "E.pum" *)
      RETURN OB.cErrorEntry;

  END;
  IF OB.IsType (yyP1, OB.DataEntry) THEN
  IF ( yyP1^.DataEntry.ident  =   Ident  ) THEN
(* line 314 "E.pum" *)
      RETURN yyP1;

  END;
(* line 315 "E.pum" *)
      RETURN Lookup (yyP1^.DataEntry.prevEntry, Ident);

  END;
  IF OB.IsType (yyP1, OB.Entry) THEN
(* line 316 "E.pum" *)
      RETURN Lookup (yyP1^.Entry.prevEntry, Ident);

  END;
(* line 317 "E.pum" *)
      RETURN OB.cErrorEntry;

 END Lookup;

PROCEDURE Lookup0* (yyP2: OB.tOB; Ident: tIdent): OB.tOB;
 BEGIN
  IF yyP2 = NIL THEN
(* line 322 "E.pum" *)
      RETURN OB.cErrorEntry;

  END;
  IF OB.IsType (yyP2, OB.DataEntry) THEN
  IF ( yyP2^.DataEntry.ident  =   Ident  ) THEN
(* line 323 "E.pum" *)
      RETURN yyP2;

  END;
(* line 324 "E.pum" *)
      RETURN Lookup0 (yyP2^.DataEntry.prevEntry, Ident);

  END;
(* line 325 "E.pum" *)
      RETURN OB.cErrorEntry;

 END Lookup0;

PROCEDURE LookupExtern* (yyP3: OB.tOB; Ident: tIdent): OB.tOB;
 BEGIN
  IF (yyP3^.Kind = OB.ServerEntry) THEN
(* line 330 "E.pum" *)
      RETURN Lookup (yyP3^.ServerEntry.serverTable, Ident);

  END;
(* line 331 "E.pum" *)
      RETURN OB.cErrorEntry;

 END LookupExtern;

PROCEDURE LookupForward* (entry: OB.tOB; ident: tIdent): OB.tOB;
 BEGIN
  IF (entry^.Kind = OB.TypeEntry) THEN
  IF ( entry^.TypeEntry.ident  =   ident  ) THEN
  IF (entry^.TypeEntry.typeRepr^.Kind = OB.ForwardTypeRepr) THEN
(* line 337 "E.pum" *)
      RETURN entry;

  END;
  END;
  END;
  IF OB.IsType (entry, OB.DataEntry) THEN
(* line 347 "E.pum" *)
      RETURN LookupForward (entry^.DataEntry.prevEntry, ident);

  END;
(* line 349 "E.pum" *)
      RETURN OB.cmtEntry;

 END LookupForward;

PROCEDURE IsUndeclared* (Table: OB.tOB; Ident: tIdent): BOOLEAN;
 BEGIN
  IF Table = OB.NoOB THEN RETURN FALSE; END;
  IF OB.IsType (Table, OB.DataEntry) THEN
  IF ( Table^.DataEntry.ident  =   Ident  ) THEN
(* line 354 "E.pum" *)
(* line 359 "E.pum" *)
      RETURN FALSE;

  END;
(* line 361 "E.pum" *)
(* line 364 "E.pum" *)
       RETURN IsUndeclared(Table^.DataEntry.prevEntry,Ident); ;
      RETURN TRUE;

  END;
(* line 366 "E.pum" *)
      RETURN TRUE;

 END IsUndeclared;

PROCEDURE IsNotToBeDeclared* (yyP4: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN FALSE; END;
  IF OB.IsType (yyP4, OB.DataEntry) THEN
  IF (yyIsEqual ( yyP4^.DataEntry.declStatus ,   OB.TOBEDECLARED ) ) THEN
(* line 369 "E.pum" *)
(* line 369 "E.pum" *)
      RETURN FALSE;

  END;
  END;
(* line 370 "E.pum" *)
      RETURN TRUE;

 END IsNotToBeDeclared;

PROCEDURE IsGenuineEmptyEntry* (yyP5: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP5 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP5^.Kind = OB.mtEntry) THEN
(* line 374 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsGenuineEmptyEntry;

PROCEDURE IsErrorEntry* (yyP6: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP6 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP6^.Kind = OB.ErrorEntry) THEN
(* line 378 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsErrorEntry;

PROCEDURE IsExportedEntry* (yyP7: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP7 = OB.NoOB THEN RETURN FALSE; END;
  IF OB.IsType (yyP7, OB.DataEntry) THEN
  IF (yyIsEqual ( yyP7^.DataEntry.exportMode ,   OB.PRIVATE ) ) THEN
(* line 382 "E.pum" *)
(* line 382 "E.pum" *)
      RETURN FALSE;

  END;
  END;
(* line 383 "E.pum" *)
      RETURN TRUE;

 END IsExportedEntry;

PROCEDURE IsExportedInheritedProc* (yyP8: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP8 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP8^.Kind = OB.InheritedProcEntry) THEN
  IF (yyP8^.InheritedProcEntry.boundProcEntry^.Kind = OB.BoundProcEntry) THEN
(* line 388 "E.pum" *)
(* line 401 "E.pum" *)
      RETURN (yyP8^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.exportMode#OB.PRIVATE);
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsExportedInheritedProc;

PROCEDURE IsExternEntry* (yyP9: OB.tOB; Module: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP9 = OB.NoOB THEN RETURN FALSE; END;
  IF Module = OB.NoOB THEN RETURN FALSE; END;
  IF OB.IsType (yyP9, OB.DataEntry) THEN
(* line 405 "E.pum" *)
(* line 405 "E.pum" *)
      RETURN (yyP9^.DataEntry.module^.ModuleEntry.name#Module^.ModuleEntry.name);
      RETURN TRUE;

  END;
(* line 406 "E.pum" *)
      RETURN TRUE;

 END IsExternEntry;

PROCEDURE IsWritableEntry* (yyP10: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP10 = OB.NoOB THEN RETURN FALSE; END;
  IF OB.IsType (yyP10, OB.DataEntry) THEN
  IF (yyIsEqual ( yyP10^.DataEntry.exportMode ,   OB.READONLY ) ) THEN
(* line 410 "E.pum" *)
(* line 410 "E.pum" *)
      RETURN FALSE;

  END;
  END;
(* line 411 "E.pum" *)
      RETURN TRUE;

 END IsWritableEntry;

PROCEDURE IsServerEntry* (yyP11: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP11 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP11^.Kind = OB.ErrorEntry) THEN
(* line 415 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP11^.Kind = OB.ServerEntry) THEN
(* line 416 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsServerEntry;

PROCEDURE IsNotServerEntry* (yyP12: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP12 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP12^.Kind = OB.ServerEntry) THEN
(* line 420 "E.pum" *)
(* line 420 "E.pum" *)
      RETURN FALSE;

  END;
(* line 421 "E.pum" *)
      RETURN TRUE;

 END IsNotServerEntry;

PROCEDURE ServerHasExistingTable* (yyP13: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP13 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP13^.Kind = OB.ServerEntry) THEN
  IF (yyP13^.ServerEntry.serverTable^.Kind = OB.ErrorEntry) THEN
(* line 426 "E.pum" *)
(* line 434 "E.pum" *)
      RETURN FALSE;

  END;
  END;
(* line 436 "E.pum" *)
      RETURN TRUE;

 END ServerHasExistingTable;

PROCEDURE IsTypeEntry* (yyP14: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP14 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP14^.Kind = OB.ErrorEntry) THEN
(* line 440 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP14^.Kind = OB.TypeEntry) THEN
(* line 441 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsTypeEntry;

PROCEDURE IsNotTypeEntry* (yyP15: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP15 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP15^.Kind = OB.TypeEntry) THEN
(* line 445 "E.pum" *)
(* line 445 "E.pum" *)
      RETURN FALSE;

  END;
(* line 446 "E.pum" *)
      RETURN TRUE;

 END IsNotTypeEntry;

PROCEDURE IsVarEntry* (yyP16: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP16 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP16^.Kind = OB.ErrorEntry) THEN
(* line 450 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP16^.Kind = OB.VarEntry) THEN
(* line 451 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsVarEntry;

PROCEDURE IsVarParamEntry* (yyP17: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP17 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP17^.Kind = OB.ErrorEntry) THEN
(* line 455 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP17^.Kind = OB.VarEntry) THEN
  IF ( yyP17^.VarEntry.isParam  =   TRUE  ) THEN
  IF (yyIsEqual ( yyP17^.VarEntry.parMode ,   OB.REFPAR ) ) THEN
(* line 457 "E.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  RETURN FALSE;
 END IsVarParamEntry;

PROCEDURE IsProcedureEntry* (yyP18: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP18 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP18^.Kind = OB.ErrorEntry) THEN
(* line 472 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP18^.Kind = OB.ProcedureEntry) THEN
(* line 473 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsProcedureEntry;

PROCEDURE IsBoundProcEntry* (yyP19: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP19 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP19^.Kind = OB.ErrorEntry) THEN
(* line 477 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP19^.Kind = OB.BoundProcEntry) THEN
(* line 478 "E.pum" *)
      RETURN TRUE;

  END;
  IF (yyP19^.Kind = OB.InheritedProcEntry) THEN
(* line 479 "E.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsBoundProcEntry;

PROCEDURE IsForwardProcEntry* (yyP20: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP20 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP20^.Kind = OB.ProcedureEntry) THEN
  IF ( yyP20^.ProcedureEntry.complete  =   FALSE  ) THEN
(* line 484 "E.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsForwardProcEntry;

PROCEDURE IsReceiverEntry* (yyP21: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP21 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP21^.Kind = OB.VarEntry) THEN
  IF ( yyP21^.VarEntry.isReceiverPar  =   TRUE  ) THEN
(* line 498 "E.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsReceiverEntry;

PROCEDURE IsVisibleBoundProcEntry* (Module: OB.tOB; yyP22: OB.tOB): BOOLEAN;
 BEGIN
  IF Module = OB.NoOB THEN RETURN FALSE; END;
  IF yyP22 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP22^.Kind = OB.BoundProcEntry) THEN
(* line 513 "E.pum" *)
(* line 520 "E.pum" *)
       RETURN (yyP22^.BoundProcEntry.module = Module)
                                  OR (yyP22^.BoundProcEntry.exportMode # OB.PRIVATE)
                            ;
      RETURN TRUE;

  END;
  IF (yyP22^.Kind = OB.InheritedProcEntry) THEN
(* line 524 "E.pum" *)
   LOOP
(* line 533 "E.pum" *)
      IF ~(IsVisibleBoundProcEntry (Module, yyP22^.InheritedProcEntry.boundProcEntry)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END IsVisibleBoundProcEntry;

PROCEDURE DeclStatusOfEntry* (yyP23: OB.tOB): tDeclStatus;
 BEGIN
  IF OB.IsType (yyP23, OB.DataEntry) THEN
(* line 538 "E.pum" *)
      RETURN yyP23^.DataEntry.declStatus;

  END;
(* line 539 "E.pum" *)
      RETURN OB.UNDECLARED;

 END DeclStatusOfEntry;

PROCEDURE IdentOfEntry* (yyP24: OB.tOB): tIdent;
 BEGIN
  IF (yyP24^.Kind = OB.ModuleEntry) THEN
(* line 544 "E.pum" *)
      RETURN yyP24^.ModuleEntry.name;

  END;
  IF OB.IsType (yyP24, OB.DataEntry) THEN
(* line 545 "E.pum" *)
      RETURN yyP24^.DataEntry.ident;

  END;
(* line 546 "E.pum" *)
      RETURN Idents.NoIdent;

 END IdentOfEntry;

PROCEDURE TypeOfEntry* (yyP25: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP25^.Kind = OB.ConstEntry) THEN
(* line 551 "E.pum" *)
      RETURN yyP25^.ConstEntry.typeRepr;

  END;
  IF (yyP25^.Kind = OB.TypeEntry) THEN
(* line 552 "E.pum" *)
      RETURN yyP25^.TypeEntry.typeRepr;

  END;
  IF (yyP25^.Kind = OB.VarEntry) THEN
(* line 553 "E.pum" *)
      RETURN yyP25^.VarEntry.typeRepr;

  END;
  IF (yyP25^.Kind = OB.ProcedureEntry) THEN
(* line 554 "E.pum" *)
      RETURN yyP25^.ProcedureEntry.typeRepr;

  END;
  IF (yyP25^.Kind = OB.BoundProcEntry) THEN
(* line 555 "E.pum" *)
      RETURN yyP25^.BoundProcEntry.typeRepr;

  END;
(* line 556 "E.pum" *)
      RETURN OB.cErrorTypeRepr;

 END TypeOfEntry;

PROCEDURE LabelOfEntry* (yyP26: OB.tOB): tLabel;
 BEGIN
  IF (yyP26^.Kind = OB.ConstEntry) THEN
(* line 561 "E.pum" *)
      RETURN yyP26^.ConstEntry.label;

  END;
  IF (yyP26^.Kind = OB.ProcedureEntry) THEN
(* line 562 "E.pum" *)
      RETURN yyP26^.ProcedureEntry.label;

  END;
  IF (yyP26^.Kind = OB.BoundProcEntry) THEN
(* line 563 "E.pum" *)
      RETURN yyP26^.BoundProcEntry.label;

  END;
(* line 564 "E.pum" *)
      RETURN LAB.MT;

 END LabelOfEntry;

PROCEDURE AddressOfVarEntry* (yyP27: OB.tOB): tAddress;
 BEGIN
  IF (yyP27^.Kind = OB.VarEntry) THEN
(* line 569 "E.pum" *)
      RETURN yyP27^.VarEntry.address;

  END;
(* line 570 "E.pum" *)
      RETURN 0;

 END AddressOfVarEntry;

PROCEDURE TypeOfTypeEntry* (yyP28: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP28^.Kind = OB.TypeEntry) THEN
(* line 575 "E.pum" *)
      RETURN yyP28^.TypeEntry.typeRepr;

  END;
(* line 576 "E.pum" *)
      RETURN OB.cErrorTypeRepr;

 END TypeOfTypeEntry;

PROCEDURE SizeOfTypeEntry* (yyP29: OB.tOB): tSize;
 BEGIN
  IF (yyP29^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (yyP29^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 581 "E.pum" *)
      RETURN yyP29^.TypeEntry.typeRepr^.TypeRepr.size;

  END;
  END;
(* line 582 "E.pum" *)
      RETURN 0;

 END SizeOfTypeEntry;

PROCEDURE TypeOfVarEntry* (yyP30: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP30^.Kind = OB.VarEntry) THEN
(* line 587 "E.pum" *)
      RETURN yyP30^.VarEntry.typeRepr;

  END;
  IF (yyP30^.Kind = OB.BoundProcEntry) THEN
(* line 597 "E.pum" *)
      RETURN yyP30^.BoundProcEntry.typeRepr;

  END;
  IF (yyP30^.Kind = OB.InheritedProcEntry) THEN
(* line 608 "E.pum" *)
      RETURN TypeOfVarEntry (yyP30^.InheritedProcEntry.boundProcEntry);

  END;
(* line 617 "E.pum" *)
      RETURN OB.cErrorTypeRepr;

 END TypeOfVarEntry;

PROCEDURE SignatureOfProcEntry* (yyP31: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP31^.Kind = OB.ProcedureEntry) THEN
  IF OB.IsType (yyP31^.ProcedureEntry.typeRepr, OB.ProcedureTypeRepr) THEN
(* line 622 "E.pum" *)
      RETURN yyP31^.ProcedureEntry.typeRepr^.ProcedureTypeRepr.signatureRepr;

  END;
  END;
(* line 639 "E.pum" *)
      RETURN OB.cErrorSignature;

 END SignatureOfProcEntry;

PROCEDURE ReceiverTypeOfBoundProc* (yyP32: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP32^.Kind = OB.BoundProcEntry) THEN
  IF (yyP32^.BoundProcEntry.receiverSig^.Kind = OB.Signature) THEN
(* line 644 "E.pum" *)
      RETURN yyP32^.BoundProcEntry.receiverSig^.Signature.VarEntry^.VarEntry.typeRepr;

  END;
  END;
(* line 664 "E.pum" *)
      RETURN OB.cErrorTypeRepr;

 END ReceiverTypeOfBoundProc;

PROCEDURE BoundProcEntryOfBoundProc* (yyP33: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP33^.Kind = OB.BoundProcEntry) THEN
(* line 669 "E.pum" *)
      RETURN yyP33;

  END;
  IF (yyP33^.Kind = OB.InheritedProcEntry) THEN
  IF (yyP33^.InheritedProcEntry.boundProcEntry^.Kind = OB.BoundProcEntry) THEN
(* line 671 "E.pum" *)
      RETURN yyP33^.InheritedProcEntry.boundProcEntry;

  END;
  END;
  yyAbort ('BoundProcEntryOfBoundProc');
 END BoundProcEntryOfBoundProc;

PROCEDURE LabelOfRedefinedBoundProc* (yyP34: OB.tOB): tLabel;
 BEGIN
  IF (yyP34^.Kind = OB.BoundProcEntry) THEN
(* line 683 "E.pum" *)
      RETURN LabelOfEntry (yyP34^.BoundProcEntry.redefinedProc);

  END;
  IF (yyP34^.Kind = OB.InheritedProcEntry) THEN
  IF (yyP34^.InheritedProcEntry.boundProcEntry^.Kind = OB.BoundProcEntry) THEN
(* line 700 "E.pum" *)
      RETURN LabelOfEntry (yyP34^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.redefinedProc);

  END;
  END;
  yyAbort ('LabelOfRedefinedBoundProc');
 END LabelOfRedefinedBoundProc;

PROCEDURE ExprValueOfEntry* (yyP35: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP35^.Kind = OB.ConstEntry) THEN
(* line 727 "E.pum" *)
      RETURN yyP35^.ConstEntry.value;

  END;
  IF (yyP35^.Kind = OB.ProcedureEntry) THEN
(* line 738 "E.pum" *)
      RETURN OB.cProcedureValue;

  END;
(* line 740 "E.pum" *)
      RETURN OB.cmtValue       ;

 END ExprValueOfEntry;

PROCEDURE PosOfForwardEntry* (yyP36: OB.tOB; VAR yyP37: tPosition);
 BEGIN
  IF yyP36 = OB.NoOB THEN RETURN; END;
  IF (yyP36^.Kind = OB.TypeEntry) THEN
  IF (yyP36^.TypeEntry.typeRepr^.Kind = OB.ForwardTypeRepr) THEN
(* line 745 "E.pum" *)
      yyP37 := yyP36^.TypeEntry.typeRepr^.ForwardTypeRepr.position;
      RETURN;

  END;
  END;
(* line 761 "E.pum" *)
      yyP37 := POS.NoPosition;
      RETURN;

 END PosOfForwardEntry;

PROCEDURE LevelOfProcEntry* (yyP38: OB.tOB): tLevel;
 BEGIN
  IF (yyP38^.Kind = OB.ProcedureEntry) THEN
(* line 766 "E.pum" *)
      RETURN yyP38^.ProcedureEntry.level;

  END;
(* line 774 "E.pum" *)
      RETURN OB . MODULELEVEL;

 END LevelOfProcEntry;

PROCEDURE LevelsOfEnv* (yyP39: OB.tOB): SET;
 BEGIN
  IF (yyP39^.Kind = OB.Environment) THEN
(* line 779 "E.pum" *)
      RETURN yyP39^.Environment.callDstLevels;

  END;
(* line 780 "E.pum" *)
      RETURN OB . ALLLEVELS;

 END LevelsOfEnv;

PROCEDURE CheckUnresolvedForwardPointers* (Table: OB.tOB): OB.tOB;
 BEGIN
  IF (Table^.Kind = OB.TypeEntry) THEN
  IF (Table^.TypeEntry.typeRepr^.Kind = OB.ForwardTypeRepr) THEN
(* line 785 "E.pum" *)
(* line 793 "E.pum" *)
       Table^.TypeEntry.prevEntry:=CheckUnresolvedForwardPointers(Table^.TypeEntry.prevEntry);
                                                         ERR.MsgPos(ERR.MsgUnresolvedForwardType,Table^.TypeEntry.typeRepr^.ForwardTypeRepr.position);
                                                       ;
      RETURN Table;

  END;
  END;
  IF OB.IsType (Table, OB.DataEntry) THEN
(* line 797 "E.pum" *)
(* line 800 "E.pum" *)
       Table^.DataEntry.prevEntry:=CheckUnresolvedForwardPointers(Table^.DataEntry.prevEntry); ;
      RETURN Table;

  END;
(* line 802 "E.pum" *)
      RETURN Table;

 END CheckUnresolvedForwardPointers;

PROCEDURE CheckUnresolvedForwardProcs* (table: OB.tOB): OB.tOB;
 BEGIN
  IF (table^.Kind = OB.ProcedureEntry) THEN
  IF ( table^.ProcedureEntry.complete  =   FALSE  ) THEN
(* line 807 "E.pum" *)
(* line 818 "E.pum" *)
       table^.ProcedureEntry.prevEntry:=CheckUnresolvedForwardProcs(table^.ProcedureEntry.prevEntry);
                                 ERR.MsgPos(ERR.MsgUnresolvedForwardProc,table^.ProcedureEntry.position);
                               ;
      RETURN table;

  END;
  END;
  IF (table^.Kind = OB.BoundProcEntry) THEN
  IF ( table^.BoundProcEntry.complete  =   FALSE  ) THEN
(* line 822 "E.pum" *)
(* line 834 "E.pum" *)
       table^.BoundProcEntry.prevEntry:=CheckUnresolvedForwardProcs(table^.BoundProcEntry.prevEntry);
                                 ERR.MsgPos(ERR.MsgUnresolvedForwardProc,table^.BoundProcEntry.position);
                               ;
      RETURN table;

  END;
  END;
  IF OB.IsType (table, OB.DataEntry) THEN
(* line 838 "E.pum" *)
(* line 841 "E.pum" *)
       table^.DataEntry.prevEntry:=CheckUnresolvedForwardProcs(table^.DataEntry.prevEntry); ;
      RETURN table;

  END;
(* line 843 "E.pum" *)
      RETURN table;

 END CheckUnresolvedForwardProcs;

PROCEDURE CheckUnresolvedForwardBoundProcs* (table: OB.tOB): OB.tOB;
 BEGIN
  IF (table^.Kind = OB.TypeEntry) THEN
  IF (table^.TypeEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 848 "E.pum" *)
(* line 867 "E.pum" *)
       table^.TypeEntry.prevEntry:=CheckUnresolvedForwardBoundProcs(table^.TypeEntry.prevEntry);
                                                           table^.TypeEntry.typeRepr^.RecordTypeRepr.fields:=CheckUnresolvedForwardProcs(table^.TypeEntry.typeRepr^.RecordTypeRepr.fields);
                                                         ;
      RETURN table;

  END;
  END;
  IF OB.IsType (table, OB.DataEntry) THEN
(* line 871 "E.pum" *)
(* line 874 "E.pum" *)
       table^.DataEntry.prevEntry:=CheckUnresolvedForwardBoundProcs(table^.DataEntry.prevEntry); ;
      RETURN table;

  END;
(* line 876 "E.pum" *)
      RETURN table;

 END CheckUnresolvedForwardBoundProcs;

PROCEDURE ForwardProcOnly* (entry: OB.tOB): OB.tOB;
 BEGIN
  IF (entry^.Kind = OB.ProcedureEntry) THEN
  IF ( entry^.ProcedureEntry.complete  =   FALSE  ) THEN
(* line 881 "E.pum" *)
      RETURN entry;

  END;
  END;
(* line 892 "E.pum" *)
      RETURN OB.cErrorEntry;

 END ForwardProcOnly;

PROCEDURE MaxExportMode* (yyP41: tExportMode; yyP40: tExportMode): tExportMode;
 BEGIN
  IF (yyIsEqual ( yyP41 ,   OB.PUBLIC   ) ) THEN
(* line 897 "E.pum" *)
      RETURN OB.PUBLIC  ;

  END;
  IF (yyIsEqual ( yyP40 ,   OB.PUBLIC   ) ) THEN
(* line 898 "E.pum" *)
      RETURN OB.PUBLIC  ;

  END;
  IF (yyIsEqual ( yyP41 ,   OB.READONLY ) ) THEN
(* line 899 "E.pum" *)
      RETURN OB.READONLY;

  END;
  IF (yyIsEqual ( yyP40 ,   OB.READONLY ) ) THEN
(* line 900 "E.pum" *)
      RETURN OB.READONLY;

  END;
(* line 901 "E.pum" *)
      RETURN OB.PRIVATE ;

 END MaxExportMode;

PROCEDURE ApplyPointerBaseIdent* (ForwardPBaseIsOkIn: BOOLEAN; Entry: OB.tOB; TableIn: OB.tOB; LevelIn: tLevel; ModuleIn: OB.tOB; Ident: tIdent; Position: tPosition; VAR TableOut: OB.tOB): OB.tOB;
(* line 913 "E.pum" *)
VAR e,t:OB.tOB;
 BEGIN
  IF ( ForwardPBaseIsOkIn  =   TRUE  ) THEN
  IF (Entry^.Kind = OB.ErrorEntry) THEN
(* line 916 "E.pum" *)
(* line 921 "E.pum" *)
       t := OB.mForwardTypeRepr
                                    (  OB.cNonameEntry
                                    ,  0
                                    ,  OB.mTypeBlocklists(NIL,NIL)
                                    ,  FALSE
                                    ,  LAB.MT
                                    ,  Position);
                               e := OB.mTypeEntry    
                                    (  TableIn
                                    ,  ModuleIn
                                    ,  Ident
                                    ,  OB.PRIVATE
                                    ,  LevelIn
                                    ,  OB.FORWARDDECLARED
                                    ,  t);
                               LinkTypeToEntry(t,e);
                             ;
      TableOut := e;
      RETURN e;

  END;
  END;
  IF ( ForwardPBaseIsOkIn  =   TRUE  ) THEN
  IF (Entry^.Kind = OB.TypeEntry) THEN
  IF (yyIsEqual ( Entry^.TypeEntry.declStatus ,   OB.FORWARDDECLARED ) ) THEN
  IF (Entry^.TypeEntry.typeRepr^.Kind = OB.ForwardTypeRepr) THEN
(* line 940 "E.pum" *)
      TableOut := TableIn;
      RETURN Entry;

  END;
  END;
  END;
  END;
  IF (Entry^.Kind = OB.TypeEntry) THEN
  IF (yyIsEqual ( Entry^.TypeEntry.declStatus ,   OB.TOBEDECLARED ) ) THEN
(* line 954 "E.pum" *)
      TableOut := TableIn;
      RETURN Entry;

  END;
  IF (yyIsEqual ( Entry^.TypeEntry.declStatus ,   OB.DECLARED ) ) THEN
(* line 968 "E.pum" *)
      TableOut := TableIn;
      RETURN Entry;

  END;
  END;
(* line 982 "E.pum" *)
      TableOut := TableIn;
      RETURN OB.cErrorEntry;

 END ApplyPointerBaseIdent;

PROCEDURE GetServerTable* (Table: OB.tOB; RefId: tIdent): OB.tOB;
 BEGIN
  IF (Table^.Kind = OB.ServerEntry) THEN
  IF ( Table^.ServerEntry.ident  =   RefId  ) THEN
(* line 990 "E.pum" *)
      RETURN Table^.ServerEntry.serverTable;

  END;
  END;
  IF OB.IsType (Table, OB.DataEntry) THEN
  IF ( Table^.DataEntry.ident  =   RefId  ) THEN
(* line 1001 "E.pum" *)
      RETURN OB.cmtEntry;

  END;
  END;
  IF OB.IsType (Table, OB.Entry) THEN
(* line 1003 "E.pum" *)
      RETURN GetServerTable (Table^.Entry.prevEntry, RefId);

  END;
(* line 1006 "E.pum" *)
      RETURN OB.cmtEntry;

 END GetServerTable;

PROCEDURE EntryWithed* (module: OB.tOB; qualification: tIdent; table: OB.tOB; variable: OB.tOB; type: OB.tOB): OB.tOB;
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (variable^.Kind = OB.VarEntry) THEN
  IF (OB.IsEqualOB ( variable^.VarEntry.module ,   module ) ) THEN
(* line 1018 "E.pum" *)
       yyTempo.yyR1.yyV1  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR1.yyV1 ) >=  SYSTEM.VAL(LONGINT,OB .yyPoolMaxPtr) THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . VarEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . VarEntry ; 
      yyTempo.yyR1.yyV1^.VarEntry.prevEntry := table;
      yyTempo.yyR1.yyV1^.VarEntry.module := module;
      yyTempo.yyR1.yyV1^.VarEntry.ident := variable^.VarEntry.ident;
      yyTempo.yyR1.yyV1^.VarEntry.exportMode := variable^.VarEntry.exportMode;
      yyTempo.yyR1.yyV1^.VarEntry.level := variable^.VarEntry.level;
      yyTempo.yyR1.yyV1^.VarEntry.declStatus := variable^.VarEntry.declStatus;
      yyTempo.yyR1.yyV1^.VarEntry.typeRepr := type;
      yyTempo.yyR1.yyV1^.VarEntry.isParam := variable^.VarEntry.isParam;
      yyTempo.yyR1.yyV1^.VarEntry.isReceiverPar := variable^.VarEntry.isReceiverPar;
      yyTempo.yyR1.yyV1^.VarEntry.parMode := variable^.VarEntry.parMode;
      yyTempo.yyR1.yyV1^.VarEntry.address := variable^.VarEntry.address;
      yyTempo.yyR1.yyV1^.VarEntry.refMode := variable^.VarEntry.refMode;
      yyTempo.yyR1.yyV1^.VarEntry.isWithed := TRUE;
      yyTempo.yyR1.yyV1^.VarEntry.isLaccessed := variable^.VarEntry.isLaccessed;
      RETURN yyTempo.yyR1.yyV1;

    END;
(* line 1056 "E.pum" *)
       yyTempo.yyR2.yyV1  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR2.yyV1 ) >=  SYSTEM.VAL(LONGINT,OB .yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . ServerEntry ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . ServerEntry ; 
      yyTempo.yyR2.yyV1^.ServerEntry.prevEntry := table;
      yyTempo.yyR2.yyV1^.ServerEntry.module := module;
      yyTempo.yyR2.yyV1^.ServerEntry.ident := qualification;
      yyTempo.yyR2.yyV1^.ServerEntry.exportMode := OB.PRIVATE;
      yyTempo.yyR2.yyV1^.ServerEntry.level := OB.MODULELEVEL;
      yyTempo.yyR2.yyV1^.ServerEntry.declStatus := OB.DECLARED;
       yyTempo.yyR2.yyV1^.ServerEntry.serverTable  :=  SYSTEM.VAL(OB.tOB,OB .yyPoolFreePtr); IF SYSTEM.VAL(LONGINT, yyTempo.yyR2.yyV1^.ServerEntry.serverTable ) >=  SYSTEM.VAL(LONGINT,OB .yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1^.ServerEntry.serverTable  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . VarEntry ]);  yyTempo.yyR2.yyV1^.ServerEntry.serverTable ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1^.ServerEntry.serverTable ^.Kind :=  OB . VarEntry ; 
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.prevEntry := GetServerTable (table, qualification);
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.module := variable^.VarEntry.module;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.ident := variable^.VarEntry.ident;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.exportMode := variable^.VarEntry.exportMode;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.level := variable^.VarEntry.level;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.declStatus := variable^.VarEntry.declStatus;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.typeRepr := type;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.isParam := variable^.VarEntry.isParam;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.isReceiverPar := variable^.VarEntry.isReceiverPar;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.parMode := variable^.VarEntry.parMode;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.address := variable^.VarEntry.address;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.refMode := variable^.VarEntry.refMode;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.isWithed := TRUE;
      yyTempo.yyR2.yyV1^.ServerEntry.serverTable^.VarEntry.isLaccessed := variable^.VarEntry.isLaccessed;
      yyTempo.yyR2.yyV1^.ServerEntry.serverId := yyTempo.yyR2.yyV1^.ServerEntry.serverId;
      RETURN yyTempo.yyR2.yyV1;

  END;
(* line 1102 "E.pum" *)
      RETURN table;

 END EntryWithed;

PROCEDURE SetLaccess* (yyP42: OB.tOB);
 BEGIN
  IF yyP42 = OB.NoOB THEN RETURN; END;
  IF (yyP42^.Kind = OB.VarEntry) THEN
(* line 1107 "E.pum" *)
(* line 1121 "E.pum" *)
       yyP42^.VarEntry.isLaccessed:=TRUE; ;
      RETURN;

  END;
 END SetLaccess;

PROCEDURE InclEnvLevel* (yyP43: OB.tOB; level: tLevel);
 BEGIN
  IF yyP43 = OB.NoOB THEN RETURN; END;
  IF (yyP43^.Kind = OB.Environment) THEN
(* line 1126 "E.pum" *)
   LOOP
(* line 1128 "E.pum" *)
      IF ~(((0 <= level) & (level <= 31))) THEN EXIT; END;
(* line 1129 "E.pum" *)
       INCL(yyP43^.Environment.callDstLevels,level); ;
      RETURN;
   END;

  END;
 END InclEnvLevel;

PROCEDURE BeginE*;
 BEGIN
 END BeginE;

PROCEDURE CloseE*;
 BEGIN
 END CloseE;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginE;
END E.

