MODULE OB;

IMPORT Base,POS,SYSTEM, System, General, Memory, DynArray, IO, Layout, StringMem, Strings, Idents, Texts, Sets, Positions,
(* line 120 "OB.ast" *)
	       LAB                    ,
               OT                     ,
               STR                    ; 

        TYPE   tIdent*                 = Idents.tIdent        ;        (* These types are re-declared due to the fact that       *)
               oBOOLEAN*               = OT.oBOOLEAN          ;        (* qualidents are illegal in an ast specification.        *)
               oCHAR*                  = OT.oCHAR             ;
               oSTRING*                = OT.oSTRING           ;
               oSET*                   = OT.oSET              ;
               oLONGINT*               = OT.oLONGINT          ;
               oREAL*                  = OT.oREAL             ;
               oLONGREAL*              = OT.oLONGREAL         ;
               tPosition*              = POS.tPosition        ;

CONST
NoOB* = NIL;

mtObject* = 1;
Entries* = 2;
mtEntry* = 3;
ErrorEntry* = 4;
ModuleEntry* = 5;
Entry* = 6;
ScopeEntry* = 7;
DataEntry* = 8;
ServerEntry* = 9;
ConstEntry* = 10;
TypeEntry* = 11;
VarEntry* = 12;
ProcedureEntry* = 13;
BoundProcEntry* = 14;
InheritedProcEntry* = 15;
Environment* = 16;
TypeReprLists* = 17;
mtTypeReprList* = 18;
TypeReprList* = 19;
Blocklists* = 20;
NoBlocklist* = 21;
Blocklist* = 22;
TypeBlocklists* = 23;
TypeReprs* = 24;
mtTypeRepr* = 25;
ErrorTypeRepr* = 26;
TypeRepr* = 27;
ForwardTypeRepr* = 28;
NilTypeRepr* = 29;
ByteTypeRepr* = 30;
PtrTypeRepr* = 31;
BooleanTypeRepr* = 32;
CharTypeRepr* = 33;
CharStringTypeRepr* = 34;
StringTypeRepr* = 35;
SetTypeRepr* = 36;
IntTypeRepr* = 37;
ShortintTypeRepr* = 38;
IntegerTypeRepr* = 39;
LongintTypeRepr* = 40;
FloatTypeRepr* = 41;
RealTypeRepr* = 42;
LongrealTypeRepr* = 43;
ArrayTypeRepr* = 44;
RecordTypeRepr* = 45;
PointerTypeRepr* = 46;
ProcedureTypeRepr* = 47;
PreDeclProcTypeRepr* = 48;
CaseFaultTypeRepr* = 49;
WithFaultTypeRepr* = 50;
AbsTypeRepr* = 51;
AshTypeRepr* = 52;
CapTypeRepr* = 53;
ChrTypeRepr* = 54;
EntierTypeRepr* = 55;
LenTypeRepr* = 56;
LongTypeRepr* = 57;
MaxTypeRepr* = 58;
MinTypeRepr* = 59;
OddTypeRepr* = 60;
OrdTypeRepr* = 61;
ShortTypeRepr* = 62;
SizeTypeRepr* = 63;
AssertTypeRepr* = 64;
CopyTypeRepr* = 65;
DecTypeRepr* = 66;
ExclTypeRepr* = 67;
HaltTypeRepr* = 68;
IncTypeRepr* = 69;
InclTypeRepr* = 70;
NewTypeRepr* = 71;
SysAdrTypeRepr* = 72;
SysBitTypeRepr* = 73;
SysCcTypeRepr* = 74;
SysLshTypeRepr* = 75;
SysRotTypeRepr* = 76;
SysValTypeRepr* = 77;
SysGetTypeRepr* = 78;
SysPutTypeRepr* = 79;
SysGetregTypeRepr* = 80;
SysPutregTypeRepr* = 81;
SysMoveTypeRepr* = 82;
SysNewTypeRepr* = 83;
SysAsmTypeRepr* = 84;
SignatureRepr* = 85;
mtSignature* = 86;
ErrorSignature* = 87;
GenericSignature* = 88;
Signature* = 89;
ValueReprs* = 90;
mtValue* = 91;
ErrorValue* = 92;
ProcedureValue* = 93;
ValueRepr* = 94;
BooleanValue* = 95;
CharValue* = 96;
SetValue* = 97;
IntegerValue* = 98;
MemValueRepr* = 99;
StringValue* = 100;
RealValue* = 101;
LongrealValue* = 102;
NilValue* = 103;
NilPointerValue* = 104;
NilProcedureValue* = 105;
Coercion* = 106;
mtCoercion* = 107;
Shortint2Integer* = 108;
Shortint2Longint* = 109;
Shortint2Real* = 110;
Shortint2Longreal* = 111;
Integer2Longint* = 112;
Integer2Real* = 113;
Integer2Longreal* = 114;
Longint2Real* = 115;
Longint2Longreal* = 116;
Real2Longreal* = 117;
Char2String* = 118;
LabelRanges* = 119;
mtLabelRange* = 120;
CharRange* = 121;
IntegerRange* = 122;
NamePaths* = 123;
mtNamePath* = 124;
NamePath* = 125;
IdentNamePath* = 126;
SelectNamePath* = 127;
IndexNamePath* = 128;
DereferenceNamePath* = 129;
TDescList* = 130;
TDescElems* = 131;
mtTDescElem* = 132;
TDescElem* = 133;

TYPE tOB* = POINTER TO yyNode;
tProcTree* = PROCEDURE (x:tOB);
(* line 23 "OB.ast" *)
 TYPE   tLevel*                 = Base.tLevel;        (* Used to keep track of scope nesting                    *)
               tParMode*               = Base.tParMode;        (* Used to represent the kind of a parameter              *)
               tExportMode*            = Base.tExportMode;        (* Used to represent the export mode                      *)
               tDeclStatus*            = INTEGER              ;        (* Used to represent the declaration status               *)
               tSize*                  = Base.tSize;
               tAddress*               = Base.tAddress;        (* for storage allocation                                 *)
               tLabel*                 = LAB.T                ;

        CONST  NOPROCNUM*              = -1                   ;        (* Bound procedures are numbered...                       *)
               ALLLEVELS*              = {0..31}              ;        (* All possible nesting levels                            *)
               NOLEVELS*               = {}                   ;

        (*** Pseudo constants ***)

        VAR    MODULELEVEL*            ,                               (* The scope of a module block has this level             *)
               ROOTEXTLEVEL*           ,                               (* The extension level of a record which has no base type *)
               FIELDLEVEL*             : tLevel               ;        (* The "scope level" of record fields                     *)

               REFPAR*                 ,                               (* Kind of a variable parameter                           *)
               VALPAR*                 : tParMode             ;        (* Kind of a value parameter                              *)

               PRIVATE*                ,                               (* The three possible export modes                        *)
               PUBLIC*                 ,
               READONLY*               : tExportMode          ;

               UNDECLARED*             ,                               (* The possible states of an entry                        *)
               TOBEDECLARED*           ,
               FORWARDDECLARED*        ,
               DECLARED*               : tDeclStatus          ;


               OPENARRAYLEN*           : oLONGINT             ;        (* "Length" that identifies open arrays                   *)

        (*** A few constant objects ***)

        VAR    cmtObject*              ,
               cNonameEntry*           ,
               cmtEntry*               ,
               cErrorEntry*            ,
               cPredeclModuleEntry*    ,
               cSystemModuleEntry*     ,

               cNoBlocklist*           ,
               cPointerBlocklist*      ,
               cProcedureBlocklist*    ,
               cmtTypeBlocklist*       ,

               cmtTypeReprList*        ,

               cmtTypeRepr*            ,
               cErrorTypeRepr*         ,
               cNilTypeRepr*           ,
               cByteTypeRepr*          ,
               cPtrTypeRepr*           ,
               cBooleanTypeRepr*       ,
               cCharTypeRepr*          ,
               cCharStringTypeRepr*    ,
               cStringTypeRepr*        ,
               cSetTypeRepr*           ,
               cShortintTypeRepr*      ,
               cIntegerTypeRepr*       ,
               cLongintTypeRepr*       ,
               cRealTypeRepr*          ,
               cLongrealTypeRepr*      ,

               cmtValue*               ,
               cErrorValue*            ,
               cProcedureValue*        ,
               cFalseValue*            ,
               cTrueValue*             ,
               cZeroIntegerValue*      ,
               cEmptySetValue*         ,
               cNilValue*              ,
               cNilPointerValue*       ,
               cNilProcedureValue*     ,

               cmtSignature*           ,
               cErrorSignature*        ,
               cGenericSignature*      ,                               (* Used for predeclared procedures                        *)

               cmtCoercion*            ,
               cShortint2Integer*      ,
               cShortint2Longint*      ,
               cShortint2Real*         ,
               cShortint2Longreal*     ,
               cInteger2Longint*       ,
               cInteger2Real*          ,
               cInteger2Longreal*      ,
               cLongint2Real*          ,
               cLongint2Longreal*      ,
               cReal2Longreal*         ,
               cChar2String*           ,

               cmtLabelRange*          ,
	       cmtNamePath*            ,
               cmtTDescElem*           : tOB;




TYPE
yytNodeHead* = RECORD yyKind*, yyMark*:INTEGER; END;
ymtObject* = RECORD yyHead*: yytNodeHead; END;
yEntries* = RECORD yyHead*: yytNodeHead; END;
ymtEntry* = RECORD yyHead*: yytNodeHead; END;
yErrorEntry* = RECORD yyHead*: yytNodeHead; END;
yModuleEntry* = RECORD yyHead*: yytNodeHead; name*: tIdent; globalLabel*: tLabel; isForeign*: BOOLEAN; END;
yEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; END;
yScopeEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; END;
yDataEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; END;
yServerEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; serverTable*: tOB; serverId*: tIdent; END;
yConstEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; typeRepr*: tOB; value*: tOB; label*: tLabel; END;
yTypeEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; typeRepr*: tOB; END;
yVarEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; typeRepr*: tOB; isParam*: BOOLEAN; isReceiverPar*: BOOLEAN; parMode*: tParMode; address*: tAddress; refMode*: tParMode; isWithed*: BOOLEAN; isLaccessed*: BOOLEAN; END;
yProcedureEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; typeRepr*: tOB; complete*: BOOLEAN; position*: tPosition; label*: tLabel; namePath*: tOB; env*: tOB; END;
yBoundProcEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; receiverSig*: tOB; typeRepr*: tOB; complete*: BOOLEAN; position*: tPosition; label*: tLabel; namePath*: tOB; redefinedProc*: tOB; procNum*: LONGINT; env*: tOB; END;
yInheritedProcEntry* = RECORD yyHead*: yytNodeHead; prevEntry*: tOB; module*: tOB; ident*: tIdent; exportMode*: tExportMode; level*: tLevel; declStatus*: tDeclStatus; boundProcEntry*: tOB; END;
yEnvironment* = RECORD yyHead*: yytNodeHead; entry*: tOB; callDstLevels*: SET; END;
yTypeReprLists* = RECORD yyHead*: yytNodeHead; END;
ymtTypeReprList* = RECORD yyHead*: yytNodeHead; END;
yTypeReprList* = RECORD yyHead*: yytNodeHead; prev*: tOB; typeRepr*: tOB; END;
yBlocklists* = RECORD yyHead*: yytNodeHead; END;
yNoBlocklist* = RECORD yyHead*: yytNodeHead; END;
yBlocklist* = RECORD yyHead*: yytNodeHead; prev*: tOB; sub*: tOB; ofs*: tAddress; count*: LONGINT; incr*: tSize; height*: LONGINT; END;
yTypeBlocklists* = RECORD yyHead*: yytNodeHead; ptrBlocklist*: tOB; procBlocklist*: tOB; END;
yTypeReprs* = RECORD yyHead*: yytNodeHead; END;
ymtTypeRepr* = RECORD yyHead*: yytNodeHead; END;
yErrorTypeRepr* = RECORD yyHead*: yytNodeHead; END;
yTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yForwardTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; position*: tPosition; END;
yNilTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yByteTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yPtrTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yBooleanTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yCharTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yCharStringTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yStringTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
ySetTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yIntTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yShortintTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yIntegerTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yLongintTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yFloatTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yRealTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yLongrealTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; END;
yArrayTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; len*: oLONGINT; elemTypeRepr*: tOB; END;
yRecordTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; extLevel*: tLevel; baseTypeRepr*: tOB; extTypeReprList*: tOB; fields*: tOB; nofBoundProcs*: LONGINT; END;
yPointerTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; baseTypeEntry*: tOB; END;
yProcedureTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yPreDeclProcTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yCaseFaultTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yWithFaultTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yAbsTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yAshTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yCapTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yChrTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yEntierTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yLenTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yLongTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yMaxTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yMinTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yOddTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yOrdTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yShortTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySizeTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yAssertTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yCopyTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yDecTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yExclTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yHaltTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yIncTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yInclTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
yNewTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysAdrTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysBitTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysCcTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysLshTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysRotTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysValTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysGetTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysPutTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysGetregTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysPutregTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysMoveTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysNewTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySysAsmTypeRepr* = RECORD yyHead*: yytNodeHead; entry*: tOB; size*: tSize; typeBlocklists*: tOB; isInTDescList*: BOOLEAN; label*: tLabel; signatureRepr*: tOB; resultType*: tOB; paramSpace*: tSize; END;
ySignatureRepr* = RECORD yyHead*: yytNodeHead; END;
ymtSignature* = RECORD yyHead*: yytNodeHead; END;
yErrorSignature* = RECORD yyHead*: yytNodeHead; END;
yGenericSignature* = RECORD yyHead*: yytNodeHead; END;
ySignature* = RECORD yyHead*: yytNodeHead; next*: tOB; VarEntry*: tOB; END;
yValueReprs* = RECORD yyHead*: yytNodeHead; END;
ymtValue* = RECORD yyHead*: yytNodeHead; END;
yErrorValue* = RECORD yyHead*: yytNodeHead; END;
yProcedureValue* = RECORD yyHead*: yytNodeHead; END;
yValueRepr* = RECORD yyHead*: yytNodeHead; END;
yBooleanValue* = RECORD yyHead*: yytNodeHead; v*: oBOOLEAN; END;
yCharValue* = RECORD yyHead*: yytNodeHead; v*: oCHAR; END;
ySetValue* = RECORD yyHead*: yytNodeHead; v*: oSET; END;
yIntegerValue* = RECORD yyHead*: yytNodeHead; v*: oLONGINT; END;
yMemValueRepr* = RECORD yyHead*: yytNodeHead; END;
yStringValue* = RECORD yyHead*: yytNodeHead; v*: oSTRING; END;
yRealValue* = RECORD yyHead*: yytNodeHead; v*: oREAL; END;
yLongrealValue* = RECORD yyHead*: yytNodeHead; v*: oLONGREAL; END;
yNilValue* = RECORD yyHead*: yytNodeHead; END;
yNilPointerValue* = RECORD yyHead*: yytNodeHead; END;
yNilProcedureValue* = RECORD yyHead*: yytNodeHead; END;
yCoercion* = RECORD yyHead*: yytNodeHead; END;
ymtCoercion* = RECORD yyHead*: yytNodeHead; END;
yShortint2Integer* = RECORD yyHead*: yytNodeHead; END;
yShortint2Longint* = RECORD yyHead*: yytNodeHead; END;
yShortint2Real* = RECORD yyHead*: yytNodeHead; END;
yShortint2Longreal* = RECORD yyHead*: yytNodeHead; END;
yInteger2Longint* = RECORD yyHead*: yytNodeHead; END;
yInteger2Real* = RECORD yyHead*: yytNodeHead; END;
yInteger2Longreal* = RECORD yyHead*: yytNodeHead; END;
yLongint2Real* = RECORD yyHead*: yytNodeHead; END;
yLongint2Longreal* = RECORD yyHead*: yytNodeHead; END;
yReal2Longreal* = RECORD yyHead*: yytNodeHead; END;
yChar2String* = RECORD yyHead*: yytNodeHead; END;
yLabelRanges* = RECORD yyHead*: yytNodeHead; END;
ymtLabelRange* = RECORD yyHead*: yytNodeHead; END;
yCharRange* = RECORD yyHead*: yytNodeHead; Next*: tOB; a*: oCHAR; b*: oCHAR; END;
yIntegerRange* = RECORD yyHead*: yytNodeHead; Next*: tOB; a*: oLONGINT; b*: oLONGINT; END;
yNamePaths* = RECORD yyHead*: yytNodeHead; END;
ymtNamePath* = RECORD yyHead*: yytNodeHead; END;
yNamePath* = RECORD yyHead*: yytNodeHead; prev*: tOB; END;
yIdentNamePath* = RECORD yyHead*: yytNodeHead; prev*: tOB; id*: tIdent; END;
ySelectNamePath* = RECORD yyHead*: yytNodeHead; prev*: tOB; END;
yIndexNamePath* = RECORD yyHead*: yytNodeHead; prev*: tOB; END;
yDereferenceNamePath* = RECORD yyHead*: yytNodeHead; prev*: tOB; END;
yTDescList* = RECORD yyHead*: yytNodeHead; TDescElems*: tOB; END;
yTDescElems* = RECORD yyHead*: yytNodeHead; END;
ymtTDescElem* = RECORD yyHead*: yytNodeHead; END;
yTDescElem* = RECORD yyHead*: yytNodeHead; prev*: tOB; namePath*: tOB; TypeReprs*: tOB; END;

yyNode* = RECORD
Kind*: INTEGER;
yyHead*: yytNodeHead;
mtObject*: ymtObject;
Entries*: yEntries;
mtEntry*: ymtEntry;
ErrorEntry*: yErrorEntry;
ModuleEntry*: yModuleEntry;
Entry*: yEntry;
ScopeEntry*: yScopeEntry;
DataEntry*: yDataEntry;
ServerEntry*: yServerEntry;
ConstEntry*: yConstEntry;
TypeEntry*: yTypeEntry;
VarEntry*: yVarEntry;
ProcedureEntry*: yProcedureEntry;
BoundProcEntry*: yBoundProcEntry;
InheritedProcEntry*: yInheritedProcEntry;
Environment*: yEnvironment;
TypeReprLists*: yTypeReprLists;
mtTypeReprList*: ymtTypeReprList;
TypeReprList*: yTypeReprList;
Blocklists*: yBlocklists;
NoBlocklist*: yNoBlocklist;
Blocklist*: yBlocklist;
TypeBlocklists*: yTypeBlocklists;
TypeReprs*: yTypeReprs;
mtTypeRepr*: ymtTypeRepr;
ErrorTypeRepr*: yErrorTypeRepr;
TypeRepr*: yTypeRepr;
ForwardTypeRepr*: yForwardTypeRepr;
NilTypeRepr*: yNilTypeRepr;
ByteTypeRepr*: yByteTypeRepr;
PtrTypeRepr*: yPtrTypeRepr;
BooleanTypeRepr*: yBooleanTypeRepr;
CharTypeRepr*: yCharTypeRepr;
CharStringTypeRepr*: yCharStringTypeRepr;
StringTypeRepr*: yStringTypeRepr;
SetTypeRepr*: ySetTypeRepr;
IntTypeRepr*: yIntTypeRepr;
ShortintTypeRepr*: yShortintTypeRepr;
IntegerTypeRepr*: yIntegerTypeRepr;
LongintTypeRepr*: yLongintTypeRepr;
FloatTypeRepr*: yFloatTypeRepr;
RealTypeRepr*: yRealTypeRepr;
LongrealTypeRepr*: yLongrealTypeRepr;
ArrayTypeRepr*: yArrayTypeRepr;
RecordTypeRepr*: yRecordTypeRepr;
PointerTypeRepr*: yPointerTypeRepr;
ProcedureTypeRepr*: yProcedureTypeRepr;
PreDeclProcTypeRepr*: yPreDeclProcTypeRepr;
CaseFaultTypeRepr*: yCaseFaultTypeRepr;
WithFaultTypeRepr*: yWithFaultTypeRepr;
AbsTypeRepr*: yAbsTypeRepr;
AshTypeRepr*: yAshTypeRepr;
CapTypeRepr*: yCapTypeRepr;
ChrTypeRepr*: yChrTypeRepr;
EntierTypeRepr*: yEntierTypeRepr;
LenTypeRepr*: yLenTypeRepr;
LongTypeRepr*: yLongTypeRepr;
MaxTypeRepr*: yMaxTypeRepr;
MinTypeRepr*: yMinTypeRepr;
OddTypeRepr*: yOddTypeRepr;
OrdTypeRepr*: yOrdTypeRepr;
ShortTypeRepr*: yShortTypeRepr;
SizeTypeRepr*: ySizeTypeRepr;
AssertTypeRepr*: yAssertTypeRepr;
CopyTypeRepr*: yCopyTypeRepr;
DecTypeRepr*: yDecTypeRepr;
ExclTypeRepr*: yExclTypeRepr;
HaltTypeRepr*: yHaltTypeRepr;
IncTypeRepr*: yIncTypeRepr;
InclTypeRepr*: yInclTypeRepr;
NewTypeRepr*: yNewTypeRepr;
SysAdrTypeRepr*: ySysAdrTypeRepr;
SysBitTypeRepr*: ySysBitTypeRepr;
SysCcTypeRepr*: ySysCcTypeRepr;
SysLshTypeRepr*: ySysLshTypeRepr;
SysRotTypeRepr*: ySysRotTypeRepr;
SysValTypeRepr*: ySysValTypeRepr;
SysGetTypeRepr*: ySysGetTypeRepr;
SysPutTypeRepr*: ySysPutTypeRepr;
SysGetregTypeRepr*: ySysGetregTypeRepr;
SysPutregTypeRepr*: ySysPutregTypeRepr;
SysMoveTypeRepr*: ySysMoveTypeRepr;
SysNewTypeRepr*: ySysNewTypeRepr;
SysAsmTypeRepr*: ySysAsmTypeRepr;
SignatureRepr*: ySignatureRepr;
mtSignature*: ymtSignature;
ErrorSignature*: yErrorSignature;
GenericSignature*: yGenericSignature;
Signature*: ySignature;
ValueReprs*: yValueReprs;
mtValue*: ymtValue;
ErrorValue*: yErrorValue;
ProcedureValue*: yProcedureValue;
ValueRepr*: yValueRepr;
BooleanValue*: yBooleanValue;
CharValue*: yCharValue;
SetValue*: ySetValue;
IntegerValue*: yIntegerValue;
MemValueRepr*: yMemValueRepr;
StringValue*: yStringValue;
RealValue*: yRealValue;
LongrealValue*: yLongrealValue;
NilValue*: yNilValue;
NilPointerValue*: yNilPointerValue;
NilProcedureValue*: yNilProcedureValue;
Coercion*: yCoercion;
mtCoercion*: ymtCoercion;
Shortint2Integer*: yShortint2Integer;
Shortint2Longint*: yShortint2Longint;
Shortint2Real*: yShortint2Real;
Shortint2Longreal*: yShortint2Longreal;
Integer2Longint*: yInteger2Longint;
Integer2Real*: yInteger2Real;
Integer2Longreal*: yInteger2Longreal;
Longint2Real*: yLongint2Real;
Longint2Longreal*: yLongint2Longreal;
Real2Longreal*: yReal2Longreal;
Char2String*: yChar2String;
LabelRanges*: yLabelRanges;
mtLabelRange*: ymtLabelRange;
CharRange*: yCharRange;
IntegerRange*: yIntegerRange;
NamePaths*: yNamePaths;
mtNamePath*: ymtNamePath;
NamePath*: yNamePath;
IdentNamePath*: yIdentNamePath;
SelectNamePath*: ySelectNamePath;
IndexNamePath*: yIndexNamePath;
DereferenceNamePath*: yDereferenceNamePath;
TDescList*: yTDescList;
TDescElems*: yTDescElems;
mtTDescElem*: ymtTDescElem;
TDescElem*: yTDescElem;
END;

VAR OBRoot*: tOB;
VAR HeapUsed*:LONGINT;
VAR yyPoolFreePtr*, yyPoolMaxPtr	*:LONGINT; 
VAR yyNodeSize*: ARRAY 134 OF INTEGER;
VAR yyExit*: PROCEDURE;

CONST yyBlockSize = 20480;

TYPE
 yytBlockPtr	= POINTER TO yytBlock;
 yytBlock	= RECORD
		     yyBlock	: ARRAY yyBlockSize+1 OF CHAR;
		     yySuccessor: yytBlockPtr;
		  END;

VAR yyBlockList	: yytBlockPtr;
VAR yyMaxSize, yyi	:INTEGER;
VAR yyTypeRange	: ARRAY 134 OF INTEGER;

TYPE yyPtrtTree	= POINTER TO ARRAY 1 OF tOB;

VAR yyf	: IO.tFile;
VAR yyLabel	: INTEGER;
VAR yyKind	: INTEGER;
VAR yyc	: CHAR;
VAR yys	: Strings.tString;

CONST yyNil	= 0FCX;
CONST yyNoLabel	= 0FDX;
CONST yyLabelDef	= 0FEX;
CONST yyLabelUse	= 0FFX;

        PROCEDURE MinimalIntegerType*(val : OT.oLONGINT) : tOB;
        BEGIN (* MinimalIntegerType *)
         IF    (OT.MINoSHORTINT <= val) & (val <= OT.MAXoSHORTINT)
            THEN RETURN cShortintTypeRepr;
         ELSIF (OT.MINoINTEGER  <= val) & (val <= OT.MAXoINTEGER )
            THEN RETURN cIntegerTypeRepr;
            ELSE RETURN cLongintTypeRepr;
         END; (* IF *)
        END MinimalIntegerType; 

PROCEDURE yyAlloc* (): tOB;
 VAR yyBlockPtr	: yytBlockPtr;
 BEGIN
  yyBlockPtr	:= yyBlockList;
  yyBlockList	:= SYSTEM.VAL(yytBlockPtr,Memory.Alloc (SIZE (yytBlock)));
  yyBlockList^.yySuccessor := yyBlockPtr;
  yyPoolFreePtr	:= SYSTEM.ADR (yyBlockList^.yyBlock);
  yyPoolMaxPtr	:= yyPoolFreePtr + yyBlockSize - yyMaxSize + 1;
  INC (HeapUsed, yyBlockSize);
  RETURN SYSTEM.VAL(tOB,yyPoolFreePtr);
 END yyAlloc;

PROCEDURE MakeOB* (yyKind: INTEGER): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [yyKind] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := yyKind;
  RETURN yyt;
 END MakeOB;

PROCEDURE IsType*(yyTree: tOB; yyKind: INTEGER): BOOLEAN;
 BEGIN
  RETURN (yyTree # NoOB) & (yyKind <= yyTree^.Kind) & (yyTree^.Kind <= yyTypeRange [yyKind]);
 END IsType;


PROCEDURE mmtObject* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtObject] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtObject;
  RETURN yyt;
 END mmtObject;

PROCEDURE mEntries* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Entries] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Entries;
  RETURN yyt;
 END mEntries;

PROCEDURE mmtEntry* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtEntry;
  RETURN yyt;
 END mmtEntry;

PROCEDURE mErrorEntry* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ErrorEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ErrorEntry;
  RETURN yyt;
 END mErrorEntry;

PROCEDURE mModuleEntry* (pname: tIdent; pglobalLabel: tLabel; pisForeign: BOOLEAN): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ModuleEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ModuleEntry;
   yyt^.ModuleEntry.name := pname;
   yyt^.ModuleEntry.globalLabel := pglobalLabel;
   yyt^.ModuleEntry.isForeign := pisForeign;
  RETURN yyt;
 END mModuleEntry;

PROCEDURE mEntry* (pprevEntry: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Entry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Entry;
   yyt^.Entry.prevEntry := pprevEntry;
  RETURN yyt;
 END mEntry;

PROCEDURE mScopeEntry* (pprevEntry: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ScopeEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ScopeEntry;
   yyt^.ScopeEntry.prevEntry := pprevEntry;
  RETURN yyt;
 END mScopeEntry;

PROCEDURE mDataEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DataEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DataEntry;
   yyt^.DataEntry.prevEntry := pprevEntry;
   yyt^.DataEntry.module := pmodule;
   yyt^.DataEntry.ident := pident;
   yyt^.DataEntry.exportMode := pexportMode;
   yyt^.DataEntry.level := plevel;
   yyt^.DataEntry.declStatus := pdeclStatus;
  RETURN yyt;
 END mDataEntry;

PROCEDURE mServerEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; pserverTable: tOB; pserverId: tIdent): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ServerEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ServerEntry;
   yyt^.ServerEntry.prevEntry := pprevEntry;
   yyt^.ServerEntry.module := pmodule;
   yyt^.ServerEntry.ident := pident;
   yyt^.ServerEntry.exportMode := pexportMode;
   yyt^.ServerEntry.level := plevel;
   yyt^.ServerEntry.declStatus := pdeclStatus;
   yyt^.ServerEntry.serverTable := pserverTable;
   yyt^.ServerEntry.serverId := pserverId;
  RETURN yyt;
 END mServerEntry;

PROCEDURE mConstEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; ptypeRepr: tOB; pvalue: tOB; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ConstEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ConstEntry;
   yyt^.ConstEntry.prevEntry := pprevEntry;
   yyt^.ConstEntry.module := pmodule;
   yyt^.ConstEntry.ident := pident;
   yyt^.ConstEntry.exportMode := pexportMode;
   yyt^.ConstEntry.level := plevel;
   yyt^.ConstEntry.declStatus := pdeclStatus;
   yyt^.ConstEntry.typeRepr := ptypeRepr;
   yyt^.ConstEntry.value := pvalue;
   yyt^.ConstEntry.label := plabel;
  RETURN yyt;
 END mConstEntry;

PROCEDURE mTypeEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; ptypeRepr: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeEntry;
   yyt^.TypeEntry.prevEntry := pprevEntry;
   yyt^.TypeEntry.module := pmodule;
   yyt^.TypeEntry.ident := pident;
   yyt^.TypeEntry.exportMode := pexportMode;
   yyt^.TypeEntry.level := plevel;
   yyt^.TypeEntry.declStatus := pdeclStatus;
   yyt^.TypeEntry.typeRepr := ptypeRepr;
  RETURN yyt;
 END mTypeEntry;

PROCEDURE mVarEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; ptypeRepr: tOB; pisParam: BOOLEAN; pisReceiverPar: BOOLEAN; pparMode: tParMode; paddress: tAddress; prefMode: tParMode; pisWithed: BOOLEAN; pisLaccessed: BOOLEAN): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [VarEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := VarEntry;
   yyt^.VarEntry.prevEntry := pprevEntry;
   yyt^.VarEntry.module := pmodule;
   yyt^.VarEntry.ident := pident;
   yyt^.VarEntry.exportMode := pexportMode;
   yyt^.VarEntry.level := plevel;
   yyt^.VarEntry.declStatus := pdeclStatus;
   yyt^.VarEntry.typeRepr := ptypeRepr;
   yyt^.VarEntry.isParam := pisParam;
   yyt^.VarEntry.isReceiverPar := pisReceiverPar;
   yyt^.VarEntry.parMode := pparMode;
   yyt^.VarEntry.address := paddress;
   yyt^.VarEntry.refMode := prefMode;
   yyt^.VarEntry.isWithed := pisWithed;
   yyt^.VarEntry.isLaccessed := pisLaccessed;
  RETURN yyt;
 END mVarEntry;

PROCEDURE mProcedureEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; ptypeRepr: tOB; pcomplete: BOOLEAN; pposition: tPosition; plabel: tLabel; pnamePath: tOB; penv: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ProcedureEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ProcedureEntry;
   yyt^.ProcedureEntry.prevEntry := pprevEntry;
   yyt^.ProcedureEntry.module := pmodule;
   yyt^.ProcedureEntry.ident := pident;
   yyt^.ProcedureEntry.exportMode := pexportMode;
   yyt^.ProcedureEntry.level := plevel;
   yyt^.ProcedureEntry.declStatus := pdeclStatus;
   yyt^.ProcedureEntry.typeRepr := ptypeRepr;
   yyt^.ProcedureEntry.complete := pcomplete;
   yyt^.ProcedureEntry.position := pposition;
   yyt^.ProcedureEntry.label := plabel;
   yyt^.ProcedureEntry.namePath := pnamePath;
   yyt^.ProcedureEntry.env := penv;
  RETURN yyt;
 END mProcedureEntry;

PROCEDURE mBoundProcEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; preceiverSig: tOB; ptypeRepr: tOB; pcomplete: BOOLEAN; pposition: tPosition; plabel: tLabel; pnamePath: tOB; predefinedProc: tOB; pprocNum: LONGINT; penv: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [BoundProcEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := BoundProcEntry;
   yyt^.BoundProcEntry.prevEntry := pprevEntry;
   yyt^.BoundProcEntry.module := pmodule;
   yyt^.BoundProcEntry.ident := pident;
   yyt^.BoundProcEntry.exportMode := pexportMode;
   yyt^.BoundProcEntry.level := plevel;
   yyt^.BoundProcEntry.declStatus := pdeclStatus;
   yyt^.BoundProcEntry.receiverSig := preceiverSig;
   yyt^.BoundProcEntry.typeRepr := ptypeRepr;
   yyt^.BoundProcEntry.complete := pcomplete;
   yyt^.BoundProcEntry.position := pposition;
   yyt^.BoundProcEntry.label := plabel;
   yyt^.BoundProcEntry.namePath := pnamePath;
   yyt^.BoundProcEntry.redefinedProc := predefinedProc;
   yyt^.BoundProcEntry.procNum := pprocNum;
   yyt^.BoundProcEntry.env := penv;
  RETURN yyt;
 END mBoundProcEntry;

PROCEDURE mInheritedProcEntry* (pprevEntry: tOB; pmodule: tOB; pident: tIdent; pexportMode: tExportMode; plevel: tLevel; pdeclStatus: tDeclStatus; pboundProcEntry: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [InheritedProcEntry] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := InheritedProcEntry;
   yyt^.InheritedProcEntry.prevEntry := pprevEntry;
   yyt^.InheritedProcEntry.module := pmodule;
   yyt^.InheritedProcEntry.ident := pident;
   yyt^.InheritedProcEntry.exportMode := pexportMode;
   yyt^.InheritedProcEntry.level := plevel;
   yyt^.InheritedProcEntry.declStatus := pdeclStatus;
   yyt^.InheritedProcEntry.boundProcEntry := pboundProcEntry;
  RETURN yyt;
 END mInheritedProcEntry;

PROCEDURE mEnvironment* (pentry: tOB; pcallDstLevels: SET): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Environment] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Environment;
   yyt^.Environment.entry := pentry;
   yyt^.Environment.callDstLevels := pcallDstLevels;
  RETURN yyt;
 END mEnvironment;

PROCEDURE mTypeReprLists* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeReprLists] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeReprLists;
  RETURN yyt;
 END mTypeReprLists;

PROCEDURE mmtTypeReprList* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtTypeReprList] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtTypeReprList;
  RETURN yyt;
 END mmtTypeReprList;

PROCEDURE mTypeReprList* (pprev: tOB; ptypeRepr: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeReprList] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeReprList;
   yyt^.TypeReprList.prev := pprev;
   yyt^.TypeReprList.typeRepr := ptypeRepr;
  RETURN yyt;
 END mTypeReprList;

PROCEDURE mBlocklists* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Blocklists] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Blocklists;
  RETURN yyt;
 END mBlocklists;

PROCEDURE mNoBlocklist* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NoBlocklist] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NoBlocklist;
  RETURN yyt;
 END mNoBlocklist;

PROCEDURE mBlocklist* (pprev: tOB; psub: tOB; pofs: tAddress; pcount: LONGINT; pincr: tSize; pheight: LONGINT): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Blocklist] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Blocklist;
   yyt^.Blocklist.prev := pprev;
   yyt^.Blocklist.sub := psub;
   yyt^.Blocklist.ofs := pofs;
   yyt^.Blocklist.count := pcount;
   yyt^.Blocklist.incr := pincr;
   yyt^.Blocklist.height := pheight;
  RETURN yyt;
 END mBlocklist;

PROCEDURE mTypeBlocklists* (pptrBlocklist: tOB; pprocBlocklist: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeBlocklists] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeBlocklists;
   yyt^.TypeBlocklists.ptrBlocklist := pptrBlocklist;
   yyt^.TypeBlocklists.procBlocklist := pprocBlocklist;
  RETURN yyt;
 END mTypeBlocklists;

PROCEDURE mTypeReprs* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeReprs] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeReprs;
  RETURN yyt;
 END mTypeReprs;

PROCEDURE mmtTypeRepr* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtTypeRepr;
  RETURN yyt;
 END mmtTypeRepr;

PROCEDURE mErrorTypeRepr* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ErrorTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ErrorTypeRepr;
  RETURN yyt;
 END mErrorTypeRepr;

PROCEDURE mTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TypeRepr;
   yyt^.TypeRepr.entry := pentry;
   yyt^.TypeRepr.size := psize;
   yyt^.TypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.TypeRepr.isInTDescList := pisInTDescList;
   yyt^.TypeRepr.label := plabel;
  RETURN yyt;
 END mTypeRepr;

PROCEDURE mForwardTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; pposition: tPosition): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ForwardTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ForwardTypeRepr;
   yyt^.ForwardTypeRepr.entry := pentry;
   yyt^.ForwardTypeRepr.size := psize;
   yyt^.ForwardTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ForwardTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ForwardTypeRepr.label := plabel;
   yyt^.ForwardTypeRepr.position := pposition;
  RETURN yyt;
 END mForwardTypeRepr;

PROCEDURE mNilTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NilTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NilTypeRepr;
   yyt^.NilTypeRepr.entry := pentry;
   yyt^.NilTypeRepr.size := psize;
   yyt^.NilTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.NilTypeRepr.isInTDescList := pisInTDescList;
   yyt^.NilTypeRepr.label := plabel;
  RETURN yyt;
 END mNilTypeRepr;

PROCEDURE mByteTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ByteTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ByteTypeRepr;
   yyt^.ByteTypeRepr.entry := pentry;
   yyt^.ByteTypeRepr.size := psize;
   yyt^.ByteTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ByteTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ByteTypeRepr.label := plabel;
  RETURN yyt;
 END mByteTypeRepr;

PROCEDURE mPtrTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PtrTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PtrTypeRepr;
   yyt^.PtrTypeRepr.entry := pentry;
   yyt^.PtrTypeRepr.size := psize;
   yyt^.PtrTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.PtrTypeRepr.isInTDescList := pisInTDescList;
   yyt^.PtrTypeRepr.label := plabel;
  RETURN yyt;
 END mPtrTypeRepr;

PROCEDURE mBooleanTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [BooleanTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := BooleanTypeRepr;
   yyt^.BooleanTypeRepr.entry := pentry;
   yyt^.BooleanTypeRepr.size := psize;
   yyt^.BooleanTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.BooleanTypeRepr.isInTDescList := pisInTDescList;
   yyt^.BooleanTypeRepr.label := plabel;
  RETURN yyt;
 END mBooleanTypeRepr;

PROCEDURE mCharTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CharTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CharTypeRepr;
   yyt^.CharTypeRepr.entry := pentry;
   yyt^.CharTypeRepr.size := psize;
   yyt^.CharTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.CharTypeRepr.isInTDescList := pisInTDescList;
   yyt^.CharTypeRepr.label := plabel;
  RETURN yyt;
 END mCharTypeRepr;

PROCEDURE mCharStringTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CharStringTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CharStringTypeRepr;
   yyt^.CharStringTypeRepr.entry := pentry;
   yyt^.CharStringTypeRepr.size := psize;
   yyt^.CharStringTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.CharStringTypeRepr.isInTDescList := pisInTDescList;
   yyt^.CharStringTypeRepr.label := plabel;
  RETURN yyt;
 END mCharStringTypeRepr;

PROCEDURE mStringTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [StringTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := StringTypeRepr;
   yyt^.StringTypeRepr.entry := pentry;
   yyt^.StringTypeRepr.size := psize;
   yyt^.StringTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.StringTypeRepr.isInTDescList := pisInTDescList;
   yyt^.StringTypeRepr.label := plabel;
  RETURN yyt;
 END mStringTypeRepr;

PROCEDURE mSetTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SetTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SetTypeRepr;
   yyt^.SetTypeRepr.entry := pentry;
   yyt^.SetTypeRepr.size := psize;
   yyt^.SetTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SetTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SetTypeRepr.label := plabel;
  RETURN yyt;
 END mSetTypeRepr;

PROCEDURE mIntTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IntTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IntTypeRepr;
   yyt^.IntTypeRepr.entry := pentry;
   yyt^.IntTypeRepr.size := psize;
   yyt^.IntTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.IntTypeRepr.isInTDescList := pisInTDescList;
   yyt^.IntTypeRepr.label := plabel;
  RETURN yyt;
 END mIntTypeRepr;

PROCEDURE mShortintTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ShortintTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ShortintTypeRepr;
   yyt^.ShortintTypeRepr.entry := pentry;
   yyt^.ShortintTypeRepr.size := psize;
   yyt^.ShortintTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ShortintTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ShortintTypeRepr.label := plabel;
  RETURN yyt;
 END mShortintTypeRepr;

PROCEDURE mIntegerTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IntegerTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IntegerTypeRepr;
   yyt^.IntegerTypeRepr.entry := pentry;
   yyt^.IntegerTypeRepr.size := psize;
   yyt^.IntegerTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.IntegerTypeRepr.isInTDescList := pisInTDescList;
   yyt^.IntegerTypeRepr.label := plabel;
  RETURN yyt;
 END mIntegerTypeRepr;

PROCEDURE mLongintTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LongintTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LongintTypeRepr;
   yyt^.LongintTypeRepr.entry := pentry;
   yyt^.LongintTypeRepr.size := psize;
   yyt^.LongintTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.LongintTypeRepr.isInTDescList := pisInTDescList;
   yyt^.LongintTypeRepr.label := plabel;
  RETURN yyt;
 END mLongintTypeRepr;

PROCEDURE mFloatTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [FloatTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := FloatTypeRepr;
   yyt^.FloatTypeRepr.entry := pentry;
   yyt^.FloatTypeRepr.size := psize;
   yyt^.FloatTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.FloatTypeRepr.isInTDescList := pisInTDescList;
   yyt^.FloatTypeRepr.label := plabel;
  RETURN yyt;
 END mFloatTypeRepr;

PROCEDURE mRealTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RealTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RealTypeRepr;
   yyt^.RealTypeRepr.entry := pentry;
   yyt^.RealTypeRepr.size := psize;
   yyt^.RealTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.RealTypeRepr.isInTDescList := pisInTDescList;
   yyt^.RealTypeRepr.label := plabel;
  RETURN yyt;
 END mRealTypeRepr;

PROCEDURE mLongrealTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LongrealTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LongrealTypeRepr;
   yyt^.LongrealTypeRepr.entry := pentry;
   yyt^.LongrealTypeRepr.size := psize;
   yyt^.LongrealTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.LongrealTypeRepr.isInTDescList := pisInTDescList;
   yyt^.LongrealTypeRepr.label := plabel;
  RETURN yyt;
 END mLongrealTypeRepr;

PROCEDURE mArrayTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; plen: oLONGINT; pelemTypeRepr: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ArrayTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ArrayTypeRepr;
   yyt^.ArrayTypeRepr.entry := pentry;
   yyt^.ArrayTypeRepr.size := psize;
   yyt^.ArrayTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ArrayTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ArrayTypeRepr.label := plabel;
   yyt^.ArrayTypeRepr.len := plen;
   yyt^.ArrayTypeRepr.elemTypeRepr := pelemTypeRepr;
  RETURN yyt;
 END mArrayTypeRepr;

PROCEDURE mRecordTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; pextLevel: tLevel; pbaseTypeRepr: tOB; pextTypeReprList: tOB; pfields: tOB; pnofBoundProcs: LONGINT): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RecordTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RecordTypeRepr;
   yyt^.RecordTypeRepr.entry := pentry;
   yyt^.RecordTypeRepr.size := psize;
   yyt^.RecordTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.RecordTypeRepr.isInTDescList := pisInTDescList;
   yyt^.RecordTypeRepr.label := plabel;
   yyt^.RecordTypeRepr.extLevel := pextLevel;
   yyt^.RecordTypeRepr.baseTypeRepr := pbaseTypeRepr;
   yyt^.RecordTypeRepr.extTypeReprList := pextTypeReprList;
   yyt^.RecordTypeRepr.fields := pfields;
   yyt^.RecordTypeRepr.nofBoundProcs := pnofBoundProcs;
  RETURN yyt;
 END mRecordTypeRepr;

PROCEDURE mPointerTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; pbaseTypeEntry: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PointerTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PointerTypeRepr;
   yyt^.PointerTypeRepr.entry := pentry;
   yyt^.PointerTypeRepr.size := psize;
   yyt^.PointerTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.PointerTypeRepr.isInTDescList := pisInTDescList;
   yyt^.PointerTypeRepr.label := plabel;
   yyt^.PointerTypeRepr.baseTypeEntry := pbaseTypeEntry;
  RETURN yyt;
 END mPointerTypeRepr;

PROCEDURE mProcedureTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ProcedureTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ProcedureTypeRepr;
   yyt^.ProcedureTypeRepr.entry := pentry;
   yyt^.ProcedureTypeRepr.size := psize;
   yyt^.ProcedureTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ProcedureTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ProcedureTypeRepr.label := plabel;
   yyt^.ProcedureTypeRepr.signatureRepr := psignatureRepr;
   yyt^.ProcedureTypeRepr.resultType := presultType;
   yyt^.ProcedureTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mProcedureTypeRepr;

PROCEDURE mPreDeclProcTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [PreDeclProcTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := PreDeclProcTypeRepr;
   yyt^.PreDeclProcTypeRepr.entry := pentry;
   yyt^.PreDeclProcTypeRepr.size := psize;
   yyt^.PreDeclProcTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.PreDeclProcTypeRepr.isInTDescList := pisInTDescList;
   yyt^.PreDeclProcTypeRepr.label := plabel;
   yyt^.PreDeclProcTypeRepr.signatureRepr := psignatureRepr;
   yyt^.PreDeclProcTypeRepr.resultType := presultType;
   yyt^.PreDeclProcTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mPreDeclProcTypeRepr;

PROCEDURE mCaseFaultTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CaseFaultTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CaseFaultTypeRepr;
   yyt^.CaseFaultTypeRepr.entry := pentry;
   yyt^.CaseFaultTypeRepr.size := psize;
   yyt^.CaseFaultTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.CaseFaultTypeRepr.isInTDescList := pisInTDescList;
   yyt^.CaseFaultTypeRepr.label := plabel;
   yyt^.CaseFaultTypeRepr.signatureRepr := psignatureRepr;
   yyt^.CaseFaultTypeRepr.resultType := presultType;
   yyt^.CaseFaultTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mCaseFaultTypeRepr;

PROCEDURE mWithFaultTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [WithFaultTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := WithFaultTypeRepr;
   yyt^.WithFaultTypeRepr.entry := pentry;
   yyt^.WithFaultTypeRepr.size := psize;
   yyt^.WithFaultTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.WithFaultTypeRepr.isInTDescList := pisInTDescList;
   yyt^.WithFaultTypeRepr.label := plabel;
   yyt^.WithFaultTypeRepr.signatureRepr := psignatureRepr;
   yyt^.WithFaultTypeRepr.resultType := presultType;
   yyt^.WithFaultTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mWithFaultTypeRepr;

PROCEDURE mAbsTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AbsTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AbsTypeRepr;
   yyt^.AbsTypeRepr.entry := pentry;
   yyt^.AbsTypeRepr.size := psize;
   yyt^.AbsTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.AbsTypeRepr.isInTDescList := pisInTDescList;
   yyt^.AbsTypeRepr.label := plabel;
   yyt^.AbsTypeRepr.signatureRepr := psignatureRepr;
   yyt^.AbsTypeRepr.resultType := presultType;
   yyt^.AbsTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mAbsTypeRepr;

PROCEDURE mAshTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AshTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AshTypeRepr;
   yyt^.AshTypeRepr.entry := pentry;
   yyt^.AshTypeRepr.size := psize;
   yyt^.AshTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.AshTypeRepr.isInTDescList := pisInTDescList;
   yyt^.AshTypeRepr.label := plabel;
   yyt^.AshTypeRepr.signatureRepr := psignatureRepr;
   yyt^.AshTypeRepr.resultType := presultType;
   yyt^.AshTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mAshTypeRepr;

PROCEDURE mCapTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CapTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CapTypeRepr;
   yyt^.CapTypeRepr.entry := pentry;
   yyt^.CapTypeRepr.size := psize;
   yyt^.CapTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.CapTypeRepr.isInTDescList := pisInTDescList;
   yyt^.CapTypeRepr.label := plabel;
   yyt^.CapTypeRepr.signatureRepr := psignatureRepr;
   yyt^.CapTypeRepr.resultType := presultType;
   yyt^.CapTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mCapTypeRepr;

PROCEDURE mChrTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ChrTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ChrTypeRepr;
   yyt^.ChrTypeRepr.entry := pentry;
   yyt^.ChrTypeRepr.size := psize;
   yyt^.ChrTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ChrTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ChrTypeRepr.label := plabel;
   yyt^.ChrTypeRepr.signatureRepr := psignatureRepr;
   yyt^.ChrTypeRepr.resultType := presultType;
   yyt^.ChrTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mChrTypeRepr;

PROCEDURE mEntierTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [EntierTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := EntierTypeRepr;
   yyt^.EntierTypeRepr.entry := pentry;
   yyt^.EntierTypeRepr.size := psize;
   yyt^.EntierTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.EntierTypeRepr.isInTDescList := pisInTDescList;
   yyt^.EntierTypeRepr.label := plabel;
   yyt^.EntierTypeRepr.signatureRepr := psignatureRepr;
   yyt^.EntierTypeRepr.resultType := presultType;
   yyt^.EntierTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mEntierTypeRepr;

PROCEDURE mLenTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LenTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LenTypeRepr;
   yyt^.LenTypeRepr.entry := pentry;
   yyt^.LenTypeRepr.size := psize;
   yyt^.LenTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.LenTypeRepr.isInTDescList := pisInTDescList;
   yyt^.LenTypeRepr.label := plabel;
   yyt^.LenTypeRepr.signatureRepr := psignatureRepr;
   yyt^.LenTypeRepr.resultType := presultType;
   yyt^.LenTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mLenTypeRepr;

PROCEDURE mLongTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LongTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LongTypeRepr;
   yyt^.LongTypeRepr.entry := pentry;
   yyt^.LongTypeRepr.size := psize;
   yyt^.LongTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.LongTypeRepr.isInTDescList := pisInTDescList;
   yyt^.LongTypeRepr.label := plabel;
   yyt^.LongTypeRepr.signatureRepr := psignatureRepr;
   yyt^.LongTypeRepr.resultType := presultType;
   yyt^.LongTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mLongTypeRepr;

PROCEDURE mMaxTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MaxTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MaxTypeRepr;
   yyt^.MaxTypeRepr.entry := pentry;
   yyt^.MaxTypeRepr.size := psize;
   yyt^.MaxTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.MaxTypeRepr.isInTDescList := pisInTDescList;
   yyt^.MaxTypeRepr.label := plabel;
   yyt^.MaxTypeRepr.signatureRepr := psignatureRepr;
   yyt^.MaxTypeRepr.resultType := presultType;
   yyt^.MaxTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mMaxTypeRepr;

PROCEDURE mMinTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MinTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MinTypeRepr;
   yyt^.MinTypeRepr.entry := pentry;
   yyt^.MinTypeRepr.size := psize;
   yyt^.MinTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.MinTypeRepr.isInTDescList := pisInTDescList;
   yyt^.MinTypeRepr.label := plabel;
   yyt^.MinTypeRepr.signatureRepr := psignatureRepr;
   yyt^.MinTypeRepr.resultType := presultType;
   yyt^.MinTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mMinTypeRepr;

PROCEDURE mOddTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OddTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OddTypeRepr;
   yyt^.OddTypeRepr.entry := pentry;
   yyt^.OddTypeRepr.size := psize;
   yyt^.OddTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.OddTypeRepr.isInTDescList := pisInTDescList;
   yyt^.OddTypeRepr.label := plabel;
   yyt^.OddTypeRepr.signatureRepr := psignatureRepr;
   yyt^.OddTypeRepr.resultType := presultType;
   yyt^.OddTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mOddTypeRepr;

PROCEDURE mOrdTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [OrdTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := OrdTypeRepr;
   yyt^.OrdTypeRepr.entry := pentry;
   yyt^.OrdTypeRepr.size := psize;
   yyt^.OrdTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.OrdTypeRepr.isInTDescList := pisInTDescList;
   yyt^.OrdTypeRepr.label := plabel;
   yyt^.OrdTypeRepr.signatureRepr := psignatureRepr;
   yyt^.OrdTypeRepr.resultType := presultType;
   yyt^.OrdTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mOrdTypeRepr;

PROCEDURE mShortTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ShortTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ShortTypeRepr;
   yyt^.ShortTypeRepr.entry := pentry;
   yyt^.ShortTypeRepr.size := psize;
   yyt^.ShortTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ShortTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ShortTypeRepr.label := plabel;
   yyt^.ShortTypeRepr.signatureRepr := psignatureRepr;
   yyt^.ShortTypeRepr.resultType := presultType;
   yyt^.ShortTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mShortTypeRepr;

PROCEDURE mSizeTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SizeTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SizeTypeRepr;
   yyt^.SizeTypeRepr.entry := pentry;
   yyt^.SizeTypeRepr.size := psize;
   yyt^.SizeTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SizeTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SizeTypeRepr.label := plabel;
   yyt^.SizeTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SizeTypeRepr.resultType := presultType;
   yyt^.SizeTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSizeTypeRepr;

PROCEDURE mAssertTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [AssertTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := AssertTypeRepr;
   yyt^.AssertTypeRepr.entry := pentry;
   yyt^.AssertTypeRepr.size := psize;
   yyt^.AssertTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.AssertTypeRepr.isInTDescList := pisInTDescList;
   yyt^.AssertTypeRepr.label := plabel;
   yyt^.AssertTypeRepr.signatureRepr := psignatureRepr;
   yyt^.AssertTypeRepr.resultType := presultType;
   yyt^.AssertTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mAssertTypeRepr;

PROCEDURE mCopyTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CopyTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CopyTypeRepr;
   yyt^.CopyTypeRepr.entry := pentry;
   yyt^.CopyTypeRepr.size := psize;
   yyt^.CopyTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.CopyTypeRepr.isInTDescList := pisInTDescList;
   yyt^.CopyTypeRepr.label := plabel;
   yyt^.CopyTypeRepr.signatureRepr := psignatureRepr;
   yyt^.CopyTypeRepr.resultType := presultType;
   yyt^.CopyTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mCopyTypeRepr;

PROCEDURE mDecTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DecTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DecTypeRepr;
   yyt^.DecTypeRepr.entry := pentry;
   yyt^.DecTypeRepr.size := psize;
   yyt^.DecTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.DecTypeRepr.isInTDescList := pisInTDescList;
   yyt^.DecTypeRepr.label := plabel;
   yyt^.DecTypeRepr.signatureRepr := psignatureRepr;
   yyt^.DecTypeRepr.resultType := presultType;
   yyt^.DecTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mDecTypeRepr;

PROCEDURE mExclTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ExclTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ExclTypeRepr;
   yyt^.ExclTypeRepr.entry := pentry;
   yyt^.ExclTypeRepr.size := psize;
   yyt^.ExclTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.ExclTypeRepr.isInTDescList := pisInTDescList;
   yyt^.ExclTypeRepr.label := plabel;
   yyt^.ExclTypeRepr.signatureRepr := psignatureRepr;
   yyt^.ExclTypeRepr.resultType := presultType;
   yyt^.ExclTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mExclTypeRepr;

PROCEDURE mHaltTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [HaltTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := HaltTypeRepr;
   yyt^.HaltTypeRepr.entry := pentry;
   yyt^.HaltTypeRepr.size := psize;
   yyt^.HaltTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.HaltTypeRepr.isInTDescList := pisInTDescList;
   yyt^.HaltTypeRepr.label := plabel;
   yyt^.HaltTypeRepr.signatureRepr := psignatureRepr;
   yyt^.HaltTypeRepr.resultType := presultType;
   yyt^.HaltTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mHaltTypeRepr;

PROCEDURE mIncTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IncTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IncTypeRepr;
   yyt^.IncTypeRepr.entry := pentry;
   yyt^.IncTypeRepr.size := psize;
   yyt^.IncTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.IncTypeRepr.isInTDescList := pisInTDescList;
   yyt^.IncTypeRepr.label := plabel;
   yyt^.IncTypeRepr.signatureRepr := psignatureRepr;
   yyt^.IncTypeRepr.resultType := presultType;
   yyt^.IncTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mIncTypeRepr;

PROCEDURE mInclTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [InclTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := InclTypeRepr;
   yyt^.InclTypeRepr.entry := pentry;
   yyt^.InclTypeRepr.size := psize;
   yyt^.InclTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.InclTypeRepr.isInTDescList := pisInTDescList;
   yyt^.InclTypeRepr.label := plabel;
   yyt^.InclTypeRepr.signatureRepr := psignatureRepr;
   yyt^.InclTypeRepr.resultType := presultType;
   yyt^.InclTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mInclTypeRepr;

PROCEDURE mNewTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NewTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NewTypeRepr;
   yyt^.NewTypeRepr.entry := pentry;
   yyt^.NewTypeRepr.size := psize;
   yyt^.NewTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.NewTypeRepr.isInTDescList := pisInTDescList;
   yyt^.NewTypeRepr.label := plabel;
   yyt^.NewTypeRepr.signatureRepr := psignatureRepr;
   yyt^.NewTypeRepr.resultType := presultType;
   yyt^.NewTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mNewTypeRepr;

PROCEDURE mSysAdrTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysAdrTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysAdrTypeRepr;
   yyt^.SysAdrTypeRepr.entry := pentry;
   yyt^.SysAdrTypeRepr.size := psize;
   yyt^.SysAdrTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysAdrTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysAdrTypeRepr.label := plabel;
   yyt^.SysAdrTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysAdrTypeRepr.resultType := presultType;
   yyt^.SysAdrTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysAdrTypeRepr;

PROCEDURE mSysBitTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysBitTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysBitTypeRepr;
   yyt^.SysBitTypeRepr.entry := pentry;
   yyt^.SysBitTypeRepr.size := psize;
   yyt^.SysBitTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysBitTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysBitTypeRepr.label := plabel;
   yyt^.SysBitTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysBitTypeRepr.resultType := presultType;
   yyt^.SysBitTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysBitTypeRepr;

PROCEDURE mSysCcTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysCcTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysCcTypeRepr;
   yyt^.SysCcTypeRepr.entry := pentry;
   yyt^.SysCcTypeRepr.size := psize;
   yyt^.SysCcTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysCcTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysCcTypeRepr.label := plabel;
   yyt^.SysCcTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysCcTypeRepr.resultType := presultType;
   yyt^.SysCcTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysCcTypeRepr;

PROCEDURE mSysLshTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysLshTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysLshTypeRepr;
   yyt^.SysLshTypeRepr.entry := pentry;
   yyt^.SysLshTypeRepr.size := psize;
   yyt^.SysLshTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysLshTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysLshTypeRepr.label := plabel;
   yyt^.SysLshTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysLshTypeRepr.resultType := presultType;
   yyt^.SysLshTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysLshTypeRepr;

PROCEDURE mSysRotTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysRotTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysRotTypeRepr;
   yyt^.SysRotTypeRepr.entry := pentry;
   yyt^.SysRotTypeRepr.size := psize;
   yyt^.SysRotTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysRotTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysRotTypeRepr.label := plabel;
   yyt^.SysRotTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysRotTypeRepr.resultType := presultType;
   yyt^.SysRotTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysRotTypeRepr;

PROCEDURE mSysValTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysValTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysValTypeRepr;
   yyt^.SysValTypeRepr.entry := pentry;
   yyt^.SysValTypeRepr.size := psize;
   yyt^.SysValTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysValTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysValTypeRepr.label := plabel;
   yyt^.SysValTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysValTypeRepr.resultType := presultType;
   yyt^.SysValTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysValTypeRepr;

PROCEDURE mSysGetTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysGetTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysGetTypeRepr;
   yyt^.SysGetTypeRepr.entry := pentry;
   yyt^.SysGetTypeRepr.size := psize;
   yyt^.SysGetTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysGetTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysGetTypeRepr.label := plabel;
   yyt^.SysGetTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysGetTypeRepr.resultType := presultType;
   yyt^.SysGetTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysGetTypeRepr;

PROCEDURE mSysPutTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysPutTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysPutTypeRepr;
   yyt^.SysPutTypeRepr.entry := pentry;
   yyt^.SysPutTypeRepr.size := psize;
   yyt^.SysPutTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysPutTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysPutTypeRepr.label := plabel;
   yyt^.SysPutTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysPutTypeRepr.resultType := presultType;
   yyt^.SysPutTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysPutTypeRepr;

PROCEDURE mSysGetregTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysGetregTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysGetregTypeRepr;
   yyt^.SysGetregTypeRepr.entry := pentry;
   yyt^.SysGetregTypeRepr.size := psize;
   yyt^.SysGetregTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysGetregTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysGetregTypeRepr.label := plabel;
   yyt^.SysGetregTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysGetregTypeRepr.resultType := presultType;
   yyt^.SysGetregTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysGetregTypeRepr;

PROCEDURE mSysPutregTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysPutregTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysPutregTypeRepr;
   yyt^.SysPutregTypeRepr.entry := pentry;
   yyt^.SysPutregTypeRepr.size := psize;
   yyt^.SysPutregTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysPutregTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysPutregTypeRepr.label := plabel;
   yyt^.SysPutregTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysPutregTypeRepr.resultType := presultType;
   yyt^.SysPutregTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysPutregTypeRepr;

PROCEDURE mSysMoveTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysMoveTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysMoveTypeRepr;
   yyt^.SysMoveTypeRepr.entry := pentry;
   yyt^.SysMoveTypeRepr.size := psize;
   yyt^.SysMoveTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysMoveTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysMoveTypeRepr.label := plabel;
   yyt^.SysMoveTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysMoveTypeRepr.resultType := presultType;
   yyt^.SysMoveTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysMoveTypeRepr;

PROCEDURE mSysNewTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysNewTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysNewTypeRepr;
   yyt^.SysNewTypeRepr.entry := pentry;
   yyt^.SysNewTypeRepr.size := psize;
   yyt^.SysNewTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysNewTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysNewTypeRepr.label := plabel;
   yyt^.SysNewTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysNewTypeRepr.resultType := presultType;
   yyt^.SysNewTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysNewTypeRepr;

PROCEDURE mSysAsmTypeRepr* (pentry: tOB; psize: tSize; ptypeBlocklists: tOB; pisInTDescList: BOOLEAN; plabel: tLabel; psignatureRepr: tOB; presultType: tOB; pparamSpace: tSize): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SysAsmTypeRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SysAsmTypeRepr;
   yyt^.SysAsmTypeRepr.entry := pentry;
   yyt^.SysAsmTypeRepr.size := psize;
   yyt^.SysAsmTypeRepr.typeBlocklists := ptypeBlocklists;
   yyt^.SysAsmTypeRepr.isInTDescList := pisInTDescList;
   yyt^.SysAsmTypeRepr.label := plabel;
   yyt^.SysAsmTypeRepr.signatureRepr := psignatureRepr;
   yyt^.SysAsmTypeRepr.resultType := presultType;
   yyt^.SysAsmTypeRepr.paramSpace := pparamSpace;
  RETURN yyt;
 END mSysAsmTypeRepr;

PROCEDURE mSignatureRepr* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SignatureRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SignatureRepr;
  RETURN yyt;
 END mSignatureRepr;

PROCEDURE mmtSignature* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtSignature] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtSignature;
  RETURN yyt;
 END mmtSignature;

PROCEDURE mErrorSignature* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ErrorSignature] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ErrorSignature;
  RETURN yyt;
 END mErrorSignature;

PROCEDURE mGenericSignature* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [GenericSignature] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := GenericSignature;
  RETURN yyt;
 END mGenericSignature;

PROCEDURE mSignature* (pnext: tOB; pVarEntry: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Signature] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Signature;
   yyt^.Signature.next := pnext;
   yyt^.Signature.VarEntry := pVarEntry;
  RETURN yyt;
 END mSignature;

PROCEDURE mValueReprs* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ValueReprs] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ValueReprs;
  RETURN yyt;
 END mValueReprs;

PROCEDURE mmtValue* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtValue;
  RETURN yyt;
 END mmtValue;

PROCEDURE mErrorValue* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ErrorValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ErrorValue;
  RETURN yyt;
 END mErrorValue;

PROCEDURE mProcedureValue* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ProcedureValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ProcedureValue;
  RETURN yyt;
 END mProcedureValue;

PROCEDURE mValueRepr* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [ValueRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := ValueRepr;
  RETURN yyt;
 END mValueRepr;

PROCEDURE mBooleanValue* (pv: oBOOLEAN): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [BooleanValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := BooleanValue;
   yyt^.BooleanValue.v := pv;
  RETURN yyt;
 END mBooleanValue;

PROCEDURE mCharValue* (pv: oCHAR): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CharValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CharValue;
   yyt^.CharValue.v := pv;
  RETURN yyt;
 END mCharValue;

PROCEDURE mSetValue* (pv: oSET): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SetValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SetValue;
   yyt^.SetValue.v := pv;
  RETURN yyt;
 END mSetValue;

PROCEDURE mIntegerValue* (pv: oLONGINT): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IntegerValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IntegerValue;
   yyt^.IntegerValue.v := pv;
  RETURN yyt;
 END mIntegerValue;

PROCEDURE mMemValueRepr* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [MemValueRepr] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := MemValueRepr;
  RETURN yyt;
 END mMemValueRepr;

PROCEDURE mStringValue* (pv: oSTRING): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [StringValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := StringValue;
   yyt^.StringValue.v := pv;
  RETURN yyt;
 END mStringValue;

PROCEDURE mRealValue* (pv: oREAL): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [RealValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := RealValue;
   yyt^.RealValue.v := pv;
  RETURN yyt;
 END mRealValue;

PROCEDURE mLongrealValue* (pv: oLONGREAL): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LongrealValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LongrealValue;
   yyt^.LongrealValue.v := pv;
  RETURN yyt;
 END mLongrealValue;

PROCEDURE mNilValue* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NilValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NilValue;
  RETURN yyt;
 END mNilValue;

PROCEDURE mNilPointerValue* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NilPointerValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NilPointerValue;
  RETURN yyt;
 END mNilPointerValue;

PROCEDURE mNilProcedureValue* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NilProcedureValue] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NilProcedureValue;
  RETURN yyt;
 END mNilProcedureValue;

PROCEDURE mCoercion* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Coercion] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Coercion;
  RETURN yyt;
 END mCoercion;

PROCEDURE mmtCoercion* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtCoercion] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtCoercion;
  RETURN yyt;
 END mmtCoercion;

PROCEDURE mShortint2Integer* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Shortint2Integer] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Shortint2Integer;
  RETURN yyt;
 END mShortint2Integer;

PROCEDURE mShortint2Longint* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Shortint2Longint] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Shortint2Longint;
  RETURN yyt;
 END mShortint2Longint;

PROCEDURE mShortint2Real* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Shortint2Real] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Shortint2Real;
  RETURN yyt;
 END mShortint2Real;

PROCEDURE mShortint2Longreal* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Shortint2Longreal] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Shortint2Longreal;
  RETURN yyt;
 END mShortint2Longreal;

PROCEDURE mInteger2Longint* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Integer2Longint] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Integer2Longint;
  RETURN yyt;
 END mInteger2Longint;

PROCEDURE mInteger2Real* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Integer2Real] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Integer2Real;
  RETURN yyt;
 END mInteger2Real;

PROCEDURE mInteger2Longreal* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Integer2Longreal] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Integer2Longreal;
  RETURN yyt;
 END mInteger2Longreal;

PROCEDURE mLongint2Real* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Longint2Real] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Longint2Real;
  RETURN yyt;
 END mLongint2Real;

PROCEDURE mLongint2Longreal* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Longint2Longreal] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Longint2Longreal;
  RETURN yyt;
 END mLongint2Longreal;

PROCEDURE mReal2Longreal* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Real2Longreal] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Real2Longreal;
  RETURN yyt;
 END mReal2Longreal;

PROCEDURE mChar2String* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [Char2String] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := Char2String;
  RETURN yyt;
 END mChar2String;

PROCEDURE mLabelRanges* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [LabelRanges] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := LabelRanges;
  RETURN yyt;
 END mLabelRanges;

PROCEDURE mmtLabelRange* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtLabelRange] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtLabelRange;
  RETURN yyt;
 END mmtLabelRange;

PROCEDURE mCharRange* (pNext: tOB; pa: oCHAR; pb: oCHAR): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [CharRange] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := CharRange;
   yyt^.CharRange.Next := pNext;
   yyt^.CharRange.a := pa;
   yyt^.CharRange.b := pb;
  RETURN yyt;
 END mCharRange;

PROCEDURE mIntegerRange* (pNext: tOB; pa: oLONGINT; pb: oLONGINT): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IntegerRange] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IntegerRange;
   yyt^.IntegerRange.Next := pNext;
   yyt^.IntegerRange.a := pa;
   yyt^.IntegerRange.b := pb;
  RETURN yyt;
 END mIntegerRange;

PROCEDURE mNamePaths* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NamePaths] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NamePaths;
  RETURN yyt;
 END mNamePaths;

PROCEDURE mmtNamePath* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtNamePath] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtNamePath;
  RETURN yyt;
 END mmtNamePath;

PROCEDURE mNamePath* (pprev: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [NamePath] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := NamePath;
   yyt^.NamePath.prev := pprev;
  RETURN yyt;
 END mNamePath;

PROCEDURE mIdentNamePath* (pprev: tOB; pid: tIdent): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IdentNamePath] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IdentNamePath;
   yyt^.IdentNamePath.prev := pprev;
   yyt^.IdentNamePath.id := pid;
  RETURN yyt;
 END mIdentNamePath;

PROCEDURE mSelectNamePath* (pprev: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [SelectNamePath] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := SelectNamePath;
   yyt^.SelectNamePath.prev := pprev;
  RETURN yyt;
 END mSelectNamePath;

PROCEDURE mIndexNamePath* (pprev: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [IndexNamePath] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := IndexNamePath;
   yyt^.IndexNamePath.prev := pprev;
  RETURN yyt;
 END mIndexNamePath;

PROCEDURE mDereferenceNamePath* (pprev: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [DereferenceNamePath] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := DereferenceNamePath;
   yyt^.DereferenceNamePath.prev := pprev;
  RETURN yyt;
 END mDereferenceNamePath;

PROCEDURE mTDescList* (pTDescElems: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TDescList] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TDescList;
   yyt^.TDescList.TDescElems := pTDescElems;
  RETURN yyt;
 END mTDescList;

PROCEDURE mTDescElems* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TDescElems] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TDescElems;
  RETURN yyt;
 END mTDescElems;

PROCEDURE mmtTDescElem* (): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [mtTDescElem] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := mtTDescElem;
  RETURN yyt;
 END mmtTDescElem;

PROCEDURE mTDescElem* (pprev: tOB; pnamePath: tOB; pTypeReprs: tOB): tOB;
 VAR yyByteCount	: LONGINT;
 VAR yyt	: tOB;
 BEGIN
   yyt  := SYSTEM.VAL(tOB,yyPoolFreePtr); IF SYSTEM.VAL(LONGINT,yyt)>=SYSTEM.VAL(LONGINT,yyPoolMaxPtr) THEN  yyt  := yyAlloc (); END; INC (yyPoolFreePtr,   yyNodeSize [TDescElem] );
  yyt^.yyHead.yyMark := 0;
  yyt^.Kind := TDescElem;
   yyt^.TDescElem.prev := pprev;
   yyt^.TDescElem.namePath := pnamePath;
   yyt^.TDescElem.TypeReprs := pTypeReprs;
  RETURN yyt;
 END mTDescElem;

PROCEDURE yyIsEqual* (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi	:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE IsEqualOB* (yyt1, yyt2: tOB): BOOLEAN;
 BEGIN
  IF yyt1 = yyt2 THEN RETURN TRUE; END;
  IF (yyt1 = NoOB) OR (yyt2 = NoOB) OR (yyt1^.Kind # yyt2^.Kind) THEN RETURN FALSE; END;
  CASE yyt1^.Kind OF
| ModuleEntry: RETURN TRUE
& ( yyt1^.ModuleEntry.name  =   yyt2^.ModuleEntry.name  )
& (yyIsEqual ( yyt1^.ModuleEntry.globalLabel ,   yyt2^.ModuleEntry.globalLabel ) )
& ( yyt1^.ModuleEntry.isForeign  =   yyt2^.ModuleEntry.isForeign  )
| Entry: RETURN TRUE
& IsEqualOB ( yyt1^.Entry.prevEntry ,   yyt2^.Entry.prevEntry )
| ScopeEntry: RETURN TRUE
& IsEqualOB ( yyt1^.ScopeEntry.prevEntry ,   yyt2^.ScopeEntry.prevEntry )
| DataEntry: RETURN TRUE
& IsEqualOB ( yyt1^.DataEntry.prevEntry ,   yyt2^.DataEntry.prevEntry )
& IsEqualOB ( yyt1^.DataEntry.module ,   yyt2^.DataEntry.module )
& ( yyt1^.DataEntry.ident  =   yyt2^.DataEntry.ident  )
& (yyIsEqual ( yyt1^.DataEntry.exportMode ,   yyt2^.DataEntry.exportMode ) )
& (yyIsEqual ( yyt1^.DataEntry.level ,   yyt2^.DataEntry.level ) )
& (yyIsEqual ( yyt1^.DataEntry.declStatus ,   yyt2^.DataEntry.declStatus ) )
| ServerEntry: RETURN TRUE
& IsEqualOB ( yyt1^.ServerEntry.prevEntry ,   yyt2^.ServerEntry.prevEntry )
& IsEqualOB ( yyt1^.ServerEntry.module ,   yyt2^.ServerEntry.module )
& ( yyt1^.ServerEntry.ident  =   yyt2^.ServerEntry.ident  )
& (yyIsEqual ( yyt1^.ServerEntry.exportMode ,   yyt2^.ServerEntry.exportMode ) )
& (yyIsEqual ( yyt1^.ServerEntry.level ,   yyt2^.ServerEntry.level ) )
& (yyIsEqual ( yyt1^.ServerEntry.declStatus ,   yyt2^.ServerEntry.declStatus ) )
& IsEqualOB ( yyt1^.ServerEntry.serverTable ,   yyt2^.ServerEntry.serverTable )
& ( yyt1^.ServerEntry.serverId  =   yyt2^.ServerEntry.serverId  )
| ConstEntry: RETURN TRUE
& IsEqualOB ( yyt1^.ConstEntry.prevEntry ,   yyt2^.ConstEntry.prevEntry )
& IsEqualOB ( yyt1^.ConstEntry.module ,   yyt2^.ConstEntry.module )
& ( yyt1^.ConstEntry.ident  =   yyt2^.ConstEntry.ident  )
& (yyIsEqual ( yyt1^.ConstEntry.exportMode ,   yyt2^.ConstEntry.exportMode ) )
& (yyIsEqual ( yyt1^.ConstEntry.level ,   yyt2^.ConstEntry.level ) )
& (yyIsEqual ( yyt1^.ConstEntry.declStatus ,   yyt2^.ConstEntry.declStatus ) )
& IsEqualOB ( yyt1^.ConstEntry.typeRepr ,   yyt2^.ConstEntry.typeRepr )
& IsEqualOB ( yyt1^.ConstEntry.value ,   yyt2^.ConstEntry.value )
& (yyIsEqual ( yyt1^.ConstEntry.label ,   yyt2^.ConstEntry.label ) )
| TypeEntry: RETURN TRUE
& IsEqualOB ( yyt1^.TypeEntry.prevEntry ,   yyt2^.TypeEntry.prevEntry )
& IsEqualOB ( yyt1^.TypeEntry.module ,   yyt2^.TypeEntry.module )
& ( yyt1^.TypeEntry.ident  =   yyt2^.TypeEntry.ident  )
& (yyIsEqual ( yyt1^.TypeEntry.exportMode ,   yyt2^.TypeEntry.exportMode ) )
& (yyIsEqual ( yyt1^.TypeEntry.level ,   yyt2^.TypeEntry.level ) )
& (yyIsEqual ( yyt1^.TypeEntry.declStatus ,   yyt2^.TypeEntry.declStatus ) )
& IsEqualOB ( yyt1^.TypeEntry.typeRepr ,   yyt2^.TypeEntry.typeRepr )
| VarEntry: RETURN TRUE
& IsEqualOB ( yyt1^.VarEntry.prevEntry ,   yyt2^.VarEntry.prevEntry )
& IsEqualOB ( yyt1^.VarEntry.module ,   yyt2^.VarEntry.module )
& ( yyt1^.VarEntry.ident  =   yyt2^.VarEntry.ident  )
& (yyIsEqual ( yyt1^.VarEntry.exportMode ,   yyt2^.VarEntry.exportMode ) )
& (yyIsEqual ( yyt1^.VarEntry.level ,   yyt2^.VarEntry.level ) )
& (yyIsEqual ( yyt1^.VarEntry.declStatus ,   yyt2^.VarEntry.declStatus ) )
& IsEqualOB ( yyt1^.VarEntry.typeRepr ,   yyt2^.VarEntry.typeRepr )
& ( yyt1^.VarEntry.isParam  =   yyt2^.VarEntry.isParam  )
& ( yyt1^.VarEntry.isReceiverPar  =   yyt2^.VarEntry.isReceiverPar  )
& (yyIsEqual ( yyt1^.VarEntry.parMode ,   yyt2^.VarEntry.parMode ) )
& (yyIsEqual ( yyt1^.VarEntry.address ,   yyt2^.VarEntry.address ) )
& (yyIsEqual ( yyt1^.VarEntry.refMode ,   yyt2^.VarEntry.refMode ) )
& ( yyt1^.VarEntry.isWithed  =   yyt2^.VarEntry.isWithed  )
& ( yyt1^.VarEntry.isLaccessed  =   yyt2^.VarEntry.isLaccessed  )
| ProcedureEntry: RETURN TRUE
& IsEqualOB ( yyt1^.ProcedureEntry.prevEntry ,   yyt2^.ProcedureEntry.prevEntry )
& IsEqualOB ( yyt1^.ProcedureEntry.module ,   yyt2^.ProcedureEntry.module )
& ( yyt1^.ProcedureEntry.ident  =   yyt2^.ProcedureEntry.ident  )
& (yyIsEqual ( yyt1^.ProcedureEntry.exportMode ,   yyt2^.ProcedureEntry.exportMode ) )
& (yyIsEqual ( yyt1^.ProcedureEntry.level ,   yyt2^.ProcedureEntry.level ) )
& (yyIsEqual ( yyt1^.ProcedureEntry.declStatus ,   yyt2^.ProcedureEntry.declStatus ) )
& IsEqualOB ( yyt1^.ProcedureEntry.typeRepr ,   yyt2^.ProcedureEntry.typeRepr )
& ( yyt1^.ProcedureEntry.complete  =   yyt2^.ProcedureEntry.complete  )
& (Positions.Compare ( yyt1^.ProcedureEntry.position ,   yyt2^.ProcedureEntry.position ) = 0 )
& (yyIsEqual ( yyt1^.ProcedureEntry.label ,   yyt2^.ProcedureEntry.label ) )
& IsEqualOB ( yyt1^.ProcedureEntry.namePath ,   yyt2^.ProcedureEntry.namePath )
& IsEqualOB ( yyt1^.ProcedureEntry.env ,   yyt2^.ProcedureEntry.env )
| BoundProcEntry: RETURN TRUE
& IsEqualOB ( yyt1^.BoundProcEntry.prevEntry ,   yyt2^.BoundProcEntry.prevEntry )
& IsEqualOB ( yyt1^.BoundProcEntry.module ,   yyt2^.BoundProcEntry.module )
& ( yyt1^.BoundProcEntry.ident  =   yyt2^.BoundProcEntry.ident  )
& (yyIsEqual ( yyt1^.BoundProcEntry.exportMode ,   yyt2^.BoundProcEntry.exportMode ) )
& (yyIsEqual ( yyt1^.BoundProcEntry.level ,   yyt2^.BoundProcEntry.level ) )
& (yyIsEqual ( yyt1^.BoundProcEntry.declStatus ,   yyt2^.BoundProcEntry.declStatus ) )
& IsEqualOB ( yyt1^.BoundProcEntry.receiverSig ,   yyt2^.BoundProcEntry.receiverSig )
& IsEqualOB ( yyt1^.BoundProcEntry.typeRepr ,   yyt2^.BoundProcEntry.typeRepr )
& ( yyt1^.BoundProcEntry.complete  =   yyt2^.BoundProcEntry.complete  )
& (Positions.Compare ( yyt1^.BoundProcEntry.position ,   yyt2^.BoundProcEntry.position ) = 0 )
& (yyIsEqual ( yyt1^.BoundProcEntry.label ,   yyt2^.BoundProcEntry.label ) )
& IsEqualOB ( yyt1^.BoundProcEntry.namePath ,   yyt2^.BoundProcEntry.namePath )
& IsEqualOB ( yyt1^.BoundProcEntry.redefinedProc ,   yyt2^.BoundProcEntry.redefinedProc )
& ( yyt1^.BoundProcEntry.procNum  =   yyt2^.BoundProcEntry.procNum  )
& IsEqualOB ( yyt1^.BoundProcEntry.env ,   yyt2^.BoundProcEntry.env )
| InheritedProcEntry: RETURN TRUE
& IsEqualOB ( yyt1^.InheritedProcEntry.prevEntry ,   yyt2^.InheritedProcEntry.prevEntry )
& IsEqualOB ( yyt1^.InheritedProcEntry.module ,   yyt2^.InheritedProcEntry.module )
& ( yyt1^.InheritedProcEntry.ident  =   yyt2^.InheritedProcEntry.ident  )
& (yyIsEqual ( yyt1^.InheritedProcEntry.exportMode ,   yyt2^.InheritedProcEntry.exportMode ) )
& (yyIsEqual ( yyt1^.InheritedProcEntry.level ,   yyt2^.InheritedProcEntry.level ) )
& (yyIsEqual ( yyt1^.InheritedProcEntry.declStatus ,   yyt2^.InheritedProcEntry.declStatus ) )
& IsEqualOB ( yyt1^.InheritedProcEntry.boundProcEntry ,   yyt2^.InheritedProcEntry.boundProcEntry )
| Environment: RETURN TRUE
& IsEqualOB ( yyt1^.Environment.entry ,   yyt2^.Environment.entry )
& ( yyt1^.Environment.callDstLevels  =   yyt2^.Environment.callDstLevels  )
| TypeReprList: RETURN TRUE
& IsEqualOB ( yyt1^.TypeReprList.prev ,   yyt2^.TypeReprList.prev )
& IsEqualOB ( yyt1^.TypeReprList.typeRepr ,   yyt2^.TypeReprList.typeRepr )
| Blocklist: RETURN TRUE
& IsEqualOB ( yyt1^.Blocklist.prev ,   yyt2^.Blocklist.prev )
& IsEqualOB ( yyt1^.Blocklist.sub ,   yyt2^.Blocklist.sub )
& (yyIsEqual ( yyt1^.Blocklist.ofs ,   yyt2^.Blocklist.ofs ) )
& ( yyt1^.Blocklist.count  =   yyt2^.Blocklist.count  )
& (yyIsEqual ( yyt1^.Blocklist.incr ,   yyt2^.Blocklist.incr ) )
& ( yyt1^.Blocklist.height  =   yyt2^.Blocklist.height  )
| TypeBlocklists: RETURN TRUE
& IsEqualOB ( yyt1^.TypeBlocklists.ptrBlocklist ,   yyt2^.TypeBlocklists.ptrBlocklist )
& IsEqualOB ( yyt1^.TypeBlocklists.procBlocklist ,   yyt2^.TypeBlocklists.procBlocklist )
| TypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.TypeRepr.entry ,   yyt2^.TypeRepr.entry )
& (yyIsEqual ( yyt1^.TypeRepr.size ,   yyt2^.TypeRepr.size ) )
& IsEqualOB ( yyt1^.TypeRepr.typeBlocklists ,   yyt2^.TypeRepr.typeBlocklists )
& ( yyt1^.TypeRepr.isInTDescList  =   yyt2^.TypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.TypeRepr.label ,   yyt2^.TypeRepr.label ) )
| ForwardTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ForwardTypeRepr.entry ,   yyt2^.ForwardTypeRepr.entry )
& (yyIsEqual ( yyt1^.ForwardTypeRepr.size ,   yyt2^.ForwardTypeRepr.size ) )
& IsEqualOB ( yyt1^.ForwardTypeRepr.typeBlocklists ,   yyt2^.ForwardTypeRepr.typeBlocklists )
& ( yyt1^.ForwardTypeRepr.isInTDescList  =   yyt2^.ForwardTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ForwardTypeRepr.label ,   yyt2^.ForwardTypeRepr.label ) )
& (Positions.Compare ( yyt1^.ForwardTypeRepr.position ,   yyt2^.ForwardTypeRepr.position ) = 0 )
| NilTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.NilTypeRepr.entry ,   yyt2^.NilTypeRepr.entry )
& (yyIsEqual ( yyt1^.NilTypeRepr.size ,   yyt2^.NilTypeRepr.size ) )
& IsEqualOB ( yyt1^.NilTypeRepr.typeBlocklists ,   yyt2^.NilTypeRepr.typeBlocklists )
& ( yyt1^.NilTypeRepr.isInTDescList  =   yyt2^.NilTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.NilTypeRepr.label ,   yyt2^.NilTypeRepr.label ) )
| ByteTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ByteTypeRepr.entry ,   yyt2^.ByteTypeRepr.entry )
& (yyIsEqual ( yyt1^.ByteTypeRepr.size ,   yyt2^.ByteTypeRepr.size ) )
& IsEqualOB ( yyt1^.ByteTypeRepr.typeBlocklists ,   yyt2^.ByteTypeRepr.typeBlocklists )
& ( yyt1^.ByteTypeRepr.isInTDescList  =   yyt2^.ByteTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ByteTypeRepr.label ,   yyt2^.ByteTypeRepr.label ) )
| PtrTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.PtrTypeRepr.entry ,   yyt2^.PtrTypeRepr.entry )
& (yyIsEqual ( yyt1^.PtrTypeRepr.size ,   yyt2^.PtrTypeRepr.size ) )
& IsEqualOB ( yyt1^.PtrTypeRepr.typeBlocklists ,   yyt2^.PtrTypeRepr.typeBlocklists )
& ( yyt1^.PtrTypeRepr.isInTDescList  =   yyt2^.PtrTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.PtrTypeRepr.label ,   yyt2^.PtrTypeRepr.label ) )
| BooleanTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.BooleanTypeRepr.entry ,   yyt2^.BooleanTypeRepr.entry )
& (yyIsEqual ( yyt1^.BooleanTypeRepr.size ,   yyt2^.BooleanTypeRepr.size ) )
& IsEqualOB ( yyt1^.BooleanTypeRepr.typeBlocklists ,   yyt2^.BooleanTypeRepr.typeBlocklists )
& ( yyt1^.BooleanTypeRepr.isInTDescList  =   yyt2^.BooleanTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.BooleanTypeRepr.label ,   yyt2^.BooleanTypeRepr.label ) )
| CharTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.CharTypeRepr.entry ,   yyt2^.CharTypeRepr.entry )
& (yyIsEqual ( yyt1^.CharTypeRepr.size ,   yyt2^.CharTypeRepr.size ) )
& IsEqualOB ( yyt1^.CharTypeRepr.typeBlocklists ,   yyt2^.CharTypeRepr.typeBlocklists )
& ( yyt1^.CharTypeRepr.isInTDescList  =   yyt2^.CharTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.CharTypeRepr.label ,   yyt2^.CharTypeRepr.label ) )
| CharStringTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.CharStringTypeRepr.entry ,   yyt2^.CharStringTypeRepr.entry )
& (yyIsEqual ( yyt1^.CharStringTypeRepr.size ,   yyt2^.CharStringTypeRepr.size ) )
& IsEqualOB ( yyt1^.CharStringTypeRepr.typeBlocklists ,   yyt2^.CharStringTypeRepr.typeBlocklists )
& ( yyt1^.CharStringTypeRepr.isInTDescList  =   yyt2^.CharStringTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.CharStringTypeRepr.label ,   yyt2^.CharStringTypeRepr.label ) )
| StringTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.StringTypeRepr.entry ,   yyt2^.StringTypeRepr.entry )
& (yyIsEqual ( yyt1^.StringTypeRepr.size ,   yyt2^.StringTypeRepr.size ) )
& IsEqualOB ( yyt1^.StringTypeRepr.typeBlocklists ,   yyt2^.StringTypeRepr.typeBlocklists )
& ( yyt1^.StringTypeRepr.isInTDescList  =   yyt2^.StringTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.StringTypeRepr.label ,   yyt2^.StringTypeRepr.label ) )
| SetTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SetTypeRepr.entry ,   yyt2^.SetTypeRepr.entry )
& (yyIsEqual ( yyt1^.SetTypeRepr.size ,   yyt2^.SetTypeRepr.size ) )
& IsEqualOB ( yyt1^.SetTypeRepr.typeBlocklists ,   yyt2^.SetTypeRepr.typeBlocklists )
& ( yyt1^.SetTypeRepr.isInTDescList  =   yyt2^.SetTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SetTypeRepr.label ,   yyt2^.SetTypeRepr.label ) )
| IntTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.IntTypeRepr.entry ,   yyt2^.IntTypeRepr.entry )
& (yyIsEqual ( yyt1^.IntTypeRepr.size ,   yyt2^.IntTypeRepr.size ) )
& IsEqualOB ( yyt1^.IntTypeRepr.typeBlocklists ,   yyt2^.IntTypeRepr.typeBlocklists )
& ( yyt1^.IntTypeRepr.isInTDescList  =   yyt2^.IntTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.IntTypeRepr.label ,   yyt2^.IntTypeRepr.label ) )
| ShortintTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ShortintTypeRepr.entry ,   yyt2^.ShortintTypeRepr.entry )
& (yyIsEqual ( yyt1^.ShortintTypeRepr.size ,   yyt2^.ShortintTypeRepr.size ) )
& IsEqualOB ( yyt1^.ShortintTypeRepr.typeBlocklists ,   yyt2^.ShortintTypeRepr.typeBlocklists )
& ( yyt1^.ShortintTypeRepr.isInTDescList  =   yyt2^.ShortintTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ShortintTypeRepr.label ,   yyt2^.ShortintTypeRepr.label ) )
| IntegerTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.IntegerTypeRepr.entry ,   yyt2^.IntegerTypeRepr.entry )
& (yyIsEqual ( yyt1^.IntegerTypeRepr.size ,   yyt2^.IntegerTypeRepr.size ) )
& IsEqualOB ( yyt1^.IntegerTypeRepr.typeBlocklists ,   yyt2^.IntegerTypeRepr.typeBlocklists )
& ( yyt1^.IntegerTypeRepr.isInTDescList  =   yyt2^.IntegerTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.IntegerTypeRepr.label ,   yyt2^.IntegerTypeRepr.label ) )
| LongintTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.LongintTypeRepr.entry ,   yyt2^.LongintTypeRepr.entry )
& (yyIsEqual ( yyt1^.LongintTypeRepr.size ,   yyt2^.LongintTypeRepr.size ) )
& IsEqualOB ( yyt1^.LongintTypeRepr.typeBlocklists ,   yyt2^.LongintTypeRepr.typeBlocklists )
& ( yyt1^.LongintTypeRepr.isInTDescList  =   yyt2^.LongintTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.LongintTypeRepr.label ,   yyt2^.LongintTypeRepr.label ) )
| FloatTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.FloatTypeRepr.entry ,   yyt2^.FloatTypeRepr.entry )
& (yyIsEqual ( yyt1^.FloatTypeRepr.size ,   yyt2^.FloatTypeRepr.size ) )
& IsEqualOB ( yyt1^.FloatTypeRepr.typeBlocklists ,   yyt2^.FloatTypeRepr.typeBlocklists )
& ( yyt1^.FloatTypeRepr.isInTDescList  =   yyt2^.FloatTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.FloatTypeRepr.label ,   yyt2^.FloatTypeRepr.label ) )
| RealTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.RealTypeRepr.entry ,   yyt2^.RealTypeRepr.entry )
& (yyIsEqual ( yyt1^.RealTypeRepr.size ,   yyt2^.RealTypeRepr.size ) )
& IsEqualOB ( yyt1^.RealTypeRepr.typeBlocklists ,   yyt2^.RealTypeRepr.typeBlocklists )
& ( yyt1^.RealTypeRepr.isInTDescList  =   yyt2^.RealTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.RealTypeRepr.label ,   yyt2^.RealTypeRepr.label ) )
| LongrealTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.LongrealTypeRepr.entry ,   yyt2^.LongrealTypeRepr.entry )
& (yyIsEqual ( yyt1^.LongrealTypeRepr.size ,   yyt2^.LongrealTypeRepr.size ) )
& IsEqualOB ( yyt1^.LongrealTypeRepr.typeBlocklists ,   yyt2^.LongrealTypeRepr.typeBlocklists )
& ( yyt1^.LongrealTypeRepr.isInTDescList  =   yyt2^.LongrealTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.LongrealTypeRepr.label ,   yyt2^.LongrealTypeRepr.label ) )
| ArrayTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ArrayTypeRepr.entry ,   yyt2^.ArrayTypeRepr.entry )
& (yyIsEqual ( yyt1^.ArrayTypeRepr.size ,   yyt2^.ArrayTypeRepr.size ) )
& IsEqualOB ( yyt1^.ArrayTypeRepr.typeBlocklists ,   yyt2^.ArrayTypeRepr.typeBlocklists )
& ( yyt1^.ArrayTypeRepr.isInTDescList  =   yyt2^.ArrayTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ArrayTypeRepr.label ,   yyt2^.ArrayTypeRepr.label ) )
& (yyIsEqual ( yyt1^.ArrayTypeRepr.len ,   yyt2^.ArrayTypeRepr.len ) )
& IsEqualOB ( yyt1^.ArrayTypeRepr.elemTypeRepr ,   yyt2^.ArrayTypeRepr.elemTypeRepr )
| RecordTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.RecordTypeRepr.entry ,   yyt2^.RecordTypeRepr.entry )
& (yyIsEqual ( yyt1^.RecordTypeRepr.size ,   yyt2^.RecordTypeRepr.size ) )
& IsEqualOB ( yyt1^.RecordTypeRepr.typeBlocklists ,   yyt2^.RecordTypeRepr.typeBlocklists )
& ( yyt1^.RecordTypeRepr.isInTDescList  =   yyt2^.RecordTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.RecordTypeRepr.label ,   yyt2^.RecordTypeRepr.label ) )
& (yyIsEqual ( yyt1^.RecordTypeRepr.extLevel ,   yyt2^.RecordTypeRepr.extLevel ) )
& IsEqualOB ( yyt1^.RecordTypeRepr.baseTypeRepr ,   yyt2^.RecordTypeRepr.baseTypeRepr )
& IsEqualOB ( yyt1^.RecordTypeRepr.extTypeReprList ,   yyt2^.RecordTypeRepr.extTypeReprList )
& IsEqualOB ( yyt1^.RecordTypeRepr.fields ,   yyt2^.RecordTypeRepr.fields )
& ( yyt1^.RecordTypeRepr.nofBoundProcs  =   yyt2^.RecordTypeRepr.nofBoundProcs  )
| PointerTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.PointerTypeRepr.entry ,   yyt2^.PointerTypeRepr.entry )
& (yyIsEqual ( yyt1^.PointerTypeRepr.size ,   yyt2^.PointerTypeRepr.size ) )
& IsEqualOB ( yyt1^.PointerTypeRepr.typeBlocklists ,   yyt2^.PointerTypeRepr.typeBlocklists )
& ( yyt1^.PointerTypeRepr.isInTDescList  =   yyt2^.PointerTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.PointerTypeRepr.label ,   yyt2^.PointerTypeRepr.label ) )
& IsEqualOB ( yyt1^.PointerTypeRepr.baseTypeEntry ,   yyt2^.PointerTypeRepr.baseTypeEntry )
| ProcedureTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ProcedureTypeRepr.entry ,   yyt2^.ProcedureTypeRepr.entry )
& (yyIsEqual ( yyt1^.ProcedureTypeRepr.size ,   yyt2^.ProcedureTypeRepr.size ) )
& IsEqualOB ( yyt1^.ProcedureTypeRepr.typeBlocklists ,   yyt2^.ProcedureTypeRepr.typeBlocklists )
& ( yyt1^.ProcedureTypeRepr.isInTDescList  =   yyt2^.ProcedureTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ProcedureTypeRepr.label ,   yyt2^.ProcedureTypeRepr.label ) )
& IsEqualOB ( yyt1^.ProcedureTypeRepr.signatureRepr ,   yyt2^.ProcedureTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.ProcedureTypeRepr.resultType ,   yyt2^.ProcedureTypeRepr.resultType )
& (yyIsEqual ( yyt1^.ProcedureTypeRepr.paramSpace ,   yyt2^.ProcedureTypeRepr.paramSpace ) )
| PreDeclProcTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.PreDeclProcTypeRepr.entry ,   yyt2^.PreDeclProcTypeRepr.entry )
& (yyIsEqual ( yyt1^.PreDeclProcTypeRepr.size ,   yyt2^.PreDeclProcTypeRepr.size ) )
& IsEqualOB ( yyt1^.PreDeclProcTypeRepr.typeBlocklists ,   yyt2^.PreDeclProcTypeRepr.typeBlocklists )
& ( yyt1^.PreDeclProcTypeRepr.isInTDescList  =   yyt2^.PreDeclProcTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.PreDeclProcTypeRepr.label ,   yyt2^.PreDeclProcTypeRepr.label ) )
& IsEqualOB ( yyt1^.PreDeclProcTypeRepr.signatureRepr ,   yyt2^.PreDeclProcTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.PreDeclProcTypeRepr.resultType ,   yyt2^.PreDeclProcTypeRepr.resultType )
& (yyIsEqual ( yyt1^.PreDeclProcTypeRepr.paramSpace ,   yyt2^.PreDeclProcTypeRepr.paramSpace ) )
| CaseFaultTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.CaseFaultTypeRepr.entry ,   yyt2^.CaseFaultTypeRepr.entry )
& (yyIsEqual ( yyt1^.CaseFaultTypeRepr.size ,   yyt2^.CaseFaultTypeRepr.size ) )
& IsEqualOB ( yyt1^.CaseFaultTypeRepr.typeBlocklists ,   yyt2^.CaseFaultTypeRepr.typeBlocklists )
& ( yyt1^.CaseFaultTypeRepr.isInTDescList  =   yyt2^.CaseFaultTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.CaseFaultTypeRepr.label ,   yyt2^.CaseFaultTypeRepr.label ) )
& IsEqualOB ( yyt1^.CaseFaultTypeRepr.signatureRepr ,   yyt2^.CaseFaultTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.CaseFaultTypeRepr.resultType ,   yyt2^.CaseFaultTypeRepr.resultType )
& (yyIsEqual ( yyt1^.CaseFaultTypeRepr.paramSpace ,   yyt2^.CaseFaultTypeRepr.paramSpace ) )
| WithFaultTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.WithFaultTypeRepr.entry ,   yyt2^.WithFaultTypeRepr.entry )
& (yyIsEqual ( yyt1^.WithFaultTypeRepr.size ,   yyt2^.WithFaultTypeRepr.size ) )
& IsEqualOB ( yyt1^.WithFaultTypeRepr.typeBlocklists ,   yyt2^.WithFaultTypeRepr.typeBlocklists )
& ( yyt1^.WithFaultTypeRepr.isInTDescList  =   yyt2^.WithFaultTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.WithFaultTypeRepr.label ,   yyt2^.WithFaultTypeRepr.label ) )
& IsEqualOB ( yyt1^.WithFaultTypeRepr.signatureRepr ,   yyt2^.WithFaultTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.WithFaultTypeRepr.resultType ,   yyt2^.WithFaultTypeRepr.resultType )
& (yyIsEqual ( yyt1^.WithFaultTypeRepr.paramSpace ,   yyt2^.WithFaultTypeRepr.paramSpace ) )
| AbsTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.AbsTypeRepr.entry ,   yyt2^.AbsTypeRepr.entry )
& (yyIsEqual ( yyt1^.AbsTypeRepr.size ,   yyt2^.AbsTypeRepr.size ) )
& IsEqualOB ( yyt1^.AbsTypeRepr.typeBlocklists ,   yyt2^.AbsTypeRepr.typeBlocklists )
& ( yyt1^.AbsTypeRepr.isInTDescList  =   yyt2^.AbsTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.AbsTypeRepr.label ,   yyt2^.AbsTypeRepr.label ) )
& IsEqualOB ( yyt1^.AbsTypeRepr.signatureRepr ,   yyt2^.AbsTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.AbsTypeRepr.resultType ,   yyt2^.AbsTypeRepr.resultType )
& (yyIsEqual ( yyt1^.AbsTypeRepr.paramSpace ,   yyt2^.AbsTypeRepr.paramSpace ) )
| AshTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.AshTypeRepr.entry ,   yyt2^.AshTypeRepr.entry )
& (yyIsEqual ( yyt1^.AshTypeRepr.size ,   yyt2^.AshTypeRepr.size ) )
& IsEqualOB ( yyt1^.AshTypeRepr.typeBlocklists ,   yyt2^.AshTypeRepr.typeBlocklists )
& ( yyt1^.AshTypeRepr.isInTDescList  =   yyt2^.AshTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.AshTypeRepr.label ,   yyt2^.AshTypeRepr.label ) )
& IsEqualOB ( yyt1^.AshTypeRepr.signatureRepr ,   yyt2^.AshTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.AshTypeRepr.resultType ,   yyt2^.AshTypeRepr.resultType )
& (yyIsEqual ( yyt1^.AshTypeRepr.paramSpace ,   yyt2^.AshTypeRepr.paramSpace ) )
| CapTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.CapTypeRepr.entry ,   yyt2^.CapTypeRepr.entry )
& (yyIsEqual ( yyt1^.CapTypeRepr.size ,   yyt2^.CapTypeRepr.size ) )
& IsEqualOB ( yyt1^.CapTypeRepr.typeBlocklists ,   yyt2^.CapTypeRepr.typeBlocklists )
& ( yyt1^.CapTypeRepr.isInTDescList  =   yyt2^.CapTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.CapTypeRepr.label ,   yyt2^.CapTypeRepr.label ) )
& IsEqualOB ( yyt1^.CapTypeRepr.signatureRepr ,   yyt2^.CapTypeRepr.signatureRepr )
& IsEqualOB ( yyt1^.CapTypeRepr.resultType ,   yyt2^.CapTypeRepr.resultType )
& (yyIsEqual ( yyt1^.CapTypeRepr.paramSpace ,   yyt2^.CapTypeRepr.paramSpace ) )
| ChrTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ChrTypeRepr.entry ,   yyt2^.ChrTypeRepr.entry )
& (yyIsEqual ( yyt1^.ChrTypeRepr.size ,   yyt2^.ChrTypeRepr.size ) )
& IsEqualOB ( yyt1^.ChrTypeRepr.typeBlocklists ,   yyt2^.ChrTypeRepr.typeBlocklists ) 
& ( yyt1^.ChrTypeRepr.isInTDescList  =   yyt2^.ChrTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ChrTypeRepr.label ,   yyt2^.ChrTypeRepr.label ) )
& IsEqualOB ( yyt1^.ChrTypeRepr.signatureRepr ,   yyt2^.ChrTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.ChrTypeRepr.resultType ,   yyt2^.ChrTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.ChrTypeRepr.paramSpace ,   yyt2^.ChrTypeRepr.paramSpace ) )
| EntierTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.EntierTypeRepr.entry ,   yyt2^.EntierTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.EntierTypeRepr.size ,   yyt2^.EntierTypeRepr.size ) )
& IsEqualOB ( yyt1^.EntierTypeRepr.typeBlocklists ,   yyt2^.EntierTypeRepr.typeBlocklists ) 
& ( yyt1^.EntierTypeRepr.isInTDescList  =   yyt2^.EntierTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.EntierTypeRepr.label ,   yyt2^.EntierTypeRepr.label ) )
& IsEqualOB ( yyt1^.EntierTypeRepr.signatureRepr ,   yyt2^.EntierTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.EntierTypeRepr.resultType ,   yyt2^.EntierTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.EntierTypeRepr.paramSpace ,   yyt2^.EntierTypeRepr.paramSpace ) )
| LenTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.LenTypeRepr.entry ,   yyt2^.LenTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.LenTypeRepr.size ,   yyt2^.LenTypeRepr.size ) )
& IsEqualOB ( yyt1^.LenTypeRepr.typeBlocklists ,   yyt2^.LenTypeRepr.typeBlocklists ) 
& ( yyt1^.LenTypeRepr.isInTDescList  =   yyt2^.LenTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.LenTypeRepr.label ,   yyt2^.LenTypeRepr.label ) )
& IsEqualOB ( yyt1^.LenTypeRepr.signatureRepr ,   yyt2^.LenTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.LenTypeRepr.resultType ,   yyt2^.LenTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.LenTypeRepr.paramSpace ,   yyt2^.LenTypeRepr.paramSpace ) )
| LongTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.LongTypeRepr.entry ,   yyt2^.LongTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.LongTypeRepr.size ,   yyt2^.LongTypeRepr.size ) )
& IsEqualOB ( yyt1^.LongTypeRepr.typeBlocklists ,   yyt2^.LongTypeRepr.typeBlocklists ) 
& ( yyt1^.LongTypeRepr.isInTDescList  =   yyt2^.LongTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.LongTypeRepr.label ,   yyt2^.LongTypeRepr.label ) )
& IsEqualOB ( yyt1^.LongTypeRepr.signatureRepr ,   yyt2^.LongTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.LongTypeRepr.resultType ,   yyt2^.LongTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.LongTypeRepr.paramSpace ,   yyt2^.LongTypeRepr.paramSpace ) )
| MaxTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.MaxTypeRepr.entry ,   yyt2^.MaxTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.MaxTypeRepr.size ,   yyt2^.MaxTypeRepr.size ) )
& IsEqualOB ( yyt1^.MaxTypeRepr.typeBlocklists ,   yyt2^.MaxTypeRepr.typeBlocklists ) 
& ( yyt1^.MaxTypeRepr.isInTDescList  =   yyt2^.MaxTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.MaxTypeRepr.label ,   yyt2^.MaxTypeRepr.label ) )
& IsEqualOB ( yyt1^.MaxTypeRepr.signatureRepr ,   yyt2^.MaxTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.MaxTypeRepr.resultType ,   yyt2^.MaxTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.MaxTypeRepr.paramSpace ,   yyt2^.MaxTypeRepr.paramSpace ) )
| MinTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.MinTypeRepr.entry ,   yyt2^.MinTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.MinTypeRepr.size ,   yyt2^.MinTypeRepr.size ) )
& IsEqualOB ( yyt1^.MinTypeRepr.typeBlocklists ,   yyt2^.MinTypeRepr.typeBlocklists ) 
& ( yyt1^.MinTypeRepr.isInTDescList  =   yyt2^.MinTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.MinTypeRepr.label ,   yyt2^.MinTypeRepr.label ) )
& IsEqualOB ( yyt1^.MinTypeRepr.signatureRepr ,   yyt2^.MinTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.MinTypeRepr.resultType ,   yyt2^.MinTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.MinTypeRepr.paramSpace ,   yyt2^.MinTypeRepr.paramSpace ) )
| OddTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.OddTypeRepr.entry ,   yyt2^.OddTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.OddTypeRepr.size ,   yyt2^.OddTypeRepr.size ) )
& IsEqualOB ( yyt1^.OddTypeRepr.typeBlocklists ,   yyt2^.OddTypeRepr.typeBlocklists ) 
& ( yyt1^.OddTypeRepr.isInTDescList  =   yyt2^.OddTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.OddTypeRepr.label ,   yyt2^.OddTypeRepr.label ) )
& IsEqualOB ( yyt1^.OddTypeRepr.signatureRepr ,   yyt2^.OddTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.OddTypeRepr.resultType ,   yyt2^.OddTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.OddTypeRepr.paramSpace ,   yyt2^.OddTypeRepr.paramSpace ) )
| OrdTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.OrdTypeRepr.entry ,   yyt2^.OrdTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.OrdTypeRepr.size ,   yyt2^.OrdTypeRepr.size ) )
& IsEqualOB ( yyt1^.OrdTypeRepr.typeBlocklists ,   yyt2^.OrdTypeRepr.typeBlocklists ) 
& ( yyt1^.OrdTypeRepr.isInTDescList  =   yyt2^.OrdTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.OrdTypeRepr.label ,   yyt2^.OrdTypeRepr.label ) )
& IsEqualOB ( yyt1^.OrdTypeRepr.signatureRepr ,   yyt2^.OrdTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.OrdTypeRepr.resultType ,   yyt2^.OrdTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.OrdTypeRepr.paramSpace ,   yyt2^.OrdTypeRepr.paramSpace ) )
| ShortTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ShortTypeRepr.entry ,   yyt2^.ShortTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.ShortTypeRepr.size ,   yyt2^.ShortTypeRepr.size ) )
& IsEqualOB ( yyt1^.ShortTypeRepr.typeBlocklists ,   yyt2^.ShortTypeRepr.typeBlocklists ) 
& ( yyt1^.ShortTypeRepr.isInTDescList  =   yyt2^.ShortTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ShortTypeRepr.label ,   yyt2^.ShortTypeRepr.label ) )
& IsEqualOB ( yyt1^.ShortTypeRepr.signatureRepr ,   yyt2^.ShortTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.ShortTypeRepr.resultType ,   yyt2^.ShortTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.ShortTypeRepr.paramSpace ,   yyt2^.ShortTypeRepr.paramSpace ) )
| SizeTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SizeTypeRepr.entry ,   yyt2^.SizeTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SizeTypeRepr.size ,   yyt2^.SizeTypeRepr.size ) )
& IsEqualOB ( yyt1^.SizeTypeRepr.typeBlocklists ,   yyt2^.SizeTypeRepr.typeBlocklists ) 
& ( yyt1^.SizeTypeRepr.isInTDescList  =   yyt2^.SizeTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SizeTypeRepr.label ,   yyt2^.SizeTypeRepr.label ) )
& IsEqualOB ( yyt1^.SizeTypeRepr.signatureRepr ,   yyt2^.SizeTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SizeTypeRepr.resultType ,   yyt2^.SizeTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SizeTypeRepr.paramSpace ,   yyt2^.SizeTypeRepr.paramSpace ) )
| AssertTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.AssertTypeRepr.entry ,   yyt2^.AssertTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.AssertTypeRepr.size ,   yyt2^.AssertTypeRepr.size ) )
& IsEqualOB ( yyt1^.AssertTypeRepr.typeBlocklists ,   yyt2^.AssertTypeRepr.typeBlocklists ) 
& ( yyt1^.AssertTypeRepr.isInTDescList  =   yyt2^.AssertTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.AssertTypeRepr.label ,   yyt2^.AssertTypeRepr.label ) )
& IsEqualOB ( yyt1^.AssertTypeRepr.signatureRepr ,   yyt2^.AssertTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.AssertTypeRepr.resultType ,   yyt2^.AssertTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.AssertTypeRepr.paramSpace ,   yyt2^.AssertTypeRepr.paramSpace ) )
| CopyTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.CopyTypeRepr.entry ,   yyt2^.CopyTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.CopyTypeRepr.size ,   yyt2^.CopyTypeRepr.size ) )
& IsEqualOB ( yyt1^.CopyTypeRepr.typeBlocklists ,   yyt2^.CopyTypeRepr.typeBlocklists ) 
& ( yyt1^.CopyTypeRepr.isInTDescList  =   yyt2^.CopyTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.CopyTypeRepr.label ,   yyt2^.CopyTypeRepr.label ) )
& IsEqualOB ( yyt1^.CopyTypeRepr.signatureRepr ,   yyt2^.CopyTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.CopyTypeRepr.resultType ,   yyt2^.CopyTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.CopyTypeRepr.paramSpace ,   yyt2^.CopyTypeRepr.paramSpace ) )
| DecTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.DecTypeRepr.entry ,   yyt2^.DecTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.DecTypeRepr.size ,   yyt2^.DecTypeRepr.size ) )
& IsEqualOB ( yyt1^.DecTypeRepr.typeBlocklists ,   yyt2^.DecTypeRepr.typeBlocklists ) 
& ( yyt1^.DecTypeRepr.isInTDescList  =   yyt2^.DecTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.DecTypeRepr.label ,   yyt2^.DecTypeRepr.label ) )
& IsEqualOB ( yyt1^.DecTypeRepr.signatureRepr ,   yyt2^.DecTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.DecTypeRepr.resultType ,   yyt2^.DecTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.DecTypeRepr.paramSpace ,   yyt2^.DecTypeRepr.paramSpace ) )
| ExclTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.ExclTypeRepr.entry ,   yyt2^.ExclTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.ExclTypeRepr.size ,   yyt2^.ExclTypeRepr.size ) )
& IsEqualOB ( yyt1^.ExclTypeRepr.typeBlocklists ,   yyt2^.ExclTypeRepr.typeBlocklists ) 
& ( yyt1^.ExclTypeRepr.isInTDescList  =   yyt2^.ExclTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.ExclTypeRepr.label ,   yyt2^.ExclTypeRepr.label ) )
& IsEqualOB ( yyt1^.ExclTypeRepr.signatureRepr ,   yyt2^.ExclTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.ExclTypeRepr.resultType ,   yyt2^.ExclTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.ExclTypeRepr.paramSpace ,   yyt2^.ExclTypeRepr.paramSpace ) )
| HaltTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.HaltTypeRepr.entry ,   yyt2^.HaltTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.HaltTypeRepr.size ,   yyt2^.HaltTypeRepr.size ) )
& IsEqualOB ( yyt1^.HaltTypeRepr.typeBlocklists ,   yyt2^.HaltTypeRepr.typeBlocklists ) 
& ( yyt1^.HaltTypeRepr.isInTDescList  =   yyt2^.HaltTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.HaltTypeRepr.label ,   yyt2^.HaltTypeRepr.label ) )
& IsEqualOB ( yyt1^.HaltTypeRepr.signatureRepr ,   yyt2^.HaltTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.HaltTypeRepr.resultType ,   yyt2^.HaltTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.HaltTypeRepr.paramSpace ,   yyt2^.HaltTypeRepr.paramSpace ) )
| IncTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.IncTypeRepr.entry ,   yyt2^.IncTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.IncTypeRepr.size ,   yyt2^.IncTypeRepr.size ) )
& IsEqualOB ( yyt1^.IncTypeRepr.typeBlocklists ,   yyt2^.IncTypeRepr.typeBlocklists ) 
& ( yyt1^.IncTypeRepr.isInTDescList  =   yyt2^.IncTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.IncTypeRepr.label ,   yyt2^.IncTypeRepr.label ) )
& IsEqualOB ( yyt1^.IncTypeRepr.signatureRepr ,   yyt2^.IncTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.IncTypeRepr.resultType ,   yyt2^.IncTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.IncTypeRepr.paramSpace ,   yyt2^.IncTypeRepr.paramSpace ) )
| InclTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.InclTypeRepr.entry ,   yyt2^.InclTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.InclTypeRepr.size ,   yyt2^.InclTypeRepr.size ) )
& IsEqualOB ( yyt1^.InclTypeRepr.typeBlocklists ,   yyt2^.InclTypeRepr.typeBlocklists ) 
& ( yyt1^.InclTypeRepr.isInTDescList  =   yyt2^.InclTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.InclTypeRepr.label ,   yyt2^.InclTypeRepr.label ) )
& IsEqualOB ( yyt1^.InclTypeRepr.signatureRepr ,   yyt2^.InclTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.InclTypeRepr.resultType ,   yyt2^.InclTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.InclTypeRepr.paramSpace ,   yyt2^.InclTypeRepr.paramSpace ) )
| NewTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.NewTypeRepr.entry ,   yyt2^.NewTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.NewTypeRepr.size ,   yyt2^.NewTypeRepr.size ) )
& IsEqualOB ( yyt1^.NewTypeRepr.typeBlocklists ,   yyt2^.NewTypeRepr.typeBlocklists ) 
& ( yyt1^.NewTypeRepr.isInTDescList  =   yyt2^.NewTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.NewTypeRepr.label ,   yyt2^.NewTypeRepr.label ) )
& IsEqualOB ( yyt1^.NewTypeRepr.signatureRepr ,   yyt2^.NewTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.NewTypeRepr.resultType ,   yyt2^.NewTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.NewTypeRepr.paramSpace ,   yyt2^.NewTypeRepr.paramSpace ) )
| SysAdrTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysAdrTypeRepr.entry ,   yyt2^.SysAdrTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysAdrTypeRepr.size ,   yyt2^.SysAdrTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysAdrTypeRepr.typeBlocklists ,   yyt2^.SysAdrTypeRepr.typeBlocklists ) 
& ( yyt1^.SysAdrTypeRepr.isInTDescList  =   yyt2^.SysAdrTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysAdrTypeRepr.label ,   yyt2^.SysAdrTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysAdrTypeRepr.signatureRepr ,   yyt2^.SysAdrTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysAdrTypeRepr.resultType ,   yyt2^.SysAdrTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysAdrTypeRepr.paramSpace ,   yyt2^.SysAdrTypeRepr.paramSpace ) )
| SysBitTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysBitTypeRepr.entry ,   yyt2^.SysBitTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysBitTypeRepr.size ,   yyt2^.SysBitTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysBitTypeRepr.typeBlocklists ,   yyt2^.SysBitTypeRepr.typeBlocklists ) 
& ( yyt1^.SysBitTypeRepr.isInTDescList  =   yyt2^.SysBitTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysBitTypeRepr.label ,   yyt2^.SysBitTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysBitTypeRepr.signatureRepr ,   yyt2^.SysBitTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysBitTypeRepr.resultType ,   yyt2^.SysBitTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysBitTypeRepr.paramSpace ,   yyt2^.SysBitTypeRepr.paramSpace ) )
| SysCcTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysCcTypeRepr.entry ,   yyt2^.SysCcTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysCcTypeRepr.size ,   yyt2^.SysCcTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysCcTypeRepr.typeBlocklists ,   yyt2^.SysCcTypeRepr.typeBlocklists ) 
& ( yyt1^.SysCcTypeRepr.isInTDescList  =   yyt2^.SysCcTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysCcTypeRepr.label ,   yyt2^.SysCcTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysCcTypeRepr.signatureRepr ,   yyt2^.SysCcTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysCcTypeRepr.resultType ,   yyt2^.SysCcTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysCcTypeRepr.paramSpace ,   yyt2^.SysCcTypeRepr.paramSpace ) )
| SysLshTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysLshTypeRepr.entry ,   yyt2^.SysLshTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysLshTypeRepr.size ,   yyt2^.SysLshTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysLshTypeRepr.typeBlocklists ,   yyt2^.SysLshTypeRepr.typeBlocklists ) 
& ( yyt1^.SysLshTypeRepr.isInTDescList  =   yyt2^.SysLshTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysLshTypeRepr.label ,   yyt2^.SysLshTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysLshTypeRepr.signatureRepr ,   yyt2^.SysLshTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysLshTypeRepr.resultType ,   yyt2^.SysLshTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysLshTypeRepr.paramSpace ,   yyt2^.SysLshTypeRepr.paramSpace ) )
| SysRotTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysRotTypeRepr.entry ,   yyt2^.SysRotTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysRotTypeRepr.size ,   yyt2^.SysRotTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysRotTypeRepr.typeBlocklists ,   yyt2^.SysRotTypeRepr.typeBlocklists ) 
& ( yyt1^.SysRotTypeRepr.isInTDescList  =   yyt2^.SysRotTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysRotTypeRepr.label ,   yyt2^.SysRotTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysRotTypeRepr.signatureRepr ,   yyt2^.SysRotTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysRotTypeRepr.resultType ,   yyt2^.SysRotTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysRotTypeRepr.paramSpace ,   yyt2^.SysRotTypeRepr.paramSpace ) )
| SysValTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysValTypeRepr.entry ,   yyt2^.SysValTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysValTypeRepr.size ,   yyt2^.SysValTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysValTypeRepr.typeBlocklists ,   yyt2^.SysValTypeRepr.typeBlocklists ) 
& ( yyt1^.SysValTypeRepr.isInTDescList  =   yyt2^.SysValTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysValTypeRepr.label ,   yyt2^.SysValTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysValTypeRepr.signatureRepr ,   yyt2^.SysValTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysValTypeRepr.resultType ,   yyt2^.SysValTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysValTypeRepr.paramSpace ,   yyt2^.SysValTypeRepr.paramSpace ) )
| SysGetTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysGetTypeRepr.entry ,   yyt2^.SysGetTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysGetTypeRepr.size ,   yyt2^.SysGetTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysGetTypeRepr.typeBlocklists ,   yyt2^.SysGetTypeRepr.typeBlocklists ) 
& ( yyt1^.SysGetTypeRepr.isInTDescList  =   yyt2^.SysGetTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysGetTypeRepr.label ,   yyt2^.SysGetTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysGetTypeRepr.signatureRepr ,   yyt2^.SysGetTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysGetTypeRepr.resultType ,   yyt2^.SysGetTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysGetTypeRepr.paramSpace ,   yyt2^.SysGetTypeRepr.paramSpace ) )
| SysPutTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysPutTypeRepr.entry ,   yyt2^.SysPutTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysPutTypeRepr.size ,   yyt2^.SysPutTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysPutTypeRepr.typeBlocklists ,   yyt2^.SysPutTypeRepr.typeBlocklists ) 
& ( yyt1^.SysPutTypeRepr.isInTDescList  =   yyt2^.SysPutTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysPutTypeRepr.label ,   yyt2^.SysPutTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysPutTypeRepr.signatureRepr ,   yyt2^.SysPutTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysPutTypeRepr.resultType ,   yyt2^.SysPutTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysPutTypeRepr.paramSpace ,   yyt2^.SysPutTypeRepr.paramSpace ) )
| SysGetregTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysGetregTypeRepr.entry ,   yyt2^.SysGetregTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysGetregTypeRepr.size ,   yyt2^.SysGetregTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysGetregTypeRepr.typeBlocklists ,   yyt2^.SysGetregTypeRepr.typeBlocklists ) 
& ( yyt1^.SysGetregTypeRepr.isInTDescList  =   yyt2^.SysGetregTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysGetregTypeRepr.label ,   yyt2^.SysGetregTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysGetregTypeRepr.signatureRepr ,   yyt2^.SysGetregTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysGetregTypeRepr.resultType ,   yyt2^.SysGetregTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysGetregTypeRepr.paramSpace ,   yyt2^.SysGetregTypeRepr.paramSpace ) )
| SysPutregTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysPutregTypeRepr.entry ,   yyt2^.SysPutregTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysPutregTypeRepr.size ,   yyt2^.SysPutregTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysPutregTypeRepr.typeBlocklists ,   yyt2^.SysPutregTypeRepr.typeBlocklists ) 
& ( yyt1^.SysPutregTypeRepr.isInTDescList  =   yyt2^.SysPutregTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysPutregTypeRepr.label ,   yyt2^.SysPutregTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysPutregTypeRepr.signatureRepr ,   yyt2^.SysPutregTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysPutregTypeRepr.resultType ,   yyt2^.SysPutregTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysPutregTypeRepr.paramSpace ,   yyt2^.SysPutregTypeRepr.paramSpace ) )
| SysMoveTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysMoveTypeRepr.entry ,   yyt2^.SysMoveTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysMoveTypeRepr.size ,   yyt2^.SysMoveTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysMoveTypeRepr.typeBlocklists ,   yyt2^.SysMoveTypeRepr.typeBlocklists ) 
& ( yyt1^.SysMoveTypeRepr.isInTDescList  =   yyt2^.SysMoveTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysMoveTypeRepr.label ,   yyt2^.SysMoveTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysMoveTypeRepr.signatureRepr ,   yyt2^.SysMoveTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysMoveTypeRepr.resultType ,   yyt2^.SysMoveTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysMoveTypeRepr.paramSpace ,   yyt2^.SysMoveTypeRepr.paramSpace ) )
| SysNewTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysNewTypeRepr.entry ,   yyt2^.SysNewTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysNewTypeRepr.size ,   yyt2^.SysNewTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysNewTypeRepr.typeBlocklists ,   yyt2^.SysNewTypeRepr.typeBlocklists ) 
& ( yyt1^.SysNewTypeRepr.isInTDescList  =   yyt2^.SysNewTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysNewTypeRepr.label ,   yyt2^.SysNewTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysNewTypeRepr.signatureRepr ,   yyt2^.SysNewTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysNewTypeRepr.resultType ,   yyt2^.SysNewTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysNewTypeRepr.paramSpace ,   yyt2^.SysNewTypeRepr.paramSpace ) )
| SysAsmTypeRepr: RETURN TRUE
& IsEqualOB ( yyt1^.SysAsmTypeRepr.entry ,   yyt2^.SysAsmTypeRepr.entry ) 
& (yyIsEqual ( yyt1^.SysAsmTypeRepr.size ,   yyt2^.SysAsmTypeRepr.size ) )
& IsEqualOB ( yyt1^.SysAsmTypeRepr.typeBlocklists ,   yyt2^.SysAsmTypeRepr.typeBlocklists ) 
& ( yyt1^.SysAsmTypeRepr.isInTDescList  =   yyt2^.SysAsmTypeRepr.isInTDescList  )
& (yyIsEqual ( yyt1^.SysAsmTypeRepr.label ,   yyt2^.SysAsmTypeRepr.label ) )
& IsEqualOB ( yyt1^.SysAsmTypeRepr.signatureRepr ,   yyt2^.SysAsmTypeRepr.signatureRepr ) 
& IsEqualOB ( yyt1^.SysAsmTypeRepr.resultType ,   yyt2^.SysAsmTypeRepr.resultType ) 
& (yyIsEqual ( yyt1^.SysAsmTypeRepr.paramSpace ,   yyt2^.SysAsmTypeRepr.paramSpace ) )
| Signature: RETURN TRUE
& IsEqualOB ( yyt1^.Signature.next ,   yyt2^.Signature.next ) 
& IsEqualOB ( yyt1^.Signature.VarEntry ,   yyt2^.Signature.VarEntry ) 
| BooleanValue: RETURN TRUE
& (yyIsEqual ( yyt1^.BooleanValue.v ,   yyt2^.BooleanValue.v ) )
| CharValue: RETURN TRUE
& (yyIsEqual ( yyt1^.CharValue.v ,   yyt2^.CharValue.v ) )
| SetValue: RETURN TRUE
& (yyIsEqual ( yyt1^.SetValue.v ,   yyt2^.SetValue.v ) )
| IntegerValue: RETURN TRUE
& (yyIsEqual ( yyt1^.IntegerValue.v ,   yyt2^.IntegerValue.v ) )
| StringValue: RETURN TRUE
& (yyIsEqual ( yyt1^.StringValue.v ,   yyt2^.StringValue.v ) )
| RealValue: RETURN TRUE
& (yyIsEqual ( yyt1^.RealValue.v ,   yyt2^.RealValue.v ) )
| LongrealValue: RETURN TRUE
& (yyIsEqual ( yyt1^.LongrealValue.v ,   yyt2^.LongrealValue.v ) )
| CharRange: RETURN TRUE
& IsEqualOB ( yyt1^.CharRange.Next ,   yyt2^.CharRange.Next ) 
& (yyIsEqual ( yyt1^.CharRange.a ,   yyt2^.CharRange.a ) )
& (yyIsEqual ( yyt1^.CharRange.b ,   yyt2^.CharRange.b ) )
| IntegerRange: RETURN TRUE
& IsEqualOB ( yyt1^.IntegerRange.Next ,   yyt2^.IntegerRange.Next ) 
& (yyIsEqual ( yyt1^.IntegerRange.a ,   yyt2^.IntegerRange.a ) )
& (yyIsEqual ( yyt1^.IntegerRange.b ,   yyt2^.IntegerRange.b ) )
| NamePath: RETURN TRUE
& IsEqualOB ( yyt1^.NamePath.prev ,   yyt2^.NamePath.prev ) 
| IdentNamePath: RETURN TRUE
& IsEqualOB ( yyt1^.IdentNamePath.prev ,   yyt2^.IdentNamePath.prev ) 
& ( yyt1^.IdentNamePath.id  =   yyt2^.IdentNamePath.id  )
| SelectNamePath: RETURN TRUE
& IsEqualOB ( yyt1^.SelectNamePath.prev ,   yyt2^.SelectNamePath.prev ) 
| IndexNamePath: RETURN TRUE
& IsEqualOB ( yyt1^.IndexNamePath.prev ,   yyt2^.IndexNamePath.prev ) 
| DereferenceNamePath: RETURN TRUE
& IsEqualOB ( yyt1^.DereferenceNamePath.prev ,   yyt2^.DereferenceNamePath.prev ) 
| TDescList: RETURN TRUE
& IsEqualOB ( yyt1^.TDescList.TDescElems ,   yyt2^.TDescList.TDescElems ) 
| TDescElem: RETURN TRUE
& IsEqualOB ( yyt1^.TDescElem.prev ,   yyt2^.TDescElem.prev ) 
& IsEqualOB ( yyt1^.TDescElem.namePath ,   yyt2^.TDescElem.namePath ) 
& IsEqualOB ( yyt1^.TDescElem.TypeReprs ,   yyt2^.TDescElem.TypeReprs ) 
  ELSE RETURN TRUE;
  END;
 END IsEqualOB;

PROCEDURE BeginOB*;
 BEGIN
(* line 126 "OB.ast" *)
  MODULELEVEL           := 1;
        ROOTEXTLEVEL          := 0;
        FIELDLEVEL            := MIN(tLevel);

        REFPAR                := 0;
        VALPAR                := 1;

        PRIVATE               := 0;
        READONLY              := 1;
        PUBLIC                := 2;

        UNDECLARED            := 0;
        TOBEDECLARED          := 1;
        FORWARDDECLARED       := 2;
        DECLARED              := 3;

        OPENARRAYLEN          := -1;
        
        cmtObject             := mmtObject          (                                      );
        cPredeclModuleEntry   := mModuleEntry       (Idents.IdentPREDECL,LAB.MT,FALSE        ); 
        cSystemModuleEntry    := mModuleEntry       (Idents.IdentSYSTEM ,LAB.MT,FALSE        ); 
        cNonameEntry          := mDataEntry         ((* prevEntry   := *) NIL              
                                                    ,(* module      := *) cPredeclModuleEntry
                                                    ,(* ident       := *) Idents.NoIdent                  
                                                    ,(* exportMode  := *) PRIVATE                           
                                                    ,(* level       := *) 0                                 
                                                    ,(* declStatus  := *) DECLARED         );

        cmtEntry              := mmtEntry           ();
        cErrorEntry           := mErrorEntry        ();
                                                                                                            
        cNoBlocklist          := mNoBlocklist       (                                 ); 
        cPointerBlocklist     := mBlocklist         (cNoBlocklist,cNoBlocklist,0,1,4,0); 
        cProcedureBlocklist   := mBlocklist         (cNoBlocklist,cNoBlocklist,0,1,4,0); 
        cmtTypeBlocklist      := mTypeBlocklists    (cNoBlocklist,cNoBlocklist); 
                                                                                                            
        cmtTypeReprList       := mmtTypeReprList    ();
                                                                                                            
        cmtTypeRepr           := mmtTypeRepr        (                                                           );
        cErrorTypeRepr        := mErrorTypeRepr     (                                                           );
        cNilTypeRepr          := mNilTypeRepr       (cNonameEntry,OT.SIZEoPOINTER ,cmtTypeBlocklist,FALSE,LAB.MT);
        cByteTypeRepr         := mByteTypeRepr      (cNonameEntry,OT.SIZEoBYTE    ,cmtTypeBlocklist,FALSE,LAB.MT);
        cPtrTypeRepr          := mPtrTypeRepr       (cNonameEntry,OT.SIZEoPTR     ,cmtTypeBlocklist,FALSE,LAB.MT);
        cBooleanTypeRepr      := mBooleanTypeRepr   (cNonameEntry,OT.SIZEoBOOLEAN ,cmtTypeBlocklist,FALSE,LAB.MT);
        cCharTypeRepr         := mCharTypeRepr      (cNonameEntry,OT.SIZEoCHAR    ,cmtTypeBlocklist,FALSE,LAB.MT);
        cCharStringTypeRepr   := mCharStringTypeRepr(cNonameEntry,0               ,cmtTypeBlocklist,FALSE,LAB.MT);
        cStringTypeRepr       := mStringTypeRepr    (cNonameEntry,0               ,cmtTypeBlocklist,FALSE,LAB.MT);
        cSetTypeRepr          := mSetTypeRepr       (cNonameEntry,OT.SIZEoSET     ,cmtTypeBlocklist,FALSE,LAB.MT);
        cShortintTypeRepr     := mShortintTypeRepr  (cNonameEntry,OT.SIZEoSHORTINT,cmtTypeBlocklist,FALSE,LAB.MT);
        cIntegerTypeRepr      := mIntegerTypeRepr   (cNonameEntry,OT.SIZEoINTEGER ,cmtTypeBlocklist,FALSE,LAB.MT);
        cLongintTypeRepr      := mLongintTypeRepr   (cNonameEntry,OT.SIZEoLONGINT ,cmtTypeBlocklist,FALSE,LAB.MT);
        cRealTypeRepr         := mRealTypeRepr      (cNonameEntry,OT.SIZEoREAL    ,cmtTypeBlocklist,FALSE,LAB.MT);
        cLongrealTypeRepr     := mLongrealTypeRepr  (cNonameEntry,OT.SIZEoLONGREAL,cmtTypeBlocklist,FALSE,LAB.MT);

        cmtValue              := mmtValue           (           );
        cErrorValue           := mErrorValue        (           );
        cProcedureValue       := mProcedureValue    (           );
        cFalseValue           := mBooleanValue      (FALSE      );
        cTrueValue            := mBooleanValue      (TRUE       );
        cZeroIntegerValue     := mIntegerValue      (0          );
        cEmptySetValue        := mSetValue          (OT.EmptySet);
        cNilValue             := mNilValue          (           ); 
        cNilPointerValue      := mNilPointerValue   (           ); 
        cNilProcedureValue    := mNilProcedureValue (           ); 

        cmtSignature          := mmtSignature       ();
        cErrorSignature       := mErrorSignature    ();
        cGenericSignature     := mGenericSignature  ();

        cmtCoercion           := mmtCoercion        ();
        cShortint2Integer     := mShortint2Integer  ();
        cShortint2Longint     := mShortint2Longint  ();
        cShortint2Real        := mShortint2Real     ();
        cShortint2Longreal    := mShortint2Longreal ();
        cInteger2Longint      := mInteger2Longint   ();
        cInteger2Real         := mInteger2Real      ();
        cInteger2Longreal     := mInteger2Longreal  ();
        cLongint2Real         := mLongint2Real      ();
        cLongint2Longreal     := mLongint2Longreal  ();
        cReal2Longreal        := mReal2Longreal     ();
        cChar2String          := mChar2String       ();

        cmtLabelRange         := mmtLabelRange      (); 
	cmtNamePath           := mmtNamePath        (); 
        cmtTDescElem          := mmtTDescElem       (); 
 END BeginOB;

PROCEDURE CloseOB*;
 BEGIN
 END CloseOB;

PROCEDURE xxExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END xxExit;

PROCEDURE IsNullChar* (yyP10: tOB): BOOLEAN;
END IsNullChar;    

PROCEDURE LengthOfString* (yyP16: tOB): OT.oLONGINT;
END LengthOfString;

PROCEDURE IsEmptyBlocklist* (yyP1: tOB): BOOLEAN;
END IsEmptyBlocklist;

PROCEDURE PtrBlocklistOfType* (t: tOB): tOB;
END PtrBlocklistOfType;

BEGIN
 yyBlockList	:= NIL;
 yyPoolFreePtr	:= 0;
 yyPoolMaxPtr	:= 0;
 HeapUsed	:= 0;
 yyExit	:= xxExit;
 yyNodeSize [mtObject] := SIZE (ymtObject);
 yyNodeSize [Entries] := SIZE (yEntries);
 yyNodeSize [mtEntry] := SIZE (ymtEntry);
 yyNodeSize [ErrorEntry] := SIZE (yErrorEntry);
 yyNodeSize [ModuleEntry] := SIZE (yModuleEntry);
 yyNodeSize [Entry] := SIZE (yEntry);
 yyNodeSize [ScopeEntry] := SIZE (yScopeEntry);
 yyNodeSize [DataEntry] := SIZE (yDataEntry);
 yyNodeSize [ServerEntry] := SIZE (yServerEntry);
 yyNodeSize [ConstEntry] := SIZE (yConstEntry);
 yyNodeSize [TypeEntry] := SIZE (yTypeEntry);
 yyNodeSize [VarEntry] := SIZE (yVarEntry);
 yyNodeSize [ProcedureEntry] := SIZE (yProcedureEntry);
 yyNodeSize [BoundProcEntry] := SIZE (yBoundProcEntry);
 yyNodeSize [InheritedProcEntry] := SIZE (yInheritedProcEntry);
 yyNodeSize [Environment] := SIZE (yEnvironment);
 yyNodeSize [TypeReprLists] := SIZE (yTypeReprLists);
 yyNodeSize [mtTypeReprList] := SIZE (ymtTypeReprList);
 yyNodeSize [TypeReprList] := SIZE (yTypeReprList);
 yyNodeSize [Blocklists] := SIZE (yBlocklists);
 yyNodeSize [NoBlocklist] := SIZE (yNoBlocklist);
 yyNodeSize [Blocklist] := SIZE (yBlocklist);
 yyNodeSize [TypeBlocklists] := SIZE (yTypeBlocklists);
 yyNodeSize [TypeReprs] := SIZE (yTypeReprs);
 yyNodeSize [mtTypeRepr] := SIZE (ymtTypeRepr);
 yyNodeSize [ErrorTypeRepr] := SIZE (yErrorTypeRepr);
 yyNodeSize [TypeRepr] := SIZE (yTypeRepr);
 yyNodeSize [ForwardTypeRepr] := SIZE (yForwardTypeRepr);
 yyNodeSize [NilTypeRepr] := SIZE (yNilTypeRepr);
 yyNodeSize [ByteTypeRepr] := SIZE (yByteTypeRepr);
 yyNodeSize [PtrTypeRepr] := SIZE (yPtrTypeRepr);
 yyNodeSize [BooleanTypeRepr] := SIZE (yBooleanTypeRepr);
 yyNodeSize [CharTypeRepr] := SIZE (yCharTypeRepr);
 yyNodeSize [CharStringTypeRepr] := SIZE (yCharStringTypeRepr);
 yyNodeSize [StringTypeRepr] := SIZE (yStringTypeRepr);
 yyNodeSize [SetTypeRepr] := SIZE (ySetTypeRepr);
 yyNodeSize [IntTypeRepr] := SIZE (yIntTypeRepr);
 yyNodeSize [ShortintTypeRepr] := SIZE (yShortintTypeRepr);
 yyNodeSize [IntegerTypeRepr] := SIZE (yIntegerTypeRepr);
 yyNodeSize [LongintTypeRepr] := SIZE (yLongintTypeRepr);
 yyNodeSize [FloatTypeRepr] := SIZE (yFloatTypeRepr);
 yyNodeSize [RealTypeRepr] := SIZE (yRealTypeRepr);
 yyNodeSize [LongrealTypeRepr] := SIZE (yLongrealTypeRepr);
 yyNodeSize [ArrayTypeRepr] := SIZE (yArrayTypeRepr);
 yyNodeSize [RecordTypeRepr] := SIZE (yRecordTypeRepr);
 yyNodeSize [PointerTypeRepr] := SIZE (yPointerTypeRepr);
 yyNodeSize [ProcedureTypeRepr] := SIZE (yProcedureTypeRepr);
 yyNodeSize [PreDeclProcTypeRepr] := SIZE (yPreDeclProcTypeRepr);
 yyNodeSize [CaseFaultTypeRepr] := SIZE (yCaseFaultTypeRepr);
 yyNodeSize [WithFaultTypeRepr] := SIZE (yWithFaultTypeRepr);
 yyNodeSize [AbsTypeRepr] := SIZE (yAbsTypeRepr);
 yyNodeSize [AshTypeRepr] := SIZE (yAshTypeRepr);
 yyNodeSize [CapTypeRepr] := SIZE (yCapTypeRepr);
 yyNodeSize [ChrTypeRepr] := SIZE (yChrTypeRepr);
 yyNodeSize [EntierTypeRepr] := SIZE (yEntierTypeRepr);
 yyNodeSize [LenTypeRepr] := SIZE (yLenTypeRepr);
 yyNodeSize [LongTypeRepr] := SIZE (yLongTypeRepr);
 yyNodeSize [MaxTypeRepr] := SIZE (yMaxTypeRepr);
 yyNodeSize [MinTypeRepr] := SIZE (yMinTypeRepr);
 yyNodeSize [OddTypeRepr] := SIZE (yOddTypeRepr);
 yyNodeSize [OrdTypeRepr] := SIZE (yOrdTypeRepr);
 yyNodeSize [ShortTypeRepr] := SIZE (yShortTypeRepr);
 yyNodeSize [SizeTypeRepr] := SIZE (ySizeTypeRepr);
 yyNodeSize [AssertTypeRepr] := SIZE (yAssertTypeRepr);
 yyNodeSize [CopyTypeRepr] := SIZE (yCopyTypeRepr);
 yyNodeSize [DecTypeRepr] := SIZE (yDecTypeRepr);
 yyNodeSize [ExclTypeRepr] := SIZE (yExclTypeRepr);
 yyNodeSize [HaltTypeRepr] := SIZE (yHaltTypeRepr);
 yyNodeSize [IncTypeRepr] := SIZE (yIncTypeRepr);
 yyNodeSize [InclTypeRepr] := SIZE (yInclTypeRepr);
 yyNodeSize [NewTypeRepr] := SIZE (yNewTypeRepr);
 yyNodeSize [SysAdrTypeRepr] := SIZE (ySysAdrTypeRepr);
 yyNodeSize [SysBitTypeRepr] := SIZE (ySysBitTypeRepr);
 yyNodeSize [SysCcTypeRepr] := SIZE (ySysCcTypeRepr);
 yyNodeSize [SysLshTypeRepr] := SIZE (ySysLshTypeRepr);
 yyNodeSize [SysRotTypeRepr] := SIZE (ySysRotTypeRepr);
 yyNodeSize [SysValTypeRepr] := SIZE (ySysValTypeRepr);
 yyNodeSize [SysGetTypeRepr] := SIZE (ySysGetTypeRepr);
 yyNodeSize [SysPutTypeRepr] := SIZE (ySysPutTypeRepr);
 yyNodeSize [SysGetregTypeRepr] := SIZE (ySysGetregTypeRepr);
 yyNodeSize [SysPutregTypeRepr] := SIZE (ySysPutregTypeRepr);
 yyNodeSize [SysMoveTypeRepr] := SIZE (ySysMoveTypeRepr);
 yyNodeSize [SysNewTypeRepr] := SIZE (ySysNewTypeRepr);
 yyNodeSize [SysAsmTypeRepr] := SIZE (ySysAsmTypeRepr);
 yyNodeSize [SignatureRepr] := SIZE (ySignatureRepr);
 yyNodeSize [mtSignature] := SIZE (ymtSignature);
 yyNodeSize [ErrorSignature] := SIZE (yErrorSignature);
 yyNodeSize [GenericSignature] := SIZE (yGenericSignature);
 yyNodeSize [Signature] := SIZE (ySignature);
 yyNodeSize [ValueReprs] := SIZE (yValueReprs);
 yyNodeSize [mtValue] := SIZE (ymtValue);
 yyNodeSize [ErrorValue] := SIZE (yErrorValue);
 yyNodeSize [ProcedureValue] := SIZE (yProcedureValue);
 yyNodeSize [ValueRepr] := SIZE (yValueRepr);
 yyNodeSize [BooleanValue] := SIZE (yBooleanValue);
 yyNodeSize [CharValue] := SIZE (yCharValue);
 yyNodeSize [SetValue] := SIZE (ySetValue);
 yyNodeSize [IntegerValue] := SIZE (yIntegerValue);
 yyNodeSize [MemValueRepr] := SIZE (yMemValueRepr);
 yyNodeSize [StringValue] := SIZE (yStringValue);
 yyNodeSize [RealValue] := SIZE (yRealValue);
 yyNodeSize [LongrealValue] := SIZE (yLongrealValue);
 yyNodeSize [NilValue] := SIZE (yNilValue);
 yyNodeSize [NilPointerValue] := SIZE (yNilPointerValue);
 yyNodeSize [NilProcedureValue] := SIZE (yNilProcedureValue);
 yyNodeSize [Coercion] := SIZE (yCoercion);
 yyNodeSize [mtCoercion] := SIZE (ymtCoercion);
 yyNodeSize [Shortint2Integer] := SIZE (yShortint2Integer);
 yyNodeSize [Shortint2Longint] := SIZE (yShortint2Longint);
 yyNodeSize [Shortint2Real] := SIZE (yShortint2Real);
 yyNodeSize [Shortint2Longreal] := SIZE (yShortint2Longreal);
 yyNodeSize [Integer2Longint] := SIZE (yInteger2Longint);
 yyNodeSize [Integer2Real] := SIZE (yInteger2Real);
 yyNodeSize [Integer2Longreal] := SIZE (yInteger2Longreal);
 yyNodeSize [Longint2Real] := SIZE (yLongint2Real);
 yyNodeSize [Longint2Longreal] := SIZE (yLongint2Longreal);
 yyNodeSize [Real2Longreal] := SIZE (yReal2Longreal);
 yyNodeSize [Char2String] := SIZE (yChar2String);
 yyNodeSize [LabelRanges] := SIZE (yLabelRanges);
 yyNodeSize [mtLabelRange] := SIZE (ymtLabelRange);
 yyNodeSize [CharRange] := SIZE (yCharRange);
 yyNodeSize [IntegerRange] := SIZE (yIntegerRange);
 yyNodeSize [NamePaths] := SIZE (yNamePaths);
 yyNodeSize [mtNamePath] := SIZE (ymtNamePath);
 yyNodeSize [NamePath] := SIZE (yNamePath);
 yyNodeSize [IdentNamePath] := SIZE (yIdentNamePath);
 yyNodeSize [SelectNamePath] := SIZE (ySelectNamePath);
 yyNodeSize [IndexNamePath] := SIZE (yIndexNamePath);
 yyNodeSize [DereferenceNamePath] := SIZE (yDereferenceNamePath);
 yyNodeSize [TDescList] := SIZE (yTDescList);
 yyNodeSize [TDescElems] := SIZE (yTDescElems);
 yyNodeSize [mtTDescElem] := SIZE (ymtTDescElem);
 yyNodeSize [TDescElem] := SIZE (yTDescElem);
 yyMaxSize	:= 0;
 FOR yyi := 1 TO 133 DO
  yyNodeSize [yyi] := SYSTEM.VAL(INTEGER,SYSTEM.VAL(SET,yyNodeSize [yyi] + (General.MaxAlign) - 1) * General.AlignMasks [General.MaxAlign]);
  yyMaxSize := SHORT(General.Max (yyNodeSize [yyi], yyMaxSize));
 END;
 yyTypeRange [mtObject] := mtObject;
 yyTypeRange [Entries] := InheritedProcEntry;
 yyTypeRange [mtEntry] := mtEntry;
 yyTypeRange [ErrorEntry] := ErrorEntry;
 yyTypeRange [ModuleEntry] := ModuleEntry;
 yyTypeRange [Entry] := InheritedProcEntry;
 yyTypeRange [ScopeEntry] := ScopeEntry;
 yyTypeRange [DataEntry] := InheritedProcEntry;
 yyTypeRange [ServerEntry] := ServerEntry;
 yyTypeRange [ConstEntry] := ConstEntry;
 yyTypeRange [TypeEntry] := TypeEntry;
 yyTypeRange [VarEntry] := VarEntry;
 yyTypeRange [ProcedureEntry] := ProcedureEntry;
 yyTypeRange [BoundProcEntry] := BoundProcEntry;
 yyTypeRange [InheritedProcEntry] := InheritedProcEntry;
 yyTypeRange [Environment] := Environment;
 yyTypeRange [TypeReprLists] := TypeReprList;
 yyTypeRange [mtTypeReprList] := mtTypeReprList;
 yyTypeRange [TypeReprList] := TypeReprList;
 yyTypeRange [Blocklists] := Blocklist;
 yyTypeRange [NoBlocklist] := NoBlocklist;
 yyTypeRange [Blocklist] := Blocklist;
 yyTypeRange [TypeBlocklists] := TypeBlocklists;
 yyTypeRange [TypeReprs] := SysAsmTypeRepr;
 yyTypeRange [mtTypeRepr] := mtTypeRepr;
 yyTypeRange [ErrorTypeRepr] := ErrorTypeRepr;
 yyTypeRange [TypeRepr] := SysAsmTypeRepr;
 yyTypeRange [ForwardTypeRepr] := ForwardTypeRepr;
 yyTypeRange [NilTypeRepr] := NilTypeRepr;
 yyTypeRange [ByteTypeRepr] := ByteTypeRepr;
 yyTypeRange [PtrTypeRepr] := PtrTypeRepr;
 yyTypeRange [BooleanTypeRepr] := BooleanTypeRepr;
 yyTypeRange [CharTypeRepr] := CharTypeRepr;
 yyTypeRange [CharStringTypeRepr] := CharStringTypeRepr;
 yyTypeRange [StringTypeRepr] := StringTypeRepr;
 yyTypeRange [SetTypeRepr] := SetTypeRepr;
 yyTypeRange [IntTypeRepr] := LongintTypeRepr;
 yyTypeRange [ShortintTypeRepr] := ShortintTypeRepr;
 yyTypeRange [IntegerTypeRepr] := IntegerTypeRepr;
 yyTypeRange [LongintTypeRepr] := LongintTypeRepr;
 yyTypeRange [FloatTypeRepr] := LongrealTypeRepr;
 yyTypeRange [RealTypeRepr] := RealTypeRepr;
 yyTypeRange [LongrealTypeRepr] := LongrealTypeRepr;
 yyTypeRange [ArrayTypeRepr] := ArrayTypeRepr;
 yyTypeRange [RecordTypeRepr] := RecordTypeRepr;
 yyTypeRange [PointerTypeRepr] := PointerTypeRepr;
 yyTypeRange [ProcedureTypeRepr] := SysAsmTypeRepr;
 yyTypeRange [PreDeclProcTypeRepr] := SysAsmTypeRepr;
 yyTypeRange [CaseFaultTypeRepr] := CaseFaultTypeRepr;
 yyTypeRange [WithFaultTypeRepr] := WithFaultTypeRepr;
 yyTypeRange [AbsTypeRepr] := AbsTypeRepr;
 yyTypeRange [AshTypeRepr] := AshTypeRepr;
 yyTypeRange [CapTypeRepr] := CapTypeRepr;
 yyTypeRange [ChrTypeRepr] := ChrTypeRepr;
 yyTypeRange [EntierTypeRepr] := EntierTypeRepr;
 yyTypeRange [LenTypeRepr] := LenTypeRepr;
 yyTypeRange [LongTypeRepr] := LongTypeRepr;
 yyTypeRange [MaxTypeRepr] := MaxTypeRepr;
 yyTypeRange [MinTypeRepr] := MinTypeRepr;
 yyTypeRange [OddTypeRepr] := OddTypeRepr;
 yyTypeRange [OrdTypeRepr] := OrdTypeRepr;
 yyTypeRange [ShortTypeRepr] := ShortTypeRepr;
 yyTypeRange [SizeTypeRepr] := SizeTypeRepr;
 yyTypeRange [AssertTypeRepr] := AssertTypeRepr;
 yyTypeRange [CopyTypeRepr] := CopyTypeRepr;
 yyTypeRange [DecTypeRepr] := DecTypeRepr;
 yyTypeRange [ExclTypeRepr] := ExclTypeRepr;
 yyTypeRange [HaltTypeRepr] := HaltTypeRepr;
 yyTypeRange [IncTypeRepr] := IncTypeRepr;
 yyTypeRange [InclTypeRepr] := InclTypeRepr;
 yyTypeRange [NewTypeRepr] := NewTypeRepr;
 yyTypeRange [SysAdrTypeRepr] := SysAdrTypeRepr;
 yyTypeRange [SysBitTypeRepr] := SysBitTypeRepr;
 yyTypeRange [SysCcTypeRepr] := SysCcTypeRepr;
 yyTypeRange [SysLshTypeRepr] := SysLshTypeRepr;
 yyTypeRange [SysRotTypeRepr] := SysRotTypeRepr;
 yyTypeRange [SysValTypeRepr] := SysValTypeRepr;
 yyTypeRange [SysGetTypeRepr] := SysGetTypeRepr;
 yyTypeRange [SysPutTypeRepr] := SysPutTypeRepr;
 yyTypeRange [SysGetregTypeRepr] := SysGetregTypeRepr;
 yyTypeRange [SysPutregTypeRepr] := SysPutregTypeRepr;
 yyTypeRange [SysMoveTypeRepr] := SysMoveTypeRepr;
 yyTypeRange [SysNewTypeRepr] := SysNewTypeRepr;
 yyTypeRange [SysAsmTypeRepr] := SysAsmTypeRepr;
 yyTypeRange [SignatureRepr] := Signature;
 yyTypeRange [mtSignature] := mtSignature;
 yyTypeRange [ErrorSignature] := ErrorSignature;
 yyTypeRange [GenericSignature] := GenericSignature;
 yyTypeRange [Signature] := Signature;
 yyTypeRange [ValueReprs] := NilProcedureValue;
 yyTypeRange [mtValue] := mtValue;
 yyTypeRange [ErrorValue] := ErrorValue;
 yyTypeRange [ProcedureValue] := ProcedureValue;
 yyTypeRange [ValueRepr] := NilProcedureValue;
 yyTypeRange [BooleanValue] := BooleanValue;
 yyTypeRange [CharValue] := CharValue;
 yyTypeRange [SetValue] := SetValue;
 yyTypeRange [IntegerValue] := IntegerValue;
 yyTypeRange [MemValueRepr] := LongrealValue;
 yyTypeRange [StringValue] := StringValue;
 yyTypeRange [RealValue] := RealValue;
 yyTypeRange [LongrealValue] := LongrealValue;
 yyTypeRange [NilValue] := NilValue;
 yyTypeRange [NilPointerValue] := NilPointerValue;
 yyTypeRange [NilProcedureValue] := NilProcedureValue;
 yyTypeRange [Coercion] := Char2String;
 yyTypeRange [mtCoercion] := mtCoercion;
 yyTypeRange [Shortint2Integer] := Shortint2Integer;
 yyTypeRange [Shortint2Longint] := Shortint2Longint;
 yyTypeRange [Shortint2Real] := Shortint2Real;
 yyTypeRange [Shortint2Longreal] := Shortint2Longreal;
 yyTypeRange [Integer2Longint] := Integer2Longint;
 yyTypeRange [Integer2Real] := Integer2Real;
 yyTypeRange [Integer2Longreal] := Integer2Longreal;
 yyTypeRange [Longint2Real] := Longint2Real;
 yyTypeRange [Longint2Longreal] := Longint2Longreal;
 yyTypeRange [Real2Longreal] := Real2Longreal;
 yyTypeRange [Char2String] := Char2String;
 yyTypeRange [LabelRanges] := IntegerRange;
 yyTypeRange [mtLabelRange] := mtLabelRange;
 yyTypeRange [CharRange] := CharRange;
 yyTypeRange [IntegerRange] := IntegerRange;
 yyTypeRange [NamePaths] := DereferenceNamePath;
 yyTypeRange [mtNamePath] := mtNamePath;
 yyTypeRange [NamePath] := DereferenceNamePath;
 yyTypeRange [IdentNamePath] := IdentNamePath;
 yyTypeRange [SelectNamePath] := SelectNamePath;
 yyTypeRange [IndexNamePath] := IndexNamePath;
 yyTypeRange [DereferenceNamePath] := DereferenceNamePath;
 yyTypeRange [TDescList] := TDescList;
 yyTypeRange [TDescElems] := TDescElem;
 yyTypeRange [mtTDescElem] := mtTDescElem;
 yyTypeRange [TDescElem] := TDescElem;
 BeginOB;
END OB.
