MODULE CO;








IMPORT SYSTEM, System, IO, OB,
(* line 13 "CO.pum" *)
OT        ,
                StringMem ; 


VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;




















































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module CO, routine ');
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

PROCEDURE GetCoercion* (SrcType: OB.tOB; DstType: OB.tOB): OB.tOB;
 BEGIN
  IF DstType = NIL THEN
(* line 18 "CO.pum" *)
      RETURN OB.cmtCoercion       ;

  END;
  IF SrcType = NIL THEN
(* line 19 "CO.pum" *)
      RETURN OB.cmtCoercion       ;

  END;
  IF (SrcType^.Kind = OB.ShortintTypeRepr) THEN
  IF (DstType^.Kind = OB.IntegerTypeRepr) THEN
(* line 20 "CO.pum" *)
      RETURN OB.cShortint2Integer ;

  END;
  IF (DstType^.Kind = OB.LongintTypeRepr) THEN
(* line 21 "CO.pum" *)
      RETURN OB.cShortint2Longint ;

  END;
  IF (DstType^.Kind = OB.RealTypeRepr) THEN
(* line 22 "CO.pum" *)
      RETURN OB.cShortint2Real    ;

  END;
  IF (DstType^.Kind = OB.LongrealTypeRepr) THEN
(* line 23 "CO.pum" *)
      RETURN OB.cShortint2Longreal;

  END;
  END;
  IF (SrcType^.Kind = OB.IntegerTypeRepr) THEN
  IF (DstType^.Kind = OB.LongintTypeRepr) THEN
(* line 24 "CO.pum" *)
      RETURN OB.cInteger2Longint  ;

  END;
  IF (DstType^.Kind = OB.RealTypeRepr) THEN
(* line 25 "CO.pum" *)
      RETURN OB.cInteger2Real     ;

  END;
  IF (DstType^.Kind = OB.LongrealTypeRepr) THEN
(* line 26 "CO.pum" *)
      RETURN OB.cInteger2Longreal ;

  END;
  END;
  IF (SrcType^.Kind = OB.LongintTypeRepr) THEN
  IF (DstType^.Kind = OB.RealTypeRepr) THEN
(* line 27 "CO.pum" *)
      RETURN OB.cLongint2Real     ;

  END;
  IF (DstType^.Kind = OB.LongrealTypeRepr) THEN
(* line 28 "CO.pum" *)
      RETURN OB.cLongint2Longreal ;

  END;
  END;
  IF (SrcType^.Kind = OB.RealTypeRepr) THEN
  IF (DstType^.Kind = OB.LongrealTypeRepr) THEN
(* line 29 "CO.pum" *)
      RETURN OB.cReal2Longreal    ;

  END;
  END;
  IF (SrcType^.Kind = OB.CharStringTypeRepr) THEN
  IF (DstType^.Kind = OB.StringTypeRepr) THEN
(* line 30 "CO.pum" *)
      RETURN OB.cChar2String      ;

  END;
  END;
(* line 31 "CO.pum" *)
      RETURN OB.cmtCoercion       ;

 END GetCoercion;

PROCEDURE DoCoercion* (coerce: OB.tOB; arg: OB.tOB): OB.tOB;
(* line 35 "CO.pum" *)
 VAR result:OB.tOB; vLongint:OT.oLONGINT; vReal:OT.oREAL; vLongreal:OT.oLONGREAL; vChar:OT.oCHAR; vString:OT.oSTRING; 
 BEGIN

  CASE coerce^.Kind OF
  | OB.Shortint2Real:
  IF (arg^.Kind = OB.IntegerValue) THEN
(* line 37 "CO.pum" *)
(* line 37 "CO.pum" *)
       OT.oLONGINT2oREAL(arg^.IntegerValue.v,vReal);
                                                               result:=OB.mRealValue(vReal); ;
      RETURN result;

  END;
  | OB.Integer2Real:
  IF (arg^.Kind = OB.IntegerValue) THEN
(* line 39 "CO.pum" *)
(* line 39 "CO.pum" *)
       OT.oLONGINT2oREAL(arg^.IntegerValue.v,vReal);
                                                               result:=OB.mRealValue(vReal); ;
      RETURN result;

  END;
  | OB.Longint2Real:
  IF (arg^.Kind = OB.IntegerValue) THEN
(* line 41 "CO.pum" *)
(* line 41 "CO.pum" *)
       OT.oLONGINT2oREAL(arg^.IntegerValue.v,vReal);
                                                               result:=OB.mRealValue(vReal); ;
      RETURN result;

  END;
  | OB.Shortint2Longreal:
  IF (arg^.Kind = OB.IntegerValue) THEN
(* line 44 "CO.pum" *)
(* line 44 "CO.pum" *)
       OT.oLONGINT2oLONGREAL(arg^.IntegerValue.v,vLongreal);
                                                               result:=OB.mLongrealValue(vLongreal); ;
      RETURN result;

  END;
  | OB.Integer2Longreal:
  IF (arg^.Kind = OB.IntegerValue) THEN
(* line 46 "CO.pum" *)
(* line 46 "CO.pum" *)
       OT.oLONGINT2oLONGREAL(arg^.IntegerValue.v,vLongreal);
                                                               result:=OB.mLongrealValue(vLongreal); ;
      RETURN result;

  END;
  | OB.Longint2Longreal:
  IF (arg^.Kind = OB.IntegerValue) THEN
(* line 48 "CO.pum" *)
(* line 48 "CO.pum" *)
       OT.oLONGINT2oLONGREAL(arg^.IntegerValue.v,vLongreal);
                                                               result:=OB.mLongrealValue(vLongreal); ;
      RETURN result;

  END;
  | OB.Real2Longreal:
  IF (arg^.Kind = OB.RealValue) THEN
(* line 51 "CO.pum" *)
(* line 51 "CO.pum" *)
       OT.oREAL2oLONGREAL(arg^.RealValue.v,vLongreal);
                                                               result:=OB.mLongrealValue(vLongreal); ;
      RETURN result;

  END;
  | OB.Char2String:
  IF (arg^.Kind = OB.CharValue) THEN
(* line 54 "CO.pum" *)
(* line 54 "CO.pum" *)
       OT.oCHAR2oSTRING(arg^.CharValue.v,vString);
                                                               result:=OB.mStringValue(vString); ;
      RETURN result;

  END;
  ELSE END;

(* line 57 "CO.pum" *)
      RETURN arg;

 END DoCoercion;

PROCEDURE DoRealCoercion* (yyP1: OB.tOB; VAR value: OB.tOB; VAR type: OB.tOB);
(* line 61 "CO.pum" *)
 VAR r:REAL; l:OT.oLONGREAL; 
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN; END;
  IF value = OB.NoOB THEN RETURN; END;
  IF type = OB.NoOB THEN RETURN; END;

  CASE yyP1^.Kind OF
  | OB.Shortint2Real:
  IF (value^.Kind = OB.IntegerValue) THEN
(* line 63 "CO.pum" *)
(* line 65 "CO.pum" *)
       OT.oLONGINT2oREAL    (value^.IntegerValue.v,r); value:=OB.mRealValue    (r); type:=OB.cRealTypeRepr;     ;
      RETURN;

  END;
  | OB.Integer2Real:
  IF (value^.Kind = OB.IntegerValue) THEN
(* line 63 "CO.pum" *)
(* line 65 "CO.pum" *)
       OT.oLONGINT2oREAL    (value^.IntegerValue.v,r); value:=OB.mRealValue    (r); type:=OB.cRealTypeRepr;     ;
      RETURN;

  END;
  | OB.Longint2Real:
  IF (value^.Kind = OB.IntegerValue) THEN
(* line 63 "CO.pum" *)
(* line 65 "CO.pum" *)
       OT.oLONGINT2oREAL    (value^.IntegerValue.v,r); value:=OB.mRealValue    (r); type:=OB.cRealTypeRepr;     ;
      RETURN;

  END;
  | OB.Shortint2Longreal:
  IF (value^.Kind = OB.IntegerValue) THEN
(* line 66 "CO.pum" *)
(* line 68 "CO.pum" *)
       OT.oLONGINT2oLONGREAL(value^.IntegerValue.v,l); value:=OB.mLongrealValue(l); type:=OB.cLongrealTypeRepr; ;
      RETURN;

  END;
  | OB.Integer2Longreal:
  IF (value^.Kind = OB.IntegerValue) THEN
(* line 66 "CO.pum" *)
(* line 68 "CO.pum" *)
       OT.oLONGINT2oLONGREAL(value^.IntegerValue.v,l); value:=OB.mLongrealValue(l); type:=OB.cLongrealTypeRepr; ;
      RETURN;

  END;
  | OB.Longint2Longreal:
  IF (value^.Kind = OB.IntegerValue) THEN
(* line 66 "CO.pum" *)
(* line 68 "CO.pum" *)
       OT.oLONGINT2oLONGREAL(value^.IntegerValue.v,l); value:=OB.mLongrealValue(l); type:=OB.cLongrealTypeRepr; ;
      RETURN;

  END;
  | OB.Real2Longreal:
  IF (value^.Kind = OB.RealValue) THEN
(* line 69 "CO.pum" *)
(* line 69 "CO.pum" *)
       OT.oREAL2oLONGREAL   (value^.RealValue.v,l); value:=OB.mLongrealValue(l); type:=OB.cLongrealTypeRepr; ;
      RETURN;

  END;
  ELSE END;

(* line 70 "CO.pum" *)
      RETURN;

 END DoRealCoercion;

PROCEDURE BeginCO*;
 BEGIN
 END BeginCO;

PROCEDURE CloseCO*;
 BEGIN
 END CloseCO;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginCO;
END CO.

