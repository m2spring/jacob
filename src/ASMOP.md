DEFINITION MODULE ASMOP;
(*
 * ASeMbler OPerations: Provides the coding of the assembler operations (opcodes) and attributes of the opcodes.
 *)

(*$1*)
TYPE  tOper          = (NoOper
                       ,asciz,byte,long,comm,align,data,text,globl,label,labelDef
                       ,nop,add,and,bound,bt,btr,bts,call,cbw,cdq,cld,cwd,cwde,cmp,cmpsb,dec,enter,idiv,imul,inc
                       ,jmp,jcxz,jecxz
                       ,ja   ,jae   ,jb   ,jbe   ,jc   ,je   ,jg   ,jge   ,jl   ,jle   ,jo   ,jp   ,js   ,jz
                       ,jna  ,jnae  ,jnb  ,jnbe  ,jnc  ,jne  ,jng  ,jnge  ,jnl  ,jnle  ,jno  ,jnp  ,jns  ,jnz
                       ,seta ,setae ,setb ,setbe ,setc ,sete ,setg ,setge ,setl ,setle ,seto ,setp ,sets ,setz
                       ,setna,setnae,setnb,setnbe,setnc,setne,setng,setnge,setnl,setnle,setno,setnp,setns,setnz
                       ,lea,leave,lods,loop,loopnz,mov,movs,movsbw,movsbl,movswl,movzbl,movzbw,movzwl,neg,not
                       ,or,popl,pushl,popf,pushf,repz,ret,sahf,stos,sub,test,xor,xchg
                       ,rcl,rcr,rol,ror,sal,sar,shl,shr,shld,shrd
                     
                       ,fstsw,fdecstp,fincstp,fxch
                       ,fld,fild
                       ,fst ,fist ,fadd ,fmul ,fdiv ,fdivr ,fsub ,fsubr
                       ,fstp,fistp,faddp,fmulp,fdivp,fdivrp,fsubp,fsubrp
                       ,fiadd,fimul,ficomp,fisub,fisubr,fidiv,fidivr
                       ,fcomp,fcompp,fabs,fchs
                       );
(*$1*)
VAR   InvDirTab      : ARRAY tOper OF tOper;                (* {rc,ro,sa,sh}l <--> {rc,ro,sa,sh}r , shld <--> shrd      *)
(*$*)
      InvBranchTab   : ARRAY tOper OF tOper;                (* e.g. ja <--> jna                                         *)
(*$*)
      IsRotateOper   : ARRAY tOper OF BOOLEAN;              (* true for rcl,rcr,rol,ror                                 *)
(*$*)
      OperStrTab     : ARRAY tOper,[0..7] OF CHAR;          (* textual representation of an opcode                      *)

(*$1*)
CONST FirstFOP       = fstsw;
(*$*)
      LastFOP        = fchs;
(*$1*)
TYPE  FOPRange       = [FirstFOP..LastFOP];
(*$1*)
VAR   PopFloatTab    : ARRAY FOPRange OF tOper;             (* e.g. fadd --> faddp; if no "_p" exists: identity         *)
(*$*)
      UnpopFloatTab  : ARRAY FOPRange OF tOper;             (* UnpopFloatTab(PopFloatTab(x))=x                          *)
(*$*)
      RevFloatTab    : ARRAY FOPRange OF tOper;             (* e.g. fsub <--> fsubr; else identity                      *)
(*$*)
      IntFloatTab    : ARRAY FOPRange OF tOper;             (* e.g. fadd --> fiadd; else identity                       *)
(*$*)
      FloatChangeTab : ARRAY FOPRange OF LONGINT;           (* diff number of ndp elems; e.g. faddp --> -1              *)
(*$*)
      FloatDyOpTab   : ARRAY FOPRange OF BOOLEAN;           (* true for op-codes with two ndp elem operands; e.g. faddp *)

END ASMOP.
