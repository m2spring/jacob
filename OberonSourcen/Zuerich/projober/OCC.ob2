MODULE OCC;  (*NW 30.5.87 / 16.3.91*)

   IMPORT Files, OCS, OCT;

   CONST CodeLength = 18000; LinkLength = 250;
            ConstLength = 3500; EntryLength = 64;
            CodeLim = CodeLength - 100;
            MaxPtrs = 64; MaxRecs = 32; MaxComs = 40; MaxExts = 7;
      (*instruction prefixes*)
         F6 = 4EH; F7 = 0CEH; F9 = 3EH; F11 = 0BEH;

      (*object and item modes*)
         Var   =  1; VarX  =  2; Ind   =  3; IndX  =  4; RegI  =  5;
         RegX  =  6; Abs   =  7; Con   =  8; Stk   =  9; Coc   = 10;
         Reg   = 11; Fld   = 12; Typ   = 13; LProc = 14; XProc = 15;
         SProc = 16; CProc = 17; IProc = 18; Mod   = 19; Head  = 20;

      (*structure forms*)
         Undef = 0; Byte = 1; Bool = 2; Char = 3; SInt = 4; Int = 5; LInt = 6;
         Real = 7; LReal = 8; Set = 9; String = 10; NilTyp = 11; NoTyp = 12;
         Pointer = 13; ProcTyp = 14; Array = 15; DynArr = 16; Record = 17;

   TYPE Argument =
         RECORD form, gen, inx: INTEGER;
            d1, d2: LONGINT
         END ;

   VAR pc*, level*: INTEGER;
         wasderef*: OCT.Object;
         typchk*: BOOLEAN;
         RegSet*, FRegSet: SET;
         lnkx, conx, nofptrs, nofrec: INTEGER;
         PtrTab: ARRAY MaxPtrs OF LONGINT;
         RecTab: ARRAY MaxRecs OF OCT.Struct;
         constant: ARRAY ConstLength OF CHAR;
         code:  ARRAY CodeLength OF CHAR;
         link:  ARRAY LinkLength OF INTEGER;
         entry: ARRAY EntryLength OF INTEGER;

   PROCEDURE GetReg*(VAR x: OCT.Item);
      VAR i: INTEGER;
   BEGIN i := 7; x.mode := Reg;
      LOOP IF ~(i IN RegSet) THEN x.a0 := i; INCL(RegSet,i); EXIT END ;
             IF i = 0 THEN x.a0 := 0; OCS.Mark(215); EXIT ELSE DEC(i) END ;
      END
   END GetReg;

   PROCEDURE GetFReg*(VAR x: OCT.Item);
      VAR i: INTEGER;
   BEGIN i := 6; x.mode := Reg;
      LOOP IF ~(i IN FRegSet) THEN x.a0 := i; INCL(FRegSet,i); EXIT END ;
             IF i = 0 THEN x.a0 := 0; OCS.Mark(216); EXIT ELSE i := i-2 END
      END
   END GetFReg;

   PROCEDURE FreeRegs*(r: SET);
   BEGIN RegSet := r; FRegSet := {}
   END FreeRegs;

   PROCEDURE AllocInt*(k: INTEGER);
   BEGIN
      IF conx < ConstLength-1 THEN
         constant[conx] := CHR(k); INC(conx);
         constant[conx] := CHR(k DIV 100H); INC(conx)
      ELSE OCS.Mark(230); conx := 0
      END
   END AllocInt;

   PROCEDURE AllocString*(VAR s: ARRAY OF CHAR; VAR x: OCT.Item);
      VAR i: INTEGER; ch: CHAR;
   BEGIN INC(conx, (-conx) MOD 4); i := 0;
      REPEAT ch := s[i]; INC(i);
         IF conx >= ConstLength THEN OCS.Mark(230); conx := 0 END ;
         constant[conx] := ch; INC(conx)
      UNTIL ch = 0X;
      x.lev := 0; x.a0 := conx - i; x.a1 := i
   END AllocString;

   PROCEDURE AllocBounds*(min, max: INTEGER; VAR adr: LONGINT);
   BEGIN INC(conx, (-conx) MOD 4); adr := conx;
      AllocInt(max); AllocInt(min)
   END AllocBounds;

   PROCEDURE PutByte*(x: LONGINT);
   BEGIN code[pc] := CHR(x); INC(pc)
   END PutByte;

   PROCEDURE PutWord*(x: LONGINT);
   BEGIN code[pc] := CHR(x DIV 100H); INC(pc); code[pc] := CHR(x); INC(pc)
   END PutWord;

   PROCEDURE PutDbl(x: LONGINT);
      VAR i: INTEGER;
   BEGIN i := -32;
      REPEAT INC(i, 8); code[pc] := CHR(ASH(x, i)); INC(pc) UNTIL i = 0
   END PutDbl;

   PROCEDURE PutDisp*(x: LONGINT);
   BEGIN
      IF x < 0 THEN
         IF x >= -40H THEN code[pc] := CHR(x+80H); INC(pc)
         ELSIF x >= -2000H THEN PutWord(x+0C000H)
         ELSE PutDbl(x)
         END
      ELSIF x < 40H THEN code[pc] := CHR(x); INC(pc)
      ELSIF x < 2000H THEN PutWord(x+8000H)
      ELSE PutDbl(x - 40000000H)
      END
   END PutDisp;

   PROCEDURE PutArg(VAR z: Argument);
   BEGIN
      CASE z.form OF
         0:   IF z.inx = 1 THEN code[pc] := CHR(z.d1); INC(pc)
               ELSIF z.inx = 2 THEN PutWord(z.d1)
               ELSIF z.inx = 4 THEN PutDbl(z.d1)
               ELSE PutDbl(z.d2); PutDbl(z.d1)
               END
      | 1:   PutDisp(z.d1)
      | 2,5:
      | 3,6: PutDisp(z.d1)
      | 4,7: PutDisp(z.d1); PutDisp(z.d2)
      END
   END PutArg;

   PROCEDURE PutF3*(op: INTEGER);
   BEGIN code[pc] := CHR(op); INC(pc); code[pc] := CHR(op DIV 100H); INC(pc)
   END PutF3;

   PROCEDURE Operand(VAR x: OCT.Item; VAR z: Argument);
      VAR F: INTEGER;

      PROCEDURE downlevel(VAR gen: INTEGER);
         VAR n, op: INTEGER; b: OCT.Item;
      BEGIN GetReg(b); n := level - x.lev; gen := SHORT(b.a0) + 8;
         op := SHORT(b.a0)*40H - 3FE9H;
         IF n = 1 THEN PutF3(op); PutDisp(8);  (*MOVD 8(FP) Rb*)
         ELSE PutF3(op - 4000H); PutDisp(8); PutDisp(8);  (*MOVD 8(8(FP)) Rb*)
            WHILE n > 2 DO DEC(n);
               PutF3((SHORT(b.a0)*20H + SHORT(b.a0))*40H + 4017H); PutDisp(8)
            END
         END ;
      END downlevel;

      PROCEDURE index;
         VAR s: LONGINT;
      BEGIN s := x.typ.size;
         IF s = 1 THEN z.gen := 1CH
         ELSIF s = 2 THEN z.gen := 1DH
         ELSIF s = 4 THEN z.gen := 1EH
         ELSIF s = 8 THEN z.gen := 1FH
         ELSE z.gen := 1CH; PutByte(F7); PutByte(x.a2 MOD 4 * 40H + 23H);
            PutByte(x.a2 DIV 4 + 0A0H); PutWord(0); PutWord(s)  (*MUL r s*)
       END ;
      END index;

   BEGIN F := x.mode;
      CASE x.mode OF
          Var:  IF x.lev = 0 THEN
                      z.gen := 1AH; z.d1 := x.a0; z.form := 3
                   ELSIF x.lev < 0 THEN (*EXT*)
                      z.gen := 16H; z.d1 := -x.lev; z.d2 := x.a0; z.form := 4
                   ELSIF x.lev = level THEN
                      z.gen := 18H; z.d1 := x.a0; z.form := 3
                   ELSIF x.lev+1 = level THEN
                      z.gen := 10H; z.d1 := 8; z.d2 := x.a0; z.form := 4
                   ELSE downlevel(z.gen); z.d1 := x.a0; z.form := 3
                   END
       | Ind:  IF x.lev = 0 THEN
                      z.gen := 12H; z.d1 := x.a0; z.d2 := x.a1; z.form := 4
                   ELSIF x.lev = level THEN
                      z.gen := 10H; z.d1 := x.a0; z.d2 := x.a1; z.form := 4
                   ELSE downlevel(z.gen);
                      PutF3((z.gen*20H + z.gen-8)*40H + 17H); PutDisp(x.a0);
                      z.d1 := x.a1; z.form := 3
                   END
       | RegI: z.gen := SHORT(x.a0)+8; z.d1 := x.a1; z.form := 3
       | VarX: index;
                   IF x.lev = 0 THEN
                      z.inx := 1AH; z.d1 := x.a0; z.form := 6
                   ELSIF x.lev < 0 THEN (*EXT*)
                      z.inx := 16H; z.d1 := -x.lev; z.d2 := x.a0; z.form := 7
                   ELSIF x.lev = level THEN
                      z.inx := 18H; z.d1 := x.a0; z.form := 6
                   ELSIF x.lev+1 = level THEN
                      z.inx := 10H;  z.d1 := 8; z.d2 := x.a0; z.form := 7
                   ELSE downlevel(z.inx); z.d1 := x.a0; z.form := 6
                   END ;
                   z.inx := z.inx*8 + SHORT(x.a2)
       | IndX: index;
                   IF x.lev = 0 THEN
                      z.inx := 12H; z.d1 := x.a0; z.d2 := x.a1; z.form := 7
                   ELSIF x.lev = level THEN
                      z.inx := 10H; z.d1 := x.a0; z.d2 := x.a1; z.form := 7
                   ELSE downlevel(z.inx);
                      PutF3((z.inx*20H + z.inx-8)*40H + 17H); PutDisp(x.a0);
                      z.d1 := x.a1; z.form := 6
                   END ;
                   z.inx := z.inx * 8 + SHORT(x.a2)
       | RegX: index; z.inx := SHORT((x.a0+8)*8 + x.a2); z.d1 := x.a1; z.form := 6
       | Con:  CASE x.typ.form OF
                      Undef, Byte, Bool, Char, SInt:
                         z.gen := 14H; z.inx := 1; z.d1 := x.a0; z.form := 0
                   | Int:
                         z.gen := 14H; z.inx := 2; z.d1 := x.a0; z.form := 0
                   | LInt, Real, Set, Pointer, ProcTyp, NilTyp:
                         z.gen := 14H; z.inx := 4; z.d1 := x.a0; z.form := 0
                   | LReal:
                         z.gen := 14H; z.inx := 8; z.d1 := x.a0; z.d2 := x.a1; z.form := 0
                   | String:
                         z.gen := 1AH; z.d1 := x.a0; z.form := 3
                   END
       | Reg:  z.gen := SHORT(x.a0); z.form := 2
       | Stk:  z.gen := 17H;  z.form := 2
       | Abs:  z.gen := 15H; z.form := 1; z.d1 := x.a0
       | Coc, Fld .. Head: OCS.Mark(126); x.mode := Var; z.form := 0
      END
   END Operand;

   PROCEDURE PutF0*(cond: LONGINT);
   BEGIN code[pc] := CHR(cond*10H + 10); INC(pc)
   END PutF0;

   PROCEDURE PutF1*(op: INTEGER);
   BEGIN code[pc] := CHR(op); INC(pc)
   END PutF1;

   PROCEDURE PutF2*(op: INTEGER; short: LONGINT; VAR x: OCT.Item);
      VAR dst: Argument;
   BEGIN Operand(x, dst);
      code[pc] := CHR(SHORT(short) MOD 2 * 80H + op); INC(pc);
      code[pc] := CHR(dst.gen*8 + SHORT(short) MOD 10H DIV 2);
      INC(pc);
      IF dst.form > 4 THEN code[pc] := CHR(dst.inx); INC(pc) END ;
      PutArg(dst)
   END PutF2;

   PROCEDURE PutF4*(op: INTEGER; VAR x, y: OCT.Item);
      VAR dst, src: Argument;
   BEGIN Operand(x, dst); Operand(y, src);
      code[pc] := CHR(dst.gen MOD 4 * 40H + op); INC(pc);
      code[pc] := CHR(src.gen*8 + dst.gen DIV 4); INC(pc);
      IF src.form > 4 THEN code[pc] := CHR(src.inx); INC(pc) END ;
      IF dst.form > 4 THEN code[pc] := CHR(dst.inx); INC(pc) END ;
      PutArg(src); PutArg(dst)
   END PutF4;

   PROCEDURE Put*(F, op: INTEGER; VAR x, y: OCT.Item);
      VAR dst, src: Argument;
   BEGIN Operand(x, dst); Operand(y, src); code[pc] := CHR(F); INC(pc);
      code[pc] := CHR(dst.gen MOD 4 * 40H + op); INC(pc);
      code[pc] := CHR(src.gen*8 + dst.gen DIV 4); INC(pc);
      IF src.form > 4 THEN code[pc] := CHR(src.inx); INC(pc) END ;
      IF dst.form > 4 THEN code[pc] := CHR(dst.inx); INC(pc) END ;
      PutArg(src); PutArg(dst)
   END Put;

   PROCEDURE AllocTypDesc*(typ: OCT.Struct);   (* typ.form = Record *)
   BEGIN INC(conx, (-conx) MOD 4); typ.mno := 0; typ.adr := conx;
      IF typ.n > MaxExts THEN OCS.Mark(233)
      ELSIF nofrec < MaxRecs THEN
         PtrTab[nofptrs] := conx; INC(nofptrs);
         RecTab[nofrec] := typ; INC(nofrec);
         AllocInt(0); AllocInt(0)
      ELSE OCS.Mark(223)
      END
   END AllocTypDesc;

   PROCEDURE InitTypDescs*;
      VAR x, y: OCT.Item; i: INTEGER; typ: OCT.Struct;
   BEGIN
      x.mode := Ind; x.lev := 0; y.mode := Var; i := 0;
      WHILE i < nofrec DO typ := RecTab[i]; INC(i); x.a0 := typ.adr;
         WHILE typ.BaseTyp # NIL DO (*initialization of base tag fields*)
            x.a1 := typ.n * 4; y.lev := -typ.mno; y.a0 := typ.adr; PutF4(17H, x, y);
            typ := typ.BaseTyp
         END
      END
   END InitTypDescs;

   PROCEDURE SaveRegisters*(VAR gR, fR: SET; VAR x: OCT.Item);
      VAR i, r, m: INTEGER; t: SET;
   BEGIN t := RegSet;
      IF x.mode IN {Reg, RegI, RegX} THEN EXCL(RegSet, x.a0) END ;
      IF x.mode IN {VarX, IndX, RegX} THEN EXCL(RegSet, x.a2) END ;
      gR := RegSet; fR := FRegSet;
      IF RegSet # {} THEN
         i := 0; r := 1; m := 0;
         REPEAT
            IF i IN RegSet THEN INC(m, r) END ;
            INC(r, r); INC(i)
         UNTIL i = 8;
         PutF1(62H); PutByte(m)
      END ;
      RegSet := t - RegSet; i := 0;
      WHILE FRegSet # {} DO
         IF i IN FRegSet THEN
            PutF1(F11); PutF3(i*800H + 5C4H); EXCL(FRegSet, i)
         END ;
         INC(i, 2)
      END
   END SaveRegisters;

   PROCEDURE RestoreRegisters*(gR, fR: SET; VAR x: OCT.Item);
      VAR i, r, m: INTEGER; y: OCT.Item;
   BEGIN RegSet := gR; FRegSet := fR; i := 8;
      (*set result mode*) x.mode := Reg; x.a0 := 0;
      IF (x.typ.form = Real) OR (x.typ.form = LReal) THEN
         IF 0 IN fR THEN GetFReg(y); Put(F11, 4, y, x); x.a0 := y.a0 END ;
         INCL(FRegSet, 0)
      ELSE
         IF 0 IN gR THEN GetReg(y); PutF4(17H, y, x); x.a0 := y.a0 END ;
         INCL(RegSet, 0)
      END ;
      WHILE fR # {} DO
         DEC(i, 2);
         IF i IN fR THEN
            PutF1(F11); PutF3(i*40H - 47FCH); EXCL(fR, i)
         END
      END ;
      IF gR # {} THEN
         i := 8; r := 1; m := 0;
         REPEAT DEC(i);
            IF i IN gR THEN INC(m, r) END ;
            INC(r, r)
         UNTIL i = 0;
         PutF1(72H); PutF1(m)
      END
   END RestoreRegisters;

   PROCEDURE DynArrAdr*(VAR x, y: OCT.Item);   (* x := ADR(y) *)
      VAR l, z: OCT.Item;
   BEGIN
      WHILE y.typ.form = DynArr DO   (* index with 0 *)
         IF y.mode = IndX THEN
            l.mode := Var; l.a0 := y.a0 + y.typ.adr; l.lev := y.lev;
            (* l = actual dimension length - 1 *)
            z.mode := Con; z.a0 := 0; z.typ := OCT.inttyp;
            Put(2EH, SHORT(y.a2)*8+5, z, l)   (* INDEXW inxreg, l, 0 *)
         END;
         y.typ := y.typ.BaseTyp
      END;
      IF (y.mode = Var) OR (y.mode = Ind) & (y.a1 = 0) THEN
         y.mode := Var; PutF4(17H, x, y)   (* MOVD *)
      ELSE PutF4(27H, x, y); x.a1 := 0   (* ADDR *)
      END
   END DynArrAdr;


   PROCEDURE Entry*(i: INTEGER): INTEGER;
   BEGIN RETURN entry[i]
   END Entry;

   PROCEDURE SetEntry*(i: INTEGER);
   BEGIN entry[i] := pc
   END SetEntry;

   PROCEDURE LinkAdr*(m: INTEGER; n: LONGINT): INTEGER;
   BEGIN
      IF lnkx >= LinkLength THEN OCS.Mark(231); lnkx := 0 END ;
      link[lnkx] := m*100H + SHORT(n); INC(lnkx); RETURN lnkx-1
   END LinkAdr;

   PROCEDURE SetLinkTable*(n: INTEGER);
   BEGIN (*base addresses of imported modules*) lnkx := 0;
      WHILE lnkx < n DO link[lnkx] := lnkx*100H + 255; INC(lnkx) END
   END SetLinkTable;

   PROCEDURE fixup*(loc: LONGINT);  (*enter pc at loc*)
      VAR x: LONGINT;
   BEGIN x := pc - loc + 8001H;
      code[loc] := CHR(x DIV 100H); code[loc+1] := CHR(x)
   END fixup;

   PROCEDURE fixupC*(loc: LONGINT);
      VAR x: LONGINT;
   BEGIN x := pc+1 - loc;
      IF x > 3 THEN
         IF x < 2000H THEN
            code[loc] := CHR(x DIV 100H + 80H); code[loc+1] := CHR(x)
         ELSE OCS.Mark(211)
         END
      ELSE DEC(pc, 3)
      END
   END fixupC;

   PROCEDURE fixupL*(loc: LONGINT);
      VAR x: LONGINT;
   BEGIN x := pc+1 - loc;
      IF x > 5 THEN
         code[loc+2] := CHR(x DIV 100H); code[loc+3] := CHR(x)
      ELSE DEC(pc, 5)
      END
   END fixupL;

   PROCEDURE FixLink*(L: LONGINT);
      VAR L1: LONGINT;
   BEGIN
      WHILE L # 0 DO
         L1 := ORD(code[L])*100H + ORD(code[L+1]);
         fixup(L); L := L1
      END
   END FixLink;

   PROCEDURE FixupWith*(L, val: LONGINT);
      VAR x: LONGINT;
   BEGIN x := val MOD 4000H + 8000H;
      IF ABS(val) >= 2000H THEN OCS.Mark(208) END ;
      code[L] := CHR(x DIV 100H); code[L+1] := CHR(x)
   END FixupWith;

   PROCEDURE FixLinkWith*(L, val: LONGINT);
      VAR L1: LONGINT;
   BEGIN
      WHILE L # 0 DO
         L1 := ORD(code[L])*100H + ORD(code[L+1]);
         FixupWith(L, val+1 - L); L := L1
      END
   END FixLinkWith;

   PROCEDURE MergedLinks*(L0, L1: LONGINT): LONGINT;
      VAR L2, L3: LONGINT;
   BEGIN (*merge chains of the two operands of AND and OR *)
      IF L0 # 0 THEN L2 := L0;
         LOOP L3 := ORD(code[L2])*100H + ORD(code[L2+1]);
            IF L3 = 0 THEN EXIT END ;
            L2 := L3
         END ;
         code[L2] := CHR(L1 DIV 100H); code[L2+1] := CHR(L1);
         RETURN L0
      ELSE RETURN L1
      END
   END MergedLinks;

   PROCEDURE Init*;
      VAR i: INTEGER;
   BEGIN pc := 0; level := 0; lnkx := 0; conx := 0; nofptrs := 0; nofrec := 0;
      RegSet := {}; FRegSet := {}; i := 0;
      REPEAT entry[i] := 0; INC(i) UNTIL i = EntryLength
   END Init;

   PROCEDURE OutCode*(VAR name, progid: ARRAY OF CHAR;
                  key: LONGINT; entno: INTEGER; datasize: LONGINT);
      CONST ObjMark = 0F8X;
      VAR ch: CHAR; f, i, m: INTEGER;
            K, s, s0, refpos: LONGINT;
            nofcom, comsize, align: INTEGER;
            obj:    OCT.Object;
            typ:    OCT.Struct;
            ObjFile:   Files.File;
            out:    Files.Rider;
            ComTab: ARRAY MaxComs OF OCT.Object;

      PROCEDURE W(n: INTEGER);
      BEGIN Files.Write(out, CHR(n)); Files.Write(out, CHR(n DIV 100H))
      END W;

      PROCEDURE WriteName(VAR name: ARRAY OF CHAR; n: INTEGER);
         VAR i: INTEGER; ch: CHAR;
      BEGIN i := 0;
         REPEAT ch := name[i]; Files.Write(out, ch); INC(i) UNTIL ch = 0X;
         WHILE i < n DO Files.Write(out, 0X); INC(i) END
      END WriteName;

      PROCEDURE FindPtrs(typ: OCT.Struct; adr: LONGINT);
         VAR fld: OCT.Object; btyp: OCT.Struct;
            i, n, s: LONGINT;
      BEGIN
         IF typ.form = Pointer THEN
            IF nofptrs < MaxPtrs THEN PtrTab[nofptrs] := adr; INC(nofptrs) ELSE OCS.Mark(222) END
         ELSIF typ.form = Record THEN
            btyp := typ.BaseTyp;
            IF btyp # NIL THEN FindPtrs(btyp, adr) END ;
            fld := typ.link;
            WHILE fld # NIL DO
               IF fld.name # "" THEN FindPtrs(fld.typ, fld.a0 + adr)
               ELSIF nofptrs < MaxPtrs THEN PtrTab[nofptrs] := fld.a0 + adr; INC(nofptrs)
               ELSE OCS.Mark(222)
               END ;
               fld := fld.next
            END
         ELSIF typ.form = Array THEN
            btyp := typ.BaseTyp; n := typ.n;
            WHILE btyp.form = Array DO n := btyp.n * n; btyp := btyp.BaseTyp END ;
            IF (btyp.form = Pointer) OR (btyp.form = Record) THEN
               i := 0; s := btyp.size;
               WHILE i < n DO FindPtrs(btyp, i*s + adr); INC(i) END
            END
         END
      END FindPtrs;

      PROCEDURE PtrsAndComs;
         VAR obj, par: OCT.Object; u: INTEGER;
      BEGIN obj := OCT.topScope.next;
         WHILE obj # NIL DO
            IF obj.mode = XProc THEN par := obj.dsc;
               IF entry[SHORT(obj.a0)] = 0 THEN OCS.Mark(129)
               ELSIF (obj.marked) & (obj.typ = OCT.notyp) &
                     ((par = NIL) OR (par.mode > 3) OR (par.a0 < 0)) THEN (*command*)
                  u := 0;
                  WHILE obj.name[u] > 0X DO INC(comsize); INC(u) END ;
                  INC(comsize, 3);
                  IF nofcom < MaxComs THEN ComTab[nofcom] := obj; INC(nofcom)
                  ELSE OCS.Mark(232); nofcom := 0; comsize := 0
                  END
               END
            ELSIF obj.mode = Var THEN
               FindPtrs(obj.typ, obj.a0)
            END ;
            obj := obj.next
         END
      END PtrsAndComs;

      PROCEDURE OutRefBlk(first: OCT.Object; pc: INTEGER; name: ARRAY OF CHAR);
         VAR obj: OCT.Object;
      BEGIN obj := first;
         WHILE obj # NIL DO
            IF obj.mode IN {LProc, XProc, IProc} THEN OutRefBlk(obj.dsc, obj.a2, obj.name) END ;
            obj := obj.next
         END ;
         Files.Write(out, 0F8X); Files.WriteBytes(out, pc, 2); WriteName(name, 0);
         obj := first;
         WHILE obj # NIL DO
            IF (obj.mode = Var) OR (obj.mode = Ind) THEN
               f := obj.typ.form;
               IF (f IN {Byte .. Set, Pointer})
                  OR (f = Array) & (obj.typ.BaseTyp.form = Char) THEN
                  Files.Write(out, CHR(obj.mode)); Files.Write(out, CHR(f));
                  Files.WriteBytes(out, obj.a0, 4); WriteName(obj.name, 0)
               END
            END ;
            obj:= obj.next
         END
      END OutRefBlk;

   BEGIN ObjFile := Files.New(name);
      IF ObjFile # NIL THEN
         Files.Set(out, ObjFile, 0);
         WHILE pc MOD 4 # 0 DO PutF1(0A2H) END ; (*NOP*)
         INC(conx, (-conx) MOD 4);
         nofcom := 0; comsize := 1;
         PtrsAndComs; align := comsize MOD 2; INC(comsize, align);
      (*header block*)
         Files.Write(out, ObjMark); Files.Write(out, "6"); W(0); W(0);
         W(entno); W(comsize); W(nofptrs); W(OCT.nofGmod);
         W(lnkx); Files.WriteBytes(out, datasize, 4); W(conx); W(pc);
         Files.WriteBytes(out, key, 4); WriteName(progid, 20);
      (*entry block*)
         Files.Write(out, 82X); Files.WriteBytes(out, entry, 2*entno);
      (*command block*)
         Files.Write(out, 83X);
         i := 0;  (*write command names and entry addresses*)
         WHILE i < nofcom DO
            obj := ComTab[i]; WriteName(obj.name, 0); W(entry[obj.a0]); INC(i)
         END ;
         Files.Write(out, 0X);
         IF align > 0 THEN Files.Write(out, 0FFX) END ;
      (*pointer block*)
         Files.Write(out, 84X); i := 0;
         WHILE i < nofptrs DO
            IF PtrTab[i] < -4000H THEN OCS.Mark(225) END ;
            Files.WriteBytes(out, PtrTab[i], 2); INC(i)
         END ;
      (*import block*)
         Files.Write(out, 85X); i := 0;
         WHILE i < OCT.nofGmod DO
            obj := OCT.GlbMod[i];
            Files.WriteBytes(out, obj.a1, 4); WriteName(obj.name, 0); Files.Write(out, 0X);
            INC(i)
         END ;
      (*link block*)
         Files.Write(out, 86X); Files.WriteBytes(out, link, 2*lnkx);
      (*data block*)
         Files.Write(out, 87X); Files.WriteBytes(out, constant, conx);
      (*code block*)
         Files.Write(out, 88X); Files.WriteBytes(out, code, pc);
      (*type block*)
         Files.Write(out, 89X); i := 0;
         WHILE i < nofrec DO
            typ := RecTab[i]; s := typ.size + 4; m := 4; s0 := 16;
            WHILE (m > 0) & (s > s0) DO INC(s0, s0); DEC(m) END ;
            IF s > s0 THEN s0 := (s+127) DIV 128 * 128 END ;
            nofptrs := 0; FindPtrs(typ, 0);
            s := nofptrs*2 + (MaxExts+1)*4; Files.WriteBytes(out, s, 2);  (*td size*)
            Files.WriteBytes(out, typ.adr, 2);               (*td adr*)
            K := LONG(nofptrs)*1000000H + s0; Files.WriteBytes(out, K, 4);
            K := 0; m := 0;
            REPEAT Files.WriteBytes(out, K, 4); INC(m) UNTIL m = MaxExts;
            m := 0;
            WHILE m < nofptrs DO
               Files.WriteBytes(out, PtrTab[m], 2); INC(m)
            END ;
            INC(i)
         END ;
      (*ref block*)
         refpos := Files.Pos(out); Files.Write(out, 8AX);
         OutRefBlk(OCT.topScope.next, pc, "$$");
         Files.Set(out, ObjFile, 2); Files.WriteBytes(out, refpos, 4);
          IF ~OCS.scanerr THEN Files.Register(ObjFile) END
      ELSE OCS.Mark(153)
      END
   END OutCode;

   PROCEDURE Close*;
      VAR i: INTEGER;
   BEGIN i := 0;
      WHILE i < MaxRecs DO RecTab[i] := NIL; INC(i) END
   END Close;

BEGIN NEW(wasderef)
END OCC.
