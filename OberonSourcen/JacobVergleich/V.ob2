MODULE V;








IMPORT SYSTEM, System, IO, OB,
(* line 77 "V.pum" *)
LAB, Base, LIM, OT, PR, Tree; 

        TYPE   oLONGINT* = OT.oLONGINT ; 
               oSET*     = OT.oSET     ; 
               tLabel*   = OB.tLabel   ; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;




























































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module V, routine ');
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

PROCEDURE IsCalculatableValue* (yyP1: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP1^.Kind = OB.mtValue) THEN
(* line 81 "V.pum" *)
(* line 81 "V.pum" *)
      RETURN FALSE;

  END;
  IF (yyP1^.Kind = OB.ErrorValue) THEN
(* line 82 "V.pum" *)
(* line 82 "V.pum" *)
      RETURN FALSE;

  END;
(* line 83 "V.pum" *)
      RETURN TRUE;

 END IsCalculatableValue;

PROCEDURE IsValidConstValue* (yyP2: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP2 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP2^.Kind = OB.ErrorValue) THEN
(* line 87 "V.pum" *)
      RETURN TRUE;

  END;
  IF OB.IsType (yyP2, OB.ValueRepr) THEN
(* line 88 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsValidConstValue;

PROCEDURE IsErrorValue* (yyP3: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP3 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP3^.Kind = OB.ErrorValue) THEN
(* line 92 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsErrorValue;

PROCEDURE IsFalseValue* (yyP4: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP4^.Kind = OB.BooleanValue) THEN
(* line 96 "V.pum" *)
(* line 96 "V.pum" *)
       RETURN ~yyP4^.BooleanValue.v; ;
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsFalseValue;

PROCEDURE IsTrueValue* (yyP5: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP5 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP5^.Kind = OB.BooleanValue) THEN
(* line 100 "V.pum" *)
(* line 100 "V.pum" *)
       RETURN yyP5^.BooleanValue.v; ;
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsTrueValue;

PROCEDURE IsCharValue* (yyP6: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP6 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP6^.Kind = OB.ErrorValue) THEN
(* line 104 "V.pum" *)
      RETURN TRUE;

  END;
  IF (yyP6^.Kind = OB.CharValue) THEN
(* line 105 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsCharValue;

PROCEDURE IsStringValue* (yyP7: OB.tOB): BOOLEAN;
 BEGIN               
  IF yyP7 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP7^.Kind = OB.ErrorValue) THEN
(* line 109 "V.pum" *)
      RETURN TRUE;

  END;
  IF (yyP7^.Kind = OB.StringValue) THEN
(* line 110 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsStringValue;

PROCEDURE IsIntegerValue* (yyP8: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP8 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP8^.Kind = OB.ErrorValue) THEN
(* line 114 "V.pum" *)
      RETURN TRUE;

  END;
  IF (yyP8^.Kind = OB.IntegerValue) THEN
(* line 115 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsIntegerValue;

PROCEDURE IsLongrealValue* (yyP9: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP9 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP9^.Kind = OB.ErrorValue) THEN
(* line 119 "V.pum" *)
      RETURN TRUE;

  END;
  IF (yyP9^.Kind = OB.LongrealValue) THEN
(* line 120 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsLongrealValue;

PROCEDURE IsNullChar* (yyP10: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP10 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP10^.Kind = OB.CharValue) THEN
(* line 124 "V.pum" *)
(* line 124 "V.pum" *)
       RETURN (yyP10^.CharValue.v = OT.oNULL); ;
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsNullChar;

PROCEDURE IsGreaterZeroInteger* (yyP11: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP11 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP11^.Kind = OB.IntegerValue) THEN
(* line 128 "V.pum" *)
(* line 128 "V.pum" *)
       RETURN (yyP11^.IntegerValue.v > 0); ;
      RETURN TRUE;

  END;
(* line 129 "V.pum" *)
      RETURN TRUE;

 END IsGreaterZeroInteger;

PROCEDURE IsNonZeroInteger* (yyP12: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP12 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP12^.Kind = OB.IntegerValue) THEN
(* line 133 "V.pum" *)
(* line 133 "V.pum" *)
       RETURN (yyP12^.IntegerValue.v # 0); ;
      RETURN TRUE;

  END;
(* line 134 "V.pum" *)
      RETURN TRUE;

 END IsNonZeroInteger;

PROCEDURE IsLegalSetValue* (yyP13: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP13 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP13^.Kind = OB.mtValue) THEN
(* line 138 "V.pum" *)
      RETURN TRUE;

  END;
  IF (yyP13^.Kind = OB.ErrorValue) THEN
(* line 139 "V.pum" *)
      RETURN TRUE;

  END;
  IF (yyP13^.Kind = OB.IntegerValue) THEN
(* line 140 "V.pum" *)
(* line 140 "V.pum" *)
       RETURN OT.IsLegalSetValue(yyP13^.IntegerValue.v); ;
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsLegalSetValue;

PROCEDURE IsLegalArrayIndex* (yyP14: OB.tOB; len: oLONGINT): BOOLEAN;
 BEGIN
  IF yyP14 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP14^.Kind = OB.IntegerValue) THEN
(* line 144 "V.pum" *)
(* line 144 "V.pum" *)
       RETURN ((len=OB.OPENARRAYLEN) OR ((0<=yyP14^.IntegerValue.v) & (yyP14^.IntegerValue.v<len))); ;
      RETURN TRUE;

  END;
(* line 145 "V.pum" *)
      RETURN TRUE;

 END IsLegalArrayIndex;

PROCEDURE ValueOfInteger* (yyP15: OB.tOB): oLONGINT;
 BEGIN
  IF (yyP15^.Kind = OB.IntegerValue) THEN
(* line 149 "V.pum" *)
      RETURN yyP15^.IntegerValue.v;

  END;
(* line 150 "V.pum" *)
      RETURN 0;

 END ValueOfInteger;

PROCEDURE LengthOfString* (yyP16: OB.tOB): oLONGINT;
 BEGIN
  IF (yyP16^.Kind = OB.StringValue) THEN
(* line 154 "V.pum" *)
      RETURN OT.LengthOfoSTRING(yyP16^.StringValue.v);

  END;
(* line 155 "V.pum" *)
      RETURN 0;

 END LengthOfString;

PROCEDURE ExtendSet* (set: OB.tOB; a: OB.tOB; b: OB.tOB; VAR isConst: BOOLEAN): OB.tOB;
(* line 159 "V.pum" *)
 VAR o:OB.tOB; vs:OT.oSET; 
 BEGIN
  IF (set^.Kind = OB.SetValue) THEN
  IF (a^.Kind = OB.IntegerValue) THEN
  IF (b^.Kind = OB.IntegerValue) THEN
(* line 161 "V.pum" *)
(* line 161 "V.pum" *)
       OT.ExtendSet(vs,set^.SetValue.v,a^.IntegerValue.v,b^.IntegerValue.v); o:=OB.mSetValue(vs); ;
      isConst := TRUE;
      RETURN o;

  END;
  END;
  END;
(* line 162 "V.pum" *)
      isConst := FALSE;
      RETURN set;

 END ExtendSet;

PROCEDURE ExtendLabelRange* (labelRange: OB.tOB; value1: OB.tOB; value2: OB.tOB): OB.tOB;
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
 yyR4: RECORD
  yyV1: OB.tOB;
  END;
 yyR5: RECORD
  yyV1: OB.tOB;
  END;
 yyR6: RECORD
  yyV1: OB.tOB;
  END;
 yyR7: RECORD
  yyV1: OB.tOB;
  END;
 yyR8: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (labelRange^.Kind = OB.mtLabelRange) THEN
  IF (value1^.Kind = OB.CharValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 169 "V.pum" *)
       yyTempo.yyR1.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR1.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . CharRange ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . CharRange ; 
      yyTempo.yyR1.yyV1^.CharRange.Next := labelRange;
      yyTempo.yyR1.yyV1^.CharRange.a := value1^.CharValue.v;
      yyTempo.yyR1.yyV1^.CharRange.b := value1^.CharValue.v;
      RETURN yyTempo.yyR1.yyV1;

  END;
  IF (value2^.Kind = OB.CharValue) THEN
(* line 170 "V.pum" *)
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . CharRange ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . CharRange ; 
      yyTempo.yyR2.yyV1^.CharRange.Next := labelRange;
      yyTempo.yyR2.yyV1^.CharRange.a := value1^.CharValue.v;
      yyTempo.yyR2.yyV1^.CharRange.b := value2^.CharValue.v;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  IF (value1^.Kind = OB.IntegerValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 175 "V.pum" *)
       yyTempo.yyR5.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR5.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR5.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerRange ]);  yyTempo.yyR5.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR5.yyV1 ^.Kind :=  OB . IntegerRange ; 
      yyTempo.yyR5.yyV1^.IntegerRange.Next := labelRange;
      yyTempo.yyR5.yyV1^.IntegerRange.a := value1^.IntegerValue.v;
      yyTempo.yyR5.yyV1^.IntegerRange.b := value1^.IntegerValue.v;
      RETURN yyTempo.yyR5.yyV1;

  END;
  IF (value2^.Kind = OB.IntegerValue) THEN
(* line 176 "V.pum" *)
       yyTempo.yyR6.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR6.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR6.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerRange ]);  yyTempo.yyR6.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR6.yyV1 ^.Kind :=  OB . IntegerRange ; 
      yyTempo.yyR6.yyV1^.IntegerRange.Next := labelRange;
      yyTempo.yyR6.yyV1^.IntegerRange.a := value1^.IntegerValue.v;
      yyTempo.yyR6.yyV1^.IntegerRange.b := value2^.IntegerValue.v;
      RETURN yyTempo.yyR6.yyV1;

  END;
  END;
  END;
  IF (labelRange^.Kind = OB.CharRange) THEN
  IF (value1^.Kind = OB.CharValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 172 "V.pum" *)
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . CharRange ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . CharRange ; 
      yyTempo.yyR3.yyV1^.CharRange.Next := labelRange;
      yyTempo.yyR3.yyV1^.CharRange.a := value1^.CharValue.v;
      yyTempo.yyR3.yyV1^.CharRange.b := value1^.CharValue.v;
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF (value2^.Kind = OB.CharValue) THEN
(* line 173 "V.pum" *)
       yyTempo.yyR4.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR4.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR4.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . CharRange ]);  yyTempo.yyR4.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR4.yyV1 ^.Kind :=  OB . CharRange ; 
      yyTempo.yyR4.yyV1^.CharRange.Next := labelRange;
      yyTempo.yyR4.yyV1^.CharRange.a := value1^.CharValue.v;
      yyTempo.yyR4.yyV1^.CharRange.b := value2^.CharValue.v;
      RETURN yyTempo.yyR4.yyV1;

  END;
  END;
  END;
  IF (labelRange^.Kind = OB.IntegerRange) THEN
  IF (value1^.Kind = OB.IntegerValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 178 "V.pum" *)
       yyTempo.yyR7.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR7.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR7.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerRange ]);  yyTempo.yyR7.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR7.yyV1 ^.Kind :=  OB . IntegerRange ; 
      yyTempo.yyR7.yyV1^.IntegerRange.Next := labelRange;
      yyTempo.yyR7.yyV1^.IntegerRange.a := value1^.IntegerValue.v;
      yyTempo.yyR7.yyV1^.IntegerRange.b := value1^.IntegerValue.v;
      RETURN yyTempo.yyR7.yyV1;

  END;
  IF (value2^.Kind = OB.IntegerValue) THEN
(* line 179 "V.pum" *)
       yyTempo.yyR8.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR8.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR8.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerRange ]);  yyTempo.yyR8.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR8.yyV1 ^.Kind :=  OB . IntegerRange ; 
      yyTempo.yyR8.yyV1^.IntegerRange.Next := labelRange;
      yyTempo.yyR8.yyV1^.IntegerRange.a := value1^.IntegerValue.v;
      yyTempo.yyR8.yyV1^.IntegerRange.b := value2^.IntegerValue.v;
      RETURN yyTempo.yyR8.yyV1;

  END;
  END;
  END;
(* line 181 "V.pum" *)
      RETURN labelRange;

 END ExtendLabelRange;

PROCEDURE AreLegalLabelRanges* (value1: OB.tOB; value2: OB.tOB): BOOLEAN;
 BEGIN
  IF value1 = OB.NoOB THEN RETURN FALSE; END;
  IF value2 = OB.NoOB THEN RETURN FALSE; END;
  IF (value1^.Kind = OB.CharValue) THEN
  IF (value2^.Kind = OB.CharValue) THEN
(* line 187 "V.pum" *)
(* line 187 "V.pum" *)
       RETURN (value1^.CharValue.v<=value2^.CharValue.v); ;
      RETURN TRUE;

  END;
  END;
  IF (value1^.Kind = OB.IntegerValue) THEN
  IF (value2^.Kind = OB.IntegerValue) THEN
(* line 188 "V.pum" *)
(* line 188 "V.pum" *)
       RETURN (value1^.IntegerValue.v<=value2^.IntegerValue.v); ;
      RETURN TRUE;

  END;
  END;
(* line 189 "V.pum" *)
      RETURN TRUE;

 END AreLegalLabelRanges;

PROCEDURE IsInLabelRange* (labelRange: OB.tOB; value1: OB.tOB; value2: OB.tOB): BOOLEAN;
 BEGIN
  IF labelRange = OB.NoOB THEN RETURN FALSE; END;
  IF value1 = OB.NoOB THEN RETURN FALSE; END;
  IF value2 = OB.NoOB THEN RETURN FALSE; END;
  IF (labelRange^.Kind = OB.CharRange) THEN
  IF (value1^.Kind = OB.CharValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 196 "V.pum" *)
(* line 196 "V.pum" *)
       RETURN OT.AreOverlappingCharRanges(labelRange^.CharRange.a,labelRange^.CharRange.b,value1^.CharValue.v,value1^.CharValue.v)
                                                                                   OR IsInLabelRange(labelRange^.CharRange.Next,value1,value2); ;
      RETURN TRUE;

  END;
  IF (value2^.Kind = OB.CharValue) THEN
(* line 199 "V.pum" *)
(* line 199 "V.pum" *)
       RETURN OT.AreOverlappingCharRanges(labelRange^.CharRange.a,labelRange^.CharRange.b,value1^.CharValue.v,value2^.CharValue.v)
                                                                                   OR IsInLabelRange(labelRange^.CharRange.Next,value1,value2); ;
      RETURN TRUE;

  END;
  END;
  END;
  IF (labelRange^.Kind = OB.IntegerRange) THEN
  IF (value1^.Kind = OB.IntegerValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 202 "V.pum" *)
(* line 202 "V.pum" *)
       RETURN OT.AreOverlappingIntegerRanges(labelRange^.IntegerRange.a,labelRange^.IntegerRange.b,value1^.IntegerValue.v,value1^.IntegerValue.v)
                                                                                   OR IsInLabelRange(labelRange^.IntegerRange.Next,value1,value2); ;
      RETURN TRUE;

  END;
  IF (value2^.Kind = OB.IntegerValue) THEN
(* line 205 "V.pum" *)
(* line 205 "V.pum" *)
       RETURN OT.AreOverlappingIntegerRanges(labelRange^.IntegerRange.a,labelRange^.IntegerRange.b,value1^.IntegerValue.v,value2^.IntegerValue.v)
                                                                                   OR IsInLabelRange(labelRange^.IntegerRange.Next,value1,value2); ;
      RETURN TRUE;

  END;
  END;
  END;
  RETURN FALSE;
 END IsInLabelRange;

PROCEDURE ExtendLabelLimits* (labelLimit: OB.tOB; value1: OB.tOB; value2: OB.tOB): OB.tOB;
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
 yyR4: RECORD
  yyV1: OB.tOB;
  END;
 END;
 BEGIN
  IF (labelLimit^.Kind = OB.mtLabelRange) THEN
  IF (value1^.Kind = OB.CharValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 211 "V.pum" *)
       yyTempo.yyR1.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR1.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR1.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . CharRange ]);  yyTempo.yyR1.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR1.yyV1 ^.Kind :=  OB . CharRange ; 
      yyTempo.yyR1.yyV1^.CharRange.Next := OB.cmtLabelRange;
      yyTempo.yyR1.yyV1^.CharRange.a := value1^.CharValue.v;
      yyTempo.yyR1.yyV1^.CharRange.b := value1^.CharValue.v;
      RETURN yyTempo.yyR1.yyV1;

  END;
  IF (value2^.Kind = OB.CharValue) THEN
(* line 212 "V.pum" *)
       yyTempo.yyR2.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR2.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR2.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . CharRange ]);  yyTempo.yyR2.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR2.yyV1 ^.Kind :=  OB . CharRange ; 
      yyTempo.yyR2.yyV1^.CharRange.Next := OB.cmtLabelRange;
      yyTempo.yyR2.yyV1^.CharRange.a := value1^.CharValue.v;
      yyTempo.yyR2.yyV1^.CharRange.b := value2^.CharValue.v;
      RETURN yyTempo.yyR2.yyV1;

  END;
  END;
  IF (value1^.Kind = OB.IntegerValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 214 "V.pum" *)
       yyTempo.yyR3.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR3.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR3.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerRange ]);  yyTempo.yyR3.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR3.yyV1 ^.Kind :=  OB . IntegerRange ; 
      yyTempo.yyR3.yyV1^.IntegerRange.Next := OB.cmtLabelRange;
      yyTempo.yyR3.yyV1^.IntegerRange.a := value1^.IntegerValue.v;
      yyTempo.yyR3.yyV1^.IntegerRange.b := value1^.IntegerValue.v;
      RETURN yyTempo.yyR3.yyV1;

  END;
  IF (value2^.Kind = OB.IntegerValue) THEN
(* line 215 "V.pum" *)
       yyTempo.yyR4.yyV1:=SYSTEM.VAL(OB.tOB,OB.yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyTempo.yyR4.yyV1 ) >=SYSTEM.VAL(LONGINT,OB.yyPoolMaxPtr) THEN  yyTempo.yyR4.yyV1  :=  OB .yyAlloc (); END; INC ( OB .yyPoolFreePtr,  OB .yyNodeSize [ OB . IntegerRange ]);  yyTempo.yyR4.yyV1 ^.yyHead.yyMark := 0;  yyTempo.yyR4.yyV1 ^.Kind :=  OB . IntegerRange ; 
      yyTempo.yyR4.yyV1^.IntegerRange.Next := OB.cmtLabelRange;
      yyTempo.yyR4.yyV1^.IntegerRange.a := value1^.IntegerValue.v;
      yyTempo.yyR4.yyV1^.IntegerRange.b := value2^.IntegerValue.v;
      RETURN yyTempo.yyR4.yyV1;

  END;
  END;
  END;
  IF (labelLimit^.Kind = OB.CharRange) THEN
  IF (value1^.Kind = OB.CharValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 217 "V.pum" *)
(* line 218 "V.pum" *)
       IF value1^.CharValue.v<labelLimit^.CharRange.a THEN labelLimit^.CharRange.a:=value1^.CharValue.v; END;
                                                                          IF value1^.CharValue.v>labelLimit^.CharRange.b THEN labelLimit^.CharRange.b:=value1^.CharValue.v; END; ;
      RETURN labelLimit;

  END;
  IF (value2^.Kind = OB.CharValue) THEN
(* line 220 "V.pum" *)
(* line 221 "V.pum" *)
       IF value1^.CharValue.v<labelLimit^.CharRange.a THEN labelLimit^.CharRange.a:=value1^.CharValue.v; END;
                                                                          IF value1^.CharValue.v>labelLimit^.CharRange.b THEN labelLimit^.CharRange.b:=value1^.CharValue.v; END;
                                                                          IF value2^.CharValue.v<labelLimit^.CharRange.a THEN labelLimit^.CharRange.a:=value2^.CharValue.v; END;
                                                                          IF value2^.CharValue.v>labelLimit^.CharRange.b THEN labelLimit^.CharRange.b:=value2^.CharValue.v; END; ;
      RETURN labelLimit;

  END;
  END;
  END;
  IF (labelLimit^.Kind = OB.IntegerRange) THEN
  IF (value1^.Kind = OB.IntegerValue) THEN
  IF (value2^.Kind = OB.mtValue) THEN
(* line 217 "V.pum" *)
(* line 218 "V.pum" *)
       IF value1^.IntegerValue.v<labelLimit^.IntegerRange.a THEN labelLimit^.IntegerRange.a:=value1^.IntegerValue.v; END;
                                                                          IF value1^.IntegerValue.v>labelLimit^.IntegerRange.b THEN labelLimit^.IntegerRange.b:=value1^.IntegerValue.v; END; ;
      RETURN labelLimit;

  END;
  IF (value2^.Kind = OB.IntegerValue) THEN
(* line 220 "V.pum" *)
(* line 221 "V.pum" *)
       IF value1^.IntegerValue.v<labelLimit^.IntegerRange.a THEN labelLimit^.IntegerRange.a:=value1^.IntegerValue.v; END;
                                                                          IF value1^.IntegerValue.v>labelLimit^.IntegerRange.b THEN labelLimit^.IntegerRange.b:=value1^.IntegerValue.v; END;
                                                                          IF value2^.IntegerValue.v<labelLimit^.IntegerRange.a THEN labelLimit^.IntegerRange.a:=value2^.IntegerValue.v; END;
                                                                          IF value2^.IntegerValue.v>labelLimit^.IntegerRange.b THEN labelLimit^.IntegerRange.b:=value2^.IntegerValue.v; END; ;
      RETURN labelLimit;

  END;
  END;
  END;
(* line 226 "V.pum" *)
      RETURN labelLimit;

 END ExtendLabelLimits;

PROCEDURE IsValidLabelRange* (yyP17: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP17 = OB.NoOB THEN RETURN FALSE; END;
  IF (yyP17^.Kind = OB.CharRange) THEN
(* line 230 "V.pum" *)
(* line 231 "V.pum" *)
       RETURN (ORD(yyP17^.CharRange.b)-ORD(yyP17^.CharRange.a) < LIM.MaxCaseLabelRange); ;
      RETURN TRUE;

  END;
  IF (yyP17^.Kind = OB.IntegerRange) THEN
(* line 230 "V.pum" *)
(* line 231 "V.pum" *)
       RETURN ((yyP17^.IntegerRange.b-yyP17^.IntegerRange.a) < LIM.MaxCaseLabelRange); ;
      RETURN TRUE;

  END;
(* line 232 "V.pum" *)
      RETURN TRUE;

 END IsValidLabelRange;

PROCEDURE NegateValue* (yyP18: OB.tOB): OB.tOB;
(* line 236 "V.pum" *)
 VAR o:OB.tOB; vSet:OT.oSET; vLongint:OT.oLONGINT; vReal:OT.oREAL; vLongreal:OT.oLONGREAL; OK:BOOLEAN; 
 BEGIN
  IF (yyP18^.Kind = OB.ErrorValue) THEN
(* line 238 "V.pum" *)
      RETURN OB.cErrorValue;

  END;
  IF (yyP18^.Kind = OB.SetValue) THEN
(* line 239 "V.pum" *)
(* line 239 "V.pum" *)
       OT.NegateSet(vSet,yyP18^.SetValue.v); o:=OB.mSetValue(vSet); ;
      RETURN o;

  END;
  IF (yyP18^.Kind = OB.IntegerValue) THEN
(* line 240 "V.pum" *)
(* line 240 "V.pum" *)
       OT.NegateLongint(vLongint,yyP18^.IntegerValue.v,OK);
                                IF OK THEN o:=OB.mIntegerValue(vLongint); ELSE o:=OB.cErrorValue; END; ;
      RETURN o;

  END;
  IF (yyP18^.Kind = OB.RealValue) THEN
(* line 242 "V.pum" *)
(* line 242 "V.pum" *)
       OT.NegateReal(vReal,yyP18^.RealValue.v); o:=OB.mRealValue(vReal); ;
      RETURN o;

  END;
  IF (yyP18^.Kind = OB.LongrealValue) THEN
(* line 243 "V.pum" *)
(* line 243 "V.pum" *)
       OT.NegateLongreal(vLongreal,yyP18^.LongrealValue.v); o:=OB.mLongrealValue(vLongreal); ;
      RETURN o;

  END;
(* line 244 "V.pum" *)
      RETURN OB.cmtValue;

 END NegateValue;

PROCEDURE NotValue* (yyP19: OB.tOB): OB.tOB;
(* line 248 "V.pum" *)
 VAR o:OB.tOB; vb:OT.oBOOLEAN; 
 BEGIN
  IF (yyP19^.Kind = OB.ErrorValue) THEN
(* line 250 "V.pum" *)
      RETURN OB.cErrorValue;

  END;
  IF (yyP19^.Kind = OB.BooleanValue) THEN
(* line 251 "V.pum" *)
(* line 251 "V.pum" *)
       OT.NotBoolean(vb,yyP19^.BooleanValue.v); o:=OB.mBooleanValue(vb); ;
      RETURN o;

  END;
(* line 252 "V.pum" *)
      RETURN OB.cmtValue;

 END NotValue;

PROCEDURE RelationValue* (arg1: OB.tOB; arg2: OB.tOB; operator:INTEGER): OB.tOB;
(* line 256 "V.pum" *)
 VAR o:OB.tOB; v:OT.oBOOLEAN; 
 BEGIN
  IF (arg1^.Kind = OB.mtValue) THEN
(* line 258 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (arg2^.Kind = OB.mtValue) THEN
(* line 259 "V.pum" *)
      RETURN OB.cmtValue;

  END;

  CASE arg1^.Kind OF
  | OB.BooleanValue:
  IF (arg2^.Kind = OB.BooleanValue) THEN
(* line 261 "V.pum" *)
(* line 261 "V.pum" *)
       OT.BooleanRelation(v,arg1^.BooleanValue.v,arg2^.BooleanValue.v,operator);  o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.CharValue:
  IF (arg2^.Kind = OB.CharValue) THEN
(* line 262 "V.pum" *)
(* line 262 "V.pum" *)
       OT.CharRelation(v,arg1^.CharValue.v,arg2^.CharValue.v,operator);     o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.StringValue:
  IF (arg2^.Kind = OB.StringValue) THEN
(* line 263 "V.pum" *)
(* line 263 "V.pum" *)
       OT.StringRelation(v,arg1^.StringValue.v,arg2^.StringValue.v,operator);   o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.SetValue:
  IF (arg2^.Kind = OB.SetValue) THEN
(* line 264 "V.pum" *)
(* line 264 "V.pum" *)
       OT.SetRelation(v,arg1^.SetValue.v,arg2^.SetValue.v,operator);      o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.IntegerValue:
  IF (arg2^.Kind = OB.IntegerValue) THEN
(* line 265 "V.pum" *)
(* line 265 "V.pum" *)
       OT.IntegerRelation(v,arg1^.IntegerValue.v,arg2^.IntegerValue.v,operator);  o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.RealValue:
  IF (arg2^.Kind = OB.RealValue) THEN
(* line 266 "V.pum" *)
(* line 266 "V.pum" *)
       OT.RealRelation(v,arg1^.RealValue.v,arg2^.RealValue.v,operator);     o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.LongrealValue:
  IF (arg2^.Kind = OB.LongrealValue) THEN
(* line 267 "V.pum" *)
(* line 267 "V.pum" *)
       OT.LongrealRelation(v,arg1^.LongrealValue.v,arg2^.LongrealValue.v,operator); o:=OB.mBooleanValue(v); ;
      RETURN o;

  END;
  | OB.NilValue:
  IF (arg2^.Kind = OB.NilValue) THEN
(* line 268 "V.pum" *)
(* line 268 "V.pum" *)
       IF operator=Tree.EqualOper THEN
                                                            o:=OB.cTrueValue; 
                                                         ELSE 
                                                            o:=OB.cFalseValue; 
                                                         END; ;
      RETURN o;

  END;
  ELSE END;

(* line 273 "V.pum" *)
      RETURN OB.cErrorValue;

 END RelationValue;

PROCEDURE OperationValue* (arg1: OB.tOB; arg2: OB.tOB; operator:INTEGER): OB.tOB;
(* line 277 "V.pum" *)
 VAR o:OB.tOB; vLongint:OT.oLONGINT; vReal:OT.oREAL; vLongreal:OT.oLONGREAL; vSet:OT.oSET; OK:BOOLEAN; 
 BEGIN
  IF (arg1^.Kind = OB.mtValue) THEN
(* line 279 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (arg2^.Kind = OB.mtValue) THEN
(* line 280 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (arg1^.Kind = OB.IntegerValue) THEN
  IF (arg2^.Kind = OB.IntegerValue) THEN
(* line 281 "V.pum" *)
(* line 281 "V.pum" *)
       OT.IntegerOperation(vLongint,arg1^.IntegerValue.v,arg2^.IntegerValue.v,operator,OK);
                                                       IF OK THEN o:=OB.mIntegerValue(vLongint); ELSE o:=OB.cErrorValue; END; ;
      RETURN o;

  END;
  END;
  IF (arg1^.Kind = OB.RealValue) THEN
  IF (arg2^.Kind = OB.RealValue) THEN
(* line 283 "V.pum" *)
(* line 283 "V.pum" *)
       OT.RealOperation(vReal,arg1^.RealValue.v,arg2^.RealValue.v,operator,OK);
                                                         IF OK THEN o:=OB.mRealValue(vReal); ELSE o:=OB.cErrorValue; END; ;
      RETURN o;

  END;
  END;
  IF (arg1^.Kind = OB.LongrealValue) THEN
  IF (arg2^.Kind = OB.LongrealValue) THEN
(* line 285 "V.pum" *)
(* line 285 "V.pum" *)
       OT.LongrealOperation(vLongreal,arg1^.LongrealValue.v,arg2^.LongrealValue.v,operator,OK);
                                                         IF OK THEN o:=OB.mLongrealValue(vLongreal);
                                                               ELSE o:=OB.cErrorValue; END; ;
      RETURN o;

  END;
  END;
  IF (arg1^.Kind = OB.SetValue) THEN
  IF (arg2^.Kind = OB.SetValue) THEN
(* line 288 "V.pum" *)
(* line 288 "V.pum" *)
       OT.SetOperation(vSet,arg1^.SetValue.v,arg2^.SetValue.v,operator,OK); o:=OB.mSetValue(vSet); ;
      RETURN o;

  END;
  END;
(* line 289 "V.pum" *)
      RETURN OB.cErrorValue;

 END OperationValue;

PROCEDURE InValue* (yyP21: OB.tOB; yyP20: OB.tOB): OB.tOB;
(* line 293 "V.pum" *)
 VAR o:OB.tOB; vb:OT.oBOOLEAN; 
 BEGIN
  IF (yyP21^.Kind = OB.mtValue) THEN
(* line 295 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (yyP21^.Kind = OB.IntegerValue) THEN
(* line 296 "V.pum" *)
   LOOP
(* line 296 "V.pum" *)
      IF ~(((yyP21^.IntegerValue.v < 0) OR (OT . MAXoSET < yyP21^.IntegerValue.v))) THEN EXIT; END;
(* line 296 "V.pum" *)
       o:=OB.cFalseValue ;
      RETURN o;
   END;

  IF (yyP20^.Kind = OB.SetValue) THEN
(* line 298 "V.pum" *)
(* line 298 "V.pum" *)
       OT.IntegerInSet(vb,yyP21^.IntegerValue.v,yyP20^.SetValue.v); o:=OB.mBooleanValue(vb); ;
      RETURN o;

  END;
  END;
  IF (yyP20^.Kind = OB.mtValue) THEN
(* line 297 "V.pum" *)
      RETURN OB.cmtValue;

  END;
(* line 299 "V.pum" *)
      RETURN OB.cErrorValue;

 END InValue;

PROCEDURE TypeTestValue* (staticType: OB.tOB; testType: OB.tOB): OB.tOB;
 BEGIN
  IF (staticType^.Kind = OB.RecordTypeRepr) THEN
  IF (testType^.Kind = OB.RecordTypeRepr) THEN
(* line 304 "V.pum" *)
   LOOP
(* line 309 "V.pum" *)
      IF ~((staticType^.RecordTypeRepr.extLevel = testType^.RecordTypeRepr.extLevel)) THEN EXIT; END;
      RETURN OB.cTrueValue;
   END;

  END;
  END;
  IF (staticType^.Kind = OB.PointerTypeRepr) THEN
  IF (staticType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (staticType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
  IF (testType^.Kind = OB.PointerTypeRepr) THEN
  IF (testType^.PointerTypeRepr.baseTypeEntry^.Kind = OB.TypeEntry) THEN
  IF (testType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.Kind = OB.RecordTypeRepr) THEN
(* line 304 "V.pum" *)
   LOOP
(* line 309 "V.pum" *)
      IF ~((staticType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.RecordTypeRepr.extLevel = testType^.PointerTypeRepr.baseTypeEntry^.TypeEntry.typeRepr^.RecordTypeRepr.extLevel)) THEN EXIT; END;
      RETURN OB.cTrueValue;
   END;

  END;
  END;
  END;
  END;
  END;
  END;
(* line 311 "V.pum" *)
      RETURN OB.cmtValue;

 END TypeTestValue;

PROCEDURE OrValue* (v1: OB.tOB; v2: OB.tOB): OB.tOB;
(* line 315 "V.pum" *)
 VAR o:OB.tOB; 
 BEGIN
  IF (v1^.Kind = OB.ErrorValue) THEN
(* line 317 "V.pum" *)
      RETURN v1;

  END;
  IF (v2^.Kind = OB.ErrorValue) THEN
(* line 318 "V.pum" *)
      RETURN v2;

  END;
  IF (v1^.Kind = OB.BooleanValue) THEN
  IF (v2^.Kind = OB.BooleanValue) THEN
(* line 320 "V.pum" *)
(* line 320 "V.pum" *)
       IF v1^.BooleanValue.v THEN o:=v1; ELSE o:=v2; END; ;
      RETURN o;

  END;
(* line 321 "V.pum" *)
(* line 321 "V.pum" *)
       IF v1^.BooleanValue.v THEN o:=v1; ELSE o:=OB.cmtValue; END; ;
      RETURN o;

  END;
(* line 323 "V.pum" *)
      RETURN OB.cmtValue;

 END OrValue;

PROCEDURE AndValue* (v1: OB.tOB; v2: OB.tOB): OB.tOB;
(* line 327 "V.pum" *)
 VAR o:OB.tOB; 
 BEGIN
  IF (v1^.Kind = OB.ErrorValue) THEN
(* line 329 "V.pum" *)
      RETURN v1;

  END;
  IF (v2^.Kind = OB.ErrorValue) THEN
(* line 330 "V.pum" *)
      RETURN v2;

  END;
  IF (v1^.Kind = OB.BooleanValue) THEN
  IF (v2^.Kind = OB.BooleanValue) THEN
(* line 332 "V.pum" *)
(* line 332 "V.pum" *)
       IF ~v1^.BooleanValue.v THEN o:=v1; ELSE o:=v2; END; ;
      RETURN o;

  END;
(* line 333 "V.pum" *)
(* line 333 "V.pum" *)
       IF ~v1^.BooleanValue.v THEN o:=v1; ELSE o:=OB.cmtValue; END; ;
      RETURN o;

  END;
(* line 335 "V.pum" *)
      RETURN OB.cmtValue;

 END AndValue;

PROCEDURE AbsValue* (yyP22: OB.tOB; VAR yyP23: BOOLEAN): OB.tOB;
(* line 339 "V.pum" *)
 VAR o:OB.tOB; vLongint:OT.oLONGINT; vReal:OT.oREAL; vLongreal:OT.oLONGREAL; OK:BOOLEAN; 
 BEGIN
  IF (yyP22^.Kind = OB.mtValue) THEN
(* line 341 "V.pum" *)
      yyP23 := TRUE;
      RETURN OB.cmtValue;

  END;
  IF (yyP22^.Kind = OB.IntegerValue) THEN
(* line 342 "V.pum" *)
(* line 342 "V.pum" *)
       OT.IntegerAbs(vLongint,yyP22^.IntegerValue.v,OK);
                                          IF OK THEN o:=OB.mIntegerValue(vLongint); ELSE o:=OB.cErrorValue; END; ;
      yyP23 := OK;
      RETURN o;

  END;
  IF (yyP22^.Kind = OB.RealValue) THEN
(* line 344 "V.pum" *)
(* line 344 "V.pum" *)
       OT.RealAbs(vReal,yyP22^.RealValue.v,OK);
                                          IF OK THEN o:=OB.mRealValue(vReal); ELSE o:=OB.cErrorValue; END; ;
      yyP23 := OK;
      RETURN o;

  END;
  IF (yyP22^.Kind = OB.LongrealValue) THEN
(* line 346 "V.pum" *)
(* line 346 "V.pum" *)
       OT.LongrealAbs(vLongreal,yyP22^.LongrealValue.v,OK);
                                          IF OK THEN o:=OB.mLongrealValue(vLongreal); ELSE o:=OB.cErrorValue; END; ;
      yyP23 := OK;
      RETURN o;

  END;
(* line 348 "V.pum" *)
      yyP23 := TRUE;
      RETURN OB.cErrorValue;

 END AbsValue;

PROCEDURE AshValue* (yyP25: OB.tOB; yyP24: OB.tOB; VAR yyP26: BOOLEAN): OB.tOB;
(* line 352 "V.pum" *)
 VAR o:OB.tOB; vLongint:OT.oLONGINT; OK:BOOLEAN; 
 BEGIN
  IF (yyP25^.Kind = OB.mtValue) THEN
(* line 354 "V.pum" *)
      yyP26 := TRUE;
      RETURN OB.cmtValue;

  END;
  IF (yyP24^.Kind = OB.mtValue) THEN
(* line 355 "V.pum" *)
      yyP26 := TRUE;
      RETURN OB.cmtValue;

  END;
  IF (yyP25^.Kind = OB.IntegerValue) THEN
  IF (yyP24^.Kind = OB.IntegerValue) THEN
(* line 356 "V.pum" *)
(* line 356 "V.pum" *)
       OT.IntegerAsh(vLongint,yyP25^.IntegerValue.v,yyP24^.IntegerValue.v,OK);
                                                             IF OK THEN o:=OB.mIntegerValue(vLongint);
                                                                   ELSE o:=OB.cErrorValue; END; ;
      yyP26 := OK;
      RETURN o;

  END;
  END;
(* line 359 "V.pum" *)
      yyP26 := TRUE;
      RETURN OB.cErrorValue;

 END AshValue;

PROCEDURE CapValue* (yyP27: OB.tOB): OB.tOB;
(* line 363 "V.pum" *)
 VAR o:OB.tOB; vChar:OT.oCHAR; 
 BEGIN
  IF (yyP27^.Kind = OB.mtValue) THEN
(* line 365 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (yyP27^.Kind = OB.CharValue) THEN
(* line 366 "V.pum" *)
(* line 366 "V.pum" *)
       OT.CharCap(vChar,yyP27^.CharValue.v); o:=OB.mCharValue(vChar); ;
      RETURN o;

  END;
(* line 367 "V.pum" *)
      RETURN OB.cErrorValue;

 END CapValue;

PROCEDURE ChrValue* (yyP28: OB.tOB; VAR yyP29: BOOLEAN): OB.tOB;
(* line 371 "V.pum" *)
 VAR o:OB.tOB; vChar:OT.oCHAR; OK:BOOLEAN; 
 BEGIN
  IF (yyP28^.Kind = OB.mtValue) THEN
(* line 373 "V.pum" *)
      yyP29 := TRUE;
      RETURN OB.cmtValue;

  END;
  IF (yyP28^.Kind = OB.IntegerValue) THEN
(* line 374 "V.pum" *)
(* line 374 "V.pum" *)
       OT.IntegerChr(vChar,yyP28^.IntegerValue.v,OK);
                                      IF OK THEN o:=OB.mCharValue(vChar); ELSE o:=OB.cErrorValue; END; ;
      yyP29 := OK;
      RETURN o;

  END;
(* line 376 "V.pum" *)
      yyP29 := TRUE;
      RETURN OB.cErrorValue;

 END ChrValue;

PROCEDURE EntierValue* (yyP30: OB.tOB; VAR yyP31: BOOLEAN): OB.tOB;
(* line 380 "V.pum" *)
 VAR o:OB.tOB; vLongint:OT.oLONGINT; OK:BOOLEAN; 
 BEGIN
  IF (yyP30^.Kind = OB.mtValue) THEN
(* line 382 "V.pum" *)
      yyP31 := TRUE;
      RETURN OB.cmtValue;

  END;
  IF (yyP30^.Kind = OB.RealValue) THEN
(* line 383 "V.pum" *)
(* line 383 "V.pum" *)
       OT.RealEntier(vLongint,yyP30^.RealValue.v,OK);
                                          IF OK THEN o:=OB.mIntegerValue(vLongint); ELSE o := OB.cErrorValue; END; ;
      yyP31 := OK;
      RETURN o;

  END;
  IF (yyP30^.Kind = OB.LongrealValue) THEN
(* line 385 "V.pum" *)
(* line 385 "V.pum" *)
       OT.LongrealEntier(vLongint,yyP30^.LongrealValue.v,OK);
                                          IF OK THEN o:=OB.mIntegerValue(vLongint); ELSE o := OB.cErrorValue; END; ;
      yyP31 := OK;
      RETURN o;

  END;
(* line 387 "V.pum" *)
      yyP31 := TRUE;
      RETURN OB.cErrorValue;

 END EntierValue;

PROCEDURE LongValue* (yyP32: OB.tOB): OB.tOB;
(* line 391 "V.pum" *)
 VAR o:OB.tOB; vLongreal:OT.oLONGREAL; 
 BEGIN
  IF (yyP32^.Kind = OB.mtValue) THEN
(* line 393 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (yyP32^.Kind = OB.IntegerValue) THEN
(* line 394 "V.pum" *)
(* line 394 "V.pum" *)
       o := OB.mIntegerValue(yyP32^.IntegerValue.v); ;
      RETURN o;

  END;
  IF (yyP32^.Kind = OB.RealValue) THEN
(* line 395 "V.pum" *)
(* line 395 "V.pum" *)
       OT.oREAL2oLONGREAL(yyP32^.RealValue.v,vLongreal); o:=OB.mLongrealValue(vLongreal); ;
      RETURN o;

  END;
(* line 396 "V.pum" *)
      RETURN OB.cErrorValue;

 END LongValue;

PROCEDURE MaxValue* (yyP33: OB.tOB): OB.tOB;
 BEGIN

  CASE yyP33^.Kind OF
  | OB.BooleanTypeRepr:
(* line 401 "V.pum" *)
      RETURN OB.mBooleanValue (OT.MAXoBOOLEAN );

  | OB.CharTypeRepr:
(* line 402 "V.pum" *)
      RETURN OB.mCharValue    (OT.MAXoCHAR    );

  | OB.ShortintTypeRepr:
(* line 403 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MAXoSHORTINT);

  | OB.IntegerTypeRepr:
(* line 404 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MAXoINTEGER );

  | OB.LongintTypeRepr:
(* line 405 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MAXoLONGINT );

  | OB.RealTypeRepr:
(* line 406 "V.pum" *)
      RETURN OB.mRealValue    (OT.MAXoREAL    );

  | OB.LongrealTypeRepr:
(* line 407 "V.pum" *)
      RETURN OB.mLongrealValue(OT.MAXoLONGREAL);

  | OB.SetTypeRepr:
(* line 408 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MAXoSET     );

  ELSE END;

(* line 409 "V.pum" *)
      RETURN OB.cErrorValue                    ;

 END MaxValue;

PROCEDURE MinValue* (yyP34: OB.tOB): OB.tOB;
 BEGIN

  CASE yyP34^.Kind OF
  | OB.BooleanTypeRepr:
(* line 414 "V.pum" *)
      RETURN OB.mBooleanValue (OT.MINoBOOLEAN );

  | OB.CharTypeRepr:
(* line 415 "V.pum" *)
      RETURN OB.mCharValue    (OT.MINoCHAR    );

  | OB.ShortintTypeRepr:
(* line 416 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MINoSHORTINT);

  | OB.IntegerTypeRepr:
(* line 417 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MINoINTEGER );

  | OB.LongintTypeRepr:
(* line 418 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MINoLONGINT );

  | OB.RealTypeRepr:
(* line 419 "V.pum" *)
      RETURN OB.mRealValue    (OT.MINoREAL    );

  | OB.LongrealTypeRepr:
(* line 420 "V.pum" *)
      RETURN OB.mLongrealValue(OT.MINoLONGREAL);

  | OB.SetTypeRepr:
(* line 421 "V.pum" *)
      RETURN OB.mIntegerValue (OT.MINoSET     );

  ELSE END;

(* line 422 "V.pum" *)
      RETURN OB.cErrorValue                    ;

 END MinValue;

PROCEDURE OddValue* (yyP35: OB.tOB): OB.tOB;
(* line 426 "V.pum" *)
 VAR o:OB.tOB; vBoolean:OT.oBOOLEAN; 
 BEGIN
  IF (yyP35^.Kind = OB.mtValue) THEN
(* line 428 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (yyP35^.Kind = OB.IntegerValue) THEN
(* line 429 "V.pum" *)
(* line 429 "V.pum" *)
       OT.IntegerOdd(vBoolean,yyP35^.IntegerValue.v); o:=OB.mBooleanValue(vBoolean); ;
      RETURN o;

  END;
(* line 430 "V.pum" *)
      RETURN OB.cErrorValue;

 END OddValue;

PROCEDURE OrdValue* (yyP36: OB.tOB): OB.tOB;
(* line 434 "V.pum" *)
 VAR o:OB.tOB; vLongint:OT.oLONGINT; 
 BEGIN
  IF (yyP36^.Kind = OB.mtValue) THEN
(* line 436 "V.pum" *)
      RETURN OB.cmtValue;

  END;
  IF (yyP36^.Kind = OB.CharValue) THEN
(* line 437 "V.pum" *)
(* line 437 "V.pum" *)
       OT.CharOrd(vLongint,yyP36^.CharValue.v); o:=OB.mIntegerValue(vLongint); ;
      RETURN o;

  END;
(* line 438 "V.pum" *)
      RETURN OB.cErrorValue;

 END OrdValue;

PROCEDURE ShortValue* (yyP38: OB.tOB; yyP37: OB.tOB; VAR yyP39: BOOLEAN): OB.tOB;
(* line 442 "V.pum" *)
 VAR o:OB.tOB; vReal:OT.oREAL; OK:BOOLEAN; 
 BEGIN
  IF (yyP37^.Kind = OB.mtValue) THEN
(* line 444 "V.pum" *)
      yyP39 := TRUE;
      RETURN OB.cmtValue;

  END;
  IF (yyP38^.Kind = OB.IntegerTypeRepr) THEN
  IF (yyP37^.Kind = OB.IntegerValue) THEN
(* line 445 "V.pum" *)
(* line 445 "V.pum" *)
       OK:=(OT.MINoSHORTINT<=yyP37^.IntegerValue.v) & (yyP37^.IntegerValue.v<=OT.MAXoSHORTINT);
                                                           IF OK THEN o:=OB.mIntegerValue(yyP37^.IntegerValue.v); ELSE o:=OB.cErrorValue; END; ;
      yyP39 := OK;
      RETURN o;

  END;
  END;
  IF (yyP38^.Kind = OB.LongintTypeRepr) THEN
  IF (yyP37^.Kind = OB.IntegerValue) THEN
(* line 447 "V.pum" *)
(* line 447 "V.pum" *)
       OK:=(OT.MINoINTEGER<=yyP37^.IntegerValue.v) & (yyP37^.IntegerValue.v<=OT.MAXoINTEGER);
                                                           IF OK THEN o:=OB.mIntegerValue(yyP37^.IntegerValue.v); ELSE o:=OB.cErrorValue; END; ;
      yyP39 := OK;
      RETURN o;

  END;
  END;
  IF (yyP37^.Kind = OB.LongrealValue) THEN
(* line 449 "V.pum" *)
(* line 449 "V.pum" *)
       OT.oLONGREAL2oREAL(yyP37^.LongrealValue.v,vReal,OK);
                                                           IF OK THEN o:=OB.mRealValue(vReal); ELSE o:=OB.cErrorValue; END; ;
      yyP39 := OK;
      RETURN o;

  END;
(* line 451 "V.pum" *)
      yyP39 := TRUE;
      RETURN OB.cErrorValue;

 END ShortValue;

PROCEDURE SizeValue* (t: OB.tOB): OB.tOB;
(* line 455 "V.pum" *)
 VAR o:OB.tOB; vLongint:OT.oLONGINT; size:LONGINT; 
 BEGIN
(* line 457 "V.pum" *)
(* line 457 "V.pum" *)
       size:=Base.SizeOfType(t);
                 IF size<=OT.MaxObjectSize
                    THEN OT.LONGCARD2oLONGINT(size,vLongint);
                         o := OB.mIntegerValue(vLongint);
                    ELSE o := OB.cmtValue;
                 END; ;
      RETURN o;

 END SizeValue;

PROCEDURE AdjustNilValue* (val: OB.tOB; yyP40: OB.tOB; VAR yyP41: OB.tOB);
 BEGIN
  IF val = OB.NoOB THEN RETURN; END;
  IF yyP40 = OB.NoOB THEN RETURN; END;
  IF (val^.Kind = OB.NilValue) THEN
  IF (yyP40^.Kind = OB.PtrTypeRepr) THEN
(* line 467 "V.pum" *)
      yyP41 := OB.cNilPointerValue  ;
      RETURN;

  END;
  IF (yyP40^.Kind = OB.PointerTypeRepr) THEN
(* line 468 "V.pum" *)
      yyP41 := OB.cNilPointerValue  ;
      RETURN;

  END;
  IF OB.IsType (yyP40, OB.ProcedureTypeRepr) THEN
(* line 469 "V.pum" *)
      yyP41 := OB.cNilProcedureValue;
      RETURN;

  END;
  END;
(* line 471 "V.pum" *)
      yyP41 := val;
      RETURN;

 END AdjustNilValue;

PROCEDURE LabelOfMemValue* (yyP42: OB.tOB): tLabel;
 BEGIN
  IF (yyP42^.Kind = OB.StringValue) THEN
(* line 476 "V.pum" *)
      RETURN LAB.String  (yyP42^.StringValue.v);

  END;
  IF (yyP42^.Kind = OB.RealValue) THEN
(* line 477 "V.pum" *)
      RETURN LAB.Real    (yyP42^.RealValue.v);

  END;
  IF (yyP42^.Kind = OB.LongrealValue) THEN
(* line 478 "V.pum" *)
      RETURN LAB.Longreal(yyP42^.LongrealValue.v);

  END;
  yyAbort ('LabelOfMemValue');
 END LabelOfMemValue;

PROCEDURE IsMemValue* (yyP43: OB.tOB): BOOLEAN;
 BEGIN
  IF yyP43 = OB.NoOB THEN RETURN FALSE; END;
  IF OB.IsType (yyP43, OB.MemValueRepr) THEN
(* line 483 "V.pum" *)
      RETURN TRUE;

  END;
  RETURN FALSE;
 END IsMemValue;

PROCEDURE BeginV*;
 BEGIN
 END BeginV;

PROCEDURE CloseV*;
 BEGIN
 END CloseV;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginV;
END V.

