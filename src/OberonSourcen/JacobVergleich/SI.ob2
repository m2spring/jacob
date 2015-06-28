MODULE SI;








IMPORT SYSTEM, System, IO, OB,POS,
(* line 32 "SI.pum" *)
OT        ,
                T         ,
                V         ; 



        TYPE    tParMode*  = OB.tParMode;
                tAddress*  = OB.tAddress;
                tPosition* = POS.tPosition; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;




















































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module SI, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR, yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE IsExistingSignature* (yyP1: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP1^.Kind = OB.ErrorSignature) THEN
(* line 38 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (yyP1^.Kind = OB.GenericSignature) THEN
(* line 39 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (yyP1^.Kind = OB.Signature) THEN
(* line 40 "SI.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsExistingSignature;

PROCEDURE IsEmptySignature* (yyP2: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP2 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP2^.Kind = OB.ErrorSignature) THEN
(* line 44 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (yyP2^.Kind = OB.mtSignature) THEN
(* line 45 "SI.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsEmptySignature;

PROCEDURE SignatureOfProcType* (yyP3: OB.tOB): OB.tOB;
 BEGIN
  IF OB.IsType (yyP3, OB.ProcedureTypeRepr) THEN
(* line 50 "SI.pum" *)
      RETURN yyP3^.ProcedureTypeRepr.signatureRepr;

  END;
(* line 51 "SI.pum" *)
      RETURN OB.cErrorSignature;

 END SignatureOfProcType;

PROCEDURE ModeOfSignatureParam* (signature: OB.tOB): tParMode;
 BEGIN
  IF (signature^.Kind = OB.Signature) THEN
(* line 56 "SI.pum" *)
      RETURN signature^.Signature.VarEntry^.VarEntry.parMode;

  END;
(* line 68 "SI.pum" *)
      RETURN OB.VALPAR;

 END ModeOfSignatureParam;

PROCEDURE GetModesOfSignatureParam* (yyP4: OB.tOB; VAR yyP7: tParMode; VAR yyP6: tParMode; VAR yyP5: tAddress);
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN; END;
  IF (yyP4^.Kind = OB.Signature) THEN
(* line 73 "SI.pum" *)
      yyP7 := yyP4^.Signature.VarEntry^.VarEntry.parMode;
      yyP6 := yyP4^.Signature.VarEntry^.VarEntry.refMode;
      yyP5 := yyP4^.Signature.VarEntry^.VarEntry.address;
      RETURN;

  END;
(* line 87 "SI.pum" *)
      yyP7 := OB.VALPAR;
      yyP6 := OB.VALPAR;
      yyP5 := 0;
      RETURN;

 END GetModesOfSignatureParam;

PROCEDURE TypeOfSignatureParam* (signature: OB.tOB): OB.tOB;
 BEGIN
  IF (signature^.Kind = OB.Signature) THEN
(* line 92 "SI.pum" *)
      RETURN signature^.Signature.VarEntry^.VarEntry.typeRepr;

  END;
(* line 101 "SI.pum" *)
      RETURN OB.cErrorTypeRepr;

 END TypeOfSignatureParam;

PROCEDURE NextSignature* (signature: OB.tOB): OB.tOB;
 BEGIN
  IF (signature^.Kind = OB.Signature) THEN
(* line 106 "SI.pum" *)
      RETURN signature^.Signature.next;

  END;
(* line 107 "SI.pum" *)
      RETURN OB.cErrorSignature;

 END NextSignature;

PROCEDURE AreMatchingSignatures* (Sa: OB.tOB; Sb: OB.tOB): BOOLEAN;
 BEGIN
  IF Sa = OB.NoOB THEN RETURN FALSE; END;
  IF Sb = OB.NoOB THEN RETURN FALSE; END;
  IF (Sa^.Kind = OB.ErrorSignature) THEN
(* line 112 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (Sb^.Kind = OB.ErrorSignature) THEN
(* line 115 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (Sa^.Kind = OB.mtSignature) THEN
  IF (Sb^.Kind = OB.mtSignature) THEN
(* line 118 "SI.pum" *)
      RETURN TRUE;

  END;
  END;
  IF (Sa^.Kind = OB.Signature) THEN
  IF (Sb^.Kind = OB.Signature) THEN
(* line 121 "SI.pum" *)
(* line 150 "SI.pum" *)
      RETURN T.AreEqualTypes(Sa^.Signature.VarEntry^.VarEntry.typeRepr,Sb^.Signature.VarEntry^.VarEntry.typeRepr)
                                                            & (Sa^.Signature.VarEntry^.VarEntry.parMode=Sb^.Signature.VarEntry^.VarEntry.parMode)
                                                            & AreMatchingSignatures(Sa^.Signature.next,Sb^.Signature.next);
                                                      ;
      RETURN TRUE;

  END;
  END;
  RETURN FALSE;
 END AreMatchingSignatures;

PROCEDURE IsCompatibleParam* (ParMode: tParMode; Tf: OB.tOB; Ta: OB.tOB; Va: OB.tOB): BOOLEAN;
 BEGIN
  IF Tf = OB.NoOB THEN RETURN FALSE; END;
  IF Ta = OB.NoOB THEN RETURN FALSE; END;
  IF Va = OB.NoOB THEN RETURN FALSE; END;
  IF (Ta^.Kind = OB.ErrorTypeRepr) THEN
(* line 162 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (Tf^.Kind = OB.ErrorTypeRepr) THEN
(* line 167 "SI.pum" *)
      RETURN TRUE;

  END;
  IF (yyIsEqual ( ParMode ,   OB . REFPAR ) ) THEN
  IF (Tf^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Tf^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
  IF (Tf^.ArrayTypeRepr.elemTypeRepr^.Kind = OB.ByteTypeRepr) THEN
(* line 172 "SI.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  END;
  IF (yyIsEqual ( ParMode ,   OB.REFPAR ) ) THEN
  IF (Tf^.Kind = OB.ByteTypeRepr) THEN
  IF (Ta^.Kind = OB.CharTypeRepr) THEN
(* line 183 "SI.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  IF (yyIsEqual ( ParMode ,   OB.REFPAR ) ) THEN
  IF (Tf^.Kind = OB.ByteTypeRepr) THEN
  IF (Ta^.Kind = OB.CharStringTypeRepr) THEN
(* line 188 "SI.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  IF (yyIsEqual ( ParMode ,   OB.REFPAR ) ) THEN
  IF (Tf^.Kind = OB.ByteTypeRepr) THEN
  IF (Ta^.Kind = OB.ShortintTypeRepr) THEN
(* line 193 "SI.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  IF (yyIsEqual ( ParMode ,   OB.REFPAR ) ) THEN
  IF (Tf^.Kind = OB.PtrTypeRepr) THEN
  IF (Ta^.Kind = OB.PointerTypeRepr) THEN
(* line 198 "SI.pum" *)
      RETURN TRUE;

  END;
  END;
  END;
  IF (Tf^.Kind = OB.ArrayTypeRepr) THEN
  IF (yyIsEqual ( Tf^.ArrayTypeRepr.len ,   OB.OPENARRAYLEN ) ) THEN
(* line 203 "SI.pum" *)
(* line 212 "SI.pum" *)
       RETURN T.IsArrayCompatible(Tf,Ta) ;
      RETURN TRUE;

  END;
  END;
  IF (yyIsEqual ( ParMode ,   OB.VALPAR ) ) THEN
(* line 214 "SI.pum" *)
(* line 215 "SI.pum" *)
       RETURN T.IsAssignmentCompatible(Tf,Ta,Va) ;
      RETURN TRUE;

  END;
  IF (yyIsEqual ( ParMode ,   OB.REFPAR ) ) THEN
  IF (Tf^.Kind = OB.RecordTypeRepr) THEN
  IF (Ta^.Kind = OB.RecordTypeRepr) THEN
(* line 217 "SI.pum" *)
(* line 220 "SI.pum" *)
       RETURN T.IsExtensionOf(Ta,Tf) ;
      RETURN TRUE;

  END;
  END;
  END;
  IF (yyIsEqual ( ParMode ,   OB.REFPAR ) ) THEN
(* line 222 "SI.pum" *)
(* line 223 "SI.pum" *)
       RETURN T.AreSameTypes(Tf,Ta) ;
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsCompatibleParam;

PROCEDURE BeginSI*;
 BEGIN
 END BeginSI;

PROCEDURE CloseSI*;
 BEGIN
 END CloseSI;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginSI;
END SI.

