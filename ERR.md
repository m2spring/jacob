DEFINITION MODULE ERR;

IMPORT POS, SYSTEM;

CONST  NoErrorMsg           =  0 ;

(*------------------------------------------------------------------------------------------------------------------------------*)
(* Vocabulary and Representation *)

MsgIllegalCharInSource      =  1 ; (* oberon.rex                                                                                *)
MsgCommentNotClosed         =  2 ; (* oberon.rex                                                                                *)
MsgIllegalIntegerConst      =  3 ; (* oberon.rex                                                                                *)
MsgIllegalRealConst         =  4 ; (* oberon.rex                                                                                *)
MsgIllegalLongrealConst     =  5 ; (* oberon.rex                                                                                *)
MsgIllegalCharConst         =  6 ; (* oberon.rex                                                                                *)
MsgStringNotTerminated      =  7 ; (* oberon.rex                                                                                *)
MsgIdentifierTooLong        =  8 ; (* oberon.rex                                                                                *)

(* Declarations and scope rules *)

MsgUndeclaredIdent          =  9 ; (* Receiver PointerToIdType UnqualifiedIdent QualifiedIdent                                  *)
MsgIdentNotExported         = 10 ; (* QualifiedIdent Importing                                                                  *)
MsgAlreadyDeclared          = 11 ; (* Import ConstDecl TypeDecl ProcDecl ForwardDecl ParId IdentList (T.pum: CheckBoundProc)    *)
MsgUndeclaredExternIdent    = 12 ; (* QualifiedIdent Importing                                                                  *)
MsgUnresolvedForwardType    = 13 ; (* (E.pum: CheckUnresolvedForwardPointers)                                                   *)
MsgUnresolvedForwardProc    = 14 ; (* (E.pum: CheckUnresolvedForwardProcs)                                                      *)

MsgConstsAlwaysReadOnly     = 15 ; (* ConstDecl                                                                                 *)
MsgTypesAlwaysReadOnly      = 16 ; (* TypeDecl                                                                                  *)
MsgProcsAlwaysReadOnly      = 17 ; (* ProcDecl ForwardDecl BoundProcDecl BoundForwardDecl                                       *)
MsgIllegalLocalExport       = 18 ; (* IdentDef                                                                                  *)

(* Types *)

MsgMissingArrayLength       = 19 ; (* OpenArrayType                                                                             *)
MsgInvalidArrayLen          = 20 ; (* ArrayExprList (oberon.pre: NewExprList)                                                   *)
MsgConstantNotInteger       = 21 ; (* ArrayExprList                                                                             *)
MsgIllegalOpenArray         = 22 ; (* NamedType (oberon.pre: SizeArgumenting)                                                   *)
MsgObjectTooBig             = 23 ; (* ArrayExprList (oberon.eva: FieldList)                                                     *)
MsgRecordTypeExpected       = 24 ; (* ExtendedType                                                                              *)
MsgWrongPointerBase         = 25 ; (* TypeDecl PointerType                                                                      *)
MsgIllegalRecursiveType     = 26 ; (* NamedType ExtendedType                                                                    *)

(* Expressions *)

MsgExprNotConstant          = 27 ; (* ConstExpr (oberon.pre: HaltArgumenting SysCcArgumenting AssertArgumenting LenArgumenting  *)
                                   (* SysGetregPutregArgumenting)                                                               *)
MsgInvalidExprType          = 28 ; (* IfStmt WhileStmt RepeatStmt NegateExpr IdentityExpr NotExpr Element InOper BoolOper       *)
                                   (* Indexing                                                                                  *)
MsgConstArithmeticError     = 29 ; (* NegateExpr NumSetOper (oberon.pre: AbsArgumenting ChrArgumenting EntierArgumenting        *)
                                   (* ShortArgumenting AshArgumenting)                                                          *)
MsgIntOutOfSet              = 30 ; (* Element (oberon.pre: ExclInclArgumenting)                                                 *)
MsgTypeTestNotApplicable    = 31 ; (* IsExpr                                                                                    *)
MsgOperatorNotApplicable    = 32 ; (* RelationOper OrderRelationOper NumSetOper                                                 *)
MsgTypeExpected             = 33 ; (* Receiver NamedType PointerType Guard IsExpr Guarding                                      *)
MsgLValueExpected           = 34 ; (* AssignStmt ExprList (oberon.pre: SysAdrArgumenting LenArgumenting DecIncArgumenting       *)
                                   (* CopyArgumenting ExclInclArgumenting SysGetArgumenting SysGetregArgumenting                *)
                                   (* SysNewArgumenting NewArgumenting)                                                         *)

(* Operands *)

MsgIdentIsNoModule          = 35 ; (* QualifiedIdent                                                                            *)
MsgModulesNotAllowed        = 36 ; (* Designator                                                                                *)
MsgTypeNotAllowed           = 37 ; (* Designator                                                                                *)
MsgRecordFieldNotFound      = 38 ; (* Selecting                                                                                 *)
MsgRecordFieldNotExported   = 39 ; (* Selecting                                                                                 *)
MsgSelectorNotApplicable    = 40 ; (* Selecting                                                                                 *)
MsgIndexNotApplicable       = 41 ; (* Indexing                                                                                  *)
MsgIndexOutOfBounds         = 42 ; (* Indexing                                                                                  *)
MsgDerefNotApplicable       = 43 ; (* Dereferencing                                                                             *)
MsgArgumentsNotAllowed      = 44 ; (* Argumenting                                                                               *)
MsgGuardNotApplicable       = 45 ; (* Guard Guarding                                                                            *)
MsgNonReceiverSupered       = 46 ; (* Supering                                                                                  *)
MsgMissingRedefined         = 47 ; (* Supering                                                                                  *)
MsgSuperingWithinRedefining = 48 ; (* Supering                                                                                  *)

(* Procedure declarations *)

MsgProcname2Incorrect       = 49 ; (* ProcDecl BoundProcDecl                                                                    *)
MsgNonMatchingActualDecl    = 50 ; (* ProcDecl (T.pum: CheckBoundProc)                                                          *)
MsgIllegalFunctionResult    = 51 ; (* FormalPars                                                                                *)

(* Formal parameters *)

MsgTooManyParams            = 52 ; (* ExprList (oberon.pre: NewExprList)                                                        *)
MsgTooFewParams             = 53 ; (* mtExprList (oberon.pre: PredeclArgumenting1 PredeclArgumenting2Opt PredeclArgumenting3    *)
                                   (* TypeArgumenting SysValArgumenting mtNewExprList)                                          *)
MsgParmNotCompatible        = 54 ; (* ExprList (oberon.pre: AbsArgumenting CapArgumenting ChrArgumenting EntierArgumenting      *)
                                   (* LongArgumenting OddArgumenting OrdArgumenting ShortArgumenting HaltArgumenting            *)
                                   (* SysCcArgumenting AssertArgumenting LenArgumenting DecIncArgumenting AshArgumenting        *)
                                   (* CopyArgumenting ExclInclArgumenting SysBitArgumenting SysLshRotArgumenting                *)
                                   (* SysGetPutArgumenting SysGetregPutregArgumenting SysNewArgumenting SysMoveArgumenting      *)
                                   (* TypeArgumenting MaxMinArgumenting NewArgumenting NewExprList)                             *)
MsgIllegalROVarPar          = 55 ; (* ExprList                                                                                  *)

(* Statements *)

MsgNotAssignCompatible      = 56 ; (* AssignStmt ForStmt                                                                        *)
MsgObjectIsReadonly         = 57 ; (* AssignStmt                                                                                *)
MsgVariableExpected         = 58 ; (* ForStmt                                                                                   *)
MsgIntegerTypeExpected      = 59 ; (* ForStmt                                                                                   *)
MsgNotCompatibleWithCtrlVar = 60 ; (* ForStmt                                                                                   *)
MsgStepMustBeNonZero        = 61 ; (* ForStmt                                                                                   *)
MsgIllegalFuncCall          = 62 ; (* DesignExpr                                                                                *)
MsgProcedureExpected        = 63 ; (* CallStmt                                                                                  *)
MsgMissingReturn            = 64 ; (* ProcDecl ReturnStmt                                                                       *)
MsgMissingReturnExpr        = 65 ; (* ReturnStmt                                                                                *)
MsgMisplacedReturnExpr      = 66 ; (* ReturnStmt                                                                                *)
MsgIncompatibleReturnExpr   = 67 ; (* ReturnStmt                                                                                *)
MsgReturnOnlyInProcs        = 68 ; (* ReturnStmt                                                                                *)
MsgIllegalCaseExpr          = 69 ; (* CaseStmt                                                                                  *)
MsgLabelNotCompatible       = 70 ; (* CaseLabel                                                                                 *)
MsgOverlappingCaseLabel     = 71 ; (* CaseLabel                                                                                 *)
MsgIllegalCaseLabelRange    = 72 ; (* CaseLabel                                                                                 *)
MsgWrongLabelType           = 73 ; (* CaseLabel                                                                                 *)
MsgExitWithoutLoop          = 74 ; (* ExitStmt                                                                                  *)

(* Type-bound procedures *)

MsgBoundProcMustBeGlobal    = 75 ; (* BoundProcDecl BoundForwardDecl                                                            *)
MsgRedefMustBeExported      = 76 ; (* BoundProcDecl BoundForwardDecl                                                            *)
MsgNonMatchingRedef         = 77 ; (* (T.pum: CheckFieldsPreRedefs)                                                             *)
MsgInvalidType              = 78 ; (* Receiver                                                                                  *)
MsgReceiverParamNotPointer  = 79 ; 

(* Modules / Importing *)

MsgModuleFilenameDiffers    = 80 ; (* Module                                                                                    *)
MsgModulename2Incorrect     = 81 ; (* Module                                                                                    *)
MsgFileNotFound             = 82 ; (* (DRV.mi: Import)                                                                          *)
MsgCyclicImport             = 83 ; (* (DRV.mi: Import)                                                                          *)

(* Others *)

MsgTooManyVars              = 84 ; (* (oberon.eva: VarDecl)                                                                     *)
MsgIllegalLenDimension      = 85 ; (* oberon.pre: LenArgumenting                                                                *)
MsgProcNestedTooDeeply      = 86 ;
MsgMaxExtLevelReached       = 87 ;
MsgMaxCaseLabelRange        = 88 ;
MaxMsg                      = 89 ;

(*------------------------------------------------------------------------------------------------------------------------------*)
(*$1*)
VAR    ErrTabName           : ARRAY [0..127] OF CHAR;
(*$1*)
TYPE   tErrorMsg            = SHORTCARD;
(*$*)
       tError               = RECORD
                               msg : tErrorMsg;
                               pos : POS.tPosition;
                              END;

PROCEDURE MsgI(ErrorCode  ,
               ErrorClass : CARDINAL;
               pos        : POS.tPosition;
               InfoClass  : CARDINAL;
               Info       : SYSTEM.ADDRESS);

PROCEDURE MsgPos(msg : tErrorMsg; VAR pos : POS.tPosition);
PROCEDURE Msg(Err : tError);
PROCEDURE Fatal(msg : ARRAY OF CHAR); 

END ERR.

