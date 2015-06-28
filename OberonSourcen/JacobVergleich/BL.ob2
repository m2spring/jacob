MODULE BL;








IMPORT Base,SYSTEM, System, IO, OB,
(* line 29 "BL.pum" *)
               LIM      ,
               UTI      ; 


        TYPE   tAddress* = OB.tAddress;
               tSize*    = OB.tSize; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;



















































































































PROCEDURE^AreEqualBlocklists (al: OB.tOB; bl: OB.tOB): BOOLEAN;
PROCEDURE^CalcPtrBlocklist (t: OB.tOB): OB.tOB;
PROCEDURE^PtrBlocklistOfOpenArrayType (t: OB.tOB; odim: LONGINT): OB.tOB;
PROCEDURE^PtrBlocklistOfRecordType (fields: OB.tOB): OB.tOB;
PROCEDURE^PtrBlOfProcLocals (decls: OB.tOB; b1: OB.tOB): OB.tOB;
PROCEDURE^PtrBlOfProcDecls (decls: OB.tOB; b1: OB.tOB): OB.tOB;
PROCEDURE^CalcProcBlocklist (t: OB.tOB): OB.tOB;
PROCEDURE^ProcBlocklistOfOpenArrayType (t: OB.tOB; odim: LONGINT): OB.tOB;
PROCEDURE^ProcBlocklistOfRecordType (fields: OB.tOB): OB.tOB;
PROCEDURE^ProcBlOfProcLocals (decls: OB.tOB; b1: OB.tOB): OB.tOB;


PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module BL, routine ');
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

PROCEDURE IsEmptyBlocklist* (yyP1: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP1^.Kind = OB.NoBlocklist) THEN
(* line 37 "BL.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsEmptyBlocklist;

PROCEDURE HeightOfBlocklist (yyP2: OB.tOB): LONGINT;
 BEGIN
  IF (yyP2^.Kind = OB.Blocklist) THEN
(* line 42 "BL.pum" *)
      RETURN UTI.MaxLI(HeightOfBlocklist(yyP2^.Blocklist.prev),yyP2^.Blocklist.height);

  END;
(* line 43 "BL.pum" *)
      RETURN 0;

 END HeightOfBlocklist;

PROCEDURE AdjustIncr (bl: OB.tOB; elemSize: tSize): OB.tOB;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (bl^.Kind = OB.Blocklist) THEN
  IF (bl^.Blocklist.prev^.Kind = OB.NoBlocklist) THEN
(* line 48 "BL.pum" *)
   LOOP
(* line 49 "BL.pum" *)
      IF ~((bl^.Blocklist.count = 1)) THEN EXIT; END;                                                                                                       
       yyTempo.yyR1.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR1.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR1.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR1.yyV1^.Blocklist.sub := bl^.Blocklist.sub;
      yyTempo.yyR1.yyV1^.Blocklist.ofs := bl^.Blocklist.ofs;
      yyTempo.yyR1.yyV1^.Blocklist.count := bl^.Blocklist.count;
      yyTempo.yyR1.yyV1^.Blocklist.incr := elemSize;
      yyTempo.yyR1.yyV1^.Blocklist.height := bl^.Blocklist.height;
      RETURN yyTempo.yyR1.yyV1;
    END;

  END;
  END;
(* line 51 "BL.pum" *)
      RETURN bl;

 END AdjustIncr;

PROCEDURE ConcatBlocklists (b1: OB.tOB; b2: OB.tOB; base: tAddress): OB.tOB;
 VAR yyTempo: RECORD 
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 yyR3: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (b2^.Kind = OB.NoBlocklist) THEN
(* line 57 "BL.pum" *)
      RETURN b1;

  END;
  IF (b1^.Kind = OB.Blocklist) THEN
  IF (b2^.Kind = OB.Blocklist) THEN
  IF (b2^.Blocklist.prev^.Kind = OB.NoBlocklist) THEN
(* line 61 "BL.pum" *)
   LOOP
(* line 66 "BL.pum" *)
      IF ~((b1^.Blocklist.incr = b2^.Blocklist.incr) & (b1^.Blocklist.ofs + b1^.Blocklist.count * b1^.Blocklist.incr = base + b2^.Blocklist.ofs) & AreEqualBlocklists (b1^.Blocklist.sub, b2^.Blocklist.sub)) THEN EXIT; END;
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR2.yyV1^.Blocklist.prev := b1^.Blocklist.prev;
      yyTempo.yyR2.yyV1^.Blocklist.sub := b2^.Blocklist.sub;
      yyTempo.yyR2.yyV1^.Blocklist.ofs := b1^.Blocklist.ofs;
      yyTempo.yyR2.yyV1^.Blocklist.count := b1^.Blocklist.count + b2^.Blocklist.count;
      yyTempo.yyR2.yyV1^.Blocklist.incr := b2^.Blocklist.incr;
      yyTempo.yyR2.yyV1^.Blocklist.height := b2^.Blocklist.height;
      RETURN yyTempo.yyR2.yyV1;
   END;

  END;
  END;
  END;
  IF (b2^.Kind = OB.Blocklist) THEN
(* line 68 "BL.pum" *)
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR3.yyV1^.Blocklist.prev := ConcatBlocklists (b1, b2^.Blocklist.prev, base);
      yyTempo.yyR3.yyV1^.Blocklist.sub := b2^.Blocklist.sub;
      yyTempo.yyR3.yyV1^.Blocklist.ofs := base + b2^.Blocklist.ofs;
      yyTempo.yyR3.yyV1^.Blocklist.count := b2^.Blocklist.count;
      yyTempo.yyR3.yyV1^.Blocklist.incr := b2^.Blocklist.incr;
      yyTempo.yyR3.yyV1^.Blocklist.height := b2^.Blocklist.height;
      RETURN yyTempo.yyR3.yyV1;

  END;
  yyAbort ('ConcatBlocklists');
 END ConcatBlocklists;

PROCEDURE AreEqualBlocklists (al: OB.tOB; bl: OB.tOB): BOOLEAN;
 BEGIN
  IF al = OB.NoOB THEN RETURN FALSE; END;
  IF bl = OB.NoOB THEN RETURN FALSE; END;
  IF (al^.Kind = OB.NoBlocklist) THEN
  IF (bl^.Kind = OB.NoBlocklist) THEN
(* line 75 "BL.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (al^.Kind = OB.Blocklist) THEN
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 76 "BL.pum" *)
   LOOP
(* line 81 "BL.pum" *)
      IF ~((al^.Blocklist.ofs = bl^.Blocklist.ofs) & (al^.Blocklist.count = bl^.Blocklist.count) & (al^.Blocklist.incr = bl^.Blocklist.incr) & (al^.Blocklist.height = bl^.Blocklist.height) & AreEqualBlocklists (al^.Blocklist.sub, bl^.Blocklist.sub) & AreEqualBlocklists (al^.Blocklist.prev, bl^.Blocklist.prev)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  END;
  RETURN FALSE;
 END AreEqualBlocklists;

PROCEDURE BlocklistOfArrayType (elemBl: OB.tOB; len: tSize; elemSize: tSize): OB.tOB;
(* line 85 "BL.pum" *)
 VAR bl:OB.tOB; h:LONGINT; 
 VAR yyTempo: RECORD
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 yyR3: RECORD
  yyV1: OB.tOB;
  END;
 yyR4: RECORD
  yyV1: OB.tOB;
  END;
 yyR5: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (elemBl^.Kind = OB.NoBlocklist) THEN
(* line 87 "BL.pum" *)
      RETURN OB.cNoBlocklist;

  END;
  IF (elemBl^.Kind = OB.Blocklist) THEN
  IF (elemBl^.Blocklist.prev^.Kind = OB.NoBlocklist) THEN
(* line 90 "BL.pum" *)
   LOOP
(* line 91 "BL.pum" *)
      IF ~((elemBl^.Blocklist.count = 1)) THEN EXIT; END;
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR2.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR2.yyV1^.Blocklist.sub := elemBl^.Blocklist.sub;
      yyTempo.yyR2.yyV1^.Blocklist.ofs := elemBl^.Blocklist.ofs;
      yyTempo.yyR2.yyV1^.Blocklist.count := len;
      yyTempo.yyR2.yyV1^.Blocklist.incr := elemSize;
      yyTempo.yyR2.yyV1^.Blocklist.height := elemBl^.Blocklist.height;
      RETURN yyTempo.yyR2.yyV1;
   END;

(* line 93 "BL.pum" *)
   LOOP
(* line 94 "BL.pum" *)
      IF ~((elemBl^.Blocklist.count * elemBl^.Blocklist.incr = elemSize)) THEN EXIT; END;
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR3.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR3.yyV1^.Blocklist.sub := elemBl^.Blocklist.sub;
      yyTempo.yyR3.yyV1^.Blocklist.ofs := elemBl^.Blocklist.ofs;
      yyTempo.yyR3.yyV1^.Blocklist.count := elemBl^.Blocklist.count * len;
      yyTempo.yyR3.yyV1^.Blocklist.incr := elemBl^.Blocklist.incr;
      yyTempo.yyR3.yyV1^.Blocklist.height := elemBl^.Blocklist.height;
      RETURN yyTempo.yyR3.yyV1;
   END;

  END;
(* line 96 "BL.pum" *)
   LOOP
(* line 97 "BL.pum" *)
      IF ~((len = 1)) THEN EXIT; END;
       yyTempo.yyR4.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR4.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR4.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR4.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR4.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR4.yyV1^.Blocklist.prev := elemBl^.Blocklist.prev;
      yyTempo.yyR4.yyV1^.Blocklist.sub := elemBl^.Blocklist.sub;
      yyTempo.yyR4.yyV1^.Blocklist.ofs := elemBl^.Blocklist.ofs;
      yyTempo.yyR4.yyV1^.Blocklist.count := elemBl^.Blocklist.count;
      yyTempo.yyR4.yyV1^.Blocklist.incr := elemBl^.Blocklist.incr;
      yyTempo.yyR4.yyV1^.Blocklist.height := elemBl^.Blocklist.height;
      RETURN yyTempo.yyR4.yyV1;
   END;

  END;
(* line 99 "BL.pum" *)
(* line 101 "BL.pum" *)
        h:=HeightOfBlocklist(elemBl); 
           IF (h>0) OR (len<0) OR (len>LIM.BlocklistLoopUnrollingThreshold) THEN INC(h); END;
        ;
       yyTempo.yyR5.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR5.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR5.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR5.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR5.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR5.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR5.yyV1^.Blocklist.sub := elemBl;
      yyTempo.yyR5.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR5.yyV1^.Blocklist.count := len;
      yyTempo.yyR5.yyV1^.Blocklist.incr := elemSize;
      yyTempo.yyR5.yyV1^.Blocklist.height := h;
      RETURN yyTempo.yyR5.yyV1;

 END BlocklistOfArrayType;

PROCEDURE PtrBlocklistOfType* (t: OB.tOB): OB.tOB;
 BEGIN
  IF OB.IsType (t, OB.TypeRepr) THEN
(* line 110 "BL.pum" *)
(* line 110 "BL.pum" *)
       IF t^.TypeRepr.typeBlocklists^.TypeBlocklists.ptrBlocklist=NIL THEN t^.TypeRepr.typeBlocklists^.TypeBlocklists.ptrBlocklist:=CalcPtrBlocklist(t); END; ;
      RETURN t^.TypeRepr.typeBlocklists^.TypeBlocklists.ptrBlocklist;

  END;
(* line 111 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END PtrBlocklistOfType;

PROCEDURE CalcPtrBlocklist (t: OB.tOB): OB.tOB;
 BEGIN
  IF (t^.Kind = OB.PointerTypeRepr) THEN
(* line 116 "BL.pum" *)
      RETURN OB.cPointerBlocklist;

  END;
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 117 "BL.pum" *)
   LOOP
(* line 117 "BL.pum" *)
      IF ~((t^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN PtrBlocklistOfOpenArrayType (t, 0);
   END;

  IF OB.IsType (t^.ArrayTypeRepr.elemTypeRepr, OB.TypeRepr) THEN
(* line 118 "BL.pum" *)
      RETURN BlocklistOfArrayType (PtrBlocklistOfType (t^.ArrayTypeRepr.elemTypeRepr), t^.ArrayTypeRepr.len, t^.ArrayTypeRepr.elemTypeRepr^.TypeRepr.size);

  END;
  END;
  IF (t^.Kind = OB.RecordTypeRepr) THEN
(* line 119 "BL.pum" *)
      RETURN AdjustIncr (PtrBlocklistOfRecordType (t^.RecordTypeRepr.fields), t^.RecordTypeRepr.size);

  END;
(* line 120 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END CalcPtrBlocklist;

PROCEDURE PtrBlocklistOfOpenArrayType (t: OB.tOB; odim: LONGINT): OB.tOB;
 VAR yyTempo: RECORD
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 yyR3: RECORD
  yyV1: OB.tOB;
  END;
 yyR4: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 125 "BL.pum" *)
   LOOP
(* line 126 "BL.pum" *)
      IF ~((t^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN PtrBlocklistOfOpenArrayType (t^.ArrayTypeRepr.elemTypeRepr, odim + 1);
   END;

  IF OB.IsType (t^.ArrayTypeRepr.elemTypeRepr, OB.TypeRepr) THEN
(* line 128 "BL.pum" *)
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR2.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR2.yyV1^.Blocklist.sub := BlocklistOfArrayType (PtrBlocklistOfType (t^.ArrayTypeRepr.elemTypeRepr), t^.ArrayTypeRepr.len, t^.ArrayTypeRepr.elemTypeRepr^.TypeRepr.size);
      yyTempo.yyR2.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR2.yyV1^.Blocklist.count := -odim;
      yyTempo.yyR2.yyV1^.Blocklist.incr := t^.ArrayTypeRepr.size;
      yyTempo.yyR2.yyV1^.Blocklist.height := 0;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  IF (t^.Kind = OB.RecordTypeRepr) THEN
(* line 136 "BL.pum" *)
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR3.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR3.yyV1^.Blocklist.sub := AdjustIncr (PtrBlocklistOfRecordType (t^.RecordTypeRepr.fields), t^.RecordTypeRepr.size);
      yyTempo.yyR3.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR3.yyV1^.Blocklist.count := -odim;
      yyTempo.yyR3.yyV1^.Blocklist.incr := t^.RecordTypeRepr.size;
      yyTempo.yyR3.yyV1^.Blocklist.height := 0;
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF (t^.Kind = OB.PointerTypeRepr) THEN
(* line 144 "BL.pum" *)
       yyTempo.yyR4.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR4.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR4.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR4.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR4.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR4.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR4.yyV1^.Blocklist.sub := OB.cPointerBlocklist;
      yyTempo.yyR4.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR4.yyV1^.Blocklist.count := -odim;
      yyTempo.yyR4.yyV1^.Blocklist.incr := 4;
      yyTempo.yyR4.yyV1^.Blocklist.height := 0;
      RETURN yyTempo.yyR4.yyV1;

  END;
(* line 152 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END PtrBlocklistOfOpenArrayType;

PROCEDURE PtrBlocklistOfRecordType (fields: OB.tOB): OB.tOB;
 BEGIN
  IF (fields^.Kind = OB.VarEntry) THEN
(* line 157 "BL.pum" *)
      RETURN ConcatBlocklists (PtrBlocklistOfRecordType (fields^.VarEntry.prevEntry), PtrBlocklistOfType (fields^.VarEntry.typeRepr), fields^.VarEntry.address);

  END;
  IF OB.IsType (fields, OB.DataEntry) THEN
(* line 162 "BL.pum" *)
      RETURN PtrBlocklistOfRecordType (fields^.DataEntry.prevEntry);

  END;
(* line 164 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END PtrBlocklistOfRecordType;

PROCEDURE PtrBlocklistOfModuleGlobals* (decls: OB.tOB): OB.tOB;
 BEGIN
  IF (decls^.Kind = OB.VarEntry) THEN
(* line 169 "BL.pum" *)
      RETURN ConcatBlocklists (PtrBlocklistOfModuleGlobals (decls^.VarEntry.prevEntry), AdjustIncr (PtrBlocklistOfType (decls^.VarEntry.typeRepr), Base. Align4 (Base . SizeOfType (decls^.VarEntry.typeRepr))), decls^.VarEntry.address);

  END;
  IF OB.IsType (decls, OB.DataEntry) THEN
(* line 175 "BL.pum" *)
      RETURN PtrBlocklistOfModuleGlobals (decls^.DataEntry.prevEntry);

  END;
(* line 177 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END PtrBlocklistOfModuleGlobals;

PROCEDURE PtrBlocklistOfProcLocals* (decls: OB.tOB): OB.tOB;
 BEGIN
(* line 182 "BL.pum" *)
      RETURN PtrBlOfProcLocals (decls, OB.cNoBlocklist);

 END PtrBlocklistOfProcLocals;

PROCEDURE PtrBlOfProcLocals (decls: OB.tOB; b1: OB.tOB): OB.tOB;
 BEGIN
  IF (decls^.Kind = OB.VarEntry) THEN
(* line 187 "BL.pum" *)
   LOOP
(* line 187 "BL.pum" *)
      IF ~((decls^.VarEntry.address > 0)) THEN EXIT; END;
      RETURN b1;
   END;

(* line 189 "BL.pum" *)
      RETURN PtrBlOfProcLocals (decls^.VarEntry.prevEntry, ConcatBlocklists (b1, PtrBlocklistOfType (decls^.VarEntry.typeRepr), decls^.VarEntry.address));

  END;
  IF OB.IsType (decls, OB.DataEntry) THEN
(* line 196 "BL.pum" *)
      RETURN PtrBlOfProcLocals (decls^.DataEntry.prevEntry, b1);

  END;
(* line 198 "BL.pum" *)
      RETURN b1;

 END PtrBlOfProcLocals;

PROCEDURE PtrBlocklistOfProcDecls* (decls: OB.tOB): OB.tOB;
 BEGIN
(* line 203 "BL.pum" *)
      RETURN PtrBlOfProcDecls (decls, OB.cNoBlocklist);

 END PtrBlocklistOfProcDecls;

PROCEDURE PtrBlOfProcDecls (decls: OB.tOB; b1: OB.tOB): OB.tOB;
 BEGIN
  IF (decls^.Kind = OB.VarEntry) THEN
(* line 208 "BL.pum" *)
   LOOP
(* line 215 "BL.pum" *)
      IF ~((decls^.VarEntry.parMode = OB . VALPAR)) THEN EXIT; END;
      RETURN PtrBlOfProcDecls (decls^.VarEntry.prevEntry, ConcatBlocklists (b1, PtrBlocklistOfType (decls^.VarEntry.typeRepr), decls^.VarEntry.address));
   END;

  END;
  IF OB.IsType (decls, OB.DataEntry) THEN
(* line 217 "BL.pum" *)
      RETURN PtrBlOfProcDecls (decls^.DataEntry.prevEntry, b1);

  END;
(* line 219 "BL.pum" *)
      RETURN b1;

 END PtrBlOfProcDecls;

PROCEDURE ProcBlocklistOfType* (t: OB.tOB): OB.tOB;
 BEGIN
  IF OB.IsType (t, OB.TypeRepr) THEN
(* line 226 "BL.pum" *)
(* line 226 "BL.pum" *)
       IF t^.TypeRepr.typeBlocklists^.TypeBlocklists.procBlocklist=NIL THEN t^.TypeRepr.typeBlocklists^.TypeBlocklists.procBlocklist:=CalcProcBlocklist(t); END; ;
      RETURN t^.TypeRepr.typeBlocklists^.TypeBlocklists.procBlocklist;

  END;
(* line 227 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END ProcBlocklistOfType;

PROCEDURE CalcProcBlocklist (t: OB.tOB): OB.tOB;
 BEGIN
  IF OB.IsType (t, OB.ProcedureTypeRepr) THEN
(* line 232 "BL.pum" *)
      RETURN OB.cProcedureBlocklist;

  END;
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 233 "BL.pum" *)
   LOOP
(* line 233 "BL.pum" *)
      IF ~((t^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN ProcBlocklistOfOpenArrayType (t, 0);
   END;

  IF OB.IsType (t^.ArrayTypeRepr.elemTypeRepr, OB.TypeRepr) THEN
(* line 234 "BL.pum" *)
      RETURN BlocklistOfArrayType (ProcBlocklistOfType (t^.ArrayTypeRepr.elemTypeRepr), t^.ArrayTypeRepr.len, t^.ArrayTypeRepr.elemTypeRepr^.TypeRepr.size);

  END;
  END;
  IF (t^.Kind = OB.RecordTypeRepr) THEN
(* line 235 "BL.pum" *)
      RETURN AdjustIncr (ProcBlocklistOfRecordType (t^.RecordTypeRepr.fields), t^.RecordTypeRepr.size);

  END;
(* line 236 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END CalcProcBlocklist;

PROCEDURE ProcBlocklistOfOpenArrayType (t: OB.tOB; odim: LONGINT): OB.tOB;
 VAR yyTempo: RECORD
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 yyR3: RECORD
  yyV1: OB.tOB;
  END;
 yyR4: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 241 "BL.pum" *)
   LOOP
(* line 242 "BL.pum" *)
      IF ~((t^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN ProcBlocklistOfOpenArrayType (t^.ArrayTypeRepr.elemTypeRepr, odim + 1);
   END;

  IF OB.IsType (t^.ArrayTypeRepr.elemTypeRepr, OB.TypeRepr) THEN
(* line 244 "BL.pum" *)
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR2.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR2.yyV1^.Blocklist.sub := BlocklistOfArrayType (ProcBlocklistOfType (t^.ArrayTypeRepr.elemTypeRepr), t^.ArrayTypeRepr.len, t^.ArrayTypeRepr.elemTypeRepr^.TypeRepr.size);
      yyTempo.yyR2.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR2.yyV1^.Blocklist.count := -odim;
      yyTempo.yyR2.yyV1^.Blocklist.incr := t^.ArrayTypeRepr.size;
      yyTempo.yyR2.yyV1^.Blocklist.height := 0;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  IF (t^.Kind = OB.RecordTypeRepr) THEN
(* line 252 "BL.pum" *)
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR3.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR3.yyV1^.Blocklist.sub := AdjustIncr (ProcBlocklistOfRecordType (t^.RecordTypeRepr.fields), t^.RecordTypeRepr.size);
      yyTempo.yyR3.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR3.yyV1^.Blocklist.count := -odim;
      yyTempo.yyR3.yyV1^.Blocklist.incr := t^.RecordTypeRepr.size;
      yyTempo.yyR3.yyV1^.Blocklist.height := 0;
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF OB.IsType (t, OB.ProcedureTypeRepr) THEN
(* line 260 "BL.pum" *)
       yyTempo.yyR4.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR4.yyV1 ) >= SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR4.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . Blocklist ]);  yyTempo.yyR4.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR4.yyV1 ^.Kind :=  OB . Blocklist ; 
      yyTempo.yyR4.yyV1^.Blocklist.prev := OB.cNoBlocklist;
      yyTempo.yyR4.yyV1^.Blocklist.sub := OB.cProcedureBlocklist;
      yyTempo.yyR4.yyV1^.Blocklist.ofs := 0;
      yyTempo.yyR4.yyV1^.Blocklist.count := -odim;
      yyTempo.yyR4.yyV1^.Blocklist.incr := 4;
      yyTempo.yyR4.yyV1^.Blocklist.height := 0;
      RETURN yyTempo.yyR4.yyV1;

  END;
(* line 268 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END ProcBlocklistOfOpenArrayType;

PROCEDURE ProcBlocklistOfRecordType (fields: OB.tOB): OB.tOB;
 BEGIN
  IF (fields^.Kind = OB.VarEntry) THEN
(* line 273 "BL.pum" *)
      RETURN ConcatBlocklists (ProcBlocklistOfRecordType (fields^.VarEntry.prevEntry), ProcBlocklistOfType (fields^.VarEntry.typeRepr), fields^.VarEntry.address);

  END;
  IF OB.IsType (fields, OB.DataEntry) THEN
(* line 278 "BL.pum" *)
      RETURN ProcBlocklistOfRecordType (fields^.DataEntry.prevEntry);

  END;
(* line 280 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END ProcBlocklistOfRecordType;

PROCEDURE ProcBlocklistOfModuleGlobals* (decls: OB.tOB): OB.tOB;
 BEGIN
  IF (decls^.Kind = OB.VarEntry) THEN
(* line 285 "BL.pum" *)
      RETURN ConcatBlocklists (ProcBlocklistOfModuleGlobals (decls^.VarEntry.prevEntry), AdjustIncr (ProcBlocklistOfType (decls^.VarEntry.typeRepr), Base. Align4 (Base . SizeOfType (decls^.VarEntry.typeRepr))), decls^.VarEntry.address);

  END;
  IF OB.IsType (decls, OB.DataEntry) THEN
(* line 291 "BL.pum" *)
      RETURN ProcBlocklistOfModuleGlobals (decls^.DataEntry.prevEntry);

  END;
(* line 293 "BL.pum" *)
      RETURN OB.cNoBlocklist;

 END ProcBlocklistOfModuleGlobals;

PROCEDURE ProcBlocklistOfProcLocals* (decls: OB.tOB): OB.tOB;
 BEGIN
(* line 298 "BL.pum" *)
      RETURN ProcBlOfProcLocals (decls, OB.cNoBlocklist);

 END ProcBlocklistOfProcLocals;

PROCEDURE ProcBlOfProcLocals (decls: OB.tOB; b1: OB.tOB): OB.tOB;
 BEGIN
  IF (decls^.Kind = OB.VarEntry) THEN
(* line 303 "BL.pum" *)
   LOOP
(* line 303 "BL.pum" *)
      IF ~((decls^.VarEntry.address > 0)) THEN EXIT; END;
      RETURN b1;
   END;

(* line 305 "BL.pum" *)
      RETURN ProcBlOfProcLocals (decls^.VarEntry.prevEntry, ConcatBlocklists (b1, ProcBlocklistOfType (decls^.VarEntry.typeRepr), decls^.VarEntry.address));

  END;
  IF OB.IsType (decls, OB.DataEntry) THEN
(* line 312 "BL.pum" *)
      RETURN ProcBlOfProcLocals (decls^.DataEntry.prevEntry, b1);

  END;
(* line 314 "BL.pum" *)
      RETURN b1;

 END ProcBlOfProcLocals;

PROCEDURE BeginBL*;
 BEGIN
 END BeginBL;

PROCEDURE CloseBL*;
 BEGIN
 END CloseBL;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginBL;
END BL.

