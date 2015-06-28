MODULE iOPL;

   IMPORT SYSTEM, iOPT, iOPS;

   CONST
      CaseTrap* = 16;
      DimTrap* = 22;
      EqualGuardTrap* = 18;
      FuncTrap* = 17;
      GETreg* = 8;
      GuardTrap* = 19;
      Ldbdwu* = 5;
      Ldbwu* = 7;
      Ldwdwu* = 6;
      MaxEntry* = 128;
      NewArrayEntryNr* = 251;
      NewArrayLinkIndex* = 4;
      NewEntryNr* = 253;
      NewLinkIndex* = 2;
      NewSysEntryNr* = 252;
      NewSysLinkIndex* = 3;
      Nil* = -1;
      OverflowTrap* = 20;
      PUTreg* = 9;
      RangeTrap* = 21;
      RiscCodeLen* = 7000;
      RiscESP* = -3;
      RiscFP* = -2;
      Short* = 93;
      WithTrap* = 15;
      abs* = 992;
      add* = 512;
      and* = 736;
      bt* = 1088;
      btr* = 768;
      bts* = 800;
      call* = 2080;
      callReg* = 2112;
      case* = 2432;
      cld* = 2272;
      cmp* = 1056;
      cmpString* = 2336;
      div* = 608;
      enter* = 2208;
      entier* = 3104;
      fabs* = 2784;
      fadd* = 2656;
      fchs* = 2816;
      fcmp* = 2848;
      fdiv* = 2752;
      fild* = 2624;
      fist* = 2592;
      fload* = 2528;
      fmul* = 2720;
      fstore* = 2560;
      fsub* = 2688;
      getReg* = 256;
      ja* = 1696;
      jae* = 1728;
      jb* = 1760;
      jbe* = 1792;
      jc* = 1824;
      je* = 1504;
      jg* = 1632;
      jge* = 1664;
      jl* = 1568;
      jle* = 1600;
      jmp* = 1888;
      jmpReg* = 1920;
      jnc* = 1856;
      jne* = 1536;
      label* = 2496;
      ld* = 32;
      ldProc* = 320;
      ldXProc* = 352;
      ldbdw* = 64;
      ldbdwu* = 160;
      ldbw* = 128;
      ldbwu* = 224;
      ldwdw* = 96;
      ldwdwu* = 196;
      lea* = 384;
      leave* = 2240;
      mod* = 640;
      mul* = 576;
      neg* = 960;
      newStat* = 3136;
      noHint* = -1;
      none* = -1;
      not* = 1024;
      or* = 672;
      phi* = 2464;
      pop* = 480;
      popReg* = 2400;
      push* = 448;
      pushReg* = 2368;
      putReg* = 288;
      repMovs* = 2304;
      ret* = 2176;
      rol* = 928;
      sal* = 832;
      sar* = 864;
      seta* = 1312;
      setae* = 1344;
      setb* = 1376;
      setbe* = 1408;
      setc* = 1440;
      sete* = 1120;
      setg* = 1248;
      setge* = 1280;
      setl* = 1184;
      setle* = 1216;
      setnc* = 1472;
      setne* = 1152;
      short* = 2976;
      shr* = 896;
      store* = 416;
      sub* = 544;
      ta* = 2016;
      tae* = 2880;
      te* = 1952;
      tle* = 2944;
      tne* = 1984;
      to* = 2912;
      trap* = 2048;
      tryEAX* = 16;
      tryEBX* = 19;
      tryECX* = 17;
      tryEDI* = 23;
      tryEDX* = 18;
      tryESI* = 22;
      useEAX* = 0;
      useEBP* = 5;
      useEBX* = 3;
      useECX* = 1;
      useEDI* = 7;
      useEDX* = 2;
      useESI* = 6;
      useESP* = 4;
      useST* = 8;
      xcall* = 2144;
      xor* = 704;

   TYPE
      ExtraNode* = POINTER TO ExtraNodeDesc;
      ExtraNodeDesc* = RECORD
         node*: iOPT.Node;
         next*: ExtraNode;
      END;
      Instruction* = RECORD
         scale*, reg*: SHORTINT;
         op*: INTEGER;
         dest*, src1*, src2*, inx*, pc*, hint*: LONGINT;
         link*, used*: INTEGER;
         node*: LONGINT;
      END;
      WeakNode* = LONGINT;

   VAR
      Instr*: ARRAY 7000 OF Instruction;
      extraNodes*: ExtraNode;
      ptrinit*: BOOLEAN;

   PROCEDURE AbsAccess* (weakNode, offset: LONGINT);
   BEGIN
   END AbsAccess;

   PROCEDURE AllocCaseTab* (low, high: LONGINT; VAR tab: LONGINT);
   BEGIN
   END AllocCaseTab;

   PROCEDURE AllocConst* (VAR s: ARRAY OF SYSTEM.BYTE; len, align: LONGINT; VAR adr: LONGINT);
   BEGIN
   END AllocConst;

   PROCEDURE AllocTypDesc* (typ: iOPT.Struct);
   BEGIN
   END AllocTypDesc;

   PROCEDURE CaseJump* (Label, tab, from, to: LONGINT);
   BEGIN
   END CaseJump;

   PROCEDURE Close*;
   BEGIN
   END Close;

   PROCEDURE FixupLocalProcCall* (proc: iOPT.Object);
   BEGIN
   END FixupLocalProcCall;

   PROCEDURE GenCode* (pSize: INTEGER);
   BEGIN
   END GenCode;

   PROCEDURE Init*;
   BEGIN
   END Init;

   PROCEDURE NewEntry* (VAR entryNr: LONGINT);
   BEGIN
   END NewEntry;

   PROCEDURE NewLink* (mod, entry: LONGINT; VAR index: LONGINT);
   BEGIN
   END NewLink;

   PROCEDURE NewVarCons* (mod, entry: INTEGER; VAR index: LONGINT);
   BEGIN
   END NewVarCons;

   PROCEDURE NewVarEntry* (offset: LONGINT; VAR entryNr: LONGINT);
   BEGIN
   END NewVarEntry;

   PROCEDURE OutCode* (VAR modName: ARRAY OF CHAR; key: LONGINT);
   BEGIN
   END OutCode;

   PROCEDURE OutRefName* (name: ARRAY OF CHAR);
   BEGIN
   END OutRefName;

   PROCEDURE OutRefPoint* (proc: iOPT.Object);
   BEGIN
   END OutRefPoint;

   PROCEDURE OutRefs* (obj: iOPT.Object);
   BEGIN
   END OutRefs;

END iOPL.
