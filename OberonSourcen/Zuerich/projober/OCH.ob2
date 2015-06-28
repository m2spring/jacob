MODULE OCH;    (*NW 7.6.87 / 19.7.92*)

   IMPORT OCS, OCT, OCC;

   CONST
      (*instruction format prefixes*)
         F6 = 4EH; F7 = 0CEH; F9 = 3EH; F11 = 0BEH;

      (*object and item modes*)
         Var   =  1; VarX  =  2; Ind   =  3; IndX  =  4; RegI  =  5;
         RegX  =  6; Abs   =  7; Con   =  8; Stk   =  9; Coc   = 10;
         Reg   = 11; Fld   = 12; LProc = 14; XProc = 15;
         CProc = 17; IProc = 18; Mod   = 19;

      (*structure forms*)
         Undef = 0; Byte = 1; Bool = 2; Char = 3; SInt = 4; Int = 5; LInt = 6;
         Real = 7; LReal = 8; Set = 9; String = 10; NilTyp = 11; NoTyp = 12;
         Pointer = 13; ProcTyp = 14; Array = 15; DynArr = 16; Record = 17;

   TYPE LabelRange* = RECORD low*, high*: INTEGER; label*: INTEGER END ;

   VAR clrchk*: BOOLEAN;
      lengcode: ARRAY 18 OF INTEGER;

   PROCEDURE setCC(VAR x: OCT.Item; cc: LONGINT);
   BEGIN
      x.typ := OCT.booltyp; x.mode := Coc; x.a0 := cc; x.a1 := 0; x.a2 := 0
   END setCC;

   PROCEDURE AdjustSP(n: LONGINT);
   BEGIN  (*ADJSPB n*)
      IF n <= 127 THEN OCC.PutF3(-5A84H); OCC.PutByte(n)
      ELSE OCC.PutF3(-5A83H); OCC.PutWord(n)
      END
   END AdjustSP;

   PROCEDURE move(L: INTEGER; VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 7) & (y.a0 >= -8) THEN
         OCC.PutF2(L+5CH, y.a0, x)  (*MOVQi*)
      ELSE OCC.PutF4(L+14H, x, y)  (*MOVi*)
      END
   END move;

   PROCEDURE load(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN IF x.mode # Reg THEN y := x; OCC.GetReg(x); move(lengcode[x.typ.form], x, y) END
   END load;

   PROCEDURE moveBW(VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 7) & (y.a0 >= -8) THEN
         OCC.PutF2(5DH, y.a0, x)
      ELSE OCC.Put(F7, 10H, x, y)  (*MOVXBW*)
      END
   END moveBW;

   PROCEDURE moveBD(VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 7) & (y.a0 >= -8) THEN
         OCC.PutF2(5FH, y.a0, x)
      ELSE OCC.Put(F7, 1CH, x, y)  (*MOVXBD*)
      END
   END moveBD;

   PROCEDURE moveWD(VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 7) & (y.a0 >= -8) THEN
         OCC.PutF2(5FH, y.a0, x)
      ELSE OCC.Put(F7, 1DH, x, y)  (*MOVXWD*)
      END
   END moveWD;

   PROCEDURE Leng(VAR x: OCT.Item; L: LONGINT);
      VAR y: OCT.Item;
   BEGIN
      IF L <= 7 THEN OCC.PutF2(5FH, L, x)       (*MOVQD*)
      ELSE y.mode := Con; y.a0 := L;           (*MOVZBD*)
         IF L <= 255 THEN y.typ := OCT.sinttyp; OCC.Put(F7, 18H, x, y)
         ELSE y.typ := OCT.inttyp; OCC.Put(F7, 19H, x, y)
         END
      END
   END Leng;

   PROCEDURE MoveBlock(VAR x, y: OCT.Item; s: LONGINT; param: BOOLEAN);
      VAR L: INTEGER; z: OCT.Item;
   BEGIN
      IF s > 0 THEN
         IF param THEN
            s := (s+3) DIV 4 * 4; AdjustSP(s)
         END ;
         IF s <= 16 THEN
            OCC.Put(F7, 0, x, y); OCC.PutDisp(s-1)   (*MOVMB*)
         ELSE
            z.mode := Reg; z.a0 := 1; OCC.PutF4(27H, z, y);    (*ADDR y,R1*)
            z.a0 := 2; OCC.PutF4(27H, z, x); z.a0 := 0;        (*ADDR x,R2*)
            IF s MOD 4 = 0 THEN L := 3; s := s DIV 4
            ELSIF s MOD 2 = 0 THEN L := 1; s := s DIV 2
            ELSE L := 0
            END ;
            Leng(z, s);
            OCC.PutF1(14); OCC.PutByte(L); OCC.PutByte(0)      (*MOVS*)
         END
      END
   END MoveBlock;

   PROCEDURE DynArrBnd(ftyp, atyp: OCT.Struct; lev: INTEGER; adr: LONGINT; varpar: BOOLEAN);
      VAR f, s: INTEGER; x, y, z: OCT.Item;
   BEGIN (* ftyp.form = DynArr *)
      x.mode := Stk; y.mode := Var;
      IF varpar & (ftyp.BaseTyp.form = Byte) THEN
         IF atyp.form # DynArr THEN
            IF (atyp.form # Array) OR (atyp.BaseTyp.size > 1) THEN OCS.Mark(-1) END ;
            Leng(x, atyp.size-1)
         ELSE y.lev := lev; y.a0 := adr + atyp.adr; y.typ := OCT.linttyp;
            atyp := atyp.BaseTyp;
            IF atyp.form # DynArr THEN
               IF atyp.size > 1 THEN
                  OCS.Mark(-1); z.mode := Con; z.typ := OCT.linttyp; z.a0 := atyp.size;
                  load(y); OCC.Put(F7, 23H, y, z);   (* MULD z, Ry *)
                  z.mode := Con; z.typ := OCT.linttyp; z.a0 := atyp.size-1;
                  IF z.a0 < 8 THEN OCC.PutF2(0FH, z.a0, y)   (* ADDQD size-1, Ry *)
                  ELSE OCC.PutF4(3, y, z)   (* ADDD size-1, Ry *)
                  END
               END
            ELSE OCS.Mark(-1); load(y); OCC.PutF2(0FH, 1, y);
               REPEAT z.mode := Var; z.lev := lev; z.a0 := atyp.adr + adr; z.typ := OCT.linttyp;
                  load(z); OCC.PutF2(0FH, 1, z);   (* ADDQD 1, Rz *)
                  OCC.Put(F7, 23H, y, z);   (* MULD Rz, Ry *)
                  atyp := atyp.BaseTyp
               UNTIL atyp.form # DynArr;
               IF atyp.size > 1 THEN
                  z.mode := Con; z.typ := OCT.linttyp; z.a0 := atyp.size;
                  OCC.Put(F7, 23H, y, z)   (* MULD z, Ry *)
               END ;
               OCC.PutF2(0FH, -1, y)   (* ADDQD -1, Ry *)
            END ;
            OCC.PutF4(17H, x, y)   (* MOVD apdynarrlen-1, TOS *)
         END
      ELSE
         LOOP f := atyp.form;
            IF f = Array THEN y.lev := -atyp.mno; y.a0 := atyp.adr
            ELSIF f = DynArr THEN y.lev := lev; y.a0 := atyp.adr + adr
            ELSE OCS.Mark(66); EXIT
            END ;
            OCC.PutF4(17H, x, y); ftyp := ftyp.BaseTyp; atyp := atyp.BaseTyp;
            IF ftyp.form # DynArr THEN
               IF ftyp # atyp THEN OCS.Mark(67) END ;
               EXIT
            END
         END
      END
   END DynArrBnd;

   PROCEDURE Trap*(n: INTEGER);
   BEGIN OCC.PutF1(0F2H); OCC.PutByte(n)  (*BPT n*)
   END Trap;

   PROCEDURE CompareParLists*(x, y: OCT.Object);
      VAR xt, yt: OCT.Struct;
   BEGIN
      WHILE x # NIL DO
         IF y # NIL THEN
            xt := x.typ; yt := y.typ;
            WHILE (xt.form = DynArr) & (yt.form = DynArr) DO
               xt := xt.BaseTyp; yt := yt.BaseTyp
            END ;
            IF x.mode # y.mode THEN OCS.Mark(115)
            ELSIF xt # yt THEN
               IF (xt.form = ProcTyp) & (yt.form = ProcTyp) THEN
                  CompareParLists(xt.link, yt.link)
               ELSE OCS.Mark(115)
               END
            END ;
            y := y.next
         ELSE OCS.Mark(116)
         END ;
         x := x.next
      END ;
      IF (y # NIL) & (y.mode <= Ind) & (y.a0 > 0) THEN OCS.Mark(117) END
   END CompareParLists;

   PROCEDURE Assign*(VAR x, y: OCT.Item; param: BOOLEAN);
      VAR f, g, L, u: INTEGER; s, vsz: LONGINT;
            p, q: OCT.Struct;
            xp, yp: OCT.Object;
            tag, tdes: OCT.Item;
   BEGIN f := x.typ.form; g := y.typ.form;
      IF x.mode = Con THEN OCS.Mark(56)
      ELSIF (x.mode IN {Var, VarX}) & (x.lev < 0) THEN OCS.Mark(-3)
      END ;
      CASE f OF
      Undef, String:
   | Byte: IF g IN {Undef, Byte, Char, SInt} THEN
                  IF param THEN moveBD(x, y) ELSE move(0, x, y) END
               ELSE OCS.Mark(113)
               END

   | Bool: IF param THEN u := 3 ELSE u := 0 END ;
               IF y.mode = Coc THEN
                  IF (y.a1 = 0) & (y.a2 = 0) THEN OCC.PutF2(u+3CH, y.a0, x)
                  ELSE
                     IF ODD(y.a0) THEN OCC.PutF0(y.a0-1) ELSE OCC.PutF0(y.a0+1) END ;
                     OCC.PutWord(y.a2); y.a2 := OCC.pc-2;
                     OCC.FixLink(y.a1); OCC.PutF2(u+5CH, 1, x);
                     OCC.PutF0(14); L := OCC.pc; OCC.PutWord(0);
                     OCC.FixLink(y.a2); OCC.PutF2(u+5CH, 0, x); OCC.fixup(L)
                  END
               ELSIF g = Bool THEN
                  IF y.mode = Con THEN OCC.PutF2(u+5CH, y.a0, x)
                  ELSIF param THEN OCC.Put(F7, 18H, x, y)  (*MOVZBD*)
                  ELSE OCC.PutF4(14H, x, y)
                  END
               ELSE OCS.Mark(113)
               END

   | Char, SInt:
               IF g = f THEN
                  IF param THEN moveBD(x, y) ELSE move(0, x, y) END
               ELSE OCS.Mark(113)
               END

   | Int:  IF g = Int THEN
                  IF param THEN moveWD(x, y) ELSE move(1, x, y) END
               ELSIF g = SInt THEN
                  IF param THEN moveBD(x, y) ELSE moveBW(x, y) END
               ELSE OCS.Mark(113)
               END

   | LInt: IF g = LInt THEN move(3, x, y)
               ELSIF g = Int THEN moveWD(x, y)
               ELSIF g = SInt THEN moveBD(x, y)
               ELSE OCS.Mark(113)
               END

   | Real: IF g = Real THEN OCC.Put(F11, 5, x, y)
               ELSIF (SInt <= g) & (g <= LInt) THEN OCC.Put(F9, lengcode[g]+4, x, y)
               ELSE OCS.Mark(113)
               END

   | LReal:IF g = LReal THEN OCC.Put(F11, 4, x, y)
               ELSIF g = Real THEN OCC.Put(F9, 1BH, x, y)
               ELSIF (SInt <= g) & (g <= LInt) THEN OCC.Put(F9, lengcode[g], x, y)
               ELSE OCS.Mark(113)
               END

   | Set:  IF g = f THEN move(3, x, y) ELSE OCS.Mark(113) END

   | Pointer:
               IF x.typ = y.typ THEN move(3, x, y)
               ELSIF g = NilTyp THEN OCC.PutF2(5FH, 0, x)
               ELSIF g = Pointer THEN
                  p := x.typ.BaseTyp; q := y.typ.BaseTyp;
                  IF (p.form = Record) & (q.form = Record) THEN
                     WHILE (q # p) & (q # NIL) DO q := q.BaseTyp END ;
                     IF q # NIL THEN move(3, x, y) ELSE OCS.Mark(113) END
                  ELSE OCS.Mark(113)
                  END
               ELSE OCS.Mark(113)
               END

   | Array: s := x.typ.size;
               IF x.typ = y.typ THEN MoveBlock(x, y, s, param)
               ELSIF (g = String) & (x.typ.BaseTyp = OCT.chartyp) THEN
                     s := y.a1; vsz := x.typ.n;  (*check length of string*)
                     IF s > vsz THEN OCS.Mark(114) END ;
                     IF param THEN
                        vsz := (vsz+3) DIV 4 - (s+3) DIV 4;
                        IF vsz > 0 THEN AdjustSP(vsz*4) END
                     END ;
                     MoveBlock(x, y, s, param)
               ELSE OCS.Mark(113)
               END

   | DynArr: s := x.typ.size;
               IF param THEN (*formal parameter is open array*)
                  IF (g = String) & (x.typ.BaseTyp.form = Char) THEN Leng(x, y.a1-1)
                  ELSIF y.mode >= Abs THEN OCS.Mark(59)
                  ELSE DynArrBnd(x.typ, y.typ, y.lev, y.a0, FALSE)
                  END ;
                  IF g = DynArr THEN OCC.DynArrAdr(x, y)
                  ELSE OCC.PutF4(27H, x, y)
                  END
               ELSE OCS.Mark(113)
               END

   | Record: s := x.typ.size;
               IF x.typ # y.typ THEN
                  IF g = Record THEN
                     q := y.typ.BaseTyp;
                     WHILE (q # NIL) & (q # x.typ) DO q := q.BaseTyp END ;
                     IF q = NIL THEN OCS.Mark(113) END
                  ELSE OCS.Mark(113)
                  END
               END;
               IF OCC.typchk & ~param &
                  ( ((x.mode = Ind) OR (x.mode = RegI)) & (x.obj = OCC.wasderef)   (* p^ := *)
                     OR (x.mode = Ind) & (x.obj # NIL) & (x.obj # OCC.wasderef) )   (* varpar := *) THEN
                  tag := x; tdes.mode := Var; tdes.lev := -x.typ.mno; tdes.a0 := x.typ.adr;
                  IF x.obj = OCC.wasderef THEN tag.a1 := - 4
                  ELSE tag.mode := Var; INC(tag.a0, 4)
                  END;
                  OCC.PutF4(7, tdes, tag);   (* CMPD tag, tdes *)
                  OCC.PutF0(0); OCC.PutDisp(4);   (* BEQ continue *)
                  OCC.PutF1(0F2H); OCC.PutByte(19)   (* BPT 19 *)
               END;
               MoveBlock(x, y, s, param)

   | ProcTyp:
               IF (x.typ = y.typ) OR (y.typ = OCT.niltyp) THEN OCC.PutF4(17H, x, y)
               ELSIF (y.mode = XProc) OR (y.mode = IProc) THEN
                  (*procedure y to proc. variable x; check compatibility*)
                  IF x.typ.BaseTyp = y.typ THEN
                     CompareParLists(x.typ.link, y.obj.dsc);
                     IF y.a1 = 0 THEN
                        y.a1 := OCC.LinkAdr(-y.lev, y.a0); y.obj.a1 := y.a1
                     END ;
                     y.mode := Var; y.lev := SHORT(-y.a1); y.a0 := 0;
                     OCC.PutF4(27H, x, y)   (*LXPD*)
                  ELSE OCS.Mark(118)
                  END
               ELSIF y.mode = LProc THEN OCS.Mark(119)
               ELSE OCS.Mark(111)
               END
   | NoTyp, NilTyp: OCS.Mark(111)
      END
   END Assign;


   PROCEDURE FJ*(VAR loc: INTEGER);
   BEGIN OCC.PutF0(14); OCC.PutWord(loc); loc := OCC.pc-2
   END FJ;

   PROCEDURE CFJ*(VAR x: OCT.Item; VAR loc: INTEGER);
   BEGIN
      IF x.typ.form = Bool THEN
         IF x.mode # Coc THEN OCC.PutF2(1CH, 1, x); setCC(x, 0) END
      ELSE OCS.Mark(120); setCC(x, 0)
      END ;
      IF ODD(x.a0) THEN OCC.PutF0(x.a0-1) ELSE OCC.PutF0(x.a0+1) END ;
      loc := OCC.pc; OCC.PutWord(x.a2); OCC.FixLink(x.a1)
   END CFJ;

   PROCEDURE BJ*(loc: INTEGER);
   BEGIN OCC.PutF0(14); OCC.PutDisp(loc - OCC.pc + 1)
   END BJ;

   PROCEDURE CBJ*(VAR x: OCT.Item; loc: INTEGER);
   BEGIN
      IF x.typ.form = Bool THEN
         IF x.mode # Coc THEN OCC.PutF2(1CH, 1, x); setCC(x,0) END
      ELSE OCS.Mark(120); setCC(x, 0)
      END ;
      IF ODD(x.a0) THEN OCC.PutF0(x.a0-1) ELSE OCC.PutF0(x.a0+1) END ;
      OCC.PutDisp(loc - OCC.pc + 1);
      OCC.FixLinkWith(x.a2, loc); OCC.FixLink(x.a1)
   END CBJ;

   PROCEDURE LFJ*(VAR loc: INTEGER);
   BEGIN OCC.PutF0(14); OCC.PutWord(-4000H); OCC.PutWord(0); loc := OCC.pc-4
   END LFJ;


   PROCEDURE PrepCall*(VAR x: OCT.Item; VAR fpar: OCT.Object);
   BEGIN
      IF (x.mode = LProc) OR (x.mode = XProc) OR (x.mode = CProc) THEN
         fpar := x.obj.dsc
      ELSIF (x.typ # NIL) & (x.typ.form = ProcTyp) THEN
         fpar := x.typ.link
      ELSE OCS.Mark(121); fpar := NIL; x.typ := OCT.undftyp
      END
   END PrepCall;

   PROCEDURE Param*(VAR ap: OCT.Item; f: OCT.Object);
      VAR q: OCT.Struct; fp, tag: OCT.Item;
   BEGIN fp.mode := Stk; fp.typ := f.typ;
      IF f.mode = Ind THEN (*VAR parameter*)
         IF ap.mode >= Con THEN OCS.Mark(122) END ;
         IF fp.typ.form = DynArr THEN
            DynArrBnd(fp.typ, ap.typ, ap.lev, ap.a0, TRUE);
            IF ap.typ.form = DynArr THEN OCC.DynArrAdr(fp, ap)
            ELSE OCC.PutF4(27H, fp, ap)
            END
         ELSIF (fp.typ.form = Record) & (ap.typ.form = Record) THEN
            q := ap.typ;
            WHILE (q # fp.typ) & (q # NIL) DO q := q.BaseTyp END ;
            IF q # NIL THEN
               IF (ap.mode = Ind) & (ap.obj # NIL) & (ap.obj # OCC.wasderef) THEN (*actual par is VAR-par*)
                  ap.mode := Var; ap.a0 := ap.a0 + 4; OCC.PutF4(17H, fp, ap);
                  ap.a0 := ap.a0 - 4; OCC.PutF4(17H, fp, ap)
               ELSIF ((ap.mode = Ind) OR (ap.mode = RegI)) & (ap.obj = OCC.wasderef) THEN (*actual par is p^*)
                  ap.a1 := - 4; OCC.PutF4(17H, fp, ap);
                  IF ap.mode = Ind THEN ap.mode := Var ELSE ap.mode := Reg END;
                  OCC.PutF4(17H, fp, ap)
               ELSE
                  tag.mode := Var; tag.lev := -ap.typ.mno; tag.a0 := ap.typ.adr;
                  OCC.PutF4(17H, fp, tag); OCC.PutF4(27H, fp, ap)
               END
            ELSE OCS.Mark(111)
            END
         ELSIF (ap.typ = fp.typ) OR ((fp.typ.form = Byte) & (ap.typ.form IN {Char, SInt})) THEN
            IF (ap.mode = Ind) & (ap.a1 = 0) THEN (*actual var par*)
               ap.mode := Var; OCC.PutF4(17H, fp, ap)
            ELSE OCC.PutF4(27H, fp, ap)
            END
         ELSE OCS.Mark(123)
         END
      ELSE Assign(fp, ap, TRUE)
      END
   END Param;

   PROCEDURE Call*(VAR x: OCT.Item);
      VAR stk, sL: OCT.Item;
   BEGIN
      IF x.mode = LProc THEN
         IF x.lev > 0 THEN
            sL.mode := Var; sL.typ := OCT.linttyp; sL.lev := x.lev; sL.a0 := 0;
            stk.mode := Stk; OCC.PutF4(27H, stk, sL)  (*static link*)
         END ;
         OCC.PutF1(2); OCC.PutDisp(x.a0 - OCC.pc + 1)  (*BSR*)
      ELSIF x.mode = XProc THEN
         IF x.a1 = 0 THEN
            x.a1 := OCC.LinkAdr(-x.lev, x.a0); x.obj.a1 := x.a1
         END ;
         OCC.PutF1(22H); OCC.PutDisp(SHORT(x.a1))     (*CXP*)
      ELSIF (x.mode < Con) & (x.typ # OCT.undftyp) THEN   (*CXPD*)
         OCC.PutF2(7FH, 0, x); x.typ := x.typ.BaseTyp
      ELSIF x.mode = CProc THEN
         OCC.PutF1(0E2H); OCC.PutByte(x.a0)            (*SVC n*)
      ELSE OCS.Mark(121)
      END
      (*function result is marked when restoring registers*)
   END Call;

   PROCEDURE Enter*(mode: SHORTINT; pno: LONGINT; VAR L: INTEGER);
   BEGIN
      IF mode # LProc THEN OCC.SetEntry(SHORT(pno)) END ;
      OCC.PutF1(82H);  (*ENTER*)
      IF mode = IProc THEN OCC.PutByte(0C0H) ELSE OCC.PutByte(0) END ;
      IF mode = Mod THEN OCC.PutByte(0)
      ELSIF clrchk THEN
         OCC.PutByte(0); OCC.PutF3(-57D9H); L := OCC.pc; OCC.PutWord(0);  (*ADDR @n, R0*)
         OCC.PutF3(-47A1H); OCC.PutF3(64DH); OCC.PutDisp(-2)   (*MOVQD 0, TOS;  ACBW -4, R0, -2*)
      ELSE L := OCC.pc; OCC.PutWord(0)
      END
   END Enter;

   PROCEDURE CopyDynArray*(adr: LONGINT; typ: OCT.Struct);
      VAR size, ptr, m2, tos: OCT.Item; add: SHORTINT;

      PROCEDURE DynArrSize(typ: OCT.Struct);
         VAR len: OCT.Item;
      BEGIN
         IF typ.form = DynArr THEN DynArrSize(typ.BaseTyp);
            len.mode := Var; len.lev := OCC.level; len.typ := OCT.linttyp;
            len.a0 := adr + typ.adr; load(len);
            IF (size.mode # Con) OR (size.a0 # 1) THEN
               IF add = 4 THEN OCC.PutF2(0FH, 1, size) END; (* ADDQD 1, size *)
               OCC.PutF2(0FH, 1, len); add := 3;   (* ADDQD 1, len *)
               OCC.Put(F7, 23H, len, size)   (* MULD size, len *)
            ELSE add := 4
            END;
            size := len
         ELSE size.mode := Con; size.typ := OCT.linttyp; size.a0 := typ.size
         END
      END DynArrSize;

   BEGIN add := 3;
      DynArrSize(typ);   (* load total byte size of dyn array *)
      OCC.PutF2(0FH, add, size);   (* ADDQD 3 or 4, size *)
      m2.mode := Con; m2.typ := OCT.sinttyp;
      m2.a0 := -2; OCC.Put(F6, 7, size, m2);   (* ASHD -2, size *)
      ptr.mode := Var; ptr.lev := OCC.level; ptr.typ := OCT.linttyp;
      ptr.a0 := adr; load(ptr);
      ptr.mode := RegX; ptr.a1 := -4; ptr.a2 := size.a0; tos.mode := Stk;
      OCC.PutF4(17H, tos, ptr);   (* loop:   MOVD -4(ptr)[size:D], TOS *)
      OCC.PutF2(4FH, -1, size); OCC.PutDisp(-4);   (* ACBD -1, size, loop *)
      OCC.PutF3(-31D9H); OCC.PutDisp(0); OCC.PutDisp(adr);   (* ADDR 0(SP), adr(FP) *)
      OCC.FreeRegs({})
   END CopyDynArray;

   PROCEDURE Result*(VAR x: OCT.Item; typ: OCT.Struct);
      VAR res: OCT.Item;
   BEGIN res.mode := Reg; res.typ := typ; res.a0 := 0;
      Assign(res, x, FALSE)
   END Result;

   PROCEDURE Return*(mode: INTEGER; psize: LONGINT);
   BEGIN OCC.PutF1(92H);                                     (*EXIT*)
      IF mode = LProc THEN
         OCC.PutByte(0); OCC.PutF1(12H); OCC.PutDisp(psize-8)  (*RET*)
      ELSIF mode = XProc THEN
         OCC.PutByte(0); OCC.PutF1(32H); OCC.PutDisp(psize-12) (*RXP*)
      ELSIF mode = IProc THEN
         OCC.PutByte(3); OCC.PutF1(42H); OCC.PutDisp(0)        (*RETT 0*)
      END
   END Return;

   PROCEDURE CaseIn*(VAR x: OCT.Item; VAR L0, L1: INTEGER);
      VAR f: INTEGER; r, x0, lim: OCT.Item;
   BEGIN f := x.typ.form;
      IF f # Int THEN
         IF f = Char THEN
            x0 := x; OCC.GetReg(x); OCC.Put(F7, 14H, x, x0)  (*MOVZBW*)
         ELSIF f = SInt THEN
            x0 := x; OCC.GetReg(x); OCC.Put(F7, 10H, x, x0)  (*MOVXBW*)
         ELSIF f # LInt THEN OCS.Mark(125)
         END ;
         f := Int
      END ;
      IF (x.mode IN {VarX, IndX, RegX}) OR (x.mode # Reg) & (x.lev > 0) & (x.lev < OCC.level) THEN
         x0 := x; OCC.GetReg(x); OCC.PutF4(15H, x, x0)  (*MOVW*)
      END ;
      L0 := OCC.pc+3;   (*fixup loc for bounds adr*)
      lim.mode := Var; lim.typ := OCT.inttyp; lim.lev := 0; lim.a0 := 100H;
      OCC.GetReg(r); OCC.Put(0EEH, SHORT(r.a0)*8 + 1, x, lim);   (*CHECK*)
      OCC.PutF0(8); OCC.PutWord(0); L1 := OCC.pc;         (*BFS*)
      lim.mode := VarX; lim.a2 := r.a0; OCC.PutF2(7DH, 14, lim)  (*CASE*)
   END CaseIn;

   PROCEDURE CaseOut*(L0, L1, L2, L3, n: INTEGER;
                               VAR tab: ARRAY OF LabelRange);
      VAR i, j, lim: INTEGER; k: LONGINT;
   BEGIN (*generate jump table*)
      IF n > 0 THEN OCC.AllocBounds(tab[0].low, tab[n-1].high, k)
      ELSE (*no cases*) OCC.AllocBounds(1, 0, k)
      END ;
      j := SHORT(k);
      OCC.FixupWith(L0, j);         (*bounds address in check*)
      OCC.FixupWith(L1-2, L2-L1+3); (*out of bounds jump addr*)
      OCC.FixupWith(L1+3, j+4);     (*jump address to table*)
      i := 0; j := tab[0].low;
      WHILE i < n DO
         lim := tab[i].high;
         WHILE j < tab[i].low DO
            OCC.AllocInt(L2-L1); INC(j)  (*else*)
         END ;
         WHILE j <= lim DO
            OCC.AllocInt(tab[i].label-L1); INC(j)
         END ;
         INC(i)
      END ;
      OCC.FixLink(L3)
   END CaseOut;

BEGIN
   lengcode[Undef] := 0;
   lengcode[Byte] := 0;
   lengcode[Bool] := 0;
   lengcode[Char] := 0;
   lengcode[SInt] := 0;
   lengcode[Int] := 1;
   lengcode[LInt] := 3;
   lengcode[Real] := 1;
   lengcode[LReal] := 0;
   lengcode[Set] := 3;
   lengcode[String] := 0;
   lengcode[NilTyp] := 3;
   lengcode[ProcTyp] := 3;
   lengcode[Pointer] := 3;
   lengcode[Array] := 1;
   lengcode[DynArr] := 1;
   lengcode[Record] := 1;
END OCH.
