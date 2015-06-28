MODULE OCE;  (*NW 7.6.87 / 5.3.91*)

   IMPORT SYSTEM, OCS, OCT, OCC;

   CONST
      (*instruction formats*)
         F6 = 4EH; F7 = 0CEH; F9 = 3EH; F11 = 0BEH;

      (*object and item modes*)
         Var   =  1; VarX  =  2; Ind   =  3; IndX  =  4; RegI  =  5;
         RegX  =  6; Abs   =  7; Con   =  8; Stk   =  9; Coc   = 10;
         Reg   = 11; Fld   = 12; Typ   = 13;

      (*structure forms*)
         Undef = 0; Byte = 1; Bool = 2; Char = 3; SInt = 4; Int = 5; LInt = 6;
         Real = 7; LReal = 8; Set = 9; String = 10; NilTyp = 11; NoTyp = 12;
         Pointer = 13; ProcTyp = 14; Array = 15; DynArr = 16; Record = 17;

      (*frequent operation codes:   5C, 5D, 5F = MOVQi, 14, 15, 17 = MOVi, 27 = ADDR*)

   VAR inxchk*: BOOLEAN;
         log: INTEGER;   (*side effect of mant*)
         lengcode: ARRAY 18 OF INTEGER;
         intSet, realSet: SET;

   PROCEDURE inverted(x: LONGINT): LONGINT;
   BEGIN (*inverted sense of condition code*)
      IF ODD(x) THEN RETURN x-1 ELSE RETURN x+1 END
   END inverted;

   PROCEDURE load(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN
      IF x.mode < Reg THEN
         y := x; OCC.GetReg(x);
         IF (y.mode = Con) & (-8 <= y.a0) & (y.a0 <= 7) THEN
            OCC.PutF2(lengcode[x.typ.form] + 5CH, y.a0, x)
         ELSE OCC.PutF4(lengcode[x.typ.form] + 14H, x, y)
         END
      ELSIF x.mode > Reg THEN OCS.Mark(126)
      END
   END load;

   PROCEDURE loadX(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN
      IF x.mode <= Reg THEN
         y := x; OCC.GetReg(x);
         IF (y.mode = Con) & (-8 <= y.a0) & (y.a0 <= 7) THEN
            OCC.PutF2(5FH, y.a0, x)
         ELSE OCC.Put(F7, lengcode[x.typ.form] + 1CH, x, y)  (*MOVXiD*)
         END
      ELSIF x.mode > Reg THEN OCS.Mark(126)
      END
   END loadX;

   PROCEDURE loadF(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN
      IF x.mode < Reg THEN
         y := x; OCC.GetFReg(x); OCC.Put(F11, lengcode[x.typ.form] + 4, x, y)  (*MOVf*)
      ELSIF x.mode > Reg THEN OCS.Mark(126)
      END
   END loadF;

   PROCEDURE loadB(VAR x: OCT.Item);  (*Coc-Mode*)
      VAR L0, L1: LONGINT;
   BEGIN
      IF (x.a1 = 0) & (x.a2 = 0) THEN
         L0 := x.a0; OCC.GetReg(x); OCC.PutF2(3CH, L0, x)
      ELSE OCC.PutF0(inverted(x.a0)); OCC.PutWord(x.a2); L0 := OCC.pc - 2;
         OCC.FixLink(x.a1); OCC.GetReg(x); OCC.PutF2(5CH, 1, x);
         OCC.PutF0(14); L1 := OCC.pc; OCC.PutWord(0);
         OCC.FixLink(L0); OCC.PutF2(5CH, 0, x); OCC.fixup(L1)
      END
   END loadB;

   PROCEDURE loadAdr(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN
      IF x.mode < Con THEN
         y := x; OCC.GetReg(x);
         IF (y.mode = Ind) & (y.a1 = 0) THEN y.mode := Var; OCC.PutF4(17H, x, y)
         ELSE OCC.PutF4(27H, x, y); x.a1 := 0
         END ;
         x.mode := RegI; x.obj := NIL
      ELSE OCS.Mark(127)
      END
   END loadAdr;

   PROCEDURE setCC(VAR x: OCT.Item; cc: LONGINT);
   BEGIN
      x.typ := OCT.booltyp; x.mode := Coc; x.a0 := cc; x.a1 := 0; x.a2 := 0
   END setCC;

   PROCEDURE cmp(L: INTEGER; VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 7) & (y.a0 >= -8) THEN
         OCC.PutF2(L+1CH, y.a0, x)  (*CMPQi*)
      ELSE OCC.PutF4(L+4, x, y)   (*CMPi*)
      END
   END cmp;

   PROCEDURE add(L: INTEGER; VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 7) & (y.a0 >= -8) THEN
         OCC.PutF2(L+0CH, y.a0, x)   (*ADDQi*)
      ELSE OCC.PutF4(L, x, y)   (*ADDi*)
      END
   END add;

   PROCEDURE sub(L: INTEGER; VAR x, y: OCT.Item);
   BEGIN
      IF (y.mode = Con) & (y.a0 <= 8) & (y.a0 >= -7) THEN
         OCC.PutF2(L+0CH, -y.a0, x)   (*ADDQi*)
      ELSE OCC.PutF4(L+20H, x, y)   (*SUBi*)
      END
   END sub;

   PROCEDURE mant(x: LONGINT): LONGINT;  (*x DIV 2^log*)
   BEGIN log := 0;
      IF x > 0 THEN
         WHILE ~ODD(x) DO x := x DIV 2; INC(log) END
      END ;
      RETURN x
   END mant;

   PROCEDURE SetIntType*(VAR x: OCT.Item);
      VAR v: LONGINT;
   BEGIN v := x.a0;
      IF (-80H <= v) & (v <= 7FH) THEN x.typ := OCT.sinttyp
      ELSIF (-8000H <= v) & (v <= 7FFFH) THEN x.typ := OCT.inttyp
      ELSE x.typ := OCT.linttyp
      END
   END SetIntType;

   PROCEDURE AssReal*(VAR x: OCT.Item; y: REAL);
   BEGIN SYSTEM.PUT(SYSTEM.ADR(x.a0), y)
   END AssReal;

   PROCEDURE AssLReal*(VAR x: OCT.Item; y: LONGREAL);
   BEGIN SYSTEM.PUT(SYSTEM.ADR(x.a0), y)
   END AssLReal;

   PROCEDURE Index*(VAR x, y: OCT.Item);
      VAR  f, n: INTEGER; i: LONGINT;
         eltyp: OCT.Struct; y1, z: OCT.Item;
   BEGIN f := y.typ.form;
      IF ~(f IN intSet) THEN OCS.Mark(80); y.typ := OCT.inttyp END ;
      IF x.typ = NIL THEN HALT(80) END ;
      IF x.typ.form = Array THEN
         eltyp := x.typ.BaseTyp; n := x.typ.n;
         IF eltyp = NIL THEN HALT(81) END ;
         IF y.mode = Con THEN
            IF (0 <= y.a0) & (y.a0 < n) THEN i := y.a0 * eltyp.size ELSE OCS.Mark(81); i := 0 END ;
            IF x.mode = Var THEN INC(x.a0, i)
            ELSIF (x.mode = Ind) OR (x.mode = RegI) THEN INC(x.a1, i); x.obj := NIL
            ELSE loadAdr(x); x.a1 := i
            END
         ELSE
            IF inxchk THEN  (*z = bound descr*)
               z.mode := Var; z.a0 := x.typ.adr; z.lev := -x.typ.mno;
               IF y.mode = Reg THEN y1 := y ELSE OCC.GetReg(y1) END ;
               IF f = SInt THEN OCC.Put(F7, 10H, y1, y); y := y1 END ;  (*MOVXBW*)
               OCC.Put(0EEH, SHORT(y1.a0)*8+1, y, z); OCC.PutF1(0D2H) (*CHECK, FLAG*)
            ELSE
               IF f = LInt THEN load(y) ELSE loadX(y) END ;
               y1 := y
            END ;
            f := x.mode;
            IF x.mode = Var THEN x.mode := VarX; x.a2 := y1.a0
            ELSIF x.mode = Ind THEN x.mode := IndX; x.a2 := y1.a0
            ELSIF x.mode = RegI THEN x.mode := RegX; x.a2 := y1.a0
            ELSIF x.mode IN {VarX, IndX, RegX} THEN
               z.mode := Con; z.typ := OCT.inttyp;
               z.a0 := (x.typ.size DIV eltyp.size) - 1;
               OCC.Put(2EH, SHORT(x.a2)*8+5, y1, z)  (*INDEX*)
            ELSE loadAdr(x); x.mode := RegX; x.a1 := 0; x.a2 := y1.a0
            END
         END ;
         x.typ := eltyp
      ELSIF x.typ.form = DynArr THEN
         IF inxchk THEN
            z.mode := Var; z.a0 := x.a0 + x.typ.adr; z.lev := x.lev;
            IF y.mode = Reg THEN y1 := y ELSE OCC.GetReg(y1) END ;
            IF f = SInt THEN
               IF y.mode = Con THEN y.typ := OCT.inttyp ELSE OCC.Put(F7, 10H, y1, y); y := y1 END
            END ;
            OCC.Put(0EEH, SHORT(y1.a0)*8+1, y, z); OCC.PutF1(0D2H)  (*CHECK, FLAG*)
         ELSE
            IF f = LInt THEN load(y) ELSE loadX(y) END ;
            y1 := y
         END ;
         IF x.mode IN {Var, Ind} THEN x.mode := IndX; x.a2 := y1.a0
         ELSIF x.mode = RegI THEN x.mode := RegX; x.a2 := y1.a0
         ELSIF x.mode IN {IndX, RegX} THEN
            z.mode := Var; z.a0 := x.a0 + x.typ.adr; z.lev := x.lev;
            OCC.Put(2EH, SHORT(x.a2)*8+5, y1, z)  (*INDEX*)
         ELSE loadAdr(x); x.mode := RegX; x.a1 := 0; x.a2 := y1.a0
         END ;
         x.typ := x.typ.BaseTyp
      ELSE OCS.Mark(82)
      END
   END Index;

   PROCEDURE Field*(VAR x: OCT.Item; y: OCT.Object);
   BEGIN (*x.typ.form = Record*)
      IF (y # NIL) & (y.mode = Fld) THEN
         IF x.mode = Var THEN INC(x.a0, y.a0)
         ELSIF (x.mode = Ind) OR (x.mode = RegI) THEN INC(x.a1, y.a0)
         ELSE loadAdr(x); x.mode := RegI; x.a1 := y.a0
         END ;
         x.typ := y.typ; x.obj := NIL
      ELSE OCS.Mark(83); x.typ := OCT.undftyp; x.mode := Var
      END
   END Field;

   PROCEDURE DeRef*(VAR x: OCT.Item);
   BEGIN
      IF x.typ.form = Pointer THEN
         IF (x.mode = Var) & (x.lev >= 0) THEN x.mode := Ind
         ELSE load(x); x.mode := RegI
         END ;
         x.typ := x.typ.BaseTyp; x.obj := OCC.wasderef
      ELSE OCS.Mark(84)
      END ;
      x.a1 := 0
   END DeRef;

   PROCEDURE TypTest*(VAR x, y: OCT.Item; test: BOOLEAN);

      PROCEDURE GTT(t0, t1: OCT.Struct; varpar: BOOLEAN);
      VAR t: OCT.Struct; xt, tdes, p: OCT.Item;
      BEGIN
         IF t0 # t1 THEN t := t1;
            REPEAT t := t.BaseTyp UNTIL (t = NIL) OR (t = t0);
            IF t # NIL THEN x.typ := y.typ;
               IF OCC.typchk OR test THEN xt := x;
                  IF varpar THEN xt.mode := Ind; xt.a0 := x.a0+4
                  ELSIF (x.mode = Var) & (x.lev >= 0) THEN
                     xt.mode := Ind; xt.a1 := -4; load(xt); xt.mode := RegI
                  ELSE load(xt); p := xt; p.mode := RegI; p.a1 := -4;
                     OCC.PutF4(17H, xt, p); (*MOVD -4(xt), xt *) xt.mode := RegI
                  END ;
                  xt.a1 := t1.n * 4; tdes.mode := Var; tdes.lev := -t1.mno; tdes.a0 := t1.adr;
                  OCC.PutF4(7, tdes, xt);  (*CMPD*)
                  IF ~test THEN
                     OCC.PutF0(0); OCC.PutDisp(4); OCC.PutF1(0F2H); OCC.PutByte(18) (*BPT*)
                  ELSE setCC(x, 0)
                  END
               END
            ELSE OCS.Mark(85);
               IF test THEN x.typ := OCT.booltyp END
            END
         ELSIF test THEN setCC(x, 14)
         END
      END GTT;

   BEGIN
      IF x.typ.form = Pointer THEN
         IF y.typ.form = Pointer THEN
            GTT(x.typ.BaseTyp, y.typ.BaseTyp, FALSE)
         ELSE OCS.Mark(86)
         END
      ELSIF (x.typ.form = Record) & (x.mode = Ind) & (x.obj # NIL) &
         (x.obj # OCC.wasderef) & (y.typ.form = Record) THEN
         GTT(x.typ, y.typ, TRUE)
      ELSE OCS.Mark(87)
      END
   END TypTest;

   PROCEDURE In*(VAR x, y: OCT.Item);
      VAR f: INTEGER;
   BEGIN f := x.typ.form;
      IF (f IN intSet) & (y.typ.form = Set) THEN
         IF y.mode = Con THEN load(y) END ;
         OCC.PutF4(lengcode[f]+34H, y, x); setCC(x, 8)   (*TBITi*)
      ELSE OCS.Mark(92); x.mode := Reg
      END ;
      x.typ := OCT.booltyp
   END In;

   PROCEDURE Set0*(VAR x, y: OCT.Item);
      VAR one: LONGINT;
   BEGIN x.mode := Reg; x.a0 := 0; x.typ := OCT.settyp;
      IF y.typ.form IN intSet THEN
         IF y.mode = Con THEN x.mode := Con;
            IF (0 <= y.a0) & (y.a0 < 32) THEN one := 1; x.a0 := SYSTEM.LSH(one, y.a0)
            ELSE OCS.Mark(202)
            END
         ELSE OCC.GetReg(x); OCC.PutF2(5FH, 1, x); OCC.Put(F6, 17H, x, y)  (*LSHD*)
         END
      ELSE OCS.Mark(93)
      END
   END Set0;

   PROCEDURE Set1*(VAR x, y, z: OCT.Item);
      VAR s: LONGINT;
   BEGIN x.mode := Reg; x.a0 := 0; x.typ := OCT.settyp;
      IF (y.typ.form IN intSet) & (z.typ.form IN intSet) THEN
         IF y.mode = Con THEN
            IF (0 <= y.a0) & (y.a0 < 32) THEN
               y.typ := OCT.settyp; s := -1; y.a0 := SYSTEM.LSH(s, y.a0);
               IF z.mode = Con THEN
                  x.mode := Con;
                  IF (y.a0 <= z.a0) & (z.a0 < 32) THEN s := -2; x.a0 := y.a0 - SYSTEM.LSH(s, z.a0)
                  ELSE OCS.Mark(202); x.a0 := 0
                  END
               ELSIF y.a0 = -1 THEN
                  OCC.GetReg(x); OCC.PutF2(5FH, -2, x); OCC.Put(F6, 17H, x, z);
                  OCC.Put(F6, 37H, x, x)   (*LSHD, COMD*)
               ELSE OCC.GetReg(x); OCC.PutF4(17H, x, y); OCC.GetReg(y);
                  OCC.PutF2(5FH, -2, y); OCC.Put(F6, 17H, y, z); OCC.PutF4(0BH, x, y)  (*BICD*)
               END
            ELSE OCS.Mark(202)
            END
         ELSE OCC.GetReg(x); OCC.PutF2(5FH, -1, x); OCC.Put(F6, 17H, x, y);
            IF z.mode = Con THEN
               IF (0 <= z.a0) & (z.a0 < 32) THEN
                  y.typ := OCT.settyp; y.mode := Con; s := -2; y.a0 := SYSTEM.LSH(s, z.a0)
               ELSE OCS.Mark(202)
               END
            ELSE OCC.GetReg(y); OCC.PutF2(5FH, -2, y); OCC.Put(F6, 17H, y, z)  (*LSHD*)
            END ;
            OCC.PutF4(0BH, x, y)   (*BICD*)
         END
      ELSE OCS.Mark(93)
      END
   END Set1;

   PROCEDURE MOp*(op: INTEGER; VAR x: OCT.Item);
      VAR f, L: INTEGER; a: LONGINT; y: OCT.Item;
   BEGIN f := x.typ.form;
      CASE op OF
         5: (*&*)
         IF x.mode = Coc THEN
            OCC.PutF0(inverted(x.a0)); OCC.PutWord(x.a2);
            x.a2 := OCC.pc-2; OCC.FixLink(x.a1)
         ELSIF (x.typ.form = Bool) & (x.mode # Con) THEN
            OCC.PutF2(1CH, 1, x); setCC(x, 0);
            OCC.PutF0(1); OCC.PutWord(x.a2); x.a2 := OCC.pc-2; OCC.FixLink(x.a1)
         ELSIF x.typ.form # Bool THEN
            OCS.Mark(94); x.mode := Con; x.typ := OCT.booltyp; x.a0 := 0
         END
      | 6: (*+*)
         IF ~(f IN intSet + realSet) THEN OCS.Mark(96) END
      | 7: (*-*)
         y := x; L := lengcode[f];
         IF f IN intSet THEN
            IF x.mode = Con THEN x.a0 := -x.a0; SetIntType(x)
            ELSE OCC.GetReg(x); OCC.Put(F6, L+20H, x, y)  (*NEGi*)
            END
         ELSIF f IN realSet THEN
            OCC.GetFReg(x); OCC.Put(F11, L+14H, x, y)  (*NEGf*)
         ELSIF f = Set  THEN OCC.GetReg(x); OCC.Put(F6, 37H, x, y)  (*COMD*)
         ELSE OCS.Mark(97)
         END
      | 8: (*OR*)
         IF x.mode = Coc THEN
            OCC.PutF0(x.a0); OCC.PutWord(x.a1); x.a1 := OCC.pc-2;
            OCC.FixLink(x.a2)
         ELSIF (x.typ.form = Bool) & (x.mode # Con) THEN
            OCC.PutF2(1CH, 1, x); setCC(x, 0);
            OCC.PutF0(0); OCC.PutWord(x.a1); x.a1 := OCC.pc-2; OCC.FixLink(x.a2)
         ELSIF x.typ.form # Bool THEN
            OCS.Mark(95); x.mode := Con; x.typ := OCT.booltyp; x.a0 := 1
         END
      | 9 .. 14: (*relations*)
         IF x.mode = Coc THEN loadB(x) END
      | 32: (*~*)
         IF x.typ.form = Bool THEN
            IF x.mode = Coc THEN x.a0 := inverted(x.a0);
               a := x.a1; x.a1 := x.a2; x.a2 := a
            ELSE OCC.PutF2(1CH, 0, x); setCC(x, 0)
            END
         ELSE OCS.Mark(98)
         END
      END
   END MOp;

   PROCEDURE convert1(VAR x: OCT.Item; typ: OCT.Struct);
      VAR y: OCT.Item; op: INTEGER;
   BEGIN
      IF x.mode # Con THEN
         y := x;
         IF typ.form = Int THEN op := 10H
         ELSE op := lengcode[x.typ.form] + 1CH
         END;
         IF x.mode < Reg THEN OCC.GetReg(x) END ;
         OCC.Put(F7, op, x, y)  (*MOVij*)
      END ;
      x.typ := typ
   END convert1;

   PROCEDURE convert2(VAR x: OCT.Item; typ: OCT.Struct);
      VAR y: OCT.Item;
   BEGIN y := x; OCC.GetFReg(x);  (*MOVif*)
      OCC.Put(F9, lengcode[typ.form]*4 + lengcode[x.typ.form], x, y); x.typ := typ
   END convert2;

   PROCEDURE convert3(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN y := x;
      IF x.mode < Reg THEN OCC.GetFReg(x) END ;
      OCC.Put(F9, 1BH, x, y); x.typ := OCT.lrltyp  (*MOVFL*)
   END convert3;

   PROCEDURE Op*(op: INTEGER; VAR x, y: OCT.Item);
      VAR f, g, L: INTEGER; p, q, r: OCT.Struct;

      PROCEDURE strings(): BOOLEAN;
      BEGIN RETURN
         ((((f=Array) OR (f=DynArr)) & (x.typ.BaseTyp.form=Char)) OR (f=String)) &
         ((((g=Array) OR (g=DynArr)) & (y.typ.BaseTyp.form=Char)) OR (g=String))
      END strings;

      PROCEDURE CompStrings(cc: INTEGER; Q: BOOLEAN);
         VAR z: OCT.Item;
      BEGIN z.mode := Reg; z.a0 := 2;
         IF f = DynArr THEN OCC.DynArrAdr(z, x)
         ELSE OCC.PutF4(27H, z, x)
         END ;
         z.a0 := 1;
         IF g = DynArr THEN OCC.DynArrAdr(z, y)
         ELSE OCC.PutF4(27H, z, y)
         END ;
         z.a0 := 0; OCC.PutF2(5FH, -1, z);   (*MOVQD -1, R0*)
         z.a0 := 4; OCC.PutF2(5FH,  0, z);   (*MOVQD  0, R4*)
         OCC.PutF1(14); OCC.PutF1(4); OCC.PutF1(6);  (*CMPSB 6*)
         IF Q THEN (*compare also with zero byte*)
            OCC.PutF0(9); OCC.PutDisp(5);     (*BFC*)
            z.mode := RegI; z.a0 := 2; z.a1 := 0; OCC.PutF2(1CH, 0, z) (*CMPQB*)
         END ;
         setCC(x, cc)
      END CompStrings;

      PROCEDURE CompBool(cc: INTEGER);
      BEGIN
         IF y.mode = Coc THEN loadB(y) END ;
         OCC.PutF4(4, x, y); setCC(x, cc)
      END CompBool;

   BEGIN
      IF x.typ # y.typ THEN
         g := y.typ.form;
         CASE x.typ.form OF
            Undef:
         | SInt: IF g = Int THEN convert1(x, y.typ)
                     ELSIF g = LInt THEN convert1(x, y.typ)
                     ELSIF g = Real THEN convert2(x, y.typ)
                     ELSIF g = LReal THEN convert2(x, y.typ)
                     ELSE OCS.Mark(100)
                     END
         | Int:  IF g = SInt THEN convert1(y, x.typ)
                     ELSIF g = LInt THEN convert1(x, y.typ)
                     ELSIF g = Real THEN convert2(x, y.typ)
                     ELSIF g = LReal THEN convert2(x, y.typ)
                     ELSE OCS.Mark(100)
                     END
         | LInt: IF g = SInt THEN convert1(y, x.typ)
                     ELSIF g = Int THEN convert1(y, x.typ)
                     ELSIF g = Real THEN convert2(x, y.typ)
                     ELSIF g = LReal THEN convert2(x, y.typ)
                     ELSE OCS.Mark(100)
                     END
         | Real: IF g = SInt THEN convert2(y, x.typ)
                     ELSIF g = Int THEN convert2(y, x.typ)
                     ELSIF g = LInt THEN convert2(y, x.typ)
                     ELSIF g = LReal THEN convert3(x)
                     ELSE OCS.Mark(100)
                     END
         | LReal: IF g = SInt THEN convert2(y, x.typ)
                     ELSIF g = Int THEN convert2(y, x.typ)
                     ELSIF g = LInt THEN convert2(y, x.typ)
                     ELSIF g = Real THEN convert3(y)
                     ELSE OCS.Mark(100)
                     END
         | NilTyp: IF g # Pointer THEN OCS.Mark(100) END
         | Pointer: IF g = Pointer THEN
                        p := x.typ.BaseTyp; q := y.typ.BaseTyp;
                        IF (p.form = Record) & (q.form = Record) THEN
                           IF p.n < q.n THEN r := p; p := q; q := r END;
                           WHILE (p # q) & (p # NIL) DO p := p.BaseTyp END;
                           IF p = NIL THEN OCS.Mark(100) END
                        ELSE OCS.Mark(100)
                        END
                     ELSIF g # NilTyp THEN OCS.Mark(100)
                     END
         | ProcTyp: IF g # NilTyp THEN OCS.Mark(100) END
         | Array, DynArr, String:
         | Byte, Bool, Char, Set, NoTyp, Record: OCS.Mark(100)
         END
      END ;
      f := x.typ.form; g := y.typ.form; L := lengcode[f];
      CASE op OF
          1:  IF f IN intSet THEN     (***)
                   IF (x.mode = Con) & (y.mode = Con) THEN (*ovfl test missing*)
                     x.a0 := x.a0 * y.a0; SetIntType(x)
                   ELSIF (x.mode = Con) & (mant(x.a0) = 1) THEN
                      x.a0 := log; x.typ := OCT.sinttyp;
                      load(y); OCC.Put(F6, L+4, y, x); (*ASHi*) x := y
                   ELSIF (y.mode = Con) & (mant(y.a0) = 1) THEN
                      y.a0 := log; y.typ := OCT.sinttyp;
                      load(x); OCC.Put(F6, L+4, x, y) (*ASHi*)
                   ELSE load(x); OCC.Put(F7, L+20H, x, y)  (*MULi*)
                   END
                ELSIF f IN realSet THEN
                   loadF(x); OCC.Put(F11, 30H+L, x, y)   (*MULf*)
                ELSIF f = Set THEN
                   load(x); OCC.PutF4(2BH, x, y)   (*ANDD*)
                ELSIF f # Undef THEN OCS.Mark(101)
                END

       | 2:  IF f IN realSet THEN  (*/*)
                   loadF(x); OCC.Put(F11, 20H+L, x, y)   (*DIVf*)
                ELSIF f IN intSet THEN
                   convert2(x, OCT.realtyp); convert2(y, OCT.realtyp);
                   OCC.Put(F11, 21H, x, y)   (*DIVF*)
                ELSIF f = Set THEN
                   load(x); OCC.PutF4(3BH, x, y)   (*XORD*)
                ELSIF f # Undef THEN OCS.Mark(102)
                END

       | 3:  IF f IN intSet THEN  (*DIV*)
                   IF (x.mode = Con) & (y.mode = Con) THEN
                      IF y.a0 # 0 THEN x.a0 := x.a0 DIV y.a0; SetIntType(x)
                      ELSE OCS.Mark(205)
                      END
                   ELSIF (y.mode = Con) & (mant(y.a0) = 1) THEN
                      y.a0 := -log; y.typ := OCT.sinttyp;
                      load(x); OCC.Put(F6, L+4, x, y)   (*ASHi*)
                   ELSE load(x); OCC.Put(F7, L+3CH, x, y)   (*DIVi*)
                   END
                ELSIF f # Undef THEN OCS.Mark(103)
                END

       | 4:  IF f IN intSet THEN  (*MOD*)
                   IF (x.mode = Con) & (y.mode = Con) THEN
                      IF y.a0 # 0 THEN x.a0 := x.a0 MOD y.a0; x.typ := y.typ
                      ELSE OCS.Mark(205)
                      END
                   ELSIF (y.mode = Con) & (mant(y.a0) = 1) THEN
                      y.a0 := ASH(-1, log); load(x); OCC.PutF4(L+8, x, y)   (*BICi*)
                   ELSE load(x); OCC.Put(F7, L+38H, x, y)   (*MODi*)
                   END
                ELSIF f # Undef THEN OCS.Mark(104)
                END

       | 5:  IF y.mode # Coc THEN  (*&*)
                   IF y.mode = Con THEN
                      IF y.a0 = 1 THEN setCC(y, 14) ELSE setCC(y, 15) END
                   ELSIF y.mode <= Reg THEN OCC.PutF2(1CH, 1, y); setCC(y, 0)
                   ELSE OCS.Mark(94); setCC(y, 0)
                   END
                END ;
                IF x.mode = Con THEN
                   IF x.a0 = 0 THEN OCC.FixLink(y.a1); OCC.FixLink(y.a2); setCC(y, 15) END ;
                   setCC(x, 0)
                END;
                IF y.a2 # 0 THEN x.a2 := OCC.MergedLinks(x.a2, y.a2) END ;
                x.a0 := y.a0; x.a1 := y.a1

       | 6:  IF f IN intSet THEN (*+*)
                   IF (x.mode = Con) & (y.mode = Con) THEN
                      INC(x.a0, y.a0); SetIntType(x)  (*ovfl test missing*)
                   ELSE load(x); add(L, x, y)
                   END
                ELSIF f IN realSet THEN
                   loadF(x); OCC.Put(F11, L, x, y)   (*ADDf*)
                ELSIF f = Set THEN
                   IF (x.mode = Con) & (y.mode = Con) THEN x.a0 := SYSTEM.VAL
                      (LONGINT, SYSTEM.VAL(SET, x.a0) + SYSTEM.VAL(SET, y.a0))
                   ELSE load(x); OCC.PutF4(1BH, x, y)   (*ORD*)
                   END
                ELSIF f # Undef THEN OCS.Mark(105)
                END

       | 7:  IF f IN intSet THEN (*-*)
                   IF (x.mode = Con) & (y.mode = Con) THEN
                      DEC(x.a0, y.a0); SetIntType(x)  (*ovfl test missing*)
                   ELSE load(x); sub(L, x, y)
                   END
                ELSIF f IN realSet THEN
                   loadF(x); OCC.Put(F11, 10H+L, x, y)   (*SUBf*)
                ELSIF f = Set THEN load(x); OCC.PutF4(0BH, x, y)   (*BICD*)
                ELSIF f # Undef THEN OCS.Mark(106)
                END

       | 8:  IF y.mode # Coc THEN  (*OR*)
                   IF y.mode = Con THEN
                      IF y.a0 = 1 THEN setCC(y, 14) ELSE setCC(y, 15) END
                   ELSIF y.mode <= Reg THEN OCC.PutF2(1CH, 1, y); setCC(y, 0)
                   ELSE OCS.Mark(95); setCC(y, 0)
                   END
                END ;
                IF x.mode = Con THEN
                   IF x.a0 = 1 THEN OCC.FixLink(y.a1); OCC.FixLink(y.a2); setCC(y, 14) END ;
                   setCC(x, 0)
                END;
                IF y.a1 # 0 THEN x.a1 := OCC.MergedLinks(x.a1, y.a1) END ;
                x.a0 := y.a0; x.a2 := y.a2

       | 9:  IF f IN {Undef, Char..LInt, Set, NilTyp, Pointer, ProcTyp} THEN
                   cmp(L, x, y); setCC(x, 0)
                ELSIF f IN realSet THEN OCC.Put(F11, 8+L, x, y); setCC(x, 0)
                ELSIF f = Bool THEN CompBool(0)
                ELSIF strings() THEN CompStrings(0, TRUE)
                ELSE OCS.Mark(107)
                END

       | 10: IF f IN {Undef, Char..LInt, Set, NilTyp, Pointer, ProcTyp} THEN
                   cmp(L, x, y); setCC(x, 1)
                ELSIF f IN realSet THEN OCC.Put(F11, 8+L, x, y); setCC(x, 1)
                ELSIF f = Bool THEN CompBool(1)
                ELSIF strings() THEN CompStrings(1, TRUE)
                ELSE OCS.Mark(107)
                END

       | 11: IF f IN intSet THEN cmp(L, x, y); setCC(x, 6)
                ELSIF f = Char THEN cmp(0, x, y); setCC(x, 4)
                ELSIF f IN realSet THEN OCC.Put(F11, 8+L, x, y); setCC(x, 6)
                ELSIF strings() THEN CompStrings(4, FALSE)
                ELSE OCS.Mark(108)
                END

       | 12: IF f IN intSet THEN cmp(L, x, y); setCC(x, 13)
                ELSIF f = Char THEN cmp(0, x, y); setCC(x, 11)
                ELSIF f IN realSet THEN OCC.Put(F11, 8+L, x, y); setCC(x, 13)
                ELSIF strings() THEN CompStrings(11, TRUE)
                ELSE OCS.Mark(108)
                END

       | 13: IF f IN intSet THEN cmp(L, x, y); setCC(x, 12)
                ELSIF f = Char THEN cmp(0, x, y); setCC(x, 10)
                ELSIF f IN realSet THEN OCC.Put(F11, 8+L, x, y); setCC(x, 12)
                ELSIF strings() THEN CompStrings(10, TRUE)
                ELSE OCS.Mark(108)
                END

       | 14: IF f IN intSet THEN cmp(L, x, y); setCC(x, 7)
                ELSIF f = Char THEN cmp(0, x, y); setCC(x, 5)
                ELSIF f IN realSet THEN OCC.Put(F11, 8+L, x, y); setCC(x, 7)
                ELSIF strings() THEN CompStrings(5, FALSE)
                ELSE OCS.Mark(108)
                END
      END
   END Op;

   PROCEDURE StPar1*(VAR x: OCT.Item; fctno: INTEGER);
      VAR f, L: INTEGER; s: LONGINT; y: OCT.Item;
   BEGIN f := x.typ.form;
      CASE fctno OF
          0: (*HALT*)
               IF (f = SInt) & (x.mode = Con) THEN
                  IF x.a0 >= 20 THEN OCC.PutF1(0F2H); OCC.PutByte(x.a0)  (*BPT*)
                  ELSE OCS.Mark(218)
                  END
               ELSE OCS.Mark(217)
               END ;
               x.typ := OCT.notyp
      |  1: (*NEW*) y.mode := Reg;
               IF f = Pointer THEN
                  y.a0 := 0; OCC.PutF4(27H, y, x);
                  x.typ := x.typ.BaseTyp; f := x.typ.form;
                  IF x.typ.size > 7FFF80H THEN OCS.Mark(227)
                  ELSIF f = Record THEN
                     y.a0 := 1; x.mode := Var; x.lev := -x.typ.mno;
                     x.a0 := x.typ.adr; OCC.PutF4(17H, y, x);
                     OCC.PutF1(0E2H); OCC.PutByte(0)  (*SVC 0*)
                  ELSIF f = Array THEN
                     y.a0 := 2; x.a0 := x.typ.size; x.mode := Con; x.typ := OCT.linttyp;
                     OCC.PutF4(17H, y, x); OCC.PutF1(0E2H); OCC.PutByte(1)  (*SVC 1*)
                  ELSE OCS.Mark(111)
                  END
               ELSE OCS.Mark(111)
               END ;
               x.typ := OCT.notyp
      |  2: (*CC*)
               IF (f = SInt) & (x.mode = Con) THEN
                  IF (0 <= x.a0) & (x.a0 < 16) THEN setCC(x, x.a0) ELSE OCS.Mark(219) END
               ELSE OCS.Mark(217)
               END
      |  3: (*ABS*) y := x; L := lengcode[f];
               IF f IN intSet THEN
                  OCC.GetReg(x); OCC.Put(F6, 30H+L, x, y)   (*ABSi*)
               ELSIF f IN realSet THEN
                  OCC.GetFReg(x); OCC.Put(F11, 34H+L, x, y)   (*ABSf*)
               ELSE OCS.Mark(111)
               END
      |  4: (*CAP*) y.mode := Con; y.typ := OCT.chartyp; y.a0 := 5FH;
               IF f = Char THEN load(x); OCC.PutF4(28H, x, y)   (*ANDB*)
               ELSE OCS.Mark(111); x.typ := OCT.chartyp
               END
      |  5: (*ORD*)
               IF (f = Char) OR (f = Byte) THEN
                  IF x.mode # Con THEN y := x; OCC.GetReg(x); OCC.Put(F7, 14H, x, y)  (*MOVZBW*) END
               ELSE OCS.Mark(111)
               END ;
               x.typ := OCT.inttyp
      |  6: (*ENTIER*)
               IF f IN realSet THEN
                  y := x; OCC.GetReg(x); OCC.Put(F9, lengcode[f]*4 + 3BH, x, y)  (*FLOORfD*)
               ELSE OCS.Mark(111)
               END ;
               x.typ := OCT.linttyp
      |  7: (*SIZE*)
               IF x.mode = Typ THEN x.a0 := x.typ.size
               ELSE OCS.Mark(110); x.a0 := 1
               END ;
               x.mode := Con; SetIntType(x)
      |  8: (*ODD*)
               IF f IN intSet THEN
                  y.mode := Con; y.typ := OCT.sinttyp; y.a0 := 0; OCC.PutF4(34H, x, y)  (*TBITB 0*)
               ELSE OCS.Mark(111)
               END ;
               setCC(x, 8)
      |  9: (*ADR*)
               IF f = DynArr THEN y := x; OCC.GetReg(x); OCC.DynArrAdr(x, y)
               ELSE loadAdr(x); x.mode := Reg
               END ;
               x.typ := OCT.linttyp
      | 10: (*MIN*)
               IF x.mode = Typ THEN x.mode := Con;
                  CASE f OF
                        Bool, Char:  x.a0 := 0
                     | SInt:  x.a0 := -80H
                     | Int:   x.a0 := -8000H
                     | LInt:  x.a0 := 80000000H
                     | Real:  x.a0 := 0FF7FFFFFH
                     | LReal: x.a0 := 0FFFFFFFFH; x.a1 := 0FFEFFFFFH
                     | Set:   x.a0 := 0; x.typ := OCT.inttyp
                     | Undef, NilTyp .. Record: OCS.Mark(111)
                  END
               ELSE OCS.Mark(110)
               END
      | 11: (*MAX*)
               IF x.mode = Typ THEN x.mode := Con;
                  CASE f OF
                        Bool:  x.a0 := 1
                     | Char:  x.a0 := 0FFH
                     | SInt:  x.a0 := 7FH
                     | Int:   x.a0 := 7FFFH
                     | LInt:  x.a0 := 7FFFFFFFH
                     | Real:  x.a0 := 7F7FFFFFH
                     | LReal: x.a0 := 0FFFFFFFFH; x.a1 := 7FEFFFFFH
                     | Set:   x.a0 := 31; x.typ := OCT.inttyp
                     | Undef, NilTyp .. Record: OCS.Mark(111)
                  END
               ELSE OCS.Mark(110)
               END |
      | 12: (*CHR*)
               IF ~(f IN {Undef, Byte, SInt, Int, LInt}) THEN OCS.Mark(111) END ;
               IF (x.mode = VarX) OR (x.mode = IndX) THEN load(x) END ;
               x.typ := OCT.chartyp
      | 13: (*SHORT*)
               IF f = LInt THEN (*range test missing*)
                  IF (x.mode = VarX) OR (x.mode = IndX) THEN load(x)
                  ELSIF x.mode = Con THEN SetIntType(x);
                     IF x.typ.form = LInt THEN OCS.Mark(203) END
                  END ;
                  x.typ := OCT.inttyp
               ELSIF f = LReal THEN (*MOVLF*)
                  y := x; OCC.GetFReg(x); OCC.Put(F9, 16H, x, y); x.typ := OCT.realtyp
               ELSIF f = Int THEN (*range test missing*)
                  IF (x.mode = VarX) OR (x.mode = IndX) THEN load(x)
                  ELSIF x.mode = Con THEN SetIntType(x);
                     IF x.typ.form # SInt THEN OCS.Mark(203) END
                  END ;
                  x.typ := OCT.sinttyp
               ELSE OCS.Mark(111)
               END
      | 14: (*LONG*)
               IF f = Int THEN convert1(x, OCT.linttyp)
               ELSIF f = Real THEN convert3(x)
               ELSIF f = SInt THEN convert1(x, OCT.inttyp)
               ELSIF f = Char THEN
                  y := x; OCC.GetReg(x); OCC.Put(F7, 18H, x, y); x.typ := OCT.linttyp (*MOVZBD*)
               ELSE OCS.Mark(111)
               END
      | 15: (*OVFL*)
               IF (f = Bool) & (x.mode = Con) THEN (*BICPSRB 10H*)
                  OCC.PutF1(7CH); OCC.PutF1(SHORT(x.a0)*2 + 0A1H); OCC.PutF1(10H)
               ELSE OCS.Mark(111)
               END ;
               x.typ := OCT.notyp
      | 16,17: (*INC DEC*)
               IF x.mode >= Con THEN OCS.Mark(112)
               ELSIF ~(f IN intSet) THEN OCS.Mark(111)
               END
      | 18,19: (*INCL EXCL*)
               IF x.mode >= Con THEN OCS.Mark(112)
               ELSIF x.typ # OCT.settyp THEN OCS.Mark(111); x.typ := OCT.settyp
               END
      | 20: (*LEN*)
               IF (f # DynArr) & (f # Array) THEN OCS.Mark(131) END
      | 21: (*ASH*)
               IF f = LInt THEN load(x)
               ELSIF f IN intSet THEN loadX(x); x.typ := OCT.linttyp
               ELSE OCS.Mark(111)
               END
      | 22, 23: (*LSH ROT*)
               IF f IN {Char, SInt, Int, LInt, Set} THEN load(x) ELSE OCS.Mark(111) END
      | 24,25,26: (*GET, PUT, BIT*)
               IF (f IN intSet) & (x.mode = Con) THEN x.mode := Abs
               ELSIF f = LInt THEN
                  IF (x.mode = Var) & (x.lev >= 0) THEN x.mode := Ind; x.a1 := 0
                  ELSE load(x); x.mode := RegI; x.a1 := 0
                  END
               ELSE OCS.Mark(111)
               END
      | 27: (*VAL*)
               IF x.mode # Typ THEN OCS.Mark(110) END
      | 28: (*SYSTEM.NEW*)
               IF (f = Pointer) & (x.mode < Con) THEN
                  y.mode := Reg; y.a0 := 0; OCC.PutF4(27H, y, x);
               ELSE OCS.Mark(111)
               END
      | 29: (*COPY*)
               IF (((f=Array) OR (f=DynArr)) & (x.typ.BaseTyp.form = Char))
                   OR (f = String) THEN
                  y.mode := Reg; y.a0 := 1;
                  IF f = DynArr THEN OCC.DynArrAdr(y, x)
                  ELSE OCC.PutF4(27H, y, x)
                  END
               ELSE OCS.Mark(111)
               END
      | 30: (*MOVE*)
               IF f = LInt THEN y.mode := Reg; y.a0 := 1; OCC.PutF4(17H, y, x)
               ELSE OCS.Mark(111)
               END
      END
   END StPar1;

   PROCEDURE StPar2*(VAR p, x: OCT.Item; fctno: INTEGER);
      VAR f, L: INTEGER; y, z: OCT.Item; typ: OCT.Struct;
   BEGIN f := x.typ.form;
      IF fctno < 16 THEN OCS.Mark(64); RETURN END ;
      CASE fctno OF
         16, 17: (*INC DEC*)
               IF x.typ # p.typ THEN
                  IF (x.mode = Con) & (x.typ.form IN intSet) THEN x.typ := p.typ
                  ELSE OCS.Mark(111)
                  END
               END ;
               L := lengcode[p.typ.form];
               IF fctno = 16 THEN add(L, p, x) ELSE sub(L, p, x) END ;
               p.typ := OCT.notyp
      | 18: (*INCL*)
               Set0(y, x); OCC.PutF4(1BH, p, y); p.typ := OCT.notyp (*ORD*)
      | 19: (*EXCL*)
               Set0(y, x); OCC.PutF4(0BH, p, y); p.typ := OCT.notyp (*BICD*)
      | 20: (*LEN*)
               IF (x.mode = Con) & (f = SInt) THEN
                  L := SHORT(x.a0); typ := p.typ;
                  WHILE (L > 0) & (typ.form IN {DynArr, Array}) DO typ := typ.BaseTyp; DEC(L) END;
                  IF (L # 0) OR ~(typ.form IN {DynArr, Array}) THEN OCS.Mark(132)
                  ELSE
                     IF typ.form = DynArr THEN
                        p.mode := Var; p.typ := OCT.linttyp; INC(p.a0, typ.adr);
                        load(p); OCC.PutF2(0FH, 1, p)   (* ADDQD 1, p *)
                     ELSE p := x; p.a0 := typ.n; SetIntType(p)
                     END
                  END
               ELSE OCS.Mark(111)
               END
      | 21, 22, 23: (*ASH LSH ROT*)
               IF f IN intSet THEN
                  IF fctno = 21 THEN L := 4 ELSIF fctno = 22 THEN L := 14H ELSE L := 0 END ;
                  IF (x.mode = VarX) OR (x.mode = IndX) THEN load(x) END ;
                  x.typ := OCT.sinttyp; OCC.Put(F6, lengcode[p.typ.form]+L, p, x)
               ELSE OCS.Mark(111)
               END
      | 24: (*GET*)
               IF x.mode >= Con THEN OCS.Mark(112)
               ELSIF f IN {Undef..LInt, Set, Pointer, ProcTyp} THEN
                  OCC.PutF4(lengcode[f]+14H, x, p)
               ELSIF f IN realSet THEN OCC.Put(F11, lengcode[f]+4, x, p)   (*MOVf*)
               END ;
               p.typ := OCT.notyp
      | 25: (*PUT*)
               IF f IN {Undef..LInt, Set, Pointer, ProcTyp} THEN OCC.PutF4(lengcode[f]+14H, p, x)
               ELSIF f IN realSet THEN OCC.Put(F11, lengcode[f]+4, p, x)   (*MOVf*)
               END ;
               p.typ := OCT.notyp
      | 26: (*BIT*)
               IF f IN intSet THEN OCC.PutF4(lengcode[f] + 34H, p, x)   (*TBITi*)
               ELSE OCS.Mark(111)
               END ;
               setCC(p, 8)
      | 27: (*VAL*)
               x.typ := p.typ; p := x
      | 28: (*SYSTEM.NEW*)
               y.mode := Reg; y.a0 := 2;
               IF f = LInt THEN OCC.PutF4(17H, y, x)
               ELSIF f = Int THEN OCC.Put(F7, 1DH, y, x)   (*MOVXWD*)
               ELSIF f = SInt THEN OCC.Put(F7, 1CH, y, x)  (*MOVXBD*)
               ELSE OCS.Mark(111)
               END ;
               OCC.PutF1(0E2H); OCC.PutByte(1);  (*SVC 1*)
               p.typ := OCT.notyp
      | 29: (*COPY*)
               IF ((f = Array) OR (f = DynArr)) & (x.typ.BaseTyp.form = Char) THEN
                  y.mode := Reg; y.a0 := 2; y.a1 := 0;
                  IF f = DynArr THEN p := x; OCC.DynArrAdr(y, x); y.a0 := 0;
                     p.mode := Var; INC(p.a0, p.typ.adr); OCC.PutF4(17H, y, p)
                  ELSE OCC.PutF4(27H, y, x); y.a0 := 0;
                     p.mode := Con; p.typ := OCT.inttyp; p.a0:= x.typ.size-1;
                     OCC.Put(F7, 19H, y, p); (*MOVZWD*)
                  END;
                  y.a0 := 4; OCC.PutF2(5FH, 0, y);                (*MOVQD*)
                  OCC.PutF1(14); OCC.PutF1(0); OCC.PutF1(6);      (*MOVSB*)
                  y.mode := RegI; y.a0 := 2; OCC.PutF2(5CH, 0, y) (*MOVQB*)
               ELSE OCS.Mark(111)
               END ;
               p.typ := OCT.notyp
      | 30: (*MOVE*)
               IF f = LInt THEN y.mode := Reg; y.a0 := 2; OCC.PutF4(17H, y, x)
               ELSE OCS.Mark(111)
               END
      END
   END StPar2;

   PROCEDURE StPar3*(VAR p, x: OCT.Item; fctno: INTEGER);
      VAR f: INTEGER; y: OCT.Item;
   BEGIN f := x.typ.form;
      IF fctno = 30 THEN (*MOVE*)
         y.mode := Reg; y.a0 := 0;
         IF f = Int THEN OCC.Put(F7, 1DH, y, x)
         ELSIF f = SInt THEN OCC.Put(F7, 1CH, y, x)
         ELSIF f = LInt THEN OCC.PutF4(17H, y, x)
         ELSE OCS.Mark(111)
         END ;
         OCC.PutF1(14); OCC.PutF1(0); OCC.PutF1(0); p.typ := OCT.notyp  (*MOVSB*)
      ELSE OCS.Mark(64)
      END
   END StPar3;

   PROCEDURE StFct*(VAR p: OCT.Item; fctno, parno: INTEGER);
   BEGIN
      IF fctno >= 16 THEN
         IF (fctno = 16) & (parno = 1) THEN (*INC*)
            OCC.PutF2(lengcode[p.typ.form]+0CH, 1, p); p.typ := OCT.notyp
         ELSIF (fctno = 17) & (parno = 1) THEN (*DEC*)
            OCC.PutF2(lengcode[p.typ.form]+0CH, -1, p); p.typ := OCT.notyp
         ELSIF (fctno = 20) & (parno = 1) THEN (*LEN*)
            IF p.typ.form = DynArr THEN
               p.mode := Var; INC(p.a0, p.typ.adr); p.typ := OCT.linttyp;
               load(p); OCC.PutF2(0FH, 1, p)   (*ADDQD 1 p*)
            ELSE p.mode := Con; p.a0 := p.typ.n; SetIntType(p)
            END
         ELSIF (parno < 2) OR (fctno = 30) & (parno < 3) THEN OCS.Mark(65)
         END
      ELSIF parno < 1 THEN OCS.Mark(65)
      END
   END StFct;

BEGIN intSet := {SInt, Int, LInt}; realSet := {Real, LReal};
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
END OCE.
