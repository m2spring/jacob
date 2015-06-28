MODULE Target;
IMPORT ASMOP,Storage,ADR, ARG, ASM, BasicIO, CV, FIL, LAB, O, TextIO, STR, SysLib, SYSTEM;

CONST 
   al=ASM.al;
   ah=ASM.ah;
   bl=ASM.bl;
   bh=ASM.bh;
   cl=ASM.cl;
   ch=ASM.ch;
   dl=ASM.dl;
   dh=ASM.dh;
   ax=ASM.ax;
   bx=ASM.bx;
   cx=ASM.cx;
   dx=ASM.dx;
   si=ASM.si;
   di=ASM.di;
   eax=ASM.eax;
   ebx=ASM.ebx;
   ecx=ASM.ecx;
   edx=ASM.edx;
   esi=ASM.esi;
   edi=ASM.edi;
   ebp=ASM.ebp;
   esp=ASM.esp;
   b=ASM.b;
   w=ASM.w;
   l=ASM.l;

   add=ASMOP.add;
   and=ASMOP.and;
   call=ASMOP.call;
   cld=ASMOP.cld;
   imul=ASMOP.imul;
   jmp=ASMOP.jmp;
   lea=ASMOP.lea;
   leave=ASMOP.leave;
   mov=ASMOP.mov;
   movs=ASMOP.movs;
   popl=ASMOP.popl;
   pushl=ASMOP.pushl;
   repz=ASMOP.repz;
   ret=ASMOP.ret;
   shl=ASMOP.shl;
   shr=ASMOP.shr;
   sub=ASMOP.sub;

CONST MaxNameLength = 300;
TYPE  tLinkElemP    = POINTER TO tLinkElem;
      tLinkElem     = RECORD
                       dir  ,
                       name : STR.tStr;
                       next : tLinkElemP;
                      END;
VAR   linkHd,linkTl:tLinkElemP;
      fOut:TextIO.File; curDir,curModulename:ARRAY MaxNameLength+1 OF CHAR; 

(************************************************************************************************************************)
PROCEDURE BeginningOfFile(dir,name:ARRAY OF CHAR);
VAR fn:ARRAY MaxNameLength+1 OF CHAR; 
BEGIN (* BeginningOfFile *)
 STR.Copy(curDir,dir); STR.Copy(curModulename,name); 
 
 STR.Conc3(fn,dir,name,".s"); 
 TextIO.OpenOutput(fOut,fn); 
 ASM.Begin(fOut); 
END BeginningOfFile;

(************************************************************************************************************************)
PROCEDURE EndOfFile;
BEGIN (* EndOfFile *)
 ASM.End;
 TextIO.PutLn(fOut); 
 TextIO.Close(fOut); 
END EndOfFile;

(************************************************************************************************************************)
PROCEDURE Module*(dir,name:ARRAY OF CHAR; globalspace:LONGINT); 
BEGIN (* Module *)  
 BeginningOfFile(dir,name); 

 IF globalspace>=0 THEN 
    ASM.Comm(FIL.ActP^.ModuleEntry^.ModuleEntry.globalLabel,8+globalspace);
 END; (* IF *)
END Module;
             
(************************************************************************************************************************)
PROCEDURE BeginModule*(tempSpace:LONGINT; fTempLabel:LAB.T);
VAR name,nLab,dLab,iLab:LAB.T; s:ARRAY 201 OF CHAR; 
BEGIN (* BeginModule *)
 name:=STR.Alloc(curModulename); 
 nLab:=LAB.AppS(name,'$I$N'); 
 dLab:=LAB.AppS(name,'$I$D'); 
 iLab:=LAB.AppS(name,'$I'); 

 ASM.Text;
 ASM.Label(nLab); 

 STR.Concat(s,curModulename,'$I'); 
 ASM.Asciz(s);

 ASM.Align(2);
 ASM.LongL(nLab); 
 ASM.LongI(0); 
 ASM.LongL(LAB.NILPROC); 

 ASM.Label(dLab); 
 ASM.LongI(-1);
 ASM.Ln;				             
 					             
 ASM.Align(2);				             
 ASM.Globl(iLab); 			             
 ASM.Label(iLab); 			             
 ASM.C1 ( pushl  ,  ASM.R(ebp)                           );
 ASM.CS2( mov,l  ,  ASM.R(esp),ASM.R(ebp)                    );
 ASM.C1 ( pushl  ,  ASM.iL(dLab)                         );
 ASM.CS2( sub,l  ,  ASM.ioL(tempSpace,fTempLabel),ASM.R(esp) ); 
 ASM.Ln;
END BeginModule;

(************************************************************************************************************************)
PROCEDURE EndModule*(fTempLabel:LAB.T; fTempSize:LONGINT);
BEGIN (* EndModule *)
 ASM.CS2( mov,l  ,  ASM.R(ebp),ASM.R(esp) ); 
 ASM.C1 ( popl   ,  ASM.R(ebp)        );
 ASM.C0 ( ret                     ); 
 ASM.LabelDef(fTempLabel,fTempSize); 

 CV.Code;
 EndOfFile;
END EndModule;

(************************************************************************************************************************)
PROCEDURE Assemble*():BOOLEAN; 
VAR s:ARRAY 2*MaxNameLength+1 OF CHAR; ok,f:BOOLEAN; 
BEGIN (* Assemble *)
 STR.Conc4(s,ARG.AsmScript^," ",curDir,curModulename);
 ok:=(SysLib.system(SYSTEM.ADR(s))=0); 

 IF ~ARG.OptionKeepTemporaries THEN 
    STR.Conc3(s,curDir,curModulename,".s");
    BasicIO.Erase(s,f); 
 END; (* IF *)
 
 RETURN ok; 
END Assemble;

(************************************************************************************************************************)
PROCEDURE ClearLinklist*;
VAR e,d:tLinkElemP; 
BEGIN (* ClearLinklist *)
 e:=linkHd; 
 WHILE e#NIL DO
  d:=e; e:=e^.next; STR.Free(d^.name); Storage.DEALLOCATE(d,SIZE(tLinkElem)); 
 END; (* WHILE *)             
 linkHd:=NIL; linkTl:=NIL; 
END ClearLinklist;

(************************************************************************************************************************)
PROCEDURE AddToLinklist*(dir,name:ARRAY OF CHAR);
VAR e:tLinkElemP; 
BEGIN (* AddObjectToLinklist *)
 NEW(e); e^.dir:=STR.Alloc(dir); e^.name:=STR.Alloc(name); e^.next:=NIL; 

 IF linkHd=NIL THEN linkHd:=e; ELSE linkTl^.next:=e; END; (* IF *)
 linkTl:=e; 
END AddToLinklist;

(************************************************************************************************************************)
PROCEDURE GenerateRootModule*(dir,mainname:ARRAY OF CHAR):BOOLEAN;
VAR dLab,nLab,iLab:LAB.T; e:tLinkElemP;
BEGIN (* GenerateRootModule *)
 BeginningOfFile(dir,mainname); 
 
 (*** Type descriptor of the root module ***)

 IF ARG.OptionCommentsInAsm THEN 
    ASM.SepLine; ASM.CmtLnS('TDesc of root init proc'); 
 END; (* IF *)

 dLab:=STR.Alloc('_$I$D'); 
 nLab:=STR.Alloc('_$I$N'); 
 iLab:=STR.Alloc('_$I'); 

 ASM.Globl(dLab); 
 ASM.Text;
 ASM.Label(nLab); 
 ASM.Asciz("_$I"); 
 ASM.Ln;

 ASM.Align(2);
 ASM.LongL(nLab); 
 ASM.LongI(0); 
 ASM.LongL(LAB.NILPROC); 

 ASM.Label(dLab); 
 ASM.LongI(-1);
 ASM.Ln;

 (*** Prolog of the init proc of the root module ***)

 IF ARG.OptionCommentsInAsm THEN ASM.SepLine; ASM.CmtLnS('root init proc'); END; (* IF *)

 ASM.Globl(iLab); 
 ASM.Align(2);
 ASM.Label(iLab); 
 ASM.C1 ( pushl  ,  ASM.R(ebp)        ); 
 ASM.C1 ( pushl  ,  ASM.i(0)          ); 
 ASM.CS2( mov,l  ,  ASM.R(esp),ASM.R(ebp) );
 ASM.C1 ( pushl  ,  ASM.iL(dLab)      ); 
 ASM.Ln;

 (*** Initialization of the type descriptors for the globals of all modules ***)

 IF ARG.OptionCommentsInAsm THEN ASM.CmtLnS('	Initialize the global TDescs of all modules'); END; (* IF *)

 e:=linkHd; 
 WHILE e#NIL DO
  ASM.CS2( mov,l  ,  ASM.iL(STR.AppS(e^.name,'$D')),ASM.L(STR.AppS(e^.name,'$G')) ); 
  e:=e^.next; 
 END; (* WHILE *)
 ASM.Ln;

 (*** Linkage of the global sections of all modules ***)

 IF ARG.OptionCommentsInAsm THEN ASM.CmtLnS('	Link the globals of all modules'); END; (* IF *)

 e:=linkHd; 
 ASM.CS2( mov,l  ,  ASM.R(ebp),ASM.oL(4,STR.AppS(e^.name,'$G')) ); 
 WHILE e^.next#NIL DO
  ASM.CS2( mov,l  ,  ASM.ioL(4,STR.AppS(e^.name,'$G')),ASM.oL(4,STR.AppS(e^.next^.name,'$G')) ); 
  e:=e^.next; 
 END; (* WHILE *)
 ASM.CS2( lea,l  ,  ASM.oL(4,STR.AppS(e^.name,'$G')),ASM.R(ebp) ); 
 ASM.Ln;

 (*** Invocation of the init procs of all modules ***)

 IF ARG.OptionCommentsInAsm THEN ASM.CmtLnS('	Call the module init procs'); END; (* IF *)

 e:=linkHd; 
 WHILE e#NIL DO
  ASM.C1( call  ,  ASM.L(STR.AppS(e^.name,'$I')) ); 
  e:=e^.next; 
 END; (* WHILE *)
 ASM.Ln;
 
 (*** Epilog of the init proc of the root module ***)

 ASM.CS2( add,l  ,  ASM.i(8),ASM.R(esp) ); 
 ASM.C1 ( popl   ,  ASM.R(ebp)      );
 ASM.C0 ( ret                   );
 ASM.Ln;

 (*** FirstModuleTDesc ***)

 IF ARG.OptionCommentsInAsm THEN ASM.SepLine; END; (* IF *)

 ASM.GLabel(LAB.FirstModuleTDesc); 
 ASM.LongL(STR.AppS(linkTl^.name,'$D')); 
 
 EndOfFile;

 RETURN Assemble();
END GenerateRootModule;

(************************************************************************************************************************)
PROCEDURE Link*(dir,mainname:ARRAY OF CHAR):BOOLEAN; 
VAR e:tLinkElemP; dirLen,cmdLen:LONGINT; cmd:POINTER TO ARRAY 100000 OF CHAR; 
    rootname:ARRAY MaxNameLength+1 OF CHAR; OK,f:BOOLEAN; 
BEGIN (* Link *)          
 IF linkHd=NIL THEN RETURN FALSE; END; (* IF *)
 
 STR.Concat(rootname,'_',mainname); 
 IF ~GenerateRootModule(dir,rootname) THEN RETURN FALSE; END; (* IF *)

 (*** Calculation of the length of the link script call ***)
 (* e.g. "oc.linker dir/main dir/_main.o "                          *)

 dirLen:=STR.Length(dir);               
 cmdLen:=STR.Length(ARG.LinkScript^)+1   
        +dirLen+STR.Length(mainname)+1      
        +dirLen+STR.Length(rootname)+3; 
 
 e:=linkHd; 
 WHILE e#NIL DO
  INC(cmdLen,STR.Length(e^.dir^)+STR.Length(e^.name^)+3); 
  e:=e^.next; 
 END; (* WHILE *)

 INC(cmdLen,2); 
 Storage.ALLOCATE(cmd,cmdLen); 
 STR.Conc7(cmd^,ARG.LinkScript^," ",mainname," ",dir,rootname,".o "); 
 e:=linkHd; 
 WHILE e#NIL DO STR.App3(cmd^,e^.dir^,e^.name^,".o "); e:=e^.next; END; (* WHILE *)

 OK:=(SysLib.system(SYSTEM.VAL(LONGINT,cmd))=0); 

 IF ~ARG.OptionKeepTemporaries THEN 
    STR.Conc3(cmd^,dir,rootname,".o"); 
    BasicIO.Erase(cmd^,f); 
 END; (* IF *)

 Storage.DEALLOCATE(cmd,cmdLen); 
 RETURN OK; 
END Link;

(************************************************************************************************************************)
BEGIN (* Target *)
 fOut:=0; linkHd:=NIL; linkTl:=NIL; 
END Target.

