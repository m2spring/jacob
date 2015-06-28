DEFINITION MODULE ASM;
(*
 * Provides the assembler sub-system.
 *)

IMPORT ASMOP, Cons, Idents, OT, STR, TextIO, SYSTEM;

(************************************************************************************************************************)
(*
 * registers
 *)
TYPE  tReg=Cons.BegRegister;
CONST NoReg=Cons.RegNil;
      al=Cons.Regal; ah=Cons.Regah; bl=Cons.Regbl; bh=Cons.Regbh; cl=Cons.Regcl; ch=Cons.Regch; dl=Cons.Regdl; 
      dh=Cons.Regdh; ax=Cons.Regax; bx=Cons.Regbx; cx=Cons.Regcx; dx=Cons.Regdx; si=Cons.Regsi; di=Cons.Regdi; 
      eax=Cons.Regeax; ebx=Cons.Regebx; ecx=Cons.Regecx; edx=Cons.Regedx; esi=Cons.Regesi; edi=Cons.Regedi; 
      ebp=Cons.Regebp; esp=Cons.Regesp; st=Cons.Regst; st1=Cons.Regst1; 
      st2=Cons.Regst2; st3=Cons.Regst3; st4=Cons.Regst4; st5=Cons.Regst5; st6=Cons.Regst6; st7=Cons.Regst7;
VAR   RegStrTab   : ARRAY tReg,[0..6] OF CHAR;
      LoRegTab    ,
      HiRegTab    : ARRAY tReg OF tReg;
     
(*
 * Codings for module SYSTEM
 *)
 
CONST codeEAX         = 0;
      codeEBX         = 1;
      codeECX         = 2;
      codeEDX         = 3;
      codeESI         = 4;
      codeEDI         = 5;
      codeEBP         = 6;
      codeESP         = 7;
      codeEFLAGS      = 8;
      codeST0         = 9;
      codeST1         = 10;
      codeST2         = 11;
      codeST3         = 12;
      codeST4         = 13;
      codeST5         = 14;
      codeST6         = 15;
      codeST7         = 16;
TYPE  CodeRegTabRange = [codeEAX..codeST7];
VAR   CodeRegTab      : ARRAY CodeRegTabRange OF tReg;
      
CONST codeCF          = 00001H; (* Carry Flag             *)
      codePF          = 00004H; (* Parity Flag            *)
      codeAF          = 00010H; (* Auxiliary carry Flag   *)
      codeZF          = 00040H; (* Zero Flag              *)
      codeSF          = 00080H; (* Sign Flag              *)
      codeTF          = 00100H; (* Trap Flag              *)
      codeIF          = 00200H; (* Interrupt enable Flag  *)
      codeDF          = 00400H; (* Direction Flag         *)
      codeOF          = 00800H; (* Overflow Flag          *)
      codeNT          = 04000H; (* Nested Task flag       *)
      codeRF          = 10000H; (* Resume Flag            *)
      codeVM          = 20000H; (* Virtual 8086 Mode flag *)
      codeAC          = 40000H; (* Alignment Check flag   *)

(************************************************************************************************************************)
(*
 * sizes
 *)		
 
TYPE  tSize            = Cons.tSize;
CONST NoSize           = Cons.NoSize;
      b                = Cons.b;
      w                = Cons.w;
      l                = Cons.l;
      s                = Cons.s;
VAR   SizeTab          : ARRAY [0..4] OF tSize;	                                    (* number of bytes --> tSize        *)
      FloatSizeTab     : ARRAY [0..8] OF tSize;                                     (* 4 --> s, 8 --> l                 *)
      SizeStrTab       : ARRAY tSize OF CHAR;                                       (* <tSize> --> '<tSize>'            *)
      RegSizeTab       : ARRAY tReg OF tSize;                                       (* tSize of register                *)
      BitSizeTab       : ARRAY [b..l] OF LONGINT;                                   (* tSize --> number of bits         *)
      ByteSizeTab      : ARRAY [b..l] OF LONGINT;                                   (* tSize --> number of bytes        *)
      FloatByteSizeTab : ARRAY [l..s] OF LONGINT;                                   (* s --> 4, l --> 8                 *)
      SizedRegTab      : ARRAY tReg,[b..l] OF tReg;                                 (* tReg x tSize --> tReg with tSize *)

(************************************************************************************************************************)
(*
 * operands
 *)
TYPE tOp;
     tLabel     = STR.tStr;
     tLocation  = RECORD
                   label    : tLabel;
                   ofs      : LONGINT; 
                   breg     ,
                   ireg     : tReg;
                   factor   : LONGINT; 
                   cmtIdent : Idents.tIdent;
                  END; 
VAR  mtLocation : tLocation;
     EmptyOp    : tOp;
     
PROCEDURE IsBaseAdrmode(VAR loc:tLocation):BOOLEAN; 
(*
 * Yields TRUE, if 'loc' specifies a base addressing mode (without offset).
 *)

TYPE tOperKind  = (okImmediate,okRegister,okMemory);
     tOperand   = RECORD
                   CASE kind:tOperKind OF
                   |okImmediate: val:LONGINT; 
                   |okRegister : reg:tReg;
                   |okMemory   : loc:tLocation;
                   END;
                  END;     

TYPE tVariable  = RECORD
                   label    : tLabel;
                   frame    ,
                   ofs      : LONGINT; 
                   tmpreg   : tReg;
                   cmtIdent : Idents.tIdent;
                   log2     : LONGINT; (* dirty trick! *)
                  END;
(*
 * label#MT           <==> global variable      at <label>+<ofs>
 * label=MT & frame=0 <==> local variable       at <ofs>(ebp)
 * label=MT & frame#0 <==> outer local variable at <ofs>(<frame>(ebp))
 *)
 
PROCEDURE AreEqualVariables(VAR v1,v2:tVariable):BOOLEAN; 

(************************************************************************************************************************)
(*
 * relations
 *)
 
TYPE  tRelation      = Cons.tRelation;
CONST NoRelation     = Cons.NoRelation;
      equal          = Cons.equal;
      unequal        = Cons.unequal;
      less           = Cons.less;
      lessORequal    = Cons.lessORequal;
      greater        = Cons.greater;
      greaterORequal = Cons.greaterORequal;
VAR   BranchOperTab  ,                                                                    (* e.g. "<",unsigned --> jb   *)
      FlagSetOperTab : ARRAY tRelation,(*isSignedRelation:*)BOOLEAN OF ASMOP.tOper;       (* e.g. ">",signed   --> setg *)
      InvRelTab      ,				                         (* for negation.            e.g. ">=" --> "<"  *)
      RevRelTab      : ARRAY tRelation OF tRelation;                     (* for exchanging operands. e.g. ">=" --> "<=" *)

(************************************************************************************************************************)
(*
 * Operand constructors
 *
 * An operand constructor can consist of the following items:
 * S = string value s             --> "<string s>"
 * i = immediate signed value i   --> $<decimal repr of i>
 * x = immediate unsigned value x --> $0x<hexadecimal repr of x>
 * R = register
 * o = decimal signed offset
 * L = label
 * B = base register
 * I = index register
 * f = scale factor (2,4,8)
 *)

PROCEDURE S    (s:ARRAY OF CHAR                           ):tOp;                                (* "this \"is\" a ..."  *)
PROCEDURE i    (v:LONGINT                                 ):tOp;                                (* $1234                *)
PROCEDURE x    (v:LONGCARD                                ):tOp;                                (* $0xfedcba98          *)
PROCEDURE iL   (           l:tLabel                       ):tOp;                                (* $label               *)
PROCEDURE ioL  (o:LONGINT; l:tLabel                       ):tOp;                                (* $10+label            *)

PROCEDURE R    (                         r:tReg           ):tOp;                                (* %eax                 *)
PROCEDURE oLBIf(o:LONGINT; l:tLabel; br,ir:tReg; f:LONGINT):tOp;                                (* -20+M$G(%ebx,%eax,4) *)

PROCEDURE oLBI (o:LONGINT; l:tLabel; br,ir:tReg           ):tOp;                                (* -20+M$G(%ebx,%eax)   *)
PROCEDURE oLB  (o:LONGINT; l:tLabel; br   :tReg           ):tOp;                                (* -20+M$G(%ebx)        *)
PROCEDURE oLIf (o:LONGINT; l:tLabel;    ir:tReg; f:LONGINT):tOp;                                (* -20+M$G(,%eax,4)     *)
PROCEDURE oL   (o:LONGINT; l:tLabel                       ):tOp;                                (* -20+M$G              *)
PROCEDURE o    (o:LONGINT                                 ):tOp;                                (* -20                  *)

PROCEDURE oBIf (o:LONGINT;           br,ir:tReg; f:LONGINT):tOp;                                (* -20(%ebp,%eax,4)     *)
PROCEDURE oBI  (o:LONGINT;           br,ir:tReg           ):tOp;                                (* -20(%ebp,%eax)       *)
PROCEDURE oB   (o:LONGINT;           br   :tReg           ):tOp;                                (* -20(%ebp)            *)
PROCEDURE oIf  (o:LONGINT;              ir:tReg; f:LONGINT):tOp;                                (* -20(,%eax,4)         *)

PROCEDURE LBIf (           l:tLabel; br,ir:tReg; f:LONGINT):tOp;                                (* const(%ebx,%eax,4)   *)
PROCEDURE LBI  (           l:tLabel; br,ir:tReg           ):tOp;                                (* const(%ebx,%eax)     *)
PROCEDURE LB   (           l:tLabel; br   :tReg           ):tOp;                                (* const(%ebx)          *)
PROCEDURE LIf  (           l:tLabel;    ir:tReg; f:LONGINT):tOp;                                (* const(,%eax,4)       *)
PROCEDURE L    (           l:tLabel                       ):tOp;                                (* const                *)

PROCEDURE BIf  (                     br,ir:tReg; f:LONGINT):tOp;                                (* (%ebx,%eax,4)        *)
PROCEDURE BI   (                     br,ir:tReg           ):tOp;                                (* (%ebx,%eax)          *)
PROCEDURE B    (                     br   :tReg           ):tOp;                                (* (%ebx)               *)
PROCEDURE If   (                        ir:tReg; f:LONGINT):tOp;                                (* (,%eax,4)            *)

(*
 * General operands
 *)

PROCEDURE Loc     (VAR loc:tLocation):tOp;
PROCEDURE Operand (VAR oper:tOperand):tOp; 
PROCEDURE Variable(VAR v:tVariable  ):tOp; 

PROCEDURE Dup(op:tOp):tOp; 
(*
 * Yields a duplication of the operand 'op'.
 *)					    
 
PROCEDURE AddOfs(op:tOp; ofs:LONGINT):tOp;
(*
 * Yields a duplication of the operand 'op' with increased offset by 'ofs'.
 *)					    

(************************************************************************************************************************)
(*
 * Simple assembler statements
 *)

PROCEDURE Ln;                                                                               (* single empty line        *)
PROCEDURE C0 (oper:ASMOP.tOper                          );                                  (* no size / no operands    *)
PROCEDURE CS0(oper:ASMOP.tOper; s:tSize                 );                                  (*    size / no operands    *)
PROCEDURE C1 (oper:ASMOP.tOper;          op         :tOp);                                  (* no size / one operand    *)
PROCEDURE CS1(oper:ASMOP.tOper; s:tSize; op         :tOp);                                  (*    size / one operand    *)
PROCEDURE C2 (oper:ASMOP.tOper;          op1,op2    :tOp);                                  (* no size / two operands   *)
PROCEDURE CS2(oper:ASMOP.tOper; s:tSize; op1,op2    :tOp);                                  (*    size / two operands   *)
PROCEDURE CS3(oper:ASMOP.tOper; s:tSize; op1,op2,op3:tOp);                                  (*    size / three operands *)

(*
 * Simple macros
 *)

PROCEDURE Comm(l:tLabel; v:LONGINT);                                                        (* .comm  l,v               *)
PROCEDURE Align(a:LONGINT);                                                                 (* .align a,0x90            *)
PROCEDURE Data;                                                                             (* .data                    *)
PROCEDURE Text;                                                                             (* .text                    *)
PROCEDURE Asciz(s:ARRAY OF CHAR);                                                           (* .asciz "s"               *)
PROCEDURE ByteI(i:LONGINT);                                                                 (* .byte  i                 *)
PROCEDURE LongI(i:LONGINT);                                                                 (* .long  i                 *)
PROCEDURE LongI2(i,j:LONGINT);                                                              (* .long  i,j               *)
PROCEDURE LongL(l:tLabel);                                                                  (* .long  l                 *)
PROCEDURE Globl(l:tLabel);                                                                  (* .globl l                 *)
PROCEDURE Label(l:tLabel);                                                                  (* l:                       *)
PROCEDURE GLabel(l:tLabel);                                                                 (* .globl l; l:             *)
PROCEDURE LabelDef(l:tLabel; v:LONGINT);                                                    (* l = v                    *)

(*
 * Complex macros
 *)

PROCEDURE RegCopy(src,dst:tReg); 
(*
 * Allows to copy any register zero extended into any other register (truncation possible).
 *)

PROCEDURE MemCopy(src,dst:tOp; size:LONGINT; isStringCopy:BOOLEAN); (* CHANGE <ecx,esi,edi> *)
(*
 * Copies 'len' bytes from address 'src' to address 'dst'.
 * If 'isStringCopy', the last byte of the destination gets 0.
 * Warning: Does not handle overlapping memory blocks.
 *)
 
PROCEDURE FillZ(dst:tOp; tmp:tReg; size:LONGINT); (* CHANGE <ecx,edi> *)
(*
 * Fills a block of 'size' bytes starting at address 'dst' with zeroes.
 * Needs a temporary register in 'tmp'.
 *)

PROCEDURE ConstStringCompare(VAR str:OT.oSTRING; reg:tReg); 
(*
 * Special coding for constant string relations.
 *)

(************************************************************************************************************************)
(*
 * Back-patching stuff
 *)
 
TYPE tOperId = RECORD                              (* "opaque" data type for identifying an emitted assember statement. *)
                id  : LONGINT; 
                adr : SYSTEM.ADDRESS; 
               END;   
               
PROCEDURE GetLastOperId(VAR oid:tOperId); 
(*
 * Yields the identifier of the last emitted statement.
 *)
 
PROCEDURE NoOperId(VAR oid:tOperId); 
(*
 * Sets 'oid' to empty.
 *)

PROCEDURE MakeObsolete(VAR oid:tOperId); 	      
(*
 * Makes the statement obsolete which could be identified by 'oid'.
 *)

(************************************************************************************************************************)
(*
 * Commenting stuff
 *)
 
PROCEDURE CmtLnS(s:ARRAY OF CHAR); 
(*
 * Starts an empty assembler statement and comments it with 's'.
 *)
 
PROCEDURE CmtS(s:ARRAY OF CHAR); 
(*
 * Appends 's' to the comment of the last emitted statement.
 *)
 
PROCEDURE CmtI(i:LONGINT); 
(*
 * Appends the decimal representation of 'i' to the comment of the last emitted statement.
 *)
 
PROCEDURE CmtId(id:Idents.tIdent); 
(*
 * Appends the textual representation of 'id' to the comment of the last emitted statement.
 *)
 
PROCEDURE CmtR(r:tReg); 
(*
 * Appends the textual representation of 'r' to the comment of the last emitted statement.
 *)
 
PROCEDURE CmtOp(op:tOp);
(*
 * Appends the textual representation of the operand 'op' to the comment of the last emitted statement.
 *)

PROCEDURE SepLine;
(*
 * Emits a separation line as comment.
 *)

(************************************************************************************************************************)
(*
 * Procedures to write directly into the assembler file.
 * The assembler statement buffer gets flushed before.
 *)
 
PROCEDURE WrLn;
(*
 * Writes a newline character.
 *)
 
PROCEDURE WrS(s:ARRAY OF CHAR); 
(*
 * Writes 's'.
 *)
 
PROCEDURE WrI(i:LONGINT); 
(*
 * Writes the decimal representation of 'i'.
 *)
 
PROCEDURE WrId(id:Idents.tIdent); 
(*
 * Writes the textual representation of 'id'.
 *)
 
PROCEDURE WrL(l:tLabel); 
(*
 * Writes the textual representation of label 'l'.
 *)
 
(************************************************************************************************************************)
(*
 * The usage of the procedures above must be parenthesized by this...
 *)

PROCEDURE Begin(outFile:TextIO.File); 
(*
 * Makes ASM aquainted with the output file.
 *)
 
PROCEDURE (* The *) End;

(************************************************************************************************************************)
END ASM.
