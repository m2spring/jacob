MODULE OT;

IMPORT Base, LREAL, MathLib, RealConv, StringMem, Strings, Strings1, UTI, SYSTEM;

CONST  DBLDIG*           = Base.DBLDIG;                                        (* number of decimal digits of precision       *)
       DBLMAX*           = MAX(LONGREAL);                                       (* maximum value                               *)

       FLTDIG*           = Base.FLTDIG;                                        (* number of decimal digits of precision       *)
       FLTMAX*           = 3.402823466E+37;                                     (* maximum value                               *)

       MaxCharOrd*        = Base.MaxCharOrd;                                     (* We grant 8-Bit ASCII...                     *)
VAR    MinLongintReal*    ,
       MaxLongintReal*    : REAL;
       MinLongintLongreal*,
       MaxLongintLongreal*: LONGREAL;
CONST  MinIllegalAbsInt*  = Base.MinIllegalAbsInt;                               (* = 80000000H in 32 bits                      *)
       MaxObjectSize*     = MAX(LONGINT)-1;                                      (* Maximum size of variables and types         *)
       ObjectTooBigSize*  = MaxObjectSize+1;                                     (* This size flags that an object is too large *)

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  The oberon types
 *)
TYPE   oBYTE*             = SYSTEM.BYTE;
       oPTR*              = SYSTEM.PTR;
       oBOOLEAN*          = BOOLEAN;
       oCHAR*             = CHAR;
       oSTRING*           = StringMem.tStringRef;
       oSHORTINT*         = SHORTINT;
       oINTEGER*          = INTEGER;
       oLONGINT*          = LONGINT;
       oREAL*             = REAL;
       oLONGREAL*         = RECORD v* : LONGREAL; END;
       oSET*              = SET;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  number of storage required by oberon types
 *)
CONST  SIZEoBYTE*         = SIZE(oBYTE);
       SIZEoPTR*          = SIZE(oPTR);
       SIZEoBOOLEAN*      = 1;
       SIZEoCHAR*         = 1;
       SIZEoSHORTINT*     = 1;
       SIZEoINTEGER*      = 2;
       SIZEoLONGINT*      = SIZE(oLONGINT);
       SIZEoSET*          = SIZE(oSET);
       SIZEoREAL*         = SIZE(oREAL);
       SIZEoLONGREAL*     = SIZE(oLONGREAL);
       SIZEoPOINTER*      = SIZE(SYSTEM.PTR);
       SIZEoPROCEDURE*    = SIZE(SYSTEM.PTR);

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  limits of oberon types
 *)
CONST  MINoBOOLEAN*       = FALSE;
       MAXoBOOLEAN*       = TRUE;
       MINoCHAR*          = 0X;
       MAXoCHAR*          = MaxCharOrd;
       MINoSHORTINT*      = -128;
       MAXoSHORTINT*      =  127;
       MINoINTEGER*       = -32768;
       MAXoINTEGER*       =  32767;
       MINoLONGINT*       = MIN(LONGINT);
       MAXoLONGINT*       = MAX(LONGINT);
       MINoSET*           = 0;
       MAXoSET*           = 31;
       MINoREAL*          = -FLTMAX;
       MAXoREAL*          = +FLTMAX;
VAR    MINoLONGREAL*      ,
       MAXoLONGREAL*      : oLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*
 *  special oberon type values
 *)
CONST  NoBoolean*         = FALSE;
       NoChar*            = 0X;
VAR    NoString*          : oSTRING;
CONST  NoShortint*        = 0;
       NoInteger*         = 0;
       NoLongint*         = 0;
       NoSet*             = {};
       NoReal*            = 0.0;
VAR    NoLongreal*        : oLONGREAL;

CONST  EmptySet*          = {};
       AllSet*            = {0..MAXoSET};
VAR    ZeroLongint*       : oLONGINT;

CONST  oNULL*             = 0X;
       oTAB*              = 11;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LONGCARD2oLONGINT*(lc :LONGINT; VAR oi : oLONGINT);
BEGIN (* LONGCARD2oLONGINT *)
 oi:=lc;
END LONGCARD2oLONGINT;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CHAR2oCHAR*(ch : CHAR; VAR oc : oCHAR);
BEGIN (* CHAR2oCHAR *)
 oc:=ch;
END CHAR2oCHAR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE STR2oSTRING*(st : Strings.tString; VAR os : oSTRING);
BEGIN (* STR2oSTRING *)
 os:=StringMem.PutString(st);
END STR2oSTRING;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE HEXSTR2oCHAR*(VAR st : Strings.tString; VAR oc : oCHAR; VAR OK : BOOLEAN);
BEGIN (* HEXSTR2oCHAR *)
 oc:=UTI.HexStr2Char(st,OK);
END HEXSTR2oCHAR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE STR2oREAL*(VAR st : Strings.tString; VAR or : oREAL; VAR OK : BOOLEAN);
BEGIN (* STR2oREAL *)
 or:=SHORT(UTI.Str2Real(st,OK));
END STR2oREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE STR2oLONGREAL*(VAR st : Strings.tString; VAR or : oLONGREAL; VAR OK : BOOLEAN);
BEGIN (* STR2oLONGREAL *)
 or.v:=UTI.Str2Longreal(st,OK);
END STR2oLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CHARofoCHAR*(oc : oCHAR) : CHAR;
BEGIN (* CHARofoCHAR *)
 RETURN oc;
END CHARofoCHAR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LengthOfoSTRING*(os : oSTRING) : oLONGINT;
BEGIN (* LengthOfoSTRING *)
 RETURN StringMem.Length(os);
END LengthOfoSTRING;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LONGREALofoLONGREAL*(ol : oLONGREAL) : LONGREAL;
BEGIN (* LONGREALofoLONGREAL *)
 RETURN ol.v;
END LONGREALofoLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE SplitoLONGREAL*(ol : oLONGREAL; VAR lo, hi : LONGINT); 
TYPE tRetype = RECORD lo,hi:LONGINT; END;
VAR retype : tRetype;
BEGIN (* SplitoLONGREAL *)
 retype:=SYSTEM.VAL(tRetype,ol); 
 lo:=retype.lo; hi:=retype.hi; 
END SplitoLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE SplitoSTRING*(os : oSTRING; VAR li : LONGINT); 
VAR str:Strings.tString; 
    retype : RECORD
              arr:ARRAY Strings.cMaxStrLength+1 OF CHAR;
             END;
BEGIN (* SplitoSTRING *)
 StringMem.GetString(os,str); Strings.StringToArray(str,retype.arr);
 IF    retype.arr[0]=0X THEN retype.arr[3]:=0X; retype.arr[2]:=0X; retype.arr[1]:=0X; 
 ELSIF retype.arr[1]=0X THEN retype.arr[3]:=0X; retype.arr[2]:=0X; 
 ELSIF retype.arr[2]=0X THEN retype.arr[3]:=0X; 
 END; (* IF *)
 li:=SYSTEM.VAL(LONGINT,retype); 
END SplitoSTRING;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ShortenoSTRING*(os:oSTRING; len:LONGINT): oSTRING;
VAR str:Strings.tString; n:Strings.tStringIndex;
BEGIN (* ShortenoSTRING *)
 StringMem.GetString(os,str);
 n:=SHORT(len); 
 IF str.Length>n THEN str.Length:=n; END; (* IF *)
 RETURN StringMem.PutString(str); 
END ShortenoSTRING;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oBOOLEAN2ARR*(ob : oBOOLEAN; VAR st : ARRAY OF CHAR);
BEGIN (* oBOOLEAN2ARR *)
 IF ob
    THEN Strings1.Assign(st,'TRUE');
    ELSE Strings1.Assign(st,'FALSE');
 END; (* IF *)
END oBOOLEAN2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oCHAR2ARR*(oc : oCHAR; VAR st : ARRAY OF CHAR);
VAR
   v :LONGINT; 
   s : ARRAY 21 OF CHAR;
BEGIN (* oCHAR2ARR *)
 v:=ORD(CHARofoCHAR(oc));
 s[0]:="'"; s[2]:="'"; s[3]:=0X;
 CASE v OF
 |ORD("'")          : s[0]:='"'; s[1]:="'"; s[2]:='"';
 |ORD(' ')..ORD('&')
 ,ORD('(')..ORD('~'): s[1]:=CHR(v);
 ELSE                 UTI.Shortcard2ArrHex(v,s);
                      Strings1.Append(s,'X');
 END; (* CASE *)
 Strings1.Assign(st,s);
END oCHAR2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oSTRING2ARR*(s : oSTRING; VAR st : ARRAY OF CHAR);
VAR
   str : Strings.tString;
   c   : ARRAY 2 OF CHAR;
BEGIN (* oSTRING2ARR *)
 StringMem.GetString(s,str);
 Strings.StringToArray(str,st);
 IF Strings1.pos("'",st)>=LEN(st)
    THEN c[0] := "'";
    ELSE c[0] := '"';
 END; (* IF *)
 c[1]:=0X;
 Strings1.Insert(c,st,0);
 Strings1.Append(st,c);
END oSTRING2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oSET2ARR*(os : oSET; VAR st : ARRAY OF CHAR);
VAR
   a, b :LONGINT; 
   f    : BOOLEAN;
   s    : ARRAY 11 OF CHAR;
BEGIN (* oSET2ARR *)
 Strings1.Assign(st,'{'); f:=TRUE;

 a:=MINoSET;
 WHILE a<=MAXoSET DO
  IF a IN os
     THEN b:=a;
          WHILE (b<MAXoSET) & ((b+1) IN os) DO
           INC(b);
          END; (* WHILE *)

          IF ~f THEN Strings1.Append(st,','); ELSE f:=FALSE; END; (* IF *)
          UTI.Shortcard2Arr(a,s);
          Strings1.Append(st,s);
          IF b>a
             THEN UTI.Shortcard2Arr(b,s);
                  Strings1.Append(st,'..');
                  Strings1.Append(st,s);
          END; (* IF *)

          a:=b;
  END; (* IF *)
  INC(a);
 END; (* WHILE *)

 Strings1.Append(st,'}');
END oSET2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLONGINT2ARR*(oi : oLONGINT; VAR st : ARRAY OF CHAR);
BEGIN (* oLONGINT2ARR *)
 UTI.Longint2Arr(oi,st);
END oLONGINT2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oREAL2ARR*(or : oREAL; VAR st : ARRAY OF CHAR);
BEGIN (* oREAL2ARR *)
 UTI.Real2Arr(or,st);
END oREAL2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLONGREAL2ARR*(ol : oLONGREAL; VAR st : ARRAY OF CHAR);
VAR
   p :LONGINT; 
BEGIN (* oLONGREAL2ARR *)
 UTI.Longreal2Arr(ol.v,st);
 p:=Strings1.pos('E',st);
 IF p<LEN(st) THEN st[p]:='D'; END; (* IF *)
END oLONGREAL2ARR;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE EqualoLONGREAL*(arg1, arg2 : oLONGREAL) : BOOLEAN;
BEGIN (* EqualoLONGREAL *)
 RETURN (arg1.v=arg2.v);
END EqualoLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IsLegalSetValue*(val : oLONGINT) : BOOLEAN;
BEGIN (* IsLegalSetValue *)
 RETURN (MINoSET<=val) & (val<=MAXoSET);
END IsLegalSetValue;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ExtendSet*(VAR result : oSET; set : oSET; arg1, arg2 : oLONGINT);
VAR
   i :LONGINT; 
BEGIN (* ExtendSet *)
 result:=set;

 IF    arg1<MINoSET THEN arg1 := MINoSET;
 ELSIF arg1>MAXoSET THEN arg1 := MAXoSET;
 END; (* IF *)
 IF    arg2<MINoSET THEN arg2 := MINoSET;
 ELSIF arg2>MAXoSET THEN arg2 := MAXoSET;
 END; (* IF *)

 FOR i:=arg1 TO arg2 DO
  INCL(result,i);
 END; (* FOR *)
END ExtendSet;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE AreOverlappingCharRanges*(a1, b1, a2, b2 : oCHAR) : BOOLEAN;
BEGIN (* AreOverlappingCharRanges *)
 RETURN (a1 <= b1)
      & (a2 <= b2)
      & (b1 >= a2)
      & (a1 <= b2);
END AreOverlappingCharRanges;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE AreOverlappingIntegerRanges*(a1, b1, a2, b2 : oLONGINT) : BOOLEAN;
BEGIN (* AreOverlappingIntegerRanges *)
 RETURN (a1 <= b1)
      & (a2 <= b2)
      & (b1 >= a2)
      & (a1 <= b2);
END AreOverlappingIntegerRanges;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NewArrayTypeSize*(len : oLONGINT; eSize : LONGINT) : LONGINT;
VAR
   n : LONGINT;
BEGIN (* NewArrayTypeSize *)
 IF (eSize=0) OR (len<1) THEN RETURN 0;                END; (* IF *)
 IF eSize>MaxObjectSize  THEN RETURN ObjectTooBigSize; END; (* IF *)

 (* eSize: [1..MaxObjectSize] , len: [1..MAX(LONGINT)] *)
 n:=len;

 IF n <= MaxObjectSize DIV eSize
    THEN RETURN n*eSize;
    ELSE RETURN ObjectTooBigSize;
 END; (* IF *)
END NewArrayTypeSize;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NewRecordTypeSize*(oSize, fSize : LONGINT) : LONGINT;
BEGIN (* NewRecordTypeSize *)
 IF (oSize>MaxObjectSize) OR (fSize>MaxObjectSize) THEN RETURN ObjectTooBigSize; END; (* IF *)

 (* oSize: [0..MaxObjectSize] , fSize: [0..MaxObjectSize] *)

 IF oSize <= MaxObjectSize-fSize
    THEN RETURN oSize+fSize;
    ELSE RETURN ObjectTooBigSize;
 END; (* IF *)
END NewRecordTypeSize;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oCHAR2oSTRING*(arg : oCHAR; VAR result : oSTRING);
VAR
   a : ARRAY 2 OF CHAR;
   s : Strings.tString;
BEGIN (* oCHAR2oSTRING *)
 a[0]:=arg; a[1]:=0X;
 Strings.ArrayToString(a,s);
 result:=StringMem.PutString(s);
END oCHAR2oSTRING;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLONGINT2oREAL*(arg : oLONGINT; VAR result : oREAL);
BEGIN (* oLONGINT2oREAL *)
 result:=MathLib.real(arg);
END oLONGINT2oREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLONGINT2oLONGREAL*(arg : oLONGINT; VAR result : oLONGREAL);
BEGIN (* oLONGINT2oLONGREAL *)
 result.v:=MathLib.realL(arg);
END oLONGINT2oLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oREAL2oLONGREAL*(arg : oREAL; VAR result : oLONGREAL);
BEGIN (* oREAL2oLONGREAL *)
 result.v:=arg;
END oREAL2oLONGREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE oLONGREAL2oREAL*(arg : oLONGREAL; VAR result : oREAL; VAR OK : BOOLEAN);
BEGIN (* oLONGREAL2oREAL *)
 OK:=(MINoREAL <= arg.v) & (arg.v <= MAXoREAL);
 IF OK THEN result:=SHORT(arg.v); END; (* IF *)
END oLONGREAL2oREAL;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NegateSet*(VAR result : oSET; arg : oSET);
BEGIN (* NegateSet *)
 result:=AllSet-arg;
END NegateSet;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NegateLongint*(VAR result : oLONGINT; arg : oLONGINT; VAR OK : BOOLEAN);
BEGIN (* NegateLongint *)
 OK     := (arg#MINoLONGINT);
 result := -arg;
END NegateLongint;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NegateReal*(VAR result : oREAL; arg : oREAL);
BEGIN (* NegateReal *)
 result:=-arg;
END NegateReal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NegateLongreal*(VAR result : oLONGREAL; arg : oLONGREAL);
BEGIN (* NegateLongreal *)
 result.v:=-arg.v;
END NegateLongreal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NotBoolean*(VAR result : oBOOLEAN; arg : oBOOLEAN);
BEGIN (* NotBoolean *)
 result:=~arg;
END NotBoolean;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE BooleanRelation*(VAR result : oBOOLEAN;
                              arg1   ,
                              arg2   : oBOOLEAN;
                              oper   :INTEGER);
BEGIN (* BooleanRelation *)
 CASE oper OF
 |Base.EqualOper  : result := (arg1 = arg2);
 |Base.UnequalOper: result := (arg1 # arg2);
 ELSE
 END; (* CASE *)
END BooleanRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CharRelation*(VAR result : oBOOLEAN;
                           arg1   ,
                           arg2   : oCHAR;
                           oper   :INTEGER);
BEGIN (* CharRelation *)
 CASE oper OF
 |Base.EqualOper       : result := (arg1 =  arg2);
 |Base.UnequalOper     : result := (arg1 #  arg2);
 |Base.LessOper        : result := (arg1 <  arg2);
 |Base.LessEqualOper   : result := (arg1 <= arg2);
 |Base.GreaterOper     : result := (arg1 >  arg2);
 |Base.GreaterEqualOper: result := (arg1 >= arg2);
 ELSE
 END; (* CASE *)
END CharRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE StringRelation*(VAR result : oBOOLEAN;
                             arg1   ,
                             arg2   : oSTRING;
                             oper   :INTEGER);
VAR
   s1, s2 : Strings.tString;
BEGIN (* StringRelation *)
 StringMem.GetString(arg1,s1); StringMem.GetString(arg2,s2);

 CASE oper OF
 |Base.EqualOper       : result :=  Strings.IsEqual  (s1,s2);
 |Base.UnequalOper     : result := ~Strings.IsEqual  (s1,s2);
 |Base.LessOper        : result := ~Strings.IsInOrder(s2,s1);
 |Base.LessEqualOper   : result :=  Strings.IsInOrder(s1,s2);
 |Base.GreaterOper     : result := ~Strings.IsInOrder(s1,s2);
 |Base.GreaterEqualOper: result :=  Strings.IsInOrder(s2,s1);
 ELSE
 END; (* CASE *)
END StringRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE SetRelation*(VAR result : oBOOLEAN;
                          arg1   ,
                          arg2   : oSET;
                          oper   :INTEGER);
BEGIN (* SetRelation *)
 CASE oper OF
 |Base.EqualOper       : result := (arg1 = arg2);
 |Base.UnequalOper     : result := (arg1 # arg2);
 ELSE
 END; (* CASE *)
END SetRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerRelation*(VAR result : oBOOLEAN;
                              arg1   ,
                              arg2   : oLONGINT;
                              oper   :INTEGER);
BEGIN (* IntegerRelation *)
 CASE oper OF
 |Base.EqualOper       : result := (arg1 =  arg2);
 |Base.UnequalOper     : result := (arg1 #  arg2);
 |Base.LessOper        : result := (arg1 <  arg2);
 |Base.LessEqualOper   : result := (arg1 <= arg2);
 |Base.GreaterOper     : result := (arg1 >  arg2);
 |Base.GreaterEqualOper: result := (arg1 >= arg2);
 ELSE
 END; (* CASE *)
END IntegerRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE RealRelation*(VAR result : oBOOLEAN;
                           arg1   ,
                           arg2   : oREAL;
                           oper   :INTEGER);
BEGIN (* RealRelation *)
 CASE oper OF
 |Base.EqualOper       : result := (arg1 =  arg2);
 |Base.UnequalOper     : result := (arg1 #  arg2);
 |Base.LessOper        : result := (arg1 <  arg2);
 |Base.LessEqualOper   : result := (arg1 <= arg2);
 |Base.GreaterOper     : result := (arg1 >  arg2);
 |Base.GreaterEqualOper: result := (arg1 >= arg2);
 ELSE
 END; (* CASE *)
END RealRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LongrealRelation*(VAR result : oBOOLEAN;
                               arg1   ,
                               arg2   : oLONGREAL;
                               oper   :INTEGER);
BEGIN (* LongrealRelation *)
 CASE oper OF
 |Base.EqualOper       : result := (arg1.v =  arg2.v);
 |Base.UnequalOper     : result := (arg1.v #  arg2.v);
 |Base.LessOper        : result := (arg1.v <  arg2.v);
 |Base.LessEqualOper   : result := (arg1.v <= arg2.v);
 |Base.GreaterOper     : result := (arg1.v >  arg2.v);
 |Base.GreaterEqualOper: result := (arg1.v >= arg2.v);
 ELSE
 END; (* CASE *)
END LongrealRelation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerInSet*(VAR result : oBOOLEAN;
                           arg1   : oLONGINT;
                           arg2   : oSET);
BEGIN (* IntegerInSet *)
 result:=(MINoSET<=arg1) & (arg1<=MAXoSET) & (arg1 IN arg2);
END IntegerInSet;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerOperation*(VAR result : oLONGINT;
                               arg1   ,
                               arg2   : oLONGINT;
                               oper   :INTEGER; 
                           VAR OK     : BOOLEAN);
BEGIN (* IntegerOperation *)
 CASE oper OF
 |Base.PlusOper : OK:=((arg1<0)#(arg2<0))
                      OR ((arg1< 0) & (arg1>=MINoLONGINT-arg2))
                      OR ((arg1>=0) & (arg1<=MAXoLONGINT-arg2));
                  IF OK THEN result:=arg1+arg2; END; (* IF *)

 |Base.MinusOper: OK:=((arg1<0)=(arg2<0))
                      OR ((arg1< 0) & (arg1>=MINoLONGINT+arg2))
                      OR ((arg1>=0) & (arg1<=MAXoLONGINT+arg2));
                  IF OK THEN result:=arg1-arg2; END; (* IF *)

 |Base.MultOper : result:=arg1*arg2;
                  OK:=((arg1=0) & (result=0)) OR (result DIV arg1=arg2);

 |Base.DivOper  : OK:=(arg2>0);
                  IF OK THEN 
		     result := arg1 DIV arg2; 
		     IF (arg1 MOD arg2)<0 THEN DEC(result); END; (* IF *)
                  END; (* IF *)

 |Base.ModOper  : OK:=(arg2>0);
                  IF OK THEN 
		     result := arg1 MOD arg2; 
		     IF result<0 THEN INC(result,arg2); END; (* IF *)
                  END; (* IF *)

 ELSE             OK:=FALSE;
 END; (* CASE *)
END IntegerOperation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE RealOperation*(VAR result : oREAL;
                            arg1   ,
                            arg2   : oREAL;
                            oper   :INTEGER; 
                        VAR OK     : BOOLEAN);
BEGIN (* RealOperation *)
 CASE oper OF
 |Base.PlusOper : OK:=((arg1<0.0)#(arg2<0.0))
                      OR ((arg1< 0.0) & (arg1>=MINoREAL-arg2))
                      OR ((arg1>=0.0) & (arg1<=MAXoREAL-arg2));
                  IF OK THEN result:=arg1+arg2; END; (* IF *)

 |Base.MinusOper: OK:=((arg1<0.0)=(arg2<0.0))
                      OR ((arg1< 0.0) & (arg1>=MINoREAL+arg2))
                      OR ((arg1>=0.0) & (arg1<=MAXoREAL+arg2));
                  IF OK THEN result:=arg1-arg2; END; (* IF *)

 |Base.MultOper : OK:=TRUE; result:=arg1*arg2;

 |Base.RDivOper : OK:=TRUE; result:=arg1/arg2;

 ELSE             OK:=FALSE;
 END; (* CASE *)
END RealOperation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LongrealOperation*(VAR result : oLONGREAL;
                                arg1   ,
                                arg2   : oLONGREAL;
                                oper   :INTEGER; 
                            VAR OK     : BOOLEAN);
BEGIN (* LongrealOperation *)
 CASE oper OF
 |Base.PlusOper : OK:=((arg1.v<0.0)#(arg2.v<0.0))
                      OR ((arg1.v< 0.0) & (arg1.v>=MINoLONGREAL.v-arg2.v))
                      OR ((arg1.v>=0.0) & (arg1.v<=MAXoLONGREAL.v-arg2.v));
                  IF OK THEN result.v:=arg1.v+arg2.v; END; (* IF *)

 |Base.MinusOper: OK:=((arg1.v<0.0)=(arg2.v<0.0))
                      OR ((arg1.v< 0.0) & (arg1.v>=MINoLONGREAL.v+arg2.v))
                      OR ((arg1.v>=0.0) & (arg1.v<=MAXoLONGREAL.v+arg2.v));
                  IF OK THEN result.v:=arg1.v-arg2.v; END; (* IF *)

 |Base.MultOper : OK:=TRUE; result.v:=arg1.v*arg2.v;

 |Base.RDivOper : OK:=TRUE; result.v:=arg1.v/arg2.v;

 ELSE             OK:=FALSE;
 END; (* CASE *)
END LongrealOperation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE SetOperation*(VAR result : oSET;
                           arg1   ,
                           arg2   : oSET;
                           oper   :INTEGER; 
                       VAR OK     : BOOLEAN);
BEGIN (* SetOperation *)
 OK:=TRUE;
 CASE oper OF
 |Base.PlusOper : result := arg1 + arg2;
 |Base.MinusOper: result := arg1 - arg2;
 |Base.MultOper : result := arg1 * arg2;
 |Base.RDivOper : result := arg1 / arg2;
 ELSE             OK     := FALSE;
 END; (* CASE *)
END SetOperation;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerAbs*(VAR result : oLONGINT; arg : oLONGINT; VAR OK : BOOLEAN);
BEGIN (* IntegerAbs *)
 OK:=(arg#MINoLONGINT);
 IF OK THEN result:=ABS(arg); END; (* IF *)
END IntegerAbs;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE RealAbs*(VAR result : oREAL; arg : oREAL; VAR OK : BOOLEAN);
BEGIN (* RealAbs *)
 OK:=TRUE; result:=ABS(arg);
END RealAbs;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LongrealAbs*(VAR result : oLONGREAL; arg : oLONGREAL; VAR OK : BOOLEAN);
BEGIN (* LongrealAbs *)
 OK:=TRUE; result.v:=ABS(arg.v);
END LongrealAbs;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerAsh*(VAR result : oLONGINT; arg1, arg2 : oLONGINT; VAR OK : BOOLEAN);
BEGIN (* IntegerAsh *)
 OK:=FALSE;
 IF arg2>0
    THEN WHILE arg2>0 DO
          IF arg1>MAXoLONGINT DIV 2 THEN RETURN; END; (* IF *)
          arg1:=arg1*2;
          DEC(arg2);
         END; (* WHILE *)
    ELSE WHILE arg2<0 DO
          arg1:=arg1 DIV 2;
          INC(arg2);
         END; (* WHILE *)
 END; (* IF *)
 OK:=TRUE; result:=arg1;
END IntegerAsh;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CharCap*(VAR result : oCHAR; arg : oCHAR);
BEGIN (* CharCap *)
 result:=CAP(arg);
END CharCap;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerChr*(VAR result : oCHAR; arg : oLONGINT; VAR OK : BOOLEAN);
BEGIN (* IntegerChr *)
 OK:=(ORD(MINoCHAR)<=arg) & (arg<=ORD(MAXoCHAR));
 IF OK THEN result:=CHR(arg); END; (* IF *)
END IntegerChr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE RealEntier*(VAR result : oLONGINT;
                         arg    : oREAL;
                     VAR OK     : BOOLEAN);
BEGIN (* RealEntier *)
 OK:=(MinLongintReal<=arg) & (arg<=MaxLongintReal);
 IF OK 
    THEN IF arg >= 0.0
            THEN result:=MathLib.entier(arg); 
            ELSE result:=-MathLib.entier(-arg+1.0)-1; 
         END; (* IF *)
 END; (* IF *)
END RealEntier;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LongrealEntier*(VAR result : oLONGINT;
                             arg    : oLONGREAL;
                         VAR OK     : BOOLEAN);
BEGIN (* LongrealEntier *)
 OK:=(MinLongintLongreal<=arg.v) & (arg.v<=MaxLongintLongreal);
 IF OK THEN result:=MathLib.entierL(arg.v); END; (* IF *)
END LongrealEntier;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IntegerOdd*(VAR result : oBOOLEAN; arg : oLONGINT);
BEGIN (* IntegerOdd *)
 result:=((arg MOD 2)=1);
END IntegerOdd;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE CharOrd*(VAR result : oLONGINT; arg : oCHAR);
BEGIN (* CharOrd *)
 result:=ORD(arg);
END CharOrd;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE InitModule*;
VAR
   s : Strings.tString;
BEGIN (* InitModule *)
 Strings.AssignEmpty(s);

 MinLongintLongreal := LREAL.LFLOAT(MINoLONGINT);
 MaxLongintLongreal := LREAL.LFLOAT(MAXoLONGINT);
 MinLongintReal     := SHORT(MinLongintLongreal);
 MaxLongintReal     := SHORT(MaxLongintLongreal);
 MINoLONGREAL.v     := -DBLMAX;
 MAXoLONGREAL.v     := +DBLMAX;
 NoString           := StringMem.PutString(s);
 NoLongreal.v       := 0.0;
 ZeroLongint        := 0;
END InitModule;

(*------------------------------------------------------------------------------------------------------------------------------*)
BEGIN (* OT *)
 InitModule;
END OT.

