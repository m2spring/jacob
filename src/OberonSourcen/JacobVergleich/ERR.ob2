MODULE ERR;

IMPORT Base,ARG,BasicIO,ErrLists,IO,O,POS,Sets,STR,StringMem,Strings,SYSTEM;

CONST  NoErrorMsg*           =  0 ;

(*------------------------------------------------------------------------------------------------------------------------------*)
(* Vocabulary and Representation *)

MsgIllegalCharInSource*      =  1 ; (* oberon.rex                                                                                *)
MsgCommentNotClosed*         =  2 ; (* oberon.rex                                                                                *)
MsgIllegalIntegerConst*      =  3 ; (* oberon.rex                                                                                *)
MsgIllegalRealConst*         =  4 ; (* oberon.rex                                                                                *)
MsgIllegalLongrealConst*     =  5 ; (* oberon.rex                                                                                *)
MsgIllegalCharConst*         =  6 ; (* oberon.rex                                                                                *)
MsgStringNotTerminated*      =  7 ; (* oberon.rex                                                                                *)

(* Declarations and scope rules *)

MsgUndeclaredIdent*          =  8 ; (* Receiver PointerToIdType UnqualifiedIdent QualifiedIdent                                  *)
MsgIdentNotExported*         =  9 ; (* QualifiedIdent Importing                                                                  *)
MsgAlreadyDeclared*          = 10 ; (* Import ConstDecl TypeDecl ProcDecl ForwardDecl ParId IdentList (T.pum: CheckBoundProc)    *)
MsgUndeclaredExternIdent*    = 11 ; (* QualifiedIdent Importing                                                                  *)
MsgUnresolvedForwardType*    = 12 ; (* (E.pum: CheckUnresolvedForwardPointers)                                                   *)
MsgUnresolvedForwardProc*    = 13 ; (* (E.pum: CheckUnresolvedForwardProcs)                                                      *)

MsgConstsAlwaysReadOnly*     = 14 ; (* ConstDecl                                                                                 *)
MsgTypesAlwaysReadOnly*      = 15 ; (* TypeDecl                                                                                  *)
MsgProcsAlwaysReadOnly*      = 16 ; (* ProcDecl ForwardDecl BoundProcDecl BoundForwardDecl                                       *)
MsgIllegalLocalExport*       = 17 ; (* IdentDef                                                                                  *)

(* Types *)

MsgMissingArrayLength*       = 18 ; (* OpenArrayType                                                                             *)
MsgInvalidArrayLen*          = 19 ; (* ArrayExprList (oberon.pre: NewExprList)                                                   *)
MsgConstantNotInteger*       = 20 ; (* ArrayExprList                                                                             *)
MsgIllegalOpenArray*         = 21 ; (* NamedType (oberon.pre: SizeArgumenting)                                                   *)
MsgObjectTooBig*             = 22 ; (* ArrayExprList (oberon.eva: FieldList)                                                     *)
MsgRecordTypeExpected*       = 23 ; (* ExtendedType                                                                              *)
MsgWrongPointerBase*         = 24 ; (* TypeDecl PointerType                                                                      *)
MsgIllegalRecursiveType*     = 25 ; (* NamedType ExtendedType                                                                    *)

(* Expressions *)

MsgExprNotConstant*          = 26 ; (* ConstExpr (oberon.pre: HaltArgumenting SysCcArgumenting AssertArgumenting LenArgumenting  *)
                                   (* SysGetregPutregArgumenting)                                                               *)
MsgInvalidExprType*          = 27 ; (* IfStmt WhileStmt RepeatStmt NegateExpr IdentityExpr NotExpr Element InOper BoolOper       *)
                                   (* Indexing                                                                                  *)
MsgConstArithmeticError*     = 28 ; (* NegateExpr NumSetOper (oberon.pre: AbsArgumenting ChrArgumenting EntierArgumenting        *)
                                   (* ShortArgumenting AshArgumenting)                                                          *)
MsgIntOutOfSet*              = 29 ; (* Element (oberon.pre: ExclInclArgumenting)                                                 *)
MsgTypeTestNotApplicable*    = 30 ; (* IsExpr                                                                                    *)
MsgOperatorNotApplicable*    = 31 ; (* RelationOper OrderRelationOper NumSetOper                                                 *)
MsgTypeExpected*             = 32 ; (* Receiver NamedType PointerType Guard IsExpr Guarding                                      *)
MsgLValueExpected*           = 33 ; (* AssignStmt ExprList (oberon.pre: SysAdrArgumenting LenArgumenting DecIncArgumenting       *)
                                   (* CopyArgumenting ExclInclArgumenting SysGetArgumenting SysGetregArgumenting                *)
                                   (* SysNewArgumenting NewArgumenting)                                                         *)

(* Operands *)

MsgIdentIsNoModule*          = 34 ; (* QualifiedIdent                                                                            *)
MsgModulesNotAllowed*        = 35 ; (* Designator                                                                                *)
MsgTypeNotAllowed*           = 36 ; (* Designator                                                                                *)
MsgRecordFieldNotFound*      = 37 ; (* Selecting                                                                                 *)
MsgRecordFieldNotExported*   = 38 ; (* Selecting                                                                                 *)
MsgSelectorNotApplicable*    = 39 ; (* Selecting                                                                                 *)
MsgIndexNotApplicable*       = 40 ; (* Indexing                                                                                  *)
MsgIndexOutOfBounds*         = 41 ; (* Indexing                                                                                  *)
MsgDerefNotApplicable*       = 42 ; (* Dereferencing                                                                             *)
MsgArgumentsNotAllowed*      = 43 ; (* Argumenting                                                                               *)
MsgGuardNotApplicable*       = 44 ; (* Guard Guarding                                                                            *)
MsgNonReceiverSupered*       = 45 ; (* Supering                                                                                  *)
MsgMissingRedefined*         = 46 ; (* Supering                                                                                  *)
MsgSuperingWithinRedefining* = 47 ; (* Supering                                                                                  *)

(* Procedure declarations *)

MsgProcname2Incorrect*       = 48 ; (* ProcDecl BoundProcDecl                                                                    *)
MsgNonMatchingActualDecl*    = 49 ; (* ProcDecl (T.pum: CheckBoundProc)                                                          *)
MsgIllegalFunctionResult*    = 50 ; (* FormalPars                                                                                *)

(* Formal parameters *)

MsgTooManyParams*            = 51 ; (* ExprList (oberon.pre: NewExprList)                                                        *)
MsgTooFewParams*             = 52 ; (* mtExprList (oberon.pre: PredeclArgumenting1 PredeclArgumenting2Opt PredeclArgumenting3    *)
                                   (* TypeArgumenting SysValArgumenting mtNewExprList)                                          *)
MsgParmNotCompatible*        = 53 ; (* ExprList (oberon.pre: AbsArgumenting CapArgumenting ChrArgumenting EntierArgumenting      *)
                                   (* LongArgumenting OddArgumenting OrdArgumenting ShortArgumenting HaltArgumenting            *)
                                   (* SysCcArgumenting AssertArgumenting LenArgumenting DecIncArgumenting AshArgumenting        *)
                                   (* CopyArgumenting ExclInclArgumenting SysBitArgumenting SysLshRotArgumenting                *)
                                   (* SysGetPutArgumenting SysGetregPutregArgumenting SysNewArgumenting SysMoveArgumenting      *)
                                   (* TypeArgumenting MaxMinArgumenting NewArgumenting NewExprList)                             *)
MsgIllegalROVarPar*          = 54 ; (* ExprList                                                                                  *)

(* Statements *)

MsgNotAssignCompatible*      = 55 ; (* AssignStmt ForStmt                                                                        *)
MsgObjectIsReadonly*         = 56 ; (* AssignStmt                                                                                *)
MsgVariableExpected*         = 57 ; (* ForStmt                                                                                   *)
MsgIntegerTypeExpected*      = 58 ; (* ForStmt                                                                                   *)
MsgNotCompatibleWithCtrlVar* = 59 ; (* ForStmt                                                                                   *)
MsgStepMustBeNonZero*        = 60 ; (* ForStmt                                                                                   *)
MsgIllegalFuncCall*          = 61 ; (* DesignExpr                                                                                *)
MsgProcedureExpected*        = 62 ; (* CallStmt                                                                                  *)
MsgMissingReturn*            = 63 ; (* ProcDecl ReturnStmt                                                                       *)
MsgMissingReturnExpr*        = 64 ; (* ReturnStmt                                                                                *)
MsgMisplacedReturnExpr*      = 65 ; (* ReturnStmt                                                                                *)
MsgIncompatibleReturnExpr*   = 66 ; (* ReturnStmt                                                                                *)
MsgReturnOnlyInProcs*        = 67 ; (* ReturnStmt                                                                                *)
MsgIllegalCaseExpr*          = 68 ; (* CaseStmt                                                                                  *)
MsgLabelNotCompatible*       = 69 ; (* CaseLabel                                                                                 *)
MsgOverlappingCaseLabel*     = 70 ; (* CaseLabel                                                                                 *)
MsgIllegalCaseLabelRange*    = 71 ; (* CaseLabel                                                                                 *)
MsgWrongLabelType*           = 72 ; (* CaseLabel                                                                                 *)
MsgExitWithoutLoop*          = 73 ; (* ExitStmt                                                                                  *)

(* Type-bound procedures *)

MsgBoundProcMustBeGlobal*    = 74 ; (* BoundProcDecl BoundForwardDecl                                                            *)
MsgRedefMustBeExported*      = 75 ; (* BoundProcDecl BoundForwardDecl                                                            *)
MsgNonMatchingRedef*         = 76 ; (* (T.pum: CheckFieldsPreRedefs)                                                             *)
MsgInvalidType*              = 77 ; (* Receiver                                                                                  *)
MsgReceiverParamNotPointer*  = 78 ; 

(* Modules / Importing *)

MsgModuleFilenameDiffers*    = 79 ; (* Module                                                                                    *)
MsgModulename2Incorrect*     = 80 ; (* Module                                                                                    *)
MsgFileNotFound*             = 81 ; (* (DRV.mi: Import)                                                                          *)
MsgCyclicImport*             = 82 ; (* (DRV.mi: Import)                                                                          *)

(* Others *)

MsgTooManyVars*              = 83 ; (* (oberon.eva: VarDecl)                                                                     *)
MsgIllegalLenDimension*      = 84 ; (* oberon.pre: LenArgumenting                                                                *)
MsgProcNestedTooDeeply*      = 85 ;
MsgMaxExtLevelReached*       = 86 ;
MsgMaxCaseLabelRange*        = 87 ;
MaxMsg*                      = 87 ;

(*------------------------------------------------------------------------------------------------------------------------------*)
VAR    ErrTabName*           : ARRAY 128 OF CHAR;
TYPE   tErrorMsg*            = Base.tErrorMsg;
       tError*               = RECORD
                               msg* : tErrorMsg;
                               pos* : POS.tPosition;
                              END;

(*------------------------------------------------------------------------------------------------------------------------------*)
VAR    Messages*       : ARRAY MaxMsg+2 OF StringMem.tStringRef;
       MessagesLoaded* : BOOLEAN;
       ActPos*         : POS.tPosition;
       ActStr*         : ARRAY 201 OF CHAR;

PROCEDURE^LoadErrorMessages;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE NewMsg(pos : POS.tPosition);
BEGIN (* NewMsg *)
 ActPos:=pos; ActStr[0]:=0X;

 IF ARG.OptionEagerErrorMsgs THEN 
    O.Str(Base.ActP^.SourceDir^); 
    O.Str(Base.ActP^.Filename^); 
    O.Str(': ');
    O.Num(pos.Line,4);
    O.Str(',');
    O.Num(pos.Column,3);
    O.Str(': ');
 END; (* IF *)
END NewMsg;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE WrStr(s : ARRAY OF CHAR);
BEGIN (* WrStr *)
 STR.Append(ActStr,s);

 IF ARG.OptionEagerErrorMsgs THEN O.Str(s); END; (* IF *)
END WrStr;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MsgDone;
BEGIN (* MsgDone *)
 ErrLists.App(SYSTEM.VAL(ErrLists.tErrorList,Base.ActP^.ErrorList),ActPos,ActStr);

 IF ARG.OptionEagerErrorMsgs THEN O.Ln; END; (* IF *)
END MsgDone;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE WrIdent(Ident :LONGINT);
VAR a:ARRAY 51 OF CHAR;
BEGIN (* WrIdent *)
 Base.TokenName(Ident,a); WrStr(a);
END WrIdent;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MsgI*(ErrorCode  ,
               ErrorClass :LONGINT; 
               pos        : POS.tPosition;
               InfoClass  :LONGINT; 
               Info       : SYSTEM.PTR);
TYPE tstP=POINTER TO Strings.tString;
VAR ar:ARRAY Strings.cMaxStrLength+3 OF CHAR; stP:tstP;
BEGIN (* MsgI *)
 IF ErrorCode#Base.ExpectedTokens THEN RETURN; END;

 NewMsg(pos);
 WrStr('Expected: ');

 CASE InfoClass OF
 |Base.Ident : WrStr('Errors.Ident???');
 |Base.String: stP := SYSTEM.VAL(tstP,Info); Strings.StringToArray(stP^,ar); WrStr(ar); 
 ELSE
 END; (* CASE *)

 MsgDone;
END MsgI;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE MsgPos*(msg : tErrorMsg; VAR pos : POS.tPosition);
VAR s,t:Strings.tString; a:ARRAY 101 OF CHAR;
BEGIN (* MsgPos *)
 IF msg=NoErrorMsg THEN RETURN; END;

 IF ~MessagesLoaded THEN LoadErrorMessages; END;

 IF (1<=msg) & (msg<=MaxMsg)
    THEN StringMem.GetString(Messages[msg],s);
    ELSE Strings.AssignEmpty(s);
 END; (* IF *)

 IF Strings.Length(s)=0
    THEN Strings.ArrayToString('Error #',s);
         Strings.IntToString(msg,t);
         Strings.Concatenate(s,t);
 END; (* IF *)

 Strings.StringToArray(s,a);
 NewMsg(pos);
 WrStr(a);
 MsgDone;
END MsgPos;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Msg*(Err : tError);
BEGIN (* Msg *)
 MsgPos(Err.msg,Err.pos);
END Msg;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Fatal*(msg : ARRAY OF CHAR); 
BEGIN (* Fatal *)
 O.Str('Fatal error: '); O.Str(msg); O.Ln;
 HALT(0);
END Fatal;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE ReadLine(f : IO.tFile; VAR a : ARRAY OF CHAR);
VAR i:LONGINT; c:CHAR;
BEGIN (* ReadLine *)
 i:=0;
 LOOP
  IF IO.EndOfFile(f) THEN EXIT; END;
  c:=IO.ReadC(f);
  IF c=CHR(10) THEN EXIT; END;
  IF i<=LEN(a) THEN a[i]:=c; INC(i); END;
 END; (* LOOP *)
 a[i]:=0X;
END ReadLine;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE LoadErrorMessages;
VAR s:Strings.tString; f:IO.tFile; i,p:LONGINT; a:ARRAY 201 OF CHAR; na:ARRAY 11 OF CHAR; 
BEGIN (* LoadErrorMessages *)
 Strings.AssignEmpty(s);
 FOR i:=1 TO MaxMsg DO
  Messages[i]:=StringMem.PutString(s);
 END; (* FOR *)

 IF ~BasicIO.Accessible(ErrTabName,FALSE) THEN RETURN; END;
 f:=IO.ReadOpen(ErrTabName);
 WHILE ~IO.EndOfFile(f) DO
  ReadLine(f,a);

  p:=STR.Pos(a,';');
  IF p#MAX(LONGINT) THEN a[p]:=0X; END;
  STR.DoKillLeadTrailSpaces(a);

  p:=STR.Pos(a,'"');
  IF p#MAX(LONGINT) THEN 
     STR.Slice(na,a,0,p); i:=STR.CardVal(na);
     STR.Delete(a,0,p+1);
     p:=STR.Pos(a,'"');
     IF p#MAX(LONGINT) THEN a[p]:=0X; END;
     IF (1<=i) & (i<=MaxMsg) THEN 
        Strings.ArrayToString(a,s);
        Messages[i]:=StringMem.PutString(s);
     END; (* IF *)
  END; (* IF *)
 END; (* WHILE *)
 IO.ReadClose(f);

 MessagesLoaded:=TRUE;
END LoadErrorMessages;

(*------------------------------------------------------------------------------------------------------------------------------*)
BEGIN (* ERR *)
 ErrTabName     := "Errors.Tab";
 MessagesLoaded := FALSE;
END ERR.


