MODULE Tree;

IMPORT Base,SYSTEM,IO,Idents,LAB,OT,POS,Strings,
       OB,System,General,Memory,DynArray,Layout,StringMem,Texts,Sets,Positions;

CONST
NoTree* = NIL;

Module* = 1;
Imports* = 2;
mtImport* = 3;
Import* = 4;
DeclSection* = 5;
DeclUnits* = 6;
mtDeclUnit* = 7;
DeclUnit* = 8;
Decls* = 9;
mtDecl* = 10;
Decl* = 11;
ConstDecl* = 12;
TypeDecl* = 13;
VarDecl* = 14;
Procs* = 15;
mtProc* = 16;
Proc* = 17;
ProcDecl* = 18;
ForwardDecl* = 19;
BoundProcDecl* = 20;
BoundForwardDecl* = 21;
FormalPars* = 22;
FPSections* = 23;
mtFPSection* = 24;
FPSection* = 25;
ParIds* = 26;
mtParId* = 27;
ParId* = 28;
Receiver* = 29;
Type* = 30;
mtType* = 31;
NamedType* = 32;
ArrayType* = 33;
OpenArrayType* = 34;
RecordType* = 35;
ExtendedType* = 36;
PointerType* = 37;
PointerToIdType* = 38;
PointerToQualIdType* = 39;
PointerToStructType* = 40;
ProcedureType* = 41;
ArrayExprLists* = 42;
mtArrayExprList* = 43;
ArrayExprList* = 44;
FieldLists* = 45;
mtFieldList* = 46;
FieldList* = 47;
IdentLists* = 48;
mtIdentList* = 49;
IdentList* = 50;
Qualidents* = 51;
mtQualident* = 52;
ErrorQualident* = 53;
UnqualifiedIdent* = 54;
QualifiedIdent* = 55;
IdentDef* = 56;
Stmts* = 57;
mtStmt* = 58;
NoStmts* = 59;
Stmt* = 60;
AssignStmt* = 61;
CallStmt* = 62;
IfStmt* = 63;
CaseStmt* = 64;
WhileStmt* = 65;
RepeatStmt* = 66;
ForStmt* = 67;
LoopStmt* = 68;
WithStmt* = 69;
ExitStmt* = 70;
ReturnStmt* = 71;
Cases* = 72;
mtCase* = 73;
Case* = 74;
CaseLabels* = 75;
mtCaseLabel* = 76;
CaseLabel* = 77;
GuardedStmts* = 78;
mtGuardedStmt* = 79;
GuardedStmt* = 80;
Guard* = 81;
ConstExpr* = 82;
Exprs* = 83;
mtExpr* = 84;
MonExpr* = 85;
NegateExpr* = 86;
IdentityExpr* = 87;
NotExpr* = 88;
DyExpr* = 89;
IsExpr* = 90;
SetExpr* = 91;
DesignExpr* = 92;
SetConst* = 93;
IntConst* = 94;
RealConst* = 95;
LongrealConst* = 96;
CharConst* = 97;
StringConst* = 98;
NilConst* = 99;
Elements* = 100;
mtElement* = 101;
Element* = 102;
DyOperator* = 103;
RelationOper* = 104;
EqualOper* = 105;
UnequalOper* = 106;
OrderRelationOper* = 107;
LessOper* = 108;
LessEqualOper* = 109;
GreaterOper* = 110;
GreaterEqualOper* = 111;
InOper* = 112;
NumSetOper* = 113;
PlusOper* = 114;
MinusOper* = 115;
MultOper* = 116;
RDivOper* = 117;
IntOper* = 118;
DivOper* = 119;
ModOper* = 120;
BoolOper* = 121;
OrOper* = 122;
AndOper* = 123;
Designator* = 124;
Designors* = 125;
mtDesignor* = 126;
Designor* = 127;
Selector* = 128;
Indexor* = 129;
Dereferencor* = 130;
Argumentor* = 131;
Designations* = 132;
mtDesignation* = 133;
Designation* = 134;
Importing* = 135;
Selecting* = 136;
Indexing* = 137;
Dereferencing* = 138;
Supering* = 139;
Argumenting* = 140;
Guarding* = 141;
PredeclArgumenting* = 142;
PredeclArgumenting1* = 143;
AbsArgumenting* = 144;
CapArgumenting* = 145;
ChrArgumenting* = 146;
EntierArgumenting* = 147;
LongArgumenting* = 148;
OddArgumenting* = 149;
OrdArgumenting* = 150;
ShortArgumenting* = 151;
HaltArgumenting* = 152;
SysAdrArgumenting* = 153;
SysCcArgumenting* = 154;
PredeclArgumenting2Opt* = 155;
LenArgumenting* = 156;
AssertArgumenting* = 157;
DecIncArgumenting* = 158;
DecArgumenting* = 159;
IncArgumenting* = 160;
PredeclArgumenting2* = 161;
AshArgumenting* = 162;
CopyArgumenting* = 163;
ExclInclArgumenting* = 164;
ExclArgumenting* = 165;
InclArgumenting* = 166;
SysBitArgumenting* = 167;
SysLshRotArgumenting* = 168;
SysLshArgumenting* = 169;
SysRotArgumenting* = 170;
SysGetPutArgumenting* = 171;
SysGetArgumenting* = 172;
SysPutArgumenting* = 173;
SysGetregPutregArgumenting* = 174;
SysGetregArgumenting* = 175;
SysPutregArgumenting* = 176;
SysNewArgumenting* = 177;
PredeclArgumenting3* = 178;
SysMoveArgumenting* = 179;
TypeArgumenting* = 180;
MaxMinArgumenting* = 181;
MaxArgumenting* = 182;
MinArgumenting* = 183;
SizeArgumenting* = 184;
SysValArgumenting* = 185;
NewArgumenting* = 186;
SysAsmArgumenting* = 187;
ExprLists* = 188;
mtExprList* = 189;
ExprList* = 190;
NewExprLists* = 191;
mtNewExprList* = 192;
NewExprList* = 193;
SysAsmExprLists* = 194;
mtSysAsmExprList* = 195;
SysAsmExprList* = 196;

TYPE tTree* = POINTER TO yyNode;
tProcTree* = PROCEDURE (t:tTree);
(* line 14 "oberon.aecp" *)
 TYPE   tIdent*         = Idents.tIdent  ;                            (* These types are re-declared due to the fact that *)
               tParMode*       = Base.tParMode    ;                            (* qualidents are illegal in an ast specification.  *)
               tExportMode*    = Base.tExportMode ;
               oCHAR*          = OT.oCHAR       ;
               oSTRING*        = OT.oSTRING     ;
               oLONGINT*       = OT.oLONGINT    ;
               oREAL*          = OT.oREAL       ;
               oLONGREAL*      = OT.oLONGREAL   ;
               oSET*           = OT.oSET        ;
               tPosition*      = POS.tPosition  ;

        VAR    cmtDesignation* : tTree          ; 
(* line 664 "oberon.aecp" *)
 TYPE   tErrorMsg*        = Base.tErrorMsg ;                     (* These types are re-declared due to the fact that       *)
               tLevel*           = Base.tLevel     ;                     (* qualidents are  illegal in an evaluator specification. *)
               tSize*            = Base.tSize      ;                     (* They are used for attribute types and must therefore   *)
               tAddress*         = Base.tAddress   ;                     (* be known in the abstract syntax tree specification.    *)
               tOB*              = OB.tOB        ;                     
               tCoercion*        = tOB        ; 
               tLabel*           = LAB.T         ; 




TYPE
yytNodeHead* = RECORD yyKind*, yyMark*: INTEGER;   END;
yModule* = RECORD yyHead*: yytNodeHead; Name*: tIdent; Pos*: tPosition; IsForeign*: BOOLEAN; Imports*: tTree; DeclSection*: tTree; Stmts*: tTree; Name2*: tIdent; Pos2*: tPosition; GlobalSpace*: tSize; TempSpace*: tSize; Globals*: tOB; TDescList*: tOB; ModuleEntry*: tOB; env*: tOB; END;
yImports* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; END;
ymtImport* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; END;
yImport* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; Next*: tTree; ServerId*: tIdent; ServerPos*: tPosition; RefId*: tIdent; RefPos*: tPosition; ServerTable*: tOB; ErrorMsg*: INTEGER; END;
yDeclSection* = RECORD yyHead*: yytNodeHead; DeclUnits*: tTree; Procs*: tTree; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yDeclUnits* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
ymtDeclUnit* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yDeclUnit* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; Decls*: tTree; END;
yDecls* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
ymtDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; END;
yConstDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; IdentDef*: tTree; ConstExpr*: tTree; Entry*: tOB; TableTmp*: tOB; label*: tLabel; END;
yTypeDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; IdentDef*: tTree; Type*: tTree; TableTmp*: tOB; ForwardedEntry*: tOB; ForwardedPos*: tPosition; TypeEntry*: tOB; END;
yVarDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; LabelPrefixIn*: tLabel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; IdentLists*: tTree; Type*: tTree; END;
yProcs* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
ymtProc* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yProc* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; END;
yProcDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; IdentDef*: tTree; FormalPars*: tTree; DeclSection*: tTree; Stmts*: tTree; EndPos*: tPosition; Ident*: tIdent; IdPos*: tPosition; Entry*: tOB; LocalSpace*: tSize; TempSpace*: tSize; Locals*: tOB; AlreadyDeclEntry*: tOB; ForwardedProcEntry*: tOB; IsUndeclared*: BOOLEAN; TableTmp*: tOB; ProcTypeRepr*: tOB; paramSpace*: tSize; label*: tLabel; env*: tOB; END;
yForwardDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; IdentDef*: tTree; FormalPars*: tTree; TableTmp*: tOB; paramSpace*: tSize; label*: tLabel; END;
yBoundProcDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; Receiver*: tTree; IdentDef*: tTree; FormalPars*: tTree; DeclSection*: tTree; Stmts*: tTree; EndPos*: tPosition; Ident*: tIdent; IdPos*: tPosition; Entry*: tOB; LocalSpace*: tSize; TempSpace*: tSize; Locals*: tOB; ReceiverTypeRepr*: tOB; ProcTypeRepr*: tOB; AlreadyExistingField*: tOB; CurrBProcEntry*: tOB; ErrorMsg*: tErrorMsg; paramSpace*: tSize; label*: tLabel; typeident*: tIdent; env*: tOB; END;
yBoundForwardDecl* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; LevelIn*: tLevel; LabelPrefixIn*: tLabel; NamePathIn*: tOB; NamePath*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; Receiver*: tTree; IdentDef*: tTree; FormalPars*: tTree; ReceiverTypeRepr*: tOB; ProcTypeRepr*: tOB; AlreadyExistingField*: tOB; ErrorMsg*: tErrorMsg; paramSpace*: tSize; label*: tLabel; END;
yFormalPars* = RECORD yyHead*: yytNodeHead; FPSections*: tTree; Type*: tTree; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; SignatureReprOut*: tOB; ResultTypeReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yFPSections* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; SignatureReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
ymtFPSection* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; SignatureReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yFPSection* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; SignatureReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; ParMode*: tParMode; ParIds*: tTree; Type*: tTree; END;
yParIds* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; Table1In*: tOB; Table1Out*: tOB; ParModeIn*: tParMode; TypeReprIn*: tOB; Table2In*: tOB; Table2Out*: tOB; SignatureReprIn*: tOB; SignatureReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; EnvIn*: tOB; END;
ymtParId* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; Table1In*: tOB; Table1Out*: tOB; ParModeIn*: tParMode; TypeReprIn*: tOB; Table2In*: tOB; Table2Out*: tOB; SignatureReprIn*: tOB; SignatureReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; EnvIn*: tOB; END;
yParId* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; Table1In*: tOB; Table1Out*: tOB; ParModeIn*: tParMode; TypeReprIn*: tOB; Table2In*: tOB; Table2Out*: tOB; SignatureReprIn*: tOB; SignatureReprOut*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; EnvIn*: tOB; Next*: tTree; Ident*: tIdent; Pos*: tPosition; AddrOfPar*: tAddress; RefMode*: tParMode; END;
yReceiver* = RECORD yyHead*: yytNodeHead; ParMode*: tParMode; Name*: tIdent; TypeIdent*: tIdent; TypePos*: tPosition; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; TypeReprOut*: tOB; SignatureOut*: tOB; TableTmp*: tOB; Entry*: tOB; EntryTypeRepr*: tOB; LevelIn*: tLevel; ParAddrIn*: tAddress; ParAddrOut*: tAddress; AddrOfPar*: tAddress; RefMode*: tParMode; END;
yType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
ymtType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yNamedType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Qualidents*: tTree; END;
yArrayType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; ArrayExprLists*: tTree; Type*: tTree; END;
yOpenArrayType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; OfPosition*: tPosition; Type*: tTree; END;
yRecordType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; FieldLists*: tTree; END;
yExtendedType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Qualidents*: tTree; FieldLists*: tTree; BaseTypeRepr*: tOB; extLevel*: tLevel; END;
yPointerType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; BaseTypeEntry*: tOB; BaseTypePos*: tPosition; END;
yPointerToIdType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; BaseTypeEntry*: tOB; BaseTypePos*: tPosition; Ident*: tIdent; IdentPos*: tPosition; END;
yPointerToQualIdType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; BaseTypeEntry*: tOB; BaseTypePos*: tPosition; Qualidents*: tTree; END;
yPointerToStructType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; BaseTypeEntry*: tOB; BaseTypePos*: tPosition; Type*: tTree; END;
yProcedureType* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; FirstTypeReprOut*: tOB; TableIn*: tOB; TableOut*: tOB; ForwardPBaseIsOkIn*: BOOLEAN; OpenArrayIsOkIn*: BOOLEAN; IsVarParTypeIn*: BOOLEAN; TypeReprOut*: tOB; LevelIn*: tLevel; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; FormalPars*: tTree; paramSpace*: tSize; END;
yArrayExprLists* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ElemTypeReprIn*: tOB; TypeReprOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; END;
ymtArrayExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ElemTypeReprIn*: tOB; TypeReprOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; END;
yArrayExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ElemTypeReprIn*: tOB; TypeReprOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; Next*: tTree; ConstExpr*: tTree; Len*: oLONGINT; ElemSize*: tSize; TypeSize*: tSize; END;
yFieldLists* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; FieldTableIn*: tOB; FieldTableOut*: tOB; LevelIn*: tLevel; SizeIn*: tSize; SizeOut*: tSize; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
ymtFieldList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; FieldTableIn*: tOB; FieldTableOut*: tOB; LevelIn*: tLevel; SizeIn*: tSize; SizeOut*: tSize; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; END;
yFieldList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; FieldTableIn*: tOB; FieldTableOut*: tOB; LevelIn*: tLevel; SizeIn*: tSize; SizeOut*: tSize; NamePathIn*: tOB; TDescListIn*: tOB; EnvIn*: tOB; Next*: tTree; IdentLists*: tTree; Type*: tTree; END;
yIdentLists* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; Table1In*: tOB; Table1Out*: tOB; TooBigMsg*: tErrorMsg; Table2In*: tOB; Table2Out*: tOB; TypeReprIn*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; SizeIn*: tSize; SizeOut*: tSize; EnvIn*: tOB; END;
ymtIdentList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; Table1In*: tOB; Table1Out*: tOB; TooBigMsg*: tErrorMsg; Table2In*: tOB; Table2Out*: tOB; TypeReprIn*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; SizeIn*: tSize; SizeOut*: tSize; EnvIn*: tOB; END;
yIdentList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; Table1In*: tOB; Table1Out*: tOB; TooBigMsg*: tErrorMsg; Table2In*: tOB; Table2Out*: tOB; TypeReprIn*: tOB; LevelIn*: tLevel; VarAddrIn*: tAddress; VarAddrOut*: tAddress; SizeIn*: tSize; SizeOut*: tSize; EnvIn*: tOB; Next*: tTree; IdentDef*: tTree; AlreadyDeclaredEntry*: tOB; ItemSize*: tSize; AddrOfVar*: tAddress; END;
yQualidents* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; TableIn*: tOB; EntryOut*: tOB; END;
ymtQualident* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; TableIn*: tOB; EntryOut*: tOB; END;
yErrorQualident* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; TableIn*: tOB; EntryOut*: tOB; END;
yUnqualifiedIdent* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; TableIn*: tOB; EntryOut*: tOB; Ident*: tIdent; END;
yQualifiedIdent* = RECORD yyHead*: yytNodeHead; Position*: tPosition; ModuleIn*: tOB; TableIn*: tOB; EntryOut*: tOB; ServerId*: tIdent; Ident*: tIdent; IdentPos*: tPosition; ServerEntry*: tOB; isExistingServer*: BOOLEAN; isDeclared*: BOOLEAN; isServerEntry*: BOOLEAN; END;
yIdentDef* = RECORD yyHead*: yytNodeHead; Ident*: tIdent; Pos*: tPosition; ExportMode*: tExportMode; LevelIn*: tLevel; END;
yStmts* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
ymtStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
yNoStmts* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
yStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; END;
yAssignStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Designator*: tTree; Exprs*: tTree; Coerce*: tCoercion; VarTypeRepr*: tOB; END;
yCallStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Designator*: tTree; END;
yIfStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Exprs*: tTree; Then*: tTree; Else*: tTree; END;
yCaseStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Exprs*: tTree; Cases*: tTree; Else*: tTree; LabelLimits*: tOB; END;
yWhileStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Exprs*: tTree; Stmts*: tTree; END;
yRepeatStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Stmts*: tTree; Exprs*: tTree; END;
yForStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Ident*: tIdent; Pos*: tPosition; From*: tTree; To*: tTree; By*: tTree; Stmts*: tTree; CurLevel*: tLevel; ControlVarEntry*: tOB; TempAddr*: tAddress; FromCoerce*: tCoercion; ToCoerce*: tCoercion; ControlVarTypeRepr*: tOB; END;
yLoopStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Stmts*: tTree; LoopEndLabel*: tLabel; END;
yWithStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; GuardedStmts*: tTree; Else*: tTree; END;
yExitStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Position*: tPosition; LoopEndLabel*: tLabel; END;
yReturnStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Position*: tPosition; Exprs*: tTree; Coerce*: tCoercion; END;
yCases* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; CaseTypeReprIn*: tOB; LabelRangeIn*: tOB; LabelLimitsIn*: tOB; LabelLimitsOut*: tOB; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
ymtCase* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; CaseTypeReprIn*: tOB; LabelRangeIn*: tOB; LabelLimitsIn*: tOB; LabelLimitsOut*: tOB; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
yCase* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; CaseTypeReprIn*: tOB; LabelRangeIn*: tOB; LabelLimitsIn*: tOB; LabelLimitsOut*: tOB; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; CaseLabels*: tTree; Stmts*: tTree; END;
yCaseLabels* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; CaseTypeReprIn*: tOB; LabelRangeIn*: tOB; LabelRangeOut*: tOB; LabelLimitsIn*: tOB; LabelLimitsOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; END;
ymtCaseLabel* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; CaseTypeReprIn*: tOB; LabelRangeIn*: tOB; LabelRangeOut*: tOB; LabelLimitsIn*: tOB; LabelLimitsOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; END;
yCaseLabel* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; CaseTypeReprIn*: tOB; LabelRangeIn*: tOB; LabelRangeOut*: tOB; LabelLimitsIn*: tOB; LabelLimitsOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; Next*: tTree; ConstExpr1*: tTree; ConstExpr2*: tTree; END;
yGuardedStmts* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
ymtGuardedStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; END;
yGuardedStmt* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ResultTypeReprIn*: tOB; ReturnExistsOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; LoopEndLabelIn*: tLabel; EnvIn*: tOB; Next*: tTree; Guard*: tTree; Stmts*: tTree; CurLevel*: tLevel; END;
yGuard* = RECORD yyHead*: yytNodeHead; Variable*: tTree; OpPos*: tPosition; TypeId*: tTree; VarEntry*: tOB; TypeTypeRepr*: tOB; ModuleIn*: tOB; TableIn*: tOB; TableOut*: tOB; VarTypeRepr*: tOB; END;
yConstExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Expr*: tTree; ModuleIn*: tOB; TableIn*: tOB; TypeReprOut*: tOB; ValueReprOut*: tOB; LevelIn*: tLevel; EnvIn*: tOB; END;
yExprs* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; END;
ymtExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; END;
yMonExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Exprs*: tTree; END;
yNegateExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Exprs*: tTree; END;
yIdentityExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Exprs*: tTree; END;
yNotExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Exprs*: tTree; END;
yDyExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; DyOperator*: tTree; Expr1*: tTree; Expr2*: tTree; END;
yIsExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Designator*: tTree; OpPos*: tPosition; TypeId*: tTree; TypeTypeRepr*: tOB; END;
ySetExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Elements*: tTree; ConstValueRepr*: tOB; END;
yDesignExpr* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Designator*: tTree; Entry*: tOB; END;
ySetConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Set*: oSET; END;
yIntConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Int*: oLONGINT; END;
yRealConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Real*: oREAL; END;
yLongrealConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Longreal*: oLONGREAL; END;
yCharConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; Char*: oCHAR; END;
yStringConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; String*: oSTRING; END;
yNilConst* = RECORD yyHead*: yytNodeHead; Position*: tPosition; TypeReprOut*: tOB; ValueReprOut*: tOB; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; EntryOut*: tOB; IsLValueOut*: BOOLEAN; IsWritableOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; END;
yElements* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; ValueReprOut*: tOB; IsConstOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; END;
ymtElement* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; ValueReprOut*: tOB; IsConstOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; END;
yElement* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; ValueReprOut*: tOB; IsConstOut*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; Next*: tTree; Expr1*: tTree; Expr2*: tTree; END;
yDyOperator* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; END;
yRelationOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yEqualOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yUnequalOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yOrderRelationOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yLessOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yLessEqualOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yGreaterOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yGreaterEqualOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; END;
yInOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; END;
yNumSetOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yPlusOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yMinusOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yMultOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yRDivOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yIntOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yDivOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yModOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; TypeReprTmp*: tOB; calculationSuccess*: BOOLEAN; END;
yBoolOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; END;
yOrOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; END;
yAndOper* = RECORD yyHead*: yytNodeHead; Position*: tPosition; Operator*: INTEGER; Coerce1*: tCoercion; Coerce2*: tCoercion; TypeRepr1In*: tOB; ValueRepr1In*: tOB; Expr1PosIn*: tPosition; TypeRepr2In*: tOB; ValueRepr2In*: tOB; Expr2PosIn*: tPosition; ValDontCareIn*: BOOLEAN; ValDontCareOut*: BOOLEAN; TypeReprOut*: tOB; ValueReprOut*: tOB; END;
yDesignator* = RECORD yyHead*: yytNodeHead; Ident*: tIdent; Position*: tPosition; Designors*: tTree; Designations*: tTree; TypeReprOut*: tOB; Entry*: tOB; LevelIn*: tLevel; SignatureRepr*: tOB; ExprList*: tTree; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; EntryOut*: tOB; ValueReprOut*: tOB; IsWritableOut*: BOOLEAN; typeRepr*: tOB; valueRepr*: tOB; endPos*: tPosition; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryOut*: tOB; EnvIn*: tOB; END;
yDesignors* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; END;
ymtDesignor* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; END;
yDesignor* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; Nextor*: tTree; END;
ySelector* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; Nextor*: tTree; OpPos*: tPosition; Ident*: tIdent; IdPos*: tPosition; END;
yIndexor* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; Nextor*: tTree; Op1Pos*: tPosition; Op2Pos*: tPosition; ExprList*: tTree; END;
yDereferencor* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; Nextor*: tTree; OpPos*: tPosition; END;
yArgumentor* = RECORD yyHead*: yytNodeHead; LevelIn*: tLevel; EnvIn*: tOB; Nextor*: tTree; Op1Pos*: tPosition; Op2Pos*: tPosition; ExprList*: tTree; END;
yDesignations* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; END;
ymtDesignation* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; END;
yDesignation* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; END;
yImporting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Ident*: tIdent; IdPos*: tPosition; typeRepr*: tOB; endPos*: tPosition; END;
ySelecting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Ident*: tIdent; IdPos*: tPosition; typeRepr*: tOB; endPos*: tPosition; END;
yIndexing* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; Expr*: tTree; Len*: oLONGINT; ElemTypeRepr*: tOB; endPos*: tPosition; END;
yDereferencing* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; BaseTypeRepr*: tOB; END;
ySupering* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; RcvEntry*: tOB; baseTypeRepr*: tOB; endPos*: tPosition; isReceiver*: BOOLEAN; END;
yArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; ExprList*: tTree; ProcTypeRepr*: tOB; RcvEntry*: tOB; signature*: tOB; isBoundProc*: BOOLEAN; END;
yGuarding* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; IsImplicit*: BOOLEAN; Qualidents*: tTree; StaticTypeRepr*: tOB; TestTypeRepr*: tOB; END;
yPredeclArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; END;
yPredeclArgumenting1* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
yAbsArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; OK*: BOOLEAN; END;
yCapArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
yChrArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; OK*: BOOLEAN; END;
yEntierArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; OK*: BOOLEAN; END;
yLongArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
yOddArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
yOrdArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
yShortArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; OK*: BOOLEAN; END;
yHaltArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
ySysAdrArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
ySysCcArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; ExprLists*: tTree; END;
yPredeclArgumenting2Opt* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yLenArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yAssertArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yDecIncArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yDecArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yIncArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yPredeclArgumenting2* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yAshArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; OK*: BOOLEAN; END;
yCopyArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yExclInclArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yExclArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
yInclArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysBitArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysLshRotArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysLshArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysRotArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysGetPutArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysGetArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysPutArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysGetregPutregArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysGetregArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysPutregArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; END;
ySysNewArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; ExprLists*: tTree; Coerce1*: tCoercion; Coerce2*: tCoercion; areEnoughParameters*: BOOLEAN; isEmptyExpr2*: BOOLEAN; pointerBaseType*: tOB; END;
yPredeclArgumenting3* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; Expr3*: tTree; ExprLists*: tTree; Coerce3*: tCoercion; END;
ySysMoveArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr1*: tTree; Expr2*: tTree; Expr3*: tTree; ExprLists*: tTree; Coerce3*: tCoercion; END;
yTypeArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Qualidents*: tTree; ExprLists*: tTree; argTypeRepr*: tOB; END;
yMaxMinArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Qualidents*: tTree; ExprLists*: tTree; argTypeRepr*: tOB; END;
yMaxArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Qualidents*: tTree; ExprLists*: tTree; argTypeRepr*: tOB; END;
yMinArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Qualidents*: tTree; ExprLists*: tTree; argTypeRepr*: tOB; END;
ySizeArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Qualidents*: tTree; ExprLists*: tTree; argTypeRepr*: tOB; END;
ySysValArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Qualidents*: tTree; ExprLists*: tTree; argTypeRepr*: tOB; Expr*: tTree; TypeTypeRepr*: tOB; TempAddr*: tAddress; END;
yNewArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; Expr*: tTree; NewExprLists*: tTree; END;
ySysAsmArgumenting* = RECORD yyHead*: yytNodeHead; Entry*: tOB; LevelIn*: tLevel; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; IsCallDesignatorIn*: BOOLEAN; PrevEntryIn*: tOB; EntryPosition*: tPosition; EntryIn*: tOB; EntryOut*: tOB; TypeReprIn*: tOB; TypeReprOut*: tOB; ValueReprIn*: tOB; ValueReprOut*: tOB; IsWritableIn*: BOOLEAN; IsWritableOut*: BOOLEAN; SignatureReprOut*: tOB; ExprListOut*: tTree; TempOfsIn*: tAddress; TempOfsOut*: tAddress; MainEntryIn*: tOB; MainEntryOut*: tOB; EnvIn*: tOB; Nextor*: tTree; Position*: tPosition; Nextion*: tTree; Op2Pos*: tPosition; typeRepr*: tOB; valueRepr*: tOB; SysAsmExprLists*: tTree; END;
yExprLists* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; SignatureIn*: tOB; ClosingPosIn*: tPosition; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; END;
ymtExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; SignatureIn*: tOB; ClosingPosIn*: tPosition; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; END;
yExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; SignatureIn*: tOB; ClosingPosIn*: tPosition; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; Next*: tTree; Expr*: tTree; Coerce*: tCoercion; parMode*: tParMode; formalTypeRepr*: tOB; IsLValueOK*: BOOLEAN; END;
yNewExprLists* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; TypeReprIn*: tOB; ClosingPosIn*: tPosition; END;
ymtNewExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; TypeReprIn*: tOB; ClosingPosIn*: tPosition; END;
yNewExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; LevelIn*: tLevel; TempOfsIn*: tAddress; TempOfsOut*: tAddress; EnvIn*: tOB; TypeReprIn*: tOB; ClosingPosIn*: tPosition; Next*: tTree; Expr*: tTree; Coerce*: tCoercion; END;
ySysAsmExprLists* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; LevelIn*: tLevel; EnvIn*: tOB; END;
ymtSysAsmExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; LevelIn*: tLevel; EnvIn*: tOB; END;
ySysAsmExprList* = RECORD yyHead*: yytNodeHead; ModuleIn*: tOB; TableIn*: tOB; ValDontCareIn*: BOOLEAN; LevelIn*: tLevel; EnvIn*: tOB; Next*: tTree; Expr*: tTree; END;

yyNode* = RECORD
Kind*: INTEGER;
yyHead*: yytNodeHead;
Module*: yModule;
Imports*: yImports;
mtImport*: ymtImport;
Import*: yImport;
DeclSection*: yDeclSection;
DeclUnits*: yDeclUnits;
mtDeclUnit*: ymtDeclUnit;
DeclUnit*: yDeclUnit;
Decls*: yDecls;
mtDecl*: ymtDecl;
Decl*: yDecl;
ConstDecl*: yConstDecl;
TypeDecl*: yTypeDecl;
VarDecl*: yVarDecl;
Procs*: yProcs;
mtProc*: ymtProc;
Proc*: yProc;
ProcDecl*: yProcDecl;
ForwardDecl*: yForwardDecl;
BoundProcDecl*: yBoundProcDecl;
BoundForwardDecl*: yBoundForwardDecl;
FormalPars*: yFormalPars;
FPSections*: yFPSections;
mtFPSection*: ymtFPSection;
FPSection*: yFPSection;
ParIds*: yParIds;
mtParId*: ymtParId;
ParId*: yParId;
Receiver*: yReceiver;
Type*: yType;
mtType*: ymtType;
NamedType*: yNamedType;
ArrayType*: yArrayType;
OpenArrayType*: yOpenArrayType;
RecordType*: yRecordType;
ExtendedType*: yExtendedType;
PointerType*: yPointerType;
PointerToIdType*: yPointerToIdType;
PointerToQualIdType*: yPointerToQualIdType;
PointerToStructType*: yPointerToStructType;
ProcedureType*: yProcedureType;
ArrayExprLists*: yArrayExprLists;
mtArrayExprList*: ymtArrayExprList;
ArrayExprList*: yArrayExprList;
FieldLists*: yFieldLists;
mtFieldList*: ymtFieldList;
FieldList*: yFieldList;
IdentLists*: yIdentLists;
mtIdentList*: ymtIdentList;
IdentList*: yIdentList;
Qualidents*: yQualidents;
mtQualident*: ymtQualident;
ErrorQualident*: yErrorQualident;
UnqualifiedIdent*: yUnqualifiedIdent;
QualifiedIdent*: yQualifiedIdent;
IdentDef*: yIdentDef;
Stmts*: yStmts;
mtStmt*: ymtStmt;
NoStmts*: yNoStmts;
Stmt*: yStmt;
AssignStmt*: yAssignStmt;
CallStmt*: yCallStmt;
IfStmt*: yIfStmt;
CaseStmt*: yCaseStmt;
WhileStmt*: yWhileStmt;
RepeatStmt*: yRepeatStmt;
ForStmt*: yForStmt;
LoopStmt*: yLoopStmt;
WithStmt*: yWithStmt;
ExitStmt*: yExitStmt;
ReturnStmt*: yReturnStmt;
Cases*: yCases;
mtCase*: ymtCase;
Case*: yCase;
CaseLabels*: yCaseLabels;
mtCaseLabel*: ymtCaseLabel;
CaseLabel*: yCaseLabel;
GuardedStmts*: yGuardedStmts;
mtGuardedStmt*: ymtGuardedStmt;
GuardedStmt*: yGuardedStmt;
Guard*: yGuard;
ConstExpr*: yConstExpr;
Exprs*: yExprs;
mtExpr*: ymtExpr;
MonExpr*: yMonExpr;
NegateExpr*: yNegateExpr;
IdentityExpr*: yIdentityExpr;
NotExpr*: yNotExpr;
DyExpr*: yDyExpr;
IsExpr*: yIsExpr;
SetExpr*: ySetExpr;
DesignExpr*: yDesignExpr;
SetConst*: ySetConst;
IntConst*: yIntConst;
RealConst*: yRealConst;
LongrealConst*: yLongrealConst;
CharConst*: yCharConst;
StringConst*: yStringConst;
NilConst*: yNilConst;
Elements*: yElements;
mtElement*: ymtElement;
Element*: yElement;
DyOperator*: yDyOperator;
RelationOper*: yRelationOper;
EqualOper*: yEqualOper;
UnequalOper*: yUnequalOper;
OrderRelationOper*: yOrderRelationOper;
LessOper*: yLessOper;
LessEqualOper*: yLessEqualOper;
GreaterOper*: yGreaterOper;
GreaterEqualOper*: yGreaterEqualOper;
InOper*: yInOper;
NumSetOper*: yNumSetOper;
PlusOper*: yPlusOper;
MinusOper*: yMinusOper;
MultOper*: yMultOper;
RDivOper*: yRDivOper;
IntOper*: yIntOper;
DivOper*: yDivOper;
ModOper*: yModOper;
BoolOper*: yBoolOper;
OrOper*: yOrOper;
AndOper*: yAndOper;
Designator*: yDesignator;
Designors*: yDesignors;
mtDesignor*: ymtDesignor;
Designor*: yDesignor;
Selector*: ySelector;
Indexor*: yIndexor;
Dereferencor*: yDereferencor;
Argumentor*: yArgumentor;
Designations*: yDesignations;
mtDesignation*: ymtDesignation;
Designation*: yDesignation;
Importing*: yImporting;
Selecting*: ySelecting;
Indexing*: yIndexing;
Dereferencing*: yDereferencing;
Supering*: ySupering;
Argumenting*: yArgumenting;
Guarding*: yGuarding;
PredeclArgumenting*: yPredeclArgumenting;
PredeclArgumenting1*: yPredeclArgumenting1;
AbsArgumenting*: yAbsArgumenting;
CapArgumenting*: yCapArgumenting;
ChrArgumenting*: yChrArgumenting;
EntierArgumenting*: yEntierArgumenting;
LongArgumenting*: yLongArgumenting;
OddArgumenting*: yOddArgumenting;
OrdArgumenting*: yOrdArgumenting;
ShortArgumenting*: yShortArgumenting;
HaltArgumenting*: yHaltArgumenting;
SysAdrArgumenting*: ySysAdrArgumenting;
SysCcArgumenting*: ySysCcArgumenting;
PredeclArgumenting2Opt*: yPredeclArgumenting2Opt;
LenArgumenting*: yLenArgumenting;
AssertArgumenting*: yAssertArgumenting;
DecIncArgumenting*: yDecIncArgumenting;
DecArgumenting*: yDecArgumenting;
IncArgumenting*: yIncArgumenting;
PredeclArgumenting2*: yPredeclArgumenting2;
AshArgumenting*: yAshArgumenting;
CopyArgumenting*: yCopyArgumenting;
ExclInclArgumenting*: yExclInclArgumenting;
ExclArgumenting*: yExclArgumenting;
InclArgumenting*: yInclArgumenting;
SysBitArgumenting*: ySysBitArgumenting;
SysLshRotArgumenting*: ySysLshRotArgumenting;
SysLshArgumenting*: ySysLshArgumenting;
SysRotArgumenting*: ySysRotArgumenting;
SysGetPutArgumenting*: ySysGetPutArgumenting;
SysGetArgumenting*: ySysGetArgumenting;
SysPutArgumenting*: ySysPutArgumenting;
SysGetregPutregArgumenting*: ySysGetregPutregArgumenting;
SysGetregArgumenting*: ySysGetregArgumenting;
SysPutregArgumenting*: ySysPutregArgumenting;
SysNewArgumenting*: ySysNewArgumenting;
PredeclArgumenting3*: yPredeclArgumenting3;
SysMoveArgumenting*: ySysMoveArgumenting;
TypeArgumenting*: yTypeArgumenting;
MaxMinArgumenting*: yMaxMinArgumenting;
MaxArgumenting*: yMaxArgumenting;
MinArgumenting*: yMinArgumenting;
SizeArgumenting*: ySizeArgumenting;
SysValArgumenting*: ySysValArgumenting;
NewArgumenting*: yNewArgumenting;
SysAsmArgumenting*: ySysAsmArgumenting;
ExprLists*: yExprLists;
mtExprList*: ymtExprList;
ExprList*: yExprList;
NewExprLists*: yNewExprLists;
mtNewExprList*: ymtNewExprList;
NewExprList*: yNewExprList;
SysAsmExprLists*: ySysAsmExprLists;
mtSysAsmExprList*: ymtSysAsmExprList;
SysAsmExprList*: ySysAsmExprList;
END;

VAR TreeRoot*	: tTree;
VAR HeapUsed*	: LONGINT; 
VAR yyPoolFreePtr*, yyPoolMaxPtr*	:LONGINT; 
VAR yyNodeSize*	: ARRAY 197 OF INTEGER;
VAR yyExit*	: PROCEDURE;

CONST yyBlockSize = 20480;

TYPE
 yytBlockPtr	= POINTER TO yytBlock;
 yytBlock	= RECORD
		     yyBlock	: ARRAY yyBlockSize+2 OF CHAR;
		     yySuccessor: yytBlockPtr;
		  END;

VAR yyBlockList	: yytBlockPtr;
VAR yyMaxSize, yyi	:LONGINT; 
VAR yyTypeRange	: ARRAY 197 OF LONGINT; 

TYPE yyPtrtTree	= POINTER TO ARRAY 1 OF tTree;

VAR yyf	: IO.tFile;
VAR yyLabel	:INTEGER; 
VAR yyKind	:INTEGER; 
VAR yyc	: CHAR;
VAR yys	: Strings.tString;

CONST yyNil	= 0FCX;
CONST yyNoLabel	= 0FDX;
CONST yyLabelDef	= 0FEX;
CONST yyLabelUse	= 0FFX;

PROCEDURE yyAlloc* (): tTree;
 VAR yyBlockPtr	: yytBlockPtr;
 BEGIN
  yyBlockPtr	:= yyBlockList;
  yyBlockList	:= SYSTEM.VAL(yytBlockPtr,Memory.Alloc (SIZE (yytBlock)));
  yyBlockList^.yySuccessor := yyBlockPtr;
  yyPoolFreePtr	:= SYSTEM.ADR (yyBlockList^.yyBlock);
  yyPoolMaxPtr	:= yyPoolFreePtr + yyBlockSize - yyMaxSize + 1;
  INC (HeapUsed, yyBlockSize);
  RETURN SYSTEM.VAL(tTree,yyPoolFreePtr);
 END yyAlloc;

PROCEDURE MakeTree* (yyKind:INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [yyKind] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := yyKind;
  RETURN yyt;
 END MakeTree;

PROCEDURE IsType* (yyTree: tTree; yyKind:INTEGER): BOOLEAN;
 BEGIN
  RETURN (yyTree # NoTree) & (yyKind <= yyTree^.Kind) & (yyTree^.Kind <= yyTypeRange [yyKind]);
 END IsType;


PROCEDURE mModule* (pName: tIdent; pPos: tPosition; pIsForeign: BOOLEAN; pImports: tTree; pDeclSection: tTree; pStmts: tTree; pName2: tIdent; pPos2: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Module] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Module;
   yyt^.Module.Name := pName;
   yyt^.Module.Pos := pPos;
   yyt^.Module.IsForeign := pIsForeign;
   yyt^.Module.Imports := pImports;
   yyt^.Module.DeclSection := pDeclSection;
   yyt^.Module.Stmts := pStmts;
   yyt^.Module.Name2 := pName2;
   yyt^.Module.Pos2 := pPos2;
    
    
    
    
    
    
  RETURN yyt;
 END mModule;

PROCEDURE mImports* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Imports] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Imports;
  RETURN yyt;
 END mImports;

PROCEDURE mmtImport* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtImport] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtImport;
  RETURN yyt;
 END mmtImport;

PROCEDURE mImport* (pNext: tTree; pServerId: tIdent; pServerPos: tPosition; pRefId: tIdent; pRefPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Import] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Import;
    
    
    
   yyt^.Import.Next := pNext;
   yyt^.Import.ServerId := pServerId;
   yyt^.Import.ServerPos := pServerPos;
   yyt^.Import.RefId := pRefId;
   yyt^.Import.RefPos := pRefPos;
    
    
  RETURN yyt;
 END mImport;

PROCEDURE mDeclSection* (pDeclUnits: tTree; pProcs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DeclSection] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DeclSection;
   yyt^.DeclSection.DeclUnits := pDeclUnits;
   yyt^.DeclSection.Procs := pProcs;
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mDeclSection;

PROCEDURE mDeclUnits* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DeclUnits] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DeclUnits;
  RETURN yyt;
 END mDeclUnits;

PROCEDURE mmtDeclUnit* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtDeclUnit] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtDeclUnit;
  RETURN yyt;
 END mmtDeclUnit;

PROCEDURE mDeclUnit* (pNext: tTree; pDecls: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DeclUnit] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DeclUnit;
    
    
    
    
    
    
    
    
    
    
   yyt^.DeclUnit.Next := pNext;
   yyt^.DeclUnit.Decls := pDecls;
  RETURN yyt;
 END mDeclUnit;

PROCEDURE mDecls* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Decls] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Decls;
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mDecls;

PROCEDURE mmtDecl* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtDecl;
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtDecl;

PROCEDURE mDecl* (pNext: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Decl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Decl;
    
    
    
    
    
    
    
    
    
    
   yyt^.Decl.Next := pNext;
  RETURN yyt;
 END mDecl;

PROCEDURE mConstDecl* (pNext: tTree; pIdentDef: tTree; pConstExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ConstDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ConstDecl;
    
    
    
    
    
    
    
    
    
    
   yyt^.ConstDecl.Next := pNext;
   yyt^.ConstDecl.IdentDef := pIdentDef;
   yyt^.ConstDecl.ConstExpr := pConstExpr;
    
    
    
  RETURN yyt;
 END mConstDecl;

PROCEDURE mTypeDecl* (pNext: tTree; pIdentDef: tTree; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeDecl;
    
    
    
    
    
    
    
    
    
    
   yyt^.TypeDecl.Next := pNext;
   yyt^.TypeDecl.IdentDef := pIdentDef;
   yyt^.TypeDecl.Type := pType;
    
    
   	
    
  RETURN yyt;
 END mTypeDecl;

PROCEDURE mVarDecl* (pNext: tTree; pIdentLists: tTree; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [VarDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := VarDecl;
    
    
    
    
    
    
    
    
    
    
   yyt^.VarDecl.Next := pNext;
   yyt^.VarDecl.IdentLists := pIdentLists;
   yyt^.VarDecl.Type := pType;
  RETURN yyt;
 END mVarDecl;

PROCEDURE mProcs* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Procs] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Procs;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mProcs;

PROCEDURE mmtProc* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtProc] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtProc;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtProc;

PROCEDURE mProc* (pNext: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Proc] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Proc;
    
    
    
    
    
    
    
    
    
   yyt^.Proc.Next := pNext;
  RETURN yyt;
 END mProc;

PROCEDURE mProcDecl* (pNext: tTree; pIdentDef: tTree; pFormalPars: tTree; pDeclSection: tTree; pStmts: tTree; pEndPos: tPosition; pIdent: tIdent; pIdPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ProcDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ProcDecl;
    
    
    
    
    
    
    
    
    
   yyt^.ProcDecl.Next := pNext;
   yyt^.ProcDecl.IdentDef := pIdentDef;
   yyt^.ProcDecl.FormalPars := pFormalPars;
   yyt^.ProcDecl.DeclSection := pDeclSection;
   yyt^.ProcDecl.Stmts := pStmts;
   yyt^.ProcDecl.EndPos := pEndPos;
   yyt^.ProcDecl.Ident := pIdent;
   yyt^.ProcDecl.IdPos := pIdPos;
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mProcDecl;

PROCEDURE mForwardDecl* (pNext: tTree; pIdentDef: tTree; pFormalPars: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ForwardDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ForwardDecl;
    
    
    
    
    
    
    
    
    
   yyt^.ForwardDecl.Next := pNext;
   yyt^.ForwardDecl.IdentDef := pIdentDef;
   yyt^.ForwardDecl.FormalPars := pFormalPars;
    
    
    
  RETURN yyt;
 END mForwardDecl;

PROCEDURE mBoundProcDecl* (pNext: tTree; pReceiver: tTree; pIdentDef: tTree; pFormalPars: tTree; pDeclSection: tTree; pStmts: tTree; pEndPos: tPosition; pIdent: tIdent; pIdPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [BoundProcDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := BoundProcDecl;
    
    
    
    
    
    
    
    
    
   yyt^.BoundProcDecl.Next := pNext;
   yyt^.BoundProcDecl.Receiver := pReceiver;
   yyt^.BoundProcDecl.IdentDef := pIdentDef;
   yyt^.BoundProcDecl.FormalPars := pFormalPars;
   yyt^.BoundProcDecl.DeclSection := pDeclSection;
   yyt^.BoundProcDecl.Stmts := pStmts;
   yyt^.BoundProcDecl.EndPos := pEndPos;
   yyt^.BoundProcDecl.Ident := pIdent;
   yyt^.BoundProcDecl.IdPos := pIdPos;
    
    
    
    
    
    
    
    
    
    
    
   	
    
  RETURN yyt;
 END mBoundProcDecl;

PROCEDURE mBoundForwardDecl* (pNext: tTree; pReceiver: tTree; pIdentDef: tTree; pFormalPars: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [BoundForwardDecl] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := BoundForwardDecl;
    
    
    
    
    
    
    
    
    
   yyt^.BoundForwardDecl.Next := pNext;
   yyt^.BoundForwardDecl.Receiver := pReceiver;
   yyt^.BoundForwardDecl.IdentDef := pIdentDef;
   yyt^.BoundForwardDecl.FormalPars := pFormalPars;
    
    
    
    
    
    
  RETURN yyt;
 END mBoundForwardDecl;

PROCEDURE mFormalPars* (pFPSections: tTree; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [FormalPars] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := FormalPars;
   yyt^.FormalPars.FPSections := pFPSections;
   yyt^.FormalPars.Type := pType;
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mFormalPars;

PROCEDURE mFPSections* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [FPSections] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := FPSections;
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mFPSections;

PROCEDURE mmtFPSection* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtFPSection] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtFPSection;
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtFPSection;

PROCEDURE mFPSection* (pNext: tTree; pParMode: tParMode; pParIds: tTree; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [FPSection] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := FPSection;
    
    
    
    
    
    
    
    
    
    
   yyt^.FPSection.Next := pNext;
   yyt^.FPSection.ParMode := pParMode;
   yyt^.FPSection.ParIds := pParIds;
   yyt^.FPSection.Type := pType;
  RETURN yyt;
 END mFPSection;

PROCEDURE mParIds* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ParIds] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ParIds;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mParIds;

PROCEDURE mmtParId* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtParId] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtParId;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtParId;

PROCEDURE mParId* (pNext: tTree; pIdent: tIdent; pPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ParId] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ParId;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.ParId.Next := pNext;
   yyt^.ParId.Ident := pIdent;
   yyt^.ParId.Pos := pPos;
    
    
  RETURN yyt;
 END mParId;

PROCEDURE mReceiver* (pParMode: tParMode; pName: tIdent; pTypeIdent: tIdent; pTypePos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Receiver] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Receiver;
   yyt^.Receiver.ParMode := pParMode;
   yyt^.Receiver.Name := pName;
   yyt^.Receiver.TypeIdent := pTypeIdent;
   yyt^.Receiver.TypePos := pTypePos;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mReceiver;

PROCEDURE mType* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Type] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Type;
   yyt^.Type.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mType;

PROCEDURE mmtType* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtType;
   yyt^.mtType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtType;

PROCEDURE mNamedType* (pPosition: tPosition; pQualidents: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NamedType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NamedType;
   yyt^.NamedType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.NamedType.Qualidents := pQualidents;
  RETURN yyt;
 END mNamedType;

PROCEDURE mArrayType* (pPosition: tPosition; pArrayExprLists: tTree; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ArrayType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ArrayType;
   yyt^.ArrayType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.ArrayType.ArrayExprLists := pArrayExprLists;
   yyt^.ArrayType.Type := pType;
  RETURN yyt;
 END mArrayType;

PROCEDURE mOpenArrayType* (pPosition: tPosition; pOfPosition: tPosition; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OpenArrayType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OpenArrayType;
   yyt^.OpenArrayType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.OpenArrayType.OfPosition := pOfPosition;
   yyt^.OpenArrayType.Type := pType;
  RETURN yyt;
 END mOpenArrayType;

PROCEDURE mRecordType* (pPosition: tPosition; pFieldLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RecordType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RecordType;
   yyt^.RecordType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.RecordType.FieldLists := pFieldLists;
  RETURN yyt;
 END mRecordType;

PROCEDURE mExtendedType* (pPosition: tPosition; pQualidents: tTree; pFieldLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExtendedType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExtendedType;
   yyt^.ExtendedType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.ExtendedType.Qualidents := pQualidents;
   yyt^.ExtendedType.FieldLists := pFieldLists;
    
    
  RETURN yyt;
 END mExtendedType;

PROCEDURE mPointerType* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PointerType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PointerType;
   yyt^.PointerType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   	
  RETURN yyt;
 END mPointerType;

PROCEDURE mPointerToIdType* (pPosition: tPosition; pIdent: tIdent; pIdentPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PointerToIdType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PointerToIdType;
   yyt^.PointerToIdType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   	
   yyt^.PointerToIdType.Ident := pIdent;
   yyt^.PointerToIdType.IdentPos := pIdentPos;
  RETURN yyt;
 END mPointerToIdType;

PROCEDURE mPointerToQualIdType* (pPosition: tPosition; pQualidents: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PointerToQualIdType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PointerToQualIdType;
   yyt^.PointerToQualIdType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   	
   yyt^.PointerToQualIdType.Qualidents := pQualidents;
  RETURN yyt;
 END mPointerToQualIdType;

PROCEDURE mPointerToStructType* (pPosition: tPosition; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PointerToStructType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PointerToStructType;
   yyt^.PointerToStructType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   	
   yyt^.PointerToStructType.Type := pType;
  RETURN yyt;
 END mPointerToStructType;

PROCEDURE mProcedureType* (pPosition: tPosition; pFormalPars: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ProcedureType] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ProcedureType;
   yyt^.ProcedureType.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.ProcedureType.FormalPars := pFormalPars;
    
  RETURN yyt;
 END mProcedureType;

PROCEDURE mArrayExprLists* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ArrayExprLists] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ArrayExprLists;
    
    
    
    
    
    
  RETURN yyt;
 END mArrayExprLists;

PROCEDURE mmtArrayExprList* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtArrayExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtArrayExprList;
    
    
    
    
    
    
  RETURN yyt;
 END mmtArrayExprList;

PROCEDURE mArrayExprList* (pNext: tTree; pConstExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ArrayExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ArrayExprList;
    
    
    
    
    
    
   yyt^.ArrayExprList.Next := pNext;
   yyt^.ArrayExprList.ConstExpr := pConstExpr;
    
    
    
  RETURN yyt;
 END mArrayExprList;

PROCEDURE mFieldLists* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [FieldLists] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := FieldLists;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mFieldLists;

PROCEDURE mmtFieldList* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtFieldList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtFieldList;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtFieldList;

PROCEDURE mFieldList* (pNext: tTree; pIdentLists: tTree; pType: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [FieldList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := FieldList;
    
    
    
    
    
    
    
    
    
   yyt^.FieldList.Next := pNext;
   yyt^.FieldList.IdentLists := pIdentLists;
   yyt^.FieldList.Type := pType;
  RETURN yyt;
 END mFieldList;

PROCEDURE mIdentLists* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IdentLists] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IdentLists;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mIdentLists;

PROCEDURE mmtIdentList* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtIdentList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtIdentList;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtIdentList;

PROCEDURE mIdentList* (pNext: tTree; pIdentDef: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IdentList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IdentList;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.IdentList.Next := pNext;
   yyt^.IdentList.IdentDef := pIdentDef;
    
    
    
  RETURN yyt;
 END mIdentList;

PROCEDURE mQualidents* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Qualidents] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Qualidents;
   yyt^.Qualidents.Position := pPosition;
    
    
    
  RETURN yyt;
 END mQualidents;

PROCEDURE mmtQualident* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtQualident] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtQualident;
   yyt^.mtQualident.Position := pPosition;
    
    
    
  RETURN yyt;
 END mmtQualident;

PROCEDURE mErrorQualident* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ErrorQualident] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ErrorQualident;
   yyt^.ErrorQualident.Position := pPosition;
    
    
    
  RETURN yyt;
 END mErrorQualident;

PROCEDURE mUnqualifiedIdent* (pPosition: tPosition; pIdent: tIdent): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [UnqualifiedIdent] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := UnqualifiedIdent;
   yyt^.UnqualifiedIdent.Position := pPosition;
    
    
    
   yyt^.UnqualifiedIdent.Ident := pIdent;
  RETURN yyt;
 END mUnqualifiedIdent;

PROCEDURE mQualifiedIdent* (pPosition: tPosition; pServerId: tIdent; pIdent: tIdent; pIdentPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [QualifiedIdent] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := QualifiedIdent;
   yyt^.QualifiedIdent.Position := pPosition;
    
    
    
   yyt^.QualifiedIdent.ServerId := pServerId;
   yyt^.QualifiedIdent.Ident := pIdent;
   yyt^.QualifiedIdent.IdentPos := pIdentPos;
    
    
    
    
  RETURN yyt;
 END mQualifiedIdent;

PROCEDURE mIdentDef* (pIdent: tIdent; pPos: tPosition; pExportMode: tExportMode): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IdentDef] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IdentDef;
   yyt^.IdentDef.Ident := pIdent;
   yyt^.IdentDef.Pos := pPos;
   yyt^.IdentDef.ExportMode := pExportMode;
    
  RETURN yyt;
 END mIdentDef;

PROCEDURE mStmts* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Stmts] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Stmts;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mStmts;

PROCEDURE mmtStmt* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtStmt;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtStmt;

PROCEDURE mNoStmts* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NoStmts] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NoStmts;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mNoStmts;

PROCEDURE mStmt* (pNext: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Stmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Stmt;
    
    
    
    
    
    
    
    
    
   yyt^.Stmt.Next := pNext;
  RETURN yyt;
 END mStmt;

PROCEDURE mAssignStmt* (pNext: tTree; pDesignator: tTree; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AssignStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AssignStmt;
    
    
    
    
    
    
    
    
    
   yyt^.AssignStmt.Next := pNext;
   yyt^.AssignStmt.Designator := pDesignator;
   yyt^.AssignStmt.Exprs := pExprs;
    
    
  RETURN yyt;
 END mAssignStmt;

PROCEDURE mCallStmt* (pNext: tTree; pDesignator: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CallStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CallStmt;
    
    
    
    
    
    
    
    
    
   yyt^.CallStmt.Next := pNext;
   yyt^.CallStmt.Designator := pDesignator;
  RETURN yyt;
 END mCallStmt;

PROCEDURE mIfStmt* (pNext: tTree; pExprs: tTree; pThen: tTree; pElse: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IfStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IfStmt;
    
    
    
    
    
    
    
    
    
   yyt^.IfStmt.Next := pNext;
   yyt^.IfStmt.Exprs := pExprs;
   yyt^.IfStmt.Then := pThen;
   yyt^.IfStmt.Else := pElse;
  RETURN yyt;
 END mIfStmt;

PROCEDURE mCaseStmt* (pNext: tTree; pExprs: tTree; pCases: tTree; pElse: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CaseStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CaseStmt;
    
    
    
    
    
    
    
    
    
   yyt^.CaseStmt.Next := pNext;
   yyt^.CaseStmt.Exprs := pExprs;
   yyt^.CaseStmt.Cases := pCases;
   yyt^.CaseStmt.Else := pElse;
    
  RETURN yyt;
 END mCaseStmt;

PROCEDURE mWhileStmt* (pNext: tTree; pExprs: tTree; pStmts: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [WhileStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := WhileStmt;
    
    
    
    
    
    
    
    
    
   yyt^.WhileStmt.Next := pNext;
   yyt^.WhileStmt.Exprs := pExprs;
   yyt^.WhileStmt.Stmts := pStmts;
  RETURN yyt;
 END mWhileStmt;

PROCEDURE mRepeatStmt* (pNext: tTree; pStmts: tTree; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RepeatStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RepeatStmt;
    
    
    
    
    
    
    
    
    
   yyt^.RepeatStmt.Next := pNext;
   yyt^.RepeatStmt.Stmts := pStmts;
   yyt^.RepeatStmt.Exprs := pExprs;
  RETURN yyt;
 END mRepeatStmt;

PROCEDURE mForStmt* (pNext: tTree; pIdent: tIdent; pPos: tPosition; pFrom: tTree; pTo: tTree; pBy: tTree; pStmts: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ForStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ForStmt;
    
    
    
    
    
    
    
    
    
   yyt^.ForStmt.Next := pNext;
   yyt^.ForStmt.Ident := pIdent;
   yyt^.ForStmt.Pos := pPos;
   yyt^.ForStmt.From := pFrom;
   yyt^.ForStmt.To := pTo;
   yyt^.ForStmt.By := pBy;
   yyt^.ForStmt.Stmts := pStmts;
    
    
    
    
    
    
  RETURN yyt;
 END mForStmt;

PROCEDURE mLoopStmt* (pNext: tTree; pStmts: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LoopStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LoopStmt;
    
    
    
    
    
    
    
    
    
   yyt^.LoopStmt.Next := pNext;
   yyt^.LoopStmt.Stmts := pStmts;
    
  RETURN yyt;
 END mLoopStmt;

PROCEDURE mWithStmt* (pNext: tTree; pGuardedStmts: tTree; pElse: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [WithStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := WithStmt;
    
    
    
    
    
    
    
    
    
   yyt^.WithStmt.Next := pNext;
   yyt^.WithStmt.GuardedStmts := pGuardedStmts;
   yyt^.WithStmt.Else := pElse;
  RETURN yyt;
 END mWithStmt;

PROCEDURE mExitStmt* (pNext: tTree; pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExitStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExitStmt;
    
    
    
    
    
    
    
    
    
   yyt^.ExitStmt.Next := pNext;
   yyt^.ExitStmt.Position := pPosition;
    
  RETURN yyt;
 END mExitStmt;

PROCEDURE mReturnStmt* (pNext: tTree; pPosition: tPosition; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ReturnStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ReturnStmt;
    
    
    
    
    
    
    
    
    
   yyt^.ReturnStmt.Next := pNext;
   yyt^.ReturnStmt.Position := pPosition;
   yyt^.ReturnStmt.Exprs := pExprs;
    
  RETURN yyt;
 END mReturnStmt;

PROCEDURE mCases* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Cases] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Cases;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mCases;

PROCEDURE mmtCase* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtCase] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtCase;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtCase;

PROCEDURE mCase* (pNext: tTree; pCaseLabels: tTree; pStmts: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Case] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Case;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.Case.Next := pNext;
   yyt^.Case.CaseLabels := pCaseLabels;
   yyt^.Case.Stmts := pStmts;
  RETURN yyt;
 END mCase;

PROCEDURE mCaseLabels* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CaseLabels] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CaseLabels;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mCaseLabels;

PROCEDURE mmtCaseLabel* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtCaseLabel] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtCaseLabel;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtCaseLabel;

PROCEDURE mCaseLabel* (pNext: tTree; pConstExpr1: tTree; pConstExpr2: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CaseLabel] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CaseLabel;
    
    
    
    
    
    
    
    
    
   yyt^.CaseLabel.Next := pNext;
   yyt^.CaseLabel.ConstExpr1 := pConstExpr1;
   yyt^.CaseLabel.ConstExpr2 := pConstExpr2;
  RETURN yyt;
 END mCaseLabel;

PROCEDURE mGuardedStmts* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [GuardedStmts] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := GuardedStmts;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mGuardedStmts;

PROCEDURE mmtGuardedStmt* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtGuardedStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtGuardedStmt;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtGuardedStmt;

PROCEDURE mGuardedStmt* (pNext: tTree; pGuard: tTree; pStmts: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [GuardedStmt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := GuardedStmt;
    
    
    
    
    
    
    
    
    
   yyt^.GuardedStmt.Next := pNext;
   yyt^.GuardedStmt.Guard := pGuard;
   yyt^.GuardedStmt.Stmts := pStmts;
    
  RETURN yyt;
 END mGuardedStmt;

PROCEDURE mGuard* (pVariable: tTree; pOpPos: tPosition; pTypeId: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Guard] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Guard;
   yyt^.Guard.Variable := pVariable;
   yyt^.Guard.OpPos := pOpPos;
   yyt^.Guard.TypeId := pTypeId;
    
    
    
    
    
    
  RETURN yyt;
 END mGuard;

PROCEDURE mConstExpr* (pPosition: tPosition; pExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ConstExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ConstExpr;
   yyt^.ConstExpr.Position := pPosition;
   yyt^.ConstExpr.Expr := pExpr;
    
    
    
    
    
    
  RETURN yyt;
 END mConstExpr;

PROCEDURE mExprs* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Exprs] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Exprs;
   yyt^.Exprs.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mExprs;

PROCEDURE mmtExpr* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtExpr;
   yyt^.mtExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtExpr;

PROCEDURE mMonExpr* (pPosition: tPosition; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MonExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MonExpr;
   yyt^.MonExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.MonExpr.Exprs := pExprs;
  RETURN yyt;
 END mMonExpr;

PROCEDURE mNegateExpr* (pPosition: tPosition; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NegateExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NegateExpr;
   yyt^.NegateExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.NegateExpr.Exprs := pExprs;
  RETURN yyt;
 END mNegateExpr;

PROCEDURE mIdentityExpr* (pPosition: tPosition; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IdentityExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IdentityExpr;
   yyt^.IdentityExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.IdentityExpr.Exprs := pExprs;
  RETURN yyt;
 END mIdentityExpr;

PROCEDURE mNotExpr* (pPosition: tPosition; pExprs: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NotExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NotExpr;
   yyt^.NotExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.NotExpr.Exprs := pExprs;
  RETURN yyt;
 END mNotExpr;

PROCEDURE mDyExpr* (pPosition: tPosition; pDyOperator: tTree; pExpr1: tTree; pExpr2: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DyExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DyExpr;
   yyt^.DyExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.DyExpr.DyOperator := pDyOperator;
   yyt^.DyExpr.Expr1 := pExpr1;
   yyt^.DyExpr.Expr2 := pExpr2;
  RETURN yyt;
 END mDyExpr;

PROCEDURE mIsExpr* (pPosition: tPosition; pDesignator: tTree; pOpPos: tPosition; pTypeId: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IsExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IsExpr;
   yyt^.IsExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.IsExpr.Designator := pDesignator;
   yyt^.IsExpr.OpPos := pOpPos;
   yyt^.IsExpr.TypeId := pTypeId;
    
  RETURN yyt;
 END mIsExpr;

PROCEDURE mSetExpr* (pPosition: tPosition; pElements: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SetExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SetExpr;
   yyt^.SetExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.SetExpr.Elements := pElements;
    
  RETURN yyt;
 END mSetExpr;

PROCEDURE mDesignExpr* (pPosition: tPosition; pDesignator: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DesignExpr] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DesignExpr;
   yyt^.DesignExpr.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.DesignExpr.Designator := pDesignator;
    
  RETURN yyt;
 END mDesignExpr;

PROCEDURE mSetConst* (pPosition: tPosition; pSet: oSET): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SetConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SetConst;
   yyt^.SetConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.SetConst.Set := pSet;
  RETURN yyt;
 END mSetConst;

PROCEDURE mIntConst* (pPosition: tPosition; pInt: oLONGINT): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IntConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IntConst;
   yyt^.IntConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.IntConst.Int := pInt;
  RETURN yyt;
 END mIntConst;

PROCEDURE mRealConst* (pPosition: tPosition; pReal: oREAL): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RealConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RealConst;
   yyt^.RealConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.RealConst.Real := pReal;
  RETURN yyt;
 END mRealConst;

PROCEDURE mLongrealConst* (pPosition: tPosition; pLongreal: oLONGREAL): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LongrealConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LongrealConst;
   yyt^.LongrealConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.LongrealConst.Longreal := pLongreal;
  RETURN yyt;
 END mLongrealConst;

PROCEDURE mCharConst* (pPosition: tPosition; pChar: oCHAR): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CharConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CharConst;
   yyt^.CharConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.CharConst.Char := pChar;
  RETURN yyt;
 END mCharConst;

PROCEDURE mStringConst* (pPosition: tPosition; pString: oSTRING): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [StringConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := StringConst;
   yyt^.StringConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
   yyt^.StringConst.String := pString;
  RETURN yyt;
 END mStringConst;

PROCEDURE mNilConst* (pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NilConst] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NilConst;
   yyt^.NilConst.Position := pPosition;
    
    
    
    
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mNilConst;

PROCEDURE mElements* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Elements] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Elements;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mElements;

PROCEDURE mmtElement* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtElement] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtElement;
    
    
    
    
    
    
    
    
    
  RETURN yyt;
 END mmtElement;

PROCEDURE mElement* (pNext: tTree; pExpr1: tTree; pExpr2: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Element] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Element;
    
    
    
    
    
    
    
    
    
   yyt^.Element.Next := pNext;
   yyt^.Element.Expr1 := pExpr1;
   yyt^.Element.Expr2 := pExpr2;
  RETURN yyt;
 END mElement;

PROCEDURE mDyOperator* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DyOperator] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DyOperator;
   yyt^.DyOperator.Position := pPosition;
   yyt^.DyOperator.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
  RETURN yyt;
 END mDyOperator;

PROCEDURE mRelationOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RelationOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RelationOper;
   yyt^.RelationOper.Position := pPosition;
   yyt^.RelationOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mRelationOper;

PROCEDURE mEqualOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [EqualOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := EqualOper;
   yyt^.EqualOper.Position := pPosition;
   yyt^.EqualOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mEqualOper;

PROCEDURE mUnequalOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [UnequalOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := UnequalOper;
   yyt^.UnequalOper.Position := pPosition;
   yyt^.UnequalOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mUnequalOper;

PROCEDURE mOrderRelationOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OrderRelationOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OrderRelationOper;
   yyt^.OrderRelationOper.Position := pPosition;
   yyt^.OrderRelationOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mOrderRelationOper;

PROCEDURE mLessOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LessOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LessOper;
   yyt^.LessOper.Position := pPosition;
   yyt^.LessOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mLessOper;

PROCEDURE mLessEqualOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LessEqualOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LessEqualOper;
   yyt^.LessEqualOper.Position := pPosition;
   yyt^.LessEqualOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mLessEqualOper;

PROCEDURE mGreaterOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [GreaterOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := GreaterOper;
   yyt^.GreaterOper.Position := pPosition;
   yyt^.GreaterOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mGreaterOper;

PROCEDURE mGreaterEqualOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [GreaterEqualOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := GreaterEqualOper;
   yyt^.GreaterEqualOper.Position := pPosition;
   yyt^.GreaterEqualOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
  RETURN yyt;
 END mGreaterEqualOper;

PROCEDURE mInOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [InOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := InOper;
   yyt^.InOper.Position := pPosition;
   yyt^.InOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
  RETURN yyt;
 END mInOper;

PROCEDURE mNumSetOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NumSetOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NumSetOper;
   yyt^.NumSetOper.Position := pPosition;
   yyt^.NumSetOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mNumSetOper;

PROCEDURE mPlusOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PlusOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PlusOper;
   yyt^.PlusOper.Position := pPosition;
   yyt^.PlusOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mPlusOper;

PROCEDURE mMinusOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MinusOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MinusOper;
   yyt^.MinusOper.Position := pPosition;
   yyt^.MinusOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mMinusOper;

PROCEDURE mMultOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MultOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MultOper;
   yyt^.MultOper.Position := pPosition;
   yyt^.MultOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mMultOper;

PROCEDURE mRDivOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RDivOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RDivOper;
   yyt^.RDivOper.Position := pPosition;
   yyt^.RDivOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mRDivOper;

PROCEDURE mIntOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IntOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IntOper;
   yyt^.IntOper.Position := pPosition;
   yyt^.IntOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mIntOper;

PROCEDURE mDivOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DivOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DivOper;
   yyt^.DivOper.Position := pPosition;
   yyt^.DivOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mDivOper;

PROCEDURE mModOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ModOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ModOper;
   yyt^.ModOper.Position := pPosition;
   yyt^.ModOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
    
    
  RETURN yyt;
 END mModOper;

PROCEDURE mBoolOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [BoolOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := BoolOper;
   yyt^.BoolOper.Position := pPosition;
   yyt^.BoolOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
  RETURN yyt;
 END mBoolOper;

PROCEDURE mOrOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OrOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OrOper;
   yyt^.OrOper.Position := pPosition;
   yyt^.OrOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
  RETURN yyt;
 END mOrOper;

PROCEDURE mAndOper* (pPosition: tPosition; pOperator: INTEGER): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AndOper] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AndOper;
   yyt^.AndOper.Position := pPosition;
   yyt^.AndOper.Operator := pOperator;
    
    
    
    
   	
    
    
   	
    
    
    
    
  RETURN yyt;
 END mAndOper;

PROCEDURE mDesignator* (pIdent: tIdent; pPosition: tPosition; pDesignors: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Designator] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Designator;
   yyt^.Designator.Ident := pIdent;
   yyt^.Designator.Position := pPosition;
   yyt^.Designator.Designors := pDesignors;
    yyt^.Designator.Designations  := NoTree; 
    
    
    
    
    yyt^.Designator.ExprList  := NoTree; 
    
    
    
    
    
    
    
    
    
   	
    
    
    
    
  RETURN yyt;
 END mDesignator;

PROCEDURE mDesignors* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Designors] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Designors;
    
    
  RETURN yyt;
 END mDesignors;

PROCEDURE mmtDesignor* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtDesignor] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtDesignor;
    
    
  RETURN yyt;
 END mmtDesignor;

PROCEDURE mDesignor* (pNextor: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Designor] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Designor;
    
    
   yyt^.Designor.Nextor := pNextor;
  RETURN yyt;
 END mDesignor;

PROCEDURE mSelector* (pNextor: tTree; pOpPos: tPosition; pIdent: tIdent; pIdPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Selector] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Selector;
    
    
   yyt^.Selector.Nextor := pNextor;
   yyt^.Selector.OpPos := pOpPos;
   yyt^.Selector.Ident := pIdent;
   yyt^.Selector.IdPos := pIdPos;
  RETURN yyt;
 END mSelector;

PROCEDURE mIndexor* (pNextor: tTree; pOp1Pos: tPosition; pOp2Pos: tPosition; pExprList: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Indexor] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Indexor;
    
    
   yyt^.Indexor.Nextor := pNextor;
   yyt^.Indexor.Op1Pos := pOp1Pos;
   yyt^.Indexor.Op2Pos := pOp2Pos;
   yyt^.Indexor.ExprList := pExprList;
  RETURN yyt;
 END mIndexor;

PROCEDURE mDereferencor* (pNextor: tTree; pOpPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Dereferencor] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Dereferencor;
    
    
   yyt^.Dereferencor.Nextor := pNextor;
   yyt^.Dereferencor.OpPos := pOpPos;
  RETURN yyt;
 END mDereferencor;

PROCEDURE mArgumentor* (pNextor: tTree; pOp1Pos: tPosition; pOp2Pos: tPosition; pExprList: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Argumentor] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Argumentor;
    
    
   yyt^.Argumentor.Nextor := pNextor;
   yyt^.Argumentor.Op1Pos := pOp1Pos;
   yyt^.Argumentor.Op2Pos := pOp2Pos;
   yyt^.Argumentor.ExprList := pExprList;
  RETURN yyt;
 END mArgumentor;

PROCEDURE mDesignations* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Designations] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Designations;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Designations.ExprListOut  := NoTree; 
    
    
    
    
    
  RETURN yyt;
 END mDesignations;

PROCEDURE mmtDesignation* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtDesignation] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtDesignation;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.mtDesignation.ExprListOut  := NoTree; 
    
    
    
    
    
  RETURN yyt;
 END mmtDesignation;

PROCEDURE mDesignation* (pNextor: tTree; pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Designation] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Designation;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Designation.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Designation.Nextor := pNextor;
   yyt^.Designation.Position := pPosition;
    yyt^.Designation.Nextion  := NoTree; 
  RETURN yyt;
 END mDesignation;

PROCEDURE mImporting* (pNextor: tTree; pPosition: tPosition; pIdent: tIdent; pIdPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Importing] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Importing;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Importing.ExprListOut  := NoTree; 
    
    
    
    
   yyt^.Importing.Nextor := pNextor;
   yyt^.Importing.Position := pPosition;
    yyt^.Importing.Nextion  := NoTree; 
   yyt^.Importing.Ident := pIdent;
   yyt^.Importing.IdPos := pIdPos;
    
   	
  RETURN yyt;
 END mImporting;

PROCEDURE mSelecting* (pNextor: tTree; pPosition: tPosition; pIdent: tIdent; pIdPos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Selecting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Selecting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Selecting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Selecting.Nextor := pNextor;
   yyt^.Selecting.Position := pPosition;
    yyt^.Selecting.Nextion  := NoTree; 
   yyt^.Selecting.Ident := pIdent;
   yyt^.Selecting.IdPos := pIdPos;
    
   	
  RETURN yyt;
 END mSelecting;

PROCEDURE mIndexing* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Indexing] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Indexing;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Indexing.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Indexing.Nextor := pNextor;
   yyt^.Indexing.Position := pPosition;
    yyt^.Indexing.Nextion  := NoTree; 
   yyt^.Indexing.Op2Pos := pOp2Pos;
   yyt^.Indexing.Expr := pExpr;
    
    
   	
  RETURN yyt;
 END mIndexing;

PROCEDURE mDereferencing* (pNextor: tTree; pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Dereferencing] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Dereferencing;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Dereferencing.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Dereferencing.Nextor := pNextor;
   yyt^.Dereferencing.Position := pPosition;
    yyt^.Dereferencing.Nextion  := NoTree; 
    
  RETURN yyt;
 END mDereferencing;

PROCEDURE mSupering* (pNextor: tTree; pPosition: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Supering] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Supering;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Supering.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Supering.Nextor := pNextor;
   yyt^.Supering.Position := pPosition;
    yyt^.Supering.Nextion  := NoTree; 
    
    
   	
    
  RETURN yyt;
 END mSupering;

PROCEDURE mArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExprList: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Argumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Argumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Argumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Argumenting.Nextor := pNextor;
   yyt^.Argumenting.Position := pPosition;
    yyt^.Argumenting.Nextion  := NoTree; 
   yyt^.Argumenting.Op2Pos := pOp2Pos;
   yyt^.Argumenting.ExprList := pExprList;
    
    
    
    
  RETURN yyt;
 END mArgumenting;

PROCEDURE mGuarding* (pNextor: tTree; pPosition: tPosition; pIsImplicit: BOOLEAN; pQualidents: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Guarding] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Guarding;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.Guarding.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.Guarding.Nextor := pNextor;
   yyt^.Guarding.Position := pPosition;
    yyt^.Guarding.Nextion  := NoTree; 
   yyt^.Guarding.IsImplicit := pIsImplicit;
   yyt^.Guarding.Qualidents := pQualidents;
    
    
  RETURN yyt;
 END mGuarding;

PROCEDURE mPredeclArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PredeclArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PredeclArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.PredeclArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.PredeclArgumenting.Nextor := pNextor;
   yyt^.PredeclArgumenting.Position := pPosition;
    yyt^.PredeclArgumenting.Nextion  := NoTree; 
   yyt^.PredeclArgumenting.Op2Pos := pOp2Pos;
    
    
  RETURN yyt;
 END mPredeclArgumenting;

PROCEDURE mPredeclArgumenting1* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PredeclArgumenting1] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PredeclArgumenting1;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.PredeclArgumenting1.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.PredeclArgumenting1.Nextor := pNextor;
   yyt^.PredeclArgumenting1.Position := pPosition;
    yyt^.PredeclArgumenting1.Nextion  := NoTree; 
   yyt^.PredeclArgumenting1.Op2Pos := pOp2Pos;
    
    
   yyt^.PredeclArgumenting1.Expr := pExpr;
   yyt^.PredeclArgumenting1.ExprLists := pExprLists;
  RETURN yyt;
 END mPredeclArgumenting1;

PROCEDURE mAbsArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AbsArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AbsArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.AbsArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.AbsArgumenting.Nextor := pNextor;
   yyt^.AbsArgumenting.Position := pPosition;
    yyt^.AbsArgumenting.Nextion  := NoTree; 
   yyt^.AbsArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.AbsArgumenting.Expr := pExpr;
   yyt^.AbsArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mAbsArgumenting;

PROCEDURE mCapArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CapArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CapArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.CapArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.CapArgumenting.Nextor := pNextor;
   yyt^.CapArgumenting.Position := pPosition;
    yyt^.CapArgumenting.Nextion  := NoTree; 
   yyt^.CapArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.CapArgumenting.Expr := pExpr;
   yyt^.CapArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mCapArgumenting;

PROCEDURE mChrArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ChrArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ChrArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.ChrArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.ChrArgumenting.Nextor := pNextor;
   yyt^.ChrArgumenting.Position := pPosition;
    yyt^.ChrArgumenting.Nextion  := NoTree; 
   yyt^.ChrArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.ChrArgumenting.Expr := pExpr;
   yyt^.ChrArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mChrArgumenting;

PROCEDURE mEntierArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [EntierArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := EntierArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.EntierArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.EntierArgumenting.Nextor := pNextor;
   yyt^.EntierArgumenting.Position := pPosition;
    yyt^.EntierArgumenting.Nextion  := NoTree; 
   yyt^.EntierArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.EntierArgumenting.Expr := pExpr;
   yyt^.EntierArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mEntierArgumenting;

PROCEDURE mLongArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LongArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LongArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.LongArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.LongArgumenting.Nextor := pNextor;
   yyt^.LongArgumenting.Position := pPosition;
    yyt^.LongArgumenting.Nextion  := NoTree; 
   yyt^.LongArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.LongArgumenting.Expr := pExpr;
   yyt^.LongArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mLongArgumenting;

PROCEDURE mOddArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OddArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OddArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.OddArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.OddArgumenting.Nextor := pNextor;
   yyt^.OddArgumenting.Position := pPosition;
    yyt^.OddArgumenting.Nextion  := NoTree; 
   yyt^.OddArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.OddArgumenting.Expr := pExpr;
   yyt^.OddArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mOddArgumenting;

PROCEDURE mOrdArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OrdArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OrdArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.OrdArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.OrdArgumenting.Nextor := pNextor;
   yyt^.OrdArgumenting.Position := pPosition;
    yyt^.OrdArgumenting.Nextion  := NoTree; 
   yyt^.OrdArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.OrdArgumenting.Expr := pExpr;
   yyt^.OrdArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mOrdArgumenting;

PROCEDURE mShortArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ShortArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ShortArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.ShortArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.ShortArgumenting.Nextor := pNextor;
   yyt^.ShortArgumenting.Position := pPosition;
    yyt^.ShortArgumenting.Nextion  := NoTree; 
   yyt^.ShortArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.ShortArgumenting.Expr := pExpr;
   yyt^.ShortArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mShortArgumenting;

PROCEDURE mHaltArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [HaltArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := HaltArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.HaltArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.HaltArgumenting.Nextor := pNextor;
   yyt^.HaltArgumenting.Position := pPosition;
    yyt^.HaltArgumenting.Nextion  := NoTree; 
   yyt^.HaltArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.HaltArgumenting.Expr := pExpr;
   yyt^.HaltArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mHaltArgumenting;

PROCEDURE mSysAdrArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysAdrArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysAdrArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysAdrArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysAdrArgumenting.Nextor := pNextor;
   yyt^.SysAdrArgumenting.Position := pPosition;
    yyt^.SysAdrArgumenting.Nextion  := NoTree; 
   yyt^.SysAdrArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysAdrArgumenting.Expr := pExpr;
   yyt^.SysAdrArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mSysAdrArgumenting;

PROCEDURE mSysCcArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysCcArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysCcArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysCcArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysCcArgumenting.Nextor := pNextor;
   yyt^.SysCcArgumenting.Position := pPosition;
    yyt^.SysCcArgumenting.Nextion  := NoTree; 
   yyt^.SysCcArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysCcArgumenting.Expr := pExpr;
   yyt^.SysCcArgumenting.ExprLists := pExprLists;
  RETURN yyt;
 END mSysCcArgumenting;

PROCEDURE mPredeclArgumenting2Opt* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PredeclArgumenting2Opt] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PredeclArgumenting2Opt;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.PredeclArgumenting2Opt.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.PredeclArgumenting2Opt.Nextor := pNextor;
   yyt^.PredeclArgumenting2Opt.Position := pPosition;
    yyt^.PredeclArgumenting2Opt.Nextion  := NoTree; 
   yyt^.PredeclArgumenting2Opt.Op2Pos := pOp2Pos;
    
    
   yyt^.PredeclArgumenting2Opt.Expr1 := pExpr1;
   yyt^.PredeclArgumenting2Opt.Expr2 := pExpr2;
   yyt^.PredeclArgumenting2Opt.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mPredeclArgumenting2Opt;

PROCEDURE mLenArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LenArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LenArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.LenArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.LenArgumenting.Nextor := pNextor;
   yyt^.LenArgumenting.Position := pPosition;
    yyt^.LenArgumenting.Nextion  := NoTree; 
   yyt^.LenArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.LenArgumenting.Expr1 := pExpr1;
   yyt^.LenArgumenting.Expr2 := pExpr2;
   yyt^.LenArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mLenArgumenting;

PROCEDURE mAssertArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AssertArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AssertArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.AssertArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.AssertArgumenting.Nextor := pNextor;
   yyt^.AssertArgumenting.Position := pPosition;
    yyt^.AssertArgumenting.Nextion  := NoTree; 
   yyt^.AssertArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.AssertArgumenting.Expr1 := pExpr1;
   yyt^.AssertArgumenting.Expr2 := pExpr2;
   yyt^.AssertArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mAssertArgumenting;

PROCEDURE mDecIncArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DecIncArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DecIncArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.DecIncArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.DecIncArgumenting.Nextor := pNextor;
   yyt^.DecIncArgumenting.Position := pPosition;
    yyt^.DecIncArgumenting.Nextion  := NoTree; 
   yyt^.DecIncArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.DecIncArgumenting.Expr1 := pExpr1;
   yyt^.DecIncArgumenting.Expr2 := pExpr2;
   yyt^.DecIncArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mDecIncArgumenting;

PROCEDURE mDecArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DecArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DecArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.DecArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.DecArgumenting.Nextor := pNextor;
   yyt^.DecArgumenting.Position := pPosition;
    yyt^.DecArgumenting.Nextion  := NoTree; 
   yyt^.DecArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.DecArgumenting.Expr1 := pExpr1;
   yyt^.DecArgumenting.Expr2 := pExpr2;
   yyt^.DecArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mDecArgumenting;

PROCEDURE mIncArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IncArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IncArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.IncArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.IncArgumenting.Nextor := pNextor;
   yyt^.IncArgumenting.Position := pPosition;
    yyt^.IncArgumenting.Nextion  := NoTree; 
   yyt^.IncArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.IncArgumenting.Expr1 := pExpr1;
   yyt^.IncArgumenting.Expr2 := pExpr2;
   yyt^.IncArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mIncArgumenting;

PROCEDURE mPredeclArgumenting2* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PredeclArgumenting2] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PredeclArgumenting2;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.PredeclArgumenting2.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.PredeclArgumenting2.Nextor := pNextor;
   yyt^.PredeclArgumenting2.Position := pPosition;
    yyt^.PredeclArgumenting2.Nextion  := NoTree; 
   yyt^.PredeclArgumenting2.Op2Pos := pOp2Pos;
    
    
   yyt^.PredeclArgumenting2.Expr1 := pExpr1;
   yyt^.PredeclArgumenting2.Expr2 := pExpr2;
   yyt^.PredeclArgumenting2.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mPredeclArgumenting2;

PROCEDURE mAshArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AshArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AshArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.AshArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.AshArgumenting.Nextor := pNextor;
   yyt^.AshArgumenting.Position := pPosition;
    yyt^.AshArgumenting.Nextion  := NoTree; 
   yyt^.AshArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.AshArgumenting.Expr1 := pExpr1;
   yyt^.AshArgumenting.Expr2 := pExpr2;
   yyt^.AshArgumenting.ExprLists := pExprLists;
    
    
    
    
    
  RETURN yyt;
 END mAshArgumenting;

PROCEDURE mCopyArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CopyArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CopyArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.CopyArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.CopyArgumenting.Nextor := pNextor;
   yyt^.CopyArgumenting.Position := pPosition;
    yyt^.CopyArgumenting.Nextion  := NoTree; 
   yyt^.CopyArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.CopyArgumenting.Expr1 := pExpr1;
   yyt^.CopyArgumenting.Expr2 := pExpr2;
   yyt^.CopyArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mCopyArgumenting;

PROCEDURE mExclInclArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExclInclArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExclInclArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.ExclInclArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.ExclInclArgumenting.Nextor := pNextor;
   yyt^.ExclInclArgumenting.Position := pPosition;
    yyt^.ExclInclArgumenting.Nextion  := NoTree; 
   yyt^.ExclInclArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.ExclInclArgumenting.Expr1 := pExpr1;
   yyt^.ExclInclArgumenting.Expr2 := pExpr2;
   yyt^.ExclInclArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mExclInclArgumenting;

PROCEDURE mExclArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExclArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExclArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.ExclArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.ExclArgumenting.Nextor := pNextor;
   yyt^.ExclArgumenting.Position := pPosition;
    yyt^.ExclArgumenting.Nextion  := NoTree; 
   yyt^.ExclArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.ExclArgumenting.Expr1 := pExpr1;
   yyt^.ExclArgumenting.Expr2 := pExpr2;
   yyt^.ExclArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mExclArgumenting;

PROCEDURE mInclArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [InclArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := InclArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.InclArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.InclArgumenting.Nextor := pNextor;
   yyt^.InclArgumenting.Position := pPosition;
    yyt^.InclArgumenting.Nextion  := NoTree; 
   yyt^.InclArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.InclArgumenting.Expr1 := pExpr1;
   yyt^.InclArgumenting.Expr2 := pExpr2;
   yyt^.InclArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mInclArgumenting;

PROCEDURE mSysBitArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysBitArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysBitArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysBitArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysBitArgumenting.Nextor := pNextor;
   yyt^.SysBitArgumenting.Position := pPosition;
    yyt^.SysBitArgumenting.Nextion  := NoTree; 
   yyt^.SysBitArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysBitArgumenting.Expr1 := pExpr1;
   yyt^.SysBitArgumenting.Expr2 := pExpr2;
   yyt^.SysBitArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysBitArgumenting;

PROCEDURE mSysLshRotArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysLshRotArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysLshRotArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysLshRotArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysLshRotArgumenting.Nextor := pNextor;
   yyt^.SysLshRotArgumenting.Position := pPosition;
    yyt^.SysLshRotArgumenting.Nextion  := NoTree; 
   yyt^.SysLshRotArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysLshRotArgumenting.Expr1 := pExpr1;
   yyt^.SysLshRotArgumenting.Expr2 := pExpr2;
   yyt^.SysLshRotArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysLshRotArgumenting;

PROCEDURE mSysLshArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysLshArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysLshArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysLshArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysLshArgumenting.Nextor := pNextor;
   yyt^.SysLshArgumenting.Position := pPosition;
    yyt^.SysLshArgumenting.Nextion  := NoTree; 
   yyt^.SysLshArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysLshArgumenting.Expr1 := pExpr1;
   yyt^.SysLshArgumenting.Expr2 := pExpr2;
   yyt^.SysLshArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysLshArgumenting;

PROCEDURE mSysRotArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysRotArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysRotArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysRotArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysRotArgumenting.Nextor := pNextor;
   yyt^.SysRotArgumenting.Position := pPosition;
    yyt^.SysRotArgumenting.Nextion  := NoTree; 
   yyt^.SysRotArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysRotArgumenting.Expr1 := pExpr1;
   yyt^.SysRotArgumenting.Expr2 := pExpr2;
   yyt^.SysRotArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysRotArgumenting;

PROCEDURE mSysGetPutArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysGetPutArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysGetPutArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysGetPutArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysGetPutArgumenting.Nextor := pNextor;
   yyt^.SysGetPutArgumenting.Position := pPosition;
    yyt^.SysGetPutArgumenting.Nextion  := NoTree; 
   yyt^.SysGetPutArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysGetPutArgumenting.Expr1 := pExpr1;
   yyt^.SysGetPutArgumenting.Expr2 := pExpr2;
   yyt^.SysGetPutArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysGetPutArgumenting;

PROCEDURE mSysGetArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysGetArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysGetArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysGetArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysGetArgumenting.Nextor := pNextor;
   yyt^.SysGetArgumenting.Position := pPosition;
    yyt^.SysGetArgumenting.Nextion  := NoTree; 
   yyt^.SysGetArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysGetArgumenting.Expr1 := pExpr1;
   yyt^.SysGetArgumenting.Expr2 := pExpr2;
   yyt^.SysGetArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysGetArgumenting;

PROCEDURE mSysPutArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysPutArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysPutArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysPutArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysPutArgumenting.Nextor := pNextor;
   yyt^.SysPutArgumenting.Position := pPosition;
    yyt^.SysPutArgumenting.Nextion  := NoTree; 
   yyt^.SysPutArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysPutArgumenting.Expr1 := pExpr1;
   yyt^.SysPutArgumenting.Expr2 := pExpr2;
   yyt^.SysPutArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysPutArgumenting;

PROCEDURE mSysGetregPutregArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysGetregPutregArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysGetregPutregArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysGetregPutregArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysGetregPutregArgumenting.Nextor := pNextor;
   yyt^.SysGetregPutregArgumenting.Position := pPosition;
    yyt^.SysGetregPutregArgumenting.Nextion  := NoTree; 
   yyt^.SysGetregPutregArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysGetregPutregArgumenting.Expr1 := pExpr1;
   yyt^.SysGetregPutregArgumenting.Expr2 := pExpr2;
   yyt^.SysGetregPutregArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysGetregPutregArgumenting;

PROCEDURE mSysGetregArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysGetregArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysGetregArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysGetregArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysGetregArgumenting.Nextor := pNextor;
   yyt^.SysGetregArgumenting.Position := pPosition;
    yyt^.SysGetregArgumenting.Nextion  := NoTree; 
   yyt^.SysGetregArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysGetregArgumenting.Expr1 := pExpr1;
   yyt^.SysGetregArgumenting.Expr2 := pExpr2;
   yyt^.SysGetregArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysGetregArgumenting;

PROCEDURE mSysPutregArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysPutregArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysPutregArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysPutregArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysPutregArgumenting.Nextor := pNextor;
   yyt^.SysPutregArgumenting.Position := pPosition;
    yyt^.SysPutregArgumenting.Nextion  := NoTree; 
   yyt^.SysPutregArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysPutregArgumenting.Expr1 := pExpr1;
   yyt^.SysPutregArgumenting.Expr2 := pExpr2;
   yyt^.SysPutregArgumenting.ExprLists := pExprLists;
    
    
    
    
  RETURN yyt;
 END mSysPutregArgumenting;

PROCEDURE mSysNewArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysNewArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysNewArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysNewArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysNewArgumenting.Nextor := pNextor;
   yyt^.SysNewArgumenting.Position := pPosition;
    yyt^.SysNewArgumenting.Nextion  := NoTree; 
   yyt^.SysNewArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysNewArgumenting.Expr1 := pExpr1;
   yyt^.SysNewArgumenting.Expr2 := pExpr2;
   yyt^.SysNewArgumenting.ExprLists := pExprLists;
    
    
    
    
    
  RETURN yyt;
 END mSysNewArgumenting;

PROCEDURE mPredeclArgumenting3* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExpr3: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PredeclArgumenting3] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PredeclArgumenting3;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.PredeclArgumenting3.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.PredeclArgumenting3.Nextor := pNextor;
   yyt^.PredeclArgumenting3.Position := pPosition;
    yyt^.PredeclArgumenting3.Nextion  := NoTree; 
   yyt^.PredeclArgumenting3.Op2Pos := pOp2Pos;
    
    
   yyt^.PredeclArgumenting3.Expr1 := pExpr1;
   yyt^.PredeclArgumenting3.Expr2 := pExpr2;
   yyt^.PredeclArgumenting3.Expr3 := pExpr3;
   yyt^.PredeclArgumenting3.ExprLists := pExprLists;
    
  RETURN yyt;
 END mPredeclArgumenting3;

PROCEDURE mSysMoveArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr1: tTree; pExpr2: tTree; pExpr3: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysMoveArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysMoveArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysMoveArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysMoveArgumenting.Nextor := pNextor;
   yyt^.SysMoveArgumenting.Position := pPosition;
    yyt^.SysMoveArgumenting.Nextion  := NoTree; 
   yyt^.SysMoveArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysMoveArgumenting.Expr1 := pExpr1;
   yyt^.SysMoveArgumenting.Expr2 := pExpr2;
   yyt^.SysMoveArgumenting.Expr3 := pExpr3;
   yyt^.SysMoveArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mSysMoveArgumenting;

PROCEDURE mTypeArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pQualidents: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.TypeArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.TypeArgumenting.Nextor := pNextor;
   yyt^.TypeArgumenting.Position := pPosition;
    yyt^.TypeArgumenting.Nextion  := NoTree; 
   yyt^.TypeArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.TypeArgumenting.Qualidents := pQualidents;
   yyt^.TypeArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mTypeArgumenting;

PROCEDURE mMaxMinArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pQualidents: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MaxMinArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MaxMinArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.MaxMinArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.MaxMinArgumenting.Nextor := pNextor;
   yyt^.MaxMinArgumenting.Position := pPosition;
    yyt^.MaxMinArgumenting.Nextion  := NoTree; 
   yyt^.MaxMinArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.MaxMinArgumenting.Qualidents := pQualidents;
   yyt^.MaxMinArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mMaxMinArgumenting;

PROCEDURE mMaxArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pQualidents: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MaxArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MaxArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.MaxArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.MaxArgumenting.Nextor := pNextor;
   yyt^.MaxArgumenting.Position := pPosition;
    yyt^.MaxArgumenting.Nextion  := NoTree; 
   yyt^.MaxArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.MaxArgumenting.Qualidents := pQualidents;
   yyt^.MaxArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mMaxArgumenting;

PROCEDURE mMinArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pQualidents: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MinArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MinArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.MinArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.MinArgumenting.Nextor := pNextor;
   yyt^.MinArgumenting.Position := pPosition;
    yyt^.MinArgumenting.Nextion  := NoTree; 
   yyt^.MinArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.MinArgumenting.Qualidents := pQualidents;
   yyt^.MinArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mMinArgumenting;

PROCEDURE mSizeArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pQualidents: tTree; pExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SizeArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SizeArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SizeArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SizeArgumenting.Nextor := pNextor;
   yyt^.SizeArgumenting.Position := pPosition;
    yyt^.SizeArgumenting.Nextion  := NoTree; 
   yyt^.SizeArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SizeArgumenting.Qualidents := pQualidents;
   yyt^.SizeArgumenting.ExprLists := pExprLists;
    
  RETURN yyt;
 END mSizeArgumenting;

PROCEDURE mSysValArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pQualidents: tTree; pExprLists: tTree; pExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysValArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysValArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysValArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysValArgumenting.Nextor := pNextor;
   yyt^.SysValArgumenting.Position := pPosition;
    yyt^.SysValArgumenting.Nextion  := NoTree; 
   yyt^.SysValArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysValArgumenting.Qualidents := pQualidents;
   yyt^.SysValArgumenting.ExprLists := pExprLists;
    
   yyt^.SysValArgumenting.Expr := pExpr;
    
    
  RETURN yyt;
 END mSysValArgumenting;

PROCEDURE mNewArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pExpr: tTree; pNewExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NewArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NewArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.NewArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.NewArgumenting.Nextor := pNextor;
   yyt^.NewArgumenting.Position := pPosition;
    yyt^.NewArgumenting.Nextion  := NoTree; 
   yyt^.NewArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.NewArgumenting.Expr := pExpr;
   yyt^.NewArgumenting.NewExprLists := pNewExprLists;
  RETURN yyt;
 END mNewArgumenting;

PROCEDURE mSysAsmArgumenting* (pNextor: tTree; pPosition: tPosition; pOp2Pos: tPosition; pSysAsmExprLists: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysAsmArgumenting] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysAsmArgumenting;
    
    
    
    
    
    
    
   	
    
    
    
    
    
    
    
    
    
    yyt^.SysAsmArgumenting.ExprListOut  := NoTree; 
    
    
    
    
    
   yyt^.SysAsmArgumenting.Nextor := pNextor;
   yyt^.SysAsmArgumenting.Position := pPosition;
    yyt^.SysAsmArgumenting.Nextion  := NoTree; 
   yyt^.SysAsmArgumenting.Op2Pos := pOp2Pos;
    
    
   yyt^.SysAsmArgumenting.SysAsmExprLists := pSysAsmExprLists;
  RETURN yyt;
 END mSysAsmArgumenting;

PROCEDURE mExprLists* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExprLists] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExprLists;
    
    
    
    
   	
    
    
    
    
  RETURN yyt;
 END mExprLists;

PROCEDURE mmtExprList* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtExprList;
    
    
    
    
   	
    
    
    
    
  RETURN yyt;
 END mmtExprList;

PROCEDURE mExprList* (pNext: tTree; pExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExprList;
    
    
    
    
   	
    
    
    
    
   yyt^.ExprList.Next := pNext;
   yyt^.ExprList.Expr := pExpr;
    
    
    
    
  RETURN yyt;
 END mExprList;

PROCEDURE mNewExprLists* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NewExprLists] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NewExprLists;
    
    
    
    
    
    
    
    
   	
  RETURN yyt;
 END mNewExprLists;

PROCEDURE mmtNewExprList* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtNewExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtNewExprList;
    
    
    
    
    
    
    
    
   	
  RETURN yyt;
 END mmtNewExprList;

PROCEDURE mNewExprList* (pNext: tTree; pExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NewExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NewExprList;
    
    
    
    
    
    
    
    
   	
   yyt^.NewExprList.Next := pNext;
   yyt^.NewExprList.Expr := pExpr;
    
  RETURN yyt;
 END mNewExprList;

PROCEDURE mSysAsmExprLists* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysAsmExprLists] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysAsmExprLists;
    
    
    
    
    
  RETURN yyt;
 END mSysAsmExprLists;

PROCEDURE mmtSysAsmExprList* (): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtSysAsmExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtSysAsmExprList;
    
    
    
    
    
  RETURN yyt;
 END mmtSysAsmExprList;

PROCEDURE mSysAsmExprList* (pNext: tTree; pExpr: tTree): tTree;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tTree;
 BEGIN
   yyt  := SYSTEM.VAL(tTree,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt) >= yyPoolMaxPtr THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysAsmExprList] ); 
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysAsmExprList;
    
    
    
    
    
   yyt^.SysAsmExprList.Next := pNext;
   yyt^.SysAsmExprList.Expr := pExpr;
  RETURN yyt;
 END mSysAsmExprList;

PROCEDURE ReleaseTreeModule*;
 VAR yyBlockPtr	: yytBlockPtr;
 BEGIN
  WHILE yyBlockList # NIL DO
   yyBlockPtr	:= yyBlockList;
   yyBlockList	:= yyBlockList^.yySuccessor;
   Memory.Free (SIZE (yytBlock), SYSTEM.VAL(LONGINT,yyBlockPtr));
  END;
  yyPoolFreePtr	:= 0;
  yyPoolMaxPtr	:= 0;
  HeapUsed	:= 0;
 END ReleaseTreeModule;

PROCEDURE BeginTree*;
 BEGIN
(* line 32 "oberon.aecp" *)
  cmtDesignation := mmtDesignation (); 
 END BeginTree;

PROCEDURE CloseTree*;
 BEGIN
 END CloseTree;

PROCEDURE xxExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END xxExit;

BEGIN
 yyBlockList	:= NIL;
 yyPoolFreePtr	:= 0;
 yyPoolMaxPtr	:= 0;
 HeapUsed	:= 0;
 yyExit	:= xxExit;
 yyNodeSize [Module] := SIZE (yModule);
 yyNodeSize [Imports] := SIZE (yImports);
 yyNodeSize [mtImport] := SIZE (ymtImport);
 yyNodeSize [Import] := SIZE (yImport);
 yyNodeSize [DeclSection] := SIZE (yDeclSection);
 yyNodeSize [DeclUnits] := SIZE (yDeclUnits);
 yyNodeSize [mtDeclUnit] := SIZE (ymtDeclUnit);
 yyNodeSize [DeclUnit] := SIZE (yDeclUnit);
 yyNodeSize [Decls] := SIZE (yDecls);
 yyNodeSize [mtDecl] := SIZE (ymtDecl);
 yyNodeSize [Decl] := SIZE (yDecl);
 yyNodeSize [ConstDecl] := SIZE (yConstDecl);
 yyNodeSize [TypeDecl] := SIZE (yTypeDecl);
 yyNodeSize [VarDecl] := SIZE (yVarDecl);
 yyNodeSize [Procs] := SIZE (yProcs);
 yyNodeSize [mtProc] := SIZE (ymtProc);
 yyNodeSize [Proc] := SIZE (yProc);
 yyNodeSize [ProcDecl] := SIZE (yProcDecl);
 yyNodeSize [ForwardDecl] := SIZE (yForwardDecl);
 yyNodeSize [BoundProcDecl] := SIZE (yBoundProcDecl);
 yyNodeSize [BoundForwardDecl] := SIZE (yBoundForwardDecl);
 yyNodeSize [FormalPars] := SIZE (yFormalPars);
 yyNodeSize [FPSections] := SIZE (yFPSections);
 yyNodeSize [mtFPSection] := SIZE (ymtFPSection);
 yyNodeSize [FPSection] := SIZE (yFPSection);
 yyNodeSize [ParIds] := SIZE (yParIds);
 yyNodeSize [mtParId] := SIZE (ymtParId);
 yyNodeSize [ParId] := SIZE (yParId);
 yyNodeSize [Receiver] := SIZE (yReceiver);
 yyNodeSize [Type] := SIZE (yType);
 yyNodeSize [mtType] := SIZE (ymtType);
 yyNodeSize [NamedType] := SIZE (yNamedType);
 yyNodeSize [ArrayType] := SIZE (yArrayType);
 yyNodeSize [OpenArrayType] := SIZE (yOpenArrayType);
 yyNodeSize [RecordType] := SIZE (yRecordType);
 yyNodeSize [ExtendedType] := SIZE (yExtendedType);
 yyNodeSize [PointerType] := SIZE (yPointerType);
 yyNodeSize [PointerToIdType] := SIZE (yPointerToIdType);
 yyNodeSize [PointerToQualIdType] := SIZE (yPointerToQualIdType);
 yyNodeSize [PointerToStructType] := SIZE (yPointerToStructType);
 yyNodeSize [ProcedureType] := SIZE (yProcedureType);
 yyNodeSize [ArrayExprLists] := SIZE (yArrayExprLists);
 yyNodeSize [mtArrayExprList] := SIZE (ymtArrayExprList);
 yyNodeSize [ArrayExprList] := SIZE (yArrayExprList);
 yyNodeSize [FieldLists] := SIZE (yFieldLists);
 yyNodeSize [mtFieldList] := SIZE (ymtFieldList);
 yyNodeSize [FieldList] := SIZE (yFieldList);
 yyNodeSize [IdentLists] := SIZE (yIdentLists);
 yyNodeSize [mtIdentList] := SIZE (ymtIdentList);
 yyNodeSize [IdentList] := SIZE (yIdentList);
 yyNodeSize [Qualidents] := SIZE (yQualidents);
 yyNodeSize [mtQualident] := SIZE (ymtQualident);
 yyNodeSize [ErrorQualident] := SIZE (yErrorQualident);
 yyNodeSize [UnqualifiedIdent] := SIZE (yUnqualifiedIdent);
 yyNodeSize [QualifiedIdent] := SIZE (yQualifiedIdent);
 yyNodeSize [IdentDef] := SIZE (yIdentDef);
 yyNodeSize [Stmts] := SIZE (yStmts);
 yyNodeSize [mtStmt] := SIZE (ymtStmt);
 yyNodeSize [NoStmts] := SIZE (yNoStmts);
 yyNodeSize [Stmt] := SIZE (yStmt);
 yyNodeSize [AssignStmt] := SIZE (yAssignStmt);
 yyNodeSize [CallStmt] := SIZE (yCallStmt);
 yyNodeSize [IfStmt] := SIZE (yIfStmt);
 yyNodeSize [CaseStmt] := SIZE (yCaseStmt);
 yyNodeSize [WhileStmt] := SIZE (yWhileStmt);
 yyNodeSize [RepeatStmt] := SIZE (yRepeatStmt);
 yyNodeSize [ForStmt] := SIZE (yForStmt);
 yyNodeSize [LoopStmt] := SIZE (yLoopStmt);
 yyNodeSize [WithStmt] := SIZE (yWithStmt);
 yyNodeSize [ExitStmt] := SIZE (yExitStmt);
 yyNodeSize [ReturnStmt] := SIZE (yReturnStmt);
 yyNodeSize [Cases] := SIZE (yCases);
 yyNodeSize [mtCase] := SIZE (ymtCase);
 yyNodeSize [Case] := SIZE (yCase);
 yyNodeSize [CaseLabels] := SIZE (yCaseLabels);
 yyNodeSize [mtCaseLabel] := SIZE (ymtCaseLabel);
 yyNodeSize [CaseLabel] := SIZE (yCaseLabel);
 yyNodeSize [GuardedStmts] := SIZE (yGuardedStmts);
 yyNodeSize [mtGuardedStmt] := SIZE (ymtGuardedStmt);
 yyNodeSize [GuardedStmt] := SIZE (yGuardedStmt);
 yyNodeSize [Guard] := SIZE (yGuard);
 yyNodeSize [ConstExpr] := SIZE (yConstExpr);
 yyNodeSize [Exprs] := SIZE (yExprs);
 yyNodeSize [mtExpr] := SIZE (ymtExpr);
 yyNodeSize [MonExpr] := SIZE (yMonExpr);
 yyNodeSize [NegateExpr] := SIZE (yNegateExpr);
 yyNodeSize [IdentityExpr] := SIZE (yIdentityExpr);
 yyNodeSize [NotExpr] := SIZE (yNotExpr);
 yyNodeSize [DyExpr] := SIZE (yDyExpr);
 yyNodeSize [IsExpr] := SIZE (yIsExpr);
 yyNodeSize [SetExpr] := SIZE (ySetExpr);
 yyNodeSize [DesignExpr] := SIZE (yDesignExpr);
 yyNodeSize [SetConst] := SIZE (ySetConst);
 yyNodeSize [IntConst] := SIZE (yIntConst);
 yyNodeSize [RealConst] := SIZE (yRealConst);
 yyNodeSize [LongrealConst] := SIZE (yLongrealConst);
 yyNodeSize [CharConst] := SIZE (yCharConst);
 yyNodeSize [StringConst] := SIZE (yStringConst);
 yyNodeSize [NilConst] := SIZE (yNilConst);
 yyNodeSize [Elements] := SIZE (yElements);
 yyNodeSize [mtElement] := SIZE (ymtElement);
 yyNodeSize [Element] := SIZE (yElement);
 yyNodeSize [DyOperator] := SIZE (yDyOperator);
 yyNodeSize [RelationOper] := SIZE (yRelationOper);
 yyNodeSize [EqualOper] := SIZE (yEqualOper);
 yyNodeSize [UnequalOper] := SIZE (yUnequalOper);
 yyNodeSize [OrderRelationOper] := SIZE (yOrderRelationOper);
 yyNodeSize [LessOper] := SIZE (yLessOper);
 yyNodeSize [LessEqualOper] := SIZE (yLessEqualOper);
 yyNodeSize [GreaterOper] := SIZE (yGreaterOper);
 yyNodeSize [GreaterEqualOper] := SIZE (yGreaterEqualOper);
 yyNodeSize [InOper] := SIZE (yInOper);
 yyNodeSize [NumSetOper] := SIZE (yNumSetOper);
 yyNodeSize [PlusOper] := SIZE (yPlusOper);
 yyNodeSize [MinusOper] := SIZE (yMinusOper);
 yyNodeSize [MultOper] := SIZE (yMultOper);
 yyNodeSize [RDivOper] := SIZE (yRDivOper);
 yyNodeSize [IntOper] := SIZE (yIntOper);
 yyNodeSize [DivOper] := SIZE (yDivOper);
 yyNodeSize [ModOper] := SIZE (yModOper);
 yyNodeSize [BoolOper] := SIZE (yBoolOper);
 yyNodeSize [OrOper] := SIZE (yOrOper);
 yyNodeSize [AndOper] := SIZE (yAndOper);
 yyNodeSize [Designator] := SIZE (yDesignator);
 yyNodeSize [Designors] := SIZE (yDesignors);
 yyNodeSize [mtDesignor] := SIZE (ymtDesignor);
 yyNodeSize [Designor] := SIZE (yDesignor);
 yyNodeSize [Selector] := SIZE (ySelector);
 yyNodeSize [Indexor] := SIZE (yIndexor);
 yyNodeSize [Dereferencor] := SIZE (yDereferencor);
 yyNodeSize [Argumentor] := SIZE (yArgumentor);
 yyNodeSize [Designations] := SIZE (yDesignations);
 yyNodeSize [mtDesignation] := SIZE (ymtDesignation);
 yyNodeSize [Designation] := SIZE (yDesignation);
 yyNodeSize [Importing] := SIZE (yImporting);
 yyNodeSize [Selecting] := SIZE (ySelecting);
 yyNodeSize [Indexing] := SIZE (yIndexing);
 yyNodeSize [Dereferencing] := SIZE (yDereferencing);
 yyNodeSize [Supering] := SIZE (ySupering);
 yyNodeSize [Argumenting] := SIZE (yArgumenting);
 yyNodeSize [Guarding] := SIZE (yGuarding);
 yyNodeSize [PredeclArgumenting] := SIZE (yPredeclArgumenting);
 yyNodeSize [PredeclArgumenting1] := SIZE (yPredeclArgumenting1);
 yyNodeSize [AbsArgumenting] := SIZE (yAbsArgumenting);
 yyNodeSize [CapArgumenting] := SIZE (yCapArgumenting);
 yyNodeSize [ChrArgumenting] := SIZE (yChrArgumenting);
 yyNodeSize [EntierArgumenting] := SIZE (yEntierArgumenting);
 yyNodeSize [LongArgumenting] := SIZE (yLongArgumenting);
 yyNodeSize [OddArgumenting] := SIZE (yOddArgumenting);
 yyNodeSize [OrdArgumenting] := SIZE (yOrdArgumenting);
 yyNodeSize [ShortArgumenting] := SIZE (yShortArgumenting);
 yyNodeSize [HaltArgumenting] := SIZE (yHaltArgumenting);
 yyNodeSize [SysAdrArgumenting] := SIZE (ySysAdrArgumenting);
 yyNodeSize [SysCcArgumenting] := SIZE (ySysCcArgumenting);
 yyNodeSize [PredeclArgumenting2Opt] := SIZE (yPredeclArgumenting2Opt);
 yyNodeSize [LenArgumenting] := SIZE (yLenArgumenting);
 yyNodeSize [AssertArgumenting] := SIZE (yAssertArgumenting);
 yyNodeSize [DecIncArgumenting] := SIZE (yDecIncArgumenting);
 yyNodeSize [DecArgumenting] := SIZE (yDecArgumenting);
 yyNodeSize [IncArgumenting] := SIZE (yIncArgumenting);
 yyNodeSize [PredeclArgumenting2] := SIZE (yPredeclArgumenting2);
 yyNodeSize [AshArgumenting] := SIZE (yAshArgumenting);
 yyNodeSize [CopyArgumenting] := SIZE (yCopyArgumenting);
 yyNodeSize [ExclInclArgumenting] := SIZE (yExclInclArgumenting);
 yyNodeSize [ExclArgumenting] := SIZE (yExclArgumenting);
 yyNodeSize [InclArgumenting] := SIZE (yInclArgumenting);
 yyNodeSize [SysBitArgumenting] := SIZE (ySysBitArgumenting);
 yyNodeSize [SysLshRotArgumenting] := SIZE (ySysLshRotArgumenting);
 yyNodeSize [SysLshArgumenting] := SIZE (ySysLshArgumenting);
 yyNodeSize [SysRotArgumenting] := SIZE (ySysRotArgumenting);
 yyNodeSize [SysGetPutArgumenting] := SIZE (ySysGetPutArgumenting);
 yyNodeSize [SysGetArgumenting] := SIZE (ySysGetArgumenting);
 yyNodeSize [SysPutArgumenting] := SIZE (ySysPutArgumenting);
 yyNodeSize [SysGetregPutregArgumenting] := SIZE (ySysGetregPutregArgumenting);
 yyNodeSize [SysGetregArgumenting] := SIZE (ySysGetregArgumenting);
 yyNodeSize [SysPutregArgumenting] := SIZE (ySysPutregArgumenting);
 yyNodeSize [SysNewArgumenting] := SIZE (ySysNewArgumenting);
 yyNodeSize [PredeclArgumenting3] := SIZE (yPredeclArgumenting3);
 yyNodeSize [SysMoveArgumenting] := SIZE (ySysMoveArgumenting);
 yyNodeSize [TypeArgumenting] := SIZE (yTypeArgumenting);
 yyNodeSize [MaxMinArgumenting] := SIZE (yMaxMinArgumenting);
 yyNodeSize [MaxArgumenting] := SIZE (yMaxArgumenting);
 yyNodeSize [MinArgumenting] := SIZE (yMinArgumenting);
 yyNodeSize [SizeArgumenting] := SIZE (ySizeArgumenting);
 yyNodeSize [SysValArgumenting] := SIZE (ySysValArgumenting);
 yyNodeSize [NewArgumenting] := SIZE (yNewArgumenting);
 yyNodeSize [SysAsmArgumenting] := SIZE (ySysAsmArgumenting);
 yyNodeSize [ExprLists] := SIZE (yExprLists);
 yyNodeSize [mtExprList] := SIZE (ymtExprList);
 yyNodeSize [ExprList] := SIZE (yExprList);
 yyNodeSize [NewExprLists] := SIZE (yNewExprLists);
 yyNodeSize [mtNewExprList] := SIZE (ymtNewExprList);
 yyNodeSize [NewExprList] := SIZE (yNewExprList);
 yyNodeSize [SysAsmExprLists] := SIZE (ySysAsmExprLists);
 yyNodeSize [mtSysAsmExprList] := SIZE (ymtSysAsmExprList);
 yyNodeSize [SysAsmExprList] := SIZE (ySysAsmExprList);
 yyMaxSize	:= 0;
 FOR yyi := 1 TO 196 DO
  yyNodeSize [yyi] := SYSTEM.VAL(INTEGER,SYSTEM.VAL(SET ,yyNodeSize [yyi] + (General.MaxAlign) - 1) * General.AlignMasks [General.MaxAlign]);
  yyMaxSize := General.Max (yyNodeSize [yyi], yyMaxSize);
 END;
 yyTypeRange [Module] := Module;
 yyTypeRange [Imports] := Import;
 yyTypeRange [mtImport] := mtImport;
 yyTypeRange [Import] := Import;
 yyTypeRange [DeclSection] := DeclSection;
 yyTypeRange [DeclUnits] := DeclUnit;
 yyTypeRange [mtDeclUnit] := mtDeclUnit;
 yyTypeRange [DeclUnit] := DeclUnit;
 yyTypeRange [Decls] := VarDecl;
 yyTypeRange [mtDecl] := mtDecl;
 yyTypeRange [Decl] := VarDecl;
 yyTypeRange [ConstDecl] := ConstDecl;
 yyTypeRange [TypeDecl] := TypeDecl;
 yyTypeRange [VarDecl] := VarDecl;
 yyTypeRange [Procs] := BoundForwardDecl;
 yyTypeRange [mtProc] := mtProc;
 yyTypeRange [Proc] := BoundForwardDecl;
 yyTypeRange [ProcDecl] := ProcDecl;
 yyTypeRange [ForwardDecl] := ForwardDecl;
 yyTypeRange [BoundProcDecl] := BoundProcDecl;
 yyTypeRange [BoundForwardDecl] := BoundForwardDecl;
 yyTypeRange [FormalPars] := FormalPars;
 yyTypeRange [FPSections] := FPSection;
 yyTypeRange [mtFPSection] := mtFPSection;
 yyTypeRange [FPSection] := FPSection;
 yyTypeRange [ParIds] := ParId;
 yyTypeRange [mtParId] := mtParId;
 yyTypeRange [ParId] := ParId;
 yyTypeRange [Receiver] := Receiver;
 yyTypeRange [Type] := ProcedureType;
 yyTypeRange [mtType] := mtType;
 yyTypeRange [NamedType] := NamedType;
 yyTypeRange [ArrayType] := ArrayType;
 yyTypeRange [OpenArrayType] := OpenArrayType;
 yyTypeRange [RecordType] := RecordType;
 yyTypeRange [ExtendedType] := ExtendedType;
 yyTypeRange [PointerType] := PointerToStructType;
 yyTypeRange [PointerToIdType] := PointerToIdType;
 yyTypeRange [PointerToQualIdType] := PointerToQualIdType;
 yyTypeRange [PointerToStructType] := PointerToStructType;
 yyTypeRange [ProcedureType] := ProcedureType;
 yyTypeRange [ArrayExprLists] := ArrayExprList;
 yyTypeRange [mtArrayExprList] := mtArrayExprList;
 yyTypeRange [ArrayExprList] := ArrayExprList;
 yyTypeRange [FieldLists] := FieldList;
 yyTypeRange [mtFieldList] := mtFieldList;
 yyTypeRange [FieldList] := FieldList;
 yyTypeRange [IdentLists] := IdentList;
 yyTypeRange [mtIdentList] := mtIdentList;
 yyTypeRange [IdentList] := IdentList;
 yyTypeRange [Qualidents] := QualifiedIdent;
 yyTypeRange [mtQualident] := mtQualident;
 yyTypeRange [ErrorQualident] := ErrorQualident;
 yyTypeRange [UnqualifiedIdent] := UnqualifiedIdent;
 yyTypeRange [QualifiedIdent] := QualifiedIdent;
 yyTypeRange [IdentDef] := IdentDef;
 yyTypeRange [Stmts] := ReturnStmt;
 yyTypeRange [mtStmt] := mtStmt;
 yyTypeRange [NoStmts] := NoStmts;
 yyTypeRange [Stmt] := ReturnStmt;
 yyTypeRange [AssignStmt] := AssignStmt;
 yyTypeRange [CallStmt] := CallStmt;
 yyTypeRange [IfStmt] := IfStmt;
 yyTypeRange [CaseStmt] := CaseStmt;
 yyTypeRange [WhileStmt] := WhileStmt;
 yyTypeRange [RepeatStmt] := RepeatStmt;
 yyTypeRange [ForStmt] := ForStmt;
 yyTypeRange [LoopStmt] := LoopStmt;
 yyTypeRange [WithStmt] := WithStmt;
 yyTypeRange [ExitStmt] := ExitStmt;
 yyTypeRange [ReturnStmt] := ReturnStmt;
 yyTypeRange [Cases] := Case;
 yyTypeRange [mtCase] := mtCase;
 yyTypeRange [Case] := Case;
 yyTypeRange [CaseLabels] := CaseLabel;
 yyTypeRange [mtCaseLabel] := mtCaseLabel;
 yyTypeRange [CaseLabel] := CaseLabel;
 yyTypeRange [GuardedStmts] := GuardedStmt;
 yyTypeRange [mtGuardedStmt] := mtGuardedStmt;
 yyTypeRange [GuardedStmt] := GuardedStmt;
 yyTypeRange [Guard] := Guard;
 yyTypeRange [ConstExpr] := ConstExpr;
 yyTypeRange [Exprs] := NilConst;
 yyTypeRange [mtExpr] := mtExpr;
 yyTypeRange [MonExpr] := NotExpr;
 yyTypeRange [NegateExpr] := NegateExpr;
 yyTypeRange [IdentityExpr] := IdentityExpr;
 yyTypeRange [NotExpr] := NotExpr;
 yyTypeRange [DyExpr] := DyExpr;
 yyTypeRange [IsExpr] := IsExpr;
 yyTypeRange [SetExpr] := SetExpr;
 yyTypeRange [DesignExpr] := DesignExpr;
 yyTypeRange [SetConst] := SetConst;
 yyTypeRange [IntConst] := IntConst;
 yyTypeRange [RealConst] := RealConst;
 yyTypeRange [LongrealConst] := LongrealConst;
 yyTypeRange [CharConst] := CharConst;
 yyTypeRange [StringConst] := StringConst;
 yyTypeRange [NilConst] := NilConst;
 yyTypeRange [Elements] := Element;
 yyTypeRange [mtElement] := mtElement;
 yyTypeRange [Element] := Element;
 yyTypeRange [DyOperator] := AndOper;
 yyTypeRange [RelationOper] := GreaterEqualOper;
 yyTypeRange [EqualOper] := EqualOper;
 yyTypeRange [UnequalOper] := UnequalOper;
 yyTypeRange [OrderRelationOper] := GreaterEqualOper;
 yyTypeRange [LessOper] := LessOper;
 yyTypeRange [LessEqualOper] := LessEqualOper;
 yyTypeRange [GreaterOper] := GreaterOper;
 yyTypeRange [GreaterEqualOper] := GreaterEqualOper;
 yyTypeRange [InOper] := InOper;
 yyTypeRange [NumSetOper] := ModOper;
 yyTypeRange [PlusOper] := PlusOper;
 yyTypeRange [MinusOper] := MinusOper;
 yyTypeRange [MultOper] := MultOper;
 yyTypeRange [RDivOper] := RDivOper;
 yyTypeRange [IntOper] := ModOper;
 yyTypeRange [DivOper] := DivOper;
 yyTypeRange [ModOper] := ModOper;
 yyTypeRange [BoolOper] := AndOper;
 yyTypeRange [OrOper] := OrOper;
 yyTypeRange [AndOper] := AndOper;
 yyTypeRange [Designator] := Designator;
 yyTypeRange [Designors] := Argumentor;
 yyTypeRange [mtDesignor] := mtDesignor;
 yyTypeRange [Designor] := Argumentor;
 yyTypeRange [Selector] := Selector;
 yyTypeRange [Indexor] := Indexor;
 yyTypeRange [Dereferencor] := Dereferencor;
 yyTypeRange [Argumentor] := Argumentor;
 yyTypeRange [Designations] := SysAsmArgumenting;
 yyTypeRange [mtDesignation] := mtDesignation;
 yyTypeRange [Designation] := SysAsmArgumenting;
 yyTypeRange [Importing] := Importing;
 yyTypeRange [Selecting] := Selecting;
 yyTypeRange [Indexing] := Indexing;
 yyTypeRange [Dereferencing] := Dereferencing;
 yyTypeRange [Supering] := Supering;
 yyTypeRange [Argumenting] := Argumenting;
 yyTypeRange [Guarding] := Guarding;
 yyTypeRange [PredeclArgumenting] := SysAsmArgumenting;
 yyTypeRange [PredeclArgumenting1] := SysCcArgumenting;
 yyTypeRange [AbsArgumenting] := AbsArgumenting;
 yyTypeRange [CapArgumenting] := CapArgumenting;
 yyTypeRange [ChrArgumenting] := ChrArgumenting;
 yyTypeRange [EntierArgumenting] := EntierArgumenting;
 yyTypeRange [LongArgumenting] := LongArgumenting;
 yyTypeRange [OddArgumenting] := OddArgumenting;
 yyTypeRange [OrdArgumenting] := OrdArgumenting;
 yyTypeRange [ShortArgumenting] := ShortArgumenting;
 yyTypeRange [HaltArgumenting] := HaltArgumenting;
 yyTypeRange [SysAdrArgumenting] := SysAdrArgumenting;
 yyTypeRange [SysCcArgumenting] := SysCcArgumenting;
 yyTypeRange [PredeclArgumenting2Opt] := SysNewArgumenting;
 yyTypeRange [LenArgumenting] := LenArgumenting;
 yyTypeRange [AssertArgumenting] := AssertArgumenting;
 yyTypeRange [DecIncArgumenting] := IncArgumenting;
 yyTypeRange [DecArgumenting] := DecArgumenting;
 yyTypeRange [IncArgumenting] := IncArgumenting;
 yyTypeRange [PredeclArgumenting2] := SysNewArgumenting;
 yyTypeRange [AshArgumenting] := AshArgumenting;
 yyTypeRange [CopyArgumenting] := CopyArgumenting;
 yyTypeRange [ExclInclArgumenting] := InclArgumenting;
 yyTypeRange [ExclArgumenting] := ExclArgumenting;
 yyTypeRange [InclArgumenting] := InclArgumenting;
 yyTypeRange [SysBitArgumenting] := SysBitArgumenting;
 yyTypeRange [SysLshRotArgumenting] := SysRotArgumenting;
 yyTypeRange [SysLshArgumenting] := SysLshArgumenting;
 yyTypeRange [SysRotArgumenting] := SysRotArgumenting;
 yyTypeRange [SysGetPutArgumenting] := SysPutArgumenting;
 yyTypeRange [SysGetArgumenting] := SysGetArgumenting;
 yyTypeRange [SysPutArgumenting] := SysPutArgumenting;
 yyTypeRange [SysGetregPutregArgumenting] := SysPutregArgumenting;
 yyTypeRange [SysGetregArgumenting] := SysGetregArgumenting;
 yyTypeRange [SysPutregArgumenting] := SysPutregArgumenting;
 yyTypeRange [SysNewArgumenting] := SysNewArgumenting;
 yyTypeRange [PredeclArgumenting3] := SysMoveArgumenting;
 yyTypeRange [SysMoveArgumenting] := SysMoveArgumenting;
 yyTypeRange [TypeArgumenting] := SysValArgumenting;
 yyTypeRange [MaxMinArgumenting] := MinArgumenting;
 yyTypeRange [MaxArgumenting] := MaxArgumenting;
 yyTypeRange [MinArgumenting] := MinArgumenting;
 yyTypeRange [SizeArgumenting] := SizeArgumenting;
 yyTypeRange [SysValArgumenting] := SysValArgumenting;
 yyTypeRange [NewArgumenting] := NewArgumenting;
 yyTypeRange [SysAsmArgumenting] := SysAsmArgumenting;
 yyTypeRange [ExprLists] := ExprList;
 yyTypeRange [mtExprList] := mtExprList;
 yyTypeRange [ExprList] := ExprList;
 yyTypeRange [NewExprLists] := NewExprList;
 yyTypeRange [mtNewExprList] := mtNewExprList;
 yyTypeRange [NewExprList] := NewExprList;
 yyTypeRange [SysAsmExprLists] := SysAsmExprList;
 yyTypeRange [mtSysAsmExprList] := mtSysAsmExprList;
 yyTypeRange [SysAsmExprList] := SysAsmExprList;
 BeginTree;
END Tree.

