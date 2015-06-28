MODULE T;








IMPORT Base,SYSTEM, System, IO, OB,
(* line 141 "T.pum" *)
               BL          ,
               ERR         ,
               Idents      ,
	       LIM         ,
               LAB         ,
               O           ,
               OT          ,
               POS         ,
	       UTI         ,
               V           ;

        TYPE   tErrorMsg*   = ERR.tErrorMsg;   (* These types are re-declared due to the fact that                               *)
               tIdent*      = Idents.tIdent;   (* qualidents are illegal in a puma specification.                                *)
               tLevel*      = OB.tLevel;      
               tAddress*    = OB.tAddress;
               tSize*       = OB.tSize;
               tLabel*      = OB.tLabel;
               oLONGINT*    = OT.oLONGINT;
               tPosition*   = POS.tPosition; 
(* line 139 "T.pum" *)

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;

PROCEDURE^CountNonOriginBoundProcs* (yyP49: OB.tOB): LONGINT;
PROCEDURE^ProcNumOfBoundProc* (entry: OB.tOB): LONGINT;
PROCEDURE^NewProcNum* (yyP50: OB.tOB): LONGINT;
PROCEDURE^CalcProcNumsOfFields* (fields: OB.tOB; type: OB.tOB);
PROCEDURE^HaveMatchingFormalPars* (Pa: OB.tOB; Pb: OB.tOB): BOOLEAN;
PROCEDURE^BindProcedureToRecord* (type: OB.tOB; entry: OB.tOB; table: OB.tOB; forwardEntry: OB.tOB; currPosition: tPosition; module: OB.tOB): OB.tOB;
PROCEDURE^CalcProcNumsOfType* (type: OB.tOB);

        PROCEDURE MinimalIntegerType*(val : OT.oLONGINT) : OB.tOB;
        BEGIN (* MinimalIntegerType *)
         IF    (OT.MINoSHORTINT <= val) & (val <= OT.MAXoSHORTINT)
            THEN RETURN OB.cShortintTypeRepr;
         ELSIF (OT.MINoINTEGER  <= val) & (val <= OT.MAXoINTEGER )
            THEN RETURN OB.cIntegerTypeRepr;
            ELSE RETURN OB.cLongintTypeRepr;
         END; (* IF *)
        END MinimalIntegerType; 




























































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module T, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi	:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE EntryOfType* (typeRepr: OB.tOB): OB.tOB;
 BEGIN
  IF OB.IsType (typeRepr, OB.TypeRepr) THEN
(* line 167 "T.pum" *)
      RETURN typeRepr^.TypeRepr.entry;

  END;
(* line 168 "T.pum" *)
      RETURN OB.cErrorEntry;

 END EntryOfType;

PROCEDURE SizeOfType* (yyP1: OB.tOB): tSize;
 BEGIN
  IF OB.IsType (yyP1, OB.TypeRepr) THEN
(* line 172 "T.pum" *)
      RETURN yyP1^.TypeRepr.size;

  END;
(* line 173 "T.pum" *)
      RETURN 0;

 END SizeOfType;

PROCEDURE LenOfArrayType* (yyP2: OB.tOB): oLONGINT;
 BEGIN
  IF (yyP2^.Kind = OB.ArrayTypeRepr) THEN
(* line 177 "T.pum" *)
      RETURN yyP2^.ArrayTypeRepr.len;

  END;
(* line 178 "T.pum" *)
      RETURN 0;

 END LenOfArrayType;

PROCEDURE DimOfArrayType* (yyP3: OB.tOB): oLONGINT;
 BEGIN
  IF (yyP3^.Kind = OB.ArrayTypeRepr) THEN
(* line 182 "T.pum" *)
      RETURN 1 + DimOfArrayType (yyP3^.ArrayTypeRepr.elemTypeRepr);

  END;
(* line 183 "T.pum" *)
      RETURN 0;

 END DimOfArrayType;

PROCEDURE OpenDimOfArrayType* (yyP4: OB.tOB): oLONGINT;
 BEGIN
  IF (yyP4^.Kind = OB.ArrayTypeRepr) THEN
(* line 187 "T.pum" *)
   LOOP
(* line 187 "T.pum" *)
      IF ~((yyP4^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN 1 + OpenDimOfArrayType (yyP4^.ArrayTypeRepr.elemTypeRepr);
   END;

  END;
(* line 188 "T.pum" *)
      RETURN 0;

 END OpenDimOfArrayType;

PROCEDURE ElemSizeOfOpenArrayType* (t: OB.tOB): tSize;
 BEGIN
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 192 "T.pum" *)
   LOOP
(* line 192 "T.pum" *)
      IF ~((t^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
      RETURN ElemSizeOfOpenArrayType (t^.ArrayTypeRepr.elemTypeRepr);
   END;

  END;
(* line 193 "T.pum" *)
      RETURN SizeOfType (t);

 END ElemSizeOfOpenArrayType;

PROCEDURE OpenDimAndElemSizeOfArrayType* (t: OB.tOB; VAR yyP6: LONGINT; VAR yyP5: LONGINT): BOOLEAN;
(* line 197 "T.pum" *)
 VAR f:BOOLEAN; odim,esize:LONGINT; 
 BEGIN
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 199 "T.pum" *)
   LOOP
(* line 200 "T.pum" *)
      IF ~((t^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 201 "T.pum" *)
      f:=OpenDimAndElemSizeOfArrayType(t^.ArrayTypeRepr.elemTypeRepr,odim,esize);;
      yyP6 := odim+1;
      yyP5 := esize;
      RETURN TRUE;
   END;

  END;
  IF OB.IsType (t, OB.TypeRepr) THEN
(* line 202 "T.pum" *)
      yyP6 := 0;
      yyP5 := t^.TypeRepr.size;
      RETURN FALSE;

  END;
  yyAbort ('OpenDimAndElemSizeOfArrayType');
 END OpenDimAndElemSizeOfArrayType;

PROCEDURE ExtLevelOfType* (yyP7: OB.tOB): tLevel;
 BEGIN
  IF (yyP7^.Kind = OB.RecordTypeRepr) THEN
(* line 207 "T.pum" *)
      RETURN yyP7^.RecordTypeRepr.extLevel;

  END;
(* line 208 "T.pum" *)
      RETURN 0;

 END ExtLevelOfType;

PROCEDURE ReceiverRecordTypeOfType* (yyP8: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP8^.Kind = OB.RecordTypeRepr) THEN
(* line 212 "T.pum" *)
      RETURN yyP8;

  END;
  IF (yyP8^.Kind = OB.PointerTypeRepr) THEN
  IF (yyP8^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (yyP8^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 214 "T.pum" *)
      RETURN yyP8^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr;

  END;
  END;
  END;
(* line 230 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END ReceiverRecordTypeOfType;

PROCEDURE BaseTypeOfPointerType* (yyP9: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP9^.Kind = OB.PointerTypeRepr) THEN
  IF (yyP9^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 235 "T.pum" *)
      RETURN yyP9^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr;

  END;
  END;
(* line 251 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END BaseTypeOfPointerType;

PROCEDURE ElemTypeOfArrayType* (t: OB.tOB): OB.tOB;
 BEGIN
  IF (t^.Kind = OB.ArrayTypeRepr) THEN
(* line 256 "T.pum" *)
      RETURN ElemTypeOfArrayType (t^.ArrayTypeRepr.elemTypeRepr);

  END;
(* line 265 "T.pum" *)
      RETURN t;

 END ElemTypeOfArrayType;

PROCEDURE RecordBaseTypeOfType* (yyP10: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP10^.Kind = OB.RecordTypeRepr) THEN
(* line 270 "T.pum" *)
      RETURN yyP10^.RecordTypeRepr.baseTypeRepr;

  END;
  IF (yyP10^.Kind = OB.PointerTypeRepr) THEN
  IF (yyP10^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 280 "T.pum" *)
      RETURN RecordBaseTypeOfType (yyP10^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr);

  END;
  END;
(* line 296 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END RecordBaseTypeOfType;

PROCEDURE FieldsOfRecordType* (yyP11: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP11^.Kind = OB.RecordTypeRepr) THEN
(* line 301 "T.pum" *)
      RETURN yyP11^.RecordTypeRepr.fields;

  END;
(* line 313 "T.pum" *)
      RETURN OB.cmtEntry;

 END FieldsOfRecordType;

PROCEDURE EmptyTypeToErrorType* (typeRepr: OB.tOB): OB.tOB;
 BEGIN
  IF (typeRepr^.Kind = OB.mtTypeRepr) THEN
(* line 317 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

  END;
(* line 318 "T.pum" *)
      RETURN typeRepr;

 END EmptyTypeToErrorType;

PROCEDURE NumberOfBoundProcsOfType* (yyP12: OB.tOB): LONGINT;
 BEGIN
  IF (yyP12^.Kind = OB.RecordTypeRepr) THEN
(* line 323 "T.pum" *)
      RETURN yyP12^.RecordTypeRepr.nofBoundProcs;

  END;
(* line 335 "T.pum" *)
      RETURN 0;

 END NumberOfBoundProcsOfType;

PROCEDURE CopyArrayTypeRepr* (typeFragment: OB.tOB; typeConstructed: OB.tOB): OB.tOB;
 BEGIN
  IF (typeFragment^.Kind = OB.ArrayTypeRepr) THEN
  IF (typeConstructed^.Kind = OB.ArrayTypeRepr) THEN
(* line 340 "T.pum" *)
(* line 356 "T.pum" *)
       typeFragment^.ArrayTypeRepr.size         := typeConstructed^.ArrayTypeRepr.size         ;
                                                  typeFragment^.ArrayTypeRepr.len          := typeConstructed^.ArrayTypeRepr.len          ;
                                                  typeFragment^.ArrayTypeRepr.elemTypeRepr := typeConstructed^.ArrayTypeRepr.elemTypeRepr ;
                                                ;
      RETURN typeFragment;

  END;
  END;
(* line 361 "T.pum" *)
      RETURN typeConstructed;

 END CopyArrayTypeRepr;

PROCEDURE CompleteOpenArrayTypeRepr* (type: OB.tOB; elemTypeRepr: OB.tOB): OB.tOB;
 BEGIN
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
(* line 366 "T.pum" *)
(* line 374 "T.pum" *)
       type^.ArrayTypeRepr.elemTypeRepr:=elemTypeRepr; ;
      RETURN type;

  END;
(* line 376 "T.pum" *)
      RETURN type;

 END CompleteOpenArrayTypeRepr;

PROCEDURE CompleteRecordTypeRepr* (type: OB.tOB; size: tSize; extLevel: tLevel; baseTypeRepr: OB.tOB; extTypeReprList: OB.tOB; fields: OB.tOB): OB.tOB;
 BEGIN
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 385 "T.pum" *)
(* line 396 "T.pum" *)
       type^.RecordTypeRepr.size := size;
                                          type^.RecordTypeRepr.extLevel := extLevel;
                                          type^.RecordTypeRepr.baseTypeRepr := baseTypeRepr;
                                          type^.RecordTypeRepr.extTypeReprList := extTypeReprList;
                                          type^.RecordTypeRepr.fields  := fields;
                                          type^.RecordTypeRepr.nofBoundProcs  := 0;
                                        ;
      RETURN type;

  END;
(* line 404 "T.pum" *)
      RETURN type;

 END CompleteRecordTypeRepr;

PROCEDURE CompletePointerTypeRepr* (type: OB.tOB; baseTypeEntry: OB.tOB): OB.tOB;
 BEGIN
  IF (type^.Kind = OB.PointerTypeRepr) THEN
(* line 409 "T.pum" *)
(* line 416 "T.pum" *)
       type^.PointerTypeRepr.baseTypeEntry := baseTypeEntry ;
      RETURN type;

  END;
(* line 418 "T.pum" *)
      RETURN type;

 END CompletePointerTypeRepr;

PROCEDURE CompleteProcedureTypeRepr* (type: OB.tOB; signatureRepr: OB.tOB; resultType: OB.tOB; paramSpace: tSize): OB.tOB;
 BEGIN
  IF OB.IsType (type, OB.ProcedureTypeRepr) THEN
(* line 425 "T.pum" *)
(* line 434 "T.pum" *)
       type^.ProcedureTypeRepr.signatureRepr := signatureRepr ;
                                          type^.ProcedureTypeRepr.resultType := resultType    ;
                                          type^.ProcedureTypeRepr.paramSpace := paramSpace    ; 
                                        ;
      RETURN type;

  END;
(* line 439 "T.pum" *)
      RETURN type;

 END CompleteProcedureTypeRepr;

PROCEDURE IsGenuineEmptyType* (yyP13: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP13 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP13^.Kind = OB.mtTypeRepr) THEN
(* line 443 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsGenuineEmptyType;

PROCEDURE IsEmptyType* (yyP14: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP14 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP14^.Kind = OB.ErrorTypeRepr) THEN
(* line 447 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP14^.Kind = OB.mtTypeRepr) THEN
(* line 448 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsEmptyType;

PROCEDURE IsErrorType* (yyP15: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP15 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP15^.Kind = OB.ErrorTypeRepr) THEN
(* line 452 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsErrorType;

PROCEDURE IsBooleanType* (yyP16: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP16 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP16^.Kind = OB.ErrorTypeRepr) THEN
(* line 456 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP16^.Kind = OB.BooleanTypeRepr) THEN
(* line 457 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsBooleanType;

PROCEDURE IsCharType* (yyP17: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP17 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP17^.Kind = OB.ErrorTypeRepr) THEN
(* line 461 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP17^.Kind = OB.CharStringTypeRepr) THEN
(* line 462 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP17^.Kind = OB.CharTypeRepr) THEN
(* line 463 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsCharType;

PROCEDURE IsSetType* (yyP18: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP18 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP18^.Kind = OB.ErrorTypeRepr) THEN
(* line 467 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP18^.Kind = OB.SetTypeRepr) THEN
(* line 468 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsSetType;

PROCEDURE IsShortintType* (yyP19: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP19 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP19^.Kind = OB.ErrorTypeRepr) THEN
(* line 472 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP19^.Kind = OB.ShortintTypeRepr) THEN
(* line 473 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsShortintType;

PROCEDURE IsLongintType* (yyP20: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP20 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP20^.Kind = OB.ErrorTypeRepr) THEN
(* line 477 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP20^.Kind = OB.LongintTypeRepr) THEN
(* line 478 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsLongintType;

PROCEDURE IsArrayType* (yyP21: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP21 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP21^.Kind = OB.ErrorTypeRepr) THEN
(* line 482 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP21^.Kind = OB.ArrayTypeRepr) THEN
(* line 483 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsArrayType;

PROCEDURE IsCharArrayType* (yyP22: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP22 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP22^.Kind = OB.ErrorTypeRepr) THEN
(* line 487 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP22^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyP22^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
(* line 488 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsCharArrayType;

PROCEDURE IsStringOrCharArrayType* (yyP23: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP23 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP23^.Kind = OB.ErrorTypeRepr) THEN
(* line 492 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP23^.Kind = OB.CharStringTypeRepr) THEN
(* line 493 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP23^.Kind = OB.StringTypeRepr) THEN
(* line 494 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP23^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyP23^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
(* line 495 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsStringOrCharArrayType;

PROCEDURE IsRecordType* (yyP24: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP24 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP24^.Kind = OB.ErrorTypeRepr) THEN
(* line 499 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP24^.Kind = OB.RecordTypeRepr) THEN
(* line 500 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsRecordType;

PROCEDURE IsPointerType* (yyP25: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP25 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP25^.Kind = OB.ErrorTypeRepr) THEN
(* line 504 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP25^.Kind = OB.PointerTypeRepr) THEN
(* line 505 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsPointerType;

PROCEDURE IsPointerOrArrayOfPointerType* (yyP26: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP26 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP26^.Kind = OB.ErrorTypeRepr) THEN
(* line 509 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP26^.Kind = OB.PointerTypeRepr) THEN
(* line 510 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP26^.Kind = OB.ArrayTypeRepr) THEN
(* line 511 "T.pum" *)
   LOOP
(* line 511 "T.pum" *)
      IF ~(IsPointerOrArrayOfPointerType (yyP26^.ArrayTypeRepr.elemTypeRepr)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END IsPointerOrArrayOfPointerType;

PROCEDURE IsPointerToRecordType* (yyP27: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP27 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP27^.Kind = OB.ErrorTypeRepr) THEN
(* line 515 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP27^.Kind = OB.PointerTypeRepr) THEN
  IF (yyP27^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (yyP27^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 516 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  RETURN FALSE;
 END IsPointerToRecordType;

PROCEDURE IsProcedureType* (yyP28: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP28 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP28^.Kind = OB.ErrorTypeRepr) THEN
(* line 520 "T.pum" *)
      RETURN TRUE;

  END;
  IF OB.IsType (yyP28, OB.ProcedureTypeRepr) THEN
(* line 521 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsProcedureType;

PROCEDURE IsOpenArrayType* (yyP29: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP29 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP29^.Kind = OB.ErrorTypeRepr) THEN
(* line 525 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP29^.Kind = OB.ArrayTypeRepr) THEN
(* line 526 "T.pum" *)
(* line 526 "T.pum" *)
      RETURN (yyP29^.ArrayTypeRepr.len=OB.OPENARRAYLEN);;
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsOpenArrayType;

PROCEDURE IsNotOpenArrayType* (yyP30: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP30 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP30^.Kind = OB.ArrayTypeRepr) THEN
(* line 530 "T.pum" *)
(* line 530 "T.pum" *)
      RETURN (yyP30^.ArrayTypeRepr.len#OB.OPENARRAYLEN);;
      RETURN TRUE;

  END;
(* line 531 "T.pum" *)
      RETURN TRUE;

 END IsNotOpenArrayType;

PROCEDURE HasPointerSubType* (t: OB.tOB): BOOLEAN;
 BEGIN
  IF t = OB.NoOB THEN RETURN FALSE; END;
(* line 535 "T.pum" *)
   LOOP
(* line 535 "T.pum" *)
      IF ~((~OB.IsEmptyBlocklist(OB.PtrBlocklistOfType(t)))) THEN EXIT; END;
      RETURN TRUE;
   END;

  RETURN FALSE;
 END HasPointerSubType;

PROCEDURE IsIntegerType* (yyP31: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP31 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP31^.Kind = OB.ErrorTypeRepr) THEN
(* line 539 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP31^.Kind = OB.ShortintTypeRepr) THEN
(* line 540 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP31^.Kind = OB.IntegerTypeRepr) THEN
(* line 541 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP31^.Kind = OB.LongintTypeRepr) THEN
(* line 542 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsIntegerType;

PROCEDURE IsRealType* (yyP32: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP32 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP32^.Kind = OB.ErrorTypeRepr) THEN
(* line 546 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP32^.Kind = OB.RealTypeRepr) THEN
(* line 547 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP32^.Kind = OB.LongrealTypeRepr) THEN
(* line 548 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsRealType;

PROCEDURE IsNumericType* (t: OB.tOB): BOOLEAN;
 BEGIN
  IF t = OB.NoOB THEN RETURN FALSE; END;
(* line 552 "T.pum" *)
   LOOP
(* line 552 "T.pum" *)
      IF ~(IsIntegerType (t)) THEN EXIT; END;
      RETURN TRUE;
   END;

(* line 553 "T.pum" *)
   LOOP
(* line 553 "T.pum" *)
      IF ~(IsRealType (t)) THEN EXIT; END;
      RETURN TRUE;
   END;

  RETURN FALSE;
 END IsNumericType;

PROCEDURE IsShortType* (yyP33: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP33 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP33^.Kind = OB.ErrorTypeRepr) THEN
(* line 557 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP33^.Kind = OB.ShortintTypeRepr) THEN
(* line 558 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP33^.Kind = OB.IntegerTypeRepr) THEN
(* line 559 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP33^.Kind = OB.RealTypeRepr) THEN
(* line 560 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsShortType;

PROCEDURE IsLongType* (yyP34: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP34 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP34^.Kind = OB.ErrorTypeRepr) THEN
(* line 564 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP34^.Kind = OB.IntegerTypeRepr) THEN
(* line 565 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP34^.Kind = OB.LongintTypeRepr) THEN
(* line 566 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP34^.Kind = OB.LongrealTypeRepr) THEN
(* line 567 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsLongType;

PROCEDURE IsBasicType* (yyP35: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP35 = OB.NoOB THEN RETURN FALSE; END;

  CASE yyP35^.Kind OF
  | OB.ErrorTypeRepr:
(* line 571 "T.pum" *)
      RETURN TRUE;

  | OB.BooleanTypeRepr:
(* line 572 "T.pum" *)
      RETURN TRUE;

  | OB.CharTypeRepr:
(* line 573 "T.pum" *)
      RETURN TRUE;

  | OB.CharStringTypeRepr:
(* line 574 "T.pum" *)
      RETURN TRUE;

  | OB.ShortintTypeRepr:
(* line 575 "T.pum" *)
      RETURN TRUE;

  | OB.IntegerTypeRepr:
(* line 576 "T.pum" *)
      RETURN TRUE;

  | OB.LongintTypeRepr:
(* line 577 "T.pum" *)
      RETURN TRUE;

  | OB.RealTypeRepr:
(* line 578 "T.pum" *)
      RETURN TRUE;

  | OB.LongrealTypeRepr:
(* line 579 "T.pum" *)
      RETURN TRUE;

  | OB.SetTypeRepr:
(* line 580 "T.pum" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsBasicType;

PROCEDURE IsShiftableType* (t: OB.tOB): BOOLEAN;
 BEGIN
  IF t = OB.NoOB THEN RETURN FALSE; END;
  IF (t^.Kind = OB.ErrorTypeRepr) THEN
(* line 584 "T.pum" *)
      RETURN TRUE;

  END;
(* line 585 "T.pum" *)
   LOOP
(* line 585 "T.pum" *)
      IF ~(IsIntegerType (t)) THEN EXIT; END;
      RETURN TRUE;
   END;

  IF (t^.Kind = OB.CharTypeRepr) THEN
(* line 586 "T.pum" *)
      RETURN TRUE;

  END;
  IF (t^.Kind = OB.ByteTypeRepr) THEN
(* line 587 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsShiftableType;

PROCEDURE IsRegisterableType* (t: OB.tOB): BOOLEAN;
 BEGIN
  IF t = OB.NoOB THEN RETURN FALSE; END;
  IF (t^.Kind = OB.ErrorTypeRepr) THEN
(* line 591 "T.pum" *)
      RETURN TRUE;

  END;
(* line 592 "T.pum" *)
   LOOP
(* line 592 "T.pum" *)
      IF ~(IsBasicType (t)) THEN EXIT; END;
      RETURN TRUE;
   END;

  IF (t^.Kind = OB.PointerTypeRepr) THEN
(* line 593 "T.pum" *)
      RETURN TRUE;

  END;
  IF OB.IsType (t, OB.ProcedureTypeRepr) THEN
(* line 594 "T.pum" *)
      RETURN TRUE;

  END;
  IF (t^.Kind = OB.ByteTypeRepr) THEN
(* line 595 "T.pum" *)
      RETURN TRUE;

  END;
  IF (t^.Kind = OB.PtrTypeRepr) THEN
(* line 596 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsRegisterableType;

PROCEDURE IsLegalPointerBaseType* (yyP36: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP36 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP36^.Kind = OB.ErrorTypeRepr) THEN
(* line 600 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP36^.Kind = OB.ForwardTypeRepr) THEN
(* line 601 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP36^.Kind = OB.ArrayTypeRepr) THEN
(* line 602 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP36^.Kind = OB.RecordTypeRepr) THEN
(* line 603 "T.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsLegalPointerBaseType;

PROCEDURE AreSameTypes* (Ta: OB.tOB; Tb: OB.tOB): BOOLEAN;
 BEGIN
  IF Ta = OB.NoOB THEN RETURN FALSE; END;
  IF Tb = OB.NoOB THEN RETURN FALSE; END;
  IF (Ta^.Kind = OB.ErrorTypeRepr) THEN
(* line 608 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Tb^.Kind = OB.ErrorTypeRepr) THEN
(* line 611 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Ta^.Kind = OB.CharStringTypeRepr) THEN
  IF (Tb^.Kind = OB.CharTypeRepr) THEN
(* line 614 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (Ta^.Kind = OB.CharTypeRepr) THEN
  IF (Tb^.Kind = OB.CharStringTypeRepr) THEN
(* line 617 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (Ta^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Ta^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
(* line 620 "T.pum" *)
(* line 621 "T.pum" *)
      RETURN FALSE;

  END;
  END;
  IF (Tb^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Tb^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
(* line 623 "T.pum" *)
(* line 624 "T.pum" *)
      RETURN FALSE;

  END;
  END;
(* line 626 "T.pum" *)
   LOOP
(* line 626 "T.pum" *)
      IF ~((Ta = Tb)) THEN EXIT; END;
      RETURN TRUE;
   END;

  RETURN FALSE;
 END AreSameTypes;

PROCEDURE AreEqualTypes* (Ta: OB.tOB; Tb: OB.tOB): BOOLEAN;
 BEGIN
  IF Ta = OB.NoOB THEN RETURN FALSE; END;
  IF Tb = OB.NoOB THEN RETURN FALSE; END;
(* line 631 "T.pum" *)
   LOOP
(* line 631 "T.pum" *)
      IF ~(AreSameTypes (Ta, Tb)) THEN EXIT; END;
      RETURN TRUE;
   END;

  IF (Ta^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Ta^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
  IF (Tb^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Tb^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
(* line 633 "T.pum" *)
   LOOP
(* line 634 "T.pum" *)
      IF ~(AreEqualTypes (Ta^.ArrayTypeRepr.elemTypeRepr, Tb^.ArrayTypeRepr.elemTypeRepr)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  END;
  END;
  END;
  IF OB.IsType (Ta, OB.ProcedureTypeRepr) THEN
  IF OB.IsType (Tb, OB.ProcedureTypeRepr) THEN
(* line 636 "T.pum" *)
   LOOP
(* line 637 "T.pum" *)
      IF ~(HaveMatchingFormalPars (Ta, Tb)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  END;
  RETURN FALSE;
 END AreEqualTypes;

PROCEDURE IsIncludedBy* (yyP38: OB.tOB; yyP37: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP38 = OB.NoOB THEN RETURN FALSE; END;
  IF yyP37 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP38^.Kind = OB.ErrorTypeRepr) THEN
(* line 641 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.ErrorTypeRepr) THEN
(* line 642 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP38^.Kind = OB.ShortintTypeRepr) THEN
  IF (yyP37^.Kind = OB.ShortintTypeRepr) THEN
(* line 644 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.IntegerTypeRepr) THEN
(* line 645 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.LongintTypeRepr) THEN
(* line 646 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.RealTypeRepr) THEN
(* line 647 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.LongrealTypeRepr) THEN
(* line 648 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (yyP38^.Kind = OB.IntegerTypeRepr) THEN
  IF (yyP37^.Kind = OB.IntegerTypeRepr) THEN
(* line 650 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.LongintTypeRepr) THEN
(* line 651 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.RealTypeRepr) THEN
(* line 652 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.LongrealTypeRepr) THEN
(* line 653 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (yyP38^.Kind = OB.LongintTypeRepr) THEN
  IF (yyP37^.Kind = OB.LongintTypeRepr) THEN
(* line 655 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.RealTypeRepr) THEN
(* line 656 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.LongrealTypeRepr) THEN
(* line 657 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (yyP38^.Kind = OB.RealTypeRepr) THEN
  IF (yyP37^.Kind = OB.RealTypeRepr) THEN
(* line 659 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP37^.Kind = OB.LongrealTypeRepr) THEN
(* line 660 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (yyP38^.Kind = OB.LongrealTypeRepr) THEN
  IF (yyP37^.Kind = OB.LongrealTypeRepr) THEN
(* line 662 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsIncludedBy;

PROCEDURE IsExtensionOf* (Tb: OB.tOB; Ta: OB.tOB): BOOLEAN;
 BEGIN
  IF Tb = OB.NoOB THEN RETURN FALSE; END;
  IF Ta = OB.NoOB THEN RETURN FALSE; END;
  IF (Tb^.Kind = OB.ErrorTypeRepr) THEN
(* line 667 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Ta^.Kind = OB.ErrorTypeRepr) THEN
(* line 670 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Tb^.Kind = OB.RecordTypeRepr) THEN
  IF (Ta^.Kind = OB.RecordTypeRepr) THEN
(* line 673 "T.pum" *)
   LOOP
(* line 674 "T.pum" *)
      IF ~(AreSameTypes (Ta, Tb)) THEN EXIT; END;
      RETURN TRUE;
   END;

(* line 676 "T.pum" *)
   LOOP
(* line 678 "T.pum" *)
      IF ~((Tb^.RecordTypeRepr.baseTypeRepr # Tb) & IsExtensionOf (Tb^.RecordTypeRepr.baseTypeRepr, Ta)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  END;
  IF (Tb^.Kind = OB.PointerTypeRepr) THEN
  IF (Tb^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (Ta^.Kind = OB.PointerTypeRepr) THEN
  IF (Ta^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 680 "T.pum" *)
   LOOP
(* line 681 "T.pum" *)
      IF ~(IsExtensionOf (Tb^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr, Ta^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  END;
  END;
  END;
  RETURN FALSE;
 END IsExtensionOf;

PROCEDURE IsAssignmentCompatible* (Tv: OB.tOB; Te: OB.tOB; Ve: OB.tOB): BOOLEAN;
 BEGIN
  IF Tv = OB.NoOB THEN RETURN FALSE; END;
  IF Te = OB.NoOB THEN RETURN FALSE; END;
  IF Ve = OB.NoOB THEN RETURN FALSE; END;
(* line 686 "T.pum" *)
   LOOP
(* line 686 "T.pum" *)
      IF ~(AreSameTypes (Te, Tv)) THEN EXIT; END;
      RETURN TRUE;
   END;

(* line 687 "T.pum" *)
   LOOP
(* line 687 "T.pum" *)
      IF ~(IsIncludedBy (Te, Tv)) THEN EXIT; END;
      RETURN TRUE;
   END;

(* line 688 "T.pum" *)
   LOOP
(* line 688 "T.pum" *)
      IF ~(IsExtensionOf (Te, Tv)) THEN EXIT; END;
      RETURN TRUE;
   END;

  IF (Tv^.Kind = OB.PointerTypeRepr) THEN
  IF (Te^.Kind = OB.NilTypeRepr) THEN
(* line 690 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF OB.IsType (Tv, OB.ProcedureTypeRepr) THEN
  IF (Te^.Kind = OB.NilTypeRepr) THEN
(* line 694 "T.pum" *)
      RETURN TRUE;

  END;
  IF OB.IsType (Te, OB.ProcedureTypeRepr) THEN
  IF (Te^.ProcedureTypeRepr.entry^.Kind = OB.ProcedureEntry) THEN
(* line 706 "T.pum" *)
(* line 716 "T.pum" *)
       RETURN (Te^.ProcedureTypeRepr.entry^.ProcedureEntry.level = OB.MODULELEVEL)
                                                             & HaveMatchingFormalPars(Tv,Te); ;
      RETURN TRUE;

  END;
  END;
  END;
  IF (Tv^.Kind = OB.ArrayTypeRepr) THEN
  IF (Tv^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
  IF (Te^.Kind = OB.CharStringTypeRepr) THEN
(* line 698 "T.pum" *)
(* line 700 "T.pum" *)
       RETURN ((1<Tv^.ArrayTypeRepr.len) OR ((Tv^.ArrayTypeRepr.len=1) & OB.IsNullChar(Ve))); ;
      RETURN TRUE;

  END;
  IF (Te^.Kind = OB.StringTypeRepr) THEN
(* line 702 "T.pum" *)
(* line 704 "T.pum" *)
       RETURN (OB.LengthOfString(Ve) < Tv^.ArrayTypeRepr.len); ;
      RETURN TRUE;

  END;
  END;
  END;
  IF (Tv^.Kind = OB.ByteTypeRepr) THEN
  IF (Te^.Kind = OB.CharTypeRepr) THEN
(* line 719 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Te^.Kind = OB.CharStringTypeRepr) THEN
(* line 723 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Te^.Kind = OB.ShortintTypeRepr) THEN
(* line 727 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (Tv^.Kind = OB.PtrTypeRepr) THEN
  IF (Te^.Kind = OB.PointerTypeRepr) THEN
(* line 731 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsAssignmentCompatible;

PROCEDURE IsArrayCompatible* (Tf: OB.tOB; Ta: OB.tOB): BOOLEAN;
 BEGIN
  IF Tf = OB.NoOB THEN RETURN FALSE; END;
  IF Ta = OB.NoOB THEN RETURN FALSE; END;
  IF (Tf^.Kind = OB.ErrorTypeRepr) THEN
(* line 738 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Ta^.Kind = OB.ErrorTypeRepr) THEN
(* line 741 "T.pum" *)
      RETURN TRUE;

  END;
(* line 744 "T.pum" *)
   LOOP
(* line 744 "T.pum" *)
      IF ~(AreSameTypes (Tf, Ta)) THEN EXIT; END;
      RETURN TRUE;
   END;

  IF (Tf^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Tf^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
  IF (Ta^.Kind = OB.ArrayTypeRepr) THEN
(* line 746 "T.pum" *)
   LOOP
(* line 747 "T.pum" *)
      IF ~(IsArrayCompatible (Tf^.ArrayTypeRepr.elemTypeRepr, Ta^.ArrayTypeRepr.elemTypeRepr)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  END;
  IF (yyIsEqual ( Tf^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
  IF (Ta^.Kind = OB.CharStringTypeRepr) THEN
(* line 749 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (yyIsEqual ( Tf^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
  IF (Ta^.Kind = OB.StringTypeRepr) THEN
(* line 752 "T.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  RETURN FALSE;
 END IsArrayCompatible;

PROCEDURE HaveMatchingFormalPars* (Pa: OB.tOB; Pb: OB.tOB): BOOLEAN;
 BEGIN
  IF Pa = OB.NoOB THEN RETURN FALSE; END;
  IF Pb = OB.NoOB THEN RETURN FALSE; END;
  IF (Pa^.Kind = OB.ErrorTypeRepr) THEN
(* line 758 "T.pum" *)
      RETURN TRUE;

  END;
  IF (Pb^.Kind = OB.ErrorTypeRepr) THEN
(* line 761 "T.pum" *)
      RETURN TRUE;

  END;
  IF OB.IsType (Pa, OB.ProcedureTypeRepr) THEN
  IF (Pa^.ProcedureTypeRepr.resultType^.Kind = OB.mtTypeRepr) THEN
  IF OB.IsType (Pb, OB.ProcedureTypeRepr) THEN
  IF (Pb^.ProcedureTypeRepr.resultType^.Kind = OB.mtTypeRepr) THEN
(* line 764 "T.pum" *)
(* line 781 "T.pum" *)
      RETURN Base.AreMatchingSignatures(Pa^.ProcedureTypeRepr.signatureRepr,Pb^.ProcedureTypeRepr.signatureRepr);
      RETURN TRUE;

  END;
  END;
  END;
  IF OB.IsType (Pb, OB.ProcedureTypeRepr) THEN
(* line 783 "T.pum" *)
(* line 800 "T.pum" *)
      RETURN Base.AreMatchingSignatures(Pa^.ProcedureTypeRepr.signatureRepr,Pb^.ProcedureTypeRepr.signatureRepr)
                                                                       & AreSameTypes(Pa^.ProcedureTypeRepr.resultType,Pb^.ProcedureTypeRepr.resultType)
                                                                 ;
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END HaveMatchingFormalPars;

PROCEDURE SmallestIntegerTypeInclBoth* (yyP40: OB.tOB; yyP39: OB.tOB): OB.tOB;
 BEGIN
  IF yyP40 = NIL THEN
(* line 806 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

  END;
  IF yyP39 = NIL THEN
(* line 807 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

  END;
  IF (yyP40^.Kind = OB.ShortintTypeRepr) THEN
  IF (yyP39^.Kind = OB.ShortintTypeRepr) THEN
(* line 809 "T.pum" *)
      RETURN OB.cShortintTypeRepr;

  END;
  IF (yyP39^.Kind = OB.IntegerTypeRepr) THEN
(* line 813 "T.pum" *)
      RETURN OB.cIntegerTypeRepr ;

  END;
  IF (yyP39^.Kind = OB.LongintTypeRepr) THEN
(* line 817 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  END;
  IF (yyP40^.Kind = OB.IntegerTypeRepr) THEN
  IF (yyP39^.Kind = OB.ShortintTypeRepr) THEN
(* line 810 "T.pum" *)
      RETURN OB.cIntegerTypeRepr ;

  END;
  IF (yyP39^.Kind = OB.IntegerTypeRepr) THEN
(* line 814 "T.pum" *)
      RETURN OB.cIntegerTypeRepr ;

  END;
  IF (yyP39^.Kind = OB.LongintTypeRepr) THEN
(* line 818 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  END;
  IF (yyP40^.Kind = OB.LongintTypeRepr) THEN
  IF (yyP39^.Kind = OB.ShortintTypeRepr) THEN
(* line 811 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP39^.Kind = OB.IntegerTypeRepr) THEN
(* line 815 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP39^.Kind = OB.LongintTypeRepr) THEN
(* line 819 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  END;
(* line 821 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

 END SmallestIntegerTypeInclBoth;

PROCEDURE SetOrSmallestNumTypeInclBoth* (yyP42: OB.tOB; yyP41: OB.tOB): OB.tOB;
 BEGIN
  IF yyP42 = NIL THEN
(* line 825 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

  END;
  IF yyP41 = NIL THEN
(* line 826 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

  END;
  IF (yyP42^.Kind = OB.SetTypeRepr) THEN
  IF (yyP41^.Kind = OB.SetTypeRepr) THEN
(* line 828 "T.pum" *)
      RETURN OB.cSetTypeRepr     ;

  END;
  END;
  IF (yyP42^.Kind = OB.ShortintTypeRepr) THEN
  IF (yyP41^.Kind = OB.ShortintTypeRepr) THEN
(* line 830 "T.pum" *)
      RETURN OB.cShortintTypeRepr;

  END;
  IF (yyP41^.Kind = OB.IntegerTypeRepr) THEN
(* line 836 "T.pum" *)
      RETURN OB.cIntegerTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.LongintTypeRepr) THEN
(* line 842 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.RealTypeRepr) THEN
(* line 848 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.LongrealTypeRepr) THEN
(* line 854 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  END;
  IF (yyP42^.Kind = OB.IntegerTypeRepr) THEN
  IF (yyP41^.Kind = OB.ShortintTypeRepr) THEN
(* line 831 "T.pum" *)
      RETURN OB.cIntegerTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.IntegerTypeRepr) THEN
(* line 837 "T.pum" *)
      RETURN OB.cIntegerTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.LongintTypeRepr) THEN
(* line 843 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.RealTypeRepr) THEN
(* line 849 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.LongrealTypeRepr) THEN
(* line 855 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  END;
  IF (yyP42^.Kind = OB.LongintTypeRepr) THEN
  IF (yyP41^.Kind = OB.ShortintTypeRepr) THEN
(* line 832 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.IntegerTypeRepr) THEN
(* line 838 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.LongintTypeRepr) THEN
(* line 844 "T.pum" *)
      RETURN OB.cLongintTypeRepr ;

  END;
  IF (yyP41^.Kind = OB.RealTypeRepr) THEN
(* line 850 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.LongrealTypeRepr) THEN
(* line 856 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  END;
  IF (yyP42^.Kind = OB.RealTypeRepr) THEN
  IF (yyP41^.Kind = OB.ShortintTypeRepr) THEN
(* line 833 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.IntegerTypeRepr) THEN
(* line 839 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.LongintTypeRepr) THEN
(* line 845 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.RealTypeRepr) THEN
(* line 851 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP41^.Kind = OB.LongrealTypeRepr) THEN
(* line 857 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  END;
  IF (yyP42^.Kind = OB.LongrealTypeRepr) THEN
  IF (yyP41^.Kind = OB.ShortintTypeRepr) THEN
(* line 834 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  IF (yyP41^.Kind = OB.IntegerTypeRepr) THEN
(* line 840 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  IF (yyP41^.Kind = OB.LongintTypeRepr) THEN
(* line 846 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  IF (yyP41^.Kind = OB.RealTypeRepr) THEN
(* line 852 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  IF (yyP41^.Kind = OB.LongrealTypeRepr) THEN
(* line 858 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
  END;
(* line 860 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

 END SetOrSmallestNumTypeInclBoth;

PROCEDURE SetOrSmallestRealType* (yyP43: OB.tOB): OB.tOB;
 BEGIN
  IF yyP43 = NIL THEN
(* line 864 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

  END;
  IF (yyP43^.Kind = OB.SetTypeRepr) THEN
(* line 866 "T.pum" *)
      RETURN OB.cSetTypeRepr     ;

  END;
  IF (yyP43^.Kind = OB.ShortintTypeRepr) THEN
(* line 868 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP43^.Kind = OB.IntegerTypeRepr) THEN
(* line 869 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP43^.Kind = OB.LongintTypeRepr) THEN
(* line 870 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP43^.Kind = OB.RealTypeRepr) THEN
(* line 871 "T.pum" *)
      RETURN OB.cRealTypeRepr    ;

  END;
  IF (yyP43^.Kind = OB.LongrealTypeRepr) THEN
(* line 872 "T.pum" *)
      RETURN OB.cLongrealTypeRepr;

  END;
(* line 874 "T.pum" *)
      RETURN OB.cErrorTypeRepr   ;

 END SetOrSmallestRealType;

PROCEDURE RelationInputType* (type1: OB.tOB; type2: OB.tOB): OB.tOB;
 BEGIN
  IF type1 = NIL THEN
(* line 878 "T.pum" *)
      RETURN OB.cErrorTypeRepr     ;

  END;
  IF type2 = NIL THEN
(* line 879 "T.pum" *)
      RETURN OB.cErrorTypeRepr     ;

  END;

  CASE type1^.Kind OF
  | OB.ShortintTypeRepr:
  IF (type2^.Kind = OB.ShortintTypeRepr) THEN
(* line 881 "T.pum" *)
      RETURN OB.cShortintTypeRepr  ;

  END;
  IF (type2^.Kind = OB.IntegerTypeRepr) THEN
(* line 887 "T.pum" *)
      RETURN OB.cIntegerTypeRepr   ;

  END;
  IF (type2^.Kind = OB.LongintTypeRepr) THEN
(* line 893 "T.pum" *)
      RETURN OB.cLongintTypeRepr   ;

  END;
  IF (type2^.Kind = OB.RealTypeRepr) THEN
(* line 899 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.LongrealTypeRepr) THEN
(* line 905 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  | OB.IntegerTypeRepr:
  IF (type2^.Kind = OB.ShortintTypeRepr) THEN
(* line 882 "T.pum" *)
      RETURN OB.cIntegerTypeRepr   ;

  END;
  IF (type2^.Kind = OB.IntegerTypeRepr) THEN
(* line 888 "T.pum" *)
      RETURN OB.cIntegerTypeRepr   ;

  END;
  IF (type2^.Kind = OB.LongintTypeRepr) THEN
(* line 894 "T.pum" *)
      RETURN OB.cLongintTypeRepr   ;

  END;
  IF (type2^.Kind = OB.RealTypeRepr) THEN
(* line 900 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.LongrealTypeRepr) THEN
(* line 906 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  | OB.LongintTypeRepr:
  IF (type2^.Kind = OB.ShortintTypeRepr) THEN
(* line 883 "T.pum" *)
      RETURN OB.cLongintTypeRepr   ;

  END;
  IF (type2^.Kind = OB.IntegerTypeRepr) THEN
(* line 889 "T.pum" *)
      RETURN OB.cLongintTypeRepr   ;

  END;
  IF (type2^.Kind = OB.LongintTypeRepr) THEN
(* line 895 "T.pum" *)
      RETURN OB.cLongintTypeRepr   ;

  END;
  IF (type2^.Kind = OB.RealTypeRepr) THEN
(* line 901 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.LongrealTypeRepr) THEN
(* line 907 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  | OB.RealTypeRepr:
  IF (type2^.Kind = OB.ShortintTypeRepr) THEN
(* line 884 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.IntegerTypeRepr) THEN
(* line 890 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.LongintTypeRepr) THEN
(* line 896 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.RealTypeRepr) THEN
(* line 902 "T.pum" *)
      RETURN OB.cRealTypeRepr      ;

  END;
  IF (type2^.Kind = OB.LongrealTypeRepr) THEN
(* line 908 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  | OB.LongrealTypeRepr:
  IF (type2^.Kind = OB.ShortintTypeRepr) THEN
(* line 885 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  IF (type2^.Kind = OB.IntegerTypeRepr) THEN
(* line 891 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  IF (type2^.Kind = OB.LongintTypeRepr) THEN
(* line 897 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  IF (type2^.Kind = OB.RealTypeRepr) THEN
(* line 903 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  IF (type2^.Kind = OB.LongrealTypeRepr) THEN
(* line 909 "T.pum" *)
      RETURN OB.cLongrealTypeRepr  ;

  END;
  | OB.CharTypeRepr:
  IF (type2^.Kind = OB.CharTypeRepr) THEN
(* line 911 "T.pum" *)
      RETURN OB.cCharTypeRepr      ;

  END;
  IF (type2^.Kind = OB.CharStringTypeRepr) THEN
(* line 912 "T.pum" *)
      RETURN OB.cCharTypeRepr      ;

  END;
  | OB.CharStringTypeRepr:
  IF (type2^.Kind = OB.CharTypeRepr) THEN
(* line 913 "T.pum" *)
      RETURN OB.cCharTypeRepr      ;

  END;
  IF (type2^.Kind = OB.CharStringTypeRepr) THEN
(* line 915 "T.pum" *)
      RETURN OB.cCharStringTypeRepr;

  END;
  IF (type2^.Kind = OB.StringTypeRepr) THEN
(* line 917 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  IF (type2^.Kind = OB.ArrayTypeRepr) THEN
  IF (type2^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
(* line 941 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  END;
  | OB.StringTypeRepr:
  IF (type2^.Kind = OB.CharStringTypeRepr) THEN
(* line 916 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  IF (type2^.Kind = OB.StringTypeRepr) THEN
(* line 918 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  IF (type2^.Kind = OB.ArrayTypeRepr) THEN
  IF (type2^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
(* line 946 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  END;
  | OB.BooleanTypeRepr:
  IF (type2^.Kind = OB.BooleanTypeRepr) THEN
(* line 920 "T.pum" *)
      RETURN OB.cBooleanTypeRepr   ;

  END;
  | OB.SetTypeRepr:
  IF (type2^.Kind = OB.SetTypeRepr) THEN
(* line 922 "T.pum" *)
      RETURN OB.cSetTypeRepr       ;

  END;
  | OB.ProcedureTypeRepr
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
  IF (type2^.Kind = OB.NilTypeRepr) THEN
(* line 924 "T.pum" *)
      RETURN OB.cNilTypeRepr       ;

  END;
  IF OB.IsType (type2, OB.ProcedureTypeRepr) THEN
(* line 931 "T.pum" *)
(* line 932 "T.pum" *)
       IF type1=type2 THEN RETURN OB.cNilTypeRepr; END; ;
      RETURN OB.cErrorTypeRepr     ;

  END;
  | OB.NilTypeRepr:
  IF OB.IsType (type2, OB.ProcedureTypeRepr) THEN
(* line 925 "T.pum" *)
      RETURN OB.cNilTypeRepr       ;

  END;
  IF (type2^.Kind = OB.NilTypeRepr) THEN
(* line 927 "T.pum" *)
      RETURN OB.cNilTypeRepr       ;

  END;
  IF (type2^.Kind = OB.PointerTypeRepr) THEN
(* line 929 "T.pum" *)
      RETURN OB.cNilTypeRepr       ;

  END;
  | OB.PointerTypeRepr:
  IF (type2^.Kind = OB.NilTypeRepr) THEN
(* line 928 "T.pum" *)
      RETURN OB.cNilTypeRepr       ;

  END;
  IF (type2^.Kind = OB.PointerTypeRepr) THEN
(* line 934 "T.pum" *)
(* line 935 "T.pum" *)
       IF (type1=type2)
                                                                OR IsExtensionOf(type1,type2)
                                                                OR IsExtensionOf(type2,type1)
                                                                THEN RETURN OB.cNilTypeRepr; END;
                                                              ;
      RETURN OB.cErrorTypeRepr     ;

  END;
  | OB.ArrayTypeRepr:
  IF (type1^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
  IF (type2^.Kind = OB.CharStringTypeRepr) THEN
(* line 943 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  IF (type2^.Kind = OB.StringTypeRepr) THEN
(* line 945 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  IF (type2^.Kind = OB.ArrayTypeRepr) THEN
  IF (type2^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.CharTypeRepr) THEN
(* line 948 "T.pum" *)
      RETURN OB.cStringTypeRepr    ;

  END;
  END;
  END;
  ELSE END;

(* line 951 "T.pum" *)
      RETURN OB.cErrorTypeRepr     ;

 END RelationInputType;

PROCEDURE IsLegalOrderRelationInputType* (yyP44: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP44 = OB.NoOB THEN RETURN FALSE; END;

  CASE yyP44^.Kind OF
  | OB.ErrorTypeRepr:
(* line 955 "T.pum" *)
      RETURN TRUE;

  | OB.CharTypeRepr:
(* line 956 "T.pum" *)
      RETURN TRUE;

  | OB.CharStringTypeRepr:
(* line 957 "T.pum" *)
      RETURN TRUE;

  | OB.StringTypeRepr:
(* line 958 "T.pum" *)
      RETURN TRUE;

  | OB.ShortintTypeRepr:
(* line 959 "T.pum" *)
      RETURN TRUE;

  | OB.IntegerTypeRepr:
(* line 960 "T.pum" *)
      RETURN TRUE;

  | OB.LongintTypeRepr:
(* line 961 "T.pum" *)
      RETURN TRUE;

  | OB.RealTypeRepr:
(* line 962 "T.pum" *)
      RETURN TRUE;

  | OB.LongrealTypeRepr:
(* line 963 "T.pum" *)
      RETURN TRUE;

  ELSE END;

  RETURN FALSE;
 END IsLegalOrderRelationInputType;

PROCEDURE LegalCaseExprTypesOnly* (Te: OB.tOB): OB.tOB;
 BEGIN
  IF (Te^.Kind = OB.CharTypeRepr) THEN
(* line 967 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.CharStringTypeRepr) THEN
(* line 968 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.ShortintTypeRepr) THEN
(* line 969 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.IntegerTypeRepr) THEN
(* line 970 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.LongintTypeRepr) THEN
(* line 971 "T.pum" *)
      RETURN Te;

  END;
(* line 972 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END LegalCaseExprTypesOnly;

PROCEDURE IsCaseExprCompatible* (Te: OB.tOB; Tl: OB.tOB): BOOLEAN;
 BEGIN
  IF Te = OB.NoOB THEN RETURN FALSE; END;
  IF Tl = OB.NoOB THEN RETURN FALSE; END;
(* line 976 "T.pum" *)
   LOOP
(* line 976 "T.pum" *)
      IF ~(IsCharType (Te) & IsCharType (Tl)) THEN EXIT; END;
      RETURN TRUE;
   END;

(* line 977 "T.pum" *)
   LOOP
(* line 977 "T.pum" *)
      IF ~(IsIntegerType (Te) & IsIncludedBy (Tl, Te)) THEN EXIT; END;
      RETURN TRUE;
   END;

  RETURN FALSE;
 END IsCaseExprCompatible;

PROCEDURE ConstTypeCorrection* (Type: OB.tOB; Value: OB.tOB): OB.tOB;
 BEGIN
  IF (Type^.Kind = OB.CharTypeRepr) THEN
  IF (Value^.Kind = OB.CharValue) THEN
(* line 981 "T.pum" *)
      RETURN OB.cCharStringTypeRepr;

  END;
  END;
  IF (Type^.Kind = OB.ShortintTypeRepr) THEN
  IF (Value^.Kind = OB.IntegerValue) THEN
(* line 982 "T.pum" *)
      RETURN MinimalIntegerType(Value^.IntegerValue.v) ;

  END;
  END;
  IF (Type^.Kind = OB.IntegerTypeRepr) THEN
  IF (Value^.Kind = OB.IntegerValue) THEN
(* line 983 "T.pum" *)
      RETURN MinimalIntegerType(Value^.IntegerValue.v) ;

  END;
  END;
  IF (Type^.Kind = OB.LongintTypeRepr) THEN
  IF (Value^.Kind = OB.IntegerValue) THEN
(* line 984 "T.pum" *)
      RETURN MinimalIntegerType(Value^.IntegerValue.v) ;

  END;
  END;
(* line 985 "T.pum" *)
      RETURN Type;

 END ConstTypeCorrection;

PROCEDURE IsLegalResultType* (yyP45: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP45 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP45^.Kind = OB.RecordTypeRepr) THEN
(* line 989 "T.pum" *)
(* line 989 "T.pum" *)
      RETURN FALSE;

  END;
  IF (yyP45^.Kind = OB.ArrayTypeRepr) THEN
(* line 990 "T.pum" *)
(* line 990 "T.pum" *)
      RETURN FALSE;

  END;
(* line 991 "T.pum" *)
      RETURN TRUE;

 END IsLegalResultType;

PROCEDURE LegalForExprTypesOnly* (Te: OB.tOB): OB.tOB;
 BEGIN
  IF (Te^.Kind = OB.ShortintTypeRepr) THEN
(* line 995 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.IntegerTypeRepr) THEN
(* line 996 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.LongintTypeRepr) THEN
(* line 997 "T.pum" *)
      RETURN Te;

  END;
(* line 998 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END LegalForExprTypesOnly;

PROCEDURE LegalAbsTypesOnly* (Te: OB.tOB): OB.tOB;
 BEGIN
  IF (Te^.Kind = OB.ShortintTypeRepr) THEN
(* line 1002 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.IntegerTypeRepr) THEN
(* line 1003 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.LongintTypeRepr) THEN
(* line 1004 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.RealTypeRepr) THEN
(* line 1005 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.LongrealTypeRepr) THEN
(* line 1006 "T.pum" *)
      RETURN Te;

  END;
(* line 1007 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END LegalAbsTypesOnly;

PROCEDURE IsValidLenDim* (T: OB.tOB; yyP46: OB.tOB): BOOLEAN;
 BEGIN
  IF T = OB.NoOB THEN RETURN FALSE; END;
  IF yyP46 = OB.NoOB THEN RETURN FALSE; END;
  IF (T^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyP46^.Kind = OB.IntegerValue) THEN
(* line 1012 "T.pum" *)
(* line 1012 "T.pum" *)
                                                                                    
    RETURN (0<=yyP46^.IntegerValue.v) & (yyP46^.IntegerValue.v<DimOfArrayType(T));
 ;
      RETURN TRUE;

  END;
  END;
(* line 1016 "T.pum" *)
      RETURN TRUE;

 END IsValidLenDim;

PROCEDURE LegalShiftableTypesOnly* (Te: OB.tOB): OB.tOB;
 BEGIN
  IF (Te^.Kind = OB.ShortintTypeRepr) THEN
(* line 1020 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.IntegerTypeRepr) THEN
(* line 1021 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.LongintTypeRepr) THEN
(* line 1022 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.CharTypeRepr) THEN
(* line 1023 "T.pum" *)
      RETURN Te;

  END;
  IF (Te^.Kind = OB.ByteTypeRepr) THEN
(* line 1024 "T.pum" *)
      RETURN Te;

  END;
(* line 1025 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END LegalShiftableTypesOnly;

PROCEDURE DupAllFields* (Tail: OB.tOB; CurrField: OB.tOB): OB.tOB;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 yyR3: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (CurrField^.Kind = OB.VarEntry) THEN
(* line 1037 "T.pum" *)
       yyTempo.yyR1.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR1.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . VarEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . VarEntry ; 
      yyTempo.yyR1.yyV1^.VarEntry.prevEntry := DupAllFields (Tail, CurrField^.VarEntry.prevEntry);
      yyTempo.yyR1.yyV1^.VarEntry.module := CurrField^.VarEntry.module;
      yyTempo.yyR1.yyV1^.VarEntry.ident := CurrField^.VarEntry.ident;
      yyTempo.yyR1.yyV1^.VarEntry.exportMode := CurrField^.VarEntry.exportMode;
      yyTempo.yyR1.yyV1^.VarEntry.level := CurrField^.VarEntry.level;
      yyTempo.yyR1.yyV1^.VarEntry.declStatus := CurrField^.VarEntry.declStatus;
      yyTempo.yyR1.yyV1^.VarEntry.typeRepr := CurrField^.VarEntry.typeRepr;
      yyTempo.yyR1.yyV1^.VarEntry.isParam := CurrField^.VarEntry.isParam;
      yyTempo.yyR1.yyV1^.VarEntry.isReceiverPar := CurrField^.VarEntry.isReceiverPar;
      yyTempo.yyR1.yyV1^.VarEntry.parMode := CurrField^.VarEntry.parMode;
      yyTempo.yyR1.yyV1^.VarEntry.address := CurrField^.VarEntry.address;
      yyTempo.yyR1.yyV1^.VarEntry.refMode := CurrField^.VarEntry.refMode;
      yyTempo.yyR1.yyV1^.VarEntry.isWithed := CurrField^.VarEntry.isWithed;
      yyTempo.yyR1.yyV1^.VarEntry.isLaccessed := CurrField^.VarEntry.isLaccessed;
      RETURN yyTempo.yyR1.yyV1;
  END;

  IF (CurrField^.Kind = OB.BoundProcEntry) THEN
(* line 1050 "T.pum" *)
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . InheritedProcEntry ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . InheritedProcEntry ; 
      yyTempo.yyR2.yyV1^.InheritedProcEntry.prevEntry := DupAllFields (Tail, CurrField^.BoundProcEntry.prevEntry);
      yyTempo.yyR2.yyV1^.InheritedProcEntry.module := CurrField^.BoundProcEntry.module;
      yyTempo.yyR2.yyV1^.InheritedProcEntry.ident := CurrField^.BoundProcEntry.ident;
      yyTempo.yyR2.yyV1^.InheritedProcEntry.exportMode := CurrField^.BoundProcEntry.exportMode;
      yyTempo.yyR2.yyV1^.InheritedProcEntry.level := CurrField^.BoundProcEntry.level;
      yyTempo.yyR2.yyV1^.InheritedProcEntry.declStatus := CurrField^.BoundProcEntry.declStatus;
      yyTempo.yyR2.yyV1^.InheritedProcEntry.boundProcEntry := CurrField;
      RETURN yyTempo.yyR2.yyV1;

  END;
  IF (CurrField^.Kind = OB.InheritedProcEntry) THEN
(* line 1061 "T.pum" *)
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . InheritedProcEntry ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . InheritedProcEntry ; 
      yyTempo.yyR3.yyV1^.InheritedProcEntry.prevEntry := DupAllFields (Tail, CurrField^.InheritedProcEntry.prevEntry);
      yyTempo.yyR3.yyV1^.InheritedProcEntry.module := CurrField^.InheritedProcEntry.module;
      yyTempo.yyR3.yyV1^.InheritedProcEntry.ident := CurrField^.InheritedProcEntry.ident;
      yyTempo.yyR3.yyV1^.InheritedProcEntry.exportMode := CurrField^.InheritedProcEntry.exportMode;
      yyTempo.yyR3.yyV1^.InheritedProcEntry.level := CurrField^.InheritedProcEntry.level;
      yyTempo.yyR3.yyV1^.InheritedProcEntry.declStatus := CurrField^.InheritedProcEntry.declStatus;
      yyTempo.yyR3.yyV1^.InheritedProcEntry.boundProcEntry := CurrField^.InheritedProcEntry.boundProcEntry;
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF OB.IsType (CurrField, OB.DataEntry) THEN
(* line 1072 "T.pum" *)
      RETURN DupAllFields (Tail, CurrField^.DataEntry.prevEntry);

  END;
(* line 1077 "T.pum" *)
      RETURN Tail;

 END DupAllFields;

PROCEDURE CloneRecordFields* (NewScope: OB.tOB; BaseTypeRepr: OB.tOB): OB.tOB;
 BEGIN
  IF (BaseTypeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 1085 "T.pum" *)
(* line 1098 "T.pum" *)
       NewScope:=DupAllFields(NewScope,BaseTypeRepr^.RecordTypeRepr.fields);
                        ;
      RETURN NewScope;

  END;
(* line 1101 "T.pum" *)
      RETURN NewScope;

 END CloneRecordFields;

PROCEDURE AppendExtension* (recordTypeRepr: OB.tOB; newRecordTypeRepr: OB.tOB);
 BEGIN
  IF recordTypeRepr = OB.NoOB THEN RETURN; END;
  IF newRecordTypeRepr = OB.NoOB THEN RETURN; END;
  IF (recordTypeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 1106 "T.pum" *)
(* line 1117 "T.pum" *)
       recordTypeRepr^.RecordTypeRepr.extTypeReprList:=OB.mTypeReprList
                                             ((* prev     := *) recordTypeRepr^.RecordTypeRepr.extTypeReprList
                                             ,(* typeRepr := *) newRecordTypeRepr);
                            ;
      RETURN;

  END;
(* line 1122 "T.pum" *)
      RETURN;

 END AppendExtension;

PROCEDURE RedefAlreadyExists* (fields: OB.tOB; ident: tIdent; orgProc: OB.tOB): BOOLEAN;
 BEGIN
  IF fields = OB.NoOB THEN RETURN FALSE; END;
  IF orgProc = OB.NoOB THEN RETURN FALSE; END;
  IF (fields^.Kind = OB.BoundProcEntry) THEN
  IF ( fields^.BoundProcEntry.ident  =   ident  ) THEN
(* line 1131 "T.pum" *)
(* line 1145 "T.pum" *)
      fields^.BoundProcEntry.redefinedProc := orgProc;
      RETURN TRUE;

  END;
  END;
  IF OB.IsType (fields, OB.DataEntry) THEN
(* line 1147 "T.pum" *)
   LOOP
(* line 1147 "T.pum" *)
      IF ~(RedefAlreadyExists (fields^.DataEntry.prevEntry, ident, orgProc)) THEN EXIT; END;
      RETURN TRUE;
   END;

  END;
  RETURN FALSE;
 END RedefAlreadyExists;

PROCEDURE DeleteBoundProc* (field: OB.tOB; module: OB.tOB; ident: tIdent; VAR yyP47: OB.tOB): OB.tOB;
(* line 1158 "T.pum" *)
 VAR deletedProc:OB.tOB; 
 VAR yyTempo: RECORD 
 yyR2: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (field^.Kind = OB.InheritedProcEntry) THEN
  IF ( field^.InheritedProcEntry.ident  =   ident  ) THEN
(* line 1161 "T.pum" *)
(* line 1171 "T.pum" *)
       deletedProc:=field^.InheritedProcEntry.boundProcEntry; 
                        IF (field^.InheritedProcEntry.module=module) OR (field^.InheritedProcEntry.exportMode#OB.PRIVATE) THEN 
                           field:=field^.InheritedProcEntry.prevEntry;
                        END;
                      ;
      yyP47 := deletedProc;
      RETURN field;

  END;
  END;
  IF OB.IsType (field, OB.DataEntry) THEN
(* line 1178 "T.pum" *)
(* line 1183 "T.pum" *)
      field^.DataEntry.prevEntry := DeleteBoundProc (field^.DataEntry.prevEntry, module, ident, yyTempo.yyR2.yyV1);
      yyP47 := yyTempo.yyR2.yyV1;
      RETURN field;

  END;
(* line 1186 "T.pum" *)
      yyP47 := OB.cmtEntry;
      RETURN field;

 END DeleteBoundProc;

PROCEDURE BindProcedureToExtensions* (typeReprList: OB.tOB; entry: OB.tOB; table: OB.tOB; module: OB.tOB): OB.tOB;
 VAR yyTempo: RECORD 
 yyR1: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (typeReprList^.Kind = OB.TypeReprList) THEN
  IF (entry^.Kind = OB.BoundProcEntry) THEN
(* line 1199 "T.pum" *)
       yyTempo.yyR1.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR1.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . InheritedProcEntry ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . InheritedProcEntry ; 
       yyTempo.yyR1.yyV1^.InheritedProcEntry.prevEntry  := NIL; 
      yyTempo.yyR1.yyV1^.InheritedProcEntry.module := entry^.BoundProcEntry.module;
      yyTempo.yyR1.yyV1^.InheritedProcEntry.ident := entry^.BoundProcEntry.ident;
      yyTempo.yyR1.yyV1^.InheritedProcEntry.exportMode := entry^.BoundProcEntry.exportMode;
      yyTempo.yyR1.yyV1^.InheritedProcEntry.level := entry^.BoundProcEntry.level;
      yyTempo.yyR1.yyV1^.InheritedProcEntry.declStatus := entry^.BoundProcEntry.declStatus;
      yyTempo.yyR1.yyV1^.InheritedProcEntry.boundProcEntry := entry;
      RETURN BindProcedureToRecord (typeReprList^.TypeReprList.typeRepr, yyTempo.yyR1.yyV1, BindProcedureToExtensions (typeReprList^.TypeReprList.prev, entry, table, module), OB.cmtEntry, POS.NoPosition, module);

  END;
  END;
(* line 1229 "T.pum" *)
      RETURN table;

 END BindProcedureToExtensions;

PROCEDURE BindProcedureToRecord* (type: OB.tOB; entry: OB.tOB; table: OB.tOB; forwardEntry: OB.tOB; currPosition: tPosition; module: OB.tOB): OB.tOB;
(* line 1239 "T.pum" *)
 VAR dummyEntry:OB.tOB; 
 BEGIN
  IF (entry^.Kind = OB.BoundProcEntry) THEN
  IF (forwardEntry^.Kind = OB.BoundProcEntry) THEN
(* line 1242 "T.pum" *)
(* line 1264 "T.pum" *)
       IF ~forwardEntry^.BoundProcEntry.complete THEN 
                            forwardEntry^.BoundProcEntry.exportMode := Base.MaxExportMode(forwardEntry^.BoundProcEntry.exportMode,entry^.BoundProcEntry.exportMode);
                            forwardEntry^.BoundProcEntry.position    := currPosition;
                            forwardEntry^.BoundProcEntry.complete    := TRUE;
                         END;
                       ;
      RETURN table;

  END;
  END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
  IF (entry^.Kind = OB.BoundProcEntry) THEN
(* line 1272 "T.pum" *)
(* line 1300 "T.pum" *)
        entry^.BoundProcEntry.prevEntry   := DeleteBoundProc(type^.RecordTypeRepr.fields,module,entry^.BoundProcEntry.ident,entry^.BoundProcEntry.redefinedProc); 
                          type^.RecordTypeRepr.fields := entry; 
                       ;
      RETURN BindProcedureToExtensions (type^.RecordTypeRepr.extTypeReprList, entry, table, module);

  END;
  IF (entry^.Kind = OB.InheritedProcEntry) THEN
(* line 1305 "T.pum" *)
(* line 1326 "T.pum" *)
       IF ~RedefAlreadyExists(type^.RecordTypeRepr.fields,entry^.InheritedProcEntry.ident,entry^.InheritedProcEntry.boundProcEntry) THEN 
                            entry^.InheritedProcEntry.prevEntry   := DeleteBoundProc(type^.RecordTypeRepr.fields,module,entry^.InheritedProcEntry.ident,dummyEntry); 
                            type^.RecordTypeRepr.fields :=entry;
                            table  := BindProcedureToExtensions(type^.RecordTypeRepr.extTypeReprList,entry^.InheritedProcEntry.boundProcEntry,table,module);
                         END;
                       ;
      RETURN table;

  END;
  END;
(* line 1334 "T.pum" *)
      RETURN table;

 END BindProcedureToRecord;

PROCEDURE LegalReceiverTypeOnly* (type: OB.tOB): OB.tOB;
 BEGIN
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 1339 "T.pum" *)
      RETURN type;

  END;
  IF (type^.Kind = OB.PointerTypeRepr) THEN
  IF (type^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 1341 "T.pum" *)
      RETURN type;

  END;
  END;
  END;
(* line 1357 "T.pum" *)
      RETURN OB.cErrorTypeRepr;

 END LegalReceiverTypeOnly;

PROCEDURE CheckFieldsPreRedefs* (fields: OB.tOB; boundProcIdent: tIdent; boundProcType: OB.tOB);
 BEGIN
  IF fields = OB.NoOB THEN RETURN; END;
  IF boundProcType = OB.NoOB THEN RETURN; END;
  IF (fields^.Kind = OB.BoundProcEntry) THEN
  IF ( fields^.BoundProcEntry.ident  =   boundProcIdent  ) THEN
(* line 1367 "T.pum" *)
(* line 1380 "T.pum" *)
       CheckFieldsPreRedefs                                
                            (fields^.BoundProcEntry.prevEntry
                            ,boundProcIdent
                            ,boundProcType);

                            IF ~HaveMatchingFormalPars(fields^.BoundProcEntry.typeRepr,boundProcType)                               
                               THEN ERR.MsgPos(ERR.MsgNonMatchingRedef,fields^.BoundProcEntry.position);
                            END; (* IF *)
                         ;
      RETURN;

  END;
  END;
  IF OB.IsType (fields, OB.DataEntry) THEN
(* line 1391 "T.pum" *)
(* line 1395 "T.pum" *)
       CheckFieldsPreRedefs                                
                            (fields^.DataEntry.prevEntry
                            ,boundProcIdent
                            ,boundProcType);
                          ;
      RETURN;

  END;
 END CheckFieldsPreRedefs;

PROCEDURE CheckTypeReprListsPreRedefs* (typeReprList: OB.tOB; boundProcIdent: tIdent; boundProcType: OB.tOB);
 BEGIN
  IF typeReprList = OB.NoOB THEN RETURN; END;
  IF boundProcType = OB.NoOB THEN RETURN; END;
  IF (typeReprList^.Kind = OB.TypeReprList) THEN
  IF (typeReprList^.TypeReprList.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 1408 "T.pum" *)
(* line 1423 "T.pum" *)
       CheckTypeReprListsPreRedefs                         
                            (typeReprList^.TypeReprList.prev
                            ,boundProcIdent
                            ,boundProcType);

                            CheckTypeReprListsPreRedefs                         
                            (typeReprList^.TypeReprList.typeRepr^.RecordTypeRepr.extTypeReprList
                            ,boundProcIdent
                            ,boundProcType);

                            CheckFieldsPreRedefs                                
                            (typeReprList^.TypeReprList.typeRepr^.RecordTypeRepr.fields
                            ,boundProcIdent
                            ,boundProcType);
                         ;
      RETURN;

  END;
  END;
 END CheckTypeReprListsPreRedefs;

PROCEDURE CheckPreRedefinitions* (receiverType: OB.tOB; boundProcIdent: tIdent; boundProcType: OB.tOB);
 BEGIN
  IF receiverType = OB.NoOB THEN RETURN; END;
  IF boundProcType = OB.NoOB THEN RETURN; END;
  IF (receiverType^.Kind = OB.RecordTypeRepr) THEN
(* line 1446 "T.pum" *)
(* line 1457 "T.pum" *)
       CheckTypeReprListsPreRedefs                         
                            (receiverType^.RecordTypeRepr.extTypeReprList
                            ,boundProcIdent
                            ,boundProcType);
                          ;
      RETURN;

  END;
 END CheckPreRedefinitions;

PROCEDURE CheckBoundProc* (module: OB.tOB; field: OB.tOB; boundProcType: OB.tOB; isForward: BOOLEAN; receiverType: OB.tOB; boundProcIdent: tIdent): tErrorMsg;
(* line 1470 "T.pum" *)
VAR ErrorMsg:tErrorMsg;
 BEGIN
  IF (field^.Kind = OB.ErrorEntry) THEN
(* line 1473 "T.pum" *)
(* line 1477 "T.pum" *)
       CheckPreRedefinitions
                          (receiverType
                          ,boundProcIdent
                          ,boundProcType);
                        ;
      RETURN ERR.NoErrorMsg;

  END;
  IF (field^.Kind = OB.VarEntry) THEN
(* line 1484 "T.pum" *)
(* line 1493 "T.pum" *)
       IF (field^.VarEntry.module=module)                                       
                          OR (field^.VarEntry.exportMode#OB.PRIVATE)
                             THEN ErrorMsg := ERR.MsgAlreadyDeclared;           
                             ELSE ErrorMsg := ERR.NoErrorMsg;
                          END;
                        ;
      RETURN ErrorMsg;

  END;
  IF (field^.Kind = OB.BoundProcEntry) THEN
  IF OB.IsType (field^.BoundProcEntry.typeRepr, OB.ProcedureTypeRepr) THEN
  IF ( field^.BoundProcEntry.complete  =   FALSE  ) THEN
(* line 1501 "T.pum" *)
(* line 1515 "T.pum" *)
       
IF isForward THEN ErrorMsg:=ERR.MsgAlreadyDeclared
ELSIF ~HaveMatchingFormalPars(field^.BoundProcEntry.typeRepr,boundProcType)
                             THEN ErrorMsg := ERR.MsgNonMatchingActualDecl;     
                             ELSE ErrorMsg := ERR.NoErrorMsg;
                          END;
                        ;
      RETURN ErrorMsg;

  END;
  END;
(* line 1524 "T.pum" *)
      RETURN ERR.MsgAlreadyDeclared;

  END;
  IF (field^.Kind = OB.InheritedProcEntry) THEN
  IF (field^.InheritedProcEntry.boundProcEntry^.Kind = OB.BoundProcEntry) THEN
  IF OB.IsType (field^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.typeRepr, OB.ProcedureTypeRepr) THEN
(* line 1530 "T.pum" *)
(* line 1551 "T.pum" *)
       IF ((field^.InheritedProcEntry.module=module) OR                                   
                              (field^.InheritedProcEntry.exportMode#OB.PRIVATE))
                           & ~HaveMatchingFormalPars(field^.InheritedProcEntry.boundProcEntry^.BoundProcEntry.typeRepr,boundProcType)
                             THEN ErrorMsg := ERR.MsgNonMatchingRedef;          
                             ELSE ErrorMsg := ERR.NoErrorMsg;
                          END;
                        ;
      RETURN ErrorMsg;

  END;
  END;
  END;
  yyAbort ('CheckBoundProc');
 END CheckBoundProc;

PROCEDURE IsExistingBoundProc* (Module: OB.tOB; yyP48: OB.tOB; BoundProc: OB.tOB): BOOLEAN;
 BEGIN
  IF Module = OB.NoOB THEN RETURN FALSE; END;
  IF yyP48 = OB.NoOB THEN RETURN FALSE; END;
  IF BoundProc = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP48^.Kind = OB.ErrorTypeRepr) THEN
(* line 1562 "T.pum" *)
      RETURN TRUE;

  END;
  IF (BoundProc^.Kind = OB.ErrorEntry) THEN
(* line 1563 "T.pum" *)
      RETURN TRUE;

  END;
  IF (yyP48^.Kind = OB.RecordTypeRepr) THEN
  IF (BoundProc^.Kind = OB.BoundProcEntry) THEN
(* line 1565 "T.pum" *)
(* line 1583 "T.pum" *)
       RETURN Base.IsVisibleBoundProcEntry
                                      (Module
                                      ,Base.Lookup0(yyP48^.RecordTypeRepr.fields,BoundProc^.BoundProcEntry.ident))
                             ;
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END IsExistingBoundProc;

PROCEDURE CalcProcNumsOfEntries* (table: OB.tOB);
 BEGIN
  IF table = OB.NoOB THEN RETURN; END;
  IF (table^.Kind = OB.TypeEntry) THEN
  IF (yyIsEqual ( table^.TypeEntry.declStatus ,   OB.DECLARED ) ) THEN
(* line 1591 "T.pum" *)
(* line 1598 "T.pum" *)
      CalcProcNumsOfEntries (table^.TypeEntry.prevEntry);
(* line 1598 "T.pum" *)
      CalcProcNumsOfType (table^.TypeEntry.typeRepr);
      RETURN;

  END;
  END;
  IF OB.IsType (table, OB.DataEntry) THEN
(* line 1600 "T.pum" *)
(* line 1600 "T.pum" *)
      CalcProcNumsOfEntries (table^.DataEntry.prevEntry);
      RETURN;

  END;
 END CalcProcNumsOfEntries;

PROCEDURE CalcProcNumsOfType* (type: OB.tOB);
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 1605 "T.pum" *)
(* line 1615 "T.pum" *)
       IF type^.RecordTypeRepr.nofBoundProcs=0 THEN 
                                                         type^.RecordTypeRepr.nofBoundProcs:=CountNonOriginBoundProcs(type^.RecordTypeRepr.fields); 
                                                      END;
                                                    ;
(* line 1619 "T.pum" *)
      CalcProcNumsOfFields (type^.RecordTypeRepr.fields, type);
      RETURN;

  END;
  IF (type^.Kind = OB.PointerTypeRepr) THEN
  IF (type^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 1621 "T.pum" *)
(* line 1635 "T.pum" *)
      CalcProcNumsOfType (type^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr);
      RETURN;

  END;
  END;
 END CalcProcNumsOfType;

PROCEDURE CountNonOriginBoundProcs* (yyP49: OB.tOB): LONGINT;
(* line 1639 "T.pum" *)
 VAR n:LONGINT; 
 BEGIN
  IF (yyP49^.Kind = OB.BoundProcEntry) THEN
(* line 1641 "T.pum" *)
   LOOP
(* line 1657 "T.pum" *)
      IF ~((~ Base . IsGenuineEmptyEntry (yyP49^.BoundProcEntry.redefinedProc))) THEN EXIT; END;
      RETURN 1 + CountNonOriginBoundProcs (yyP49^.BoundProcEntry.prevEntry);
   END;

  END;
  IF (yyP49^.Kind = OB.InheritedProcEntry) THEN
(* line 1659 "T.pum" *)
      RETURN 1 + CountNonOriginBoundProcs (yyP49^.InheritedProcEntry.prevEntry);

  END;
  IF OB.IsType (yyP49, OB.DataEntry) THEN
(* line 1663 "T.pum" *)
      RETURN CountNonOriginBoundProcs (yyP49^.DataEntry.prevEntry);

  END;
(* line 1665 "T.pum" *)
      RETURN 0;

 END CountNonOriginBoundProcs;

PROCEDURE CalcProcNumsOfFields* (fields: OB.tOB; type: OB.tOB);
 BEGIN
  IF fields = OB.NoOB THEN RETURN; END;
  IF type = OB.NoOB THEN RETURN; END;
  IF (fields^.Kind = OB.BoundProcEntry) THEN
(* line 1670 "T.pum" *)
   LOOP
(* line 1685 "T.pum" *)
      IF ~((fields^.BoundProcEntry.procNum = OB.NOPROCNUM)) THEN EXIT; END;
(* line 1686 "T.pum" *)
      CalcProcNumsOfFields (fields^.BoundProcEntry.prevEntry, type);
(* line 1687 "T.pum" *)
       IF Base.IsGenuineEmptyEntry(fields^.BoundProcEntry.redefinedProc) THEN 
                                       fields^.BoundProcEntry.procNum:=NewProcNum(type); 
                                    ELSE 
                                       fields^.BoundProcEntry.procNum:=ProcNumOfBoundProc(fields^.BoundProcEntry.redefinedProc); 
                                    END; ;
      RETURN;
   END;

  END;
  IF OB.IsType (fields, OB.DataEntry) THEN
(* line 1693 "T.pum" *)
(* line 1693 "T.pum" *)
      CalcProcNumsOfFields (fields^.DataEntry.prevEntry, type);
      RETURN;

  END;
 END CalcProcNumsOfFields;

PROCEDURE ProcNumOfBoundProc* (entry: OB.tOB): LONGINT;
 BEGIN
  IF (entry^.Kind = OB.BoundProcEntry) THEN
(* line 1698 "T.pum" *)
(* line 1714 "T.pum" *)
       IF entry^.BoundProcEntry.procNum=OB.NOPROCNUM THEN 
                               CalcProcNumsOfType(SYSTEM.VAL(OB.tOB,Base.ReceiverTypeOfBoundProc(entry)))
                            END; ;
      RETURN entry^.BoundProcEntry.procNum;

  END;
(* line 1718 "T.pum" *)
      RETURN OB.NOPROCNUM;

 END ProcNumOfBoundProc;

PROCEDURE NewProcNum* (yyP50: OB.tOB): LONGINT;
(* line 1722 "T.pum" *)
 VAR num:LONGINT; 
 BEGIN
  IF (yyP50^.Kind = OB.RecordTypeRepr) THEN
(* line 1724 "T.pum" *)
(* line 1735 "T.pum" *)
       num:=yyP50^.RecordTypeRepr.nofBoundProcs; INC(yyP50^.RecordTypeRepr.nofBoundProcs); ;
      RETURN num;

  END;
(* line 1737 "T.pum" *)
      RETURN OB.NOPROCNUM;

 END NewProcNum;

PROCEDURE TypeSelected* (yyP51: OB.tOB; ident: tIdent): OB.tOB;
 BEGIN
  IF (yyP51^.Kind = OB.RecordTypeRepr) THEN
(* line 1741 "T.pum" *)
      RETURN SYSTEM.VAL(OB.tOB,Base.Lookup0(yyP51^.RecordTypeRepr.fields,ident));

  END;
(* line 1742 "T.pum" *)
      RETURN OB.cErrorEntry     ;

 END TypeSelected;

PROCEDURE TypeIndexed* (yyP52: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP52^.Kind = OB.ArrayTypeRepr) THEN
(* line 1746 "T.pum" *)
      RETURN yyP52^.ArrayTypeRepr.elemTypeRepr;

  END;
(* line 1747 "T.pum" *)
      RETURN OB.cErrorTypeRepr      ;

 END TypeIndexed;

PROCEDURE TypeOpenIndexed* (yyP53: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP53^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( yyP53^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
(* line 1751 "T.pum" *)
      RETURN yyP53^.ArrayTypeRepr.elemTypeRepr;

  END;
  END;
(* line 1752 "T.pum" *)
      RETURN OB.cErrorTypeRepr      ;

 END TypeOpenIndexed;

PROCEDURE TypeDereferenced* (yyP54: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP54^.Kind = OB.PointerTypeRepr) THEN
  IF (yyP54^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
(* line 1756 "T.pum" *)
      RETURN yyP54^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr;

  END;
  END;
(* line 1757 "T.pum" *)
      RETURN OB.cErrorTypeRepr      ;

 END TypeDereferenced;

PROCEDURE TypeArgumented* (procTypeRepr: OB.tOB): OB.tOB;
 BEGIN
  IF OB.IsType (procTypeRepr, OB.ProcedureTypeRepr) THEN
(* line 1762 "T.pum" *)
      RETURN procTypeRepr^.ProcedureTypeRepr.resultType;

  END;
(* line 1763 "T.pum" *)
      RETURN OB.cErrorTypeRepr      ;

 END TypeArgumented;

PROCEDURE TypeLonged* (yyP55: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP55^.Kind = OB.ShortintTypeRepr) THEN
(* line 1767 "T.pum" *)
      RETURN OB.cIntegerTypeRepr    ;

  END;
  IF (yyP55^.Kind = OB.IntegerTypeRepr) THEN
(* line 1768 "T.pum" *)
      RETURN OB.cLongintTypeRepr    ;

  END;
  IF (yyP55^.Kind = OB.RealTypeRepr) THEN
(* line 1769 "T.pum" *)
      RETURN OB.cLongrealTypeRepr   ;

  END;
(* line 1770 "T.pum" *)
      RETURN OB.cErrorTypeRepr      ;

 END TypeLonged;

PROCEDURE TypeShortened* (yyP56: OB.tOB): OB.tOB;
 BEGIN
  IF (yyP56^.Kind = OB.IntegerTypeRepr) THEN
(* line 1774 "T.pum" *)
      RETURN OB.cShortintTypeRepr   ;

  END;
  IF (yyP56^.Kind = OB.LongintTypeRepr) THEN
(* line 1775 "T.pum" *)
      RETURN OB.cIntegerTypeRepr    ;

  END;
  IF (yyP56^.Kind = OB.LongrealTypeRepr) THEN
(* line 1776 "T.pum" *)
      RETURN OB.cRealTypeRepr       ;

  END;
(* line 1777 "T.pum" *)
      RETURN OB.cErrorTypeRepr      ;

 END TypeShortened;

PROCEDURE TypeLimited* (type: OB.tOB): OB.tOB;
 BEGIN
  IF (type^.Kind = OB.SetTypeRepr) THEN
(* line 1781 "T.pum" *)
      RETURN OB.cIntegerTypeRepr    ;

  END;
(* line 1782 "T.pum" *)
      RETURN type;

 END TypeLimited;

PROCEDURE TypeDimensioned* (yyP58: OB.tOB; yyP57: OB.tOB): OB.tOB;
(* line 1786 "T.pum" *)
 VAR o:OB.tOB; 
 BEGIN
  IF (yyP58^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyP57^.Kind = OB.IntegerValue) THEN
(* line 1788 "T.pum" *)
(* line 1788 "T.pum" *)
                                                 
    IF yyP57^.IntegerValue.v=0
       THEN IF yyP58^.ArrayTypeRepr.len=OB.OPENARRAYLEN
               THEN o := OB.cmtValue;
               ELSE o := OB.mIntegerValue(yyP58^.ArrayTypeRepr.len);
            END;
    ELSIF yyP57^.IntegerValue.v>0
       THEN o := TypeDimensioned(yyP58^.ArrayTypeRepr.elemTypeRepr,OB.mIntegerValue(yyP57^.IntegerValue.v-1));
       ELSE o := OB.cErrorValue;
    END;
 ;
      RETURN o;

  END;
  IF (yyP57^.Kind = OB.mtValue) THEN
(* line 1800 "T.pum" *)
(* line 1800 "T.pum" *)
      
    IF yyP58^.ArrayTypeRepr.len=OB.OPENARRAYLEN
       THEN o := OB.cmtValue;
       ELSE o := OB.mIntegerValue(yyP58^.ArrayTypeRepr.len);
    END;
 ;
      RETURN o;

  END;
  END;
(* line 1807 "T.pum" *)
      RETURN OB.cErrorValue;

 END TypeDimensioned;

PROCEDURE AppendTDesc* (yyP60: OB.tOB; yyP59: OB.tOB; n: OB.tOB);
 BEGIN
  IF yyP60 = OB.NoOB THEN RETURN; END;
  IF yyP59 = OB.NoOB THEN RETURN; END;
  IF n = OB.NoOB THEN RETURN; END;
  IF (yyP59^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (yyP59^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 1812 "T.pum" *)
(* line 1827 "T.pum" *)
       
   IF ~yyP59^.TypeEntry.typeRepr^.TypeRepr.isInTDescList & IsLegalPointerBaseType(yyP59^.TypeEntry.typeRepr) THEN 
      yyP59^.TypeEntry.typeRepr^.TypeRepr.isInTDescList:=TRUE; 
      yyP60^.TDescList.TDescElems:=OB.mTDescElem(yyP60^.TDescList.TDescElems,n,yyP59^.TypeEntry.typeRepr);
      
      IF (yyP59^.TypeEntry.level=OB.MODULELEVEL) & (yyP59^.TypeEntry.typeRepr^.TypeRepr.label=LAB.MT) THEN 
         yyP59^.TypeEntry.typeRepr^.TypeRepr.label:=LAB.NewImplicit(yyP59^.TypeEntry.module^.ModuleEntry.name); 
      END;
   END;
;
      RETURN;

  END;
  END;
 END AppendTDesc;

PROCEDURE DefineTypeReprLabel* (yyP61: OB.tOB; label: tLabel);
 BEGIN
  IF yyP61 = OB.NoOB THEN RETURN; END;
  IF (yyP61^.Kind = OB.TypeEntry) THEN
  IF OB.IsType (yyP61^.TypeEntry.typeRepr, OB.TypeRepr) THEN
(* line 1841 "T.pum" *)
   LOOP
(* line 1855 "T.pum" *)
      IF ~((yyP61^.TypeEntry.typeRepr^.TypeRepr.label = LAB.MT)) THEN EXIT; END;
(* line 1855 "T.pum" *)
      
    yyP61^.TypeEntry.typeRepr^.TypeRepr.label:=label; 
 ;
      RETURN;
   END;

  END;
  END;
 END DefineTypeReprLabel;

PROCEDURE LabelOfTypeRepr* (yyP62: OB.tOB): tLabel;
 BEGIN
  IF OB.IsType (yyP62, OB.TypeRepr) THEN
(* line 1862 "T.pum" *)
(* line 1867 "T.pum" *)
       IF yyP62^.TypeRepr.label=LAB.MT THEN yyP62^.TypeRepr.label:=LAB.NewLocal(); END; ;
      RETURN yyP62^.TypeRepr.label;

  END;
(* line 1869 "T.pum" *)
      RETURN LAB.MT;

 END LabelOfTypeRepr;

PROCEDURE BeginT*;
 BEGIN
 END BeginT;

PROCEDURE CloseT*;
 BEGIN
 END CloseT;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginT;
END T.

