MODULE CODEf;








IMPORT SYSTEM, System, IO, Tree, OB,Storage,ASMOP,
        ADR,ARG,ASM,BL,CMT,E,ERR,FIL,LAB,LIM,O,STR,T;
(* line 23 "CODEf.tmp" *)

CONST al=ASM.al;ah=ASM.ah;bl=ASM.bl;bh=ASM.bh;cl=ASM.cl;ch=ASM.ch;dl=ASM.dl;
dh=ASM.dh;ax=ASM.ax;bx=ASM.bx;cx=ASM.cx;dx=ASM.dx;si=ASM.si;di=ASM.di;eax=ASM.eax;
ebx=ASM.ebx;ecx=ASM.ecx;edx=ASM.edx;esi=ASM.esi;edi=ASM.edi;ebp=ASM.ebp;esp=ASM.esp;
b=ASM.b;w=ASM.w;l=ASM.l;

CONST add=ASMOP.add;and=ASMOP.and;bts=ASMOP.bts;call=ASMOP.call;cld=ASMOP.cld;
dec=ASMOP.dec;enter=ASMOP.enter;imul=ASMOP.imul;inc=ASMOP.inc;jc=ASMOP.jc;jmp=ASMOP.jmp;
jnz=ASMOP.jnz;jz=ASMOP.jz;lea=ASMOP.lea;leave=ASMOP.leave;loop=ASMOP.loop;mov=ASMOP.mov;
movs=ASMOP.movs;nop=ASMOP.nop;or=ASMOP.or;popl=ASMOP.popl;pushl=ASMOP.pushl;
repz=ASMOP.repz;ret=ASMOP.ret;shl=ASMOP.shl;shr=ASMOP.shr;stos=ASMOP.stos;sub=ASMOP.sub;
test=ASMOP.test;xor=ASMOP.xor;

        TYPE   tLabel  = LAB.T       ;
               tOperId = ASM.tOperId ; 

VAR yyf*	: IO.tFile;
VAR Exit*	: PROCEDURE;
        TYPE   tLevel      = OB.tLevel      ;
               tAddress    = OB.tAddress    ;
               tProcTab    = POINTER TO ARRAY 100000 OF OB.tOB; 
        VAR    ProcTab     : tProcTab       ;
               ProcTabSize : LONGINT        ;
               BaseTypes   : ARRAY LIM.MaxExtensionLevel+1 OF OB.tOB;

        PROCEDURE InitProcTab(s:LONGINT); 
        VAR i:LONGINT; 
        BEGIN              
         IF s>ProcTabSize THEN 
            Storage.DEALLOCATE(ProcTab,ProcTabSize*SIZE(OB.tOB)); 
            ProcTabSize:=s; 
            Storage.ALLOCATE(ProcTab,ProcTabSize*SIZE(OB.tOB)); 
         END;
         FOR i:=0 TO ProcTabSize-1 DO ProcTab^[i]:=NIL; END;
        END InitProcTab; 

        PROCEDURE oG(ofs:LONGINT):ASM.tOp;
        BEGIN
         RETURN ASM.oL(ofs,FIL.ActP^.ModuleEntry^.ModuleEntry.globalLabel); 
        END oG; 

        PROCEDURE oGIf(ofs:LONGINT; r:ASM.tReg; f:LONGINT):ASM.tOp;
        BEGIN
         RETURN ASM.oLIf(ofs,FIL.ActP^.ModuleEntry^.ModuleEntry.globalLabel,r,f); 
        END oGIf; 

        PROCEDURE oGB(ofs:LONGINT; r:ASM.tReg):ASM.tOp;
        BEGIN
         RETURN ASM.oLB(ofs,FIL.ActP^.ModuleEntry^.ModuleEntry.globalLabel,r); 
        END oGB; 

        PROCEDURE PV(isPtr:BOOLEAN):ASM.tOp;
        BEGIN
         IF isPtr THEN RETURN ASM.i(0); 
                  ELSE RETURN ASM.iL(LAB.NILPROC); END;
        END PV; 










































































































































PROCEDURE yyAbort (yyFunction: ARRAY OF CHAR);
 BEGIN
  IO.WriteS (IO.StdError, 'Error: module CODEf, routine ');
  IO.WriteS (IO.StdError, yyFunction);
  IO.WriteS (IO.StdError, ' failed');
  IO.WriteNl (IO.StdError);
  Exit;
 END yyAbort;

PROCEDURE yyIsEqual (VAR yya, yyb: ARRAY OF SYSTEM.BYTE): BOOLEAN;
 VAR yyi:LONGINT; 
 BEGIN
  FOR yyi := 0 TO (LEN(yya)) DO
   IF SYSTEM.VAL(CHAR,yya [yyi]) # SYSTEM.VAL(CHAR,yyb [yyi]) THEN RETURN FALSE; END;
  END;
  RETURN TRUE;
 END yyIsEqual;

PROCEDURE LoadEaxWithInitVal (isPtr: BOOLEAN);
 BEGIN
(* line 76 "CODEf.tmp" *)
   LOOP
(* line 76 "CODEf.tmp" *)
      IF ~((isPtr)) THEN EXIT; END;
(* line 76 "CODEf.tmp" *)
       ASM.CS2( xor,l  ,  ASM.R(eax),ASM.R(eax)             ); ;
      RETURN;
   END;

(* line 77 "CODEf.tmp" *)
(* line 77 "CODEf.tmp" *)
       ASM.CS2( lea,l  ,  ASM.L(LAB.NILPROC),ASM.R(eax) ); ;
      RETURN;

 END LoadEaxWithInitVal;

PROCEDURE^VarInit (bl: OB.tOB; isGlobal: BOOLEAN; base: LONGINT);

PROCEDURE VarInitializing* (bl: OB.tOB; isGlobal: BOOLEAN; isPtr: BOOLEAN);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
  IF (bl^.Blocklist.prev^.Kind = OB.NoBlocklist) THEN
  IF (bl^.Blocklist.sub^.Kind = OB.NoBlocklist) THEN
(* line 84 "CODEf.tmp" *)
   LOOP
(* line 84 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count = 1)) THEN EXIT; END;
(* line 84 "CODEf.tmp" *)
      
    IF ARG.OptionCommentsInAsm THEN 
       IF isPtr THEN ASM.CmtLnS('	pointer'); ELSE ASM.CmtLnS('	proc'); END;
       ASM.CmtS(' variable init code'); 
    END;

    IF isGlobal THEN ASM.CS2( mov,l  ,  PV(isPtr),oG(bl^.Blocklist.ofs)     ); 
                ELSE ASM.CS2( mov,l  ,  PV(isPtr),ASM.oB(bl^.Blocklist.ofs,ebp) ); END;
    ASM.Ln; 
 ;
      RETURN;
   END;

  END;
  END;
(* line 95 "CODEf.tmp" *)
(* line 95 "CODEf.tmp" *)
      
    IF ARG.OptionCommentsInAsm THEN 
       IF isPtr THEN ASM.CmtLnS('	pointer'); ELSE ASM.CmtLnS('	proc'); END;
       ASM.CmtS(' variable init code'); 
    END;

    LoadEaxWithInitVal(isPtr); 
    VarInit(bl,isGlobal,0); 
    ASM.Ln;
 ;
      RETURN;

  END;
 END VarInitializing;

PROCEDURE^OpenTypeInitializing (bl: OB.tOB; isPtr: BOOLEAN);
PROCEDURE^SubVarInit (bl: OB.tOB; VAR incrOut: LONGINT);

PROCEDURE TypeInitializing (bl: OB.tOB; isPtr: BOOLEAN);
(* line 110 "CODEf.tmp" *)
 VAR incrSub,dontcare:LONGINT; lab:tLabel; tmp:ASM.tReg; 
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.NoBlocklist) THEN
(* line 112 "CODEf.tmp" *)
      RETURN;

  END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 114 "CODEf.tmp" *)
   LOOP
(* line 114 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count < 1)) THEN EXIT; END;
(* line 114 "CODEf.tmp" *)
      
    OpenTypeInitializing(bl,isPtr); 
 ;
      RETURN;
   END;

  IF (bl^.Blocklist.prev^.Kind = OB.NoBlocklist) THEN
  IF (bl^.Blocklist.sub^.Kind = OB.NoBlocklist) THEN
(* line 118 "CODEf.tmp" *)
   LOOP
(* line 118 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count = 1)) THEN EXIT; END;
(* line 118 "CODEf.tmp" *)
      
    IF isPtr THEN ASM.CS2( mov,l  ,  ASM.i(0),ASM.oB(bl^.Blocklist.ofs,edi)            ); 
             ELSE ASM.CS2( mov,l  ,  ASM.iL(LAB.NILPROC),ASM.oB(bl^.Blocklist.ofs,edi) ); END;
 ;
      RETURN;
   END;

  END;
  END;
(* line 123 "CODEf.tmp" *)
   LOOP
(* line 123 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count > 0)) THEN EXIT; END;
(* line 123 "CODEf.tmp" *)
      
    LoadEaxWithInitVal(isPtr); 
    SubVarInit(bl,dontcare); 
 ;
      RETURN;
   END;

  END;
(* line 128 "CODEf.tmp" *)
(* line 128 "CODEf.tmp" *)
       ERR.Fatal('CODEf.TypeInitializing: failed'); ;
      RETURN;

 END TypeInitializing;

PROCEDURE OpenTypeInitializing (bl: OB.tOB; isPtr: BOOLEAN);
(* line 134 "CODEf.tmp" *)
 VAR height,incrSub:LONGINT; lab:tLabel; tmp:ASM.tReg; 
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
  IF (bl^.Blocklist.prev^.Kind = OB.NoBlocklist) THEN
  IF (bl^.Blocklist.sub^.Kind = OB.Blocklist) THEN
(* line 136 "CODEf.tmp" *)
(* line 136 "CODEf.tmp" *)
      
    LoadEaxWithInitVal(isPtr); 

    height:=bl^.Blocklist.sub^.Blocklist.height+1; 
    CASE height OF 1:tmp:=ebx; | 2:tmp:=edx; | 3:tmp:=esi; ELSE tmp:=ecx; END;
    ASM.CS2                       ( mov,l   ,  ASM.B(edi),ASM.R(tmp)                          ); 
    ASM.CS2                       ( add,l   ,  ASM.i(ADR.ArrayOfsFromODim(-bl^.Blocklist.count)),ASM.R(edi) );
                                                                      
    ASM.Label(LAB.New               (lab)                                             );                                          
    IF height>3 THEN ASM.C1       ( pushl   ,  ASM.R(ecx)                                 ); END;
    SubVarInit(bl^.Blocklist.sub,incrSub);                                                          
    IF height>3 THEN ASM.C1       ( popl    ,  ASM.R(ecx)                                 ); END;

    IF bl^.Blocklist.incr-incrSub#0 THEN ASM.CS2( add,l   ,  ASM.i(bl^.Blocklist.incr-incrSub),ASM.R(edi)                 ); END;

    CASE height OF						                      
    |1,2,3: ASM.CS2               ( sub,l   ,  ASM.i(1),ASM.R(tmp)                            ); 
            ASM.C1                ( jnz     ,  ASM.L(lab)                             ); 
    ELSE    ASM.C1                ( loop    ,  ASM.L(lab)                             ); 
    END;
 ;
      RETURN;

  END;
  END;
  END;
 END OpenTypeInitializing;

PROCEDURE VarInit (bl: OB.tOB; isGlobal: BOOLEAN; base: LONGINT);
(* line 162 "CODEf.tmp" *)
 VAR ii,incrSub:LONGINT; lab:LAB.T; tmp:ASM.tReg; 
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 165 "CODEf.tmp" *)
   LOOP
(* line 165 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count = 1)) THEN EXIT; END;
(* line 165 "CODEf.tmp" *)
      
    VarInit(bl^.Blocklist.prev,isGlobal,base); 
    
    IF isGlobal THEN ASM.CS2( mov,l  ,  ASM.R(eax),oG(base+bl^.Blocklist.ofs)     ); 
                ELSE ASM.CS2( mov,l  ,  ASM.R(eax),ASM.oB(base+bl^.Blocklist.ofs,ebp) ); END;
 ;
      RETURN;
   END;

  IF (bl^.Blocklist.sub^.Kind = OB.NoBlocklist) THEN
(* line 173 "CODEf.tmp" *)
(* line 173 "CODEf.tmp" *)
      
    VarInit(bl^.Blocklist.prev,isGlobal,base); 
    
    IF bl^.Blocklist.count<=LIM.BlocklistLoopUnrollingThreshold THEN 
       FOR ii:=0 TO bl^.Blocklist.count-1 DO
        IF isGlobal THEN ASM.CS2( mov,l  ,  ASM.R(eax),oG(base+bl^.Blocklist.ofs+ii*bl^.Blocklist.incr)     ); 
                    ELSE ASM.CS2( mov,l  ,  ASM.R(eax),ASM.oB(base+bl^.Blocklist.ofs+ii*bl^.Blocklist.incr,ebp) ); END;
       END;
    ELSE 
       IF isGlobal THEN ASM.CS2 ( lea,l  ,  oG(base+bl^.Blocklist.ofs),ASM.R(edi)             ); 
                   ELSE ASM.CS2 ( lea,l  ,  ASM.oB(base+bl^.Blocklist.ofs,ebp),ASM.R(edi)         ); END;
       ASM.CS2                  ( mov,l  ,  ASM.i(bl^.Blocklist.count),ASM.R(ecx)                 ); 
       
       IF bl^.Blocklist.incr<=4 THEN 
          ASM.C0                ( cld                                       ); 
          ASM.C0                ( repz                                      ); 
          ASM.CS0               ( stos,l                                    ); 
       ELSE 
          ASM.Label(LAB.New       (lab)                                     ); 
          ASM.CS2               ( mov,l  ,  ASM.R(eax),ASM.B(edi)                   ); 
          ASM.CS2               ( add,l  ,  ASM.i(bl^.Blocklist.incr),ASM.R(edi)                  ); 
          ASM.C1                ( loop   ,  ASM.L(lab)                      );
       END;
    END;
 ;
      RETURN;

  END;
(* line 200 "CODEf.tmp" *)
(* line 200 "CODEf.tmp" *)
      
    VarInit(bl^.Blocklist.prev,isGlobal,base); 
    
    IF isGlobal THEN ASM.CS2      ( lea,l  ,  oG(base+bl^.Blocklist.ofs),ASM.R(edi)     ); 
                ELSE ASM.CS2      ( lea,l  ,  ASM.oB(base+bl^.Blocklist.ofs,ebp),ASM.R(edi) ); END;

    CASE bl^.Blocklist.height OF 1:tmp:=ebx;
    |              2:tmp:=edx;
    |              3:tmp:=esi; 
    ELSE             tmp:=ecx; END;
    ASM.CS2                       ( mov,l  ,  ASM.i(bl^.Blocklist.count),ASM.R(tmp)         ); 
                                                                     
    ASM.Label(LAB.New(lab));                                         
    IF bl^.Blocklist.height>3 THEN ASM.C1       ( pushl  ,  ASM.R(ecx)                  ); END;
    SubVarInit(bl^.Blocklist.sub,incrSub);                                         
    IF bl^.Blocklist.height>3 THEN ASM.C1       ( popl   ,  ASM.R(ecx)                  ); END;

    IF bl^.Blocklist.incr-incrSub#0 THEN ASM.CS2( add,l  ,  ASM.i(bl^.Blocklist.incr-incrSub),ASM.R(edi)  ); END;

    CASE bl^.Blocklist.height OF
    |1,2,3: ASM.CS2               ( sub,l  ,  ASM.i(1),ASM.R(tmp)             ); 
            ASM.C1                ( jnz    ,  ASM.L(lab)              ); 
    ELSE    ASM.C1                ( loop   ,  ASM.L(lab)              ); 
    END;
 ;
      RETURN;

  END;
 END VarInit;

PROCEDURE SubVarInit (bl: OB.tOB; VAR incrOut: LONGINT);
(* line 230 "CODEf.tmp" *)
 VAR ii,incrSub:LONGINT; lab:LAB.T; op2:ASM.tOp; tmp:ASM.tReg; 
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 233 "CODEf.tmp" *)
   LOOP
(* line 233 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count = 1)) THEN EXIT; END;
(* line 233 "CODEf.tmp" *)
      
    SubVarInit(bl^.Blocklist.prev,incrOut); 
    
    ASM.CS2( mov,l  ,  ASM.R(eax),ASM.oB(bl^.Blocklist.ofs-incrOut,edi) ); 
 ;
      incrOut := incrOut;
      RETURN;
   END;

  IF (bl^.Blocklist.sub^.Kind = OB.NoBlocklist) THEN
(* line 240 "CODEf.tmp" *)
(* line 240 "CODEf.tmp" *)
      
    SubVarInit(bl^.Blocklist.prev,incrOut); 
    
    IF bl^.Blocklist.count<=LIM.BlocklistLoopUnrollingThreshold THEN 
       FOR ii:=0 TO bl^.Blocklist.count-1 DO ASM.CS2( mov,l  ,  ASM.R(eax),ASM.oB(bl^.Blocklist.ofs+ii*bl^.Blocklist.incr-incrOut,edi) ); END;
    ELSE 
       IF bl^.Blocklist.ofs-incrOut#0 THEN ASM.CS2  ( add,l  ,  ASM.i(bl^.Blocklist.ofs-incrOut),ASM.R(edi)              ); END;
       ASM.CS2                        ( mov,l  ,  ASM.i(bl^.Blocklist.count),ASM.R(ecx)                    ); 
                                      
       IF bl^.Blocklist.incr<=4 THEN                
          ASM.C0                      ( cld                                          ); 
          ASM.C0                      ( repz                                         ); 
          ASM.CS0                     ( stos,l                                       ); 
       ELSE                           
          ASM.Label(LAB.New             (lab)                                        );    
          ASM.CS2                     ( mov,l  ,  ASM.R(eax),ASM.B(edi)                      ); 
          ASM.CS2                     ( add,l  ,  ASM.i(bl^.Blocklist.incr),ASM.R(edi)                     ); 
          ASM.C1                      ( loop   ,  ASM.L(lab)                         );
       END;
       incrOut:=bl^.Blocklist.ofs+bl^.Blocklist.count*bl^.Blocklist.incr;
    END;
 ;
      incrOut := incrOut;
      RETURN;

  END;
(* line 264 "CODEf.tmp" *)
(* line 264 "CODEf.tmp" *)
      
    SubVarInit(bl^.Blocklist.prev,incrOut); 
    
    IF bl^.Blocklist.ofs-incrOut#0 THEN ASM.CS2 ( add,l  ,  ASM.i(bl^.Blocklist.ofs-incrOut),ASM.R(edi)  ); END;

    CASE bl^.Blocklist.height OF 1:tmp:=ebx;
    |              2:tmp:=edx;
    |              3:tmp:=esi;
    ELSE             tmp:=ecx; END;
    ASM.CS2                       ( mov,l  ,  ASM.i(bl^.Blocklist.count),ASM.R(tmp)        ); 
    
    ASM.Label(LAB.New               (lab)                            ); 
    IF bl^.Blocklist.height>3 THEN ASM.C1       ( pushl  ,  ASM.R(ecx)                 ); END;
    SubVarInit(bl^.Blocklist.sub,incrSub); 
    IF bl^.Blocklist.height>3 THEN ASM.C1       ( popl   ,  ASM.R(ecx)                 ); END;

    IF bl^.Blocklist.incr-incrSub#0 THEN ASM.CS2( add,l  ,  ASM.i(bl^.Blocklist.incr-incrSub),ASM.R(edi) ); END;

    CASE bl^.Blocklist.height OF
    |1,2,3: ASM.CS2               ( sub,l  ,  ASM.i(1),ASM.R(tmp)            ); 
            ASM.C1                ( jnz    ,  ASM.L(lab)             ); 
    ELSE    ASM.C1                ( loop   ,  ASM.L(lab)             ); 
    END;
    incrOut:=bl^.Blocklist.ofs+bl^.Blocklist.count*bl^.Blocklist.incr;
 ;
      incrOut := incrOut;
      RETURN;

  END;
(* line 291 "CODEf.tmp" *)
      incrOut := 0;
      RETURN;

 END SubVarInit;

PROCEDURE^CodeGlobalBlocklists (bl: OB.tOB);

PROCEDURE GlobalTDesc* (ptrBl: OB.tOB);
(* line 304 "CODEf.tmp" *)
 VAR nLab,dLab:LAB.T; 
 BEGIN
  IF ptrBl = OB.NoOB THEN RETURN; END;
(* line 306 "CODEf.tmp" *)
(* line 306 "CODEf.tmp" *)
      
    IF ARG.OptionCommentsInAsm THEN ASM.SepLine; ASM.CmtLnS('TDesc for module globals'); END;
    
    nLab:=LAB.AppS(FIL.ActP^.Modulename,'$N'); 
    dLab:=LAB.AppS(FIL.ActP^.Modulename,'$D'); 
    
    ASM.Text;
    ASM.Label(nLab); 
    
    ASM.Asciz(FIL.ActP^.Modulename^); 
    ASM.Align(2);
    ASM.LongL(nLab);
    ASM.LongI(0); 
    ASM.LongL(LAB.NILPROC); 

    ASM.GLabel(dLab); 
    IF ARG.OptionCommentsInAsm THEN CMT.CmtBlocklist(ptrBl); END;
    CodeGlobalBlocklists(ptrBl);
    ASM.Ln;
 ;
      RETURN;

 END GlobalTDesc;

PROCEDURE NamePath (yyP1: OB.tOB);
 BEGIN
  IF yyP1 = OB.NoOB THEN RETURN; END;
  IF (yyP1^.Kind = OB.IdentNamePath) THEN
(* line 332 "CODEf.tmp" *)
(* line 332 "CODEf.tmp" *)
       NamePath(yyP1^.IdentNamePath.prev); ASM.WrId(yyP1^.IdentNamePath.id ); ;
      RETURN;

  END;
  IF (yyP1^.Kind = OB.SelectNamePath) THEN
(* line 333 "CODEf.tmp" *)
(* line 333 "CODEf.tmp" *)
       NamePath(yyP1^.SelectNamePath.prev); ASM.WrS('.' ); ;
      RETURN;

  END;
  IF (yyP1^.Kind = OB.IndexNamePath) THEN
(* line 334 "CODEf.tmp" *)
(* line 334 "CODEf.tmp" *)
       NamePath(yyP1^.IndexNamePath.prev); ASM.WrS('[]'); ;
      RETURN;

  END;
  IF (yyP1^.Kind = OB.DereferenceNamePath) THEN
(* line 335 "CODEf.tmp" *)
(* line 335 "CODEf.tmp" *)
       NamePath(yyP1^.DereferenceNamePath.prev); ASM.WrS('^' ); ;
      RETURN;

  END;
 END NamePath;

PROCEDURE^LocalTDesc1 (label: tLabel; namePath: OB.tOB; ptrBl: OB.tOB);

PROCEDURE LocalTDesc* (entry: OB.tOB; ptrBl: OB.tOB);
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF ptrBl = OB.NoOB THEN RETURN; END;
  IF (entry^.Kind = OB.BoundProcEntry) THEN
(* line 342 "CODEf.tmp" *)
(* line 343 "CODEf.tmp" *)
      LocalTDesc1 (entry^.BoundProcEntry.label, entry^.BoundProcEntry.namePath, ptrBl);
      RETURN;

  END;
  IF (entry^.Kind = OB.ProcedureEntry) THEN
(* line 342 "CODEf.tmp" *)
(* line 343 "CODEf.tmp" *)
      LocalTDesc1 (entry^.ProcedureEntry.label, entry^.ProcedureEntry.namePath, ptrBl);
      RETURN;

  END;
 END LocalTDesc;

PROCEDURE^CodeLocalBlocklists (bl: OB.tOB);

PROCEDURE LocalTDesc1 (label: tLabel; namePath: OB.tOB; ptrBl: OB.tOB);
(* line 349 "CODEf.tmp" *)
 VAR nLab,dLab:LAB.T; 
 BEGIN
  IF namePath = OB.NoOB THEN RETURN; END;
  IF ptrBl = OB.NoOB THEN RETURN; END;
(* line 351 "CODEf.tmp" *)
(* line 351 "CODEf.tmp" *)
      
    IF ARG.OptionCommentsInAsm THEN ASM.CmtLnS('TDesc for proc locals'); END;
    
    nLab:=LAB.AppS(label,'$N'); 
    
    ASM.Text;
    ASM.Label(nLab); 

    IF ARG.OptionCommentsInAsm THEN 
       ASM.WrS('	.asciz	"'); NamePath(namePath);  ASM.WrS('"'); ASM.WrLn;
    ELSE 
       ASM.WrS('.asciz "'); NamePath(namePath);  ASM.WrS('"'); ASM.WrLn;
    END;

    ASM.Align(2);
    ASM.LongL(nLab); 
    ASM.LongI(0); 
    ASM.LongL(LAB.NILPROC); 

    dLab:=LAB.AppS(label,'$D'); 
    ASM.Label(dLab); 
    IF ARG.OptionCommentsInAsm THEN CMT.CmtBlocklist(ptrBl); END;
    CodeLocalBlocklists(ptrBl); 
 ;
      RETURN;

 END LocalTDesc1;

PROCEDURE^TDescElems (yyP3: OB.tOB);

PROCEDURE TDescList* (yyP2: OB.tOB);
 BEGIN
  IF yyP2 = OB.NoOB THEN RETURN; END;
(* line 381 "CODEf.tmp" *)
(* line 381 "CODEf.tmp" *)
       TDescElems(yyP2^.TDescList.TDescElems); ;
      RETURN;

 END TDescList;

PROCEDURE^TDesc (type: OB.tOB; name: OB.tOB);

PROCEDURE TDescElems (yyP3: OB.tOB);
 BEGIN
  IF yyP3 = OB.NoOB THEN RETURN; END;
  IF (yyP3^.Kind = OB.TDescElem) THEN
(* line 388 "CODEf.tmp" *)
(* line 388 "CODEf.tmp" *)
      
    TDescElems(yyP3^.TDescElem.prev); 
    
    IF ARG.OptionCommentsInAsm THEN 
       ASM.SepLine; ASM.WrS('# TDesc for '); NamePath(yyP3^.TDescElem.namePath); ASM.WrLn;
    END;

    ASM.Text;
    TDesc(yyP3^.TDescElem.TypeReprs,yyP3^.TDescElem.namePath); 
 ;
      RETURN;

  END;
 END TDescElems;

PROCEDURE^Skipper (type: OB.tOB);
PROCEDURE^EnterProcsIntoTab (yyP4: OB.tOB);
PROCEDURE^CodeBlocklists (bl: OB.tOB);

PROCEDURE TDesc (type: OB.tOB; name: OB.tOB);
(* line 403 "CODEf.tmp" *)
 VAR label,dLab,iLab:LAB.T; i,n,ofs,odim,size,num:LONGINT; t:OB.tOB; save_edi:BOOLEAN; ptrBl,prcBl:OB.tOB; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF name = OB.NoOB THEN RETURN; END;
  IF OB.IsType (type, OB.TypeRepr) THEN
(* line 405 "CODEf.tmp" *)
(* line 405 "CODEf.tmp" *)
      

    label:=T.LabelOfTypeRepr(type); 

    ASM.Label(LAB.AppS(label,'$N')); 
    IF ARG.OptionCommentsInAsm THEN 
       ASM.WrS('	.asciz	"'); NamePath(name);  ASM.WrS('"'); ASM.WrLn;
    ELSE 
       ASM.WrS('.asciz "'); NamePath(name);  ASM.WrS('"'); ASM.WrLn;
    END;

    ASM.Align(2);
    ASM.Label(LAB.AppS(label,'$S')); 
    Skipper(type); 
    ASM.Ln;

    ASM.Align(2);
    ofs:=-12; 
    IF T.OpenDimAndElemSizeOfArrayType(type,odim,size) THEN 
       ASM.LongI(size); IF ARG.OptionCommentsInAsm THEN ASM.CmtS('-16 elemSize'); END;
       size:=-odim; 
    ELSE 
       size:=type^.TypeRepr.size; 

       (* ProcTab *)           
       n:=T.NumberOfBoundProcsOfType(type); 
       DEC(ofs,4*(LIM.MaxExtensionLevel+n)); 
       IF n>0 THEN 
          InitProcTab(n); 
          EnterProcsIntoTab(T.FieldsOfRecordType(type)); 
          FOR i:=n-1 TO 0 BY -1 DO
           IF ProcTab^[i]#NIL THEN 
              ASM.LongL(E.LabelOfEntry(ProcTab^[i])); IF ARG.OptionCommentsInAsm THEN ASM.CmtI(ofs); INC(ofs,4); END;
           ELSE 
              ERR.Fatal('Coder.CodeTDesc: ProcTab problems'); 
           END;
          END;
          ASM.Ln;
       END;
   
       (* BaseTypes *)
       t:=type; n:=0; 
       WHILE (n<LIM.MaxExtensionLevel) & T.IsRecordType(t) DO
        INC(n); BaseTypes[n]:=t; t:=T.RecordBaseTypeOfType(t); 
       END;

       num:=0; 
       FOR i:=n TO 1 BY -1 DO
        ASM.LongL(LAB.AppS(T.LabelOfTypeRepr(BaseTypes[i]),'$D')); 
        IF ARG.OptionCommentsInAsm THEN ASM.CmtI(ofs); INC(ofs,4); ASM.CmtS(" type"); ASM.CmtI(num); INC(num); END;
       END;
       FOR i:=n+1 TO LIM.MaxExtensionLevel DO
        ASM.LongI(0); 
        IF ARG.OptionCommentsInAsm THEN ASM.CmtI(ofs); INC(ofs,4); ASM.CmtS(" type"); ASM.CmtI(num); INC(num); END;
       END;
       ASM.Ln;
    END;

    ASM.LongL(LAB.AppS(label,'$N')); IF ARG.OptionCommentsInAsm THEN ASM.CmtS('-12 name'); END;
    ASM.LongI(size);                 IF ARG.OptionCommentsInAsm THEN ASM.CmtS('-8  size/odim'); END;
    ASM.LongL(LAB.AppS(label,'$S')); IF ARG.OptionCommentsInAsm THEN ASM.CmtS('-4  skipper'); END;
    ASM.Ln;

    (* pointer offsets *)
    dLab:=LAB.AppS(label,'$D'); 
    ASM.Globl(dLab); 
    ASM.Label(dLab); 
    ptrBl:=BL.PtrBlocklistOfType(type); 
    IF ARG.OptionCommentsInAsm THEN CMT.CmtBlocklist(ptrBl); END;
    ASM.ByteI(0); 
    CodeBlocklists(ptrBl);

    IF ARG.OptionCommentsInAsm THEN ASM.WrS('	.long	'); ELSE ASM.WrS('.long '); END;
    ASM.WrS(dLab^); ASM.WrS('+1'); ASM.WrLn;
    ASM.Ln;
    
    (* Initializer *)
    prcBl:=BL.ProcBlocklistOfType(type); 
    save_edi:=(~BL.IsEmptyBlocklist(ptrBl) & ~BL.IsEmptyBlocklist(prcBl)); 

    iLab:=LAB.AppS(label,'$I'); 
    ASM.Globl(iLab); 
    ASM.Label(iLab); 
    IF save_edi THEN ASM.C1( pushl  ,  ASM.R(edi) ); END;

    TypeInitializing(ptrBl,(*isPtr:=*)TRUE ); 
    IF save_edi THEN ASM.C1( popl   ,  ASM.R(edi) ); END;
    TypeInitializing(prcBl,(*isPtr:=*)FALSE); 
    ASM.C0                 ( ret              ); 
    ASM.Ln;
 ;
      RETURN;

  END;
 END TDesc;

PROCEDURE^EnterProcsIntoTab1 (entry: OB.tOB);

PROCEDURE EnterProcsIntoTab (yyP4: OB.tOB);
 BEGIN
  IF yyP4 = OB.NoOB THEN RETURN; END;
  IF (yyP4^.Kind = OB.BoundProcEntry) THEN
(* line 502 "CODEf.tmp" *)
(* line 503 "CODEf.tmp" *)
      
    EnterProcsIntoTab(yyP4^.BoundProcEntry.prevEntry); 
    EnterProcsIntoTab1(yyP4);
 ;
      RETURN;

  END;
  IF (yyP4^.Kind = OB.InheritedProcEntry) THEN
  IF (yyP4^.InheritedProcEntry.boundProcEntry^.Kind = OB.BoundProcEntry) THEN
(* line 502 "CODEf.tmp" *)
(* line 503 "CODEf.tmp" *)
      
    EnterProcsIntoTab(yyP4^.InheritedProcEntry.prevEntry); 
    EnterProcsIntoTab1(yyP4^.InheritedProcEntry.boundProcEntry);
 ;
      RETURN;

  END;
  END;
  IF OB.IsType (yyP4, OB.DataEntry) THEN
(* line 508 "CODEf.tmp" *)
(* line 508 "CODEf.tmp" *)
      
    EnterProcsIntoTab(yyP4^.DataEntry.prevEntry); 
 ;
      RETURN;

  END;
 END EnterProcsIntoTab;

PROCEDURE EnterProcsIntoTab1 (entry: OB.tOB);
 BEGIN
  IF entry = OB.NoOB THEN RETURN; END;
  IF (entry^.Kind = OB.BoundProcEntry) THEN
(* line 517 "CODEf.tmp" *)
(* line 517 "CODEf.tmp" *)
        
    IF (0<=entry^.BoundProcEntry.procNum) & (entry^.BoundProcEntry.procNum<ProcTabSize)
    &  (ProcTab^[entry^.BoundProcEntry.procNum]=NIL) THEN 
       ProcTab^[entry^.BoundProcEntry.procNum]:=entry; 
    ELSE                       
       ERR.Fatal('Coder.EnterProcsIntoTab1: ProcTab problems'); 
    END;
 ;
      RETURN;

  END;
 END EnterProcsIntoTab1;

PROCEDURE^CodeFixedBls (bl: OB.tOB; base: LONGINT);

PROCEDURE CodeBlocklists (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 531 "CODEf.tmp" *)
   LOOP
(* line 531 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count < 0)) THEN EXIT; END;
(* line 531 "CODEf.tmp" *)
      
    ASM.LongI(-2); 
    ASM.LongI(ADR.ArrayOfsFromODim(-bl^.Blocklist.count)); 
    ASM.LongI(bl^.Blocklist.incr); 
    CodeFixedBls(bl^.Blocklist.sub,0); 
    ASM.LongI(-1); 
 ;
      RETURN;
   END;

  END;
(* line 539 "CODEf.tmp" *)
(* line 539 "CODEf.tmp" *)
      
    CodeFixedBls(bl,0); 
    ASM.LongI(-1); 
 ;
      RETURN;

 END CodeBlocklists;

PROCEDURE CodeGlobalBlocklists (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
(* line 549 "CODEf.tmp" *)
(* line 549 "CODEf.tmp" *)
      
    CodeFixedBls(bl,-4); 
    ASM.LongI(-1); 
 ;
      RETURN;

 END CodeGlobalBlocklists;

PROCEDURE^CodeOpenBls (bl: OB.tOB);

PROCEDURE CodeLocalBlocklists (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
(* line 559 "CODEf.tmp" *)
(* line 559 "CODEf.tmp" *)
      
    CodeFixedBls(bl,0); 
    ASM.LongI(-1); 
    CodeOpenBls(bl); 
 ;
      RETURN;

 END CodeLocalBlocklists;

PROCEDURE CodeOpenBls (bl: OB.tOB);
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
(* line 570 "CODEf.tmp" *)
   LOOP
(* line 570 "CODEf.tmp" *)
      IF ~((bl^.Blocklist.count < 0)) THEN EXIT; END;
(* line 570 "CODEf.tmp" *)
      
    CodeOpenBls(bl^.Blocklist.prev); 
    ASM.LongI(-2); 
    ASM.LongI(bl^.Blocklist.ofs); 
    ASM.LongI(bl^.Blocklist.incr); 
    CodeFixedBls(bl^.Blocklist.sub,0); 
    ASM.LongI(-1); 
 ;
      RETURN;
   END;

(* line 579 "CODEf.tmp" *)
(* line 579 "CODEf.tmp" *)
      
    CodeOpenBls(bl^.Blocklist.prev); 
 ;
      RETURN;

  END;
 END CodeOpenBls;

PROCEDURE CodeFixedBls (bl: OB.tOB; base: LONGINT);
(* line 587 "CODEf.tmp" *)
 VAR ii:LONGINT; 
 BEGIN
  IF bl = OB.NoOB THEN RETURN; END;
  IF (bl^.Kind = OB.Blocklist) THEN
  IF (bl^.Blocklist.sub^.Kind = OB.NoBlocklist) THEN
(* line 589 "CODEf.tmp" *)
(* line 589 "CODEf.tmp" *)
      
    CodeFixedBls(bl^.Blocklist.prev,base); 
    FOR ii:=0 TO bl^.Blocklist.count-1 DO ASM.LongI(base+bl^.Blocklist.ofs+ii*bl^.Blocklist.incr); END;
 ;
      RETURN;

  END;
(* line 594 "CODEf.tmp" *)
(* line 594 "CODEf.tmp" *)
      
    CodeFixedBls(bl^.Blocklist.prev,base); 
    FOR ii:=0 TO bl^.Blocklist.count-1 DO CodeFixedBls(bl^.Blocklist.sub,base+bl^.Blocklist.ofs+ii*bl^.Blocklist.incr); END;
 ;
      RETURN;

  END;
 END CodeFixedBls;

PROCEDURE^StackFrameLinks1 (level: tLevel; env: OB.tOB; label: tLabel; localSpace: LONGINT; fTempLabel: tLabel; VAR yyP9: tOperId; VAR yyP8: LONGINT);

PROCEDURE StackFrameLinks* (yyP5: OB.tOB; localSpace: LONGINT; fTempLabel: tLabel; VAR yyP7: tOperId; VAR yyP6: LONGINT);
 VAR yyTempo: RECORD
 yyR1: RECORD
  yyV1: tOperId;
  yyV2: LONGINT;
  END;
 yyR2: RECORD
  yyV1: tOperId;
  yyV2: LONGINT;
  END;
 END;
 BEGIN
  IF yyP5 = OB.NoOB THEN RETURN; END;
  IF (yyP5^.Kind = OB.BoundProcEntry) THEN
(* line 610 "CODEf.tmp" *)
(* line 612 "CODEf.tmp" *)
      StackFrameLinks1 (yyP5^.BoundProcEntry.level, yyP5^.BoundProcEntry.env, yyP5^.BoundProcEntry.label, localSpace, fTempLabel, yyTempo.yyR1.yyV1, yyTempo.yyR1.yyV2);
      yyP7 := yyTempo.yyR1.yyV1;
      yyP6 := yyTempo.yyR1.yyV2;
      RETURN;

  END;
  IF (yyP5^.Kind = OB.ProcedureEntry) THEN
(* line 610 "CODEf.tmp" *)
(* line 612 "CODEf.tmp" *)
      StackFrameLinks1 (yyP5^.ProcedureEntry.level, yyP5^.ProcedureEntry.env, yyP5^.ProcedureEntry.label, localSpace, fTempLabel, yyTempo.yyR2.yyV1, yyTempo.yyR2.yyV2);
      yyP7 := yyTempo.yyR2.yyV1;
      yyP6 := yyTempo.yyR2.yyV2;
      RETURN;

  END;
 END StackFrameLinks;

PROCEDURE StackFrameLinks1 (level: tLevel; env: OB.tOB; label: tLabel; localSpace: LONGINT; fTempLabel: tLabel; VAR yyP9: tOperId; VAR yyP8: LONGINT);
(* line 618 "CODEf.tmp" *)
 VAR ii,spaceAdjust:LONGINT; idOfdispN,idOfLocalSub:ASM.tOperId; 
 BEGIN
  IF env = OB.NoOB THEN RETURN; END;
(* line 619 "CODEf.tmp" *)
(* line 619 "CODEf.tmp" *)
      
    spaceAdjust:=0; 
    IF level<LIM.FirstNestingDepthToUseEnter THEN                       
       ASM.C1                      ( pushl  ,  ASM.R(ebp)                                        ); 
       ASM.C1                      ( pushl  ,  ASM.iL(LAB.AppS(label,'$D'))                      ); 
       IF ARG.OptionCommentsInAsm THEN ASM.CmtS('TDesc of proc'); END;  
                                                                        
       FOR ii:=2 TO level DO ASM.C1( pushl  ,  ASM.oB(-4*ii,ebp)                                 ); END;
                                                                                                      
       ASM.CS2                     ( lea,l  ,  ASM.oB(4*level,esp),ASM.R(ebp)                        ); 

       ASM.C1                      ( pushl  ,  ASM.R(ebp)                                        ); 
       IF ARG.OptionCommentsInAsm THEN ASM.CmtS('disp-next'); END;
       IF ~((level+1) IN E.LevelsOfEnv(env)) THEN 
          ASM.GetLastOperId(idOfdispN);
          ASM.MakeObsolete(idOfdispN); 
          spaceAdjust:=4; 
       END;

       ASM.CS2                     ( sub,l  ,  ASM.ioL(ADR.Align4(localSpace),fTempLabel),ASM.R(esp) ); 
       ASM.GetLastOperId(idOfLocalSub);
    ELSE 
       ASM.C2                      ( enter  ,  ASM.i(ADR.Align4(localSpace)),ASM.i(level+1)          ); 
         
       ASM.CS2                     ( mov,l  ,  ASM.iL(LAB.AppS(label,'$D')),ASM.oB(-4,ebp)           ); 
       IF ARG.OptionCommentsInAsm THEN ASM.CmtS('TDesc of proc'); END;
    END;
    ASM.Ln;
 ;
      yyP9 := idOfLocalSub;
      yyP8 := spaceAdjust;
      RETURN;

 END StackFrameLinks1;

PROCEDURE RefdValParamsCopy* (yyP10: OB.tOB);
(* line 653 "CODEf.tmp" *)
 VAR size,elemSize,shift:LONGINT; 
 BEGIN
  IF yyP10 = OB.NoOB THEN RETURN; END;
  IF (yyP10^.Kind = OB.Signature) THEN
  IF (yyIsEqual ( yyP10^.Signature.VarEntry^.VarEntry.parMode ,   OB.VALPAR ) ) THEN
  IF (yyIsEqual ( yyP10^.Signature.VarEntry^.VarEntry.refMode ,   OB.REFPAR ) ) THEN
(* line 656 "CODEf.tmp" *)
(* line 673 "CODEf.tmp" *)
      
    IF ARG.OptionCommentsInAsm THEN 
       ASM.CmtLnS('Local copy for parameter '); ASM.CmtId(yyP10^.Signature.VarEntry^.VarEntry.ident); 
    END;
    IF yyP10^.Signature.VarEntry^.VarEntry.isLaccessed THEN 
       IF T.OpenDimOfArrayType(yyP10^.Signature.VarEntry^.VarEntry.typeRepr)=0 THEN 
          size:=T.SizeOfType(yyP10^.Signature.VarEntry^.VarEntry.typeRepr); 
          CASE size OF
          |0..4 : ;
   
          |5..8 : ASM.CS2   ( sub,l   ,  ASM.i(8),ASM.R(esp)                      );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         ); 
                  ASM.CS0   ( movs,l                                      );
                  ASM.CS0   ( movs,l                                      );
                  ASM.Ln;                                                 
                                                                          
          |9..12: ASM.CS2   ( sub,l   ,  ASM.i(12),ASM.R(esp)                     );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         ); 
                  ASM.CS0   ( movs,l                                      );
                  ASM.CS0   ( movs,l                                      );
                  ASM.CS0   ( movs,l                                      );
                  ASM.Ln;                                     
                                                              
          ELSE    size:=ADR.Align4(size);                     
                  ASM.CS2   ( mov,l   ,  ASM.i(size DIV 4),ASM.R(ecx)             );
                  ASM.CS2   ( sub,l   ,  ASM.i(size),ASM.R(esp)                   );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         ); 
                  ASM.C0    ( repz                                        );
                  ASM.CS0   ( movs,l                                      );
                  ASM.Ln;
          END;
       ELSE 
          elemSize:=T.ElemSizeOfOpenArrayType(yyP10^.Signature.VarEntry^.VarEntry.typeRepr);
          CASE elemSize OF
   
          |1:     ASM.CS2   ( mov,l   ,  ASM.oB(4+yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(ecx)             );
                  ASM.CS2   ( add,l   ,  ASM.i(3),ASM.R(ecx)                      );
                  ASM.CS2   ( and,b   ,  ASM.x(0FCH),ASM.R(cl)                    );
                  ASM.CS2   ( sub,l   ,  ASM.R(ecx),ASM.R(esp)                    );
                  ASM.CS2   ( shr,l   ,  ASM.i(2),ASM.R(ecx)                      );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         );    
                  ASM.C0    ( repz                                        );   
                  ASM.CS0   ( movs,l                                      ); 
                                                              
          |2:     ASM.CS2   ( mov,l   ,  ASM.oB(4+yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(ecx)             );
                  ASM.CS2   ( lea,l   ,  ASM.oIf(3,ecx,2),ASM.R(ecx)              );
                  ASM.CS2   ( and,b   ,  ASM.x(0FCH),ASM.R(cl)                    );
                  ASM.CS2   ( sub,l   ,  ASM.R(ecx),ASM.R(esp)                    );
                  ASM.CS2   ( shr,l   ,  ASM.i(2),ASM.R(ecx)                      );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         );    
                  ASM.C0    ( repz                                        );   
                  ASM.CS0   ( movs,l                                      ); 
                                                                          
          |3:     ASM.CS2   ( mov,l   ,  ASM.oB(4+yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(ecx)             );
                  ASM.CS2   ( lea,l   ,  ASM.oBIf(3,ecx,ecx,2),ASM.R(ecx)         );
                  ASM.CS2   ( and,b   ,  ASM.x(0FCH),ASM.R(cl)                    );
                  ASM.CS2   ( sub,l   ,  ASM.R(ecx),ASM.R(esp)                    );
                  ASM.CS2   ( shr,l   ,  ASM.i(2),ASM.R(ecx)                      );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         );    
                  ASM.C0    ( repz                                        );   
                  ASM.CS0   ( movs,l                                      ); 
                                                                          
          |4:     ASM.CS2   ( mov,l   ,  ASM.oB(4+yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(ecx)             );
                  ASM.CS2   ( mov,l   ,  ASM.R(ecx),ASM.R(eax)                    );
                  ASM.CS2   ( shl,l   ,  ASM.i(2),ASM.R(eax)                      );
                  ASM.CS2   ( sub,l   ,  ASM.R(eax),ASM.R(esp)                    );
                  ASM.CS2   ( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                  ASM.CS2   ( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                  ASM.CS2   ( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                  ASM.C0    ( cld                                         ); 
                  ASM.C0    ( repz                                        );
                  ASM.CS0   ( movs,l                                      );
   
          ELSE    IF ADR.IntLog2(elemSize,shift) THEN
                     ASM.CS2( mov,l   ,  ASM.oB(4+yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(ecx)             );
                     ASM.CS2( shl,l   ,  ASM.i(shift),ASM.R(ecx)                  );
                     ASM.CS2( add,l   ,  ASM.i(3),ASM.R(ecx)                      );
                     ASM.CS2( and,b   ,  ASM.x(0FCH),ASM.R(cl)                    );
                     ASM.CS2( sub,l   ,  ASM.R(ecx),ASM.R(esp)                    );
                     ASM.CS2( shr,l   ,  ASM.i(2),ASM.R(ecx)                      );
                     ASM.CS2( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                     ASM.CS2( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                     ASM.CS2( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                     ASM.C0 ( cld                                         );    
                     ASM.C0 ( repz                                        );   
                     ASM.CS0( movs,l                                      ); 
                  ELSE                  
                     ASM.CS3( imul,l  ,  ASM.i(elemSize),ASM.oB(4+yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(ecx) );
                     ASM.CS2( add,l   ,  ASM.i(3),ASM.R(ecx)                      );
                     ASM.CS2( and,b   ,  ASM.x(0FCH),ASM.R(cl)                    );
                     ASM.CS2( sub,l   ,  ASM.R(ecx),ASM.R(esp)                    );
                     ASM.CS2( shr,l   ,  ASM.i(2),ASM.R(ecx)                      );
                     ASM.CS2( mov,l   ,  ASM.R(esp),ASM.R(edi)                    );
                     ASM.CS2( mov,l   ,  ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp),ASM.R(esi)               );
                     ASM.CS2( mov,l   ,  ASM.R(edi),ASM.oB(yyP10^.Signature.VarEntry^.VarEntry.address,ebp)               );
                     ASM.C0 ( cld                                         );    
                     ASM.C0 ( repz                                        );
                     ASM.CS0( movs,l                                      );
                  END;
          END;
          ASM.Ln;
       END;
    ELSE 
       IF ARG.OptionCommentsInAsm THEN ASM.CmtS(' obsolete (not L-accessed)'); END;
    END;

    RefdValParamsCopy(yyP10^.Signature.next); 
 ;
      RETURN;

  END;
  END;
(* line 801 "CODEf.tmp" *)
(* line 801 "CODEf.tmp" *)
      
    RefdValParamsCopy(yyP10^.Signature.next); 
 ;
      RETURN;

  END;
 END RefdValParamsCopy;

PROCEDURE Skipper (type: OB.tOB);
(* line 809 "CODEf.tmp" *)
 VAR arrayOfs,openDim,elemSize,shift:LONGINT; 
 BEGIN
  IF type = OB.NoOB THEN RETURN; END;
  IF OB.IsType (type, OB.TypeRepr) THEN
(* line 811 "CODEf.tmp" *)
   LOOP
(* line 811 "CODEf.tmp" *)
      IF ~((type^.TypeRepr.size > 0)) THEN EXIT; END;
(* line 811 "CODEf.tmp" *)
      
    ASM.CS2( add,l  ,  ASM.i(ADR.Align8(4+type^.TypeRepr.size)),ASM.R(ebx) ); 
    ASM.C1 ( jmp    ,  ASM.R(esi)                       ); 
 ;
      RETURN;
   END;

  END;
  IF (type^.Kind = OB.RecordTypeRepr) THEN
(* line 816 "CODEf.tmp" *)
   LOOP
(* line 816 "CODEf.tmp" *)
      IF ~((type^.RecordTypeRepr.size = 0)) THEN EXIT; END;
(* line 816 "CODEf.tmp" *)
       (* An open array has also type^.RecordTypeRepr.size=0! *)
    ASM.CS2( add,l  ,  ASM.i(8),ASM.R(ebx) ); 
    ASM.C1 ( jmp    ,  ASM.R(esi)      ); 
 ;
      RETURN;
   END;

  END;
  IF (type^.Kind = OB.ArrayTypeRepr) THEN
(* line 821 "CODEf.tmp" *)
   LOOP
(* line 821 "CODEf.tmp" *)
      IF ~((type^.ArrayTypeRepr.len = OB . OPENARRAYLEN)) THEN EXIT; END;
(* line 821 "CODEf.tmp" *)
      
    openDim       := T.OpenDimOfArrayType(type); 
    elemSize      := T.ElemSizeOfOpenArrayType(type); 
    CASE openDim OF
    |0:  arrayOfs := 0; 
    |1:  arrayOfs := 4; 
    ELSE arrayOfs := 4+4*openDim; 
    END;
    
    CASE elemSize OF

    |0  : ASM.CS2( add,l  ,  ASM.i(ADR.Align8(4+arrayOfs)),ASM.R(ebx)              ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |1  : ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.oBI(11+arrayOfs,ebx,eax),ASM.R(ebx)               ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |2,4: ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.oBIf(11+arrayOfs,ebx,eax,elemSize),ASM.R(ebx)     ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |3  : ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.BIf(eax,eax,2),ASM.R(eax)                         ); 
          ASM.CS2( lea,l  ,  ASM.oBI(11+arrayOfs,ebx,eax),ASM.R(ebx)               ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |5  : ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.B(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.BIf(eax,eax,4),ASM.R(eax)                         ); 
          ASM.CS2( lea,l  ,  ASM.oBI(11+arrayOfs,ebx,eax),ASM.R(ebx)               ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |6  : ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.BIf(eax,eax,2),ASM.R(eax)                         ); 
          ASM.CS2( lea,l  ,  ASM.oBIf(11+arrayOfs,ebx,eax,2),ASM.R(ebx)            ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |7  : ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( shl,l  ,  ASM.i(3),ASM.R(eax)                                   ); 
          ASM.CS2( sub,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.oBI(11+arrayOfs,ebx,eax),ASM.R(ebx)               ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    |8  : ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( lea,l  ,  ASM.oBIf(ADR.Align8(4+arrayOfs),ebx,eax,8),ASM.R(ebx) ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 

    ELSE  IF ADR.IntLog2(elemSize,shift) THEN 
          ASM.CS2( mov,l  ,  ASM.B(ebx),ASM.R(eax)                                 ); 
          ASM.CS2( shl,l  ,  ASM.i(shift),ASM.R(eax)                               ); 
          ASM.CS2( lea,l  ,  ASM.oBI(ADR.Align8(4+arrayOfs),ebx,eax),ASM.R(ebx)    ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 
    ELSE
          ASM.CS3( imul,l ,  ASM.i(elemSize),ASM.B(ebx),ASM.R(eax)                     ); 
          ASM.CS2( lea,l  ,  ASM.oBI(11+arrayOfs,ebx,eax),ASM.R(ebx)               ); 
          ASM.CS2( and,b  ,  ASM.x(0F8H),ASM.R(bl)                                 ); 
          ASM.C1 ( jmp    ,  ASM.R(esi)                                        ); 
    END;
    END;
 ;
      RETURN;
   END;

  END;
 END Skipper;

PROCEDURE BeginCODEf*;
 BEGIN
(* line 69 "CODEf.tmp" *)
  ProcTabSize:=16; Storage.ALLOCATE(ProcTab,ProcTabSize*SIZE(OB.tOB)); 
 END BeginCODEf;

PROCEDURE CloseCODEf*;
 BEGIN
 END CloseCODEf;

PROCEDURE yyExit;
 BEGIN
  IO.CloseIO; System.Exit (1);
 END yyExit;

BEGIN
 yyf	:= IO.StdOutput;
 Exit	:= yyExit;
 BeginCODEf;
END CODEf.

