MODULE Base;

IMPORT SYSTEM,Idents;

(* From IR *)
VAR 
     OptEmitIR*, OptEmitMatch*, OptRegAlloc* : BOOLEAN;

(* From OT *)

CONST MaxCharOrd*       = 0FFX;
      MinIllegalAbsInt* = MIN(LONGINT);
      FLTDIG*          = 7;
      DBLDIG*          = 15;

(* From Tree *)

      EqualOper*        = 105;
      UnequalOper*      = 106;
      LessOper*         = 108;
      LessEqualOper*    = 109;
      GreaterOper*      = 110;
      GreaterEqualOper* = 111;
      PlusOper*         = 114;
      MinusOper*        = 115;
      MultOper*         = 116;
      RDivOper*         = 117;
      DivOper*          = 119;
      ModOper*          = 120;

(* From FIL *)

VAR ActP*: POINTER TO RECORD
                       NextLocLabel*:LONGINT; 
                       ErrorList*:LONGINT; 
                       SourceDir*    ,
                       Filename*     : POINTER TO ARRAY OF CHAR;
                       TreeRoot*     : SYSTEM.PTR;
                      END;  
                      
(* From OB *)

TYPE
tLevel*      = SHORTINT;
tParMode*    = SHORTINT;
tExportMode* = SHORTINT;
tSize*       = LONGINT;
tAddress*    = LONGINT;
tOB*         = POINTER TO RECORD
                          END;  
                          
(* From ERR *)

TYPE 
tErrorMsg* = LONGINT;

(* From Errors *)

CONST 
ExpectedTokens*       = 2  ;
String*               = 7  ;
Ident*                = 10 ;

(* From ASM *)

CONST codeEAX*         = 0;
      codeEBX*         = 1;
      codeECX*         = 2;
      codeEDX*         = 3;
      codeESI*         = 4;
      codeEDI*         = 5;
      codeEBP*         = 6;
      codeESP*         = 7;
      codeEFLAGS*      = 8;
      codeST0*         = 9;
      codeST1*         = 10;
      codeST2*         = 11;
      codeST3*         = 12;
      codeST4*         = 13;
      codeST5*         = 14;
      codeST6*         = 15;
      codeST7*         = 16;
      
CONST codeCF*          = 00001H; (* Carry Flag             *)
      codePF*          = 00004H; (* Parity Flag            *)
      codeAF*          = 00010H; (* Auxiliary carry Flag   *)
      codeZF*          = 00040H; (* Zero Flag              *)
      codeSF*          = 00080H; (* Sign Flag              *)
      codeTF*          = 00100H; (* Trap Flag              *)
      codeIF*          = 00200H; (* Interrupt enable Flag  *)
      codeDF*          = 00400H; (* Direction Flag         *)
      codeOF*          = 00800H; (* Overflow Flag          *)
      codeNT*          = 04000H; (* Nested Task flag       *)
      codeRF*          = 10000H; (* Resume Flag            *)
      codeVM*          = 20000H; (* Virtual 8086 Mode flag *)
      codeAC*          = 40000H; (* Alignment Check flag   *)

(* From CV *)
TYPE tTable*=SYSTEM.PTR;

PROCEDURE Init*; END Init;

(* From Parser *)

PROCEDURE TokenName* (Token:LONGINT; VAR Name: ARRAY OF CHAR);
END TokenName;

(* From ADR *)

PROCEDURE Align4*(v:tSize):tSize; END Align4;

(* From T *)

PROCEDURE SizeOfType* (yyP1: SYSTEM.PTR): tSize; END SizeOfType;

(* From SI *)

PROCEDURE AreMatchingSignatures* (Sa,Sb: SYSTEM.PTR): BOOLEAN; END AreMatchingSignatures;

(* From E *)

PROCEDURE ReceiverTypeOfBoundProc* (yyP32: SYSTEM.PTR): tOB; END ReceiverTypeOfBoundProc;
PROCEDURE IsGenuineEmptyEntry* (yyP5: SYSTEM.PTR): BOOLEAN; END IsGenuineEmptyEntry;
PROCEDURE IsVisibleBoundProcEntry* (Module: SYSTEM.PTR; yyP22: SYSTEM.PTR): BOOLEAN; END IsVisibleBoundProcEntry;
PROCEDURE MaxExportMode* (yyP41: tExportMode; yyP40: tExportMode): tExportMode; END MaxExportMode;
PROCEDURE Lookup0* (yyP2: SYSTEM.PTR; Ident:INTEGER): tOB; END Lookup0;

(* From DRV *)

PROCEDURE Import*(ServerIdent : Idents.tIdent; VAR ErrorMsg :INTEGER) : tOB; END Import;
PROCEDURE ShowCompiling*(table : SYSTEM.PTR) : tOB; END ShowCompiling;
PROCEDURE ShowProcCount*(table : SYSTEM.PTR) : tOB; END ShowProcCount;

END Base.

