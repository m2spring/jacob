MODULE IR;

IMPORT InOut,BETO,Storage,ConsBase,
SYSTEM,ASMOP,Idents,LAB,ASM,Target,OT,Strings; 
(*++++++ start insertion IpTestImport ++++++*)

(*------ end   insertion IpTestImport ------*)
(******* empty insertion IpInOut *******)

(******* empty insertion IpIRConsStorage *******)
 (******* empty insertion IpTypes *******)
(*++++++ start insertion IpIR_i ++++++*)

(*------ end   insertion IpIR_i ------*)

 
 CONST    MaxArity*        = 4;
          MaxScratch*      = 1;
 
 TYPE     OpCode* = INTEGER;
 CONST    NoOpCode*                            = 0;
          opGlobalVariable*                    = 1;
          opLocalVariable*                     = 2;
          opSelector*                          = 3;
          opIndex*                             = 4;
          opPointerFrom*                       = 5;
          opSimpleAssignment*                  = 6;
          opMemCopy*                           = 7;
          opShortConstStrCopy*                 = 8;
          opStrCopy*                           = 9;
          opStrCopyArguments*                  = 10;
          opImplicifyConst*                    = 11;
          opImplicifyOpenIndexed*              = 12;
          opImplicify*                         = 13;
          opMemSet3*                           = 14;
          opMemSet8*                           = 15;
          opContentOf*                         = 16;
          opAddressOf*                         = 17;
          opNoParam*                           = 18;
          opParam*                             = 19;
          opParam0*                            = 20;
          opParam8*                            = 21;
          opParam_AddrAndTag*                  = 22;
          opParam_LensAndAddr*                 = 23;
          opParam_LensAndNewNofElemsAndAddr*   = 24;
          opParam_Lens*                        = 25;
          opParam_LensAndNewNofElems*          = 26;
          opParam_RecordSizeAndAddr*           = 27;
          opParam_OArrSizeAndAddr*             = 28;
          opParam_PartialOArrSizeAndAddrOfPar* = 29;
          opParam_PartialOArrSizeAndAddrOfPtr* = 30;
          opDirectCall*                        = 31;
          opIndirectCall*                      = 32;
          opBoundCall_FPtr_APtr*               = 33;
          opBoundCall_FRec_APtr*               = 34;
          opBoundCall_FRec_ARec*               = 35;
          opProcReturn*                        = 36;
          opFuncReturn*                        = 37;
          opNoFuncResult*                      = 38;
          opFuncResultOf*                      = 39;
          opCaseExpr*                          = 40;
          opForStmt*                           = 41;
          opMonOper*                           = 42;
          opSymDyOper*                         = 43;
          opSub*                               = 44;
          opDiv*                               = 45;
          opMod*                               = 46;
          opDifference*                        = 47;
          opSetExtendByElem*                   = 48;
          opSetExtendByRange*                  = 49;
          opNoBoolVal*                         = 50;
          opBoolVal*                           = 51;
          opNot*                               = 52;
          opAnd*                               = 53;
          opOr*                                = 54;
          opConstBranch*                       = 55;
          opBranch*                            = 56;
          opLabelDef*                          = 57;
          opFlag*                              = 58;
          opCompare*                           = 59;
          opStringCompare*                     = 60;
          opConstStringCompare*                = 61;
          opIn*                                = 62;
          opIs*                                = 63;
          opOdd*                               = 64;
          opBit*                               = 65;
          opCc*                                = 66;
          opAbs*                               = 67;
          opAsh*                               = 68;
          opCap*                               = 69;
          opIncOrDec*                          = 70;
          opExcl*                              = 71;
          opIncl*                              = 72;
          opShiftOrRotate*                     = 73;
          opStaticNew*                         = 74;
          opOpenNew*                           = 75;
          opLenCheck*                          = 76;
          opSystemNew*                         = 77;
          opGetreg*                            = 78;
          opPutreg*                            = 79;
          opMove*                              = 80;
          opData2Retype*                       = 81;
          opAddr2Retype*                       = 82;
          opRetype2Data*                       = 83;
          opRetype2Float*                      = 84;
          opRetype2Addr*                       = 85;
          opInt2Shortint*                      = 86;
          opInt2Integer*                       = 87;
          opInt2Longint*                       = 88;
          opCard2Shortint*                     = 89;
          opCard2Integer*                      = 90;
          opCard2Longint*                      = 91;
          opCharConst*                         = 92;
          opBooleanConst*                      = 93;
          opShortintConst*                     = 94;
          opIntegerConst*                      = 95;
          opLongintConst*                      = 96;
          opIntConst*                          = 97;
          opRealConst*                         = 98;
          opSetConst*                          = 99;
          opRecordGuard*                       = 100;
          opPointerGuard*                      = 101;
          opSimpleGuard*                       = 102;
          opIndexCheck*                        = 103;
          opNilCheck*                          = 104;
          opMinIntCheck*                       = 105;
          opChrRangeCheck*                     = 106;
          opShortRangeCheck*                   = 107;
          opOpenIndexStartLocal*               = 108;
          opOpenIndexStart*                    = 109;
          opOpenIndexPush*                     = 110;
          opOpenIndexStaticBase*               = 111;
          opOpenIndexOpenBase*                 = 112;
          opOpenIndexPop*                      = 113;
          opOpenIndexApplication*              = 114;
          opHeapOpenIndexApplication*          = 115;
          opConjureRegister*                   = 116;
          opFloatAssignment*                   = 117;
          opFloatContentOf*                    = 118;
          opFloatParam*                        = 119;
          opFloatFuncReturn*                   = 120;
          opFloatFuncResultOf*                 = 121;
          opFloatNegate*                       = 122;
          opFloatSymDyOper*                    = 123;
          opFloatDyOper*                       = 124;
          opFloatCompare*                      = 125;
          opEntier*                            = 126;
          opInt2Float*                         = 127;
          opCard2Float*                        = 128;
          opReal2Longreal*                     = 129;
          opLongreal2Real*                     = 130;
          MAX_OpCode*                          = opLongreal2Real;

TYPE 
        Expression* = POINTER TO ExpressionRecord;
        Attributes* = POINTER TO AttributesRecord;
        ExprAttributes*  =  POINTER TO ExprAttrRec;

 CONST 
     MaxPscArity* = 5;

 TYPE     

   NonTerminal* = SHORTINT;
CONST 
      ntBReg*         = 0;
      ntWReg*         = 1;
      ntLReg*         = 2;
      ntReg*          = 3;
      ntFXReg*        = 4;
      ntFYReg*        = 5;
      ntConstant*     = 6;
      ntGv*           = 7;
      ntIreg*         = 8;
      ntBreg*         = 9;
      ntBregIreg*     = 10;
      ntMemory*       = 11;
      ntLab*          = 12;
      ntCond*         = 13;
      ntBool*         = 14;
      ntReducedStack* = 15;
      ntStrCopyArgs*  = 16;
      ntArgs*         = 17;
      ntRetyp*        = 18;
      ntAMem*         = 19;
      ntAReg*         = 20;
      ntAImm*         = 21;
      ntAMemAReg*     = 22;
      ntAMemAImm*     = 23;
      ntARegAImm*     = 24;
      ntAMemARegAImm* = 25;
      ntAVar*         = 26;
      MAX_NonTerminal* =ntAVar;      

TYPE 
   Register*    = ConsBase.BegRegister;
   
TYPE RegisterSet* = ARRAY 1 OF SET;

 TYPE

   Rule*        = INTEGER;
CONST 
   MAX_Rule*    = 361;

 TYPE  Cost* = INTEGER;
 CONST infcost* = MAX(Cost) DIV 10;

 TYPE
   CostArray*   =      ARRAY MAX_NonTerminal+1 OF Cost;

 
        ExpressionRecord* = 
           RECORD
              attr*             : Attributes;
              son*              : ARRAY MaxArity+1 OF Expression;
              arity*            :SHORTINT; 
              gcg*              : ExprAttributes;
              hashchain*        : Expression;
           END;

 
        AttributesRecord* = 
           RECORD
              op*        :  OpCode;
 
              GlobalVariable* : RECORD  
                      label*  :  LAB.T;
                      adr*  :  LONGINT;
                      cmtIdent*  :  Idents.tIdent;
                 END;
              LocalVariable* : RECORD  
                      adr*  :  LONGINT;
                      cmtIdent*  :  Idents.tIdent;
                 END;
              Selector* : RECORD  
                      ofs*  :  LONGINT;
                 END;
              Index* : RECORD  
                      factor*  :  LONGINT;
                 END;
              PointerFrom* : RECORD  
                 END;
              SimpleAssignment* : RECORD  
                 END;
              MemCopy* : RECORD  
                      len*  :  LONGINT;
                      isStringCopy*  :  BOOLEAN;
                 END;
              ShortConstStrCopy* : RECORD  
                      strVal*  :  LONGINT;
                      len*  :  LONGINT;
                 END;
              StrCopy* : RECORD  
                 END;
              StrCopyArguments* : RECORD  
                 END;
              ImplicifyConst*: RECORD  
                      len*:  LONGINT;
                 END;
              ImplicifyOpenIndexed*: RECORD  
                      lenOfs*:  LONGINT;
                      isStackObject*:  BOOLEAN;
                      objOfs*:  LONGINT;
                 END;
              Implicify*: RECORD  
                      lenOfs*:  LONGINT;
                      isStackObject*:  BOOLEAN;
                      objOfs*:  LONGINT;
                 END;
              MemSet3*: RECORD  
                      v*:  LONGINT;
                 END;
              MemSet8*: RECORD  
                      lrLo*:  LONGINT;
                      lrHi*:  LONGINT;
                 END;
              ContentOf*: RECORD  
                      size*:  ConsBase.tSize;
                 END;
              AddressOf*: RECORD  
                 END;
              NoParam*: RECORD  
                 END;
              Param*: RECORD  
                 END;
              Param0*: RECORD  
                 END;
              Param8*: RECORD  
                      lrLo*:  LONGINT;
                      lrHi*:  LONGINT;
                 END;
              Param_AddrAndTag*: RECORD  
                 END;
              Param_LensAndAddr*: RECORD  
                      nofOpenLens*:  LONGINT;
                 END;
              Param_LensAndNewNofElemsAndAddr*: RECORD  
                      nofOpenLens*:  LONGINT;
                      baseNofElems*:  LONGINT;
                 END;
              Param_Lens*: RECORD  
                      nofOpenLens*:  LONGINT;
                      lastLenOfs*:  LONGINT;
                 END;
              Param_LensAndNewNofElems*: RECORD  
                      nofOpenLens*:  LONGINT;
                      lastLenOfs*:  LONGINT;
                      baseNofElems*:  LONGINT;
                 END;
              Param_RecordSizeAndAddr*: RECORD  
                 END;
              Param_OArrSizeAndAddr*: RECORD  
                      objOfs*:  LONGINT;
                      elemSize*:  LONGINT;
                 END;
              Param_PartialOArrSizeAndAddrOfPar*: RECORD  
                 END;
              Param_PartialOArrSizeAndAddrOfPtr*: RECORD  
                      objOfs*:  LONGINT;
                 END;
              DirectCall*: RECORD  
                      paramSpace*:  LONGINT;
                      label*:  LAB.T;
                 END;
              IndirectCall*: RECORD  
                      paramSpace*:  LONGINT;
                 END;
              BoundCall_FPtr_APtr*: RECORD  
                      bprocLab*:  LAB.T;
                      procOfs*:  LONGINT;
                      paramSpace*:  LONGINT;
                 END;
              BoundCall_FRec_APtr*: RECORD  
                      bprocLab*:  LAB.T;
                      procOfs*:  LONGINT;
                      paramSpace*:  LONGINT;
                 END;
              BoundCall_FRec_ARec*: RECORD  
                      bprocLab*:  LAB.T;
                      procOfs*:  LONGINT;
                      paramSpace*:  LONGINT;
                 END;
              ProcReturn*: RECORD  
                 END;
              FuncReturn*: RECORD  
                 END;
              NoFuncResult*: RECORD  
                 END;
              FuncResultOf*: RECORD  
                      size*:  ConsBase.tSize;
                 END;
              CaseExpr*: RECORD  
                      isChar*:  BOOLEAN;
                      minVal*:  LONGINT;
                      maxVal*:  LONGINT;
                      tabLabel*:  LAB.T;
                      elseLabel*:  LAB.T;
                 END;
              ForStmt*: RECORD  
                      tempOfs*:  LONGINT;
                      step*:  LONGINT;
                      loopLabel*:  LAB.T;
                      condLabel*:  LAB.T;
                      size*:  ConsBase.tSize;
                 END;
              MonOper*: RECORD  
                      code*:  ASMOP.tOper;
                 END;
              SymDyOper*: RECORD  
                      code*:  ASMOP.tOper;
                 END;
              Sub*: RECORD  
                 END;
              Div*: RECORD  
                 END;
              Mod*: RECORD  
                 END;
              Difference*: RECORD  
                 END;
              SetExtendByElem*: RECORD  
                 END;
              SetExtendByRange*: RECORD  
                 END;
              NoBoolVal*: RECORD  
                 END;
              BoolVal*: RECORD  
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Not*: RECORD  
                 END;
              And*: RECORD  
                 END;
              Or*: RECORD  
                 END;
              ConstBranch*: RECORD  
                      value*:  BOOLEAN;
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Branch*: RECORD  
                      isSigned*:  BOOLEAN;
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              LabelDef*: RECORD  
                      label*:  LAB.T;
                 END;
              Flag*: RECORD  
                      rel*:  ConsBase.tRelation;
                 END;
              Compare*: RECORD  
                      rel*:  ConsBase.tRelation;
                 END;
              StringCompare*: RECORD  
                      rel*:  ConsBase.tRelation;
                 END;
              ConstStringCompare*: RECORD  
                      rel*:  ConsBase.tRelation;
                      str*:  OT.oSTRING;
                 END;
              In*: RECORD  
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Is*: RECORD  
                      typeLabel*:  LAB.T;
                      ttableElemOfs*:  LONGINT;
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Odd*: RECORD  
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Bit*: RECORD  
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Cc*: RECORD  
                      condcoding*:  LONGINT;
                      trueLabel*:  LAB.T;
                      falseLabel*:  LAB.T;
                 END;
              Abs*: RECORD  
                 END;
              Ash*: RECORD  
                 END;
              Cap*: RECORD  
                 END;
              IncOrDec*: RECORD  
                      code*:  ASMOP.tOper;
                 END;
              Excl*: RECORD  
                 END;
              Incl*: RECORD  
                 END;
              ShiftOrRotate*: RECORD  
                      code*:  ASMOP.tOper;
                 END;
              StaticNew*: RECORD  
                      size*:  LONGINT;
                      tdescLabel*:  LAB.T;
                      initLabel*:  LAB.T;
                 END;
              OpenNew*: RECORD  
                      elemSize*:  LONGINT;
                      tdescLabel*:  LAB.T;
                      initLabel*:  LAB.T;
                      nofLens*:  LONGINT;
                 END;
              LenCheck*: RECORD  
                 END;
              SystemNew*: RECORD  
                 END;
              Getreg*: RECORD  
                      regcoding*:  LONGINT;
                      dstSize*:  LONGINT;
                 END;
              Putreg*: RECORD  
                      regcoding*:  LONGINT;
                 END;
              Move*: RECORD  
                 END;
              Data2Retype*: RECORD  
                      srcLen*:  LONGINT;
                      dstLen*:  LONGINT;
                      tmpOfs*:  LONGINT;
                 END;
              Addr2Retype*: RECORD  
                      srcLen*:  LONGINT;
                      dstLen*:  LONGINT;
                      tmpOfs*:  LONGINT;
                 END;
              Retype2Data*: RECORD  
                 END;
              Retype2Float*: RECORD  
                 END;
              Retype2Addr*: RECORD  
                 END;
              Int2Shortint*: RECORD  
                 END;
              Int2Integer*: RECORD  
                 END;
              Int2Longint*: RECORD  
                 END;
              Card2Shortint*: RECORD  
                 END;
              Card2Integer*: RECORD  
                 END;
              Card2Longint*: RECORD  
                 END;
              CharConst*: RECORD  
                      val*:  OT.oCHAR;
                 END;
              BooleanConst*: RECORD  
                      val*:  OT.oBOOLEAN;
                 END;
              ShortintConst*: RECORD  
                      val*:  OT.oLONGINT;
                 END;
              IntegerConst*: RECORD  
                      val*:  OT.oLONGINT;
                 END;
              LongintConst*: RECORD  
                      val*:  OT.oLONGINT;
                 END;
              IntConst*: RECORD  
                      val*:  OT.oLONGINT;
                      size*:  ConsBase.tSize;
                 END;
              RealConst*: RECORD  
                      val*:  OT.oREAL;
                 END;
              SetConst*: RECORD  
                      val*:  OT.oSET;
                 END;
              RecordGuard*: RECORD  
                      typeLabel*:  LAB.T;
                      ttableElemOfs*:  LONGINT;
                      tagOfs*:  LONGINT;
                 END;
              PointerGuard*: RECORD  
                      typeLabel*:  LAB.T;
                      ttableElemOfs*:  LONGINT;
                 END;
              SimpleGuard*: RECORD  
                      typeLabel*:  LAB.T;
                      tagOfs*:  LONGINT;
                 END;
              IndexCheck*: RECORD  
                      len*:  LONGINT;
                 END;
              NilCheck*: RECORD  
                 END;
              MinIntCheck*: RECORD  
                      faultLabel*:  LAB.T;
                 END;
              ChrRangeCheck*: RECORD  
                 END;
              ShortRangeCheck*: RECORD  
                 END;
              OpenIndexStartLocal*: RECORD  
                 END;
              OpenIndexStart*: RECORD  
                 END;
              OpenIndexPush*: RECORD  
                      lenOfs*:  LONGINT;
                 END;
              OpenIndexStaticBase*: RECORD  
                      size*:  LONGINT;
                 END;
              OpenIndexOpenBase*: RECORD  
                      lenOfs*:  LONGINT;
                 END;
              OpenIndexPop*: RECORD  
                      lenOfs*:  LONGINT;
                      isFirstIndex*:  BOOLEAN;
                      isLastIndex*:  BOOLEAN;
                 END;
              OpenIndexApplication*: RECORD  
                 END;
              HeapOpenIndexApplication*: RECORD  
                      objOfs*:  LONGINT;
                 END;
              ConjureRegister*: RECORD  
                 END;
              FloatAssignment*: RECORD  
                      size*:  ConsBase.tSize;
                 END;
              FloatContentOf*: RECORD  
                      size*:  ConsBase.tSize;
                 END;
              FloatParam*: RECORD  
                      size*:  ConsBase.tSize;
                 END;
              FloatFuncReturn*: RECORD  
                 END;
              FloatFuncResultOf*: RECORD  
                 END;
              FloatNegate*: RECORD  
                 END;
              FloatSymDyOper*: RECORD  
                      code*:  ASMOP.tOper;
                 END;
              FloatDyOper*: RECORD  
                      code*:  ASMOP.tOper;
                 END;
              FloatCompare*: RECORD  
                      rel*:  ConsBase.tRelation;
                 END;
              Entier*: RECORD  
                 END;
              Int2Float*: RECORD  
                 END;
              Card2Float*: RECORD  
                 END;
              Real2Longreal*: RECORD  
                 END;
              Longreal2Real*: RECORD  
                 END;
              hashchain*:  Attributes;
           END;
 

 VAR       emptyAttrRec*: AttributesRecord;
           emptyExprRec*: ExpressionRecord;
           emptyExpression*: Expression;
           emptyAttributes*: Attributes;
 (* Attributes and Expression Records must be initialized !! because
    they are compared physically                                       *)


TYPE
(******* empty insertion IpGcgTypes *******)

   ExprAttrRec* =  RECORD
       hashchain*: ExprAttributes;
       Reg*: RECORD
               size*:  ConsBase.tSize;
       END; 
       Constant*: RECORD
               size*:  ConsBase.tSize;
               val*:  LONGINT;
       END; 
       Retyp*: RECORD
               dstLen*:  LONGINT;
               tmpOfs*:  LONGINT;
       END; 
       AMem*: RECORD
               size*:  ConsBase.tSize;
       END; 
       AReg*: RECORD
               size*:  ConsBase.tSize;
       END; 
       AImm*: RECORD
               size*:  ConsBase.tSize;
       END; 
       AMemAReg*: RECORD
               size*:  ConsBase.tSize;
       END; 
       AMemAImm*: RECORD
               size*:  ConsBase.tSize;
       END; 
       ARegAImm*: RECORD
               size*:  ConsBase.tSize;
       END; 
       AMemARegAImm*: RECORD
               size*:  ConsBase.tSize;
       END; 
       AVar*: RECORD
               var*:  ASM.tVariable;
       END; 
          stmtcost*: Cost;
                   stmtrule*: Rule;
                   cost*: CostArray; 
                   rule*: ARRAY MAX_NonTerminal+1 OF Rule;
   END;


 VAR InfCosts* : CostArray;


     OptEmitIR*, OptEmitMatch*, OptRegAlloc* : BOOLEAN;


     RegNameTable* : ARRAY ConsBase.MAX_BegRegister+1 OF ARRAY 10 OF CHAR;

















 VAR  nt : NonTerminal;



 PROCEDURE^PrintBOOLEAN*     (b : BOOLEAN);
 
 PROCEDURE PrintAttributes*  (VAR attr : AttributesRecord);
 BEGIN
    CASE attr.op OF 
    |  opGlobalVariable  :
       InOut.WriteString ('GlobalVariable  ');
       InOut.Write(' '); BETO.PrintT(attr.GlobalVariable.label);
       InOut.Write(' '); BETO.PrintLONGINT(attr.GlobalVariable.adr);
       InOut.Write(' '); BETO.PrinttIdent(attr.GlobalVariable.cmtIdent);
    |  opLocalVariable  :
       InOut.WriteString ('LocalVariable  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.LocalVariable.adr);
       InOut.Write(' '); BETO.PrinttIdent(attr.LocalVariable.cmtIdent);
    |  opSelector  :
       InOut.WriteString ('Selector  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Selector.ofs);
    |  opIndex  :
       InOut.WriteString ('Index  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Index.factor);
    |  opPointerFrom  :
       InOut.WriteString ('PointerFrom  ');
    |  opSimpleAssignment  :
       InOut.WriteString ('SimpleAssignment  ');
    |  opMemCopy  :
       InOut.WriteString ('MemCopy  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.MemCopy.len);
       InOut.Write(' '); PrintBOOLEAN(attr.MemCopy.isStringCopy);
    |  opShortConstStrCopy  :
       InOut.WriteString ('ShortConstStrCopy  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.ShortConstStrCopy.strVal);
       InOut.Write(' '); BETO.PrintLONGINT(attr.ShortConstStrCopy.len);
    |  opStrCopy  :
       InOut.WriteString ('StrCopy  ');
    |  opStrCopyArguments  :
       InOut.WriteString ('StrCopyArguments  ');
    |  opImplicifyConst  :
       InOut.WriteString ('ImplicifyConst  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.ImplicifyConst.len);
    |  opImplicifyOpenIndexed  :
       InOut.WriteString ('ImplicifyOpenIndexed  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.ImplicifyOpenIndexed.lenOfs);
       InOut.Write(' '); PrintBOOLEAN(attr.ImplicifyOpenIndexed.isStackObject);
       InOut.Write(' '); BETO.PrintLONGINT(attr.ImplicifyOpenIndexed.objOfs);
    |  opImplicify  :
       InOut.WriteString ('Implicify  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Implicify.lenOfs);
       InOut.Write(' '); PrintBOOLEAN(attr.Implicify.isStackObject);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Implicify.objOfs);
    |  opMemSet3  :
       InOut.WriteString ('MemSet3  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.MemSet3.v);
    |  opMemSet8  :
       InOut.WriteString ('MemSet8  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.MemSet8.lrLo);
       InOut.Write(' '); BETO.PrintLONGINT(attr.MemSet8.lrHi);
    |  opContentOf  :
       InOut.WriteString ('ContentOf  ');
       InOut.Write(' '); BETO.PrinttSize(attr.ContentOf.size);
    |  opAddressOf  :
       InOut.WriteString ('AddressOf  ');
    |  opNoParam  :
       InOut.WriteString ('NoParam  ');
    |  opParam  :
       InOut.WriteString ('Param  ');
    |  opParam0  :
       InOut.WriteString ('Param0  ');
    |  opParam8  :
       InOut.WriteString ('Param8  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param8.lrLo);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param8.lrHi);
    |  opParam_AddrAndTag  :
       InOut.WriteString ('Param_AddrAndTag  ');
    |  opParam_LensAndAddr  :
       InOut.WriteString ('Param_LensAndAddr  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_LensAndAddr.nofOpenLens);
    |  opParam_LensAndNewNofElemsAndAddr  :
       InOut.WriteString ('Param_LensAndNewNofElemsAndAddr  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_LensAndNewNofElemsAndAddr.nofOpenLens);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_LensAndNewNofElemsAndAddr.baseNofElems);
    |  opParam_Lens  :
       InOut.WriteString ('Param_Lens  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_Lens.nofOpenLens);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_Lens.lastLenOfs);
    |  opParam_LensAndNewNofElems  :
       InOut.WriteString ('Param_LensAndNewNofElems  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_LensAndNewNofElems.nofOpenLens);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_LensAndNewNofElems.lastLenOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_LensAndNewNofElems.baseNofElems);
    |  opParam_RecordSizeAndAddr  :
       InOut.WriteString ('Param_RecordSizeAndAddr  ');
    |  opParam_OArrSizeAndAddr  :
       InOut.WriteString ('Param_OArrSizeAndAddr  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_OArrSizeAndAddr.objOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_OArrSizeAndAddr.elemSize);
    |  opParam_PartialOArrSizeAndAddrOfPar  :
       InOut.WriteString ('Param_PartialOArrSizeAndAddrOfPar  ');
    |  opParam_PartialOArrSizeAndAddrOfPtr  :
       InOut.WriteString ('Param_PartialOArrSizeAndAddrOfPtr  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Param_PartialOArrSizeAndAddrOfPtr.objOfs);
    |  opDirectCall  :
       InOut.WriteString ('DirectCall  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.DirectCall.paramSpace);
       InOut.Write(' '); BETO.PrintT(attr.DirectCall.label);
    |  opIndirectCall  :
       InOut.WriteString ('IndirectCall  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.IndirectCall.paramSpace);
    |  opBoundCall_FPtr_APtr  :
       InOut.WriteString ('BoundCall_FPtr_APtr  ');
       InOut.Write(' '); BETO.PrintT(attr.BoundCall_FPtr_APtr.bprocLab);
       InOut.Write(' '); BETO.PrintLONGINT(attr.BoundCall_FPtr_APtr.procOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.BoundCall_FPtr_APtr.paramSpace);
    |  opBoundCall_FRec_APtr  :
       InOut.WriteString ('BoundCall_FRec_APtr  ');
       InOut.Write(' '); BETO.PrintT(attr.BoundCall_FRec_APtr.bprocLab);
       InOut.Write(' '); BETO.PrintLONGINT(attr.BoundCall_FRec_APtr.procOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.BoundCall_FRec_APtr.paramSpace);
    |  opBoundCall_FRec_ARec  :
       InOut.WriteString ('BoundCall_FRec_ARec  ');
       InOut.Write(' '); BETO.PrintT(attr.BoundCall_FRec_ARec.bprocLab);
       InOut.Write(' '); BETO.PrintLONGINT(attr.BoundCall_FRec_ARec.procOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.BoundCall_FRec_ARec.paramSpace);
    |  opProcReturn  :
       InOut.WriteString ('ProcReturn  ');
    |  opFuncReturn  :
       InOut.WriteString ('FuncReturn  ');
    |  opNoFuncResult  :
       InOut.WriteString ('NoFuncResult  ');
    |  opFuncResultOf  :
       InOut.WriteString ('FuncResultOf  ');
       InOut.Write(' '); BETO.PrinttSize(attr.FuncResultOf.size);
    |  opCaseExpr  :
       InOut.WriteString ('CaseExpr  ');
       InOut.Write(' '); PrintBOOLEAN(attr.CaseExpr.isChar);
       InOut.Write(' '); BETO.PrintLONGINT(attr.CaseExpr.minVal);
       InOut.Write(' '); BETO.PrintLONGINT(attr.CaseExpr.maxVal);
       InOut.Write(' '); BETO.PrintT(attr.CaseExpr.tabLabel);
       InOut.Write(' '); BETO.PrintT(attr.CaseExpr.elseLabel);
    |  opForStmt  :
       InOut.WriteString ('ForStmt  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.ForStmt.tempOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.ForStmt.step);
       InOut.Write(' '); BETO.PrintT(attr.ForStmt.loopLabel);
       InOut.Write(' '); BETO.PrintT(attr.ForStmt.condLabel);
       InOut.Write(' '); BETO.PrinttSize(attr.ForStmt.size);
    |  opMonOper  :
       InOut.WriteString ('MonOper  ');
       InOut.Write(' '); BETO.PrinttOper(attr.MonOper.code);
    |  opSymDyOper  :
       InOut.WriteString ('SymDyOper  ');
       InOut.Write(' '); BETO.PrinttOper(attr.SymDyOper.code);
    |  opSub  :
       InOut.WriteString ('Sub  ');
    |  opDiv  :
       InOut.WriteString ('Div  ');
    |  opMod  :
       InOut.WriteString ('Mod  ');
    |  opDifference  :
       InOut.WriteString ('Difference  ');
    |  opSetExtendByElem  :
       InOut.WriteString ('SetExtendByElem  ');
    |  opSetExtendByRange  :
       InOut.WriteString ('SetExtendByRange  ');
    |  opNoBoolVal  :
       InOut.WriteString ('NoBoolVal  ');
    |  opBoolVal  :
       InOut.WriteString ('BoolVal  ');
       InOut.Write(' '); BETO.PrintT(attr.BoolVal.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.BoolVal.falseLabel);
    |  opNot  :
       InOut.WriteString ('Not  ');
    |  opAnd  :
       InOut.WriteString ('And  ');
    |  opOr  :
       InOut.WriteString ('Or  ');
    |  opConstBranch  :
       InOut.WriteString ('ConstBranch  ');
       InOut.Write(' '); PrintBOOLEAN(attr.ConstBranch.value);
       InOut.Write(' '); BETO.PrintT(attr.ConstBranch.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.ConstBranch.falseLabel);
    |  opBranch  :
       InOut.WriteString ('Branch  ');
       InOut.Write(' '); PrintBOOLEAN(attr.Branch.isSigned);
       InOut.Write(' '); BETO.PrintT(attr.Branch.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.Branch.falseLabel);
    |  opLabelDef  :
       InOut.WriteString ('LabelDef  ');
       InOut.Write(' '); BETO.PrintT(attr.LabelDef.label);
    |  opFlag  :
       InOut.WriteString ('Flag  ');
       InOut.Write(' '); BETO.PrinttRelation(attr.Flag.rel);
    |  opCompare  :
       InOut.WriteString ('Compare  ');
       InOut.Write(' '); BETO.PrinttRelation(attr.Compare.rel);
    |  opStringCompare  :
       InOut.WriteString ('StringCompare  ');
       InOut.Write(' '); BETO.PrinttRelation(attr.StringCompare.rel);
    |  opConstStringCompare  :
       InOut.WriteString ('ConstStringCompare  ');
       InOut.Write(' '); BETO.PrinttRelation(attr.ConstStringCompare.rel);
       InOut.Write(' '); BETO.PrintoSTRING(attr.ConstStringCompare.str);
    |  opIn  :
       InOut.WriteString ('In  ');
       InOut.Write(' '); BETO.PrintT(attr.In.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.In.falseLabel);
    |  opIs  :
       InOut.WriteString ('Is  ');
       InOut.Write(' '); BETO.PrintT(attr.Is.typeLabel);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Is.ttableElemOfs);
       InOut.Write(' '); BETO.PrintT(attr.Is.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.Is.falseLabel);
    |  opOdd  :
       InOut.WriteString ('Odd  ');
       InOut.Write(' '); BETO.PrintT(attr.Odd.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.Odd.falseLabel);
    |  opBit  :
       InOut.WriteString ('Bit  ');
       InOut.Write(' '); BETO.PrintT(attr.Bit.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.Bit.falseLabel);
    |  opCc  :
       InOut.WriteString ('Cc  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Cc.condcoding);
       InOut.Write(' '); BETO.PrintT(attr.Cc.trueLabel);
       InOut.Write(' '); BETO.PrintT(attr.Cc.falseLabel);
    |  opAbs  :
       InOut.WriteString ('Abs  ');
    |  opAsh  :
       InOut.WriteString ('Ash  ');
    |  opCap  :
       InOut.WriteString ('Cap  ');
    |  opIncOrDec  :
       InOut.WriteString ('IncOrDec  ');
       InOut.Write(' '); BETO.PrinttOper(attr.IncOrDec.code);
    |  opExcl  :
       InOut.WriteString ('Excl  ');
    |  opIncl  :
       InOut.WriteString ('Incl  ');
    |  opShiftOrRotate  :
       InOut.WriteString ('ShiftOrRotate  ');
       InOut.Write(' '); BETO.PrinttOper(attr.ShiftOrRotate.code);
    |  opStaticNew  :
       InOut.WriteString ('StaticNew  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.StaticNew.size);
       InOut.Write(' '); BETO.PrintT(attr.StaticNew.tdescLabel);
       InOut.Write(' '); BETO.PrintT(attr.StaticNew.initLabel);
    |  opOpenNew  :
       InOut.WriteString ('OpenNew  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.OpenNew.elemSize);
       InOut.Write(' '); BETO.PrintT(attr.OpenNew.tdescLabel);
       InOut.Write(' '); BETO.PrintT(attr.OpenNew.initLabel);
       InOut.Write(' '); BETO.PrintLONGINT(attr.OpenNew.nofLens);
    |  opLenCheck  :
       InOut.WriteString ('LenCheck  ');
    |  opSystemNew  :
       InOut.WriteString ('SystemNew  ');
    |  opGetreg  :
       InOut.WriteString ('Getreg  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Getreg.regcoding);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Getreg.dstSize);
    |  opPutreg  :
       InOut.WriteString ('Putreg  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Putreg.regcoding);
    |  opMove  :
       InOut.WriteString ('Move  ');
    |  opData2Retype  :
       InOut.WriteString ('Data2Retype  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Data2Retype.srcLen);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Data2Retype.dstLen);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Data2Retype.tmpOfs);
    |  opAddr2Retype  :
       InOut.WriteString ('Addr2Retype  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.Addr2Retype.srcLen);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Addr2Retype.dstLen);
       InOut.Write(' '); BETO.PrintLONGINT(attr.Addr2Retype.tmpOfs);
    |  opRetype2Data  :
       InOut.WriteString ('Retype2Data  ');
    |  opRetype2Float  :
       InOut.WriteString ('Retype2Float  ');
    |  opRetype2Addr  :
       InOut.WriteString ('Retype2Addr  ');
    |  opInt2Shortint  :
       InOut.WriteString ('Int2Shortint  ');
    |  opInt2Integer  :
       InOut.WriteString ('Int2Integer  ');
    |  opInt2Longint  :
       InOut.WriteString ('Int2Longint  ');
    |  opCard2Shortint  :
       InOut.WriteString ('Card2Shortint  ');
    |  opCard2Integer  :
       InOut.WriteString ('Card2Integer  ');
    |  opCard2Longint  :
       InOut.WriteString ('Card2Longint  ');
    |  opCharConst  :
       InOut.WriteString ('CharConst  ');
       InOut.Write(' '); BETO.PrintoCHAR(attr.CharConst.val);
    |  opBooleanConst  :
       InOut.WriteString ('BooleanConst  ');
       InOut.Write(' '); BETO.PrintoBOOLEAN(attr.BooleanConst.val);
    |  opShortintConst  :
       InOut.WriteString ('ShortintConst  ');
       InOut.Write(' '); BETO.PrintoLONGINT(attr.ShortintConst.val);
    |  opIntegerConst  :
       InOut.WriteString ('IntegerConst  ');
       InOut.Write(' '); BETO.PrintoLONGINT(attr.IntegerConst.val);
    |  opLongintConst  :
       InOut.WriteString ('LongintConst  ');
       InOut.Write(' '); BETO.PrintoLONGINT(attr.LongintConst.val);
    |  opIntConst  :
       InOut.WriteString ('IntConst  ');
       InOut.Write(' '); BETO.PrintoLONGINT(attr.IntConst.val);
       InOut.Write(' '); BETO.PrinttSize(attr.IntConst.size);
    |  opRealConst  :
       InOut.WriteString ('RealConst  ');
       InOut.Write(' '); BETO.PrintoREAL(attr.RealConst.val);
    |  opSetConst  :
       InOut.WriteString ('SetConst  ');
       InOut.Write(' '); BETO.PrintoSET(attr.SetConst.val);
    |  opRecordGuard  :
       InOut.WriteString ('RecordGuard  ');
       InOut.Write(' '); BETO.PrintT(attr.RecordGuard.typeLabel);
       InOut.Write(' '); BETO.PrintLONGINT(attr.RecordGuard.ttableElemOfs);
       InOut.Write(' '); BETO.PrintLONGINT(attr.RecordGuard.tagOfs);
    |  opPointerGuard  :
       InOut.WriteString ('PointerGuard  ');
       InOut.Write(' '); BETO.PrintT(attr.PointerGuard.typeLabel);
       InOut.Write(' '); BETO.PrintLONGINT(attr.PointerGuard.ttableElemOfs);
    |  opSimpleGuard  :
       InOut.WriteString ('SimpleGuard  ');
       InOut.Write(' '); BETO.PrintT(attr.SimpleGuard.typeLabel);
       InOut.Write(' '); BETO.PrintLONGINT(attr.SimpleGuard.tagOfs);
    |  opIndexCheck  :
       InOut.WriteString ('IndexCheck  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.IndexCheck.len);
    |  opNilCheck  :
       InOut.WriteString ('NilCheck  ');
    |  opMinIntCheck  :
       InOut.WriteString ('MinIntCheck  ');
       InOut.Write(' '); BETO.PrintT(attr.MinIntCheck.faultLabel);
    |  opChrRangeCheck  :
       InOut.WriteString ('ChrRangeCheck  ');
    |  opShortRangeCheck  :
       InOut.WriteString ('ShortRangeCheck  ');
    |  opOpenIndexStartLocal  :
       InOut.WriteString ('OpenIndexStartLocal  ');
    |  opOpenIndexStart  :
       InOut.WriteString ('OpenIndexStart  ');
    |  opOpenIndexPush  :
       InOut.WriteString ('OpenIndexPush  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.OpenIndexPush.lenOfs);
    |  opOpenIndexStaticBase  :
       InOut.WriteString ('OpenIndexStaticBase  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.OpenIndexStaticBase.size);
    |  opOpenIndexOpenBase  :
       InOut.WriteString ('OpenIndexOpenBase  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.OpenIndexOpenBase.lenOfs);
    |  opOpenIndexPop  :
       InOut.WriteString ('OpenIndexPop  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.OpenIndexPop.lenOfs);
       InOut.Write(' '); PrintBOOLEAN(attr.OpenIndexPop.isFirstIndex);
       InOut.Write(' '); PrintBOOLEAN(attr.OpenIndexPop.isLastIndex);
    |  opOpenIndexApplication  :
       InOut.WriteString ('OpenIndexApplication  ');
    |  opHeapOpenIndexApplication  :
       InOut.WriteString ('HeapOpenIndexApplication  ');
       InOut.Write(' '); BETO.PrintLONGINT(attr.HeapOpenIndexApplication.objOfs);
    |  opConjureRegister  :
       InOut.WriteString ('ConjureRegister  ');
    |  opFloatAssignment  :
       InOut.WriteString ('FloatAssignment  ');
       InOut.Write(' '); BETO.PrinttSize(attr.FloatAssignment.size);
    |  opFloatContentOf  :
       InOut.WriteString ('FloatContentOf  ');
       InOut.Write(' '); BETO.PrinttSize(attr.FloatContentOf.size);
    |  opFloatParam  :
       InOut.WriteString ('FloatParam  ');
       InOut.Write(' '); BETO.PrinttSize(attr.FloatParam.size);
    |  opFloatFuncReturn  :
       InOut.WriteString ('FloatFuncReturn  ');
    |  opFloatFuncResultOf  :
       InOut.WriteString ('FloatFuncResultOf  ');
    |  opFloatNegate  :
       InOut.WriteString ('FloatNegate  ');
    |  opFloatSymDyOper  :
       InOut.WriteString ('FloatSymDyOper  ');
       InOut.Write(' '); BETO.PrinttOper(attr.FloatSymDyOper.code);
    |  opFloatDyOper  :
       InOut.WriteString ('FloatDyOper  ');
       InOut.Write(' '); BETO.PrinttOper(attr.FloatDyOper.code);
    |  opFloatCompare  :
       InOut.WriteString ('FloatCompare  ');
       InOut.Write(' '); BETO.PrinttRelation(attr.FloatCompare.rel);
    |  opEntier  :
       InOut.WriteString ('Entier  ');
    |  opInt2Float  :
       InOut.WriteString ('Int2Float  ');
    |  opCard2Float  :
       InOut.WriteString ('Card2Float  ');
    |  opReal2Longreal  :
       InOut.WriteString ('Real2Longreal  ');
    |  opLongreal2Real  :
       InOut.WriteString ('Longreal2Real  ');
    END;
    InOut.WriteLn;
  END PrintAttributes;

 (*-------------------------------------------------------------------------*)
 PROCEDURE PrintExpressionR (expr: Expression; level:LONGINT);
    VAR i:LONGINT; 
 BEGIN
    InOut.WriteCard (SYSTEM.VAL(LONGINT,expr),7); InOut.Write(' ');
    FOR i := 1 TO level DO InOut.WriteString('  '); END;
    PrintAttributes(expr^.attr^);
    FOR i := 1 TO expr^.arity DO
       PrintExpressionR(expr^.son[i], level+1)
    END;
 END PrintExpressionR;


 PROCEDURE PrintExpression*  (e : Expression);
 BEGIN
    PrintExpressionR (e,0);
 END PrintExpression;
 (*-------------------------------------------------------------------------*)
 PROCEDURE^PrintExprAttributes* (ga : ExprAttributes);
 
 PROCEDURE PrintExprCostsR (expr: Expression; level:LONGINT);
    VAR i:LONGINT; 
 BEGIN
    InOut.WriteCard (SYSTEM.VAL(LONGINT,expr),7); InOut.Write(' ');
    FOR i := 1 TO level DO InOut.WriteString('  '); END;
    PrintAttributes(expr^.attr^);
    PrintExprAttributes (expr^.gcg);
    FOR i := 1 TO expr^.arity DO
       PrintExprCostsR(expr^.son[i], level+1)
    END;
 END PrintExprCostsR;


 PROCEDURE PrintExprCosts*  (e : Expression);
 BEGIN
    PrintExprCostsR (e,1);
 END PrintExprCosts;
 (*-------------------------------------------------------------------------*)
 PROCEDURE PrintInstrCosts*  (e : Expression);
 VAR i:LONGINT; 
 BEGIN
    InOut.WriteCard (SYSTEM.VAL(LONGINT,e),7); InOut.Write(' ');
    PrintAttributes(e^.attr^);
    FOR i:=1 TO e^.arity DO 
       PrintExprCosts (e^.son[i]);
    END;
 END PrintInstrCosts;
 (*-------------------------------------------------------------------------*)
 PROCEDURE PrintINTEGER*     (i : INTEGER);
 BEGIN
    InOut.WriteInt (i,1);
 END PrintINTEGER;

 PROCEDURE PrintCARDINAL*    (i :LONGINT);
 BEGIN
   InOut.WriteCard (i,1);
 END PrintCARDINAL;

 PROCEDURE PrintBOOLEAN*     (b : BOOLEAN);
 BEGIN
    IF b THEN InOut.WriteString ('TRUE') ELSE InOut.WriteString ('FALSE'); END;
 END PrintBOOLEAN;

 (*-------------------------------------------------------------------------*)

 PROCEDURE  InitIR*;
 VAR i : INTEGER;
 BEGIN
    NEW (emptyExpression);
    NEW (emptyAttributes);

       emptyExprRec.gcg := NIL;
       emptyExprRec.hashchain := NIL;
       FOR i:=1 TO MaxArity DO emptyExprRec.son[i] := emptyExpression; END;
   
    emptyAttrRec.op  := NoOpCode;
    
    emptyAttributes^ := emptyAttrRec;
    emptyExpression^ := emptyExprRec;
    NEW (emptyExpression^.gcg);
    emptyExpression^.gcg^.cost := InfCosts;
 END InitIR;
 
(******* empty insertion IpError *******)
 PROCEDURE Error* (errmesg: ARRAY OF CHAR);
 BEGIN
   InOut.WriteString (errmesg); InOut.WriteLn;
 END Error;


 PROCEDURE PrintNonTerminal (n : NonTerminal);
 BEGIN
    CASE n OF 
    |  ntBReg : InOut.WriteString ('BReg');
    |  ntWReg : InOut.WriteString ('WReg');
    |  ntLReg : InOut.WriteString ('LReg');
    |  ntReg : InOut.WriteString ('Reg');
    |  ntFXReg : InOut.WriteString ('FXReg');
    |  ntFYReg : InOut.WriteString ('FYReg');
    |  ntConstant : InOut.WriteString ('Constant');
    |  ntGv : InOut.WriteString ('Gv');
    |  ntIreg : InOut.WriteString ('Ireg');
    |  ntBreg : InOut.WriteString ('Breg');
    |  ntBregIreg : InOut.WriteString ('BregIreg');
    |  ntMemory : InOut.WriteString ('Memory');
    |  ntLab : InOut.WriteString ('Lab');
    |  ntCond : InOut.WriteString ('Cond');
    |  ntBool : InOut.WriteString ('Bool');
    |  ntReducedStack : InOut.WriteString ('ReducedStack');
    |  ntStrCopyArgs : InOut.WriteString ('StrCopyArgs');
    |  ntArgs : InOut.WriteString ('Args');
    |  ntRetyp : InOut.WriteString ('Retyp');
    |  ntAMem : InOut.WriteString ('AMem');
    |  ntAReg : InOut.WriteString ('AReg');
    |  ntAImm : InOut.WriteString ('AImm');
    |  ntAMemAReg : InOut.WriteString ('AMemAReg');
    |  ntAMemAImm : InOut.WriteString ('AMemAImm');
    |  ntARegAImm : InOut.WriteString ('ARegAImm');
    |  ntAMemARegAImm : InOut.WriteString ('AMemARegAImm');
    |  ntAVar : InOut.WriteString ('AVar');
    END;
 END PrintNonTerminal;

 PROCEDURE PrintExprAttributes* (ga : ExprAttributes);
 VAR  nt : NonTerminal;
 BEGIN
    FOR nt:= ntBReg TO ntAVar DO 
       IF ga^.cost[nt]<infcost THEN 
          InOut.WriteString('                     ');
          PrintNonTerminal(nt);
          InOut.WriteString(' Cost=');
          InOut.WriteInt   (ga^.cost[nt],1);
          InOut.WriteString(' Rule=');
          InOut.WriteInt   (ga^.rule[nt],1);
          InOut.WriteLn;
       END;
    END;
 END PrintExprAttributes;

PROCEDURE^PrintRegister*       (r  : Register      );

 PROCEDURE PrintRegisterSet*    (rs : RegisterSet   );
 VAR r : Register;
 BEGIN
    InOut.WriteString ('{ ');
    FOR r:=MIN(Register) TO MAX(Register) DO 
       IF    ((r) IN rs[0]) THEN
          PrintRegister (r); InOut.WriteString(' ');
       END;
    END;
    InOut.WriteString ('}');
 END PrintRegisterSet;

PROCEDURE PrintBegRegister*       (r  : Register      );
BEGIN
    InOut.WriteString (RegNameTable[r]);
END PrintBegRegister;
 
PROCEDURE PrintRegister*       (r  : Register      );
BEGIN
    InOut.WriteString (RegNameTable[r]);
END PrintRegister;
 



PROCEDURE RegUnion*	(a, b: RegisterSet; VAR r: RegisterSet);
BEGIN
      r[0]:=a[0]+b[0];      
END RegUnion;

PROCEDURE RegInter*	(a, b: RegisterSet; VAR r: RegisterSet);
BEGIN
      r[0]:=a[0]*b[0];      
END RegInter;

PROCEDURE RegMinus*	(a, b: RegisterSet; VAR r: RegisterSet);
BEGIN
      r[0] :=a[0]-b[0];      
END RegMinus;

PROCEDURE RegNegate*	(a: RegisterSet; VAR r: RegisterSet);
BEGIN
      r[0] := SYSTEM.VAL(SET, (-1))-a[0];      
END RegNegate;

PROCEDURE RegEmpty*	(a: RegisterSet): BOOLEAN;
BEGIN
  RETURN ( (a[0]={}));
END RegEmpty;

PROCEDURE RegIsIn*	(a: Register; b: RegisterSet): BOOLEAN;
BEGIN
  RETURN    ((a) IN b[0]);
END RegIsIn;

PROCEDURE RegIncl*	(VAR a: RegisterSet; b: Register);
BEGIN
   INCL (a[0], (b));
END RegIncl;

PROCEDURE RegExcl*	(VAR a: RegisterSet; b: Register);
BEGIN
   EXCL (a[0], (b));
END RegExcl;

PROCEDURE RegClear*	(VAR a: RegisterSet);
BEGIN
     a[0]:={};
END RegClear;

PROCEDURE RegDisjoint*	(a, b: RegisterSet): BOOLEAN;
BEGIN
  RETURN ( (a[0]*b[0]={}));
END RegDisjoint;


 BEGIN
    FOR nt:= ntBReg TO ntAVar DO 
       InfCosts [nt] := infcost;
    END;
    OptEmitIR := FALSE;
    OptEmitMatch := FALSE;
    OptRegAlloc := FALSE;
     RegNameTable[ConsBase.RegNil] := 'Nil';
     RegNameTable[ConsBase.Regal] := 'al';
     RegNameTable[ConsBase.Regah] := 'ah';
     RegNameTable[ConsBase.Regbl] := 'bl';
     RegNameTable[ConsBase.Regbh] := 'bh';
     RegNameTable[ConsBase.Regcl] := 'cl';
     RegNameTable[ConsBase.Regch] := 'ch';
     RegNameTable[ConsBase.Regdl] := 'dl';
     RegNameTable[ConsBase.Regdh] := 'dh';
     RegNameTable[ConsBase.Regax] := 'ax';
     RegNameTable[ConsBase.Regbx] := 'bx';
     RegNameTable[ConsBase.Regcx] := 'cx';
     RegNameTable[ConsBase.Regdx] := 'dx';
     RegNameTable[ConsBase.Regsi] := 'si';
     RegNameTable[ConsBase.Regdi] := 'di';
     RegNameTable[ConsBase.Regeax] := 'eax';
     RegNameTable[ConsBase.Regebx] := 'ebx';
     RegNameTable[ConsBase.Regecx] := 'ecx';
     RegNameTable[ConsBase.Regedx] := 'edx';
     RegNameTable[ConsBase.Regesi] := 'esi';
     RegNameTable[ConsBase.Regedi] := 'edi';
     RegNameTable[ConsBase.Regebp] := 'ebp';
     RegNameTable[ConsBase.Regesp] := 'esp';
     RegNameTable[ConsBase.Regst] := 'st';
     RegNameTable[ConsBase.Regst1] := 'st1';
     RegNameTable[ConsBase.Regst2] := 'st2';
     RegNameTable[ConsBase.Regst3] := 'st3';
     RegNameTable[ConsBase.Regst4] := 'st4';
     RegNameTable[ConsBase.Regst5] := 'st5';
     RegNameTable[ConsBase.Regst6] := 'st6';
     RegNameTable[ConsBase.Regst7] := 'st7';
END IR.
