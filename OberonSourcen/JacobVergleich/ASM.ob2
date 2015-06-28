MODULE ASM;

IMPORT Storage,ADR, ARG, ASMOP, ConsBase, ERR, Idents, LAB, LIM, O, OT, STR, StringMem, Strings, Strings1, SYSTEM, TextIO, UTI;

TYPE  tReg*=ConsBase.BegRegister;
CONST NoReg*=ConsBase.RegNil;
      al*=ConsBase.Regal; ah*=ConsBase.Regah; bl*=ConsBase.Regbl; bh*=ConsBase.Regbh; cl*=ConsBase.Regcl; ch*=ConsBase.Regch; dl*=ConsBase.Regdl; 
      dh*=ConsBase.Regdh; ax*=ConsBase.Regax; bx*=ConsBase.Regbx; cx*=ConsBase.Regcx; dx*=ConsBase.Regdx; si*=ConsBase.Regsi; di*=ConsBase.Regdi; 
      eax*=ConsBase.Regeax; ebx*=ConsBase.Regebx; ecx*=ConsBase.Regecx; edx*=ConsBase.Regedx; esi*=ConsBase.Regesi; edi*=ConsBase.Regedi; 
      ebp*=ConsBase.Regebp; esp*=ConsBase.Regesp; st*=ConsBase.Regst; st1*=ConsBase.Regst1; 
      st2*=ConsBase.Regst2; st3*=ConsBase.Regst3; st4*=ConsBase.Regst4; st5*=ConsBase.Regst5; st6*=ConsBase.Regst6; st7*=ConsBase.Regst7;
VAR   RegStrTab*   : ARRAY ConsBase.MAX_BegRegister+1,7 OF CHAR;
      LoRegTab*    ,
      HiRegTab*    : ARRAY ConsBase.MAX_BegRegister+1 OF tReg;
     
(*
 * Codings for module SYSTEM
 *)
 
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
      MIN_CodeRegTabRange* = 0;
      MAX_CodeRegTabRange* = codeST7;
VAR   CodeRegTab*      : ARRAY codeST7+1 OF tReg;
      
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

(************************************************************************************************************************)
(*
 * sizes
 *)		
 
TYPE  tSize*            = ConsBase.tSize;
CONST NoSize*           = ConsBase.NoSize;
      b*                = ConsBase.b;
      w*                = ConsBase.w;
      l*                = ConsBase.l;
      s*                = ConsBase.s;
VAR   SizeTab*          : ARRAY 5 OF tSize;	                                    (* number of bytes --> tSize        *)
      FloatSizeTab*     : ARRAY 9 OF tSize;                                     (* 4 --> s, 8 --> l                 *)
      SizeStrTab*       : ARRAY ConsBase.MAX_tSize+1 OF CHAR;                                       (* <tSize> --> '<tSize>'            *)
      RegSizeTab*       : ARRAY ConsBase.MAX_BegRegister+1 OF tSize;                                       (* tSize of register                *)
      BitSizeTab*       : ARRAY ConsBase.MAX_tSize+1 OF LONGINT;                                   (* tSize --> number of bits         *)
      ByteSizeTab*      : ARRAY ConsBase.MAX_tSize+1 OF LONGINT;                                   (* tSize --> number of bytes        *)
      FloatByteSizeTab* : ARRAY ConsBase.MAX_tSize+1 OF LONGINT;                                   (* s --> 4, l --> 8                 *)
      SizedRegTab*      : ARRAY ConsBase.MAX_BegRegister+1,ConsBase.MAX_tSize+1 OF tReg;                                 (* tReg x tSize --> tReg with tSize *)

(************************************************************************************************************************)
(*
 * operands
 *)
TYPE tOp*       = POINTER TO tOpRec;
     tLabel*    = STR.tStr;
     tLocation* = RECORD
                   label*    : tLabel;
                   ofs*      : LONGINT; 
                   breg*     ,
                   ireg*     : tReg;
                   factor*   : LONGINT; 
                   cmtIdent* : Idents.tIdent;
                  END; 
VAR  mtLocation* : tLocation;
     EmptyOp*    : tOp;
     
TYPE tOperKind*    = SHORTINT;
CONST okImmediate* = 0;
      okRegister*  = 1;
      okMemory*    = 2;
TYPE 
     tOperand*   = RECORD
                    kind*:tOperKind;
                    val*:LONGINT; 
                    reg*:tReg;
                    loc*:tLocation;
                   END;     

TYPE tVariable*  = RECORD
                   label*    : tLabel;
                   frame*    ,
                   ofs*      : LONGINT; 
                   tmpreg*   : tReg;
                   cmtIdent* : Idents.tIdent;
                   log2*     : LONGINT; (* dirty trick! *)
                  END;
(*
 * label#MT           <==> global variable      at <label>+<ofs>
 * label=MT & frame=0 <==> local variable       at <ofs>(ebp)
 * label=MT & frame#0 <==> outer local variable at <ofs>(<frame>(ebp))
 *)
 
(************************************************************************************************************************)
(*
 * relations
 *)
 
TYPE  tRelation*      = ConsBase.tRelation;
CONST NoRelation*     = ConsBase.NoRelation;
      equal*          = ConsBase.equal;
      unequal*        = ConsBase.unequal;
      less*           = ConsBase.less;
      lessORequal*    = ConsBase.lessORequal;
      greater*        = ConsBase.greater;
      greaterORequal* = ConsBase.greaterORequal;
VAR   BranchOperTab*  ,                                                                    (* e.g. "<",unsigned --> jb   *)
      FlagSetOperTab* : ARRAY ConsBase.MAX_tRelation+1,(*isSignedRelation:*)2 OF ASMOP.tOper;       (* e.g. ">",signed   --> setg *)
      InvRelTab*      ,				                         (* for negation.            e.g. ">=" --> "<"  *)
      RevRelTab*      : ARRAY ConsBase.MAX_tRelation+1 OF tRelation;                     (* for exchanging operands. e.g. ">=" --> "<=" *)

TYPE tOperId*= RECORD                              (* "opaque" data type for identifying an emitted assember statement. *)
                id  : LONGINT; 
                adr : SYSTEM.PTR; 
               END;   

CONST align  = ASMOP.align;
      asciz  = ASMOP.asciz;
      byte   = ASMOP.byte;
      comm   = ASMOP.comm;
      data   = ASMOP.data;
      globl  = ASMOP.globl;
      long   = ASMOP.long;
      text   = ASMOP.text;
      and    = ASMOP.and;
      call   = ASMOP.call;
      cld    = ASMOP.cld;
      cmp    = ASMOP.cmp;
      imul   = ASMOP.imul;
      jmp    = ASMOP.jmp;
      jnz    = ASMOP.jnz;
      lea    = ASMOP.lea;
      mov    = ASMOP.mov;
      movs   = ASMOP.movs;
      movzbw = ASMOP.movzbw;
      movzbl = ASMOP.movzbl;
      movzwl = ASMOP.movzwl;
      neg    = ASMOP.neg;
      nop    = ASMOP.nop;
      repz   = ASMOP.repz;
      shl    = ASMOP.shl;
      stos   = ASMOP.stos;
      xchg   = ASMOP.xchg;
      xor    = ASMOP.xor;
VAR reg:tReg;

(************************************************************************************************************************)
(*** operand definitions and operand output                                                                           ***)
(************************************************************************************************************************)
TYPE tOpID     = SHORTINT;
CONST 
     ID_      = 0; 
     ID_S     = 1;
     ID_i     = 2;
     ID_x     = 3;
     ID_iL    = 4;
     ID_ioL   = 5;
     ID_R     = 6;
     ID_oLBIf = 7;
     ID_oLBI  = 8;
     ID_oLB   = 9;
     ID_oLIf  = 10;
     ID_oL    = 11;
     ID_o     = 12;
     ID_oBIf  = 13;
     ID_oBI   = 14;
     ID_oB    = 15;
     ID_oIf   = 16;
     ID_LBIf  = 17;
     ID_LBI   = 18;
     ID_LB    = 19;
     ID_LIf   = 20;
     ID_L     = 21;
     ID_BIf   = 22;
     ID_BI    = 23;
     ID_B     = 24;
     ID_If    = 25;
     MAX_tOpID = ID_If;

TYPE tOpRec    = RECORD 
                  ID     : tOpID;
                  str    : STR.tStr;
                  int    : LONGINT;  (* immediate value / offset *)
                  crd    : LONGINT; (* immediate value          *)
                  label  : tLabel;
                  reg    ,           (* base register / register *)
                  ireg   : tReg;     (* index register           *)
                  factor : LONGINT;  (* index factor             *)
                 END;
VAR  OpProcTab : ARRAY MAX_tOpID+1 OF RECORD
                                 Out : PROCEDURE(VAR r:tOpRec); 
                                END;

(************************************************************************************************************************)
(*** operation definitions and operation buffer                                                                       ***)
(************************************************************************************************************************)
CONST MaxNofDelayedOperations = 1024;      
      MaxLenOfComment         = 200;
TYPE  tOperationBuf           = RECORD
                                 operId    : LONGINT; 
                                 obsolete  : BOOLEAN; 
                                 operation : ASMOP.tOper;
                                 size      : tSize;
                                 operand1  ,
                                 operand2  ,
                                 operand3  : tOp;
                                 comment   : ARRAY MaxLenOfComment+1 OF CHAR; 
                                END;
VAR   OperationBuf            : ARRAY MaxNofDelayedOperations OF tOperationBuf;
      NofOpersInBuf           ,
      OperHeadIdx             , 
      OperTailIdx             :LONGINT; 
TYPE  topern = POINTER TO tOperationBuf;
VAR   opern                   : topern;
      nextOperCmtIdent        : Idents.tIdent;
      LastOperId              : LONGINT; 

(************************************************************************************************************************)
(*** operand buffer                                                                                                   ***)
(************************************************************************************************************************)
CONST MaxNofOpBufs  = 4*MaxNofDelayedOperations; (* Ok, we have only a maximum of 3 operands, but MOD (n*4) works faster*)
VAR   OpBuf         : ARRAY MaxNofOpBufs OF tOpRec;
      nextFreeOpIdx : LONGINT; 
VAR   opn           : tOp;

(************************************************************************************************************************)
(*** output buffer                                                                                                    ***)
(************************************************************************************************************************)
CONST OutputBufMaxSize = 2*MaxLenOfComment;
VAR   OutputBuf        : ARRAY OutputBufMaxSize+2 OF CHAR; (* plus "\n" plus 0X  *)
      OutputIdx        :LONGINT; 
      OutputFile       : TextIO.File;
      
(************************************************************************************************************************)
(*** operations                                                                                                       ***)
(************************************************************************************************************************)
CONST NoSection   = 0;
      DataSection = 1;
      TextSection = 2;
VAR   curSection  : SHORTINT; 
      is_cld      : BOOLEAN; 

(************************************************************************************************************************)
PROCEDURE AreEqualVariables*(VAR v1,v2:tVariable):BOOLEAN; 
BEGIN (* AreEqualVariables *)
 RETURN LAB.Equal(v1.label,v2.label)
      & (v1.frame=v2.frame)
      & (v1.ofs=v2.ofs); 
END AreEqualVariables;

PROCEDURE^OutS(s:ARRAY OF CHAR);
PROCEDURE^OutCh(c:CHAR);
PROCEDURE^OutI(i:LONGINT);
PROCEDURE^OutX(v:LONGINT);
PROCEDURE^OutR(r:tReg);
PROCEDURE^OutOper(VAR oper:tOperationBuf);

PROCEDURE Out_(VAR op:tOpRec);
BEGIN (* Out_ *) 
END Out_;

PROCEDURE Out_S(VAR op:tOpRec);
BEGIN (* Out_S *)
 OutCh('"'); OutS(op.str^); OutCh('"'); 
 STR.Free(op.str); 
END Out_S;
                   
PROCEDURE Out_i(VAR op:tOpRec);
BEGIN (* Out_i *) 
 OutCh('$'); OutI(op.int); 
END Out_i;
                   
PROCEDURE Out_x(VAR op:tOpRec);
BEGIN (* Out_x *) 
 OutS('$0x'); OutX(op.crd); 
END Out_x;
                   
PROCEDURE Out_iL(VAR op:tOpRec);
BEGIN (* Out_iL *) 
 OutCh('$'); OutS(op.label^); 
END Out_iL;
                   
PROCEDURE Out_ioL(VAR op:tOpRec);
BEGIN (* Out_ioL *) 
 OutCh('$'); 
 IF op.int#0 THEN OutI(op.int); OutCh('+'); END; (* IF *)
 OutS(op.label^); 
END Out_ioL;
                   
PROCEDURE Out_R(VAR op:tOpRec);
BEGIN (* Out_R *) 
 OutR(op.reg); 
END Out_R;
                   
PROCEDURE Out_oLBIf(VAR op:tOpRec);
BEGIN (* Out_oLBIf *) 
 IF op.int#0 THEN 
    OutI(op.int); 
 ELSIF (op.label=NIL) & (op.reg=ConsBase.RegNil) & (op.ireg=ConsBase.RegNil) THEN
    OutCh('0'); RETURN; 
 END; (* IF *)
 
 IF op.label#NIL THEN 
    IF op.int#0 THEN OutCh('+'); END; (* IF *)
    OutS(op.label^); 
 END; (* IF *)          
 
 IF (op.reg#ConsBase.RegNil) OR (op.ireg#ConsBase.RegNil) THEN 
    OutCh('('); 
    IF (op.reg=ConsBase.RegNil) & (op.factor=1) THEN 
       OutR(op.ireg); 
    ELSE 
       IF op.reg#ConsBase.RegNil THEN OutR(op.reg); END; (* IF *)
       IF op.ireg#ConsBase.RegNil THEN 
          OutCh(','); OutR(op.ireg); 
          IF op.factor>1 THEN OutCh(','); OutCh(CHR(48+op.factor)); END; (* IF *)
       END; (* IF *)
    END; (* IF *)
    OutCh(')'); 
 END; (* IF *)
END Out_oLBIf;
                   
(************************************************************************************************************************)
PROCEDURE InitOperands;
VAR odi:tOpID;
BEGIN (* InitOperands *) 
 FOR odi:=0 TO MAX_tOpID DO OpProcTab[odi].Out:=Out_; END; (* FOR *)
 OpProcTab[ID_S    ].Out := Out_S    ; 
 OpProcTab[ID_i    ].Out := Out_i    ; 
 OpProcTab[ID_x    ].Out := Out_x    ; 
 OpProcTab[ID_iL   ].Out := Out_iL   ; 
 OpProcTab[ID_ioL  ].Out := Out_ioL  ; 
 OpProcTab[ID_R    ].Out := Out_R    ; 
 OpProcTab[ID_oLBIf].Out := Out_oLBIf; 
 OpProcTab[ID_oLBI ].Out := Out_oLBIf; 
 OpProcTab[ID_oLB  ].Out := Out_oLBIf; 
 OpProcTab[ID_oLIf ].Out := Out_oLBIf; 
 OpProcTab[ID_oL   ].Out := Out_oLBIf; 
 OpProcTab[ID_o    ].Out := Out_oLBIf; 
 OpProcTab[ID_oBIf ].Out := Out_oLBIf; 
 OpProcTab[ID_oBI  ].Out := Out_oLBIf; 
 OpProcTab[ID_oB   ].Out := Out_oLBIf; 
 OpProcTab[ID_oIf  ].Out := Out_oLBIf; 
 OpProcTab[ID_LBIf ].Out := Out_oLBIf; 
 OpProcTab[ID_LBI  ].Out := Out_oLBIf; 
 OpProcTab[ID_LB   ].Out := Out_oLBIf; 
 OpProcTab[ID_LIf  ].Out := Out_oLBIf; 
 OpProcTab[ID_L    ].Out := Out_oLBIf; 
 OpProcTab[ID_BIf  ].Out := Out_oLBIf; 
 OpProcTab[ID_BI   ].Out := Out_oLBIf; 
 OpProcTab[ID_B    ].Out := Out_oLBIf; 
 OpProcTab[ID_If   ].Out := Out_oLBIf; 
END InitOperands;

(************************************************************************************************************************)
PROCEDURE NewOper(oper:ASMOP.tOper);
BEGIN (* NewOper *) 
 IF NofOpersInBuf=MaxNofDelayedOperations THEN 
    OutOper(OperationBuf[OperHeadIdx]); 
    OperHeadIdx:=(OperHeadIdx+1) MOD MaxNofDelayedOperations; 
 ELSE 
    INC(NofOpersInBuf); 
 END; (* IF *)

 OperTailIdx:=(OperTailIdx+1) MOD MaxNofDelayedOperations; 
 opern:=SYSTEM.VAL(topern,SYSTEM.ADR(OperationBuf[OperTailIdx])); 
 
 INC(LastOperId); 
  opern^.operId    := LastOperId; 
  opern^.obsolete  := FALSE; 
  opern^.operation := oper; 
  opern^.comment   := ''; 
END NewOper;

PROCEDURE NewOp(odi:tOpID);
BEGIN (* NewOp *) 
 opn           := SYSTEM.VAL(tOp,SYSTEM.ADR(OpBuf[nextFreeOpIdx])); 
 opn^          := EmptyOp^; 
 opn^.ID       := odi;
 nextFreeOpIdx := (nextFreeOpIdx+1) MOD MaxNofOpBufs; 
END NewOp;

PROCEDURE InitOperandBuffers;
BEGIN (* InitOperandBuffers *) 
 NEW(EmptyOp); 
 EmptyOp^.ID     := ID_; 
 EmptyOp^.int    := 0; 
 EmptyOp^.label  := NIL; 
 EmptyOp^.reg    := ConsBase.RegNil; 
 EmptyOp^.ireg   := ConsBase.RegNil; 
 EmptyOp^.factor := 1; 

 nextFreeOpIdx:=0; 
END InitOperandBuffers;
                        
(************************************************************************************************************************)
(*** operand constructors                                                                                             ***)
(************************************************************************************************************************)
PROCEDURE S*(s:ARRAY OF CHAR):tOp; 
BEGIN 
 NewOp(ID_S); opn^.str:=STR.Alloc(s); RETURN opn; 
END S;

PROCEDURE i*(v:LONGINT):tOp; 
BEGIN 
 NewOp(ID_i); opn^.int:=v; RETURN opn; 
END i;

PROCEDURE x*(v:LONGINT):tOp; 
BEGIN 
 NewOp(ID_x); opn^.crd:=v; RETURN opn; 
END x;

PROCEDURE iL*(l:tLabel):tOp; 
BEGIN 
 NewOp(ID_iL); opn^.label:=l; RETURN opn; 
END iL;

PROCEDURE ioL*(o:LONGINT;l:tLabel):tOp; 
BEGIN 
 NewOp(ID_ioL); opn^.int:=o; opn^.label:=l; RETURN opn; 
END ioL;

PROCEDURE R*(r:tReg):tOp; 
BEGIN 
 NewOp(ID_R); opn^.reg:=r; RETURN opn; 
END R;

PROCEDURE oLBIf*(o:LONGINT;l:tLabel;br,ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_oLBIf); opn^.int:=o; opn^.label:=l; opn^.reg:=br; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END oLBIf;

PROCEDURE oLBI*(o:LONGINT;l:tLabel;br,ir:tReg):tOp; 
BEGIN 
 NewOp(ID_oLBI); opn^.int:=o; opn^.label:=l; opn^.reg:=br; opn^.ireg:=ir; RETURN opn; 
END oLBI;

PROCEDURE oLB*(o:LONGINT;l:tLabel;br:tReg):tOp; 
BEGIN 
 NewOp(ID_oLB); opn^.int:=o; opn^.label:=l; opn^.reg:=br; RETURN opn; 
END oLB;

PROCEDURE oLIf*(o:LONGINT;l:tLabel;ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_oLIf); opn^.int:=o; opn^.label:=l; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END oLIf;

PROCEDURE oL*(o:LONGINT;l:tLabel):tOp; 
BEGIN 
 NewOp(ID_oL); opn^.int:=o; opn^.label:=l; RETURN opn; 
END oL;

PROCEDURE o*(o:LONGINT):tOp; 
BEGIN 
 NewOp(ID_o); opn^.int:=o; RETURN opn; 
END o;

PROCEDURE oBIf*(o:LONGINT; br,ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_oBIf); opn^.int:=o; opn^.reg:=br; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END oBIf;

PROCEDURE oBI*(o:LONGINT; br,ir:tReg):tOp; 
BEGIN 
 NewOp(ID_oBI); opn^.int:=o; opn^.reg:=br; opn^.ireg:=ir; RETURN opn; 
END oBI;

PROCEDURE oB*(o:LONGINT; br:tReg):tOp; 
BEGIN 
 NewOp(ID_oB); opn^.int:=o; opn^.reg:=br; RETURN opn; 
END oB;

PROCEDURE oIf*(o:LONGINT; ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_oIf); opn^.int:=o; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END oIf;

PROCEDURE LBIf*(l:tLabel;br,ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_LBIf); opn^.label:=l; opn^.reg:=br; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END LBIf;

PROCEDURE LBI*(l:tLabel;br,ir:tReg):tOp; 
BEGIN 
 NewOp(ID_LBI); opn^.label:=l; opn^.reg:=br; opn^.ireg:=ir; RETURN opn; 
END LBI;

PROCEDURE LB*(l:tLabel;br:tReg):tOp; 
BEGIN 
 NewOp(ID_LB); opn^.label:=l; opn^.reg:=br; RETURN opn; 
END LB;

PROCEDURE LIf*(l:tLabel;ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_LIf); opn^.label:=l; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END LIf;

PROCEDURE L*(l:tLabel):tOp; 
BEGIN 
 NewOp(ID_L); opn^.label:=l; RETURN opn; 
END L;

PROCEDURE BIf*(br,ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_BIf); opn^.reg:=br; opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END BIf;

PROCEDURE BI*(br,ir:tReg):tOp; 
BEGIN 
 NewOp(ID_BI); opn^.reg:=br; opn^.ireg:=ir; RETURN opn; 
END BI;

PROCEDURE B*(br:tReg):tOp; 
BEGIN 
 NewOp(ID_B); opn^.reg:=br; RETURN opn; 
END B;

PROCEDURE If*(ir:tReg;f:LONGINT):tOp; 
BEGIN 
 NewOp(ID_If); opn^.ireg:=ir; opn^.factor:=f; RETURN opn; 
END If;

PROCEDURE^MultR(reg:tReg; VAR factor:LONGINT); 

(************************************************************************************************************************)
PROCEDURE Loc*(VAR loc:tLocation):tOp;
VAR op:tOp;
BEGIN (* Loc *)
 MultR(loc.ireg,loc.factor); 
 op:=oLBIf(loc.ofs,loc.label,loc.breg,loc.ireg,loc.factor); 
 IF ARG.OptionCommentsInAsm & (loc.cmtIdent#Idents.NoIdent) THEN nextOperCmtIdent:=loc.cmtIdent; END; (* IF *)
 RETURN op; 
END Loc;

(************************************************************************************************************************)
PROCEDURE Operand*(VAR oper:tOperand):tOp;
BEGIN (* Operand *)
 CASE oper.kind OF
 |okImmediate: RETURN i(oper.val); 
 |okRegister : RETURN R(oper.reg); 
 |okMemory   : RETURN Loc(oper.loc); 
 ELSE          ERR.Fatal('ASM.Operand: CASE fault'); 
 END; (* CASE *)
END Operand;

PROCEDURE^CS2*(oper:ASMOP.tOper; s:tSize; op1,op2:tOp);

(************************************************************************************************************************)
PROCEDURE Variable*(VAR v:tVariable):tOp; 
VAR op:tOp;
BEGIN (* Variable *)
 IF    v.label#LAB.MT THEN op:=oL(v.ofs,v.label); 
 ELSIF v.frame=0      THEN op:=oB(v.ofs,ebp); 
                      ELSE CS2( ASMOP.mov,l  ,  oB(v.frame,ebp),R(v.tmpreg) ); 
                           op:=oB(v.ofs,v.tmpreg); 
 END; (* IF *)
 IF ARG.OptionCommentsInAsm & (v.cmtIdent#Idents.NoIdent) THEN nextOperCmtIdent:=v.cmtIdent; END; (* IF *)
 RETURN op; 
END Variable;

(************************************************************************************************************************)
PROCEDURE Dup*(op:tOp):tOp; 
BEGIN (* Dup *)
 NewOp(op^.ID); 
 opn^:=op^; 
 RETURN opn; 
END Dup;

(************************************************************************************************************************)
PROCEDURE AddOfs*(op:tOp; ofs:LONGINT):tOp;
BEGIN (* AddOfs *)
 NewOp(op^.ID); 
 opn^:=op^;                         
 INC(opn^.int,ofs); 
 RETURN opn; 
END AddOfs;

(************************************************************************************************************************)
PROCEDURE OutCh(c:CHAR);
BEGIN (* OutCh *) 
 IF OutputIdx<OutputBufMaxSize THEN 
    OutputBuf[OutputIdx]:=c; INC(OutputIdx); 
 END; (* IF *)
END OutCh;

(************************************************************************************************************************)
PROCEDURE OutS(s:ARRAY OF CHAR);
VAR i:LONGINT; 
BEGIN (* OutS *) 
 FOR i:=0 TO LEN(s) DO
  IF (s[i]=0X) OR (OutputIdx>=OutputBufMaxSize) THEN RETURN; END; (* IF *)
  OutputBuf[OutputIdx]:=s[i]; INC(OutputIdx); 
 END; (* FOR *)
END OutS;

(************************************************************************************************************************)
PROCEDURE OutI(i:LONGINT);
VAR buf:ARRAY 51 OF CHAR; dst:LONGINT; 
BEGIN (* OutI *) 
 IF i=MIN(LONGINT) THEN buf:='-2147483648'; OutS(buf); RETURN; END; (* IF *)
 
 IF i<0 THEN 
    IF OutputIdx<OutputBufMaxSize THEN OutputBuf[OutputIdx]:='-'; INC(OutputIdx); END; (* IF *)
    i:=ABS(i); 
 END; (* IF *)
 
 dst:=0; 
 REPEAT
  buf[dst]:=CHR(48+(i MOD 10)); i:=i DIV 10; INC(dst); 
 UNTIL i=0;                                         

 WHILE (dst>0) & (OutputIdx<OutputBufMaxSize) DO
  DEC(dst); 
  OutputBuf[OutputIdx]:=buf[dst]; INC(OutputIdx); 
 END; (* WHILE *)
END OutI;

(************************************************************************************************************************)
PROCEDURE OutX(v:LONGINT);
VAR i:LONGINT; w:LONGINT; 
BEGIN (* OutX *) 
 IF OutputIdx+8>=OutputBufMaxSize THEN RETURN; END; (* IF *)
 
 FOR i:=OutputIdx+7 TO OutputIdx BY -1 DO
  w:=v MOD 16; v:=v DIV 16; 
  IF w>9 THEN INC(w,39); END; (* IF *)
  OutputBuf[i]:=CHR(48+w); 
 END; (* FOR *)         
 INC(OutputIdx,8); 
END OutX;

(************************************************************************************************************************)
PROCEDURE OutR(r:tReg);
BEGIN (* OutR *) 
 OutS(RegStrTab[r]); 
END OutR;

(************************************************************************************************************************)
PROCEDURE OutOper(VAR oper:tOperationBuf);

 PROCEDURE OutCmt;
 VAR i:LONGINT; s:STR.tStr;
 BEGIN (* OutCmt *)
  IF (oper.comment[0]='-') & (oper.comment[1]='-') THEN 
     OutCh('#'); OutS(oper.comment); 
  ELSE                            
     i:=0; 
     WHILE oper.comment[i]=CHR(9) DO OutCh(CHR(9)); INC(i); END; (* WHILE *)
     s:=SYSTEM.VAL(STR.tStr,SYSTEM.ADR(oper.comment[i])); 
     OutS('# '); OutS(s^); 
  END; (* IF *)
 END OutCmt;

BEGIN (* OutOper *) 
 OutputIdx:=0; 

 IF ARG.OptionCommentsInAsm THEN 
    IF oper.obsolete THEN OutCh('#'); END; (* IF *)
    CASE oper.operation OF
    |ASMOP.NoOper: 
       IF oper.comment[0]#0X THEN OutCmt; END; (* IF *)
    |ASMOP.label: 
       OpProcTab[oper.operand1^.ID].Out(oper.operand1^); OutCh(':'); 
       IF oper.comment[0]#0X THEN OutCh(CHR(9)); OutCmt; END; (* IF *)
    |ASMOP.labelDef: 
       OpProcTab[oper.operand1^.ID].Out(oper.operand1^); OutCh('='); 
       OutCh(CHR(9)); 
       OpProcTab[oper.operand2^.ID].Out(oper.operand2^); 
       IF oper.comment[0]#0X THEN OutCh(CHR(9)); OutCmt; END; (* IF *)
    ELSE
       OutCh(CHR(9)); 
       OutS(ASMOP.OperStrTab[oper.operation]); 
       IF oper.size#NoSize THEN OutCh(SizeStrTab[oper.size]); END; (* IF *)
   
       IF (oper.operand1^.ID#ID_) OR (oper.comment[0]#0X) THEN 
          OutCh(CHR(9)); 
       END; (* IF *)
       
       OpProcTab[oper.operand1^.ID].Out(oper.operand1^); 
       IF oper.operand2^.ID#ID_ THEN OutCh(','); OpProcTab[oper.operand2^.ID].Out(oper.operand2^); END; (* IF *)
       IF oper.operand3^.ID#ID_ THEN OutCh(','); OpProcTab[oper.operand3^.ID].Out(oper.operand3^); END; (* IF *)
       IF oper.comment[0]#0X   THEN OutCh(CHR(9)); OutCmt; END; (* IF *)
    END; (* CASE *)
 ELSE 
    IF oper.obsolete THEN RETURN; END; (* IF *)
    CASE oper.operation OF
    |ASMOP.NoOper: RETURN; 
    |ASMOP.label: 
       OpProcTab[oper.operand1^.ID].Out(oper.operand1^); OutCh(':'); 
    |ASMOP.labelDef: 
       OpProcTab[oper.operand1^.ID].Out(oper.operand1^); OutCh('='); 
       OpProcTab[oper.operand2^.ID].Out(oper.operand2^); 
    ELSE
       OutS(ASMOP.OperStrTab[oper.operation]); 
       IF oper.size#NoSize THEN OutCh(SizeStrTab[oper.size]); END; (* IF *)
   
       IF oper.operand1^.ID#ID_ THEN OutCh(' '); END; (* IF *)
       
       OpProcTab[oper.operand1^.ID].Out(oper.operand1^); 
       IF oper.operand2^.ID#ID_ THEN OutCh(','); OpProcTab[oper.operand2^.ID].Out(oper.operand2^); END; (* IF *)
       IF oper.operand3^.ID#ID_ THEN OutCh(','); OpProcTab[oper.operand3^.ID].Out(oper.operand3^); END; (* IF *)
    END; (* CASE *)
 END; (* IF *)
 
 OutputBuf[OutputIdx]:=CHR(10); INC(OutputIdx); 
 OutputBuf[OutputIdx]:=0X; 
 TextIO.PutString(OutputFile,OutputBuf); 
END OutOper;

PROCEDURE^CmtS*(s:ARRAY OF CHAR); 
PROCEDURE^CmtId*(id:Idents.tIdent); 

(************************************************************************************************************************)
PROCEDURE OperCmtId;
BEGIN (* OperCmtId *)
 IF nextOperCmtIdent#Idents.NoIdent THEN 
    CmtId(nextOperCmtIdent); nextOperCmtIdent:=Idents.NoIdent; 
    CmtS(' '); 
 END; (* IF *)
END OperCmtId;

(************************************************************************************************************************)
PROCEDURE Ln*;
BEGIN (* Ln *)
 NewOper(ASMOP.NoOper); 
 opern^.size     := NoSize; 
 opern^.operand1 := EmptyOp; 
 opern^.operand2 := EmptyOp; 
 opern^.operand3 := EmptyOp; 
END Ln;

(************************************************************************************************************************)
PROCEDURE C0*(oper:ASMOP.tOper);
BEGIN (* C0 *) 
 NewOper(oper); 
 opern^.size     := NoSize; 
 opern^.operand1 := EmptyOp; 
 opern^.operand2 := EmptyOp; 
 opern^.operand3 := EmptyOp; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)

 CASE oper OF
 |cld: IF is_cld THEN opern^.obsolete:=TRUE; ELSE is_cld:=TRUE; END; (* IF *)
 ELSE 
 END; (* CASE *)
END C0;

(************************************************************************************************************************)
PROCEDURE CS0*(oper:ASMOP.tOper; s:tSize);
BEGIN (* CS0 *) 
 NewOper(oper); 
 opern^.size     := s; 
 opern^.operand1 := EmptyOp; 
 opern^.operand2 := EmptyOp; 
 opern^.operand3 := EmptyOp; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)
END CS0;

PROCEDURE^HasEqualLabels(op1,op2:tOp):BOOLEAN; 

(************************************************************************************************************************)
PROCEDURE C1*(oper:ASMOP.tOper; op:tOp);
BEGIN (* C1 *) 
 CASE oper OF
 |ASMOP.label: 
    IF op^.label=LAB.MT THEN RETURN; END; (* IF *)
     IF (OperationBuf[OperTailIdx].operation=jmp) 
        & HasEqualLabels(OperationBuf[OperTailIdx].operand1,op) THEN OperationBuf[OperTailIdx].obsolete:=TRUE; END; (* IF *)
    is_cld:=FALSE; 
 |call:
    is_cld:=FALSE; 
 ELSE 
 END; (* CASE *)
 
 NewOper(oper); 
 opern^.size     := NoSize; 
 opern^.operand1 := op; 
 opern^.operand2 := EmptyOp; 
 opern^.operand3 := EmptyOp; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)
END C1;

(************************************************************************************************************************)
PROCEDURE CS1*(oper:ASMOP.tOper; s:tSize; op:tOp);
BEGIN (* CS1 *) 
 NewOper(oper); 
 opern^.size     := s; 
 opern^.operand1 := op; 
 opern^.operand2 := EmptyOp; 
 opern^.operand3 := EmptyOp; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)
END CS1;

(************************************************************************************************************************)
PROCEDURE C2*(oper:ASMOP.tOper; op1,op2:tOp);
BEGIN (* C2 *) 
 NewOper(oper); 
 opern^.size     := NoSize; 
 opern^.operand1 := op1; 
 opern^.operand2 := op2; 
 opern^.operand3 := EmptyOp; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)
END C2;

PROCEDURE^MultConstToReg(factor:LONGINT; reg:tReg):BOOLEAN; 

(************************************************************************************************************************)
PROCEDURE CS2*(oper:ASMOP.tOper; s:tSize; op1,op2:tOp);
VAR obsolete:BOOLEAN; 
BEGIN (* CS2 *) 
 obsolete:=FALSE; 
 CASE oper OF
 |ASMOP.imul:
    IF (op1^.ID=ID_i) & (op2^.ID=ID_R) & MultConstToReg(op1^.int,op2^.reg) THEN obsolete:=TRUE; END;
 |ASMOP.add:
    IF op1^.ID=ID_i THEN 
       IF    op1^.int=-1 THEN oper:=ASMOP.dec; op1:=op2; op2:=EmptyOp; 
       ELSIF op1^.int= 0 THEN obsolete:=TRUE; 
       ELSIF op1^.int= 1 THEN oper:=ASMOP.inc; op1:=op2; op2:=EmptyOp; 
       END; (* IF *)
    END; (* IF *)
 |ASMOP.sub:
    IF op1^.ID=ID_i THEN 
       IF    op1^.int=-1 THEN oper:=ASMOP.inc; op1:=op2; op2:=EmptyOp; 
       ELSIF op1^.int= 0 THEN obsolete:=TRUE; 
       ELSIF op1^.int= 1 THEN oper:=ASMOP.dec; op1:=op2; op2:=EmptyOp; 
       END; (* IF *)
    END; (* IF *)
 ELSE 
 END; (* CASE *)

 NewOper(oper); 
 opern^.obsolete := obsolete; 
 opern^.size     := s; 
 opern^.operand1 := op1; 
 opern^.operand2 := op2; 
 opern^.operand3 := EmptyOp; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)
END CS2;

PROCEDURE^MultConstAndOpToReg(factor:LONGINT; op:tOp; reg:tReg):BOOLEAN; 

(************************************************************************************************************************)
PROCEDURE CS3*(oper:ASMOP.tOper; s:tSize; op1,op2,op3:tOp);
BEGIN (* CS3 *) 
 CASE oper OF
 |imul:
    IF (op1^.ID=ID_i) & (op3^.ID=ID_R) & MultConstAndOpToReg(op1^.int,op2,op3^.reg) THEN RETURN; END; (* IF *)
 ELSE 
 END; (* CASE *)

 NewOper(oper); 
 opern^.size     := s; 
 opern^.operand1 := op1; 
 opern^.operand2 := op2; 
 opern^.operand3 := op3; 
 IF ARG.OptionCommentsInAsm THEN OperCmtId; END; (* IF *)
END CS3;

(************************************************************************************************************************)
PROCEDURE Comm*(l:tLabel; v:LONGINT); 
BEGIN (* Comm *)
 C2( comm , L(l) , o(v) );
END Comm;

(************************************************************************************************************************)
PROCEDURE Align*(a:LONGINT);
BEGIN (* Align *)
 IF curSection=DataSection THEN 
    C1( align , o(a) ); 
 ELSE 
    C2( align , o(a),o(90H) ); 
 END; (* IF *)
END Align;

(************************************************************************************************************************)
PROCEDURE Data*;
BEGIN (* Data *)
 IF curSection=DataSection THEN RETURN; END; (* IF *)
 
 C0( data ); 
 curSection:=DataSection; 
END Data;

(************************************************************************************************************************)
PROCEDURE Text*;
BEGIN (* Text *)
 IF curSection=TextSection THEN RETURN; END; (* IF *)

 C0( text ); 
 curSection:=TextSection; 
END Text;

(************************************************************************************************************************)
PROCEDURE Asciz*(s:ARRAY OF CHAR); 
BEGIN (* Asciz *)
 C1( asciz , S(s) ); 
END Asciz;

(************************************************************************************************************************)
PROCEDURE ByteI*(i:LONGINT); 
BEGIN (* ByteI *)
 C1( byte , o(i) ); 
END ByteI;

(************************************************************************************************************************)
PROCEDURE LongI*(i:LONGINT); 
BEGIN (* LongI *)
 C1( long , o(i) ); 
END LongI;

(************************************************************************************************************************)
PROCEDURE LongI2*(i,j:LONGINT); 
BEGIN (* LongI2 *)
 C2( long , o(i) , o(j) ); 
END LongI2;

(************************************************************************************************************************)
PROCEDURE LongL*(l:tLabel); 
BEGIN (* LongL *)
 C1( long , L(l) ); 
END LongL;

(************************************************************************************************************************)
PROCEDURE Globl*(l:tLabel); 
BEGIN (* Globl *)
 C1( globl , L(l) ); 
END Globl;

(************************************************************************************************************************)
PROCEDURE Label*(l:tLabel); 
BEGIN (* Label *)
 C1( ASMOP.label , L(l) ); 
END Label;

(************************************************************************************************************************)
PROCEDURE GLabel*(l:tLabel); 
BEGIN (* GLabel *)
 C1( globl       , L(l) ); 
 C1( ASMOP.label , L(l) ); 
END GLabel;

(************************************************************************************************************************)
PROCEDURE LabelDef*(l:tLabel; v:LONGINT); 
BEGIN (* LabelDef *)
 C2( ASMOP.labelDef , L(l),o(v) ); 
END LabelDef;

PROCEDURE^CmtR*(r:tReg); 

(************************************************************************************************************************)
PROCEDURE RegCopy*(src,dst:tReg);
VAR sz,dz:tSize; tmp:tReg;

 PROCEDURE Cmt;
 BEGIN (* Cmt *)
  CmtR(src); CmtS(' --> '); CmtR(dst); 
 END Cmt;

 PROCEDURE Nop;
 BEGIN (* Nop *)
  IF ARG.OptionCommentsInAsm THEN Ln; CmtS('	'); Cmt; END;
 END Nop;

BEGIN (* RegCopy *)
 IF src=dst THEN Nop; RETURN; END;

 sz:=RegSizeTab[src]; dz:=RegSizeTab[dst]; 
 IF sz=dz THEN CS2                  ( mov,sz  ,  R(src),R(dst)                 ); Cmt; RETURN; END;
                                                                 
 IF sz<dz THEN                                                   
    IF SizedRegTab[dst,sz]=src THEN                              
       IF (dz=w) & ((src=al) OR (src=bl) OR (src=cl) OR (src=dl)) THEN                                              
          CASE src OF                                            
          |al: CS2                  ( xor,b   ,  R(ah),R(ah)                   );
          |bl: CS2                  ( xor,b   ,  R(bh),R(bh)                   );
          |cl: CS2                  ( xor,b   ,  R(ch),R(ch)                   );
          |dl: CS2                  ( xor,b   ,  R(dh),R(dh)                   );
          END;
       ELSIF sz=b THEN CS2          ( and,dz  ,  x(0FFH),R(dst)                );
                  ELSE CS2          ( and,l   ,  x(0FFFFH),R(dst)              );
       END;
    ELSE 
       IF    (sz=b) & (dz=w) THEN C2( movzbw  ,  R(src),R(dst)                 ); 
       ELSIF (sz=b) & (dz=l) THEN C2( movzbl  ,  R(src),R(dst)                 ); 
                             ELSE C2( movzwl  ,  R(src),R(dst)                 ); 
       END;
    END;

 ELSE 
    IF SizedRegTab[src,dz]=dst THEN 
       Nop; RETURN; 
    ELSIF (dz=b) & ((src=si) OR (src=di) OR (src=esi) OR (src=edi)) THEN
       IF (dst=al) OR (dst=ah) THEN tmp:=ebx; ELSE tmp:=eax; END;
       IF ARG.OptionCommentsInAsm THEN Ln; END;
       CS2                          ( xchg,l  ,  R(SizedRegTab[src,l]),R(tmp)  );
       CS2                          ( mov,dz  ,  R(SizedRegTab[tmp,dz]),R(dst) );
       CS2                          ( xchg,l  ,  R(tmp),R(SizedRegTab[src,l])  );
    ELSE
       CS2                          ( mov,dz  ,  R(SizedRegTab[src,dz]),R(dst) );
    END;
 END;

 IF ARG.OptionCommentsInAsm THEN Cmt; END;
END RegCopy;

(************************************************************************************************************************)
PROCEDURE MemCopy*(src,dst:tOp; tmp:tReg; size:LONGINT; isStringCopy:BOOLEAN);
VAR ii:LONGINT; 
BEGIN (* MemCopy *)
 IF size<=0 THEN RETURN; END;
 
 IF size<=LIM.MaxNofBytesToUseRegdMemCopy THEN 

    FOR ii:=1 TO size DIV 4 DO
     CS2     ( mov,l  ,  src,R(tmp)                ); src:=AddOfs(src,4); 
     CS2     ( mov,l  ,  R(tmp),dst                ); dst:=AddOfs(dst,4); 
    END;                                          
                                                  
    IF (size MOD 4)>1 THEN                        
       CS2   ( mov,w  ,  src,R(SizedRegTab[tmp,w]) ); src:=AddOfs(src,2); 
       CS2   ( mov,w  ,  R(SizedRegTab[tmp,w]),dst ); dst:=AddOfs(dst,2); 
    END;                                          
                                                  
    IF (size MOD 2)>0 THEN                        
       IF isStringCopy THEN                       
          CS2( mov,b  ,  i(0),dst                  ); 
       ELSE                                       
          CS2( mov,b  ,  src,R(SizedRegTab[tmp,b]) ); 
          CS2( mov,b  ,  R(SizedRegTab[tmp,b]),dst ); 
       END;
    END; 
 ELSE 
    CS2      ( lea,l  ,  dst,R(edi)                ); 
    CS2      ( lea,l  ,  src,R(esi)                ); 

    CS2      ( mov,l  ,  i(size DIV 4),R(ecx)      ); 
    C0       ( cld                                 ); 
    C0       ( repz                                ); 
    CS0      ( movs,l                              ); 
    IF (size MOD 4)>1 THEN                         
       CS0   ( movs,w                              ); 
    END;                                           
    IF (size MOD 2)>0 THEN                         
       IF isStringCopy THEN                        
          CS2( mov,b  ,  i(0),R(edi)               ); 
       ELSE                                        
          CS0( movs,b                              ); 
       END;
    END;
 END;
END MemCopy;

(************************************************************************************************************************)
PROCEDURE FillZ*(dst:tOp; tmp:tReg; size:LONGINT);
VAR ii:LONGINT; 
BEGIN (* FillZ *)
 IF size<=0 THEN RETURN; END;

 CASE size OF
 |1: CS2                           ( mov,b   ,  i(0),dst                  ); 
 |2: CS2                           ( mov,w   ,  i(0),dst                  ); 
 |3: CS2                           ( mov,w   ,  i(0),dst                  ); dst:=AddOfs(dst,2); 
     CS2                           ( mov,b   ,  i(0),dst                  ); 
 |4: CS2                           ( mov,l   ,  i(0),dst                  ); 
 |5..LIM.MaxNofBytesToUseRegdMemCopy:                                     
     CS2                           ( xor,l   ,  R(tmp),R(tmp)             ); 
     FOR ii:=1 TO size DIV 4 DO CS2( mov,l   ,  R(tmp),dst                ); dst:=AddOfs(dst,4); END; 
     IF (size MOD 4)>1 THEN CS2    ( mov,w   ,  R(SizedRegTab[tmp,w]),dst ); dst:=AddOfs(dst,2); END;
     IF (size MOD 2)>0 THEN CS2    ( mov,b   ,  R(SizedRegTab[tmp,b]),dst ); END;                    
 ELSE
     IF tmp#eax THEN CS2           ( xchg,l  ,  R(tmp),R(eax)             ); END;
     CS2                           ( xor,l   ,  R(eax),R(eax)             ); 
     CS2                           ( lea,l   ,  dst,R(edi)                ); 
     CS2                           ( mov,l   ,  i(size DIV 4),R(ecx)      ); 
     C0                            ( cld                                  ); 
     C0                            ( repz                                 ); 
     CS0                           ( stos,l                               ); 
     IF (size MOD 4)>1 THEN CS0    ( stos,w                               ); END;                                            
     IF (size MOD 2)>0 THEN CS0    ( stos,b                               ); END;
     IF tmp#eax THEN CS2           ( xchg,l  ,  R(tmp),R(eax)             ); END;
 END;
END FillZ;

(************************************************************************************************************************)
PROCEDURE ConstStringCompare*(VAR str:OT.oSTRING; reg:tReg); 
VAR string:Strings.tString; arr:ARRAY Strings.cMaxStrLength+1 OF CHAR; ii,len:LONGINT; label:LAB.T;
BEGIN (* ConstStringCompare *)       
 StringMem.GetString(str,string); Strings.StringToArray(string,arr); 
 
 len:=STR.Length(arr); label:=LAB.NewLocal(); 
 FOR ii:=0 TO len-1 DO
  CS2( cmp,b  ,  i(ORD(arr[ii])),oB(ii,reg) ); 
  C1 ( jnz    ,  L(label)                   );
 END;
 CS2 ( cmp,b  ,  i(0),oB(len,reg)           ); 
 Label(label); 
END ConstStringCompare;

PROCEDURE^CmtI*(i:LONGINT); 

(************************************************************************************************************************)
PROCEDURE CmtFactor(reg:tReg; f:LONGINT);
BEGIN (* CmtFactor *)
 CmtR(reg); CmtS(':='); CmtI(f); CmtS('*'); CmtR(reg); CmtS('; ');  
END CmtFactor;

(************************************************************************************************************************)
PROCEDURE MultConstToReg(factor:LONGINT; reg:tReg):BOOLEAN; 
VAR sz:tSize; f,shift:LONGINT; 
BEGIN (* MultConstToReg *)
 sz:=RegSizeTab[reg]; f:=ABS(factor); 

 IF factor=0 THEN
    CS2        ( xor,sz  ,  R(reg),R(reg)         ); 
 ELSIF f=1 THEN 

 ELSIF (sz=l) & (f<10) & (f IN {2,3,4,5,8,9}) THEN 
    CASE factor OF
    |2,4,8: CS2( lea,sz  ,  If(reg,f),R(reg)      ); 
    |3    : CS2( lea,sz  ,  BIf(reg,reg,2),R(reg) ); 
    |5    : CS2( lea,sz  ,  BIf(reg,reg,4),R(reg) ); 
    |9    : CS2( lea,sz  ,  BIf(reg,reg,8),R(reg) ); 
    ELSE    ERR.Fatal('ASM.MultConstToReg: CASE failed'); 
    END; (* CASE *)
 ELSIF ADR.IntLog2(f,shift) THEN 
    CS2        ( shl,sz   ,  i(shift),R(reg)      ); 
 ELSE 
    RETURN FALSE; 
 END; (* IF *)

 IF factor<0 THEN 
    CS1        ( neg,sz  ,  R(reg)                ); 
 END; (* IF *)
   
 IF ARG.OptionCommentsInAsm THEN CmtFactor(reg,factor); END; (* IF *)
 RETURN TRUE; 
END MultConstToReg;

PROCEDURE^CmtOp*(op:tOp);

(************************************************************************************************************************)
PROCEDURE MultConstAndOpToReg(factor:LONGINT; op:tOp; reg:tReg):BOOLEAN; 
VAR sz:tSize; f,shift:LONGINT; 
BEGIN (* MultConstAndOpToReg *)
 sz:=RegSizeTab[reg]; f:=ABS(factor); 
 IF factor=0 THEN
    CS2        ( xor,sz   ,  R(reg),R(reg)         ); 
 ELSIF f=1 THEN 
    CS2        ( mov,sz   ,  op,R(reg)             ); 
 ELSIF (sz=l) & (f<10) & (f IN {2,3,4,5,8,9}) THEN 
    CS2        ( mov,sz   ,  op,R(reg)             ); 
    CASE factor OF
    |2,4,8: CS2( lea,sz   ,  If(reg,f),R(reg)      ); 
    |3    : CS2( lea,sz   ,  BIf(reg,reg,2),R(reg) ); 
    |5    : CS2( lea,sz   ,  BIf(reg,reg,4),R(reg) ); 
    |9    : CS2( lea,sz   ,  BIf(reg,reg,8),R(reg) ); 
    ELSE    ERR.Fatal('ASM.MultConstAndOpToReg: CASE failed'); 
    END; (* CASE *)
 ELSIF ADR.IntLog2(f,shift) THEN 
    CS2        ( mov,sz   ,  op,R(reg)             ); 
    CS2        ( shl,sz   ,  i(shift),R(reg)       ); 
 ELSE  
    RETURN FALSE; 
 END; (* IF *)

 IF factor<0 THEN 
    CS1        ( neg,sz   ,  R(reg)                ); 
 END; (* IF *)

 IF ARG.OptionCommentsInAsm THEN CmtR(reg); CmtS(':='); CmtI(factor); CmtS(' * '); CmtOp(op); CmtS('; '); END; (* IF *)
 RETURN TRUE; 
END MultConstAndOpToReg;

(************************************************************************************************************************)
PROCEDURE MultR(reg:tReg; VAR factor:LONGINT); 
VAR leaFactor,shift:LONGINT; 
BEGIN (* MultR *)
 CASE factor OF
 |0            : CS2   ( xor,l   ,  R(reg),R(reg)       ); 
 |1,2,4,8      : RETURN; 
 |3,3*2,3*4,3*8: leaFactor:=(3-1); factor:=factor DIV 3; 
 |5,5*2,5*4,5*8: leaFactor:=(5-1); factor:=factor DIV 5; 
 |9,9*2,9*4,9*8: leaFactor:=(9-1); factor:=factor DIV 9; 
 ELSE      	 IF ADR.IntLog2(factor,shift) THEN
                    CS2( shl,l   ,  i(shift),R(reg)  ); 
                    IF ARG.OptionCommentsInAsm THEN CmtFactor(reg,factor); END; (* IF *)
                 ELSE 
                    CS2( imul,l  ,  i(factor),R(reg) ); 
                 END; (* IF *)	
                 factor:=1; RETURN; 
 END; (* CASE *)

 CS2                   ( lea,l  ,  BIf(reg,reg,leaFactor),R(reg) ); 
 IF ARG.OptionCommentsInAsm THEN CmtFactor(reg,leaFactor+1); END; (* IF *)
END MultR;

(************************************************************************************************************************)
PROCEDURE HasEqualLabels(op1,op2:tOp):BOOLEAN; 
BEGIN (* HasEqualLabels *) 
 RETURN (op1^.ID=ID_L) & (op2^.ID=ID_L) & Strings1.StrEq(op1^.label^,op2^.label^); 
END HasEqualLabels;

(************************************************************************************************************************)
PROCEDURE GetLastOperId*(VAR oid:tOperId); 
BEGIN (* GetLastOperId *)
 oid.id  := opern^.operId; 
 oid.adr := opern; 
END GetLastOperId;

(************************************************************************************************************************)
PROCEDURE MakeObsolete*(VAR oid:tOperId); 
TYPE t=POINTER TO tOperationBuf; VAR p:t;
BEGIN (* MakeObsolete *)
 p:=SYSTEM.VAL(t,oid.adr); 
 IF p^.operId=oid.id THEN 
    p^.obsolete:=TRUE; 
 END; (* IF *)
END MakeObsolete;

(************************************************************************************************************************)
(*** comments                                                                                                         ***)
(************************************************************************************************************************)
PROCEDURE CmtLnS*(s:ARRAY OF CHAR); 
BEGIN (* CmtLnS *)
 Ln; 
 CmtS(s); 
END CmtLnS;

(************************************************************************************************************************)
PROCEDURE CmtS*(s:ARRAY OF CHAR); 
BEGIN (* CmtS *) 
 STR.Append(OperationBuf[OperTailIdx].comment,s); 
END CmtS;

(************************************************************************************************************************)
PROCEDURE CmtI*(i:LONGINT); 
VAR s:ARRAY 51 OF CHAR; 
BEGIN (* CmtI *) 
 UTI.Longint2Arr(i,s); CmtS(s); 
END CmtI;

(************************************************************************************************************************)
PROCEDURE CmtId*(id:Idents.tIdent); 
VAR str:Strings.tString; s:ARRAY Strings.cMaxStrLength+2 OF CHAR; 
BEGIN (* CmtId *) 
 Idents.GetString(id,str); Strings.StringToArray(str,s); CmtS(s); 
END CmtId;

(************************************************************************************************************************)
PROCEDURE CmtR*(r:tReg); 
BEGIN (* CmtR *)
 CmtS(RegStrTab[r]); 
END CmtR;

(************************************************************************************************************************)
PROCEDURE CmtOp*(op:tOp);
BEGIN (* CmtOp *)
 IF op^.int#0 THEN 
    CmtI(op^.int); 
 ELSIF (op^.label=NIL) & (op^.reg=ConsBase.RegNil) & (op^.ireg=ConsBase.RegNil) THEN
    CmtS('0'); RETURN; 
 END; (* IF *)
 
 IF op^.label#NIL THEN 
    IF op^.int#0 THEN CmtS('+'); END; (* IF *)
    CmtS(op^.label^); 
 END; (* IF *)          
 
 IF (op^.reg#ConsBase.RegNil) OR (op^.ireg#ConsBase.RegNil) THEN 
    CmtS('('); 
    IF (op^.reg=ConsBase.RegNil) & (op^.factor=1) THEN 
       CmtR(op^.ireg); 
    ELSE 
       IF op^.reg#ConsBase.RegNil THEN CmtR(op^.reg); END; (* IF *)
       IF op^.ireg#ConsBase.RegNil THEN 
          CmtS(','); CmtR(op^.ireg); 
          IF op^.factor>1 THEN CmtS(','); CmtI(op^.factor); END; (* IF *)
       END; (* IF *)
    END; (* IF *)
    CmtS(')'); 
 END; (* IF *)
END CmtOp;

(************************************************************************************************************************)
PROCEDURE SepLine*;
BEGIN (* SepLine *)
 CmtLnS('------------------------------------------------------------------------------'); 
END SepLine;

PROCEDURE^FlushBuffer;

(************************************************************************************************************************)
PROCEDURE WrLn*;
BEGIN (* WrLn *)
 FlushBuffer;
 TextIO.PutLn(OutputFile); 
END WrLn;

(************************************************************************************************************************)
PROCEDURE WrS*(s:ARRAY OF CHAR); 
BEGIN (* WrS *)
 FlushBuffer;
 TextIO.PutString(OutputFile,s); 
END WrS;

(************************************************************************************************************************)
PROCEDURE WrI*(i:LONGINT);
VAR s:ARRAY 31 OF CHAR; 
BEGIN (* WrI *)
 UTI.Longint2Arr(i,s); WrS(s); 
END WrI;

(************************************************************************************************************************)
PROCEDURE WrId*(id:Idents.tIdent); 
VAR str:Strings.tString; s:ARRAY Strings.cMaxStrLength+2 OF CHAR; 
BEGIN (* WrId *)
 Idents.GetString(id,str); Strings.StringToArray(str,s); WrS(s); 
END WrId;

(************************************************************************************************************************)
(*** root actions                                                                                                     ***)
(************************************************************************************************************************)
PROCEDURE Begin*(outFile:TextIO.File);
BEGIN (* Begin *) 
 OutputFile    := outFile; 
 NofOpersInBuf := 0; 
 OperHeadIdx   := 0; 
 OperTailIdx   := MaxNofDelayedOperations-1; 
 nextFreeOpIdx := 0; 
 curSection    := NoSection; 
 is_cld        := FALSE; 
 LastOperId    := 0; 
END Begin;

(************************************************************************************************************************)
PROCEDURE FlushBuffer;
BEGIN (* FlushBuffer *)
 WHILE NofOpersInBuf>0 DO
  OutOper(OperationBuf[OperHeadIdx]); 
  OperHeadIdx:=(OperHeadIdx+1) MOD MaxNofDelayedOperations; 
  DEC(NofOpersInBuf); 
 END; (* WHILE *)  
 is_cld:=FALSE; 
END FlushBuffer;

(************************************************************************************************************************)
PROCEDURE End*;
BEGIN (* End *) 
 FlushBuffer;
END End;

(************************************************************************************************************************)
BEGIN (* ASM *) 
 InitOperands;
 InitOperandBuffers;
 
 FOR reg:=MIN(tReg) TO MAX(tReg) DO 
  LoRegTab[reg]:=NoReg; HiRegTab[reg]:=NoReg; 
  RegSizeTab[reg]:=NoSize; RegStrTab[reg]:='%reg'; 
 END;
 
 RegStrTab[al ] := '%al'   ; RegSizeTab[al ] := b; 
 RegStrTab[ah ] := '%ah'   ; RegSizeTab[ah ] := b; 
 RegStrTab[bl ] := '%bl'   ; RegSizeTab[bl ] := b; 
 RegStrTab[bh ] := '%bh'   ; RegSizeTab[bh ] := b; 
 RegStrTab[cl ] := '%cl'   ; RegSizeTab[cl ] := b; 
 RegStrTab[ch ] := '%ch'   ; RegSizeTab[ch ] := b; 
 RegStrTab[dl ] := '%dl'   ; RegSizeTab[dl ] := b; 
 RegStrTab[dh ] := '%dh'   ; RegSizeTab[dh ] := b; 
 RegStrTab[ax ] := '%ax'   ; RegSizeTab[ax ] := w; LoRegTab[ax ] := al; HiRegTab[ax ] := ah; 
 RegStrTab[bx ] := '%bx'   ; RegSizeTab[bx ] := w; LoRegTab[bx ] := bl; HiRegTab[bx ] := bh; 
 RegStrTab[cx ] := '%cx'   ; RegSizeTab[cx ] := w; LoRegTab[cx ] := cl; HiRegTab[cx ] := ch; 
 RegStrTab[dx ] := '%dx'   ; RegSizeTab[dx ] := w; LoRegTab[dx ] := dl; HiRegTab[dx ] := dh; 
 RegStrTab[si ] := '%si'   ; RegSizeTab[si ] := w; 			                    
 RegStrTab[di ] := '%di'   ; RegSizeTab[di ] := w; 			                    
 RegStrTab[eax] := '%eax'  ; RegSizeTab[eax] := l; LoRegTab[eax] := ax;
 RegStrTab[ebx] := '%ebx'  ; RegSizeTab[ebx] := l; LoRegTab[ebx] := bx;
 RegStrTab[ecx] := '%ecx'  ; RegSizeTab[ecx] := l; LoRegTab[ecx] := cx;
 RegStrTab[edx] := '%edx'  ; RegSizeTab[edx] := l; LoRegTab[edx] := dx;
 RegStrTab[esi] := '%esi'  ; RegSizeTab[esi] := l; LoRegTab[esi] := si;
 RegStrTab[edi] := '%edi'  ; RegSizeTab[edi] := l; LoRegTab[edi] := di;
 RegStrTab[ebp] := '%ebp'  ; RegSizeTab[ebp] := l; 
 RegStrTab[esp] := '%esp'  ; RegSizeTab[esp] := l; 
 RegStrTab[st ] := '%st'   ;                       
 RegStrTab[st1] := '%st(1)';                       
 RegStrTab[st2] := '%st(2)';                       
 RegStrTab[st3] := '%st(3)';                       
 RegStrTab[st4] := '%st(4)';                       
 RegStrTab[st5] := '%st(5)';                       
 RegStrTab[st6] := '%st(6)';                       
 RegStrTab[st7] := '%st(7)';                       
 						   
 CodeRegTab[codeEAX   ] := eax  ; 		   
 CodeRegTab[codeEBX   ] := ebx  ; 
 CodeRegTab[codeECX   ] := ecx  ; 
 CodeRegTab[codeEDX   ] := edx  ; 
 CodeRegTab[codeESI   ] := esi  ; 
 CodeRegTab[codeEDI   ] := edi  ; 
 CodeRegTab[codeEBP   ] := ebp  ; 
 CodeRegTab[codeESP   ] := esp  ; 
 CodeRegTab[codeEFLAGS] := NoReg; 
 CodeRegTab[codeST0   ] := st   ; 
 CodeRegTab[codeST1   ] := st1  ; 
 CodeRegTab[codeST2   ] := st2  ; 
 CodeRegTab[codeST3   ] := st3  ; 
 CodeRegTab[codeST4   ] := st4  ; 
 CodeRegTab[codeST5   ] := st5  ; 
 CodeRegTab[codeST6   ] := st6  ; 
 CodeRegTab[codeST7   ] := st7  ; 

 mtLocation.label    := LAB.MT; 
 mtLocation.ofs      := 0; 
 mtLocation.breg     := NoReg; 
 mtLocation.ireg     := NoReg; 
 mtLocation.factor   := 1; 
 mtLocation.cmtIdent := Idents.NoIdent; 

 SizeTab[0] := NoSize; 
 SizeTab[1] := b; 
 SizeTab[2] := w; 
 SizeTab[3] := NoSize; 
 SizeTab[4] := l; 

 FloatSizeTab[0] := NoSize; 
 FloatSizeTab[1] := NoSize; 
 FloatSizeTab[2] := NoSize; 
 FloatSizeTab[3] := NoSize; 
 FloatSizeTab[4] := s; 
 FloatSizeTab[5] := NoSize; 
 FloatSizeTab[6] := NoSize; 
 FloatSizeTab[7] := NoSize; 
 FloatSizeTab[8] := l; 

 SizeStrTab[NoSize] := ' '; 
 SizeStrTab[b     ] := 'b'; 
 SizeStrTab[w     ] := 'w'; 
 SizeStrTab[l     ] := 'l'; 
 SizeStrTab[s     ] := 's'; 
 
 BitSizeTab[b     ] := 8; 
 BitSizeTab[w     ] := 16; 
 BitSizeTab[l     ] := 32; 
 
 ByteSizeTab[b     ] := 1; 
 ByteSizeTab[w     ] := 2; 
 ByteSizeTab[l     ] := 4; 
 
 FloatByteSizeTab[s] := 4; 
 FloatByteSizeTab[l] := 8; 
 
 FOR reg:=MIN(tReg) TO MAX(tReg) DO 
  SizedRegTab[reg,b]:=NoReg; SizedRegTab[reg,w]:=NoReg; SizedRegTab[reg,l]:=NoReg; 
 END;

 SizedRegTab[al ,b]:=al   ; SizedRegTab[al ,w]:=ax; SizedRegTab[al ,l]:=eax; 
 SizedRegTab[ah ,b]:=ah   ; SizedRegTab[ah ,w]:=ax; SizedRegTab[ah ,l]:=eax; 
 SizedRegTab[bl ,b]:=bl   ; SizedRegTab[bl ,w]:=bx; SizedRegTab[bl ,l]:=ebx; 
 SizedRegTab[bh ,b]:=bh   ; SizedRegTab[bh ,w]:=bx; SizedRegTab[bh ,l]:=ebx; 
 SizedRegTab[cl ,b]:=cl   ; SizedRegTab[cl ,w]:=cx; SizedRegTab[cl ,l]:=ecx; 
 SizedRegTab[ch ,b]:=ch   ; SizedRegTab[ch ,w]:=cx; SizedRegTab[ch ,l]:=ecx; 
 SizedRegTab[dl ,b]:=dl   ; SizedRegTab[dl ,w]:=dx; SizedRegTab[dl ,l]:=edx; 
 SizedRegTab[dh ,b]:=dh   ; SizedRegTab[dh ,w]:=dx; SizedRegTab[dh ,l]:=edx; 
 SizedRegTab[ax ,b]:=al   ; SizedRegTab[ax ,w]:=ax; SizedRegTab[ax ,l]:=eax; 
 SizedRegTab[bx ,b]:=bl   ; SizedRegTab[bx ,w]:=bx; SizedRegTab[bx ,l]:=ebx; 
 SizedRegTab[cx ,b]:=cl   ; SizedRegTab[cx ,w]:=cx; SizedRegTab[cx ,l]:=ecx; 
 SizedRegTab[dx ,b]:=dl   ; SizedRegTab[dx ,w]:=dx; SizedRegTab[dx ,l]:=edx; 
                            SizedRegTab[si ,w]:=si; SizedRegTab[si ,l]:=esi; 
                            SizedRegTab[di ,w]:=di; SizedRegTab[di ,l]:=edi; 
 SizedRegTab[eax,b]:=al   ; SizedRegTab[eax,w]:=ax; SizedRegTab[eax,l]:=eax; 
 SizedRegTab[ebx,b]:=bl   ; SizedRegTab[ebx,w]:=bx; SizedRegTab[ebx,l]:=ebx; 
 SizedRegTab[ecx,b]:=cl   ; SizedRegTab[ecx,w]:=cx; SizedRegTab[ecx,l]:=ecx; 
 SizedRegTab[edx,b]:=dl   ; SizedRegTab[edx,w]:=dx; SizedRegTab[edx,l]:=edx; 
                            SizedRegTab[esi,w]:=si; SizedRegTab[esi,l]:=esi; 
                            SizedRegTab[edi,w]:=di; SizedRegTab[edi,l]:=edi; 
 
 BranchOperTab [NoRelation    ,0] := ASMOP.NoOper; BranchOperTab [NoRelation    ,1] := ASMOP.NoOper; 
 BranchOperTab [equal         ,0] := ASMOP.jz    ; BranchOperTab [equal         ,1] := ASMOP.jz    ; 
 BranchOperTab [unequal       ,0] := ASMOP.jnz   ; BranchOperTab [unequal       ,1] := ASMOP.jnz   ; 
 BranchOperTab [less          ,0] := ASMOP.jb    ; BranchOperTab [less          ,1] := ASMOP.jl    ; 
 BranchOperTab [lessORequal   ,0] := ASMOP.jbe   ; BranchOperTab [lessORequal   ,1] := ASMOP.jle   ; 
 BranchOperTab [greater       ,0] := ASMOP.ja    ; BranchOperTab [greater       ,1] := ASMOP.jg    ; 
 BranchOperTab [greaterORequal,0] := ASMOP.jae   ; BranchOperTab [greaterORequal,1] := ASMOP.jge   ; 

 FlagSetOperTab[NoRelation    ,0] := ASMOP.NoOper; FlagSetOperTab[NoRelation    ,1] := ASMOP.NoOper;
 FlagSetOperTab[equal         ,0] := ASMOP.setz  ; FlagSetOperTab[equal         ,1] := ASMOP.setz  ;
 FlagSetOperTab[unequal       ,0] := ASMOP.setnz ; FlagSetOperTab[unequal       ,1] := ASMOP.setnz ;
 FlagSetOperTab[less          ,0] := ASMOP.setb  ; FlagSetOperTab[less          ,1] := ASMOP.setl  ;
 FlagSetOperTab[lessORequal   ,0] := ASMOP.setbe ; FlagSetOperTab[lessORequal   ,1] := ASMOP.setle ;
 FlagSetOperTab[greater       ,0] := ASMOP.seta  ; FlagSetOperTab[greater       ,1] := ASMOP.setg  ;
 FlagSetOperTab[greaterORequal,0] := ASMOP.setae ; FlagSetOperTab[greaterORequal,1] := ASMOP.setge ;

 InvRelTab[NoRelation    ] := NoRelation    ; 
 InvRelTab[equal         ] := unequal       ; 
 InvRelTab[unequal       ] := equal         ; 
 InvRelTab[less          ] := greaterORequal; 
 InvRelTab[lessORequal   ] := greater       ; 
 InvRelTab[greater       ] := lessORequal   ; 
 InvRelTab[greaterORequal] := less          ; 
 
 RevRelTab[NoRelation    ] := NoRelation    ; 
 RevRelTab[equal         ] := equal         ; 
 RevRelTab[unequal       ] := unequal       ; 
 RevRelTab[less          ] := greater       ; 
 RevRelTab[lessORequal   ] := greaterORequal; 
 RevRelTab[greater       ] := less          ; 
 RevRelTab[greaterORequal] := lessORequal   ; 
 
 OutputFile:=0; nextOperCmtIdent:=Idents.NoIdent; 
END ASM.

