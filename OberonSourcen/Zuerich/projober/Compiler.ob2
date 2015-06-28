MODULE Compiler;   (*NW 7.6.87 / 19.7.92*)

   IMPORT Texts, Files, TextFrames, Viewers, Oberon, OCS, OCT, OCC, OCE, OCH;

   CONST NofCases = 128; MaxEntry = 64; ModNameLen = 20;
      RecDescSize = 8; AdrSize = 4; ProcSize = 4; PtrSize = 4;
      XParOrg = 12; LParOrg = 8; LDataSize = 2000H;

      (*symbol values*)
         times = 1; slash = 2; div = 3; mod = 4;
         and = 5; plus = 6; minus = 7; or = 8; eql = 9;
         neq = 10; lss = 11; leq = 12; gtr = 13; geq = 14;
         in = 15; is = 16; arrow = 17; period = 18; comma = 19;
         colon = 20; upto = 21; rparen = 22; rbrak = 23; rbrace = 24;
         of = 25; then = 26; do = 27; to = 28; lparen = 29;
         lbrak = 30; lbrace = 31; not = 32; becomes = 33; number = 34;
         nil = 35; string = 36; ident = 37; semicolon = 38; bar = 39;
         end = 40; else = 41; elsif = 42; until = 43; if = 44;
         case = 45; while = 46; repeat = 47; loop = 48; with = 49;
         exit = 50; return = 51; array = 52; record = 53; pointer = 54;
         begin = 55; const = 56; type = 57; var = 58; procedure = 59;
         import = 60; module = 61;

      (*object and item modes*)
         Var = 1; Ind = 3; Con = 8; Fld = 12; Typ = 13;
         LProc = 14; XProc = 15; SProc = 16; CProc = 17; IProc = 18; Mod = 19;

      (*structure forms*)
         Undef = 0; NoTyp = 12; Pointer = 13; ProcTyp = 14; Array = 15; DynArr = 16; Record = 17;
         intSet = {4 .. 6}; labeltyps = {3 .. 6};

   VAR W: Texts.Writer;
         sym, entno: INTEGER;
         newSF:      BOOLEAN;
         LoopLevel, ExitNo: INTEGER;
         LoopExit:  ARRAY 16 OF INTEGER;

   PROCEDURE^ Type(VAR typ: OCT.Struct);
   PROCEDURE^ FormalType(VAR typ: OCT.Struct);
   PROCEDURE^ Expression(VAR x: OCT.Item);
   PROCEDURE^ Block(VAR dsize: LONGINT);

   PROCEDURE CheckSym(s: INTEGER);
   BEGIN
      IF sym = s THEN OCS.Get(sym) ELSE OCS.Mark(s) END
   END CheckSym;

   PROCEDURE qualident(VAR x: OCT.Item);
      VAR mnolev: INTEGER; obj: OCT.Object;
   BEGIN (*sym = ident*)
      OCT.Find(obj, mnolev); OCS.Get(sym);
      IF (sym = period) & (obj # NIL) & (obj.mode = Mod) THEN
         OCS.Get(sym); mnolev := SHORT(-obj.a0);
         IF sym = ident THEN
            OCT.FindImport(obj, obj); OCS.Get(sym)
         ELSE OCS.Mark(10); obj := NIL
         END
      END ;
      x.lev := mnolev; x.obj := obj;
      IF obj # NIL THEN
         x.mode := obj.mode; x.typ := obj.typ; x.a0 := obj.a0; x.a1 := obj.a1
      ELSE OCS.Mark(0); x.mode := Var;
         x.typ := OCT.undftyp; x.a0 := 0; x.obj := NIL
      END
   END qualident;

   PROCEDURE ConstExpression(VAR x: OCT.Item);
   BEGIN Expression(x);
      IF x.mode # Con THEN
         OCS.Mark(50); x.mode := Con; x.typ := OCT.inttyp; x.a0 := 1
      END
   END ConstExpression;

   PROCEDURE NewStr(form: INTEGER): OCT.Struct;
      VAR typ: OCT.Struct;
   BEGIN NEW(typ);
      typ.form := form; typ.mno := 0; typ.size := 4; typ.ref := 0;
      typ.BaseTyp := OCT.undftyp; typ.strobj := NIL; RETURN typ
   END NewStr;

   PROCEDURE CheckMark(VAR mk: BOOLEAN);
   BEGIN OCS.Get(sym);
      IF sym = times THEN
         IF OCC.level = 0 THEN mk := TRUE ELSE mk := FALSE; OCS.Mark(47) END ;
         OCS.Get(sym)
      ELSE mk := FALSE
      END
   END CheckMark;

   PROCEDURE CheckUndefPointerTypes;
      VAR obj: OCT.Object;
   BEGIN obj := OCT.topScope.next;
      WHILE obj # NIL DO
         IF obj.mode = Undef THEN OCS.Mark(48) END ;
         obj := obj.next
      END
   END CheckUndefPointerTypes;

   PROCEDURE RecordType(VAR typ: OCT.Struct);
      VAR adr, size: LONGINT;
         fld, fld0, fld1: OCT.Object;
         ftyp, btyp: OCT.Struct;
         base: OCT.Item;
   BEGIN adr := 0; typ := NewStr(Record); typ.BaseTyp := NIL; typ.n := 0;
      IF sym = lparen THEN
         OCS.Get(sym); (*record extension*)
         IF sym = ident THEN
            qualident(base);
            IF (base.mode = Typ) & (base.typ.form = Record) THEN
               typ.BaseTyp := base.typ; typ.n := base.typ.n + 1; adr := base.typ.size
            ELSE OCS.Mark(52)
            END
         ELSE OCS.Mark(10)
         END ;
         CheckSym(rparen)
      END ;
      OCT.OpenScope(0); fld := NIL; fld1 := OCT.topScope;
      LOOP
         IF sym = ident THEN
            LOOP
               IF sym = ident THEN
                  IF typ.BaseTyp # NIL THEN
                     OCT.FindField(typ.BaseTyp, fld0);
                     IF fld0 # NIL THEN OCS.Mark(1) END
                  END ;
                  OCT.Insert(OCS.name, fld); CheckMark(fld.marked); fld.mode := Fld
               ELSE OCS.Mark(10)
               END ;
               IF sym = comma THEN OCS.Get(sym)
               ELSIF sym = ident THEN OCS.Mark(19)
               ELSE EXIT
               END
            END ;
            CheckSym(colon); Type(ftyp); size := ftyp.size; btyp := ftyp;
            WHILE btyp.form = Array DO btyp := btyp.BaseTyp END ;
            IF btyp.size >= 4 THEN INC(adr, (-adr) MOD 4)
            ELSIF btyp.size = 2 THEN INC(adr, adr MOD 2)
            END ;
            WHILE fld1.next # NIL DO
               fld1 := fld1.next; fld1.typ := ftyp; fld1.a0 := adr; INC(adr, size)
            END
         END ;
         IF sym = semicolon THEN OCS.Get(sym)
         ELSIF sym = ident THEN OCS.Mark(38)
         ELSE EXIT
         END
      END ;
      typ.size := (-adr) MOD 4 + adr; typ.link := OCT.topScope.next;
      CheckUndefPointerTypes; OCT.CloseScope
   END RecordType;

   PROCEDURE ArrayType(VAR typ: OCT.Struct);
      VAR x: OCT.Item; f, n: INTEGER;
   BEGIN typ := NewStr(Array); ConstExpression(x); f := x.typ.form;
      IF f IN intSet THEN
         IF (x.a0 > 0) & (x.a0 <= MAX(INTEGER)) THEN n := SHORT(x.a0)
         ELSE n := 1; OCS.Mark(63)
         END
      ELSE OCS.Mark(51); n := 1
      END ;
      typ.n := n; OCC.AllocBounds(0, n-1, typ.adr);
      IF sym = of THEN
         OCS.Get(sym); Type(typ.BaseTyp)
      ELSIF sym = comma THEN
         OCS.Get(sym); ArrayType(typ.BaseTyp)
      ELSE OCS.Mark(34)
      END ;
      typ.size := n * typ.BaseTyp.size
   END ArrayType;

   PROCEDURE FormalParameters(VAR resTyp: OCT.Struct; VAR psize: LONGINT);
      VAR mode: SHORTINT;
            adr, size: LONGINT; res: OCT.Item;
            par, par1: OCT.Object; typ: OCT.Struct;
   BEGIN par1 := OCT.topScope; adr := 0;
      IF (sym = ident) OR (sym = var) THEN
         LOOP
            IF sym = var THEN OCS.Get(sym); mode := Ind ELSE mode := Var END ;
            LOOP
               IF sym = ident THEN
                  OCT.Insert(OCS.name, par); OCS.Get(sym); par.mode := mode
               ELSE OCS.Mark(10)
               END ;
               IF sym = comma THEN OCS.Get(sym)
               ELSIF sym = ident THEN OCS.Mark(19)
               ELSIF sym = var THEN OCS.Mark(19); OCS.Get(sym)
               ELSE EXIT
               END
            END ;
            CheckSym(colon); FormalType(typ);
            IF mode = Ind THEN (*VAR param*)
               IF typ.form = Record THEN size := RecDescSize
               ELSIF typ.form = DynArr THEN size := typ.size
               ELSE size := AdrSize
               END
            ELSE size := (-typ.size) MOD 4 + typ.size
            END ;
            WHILE par1.next # NIL DO
               par1 := par1.next; par1.typ := typ; DEC(adr, size); par1.a0 := adr
            END ;
            IF sym = semicolon THEN OCS.Get(sym)
            ELSIF sym = ident THEN OCS.Mark(38)
            ELSE EXIT
            END
         END
      END ;
      psize := psize - adr; par := OCT.topScope.next;
      WHILE par # NIL DO INC(par.a0, psize); par := par.next END ;
      CheckSym(rparen);
      IF sym = colon THEN
         OCS.Get(sym); resTyp := OCT.undftyp;
         IF sym = ident THEN qualident(res);
            IF res.mode = Typ THEN
               IF (res.typ.form <= ProcTyp) & (res.typ.form # NoTyp) THEN resTyp := res.typ ELSE OCS.Mark(54) END
            ELSE OCS.Mark(52)
            END
         ELSE OCS.Mark(10)
         END
      ELSE resTyp := OCT.notyp
      END
   END FormalParameters;

   PROCEDURE ProcType(VAR typ: OCT.Struct);
      VAR psize: LONGINT;
   BEGIN typ := NewStr(ProcTyp); typ.size := ProcSize;
      IF sym = lparen THEN
         OCS.Get(sym); OCT.OpenScope(OCC.level); psize := XParOrg;
         FormalParameters(typ.BaseTyp, psize); typ.link := OCT.topScope.next;
         OCT.CloseScope
      ELSE typ.BaseTyp := OCT.notyp; typ.link := NIL
      END
   END ProcType;

   PROCEDURE HasPtr(typ: OCT.Struct): BOOLEAN;
      VAR fld: OCT.Object;
   BEGIN
      IF typ.form = Pointer THEN RETURN TRUE
      ELSIF typ.form = Array THEN RETURN HasPtr(typ.BaseTyp)
      ELSIF typ.form = Record THEN
         IF (typ.BaseTyp # NIL) & HasPtr(typ.BaseTyp) THEN RETURN TRUE END ;
         fld := typ.link;
         WHILE fld # NIL DO
            IF (fld.name = "") OR HasPtr(fld.typ) THEN RETURN TRUE END ;
            fld := fld.next
         END
      END ;
      RETURN FALSE
   END HasPtr;

   PROCEDURE SetPtrBase(ptyp, btyp: OCT.Struct);
   BEGIN
      IF (btyp.form = Record) OR (btyp.form = Array) & ~HasPtr(btyp.BaseTyp) THEN
         ptyp.BaseTyp := btyp
      ELSE ptyp.BaseTyp := OCT.undftyp; OCS.Mark(57)
      END
   END SetPtrBase;

   PROCEDURE Type(VAR typ: OCT.Struct);
      VAR lev: INTEGER; obj: OCT.Object; x: OCT.Item;
   BEGIN typ := OCT.undftyp;
      IF sym < lparen THEN OCS.Mark(12);
         REPEAT OCS.Get(sym) UNTIL sym >= lparen
      END ;
      IF sym = ident THEN qualident(x);
         IF x.mode = Typ THEN typ := x.typ;
            IF typ = OCT.notyp THEN OCS.Mark(58) END
         ELSE OCS.Mark(52)
         END
      ELSIF sym = array THEN
         OCS.Get(sym); ArrayType(typ)
      ELSIF sym = record THEN
         OCS.Get(sym); RecordType(typ); OCC.AllocTypDesc(typ); CheckSym(end)
      ELSIF sym = pointer THEN
         OCS.Get(sym); typ := NewStr(Pointer); typ.link := NIL; typ.size := PtrSize;
         CheckSym(to);
         IF sym = ident THEN OCT.Find(obj, lev);
            IF obj = NIL THEN (*forward ref*)
               OCT.Insert(OCS.name, obj); typ.BaseTyp := OCT.undftyp;
               obj.mode := Undef; obj.typ := typ; OCS.Get(sym)
            ELSE qualident(x);
               IF x.mode = Typ THEN SetPtrBase(typ, x.typ)
               ELSE typ.BaseTyp := OCT.undftyp; OCS.Mark(52)
               END
            END
         ELSE Type(x.typ); SetPtrBase(typ, x.typ)
         END
      ELSIF sym = procedure THEN
         OCS.Get(sym); ProcType(typ)
      ELSE OCS.Mark(12)
      END ;
      IF (sym < semicolon) OR (else < sym) THEN OCS.Mark(15);
         WHILE (sym < ident) OR (else < sym) & (sym < begin) DO
            OCS.Get(sym)
         END
      END
   END Type;

   PROCEDURE FormalType(VAR typ: OCT.Struct);
      VAR x: OCT.Item; typ0: OCT.Struct; a, s: LONGINT;
   BEGIN typ := OCT.undftyp; a := 0;
      WHILE sym = array DO
         OCS.Get(sym); CheckSym(of); INC(a, 4)
      END ;
      IF sym = ident THEN qualident(x);
         IF x.mode = Typ THEN typ := x.typ;
            IF typ = OCT.notyp THEN OCS.Mark(58) END
         ELSE OCS.Mark(52)
         END
      ELSIF sym = procedure THEN OCS.Get(sym); ProcType(typ)
      ELSE OCS.Mark(10)
      END ;
      s := a + 8;
      WHILE a > 0 DO
         typ0 := NewStr(DynArr); typ0.BaseTyp := typ;
         typ0.size := s-a; typ0.adr := typ0.size-4; typ0.mno := 0; typ := typ0; DEC(a, 4)
      END
   END FormalType;


   PROCEDURE selector(VAR x: OCT.Item);
      VAR fld: OCT.Object; y: OCT.Item;
   BEGIN
      LOOP
         IF sym = lbrak THEN OCS.Get(sym);
            LOOP
               IF (x.typ # NIL) & (x.typ.form = Pointer) THEN OCE.DeRef(x) END ;
               Expression(y); OCE.Index(x, y);
               IF sym = comma THEN OCS.Get(sym) ELSE EXIT END
            END ;
            CheckSym(rbrak)
         ELSIF sym = period THEN OCS.Get(sym);
            IF sym = ident THEN
               IF x.typ # NIL THEN
                  IF x.typ.form = Pointer THEN OCE.DeRef(x) END ;
                  IF x.typ.form = Record THEN
                     OCT.FindField(x.typ, fld); OCE.Field(x, fld)
                  ELSE OCS.Mark(53)
                  END
               ELSE OCS.Mark(52)
               END ;
               OCS.Get(sym)
            ELSE OCS.Mark(10)
            END
         ELSIF sym = arrow THEN
            OCS.Get(sym); OCE.DeRef(x)
         ELSIF (sym = lparen) & (x.mode < Typ) & (x.typ.form # ProcTyp) THEN
            OCS.Get(sym);
            IF sym = ident THEN
               qualident(y);
               IF y.mode = Typ THEN OCE.TypTest(x, y, FALSE)
               ELSE OCS.Mark(52)
               END
            ELSE OCS.Mark(10)
            END ;
            CheckSym(rparen)
         ELSE EXIT
         END
      END
   END selector;

   PROCEDURE IsParam(obj: OCT.Object): BOOLEAN;
   BEGIN RETURN (obj # NIL) & (obj.mode <= Ind) & (obj.a0 > 0)
   END IsParam;

   PROCEDURE ActualParameters(VAR x: OCT.Item; fpar: OCT.Object);
      VAR apar: OCT.Item; R: SET;
   BEGIN
      IF sym # rparen THEN
         R := OCC.RegSet;
         LOOP Expression(apar);
            IF IsParam(fpar) THEN
               OCH.Param(apar, fpar); fpar := fpar.next
            ELSE OCS.Mark(64)
            END ;
            OCC.FreeRegs(R);
            IF sym = comma THEN OCS.Get(sym)
            ELSIF (lparen <= sym) & (sym <= ident) THEN OCS.Mark(19)
            ELSE EXIT
            END
         END
      END ;
      IF IsParam(fpar) THEN OCS.Mark(65) END
   END ActualParameters;

   PROCEDURE StandProcCall(VAR x: OCT.Item);
      VAR y: OCT.Item; m, n: INTEGER;
   BEGIN m := SHORT(x.a0); n := 0;
      IF sym = lparen THEN OCS.Get(sym);
         IF sym # rparen THEN
            LOOP
               IF n = 0 THEN Expression(x); OCE.StPar1(x, m); n := 1
               ELSIF n = 1 THEN Expression(y); OCE.StPar2(x, y, m); n := 2
               ELSIF n = 2 THEN Expression(y); OCE.StPar3(x, y, m); n := 3
               ELSE OCS.Mark(64); Expression(y)
               END ;
               IF sym = comma THEN OCS.Get(sym)
               ELSIF (lparen <= sym) & (sym <= ident) THEN OCS.Mark(19)
               ELSE EXIT
               END
            END ;
            CheckSym(rparen)
         ELSE OCS.Get(sym)
         END ;
         OCE.StFct(x, m, n)
      ELSE OCS.Mark(29)
      END
   END StandProcCall;

   PROCEDURE Element(VAR x: OCT.Item);
      VAR e1, e2: OCT.Item;
   BEGIN Expression(e1);
      IF sym = upto THEN
         OCS.Get(sym); Expression(e2); OCE.Set1(x, e1, e2)
      ELSE OCE.Set0(x, e1)
      END ;
   END Element;

   PROCEDURE Sets(VAR x: OCT.Item);
      VAR y: OCT.Item;
   BEGIN x.typ := OCT.settyp; y.typ := OCT.settyp;
      IF sym # rbrace THEN
         Element(x);
         LOOP
            IF sym = comma THEN OCS.Get(sym)
            ELSIF (lparen <= sym) & (sym <= ident) THEN OCS.Mark(19)
            ELSE EXIT
            END ;
            Element(y); OCE.Op(plus, x, y)  (*x := x+y*)
         END
      ELSE x.mode := Con; x.a0 := 0
      END ;
      CheckSym(rbrace)
   END Sets;

   PROCEDURE Factor(VAR x: OCT.Item);
      VAR fpar: OCT.Object; gR, fR: SET;
   BEGIN
      IF sym < lparen THEN OCS.Mark(13);
         REPEAT OCS.Get(sym) UNTIL sym >= lparen
      END ;
      IF sym = ident THEN
         qualident(x); selector(x);
         IF x.mode = SProc THEN StandProcCall(x)
         ELSIF sym = lparen THEN
            OCS.Get(sym); OCH.PrepCall(x, fpar);
            OCC.SaveRegisters(gR, fR, x); ActualParameters(x, fpar);
            OCH.Call(x); OCC.RestoreRegisters(gR, fR, x);
            CheckSym(rparen)
         END
      ELSIF sym = number THEN
         OCS.Get(sym); x.mode := Con;
         CASE OCS.numtyp OF
            1: x.typ := OCT.chartyp; x.a0 := OCS.intval
         | 2: x.a0 := OCS.intval; OCE.SetIntType(x)
         | 3: x.typ := OCT.realtyp; OCE.AssReal(x, OCS.realval)
         | 4: x.typ := OCT.lrltyp; OCE.AssLReal(x, OCS.lrlval)
         END
      ELSIF sym = string THEN
         x.typ := OCT.stringtyp; x.mode := Con;
         OCC.AllocString(OCS.name, x); OCS.Get(sym)
      ELSIF sym = nil THEN
         OCS.Get(sym); x.typ := OCT.niltyp; x.mode := Con; x.a0 := 0
      ELSIF sym = lparen THEN
         OCS.Get(sym); Expression(x); CheckSym(rparen)
      ELSIF sym = lbrak THEN
         OCS.Get(sym); OCS.Mark(29); Expression(x); CheckSym(rparen)
      ELSIF sym = lbrace THEN OCS.Get(sym); Sets(x)
      ELSIF sym = not THEN
         OCS.Get(sym); Factor(x); OCE.MOp(not, x)
      ELSE OCS.Mark(13); OCS.Get(sym); x.typ := OCT.undftyp; x.mode := Var; x.a0 := 0
      END
   END Factor;

   PROCEDURE Term(VAR x: OCT.Item);
      VAR y: OCT.Item; mulop: INTEGER;
   BEGIN Factor(x);
      WHILE (times <= sym) & (sym <= and) DO
         mulop := sym; OCS.Get(sym);
         IF mulop = and THEN OCE.MOp(and, x) END ;
         Factor(y); OCE.Op(mulop, x, y)
      END
   END Term;

   PROCEDURE SimpleExpression(VAR x: OCT.Item);
      VAR y: OCT.Item; addop: INTEGER;
   BEGIN
      IF sym = minus THEN OCS.Get(sym); Term(x); OCE.MOp(minus, x)
      ELSIF sym = plus THEN OCS.Get(sym); Term(x); OCE.MOp(plus, x)
      ELSE Term(x)
      END ;
      WHILE (plus <= sym) & (sym <= or) DO
         addop := sym; OCS.Get(sym);
         IF addop = or THEN OCE.MOp(or, x) END ;
         Term(y); OCE.Op(addop, x, y)
      END
   END SimpleExpression;

   PROCEDURE Expression(VAR x: OCT.Item);
      VAR y: OCT.Item; relation: INTEGER;
   BEGIN SimpleExpression(x);
      IF (eql <= sym) & (sym <= geq) THEN
         relation := sym; OCS.Get(sym);
         IF x.typ = OCT.booltyp THEN OCE.MOp(relation, x) END ;
         SimpleExpression(y); OCE.Op(relation, x, y)
      ELSIF sym = in THEN
         OCS.Get(sym); SimpleExpression(y); OCE.In(x, y)
      ELSIF sym = is THEN
         IF x.mode >= Typ THEN OCS.Mark(112) END ;
         OCS.Get(sym);
         IF sym = ident THEN
            qualident(y);
            IF y.mode = Typ THEN OCE.TypTest(x, y, TRUE) ELSE OCS.Mark(52) END
         ELSE OCS.Mark(10)
         END
      END
   END Expression;


   PROCEDURE ProcedureDeclaration;
      VAR proc, proc1, par: OCT.Object;
         L1: INTEGER;
         mode: SHORTINT; body: BOOLEAN;
         psize, dsize: LONGINT;
   BEGIN dsize := 0; proc := NIL; body := TRUE;
      IF (sym # ident) & (OCC.level = 0) THEN
         IF sym = times THEN mode := XProc
         ELSIF sym = arrow THEN (*forward*) mode := XProc; body := FALSE
         ELSIF sym = plus THEN mode := IProc
         ELSIF sym = minus THEN mode := CProc; body := FALSE
         ELSE mode := LProc; OCS.Mark(10)
         END ;
         OCS.Get(sym)
      ELSE mode := LProc
      END ;
      IF sym = ident THEN
         IF OCC.level = 0 THEN OCT.Find(proc1, L1) ELSE proc1 := NIL END;
         IF (proc1 # NIL) & (proc1.mode = XProc) & (OCC.Entry(SHORT(proc1.a0)) = 0) THEN
            (*there exists a corresponding forward declaration*)
            OCT.Remove(proc1); OCT.Insert(OCS.name, proc);
            CheckMark(proc.marked); mode := XProc; proc.a0 := proc1.a0; proc.a1 := proc1.a1
         ELSE
            IF proc1 # NIL THEN OCS.Mark(1); proc1 := NIL END ;
            OCT.Insert(OCS.name, proc); CheckMark(proc.marked); proc.a1 := 0;
            IF proc.marked & (mode = LProc) THEN mode := XProc END ;
            IF mode = LProc THEN proc.a0 := OCC.pc
            ELSIF mode # CProc THEN
               IF entno < MaxEntry THEN proc.a0 := entno; INC(entno) ELSE proc.a0 := 1; OCS.Mark(226) END
            END
         END ;
         proc.mode := mode; proc.typ := OCT.notyp; proc.dsc := NIL;
         INC(OCC.level); OCT.OpenScope(OCC.level);
         IF (mode = LProc) & (OCC.level = 1) THEN psize := LParOrg ELSE psize := XParOrg END ;
         IF sym = lparen THEN
            OCS.Get(sym); FormalParameters(proc.typ, psize); proc.dsc := OCT.topScope.next
         END ;
         IF proc1 # NIL THEN  (*forward*)
            OCH.CompareParLists(proc.dsc, proc1.dsc);
            IF proc.typ # proc1.typ THEN OCS.Mark(118) END
         END ;
         IF mode = CProc THEN
            IF sym = number THEN proc.a0 := OCS.intval; OCS.Get(sym) ELSE OCS.Mark(17) END
         END ;
         IF body THEN
            CheckSym(semicolon); OCT.topScope.typ := proc.typ;
            OCT.topScope.a1 := mode*10000H + psize; (*for RETURN statements*)
            OCH.Enter(mode, proc.a0, L1); par := proc.dsc;
            WHILE par # NIL DO
               (*code for dynamic array value parameters*)
               IF (par.typ.form = DynArr) & (par.mode = Var) THEN
                  OCH.CopyDynArray(par.a0, par.typ)
               END ;
               par := par.next
            END ;
            Block(dsize); proc.dsc := OCT.topScope.next;  (*update*)
            IF proc.typ = OCT.notyp THEN OCH.Return(proc.mode, psize) ELSE OCH.Trap(17) END ;
            IF dsize >= LDataSize THEN OCS.Mark(209); dsize := 0 END ;
            IF OCH.clrchk & (dsize <= 0) THEN dsize := 4 END ;
            OCC.FixupWith(L1, dsize); proc.a2 := OCC.pc;
            IF sym = ident THEN
               IF OCS.name # proc.name THEN OCS.Mark(4) END ;
               OCS.Get(sym)
            ELSE OCS.Mark(10)
            END
         END ;
         DEC(OCC.level); OCT.CloseScope
      END
   END ProcedureDeclaration;


   PROCEDURE CaseLabelList(LabelForm: INTEGER;
                  VAR n: INTEGER; VAR tab: ARRAY OF OCH.LabelRange);
      VAR x, y: OCT.Item; i, f: INTEGER;
   BEGIN
      IF ~(LabelForm IN labeltyps) THEN OCS.Mark(61) END ;
      LOOP ConstExpression(x); f := x.typ.form;
         IF f IN intSet THEN
            IF LabelForm < f THEN OCS.Mark(60) END
         ELSIF f # LabelForm THEN OCS.Mark(60)
         END ;
         IF sym = upto THEN
            OCS.Get(sym); ConstExpression(y);
            IF (y.typ.form # f) & ~((f IN intSet) & (y.typ.form IN intSet)) THEN OCS.Mark(60) END ;
            IF y.a0 < x.a0 THEN OCS.Mark(63); y.a0 := x.a0 END
         ELSE y := x
         END ;
         (*enter label range into ordered table*)  i := n;
         IF i < NofCases THEN
            LOOP
               IF i = 0 THEN EXIT END ;
               IF tab[i-1].low <= y.a0 THEN
                  IF tab[i-1].high >= x.a0 THEN OCS.Mark(62) END ;
                  EXIT
               END ;
               tab[i] := tab[i-1]; DEC(i)
            END ;
            tab[i].low := SHORT(x.a0); tab[i].high := SHORT(y.a0);
            tab[i].label := OCC.pc; INC(n)
         ELSE OCS.Mark(213)
         END ;
         IF sym = comma THEN OCS.Get(sym)
         ELSIF (sym = number) OR (sym = ident) THEN OCS.Mark(19)
         ELSE EXIT
         END
      END
   END CaseLabelList;

   PROCEDURE StatSeq;
      VAR fpar: OCT.Object; xtyp: OCT.Struct;
            x, y: OCT.Item; L0, L1, ExitIndex: INTEGER;

      PROCEDURE CasePart;
         VAR x: OCT.Item; n, L0, L1, L2, L3: INTEGER;
               tab: ARRAY NofCases OF OCH.LabelRange;
      BEGIN n := 0; L3 := 0;
         Expression(x); OCH.CaseIn(x, L0, L1); OCC.FreeRegs({});
         CheckSym(of);
         LOOP
            IF sym < bar THEN
               CaseLabelList(x.typ.form, n, tab);
               CheckSym(colon); StatSeq; OCH.FJ(L3)
            END ;
            IF sym = bar THEN OCS.Get(sym) ELSE EXIT END
         END ;
         L2 := OCC.pc;
         IF sym = else THEN
            OCS.Get(sym); StatSeq; OCH.FJ(L3)
         ELSE OCH.Trap(16)
         END ;
         OCH.CaseOut(L0, L1, L2, L3, n, tab)
      END CasePart;

   BEGIN
      LOOP
         IF sym < ident THEN OCS.Mark(14);
            REPEAT OCS.Get(sym) UNTIL sym >= ident
         END ;
         IF sym = ident THEN
            qualident(x); selector(x);
            IF sym = becomes THEN
               OCS.Get(sym); Expression(y); OCH.Assign(x, y, FALSE)
            ELSIF sym = eql THEN
               OCS.Mark(33); OCS.Get(sym); Expression(y); OCH.Assign(x, y, FALSE)
            ELSIF x.mode = SProc THEN
               StandProcCall(x);
               IF x.typ # OCT.notyp THEN OCS.Mark(55) END
            ELSE OCH.PrepCall(x, fpar);
               IF sym = lparen THEN
                  OCS.Get(sym); ActualParameters(x, fpar); CheckSym(rparen)
               ELSIF IsParam(fpar) THEN OCS.Mark(65)
               END ;
               OCH.Call(x);
               IF x.typ # OCT.notyp THEN OCS.Mark(55) END
            END
         ELSIF sym = if THEN
            OCS.Get(sym); Expression(x); OCH.CFJ(x, L0); OCC.FreeRegs({});
            CheckSym(then); StatSeq; L1 := 0;
            WHILE sym = elsif DO
               OCS.Get(sym); OCH.FJ(L1); OCC.FixLink(L0);
               Expression(x); OCH.CFJ(x, L0); OCC.FreeRegs({});
               CheckSym(then); StatSeq
            END ;
            IF sym = else THEN
               OCS.Get(sym); OCH.FJ(L1); OCC.FixLink(L0); StatSeq
            ELSE OCC.FixLink(L0)
            END ;
            OCC.FixLink(L1); CheckSym(end)
         ELSIF sym = case THEN
            OCS.Get(sym); CasePart; CheckSym(end)
         ELSIF sym = while THEN
            OCS.Get(sym); L1 := OCC.pc;
            Expression(x); OCH.CFJ(x, L0); OCC.FreeRegs({});
            CheckSym(do); StatSeq; OCH.BJ(L1); OCC.FixLink(L0);
            CheckSym(end)
         ELSIF sym = repeat THEN
            OCS.Get(sym); L0 := OCC.pc; StatSeq;
            IF sym = until THEN
               OCS.Get(sym); Expression(x); OCH.CBJ(x, L0)
            ELSE OCS.Mark(43)
            END
         ELSIF sym = loop THEN
            OCS.Get(sym); ExitIndex := ExitNo; INC(LoopLevel);
            L0 := OCC.pc; StatSeq; OCH.BJ(L0); DEC(LoopLevel);
            WHILE ExitNo > ExitIndex DO
               DEC(ExitNo); OCC.fixup(LoopExit[ExitNo])
            END ;
            CheckSym(end)
         ELSIF sym = with THEN
            OCS.Get(sym); x.obj := NIL; xtyp := NIL;
            IF sym = ident THEN
               qualident(x); CheckSym(colon);
               IF sym = ident THEN qualident(y);
                  IF y.mode = Typ THEN
                     IF x.obj # NIL THEN
                        IF x.typ.form = Pointer THEN OCS.Mark(-2) END ;
                        xtyp := x.typ; OCE.TypTest(x, y, FALSE); x.obj.typ := x.typ
                     ELSE OCS.Mark(130)
                     END
                  ELSE OCS.Mark(52)
                  END
               ELSE OCS.Mark(10)
               END
            ELSE OCS.Mark(10)
            END ;
            CheckSym(do); OCC.FreeRegs({}); StatSeq; CheckSym(end);
            IF xtyp# NIL THEN x.obj.typ := xtyp END
         ELSIF sym = exit THEN
            OCS.Get(sym); OCH.FJ(L0);
            IF LoopLevel = 0 THEN OCS.Mark(45)
            ELSIF ExitNo < 16 THEN LoopExit[ExitNo] := L0; INC(ExitNo)
            ELSE OCS.Mark(214)
            END
         ELSIF sym = return THEN OCS.Get(sym);
            IF OCC.level > 0 THEN
               IF sym < semicolon THEN
                  Expression(x); OCH.Result(x, OCT.topScope.typ)
               ELSIF OCT.topScope.typ # OCT.notyp THEN OCS.Mark(124)
               END ;
               OCH.Return(SHORT(OCT.topScope.a1 DIV 10000H), SHORT(OCT.topScope.a1))
            ELSE (*return from module body*)
               IF sym < semicolon THEN Expression(x); OCS.Mark(124) END ;
               OCH.Return(XProc, XParOrg)
            END
         END ;
         OCC.FreeRegs({});
         IF sym = semicolon THEN OCS.Get(sym)
         ELSIF (sym <= ident) OR (if <= sym) & (sym <= return) THEN OCS.Mark(38)
         ELSE EXIT
         END
      END
   END StatSeq;

   PROCEDURE Block(VAR dsize: LONGINT);
      VAR typ, forward: OCT.Struct;
         obj, first: OCT.Object;
         x: OCT.Item;
         L0: INTEGER;
         adr, size: LONGINT;
         mk: BOOLEAN;
         id0: ARRAY 32 OF CHAR;

   BEGIN adr := -dsize; obj := OCT.topScope;
      WHILE obj.next # NIL DO obj := obj.next END ;
      LOOP
         IF sym = const THEN
            OCS.Get(sym);
            WHILE sym = ident DO
               COPY(OCS.name, id0); CheckMark(mk);
               IF sym = eql THEN OCS.Get(sym); ConstExpression(x)
               ELSIF sym = becomes THEN OCS.Mark(9); OCS.Get(sym); ConstExpression(x)
               ELSE OCS.Mark(9)
               END ;
               OCT.Insert(id0, obj); obj.mode := SHORT(x.mode);
               obj.typ := x.typ; obj.a0 := x.a0; obj.a1 := x.a1; obj.marked := mk;
               CheckSym(semicolon)
            END
         END ;
         IF sym = type THEN
            OCS.Get(sym);
            WHILE sym = ident DO
               typ := OCT.undftyp; OCT.Insert(OCS.name, obj); forward := obj.typ;
               obj.mode := Typ; obj.typ := OCT.notyp; CheckMark(obj.marked);
               IF sym = eql THEN OCS.Get(sym); Type(typ)
               ELSIF (sym = becomes) OR (sym = colon) THEN OCS.Mark(9); OCS.Get(sym); Type(typ)
               ELSE OCS.Mark(9)
               END ;
               obj.typ := typ;
               IF typ.strobj = NIL THEN typ.strobj := obj END ;
               IF forward # NIL THEN (*fixup*) SetPtrBase(forward, typ) END ;
               CheckSym(semicolon)
            END
         END ;
         IF sym = var THEN
            OCS.Get(sym);
            WHILE sym = ident DO
               OCT.Insert(OCS.name, obj); first := obj; CheckMark(obj.marked); obj.mode := Var;
               LOOP
                  IF sym = comma THEN OCS.Get(sym)
                  ELSIF sym = ident THEN OCS.Mark(19)
                  ELSE EXIT
                  END ;
                  IF sym = ident THEN
                     OCT.Insert(OCS.name, obj); CheckMark(obj.marked); obj.mode := Var
                  ELSE OCS.Mark(10)
                  END
               END ;
               CheckSym(colon); Type(typ); size := typ.size;
               IF size >= 4 THEN DEC(adr, adr MOD 4)
               ELSIF size = 2 THEN DEC(adr, adr MOD 2)
               END ;
               WHILE first # NIL DO
                  first.typ := typ; DEC(adr, size); first.a0 := adr; first := first.next
               END ;
               CheckSym(semicolon)
            END
         END ;
         IF (sym < const) OR (sym > var) THEN EXIT END ;
      END ;

      CheckUndefPointerTypes;
      IF OCC.level = 0 THEN OCH.LFJ(L0) ELSE OCH.FJ(L0) END ;
      WHILE sym = procedure DO
         OCS.Get(sym); ProcedureDeclaration; CheckSym(semicolon)
      END ;
      IF OCC.level = 0 THEN OCC.fixupL(L0); OCC.InitTypDescs ELSE OCC.fixupC(L0) END ;
      IF sym = begin THEN OCS.Get(sym); StatSeq END ;
      dsize := (adr MOD 4) - adr; CheckSym(end)
   END Block;

   PROCEDURE CompilationUnit(source: Texts.Text; pos: LONGINT);
      VAR L0: INTEGER; ch: CHAR;
            time, date, key, dsize, tm: LONGINT;
            modid, impid, FName: ARRAY 32 OF CHAR;

      PROCEDURE MakeFileName(VAR name, FName: ARRAY OF CHAR; ext: ARRAY OF CHAR);
         VAR i, j: INTEGER; ch: CHAR;
      BEGIN i := 0;
         LOOP ch := name[i];
            IF ch = 0X THEN EXIT END ;
            FName[i] := ch; INC(i)
         END ;
         j := 0;
         REPEAT ch := ext[j]; FName[i] := ch; INC(i); INC(j)
         UNTIL ch = 0X
      END MakeFileName;

   BEGIN tm := Oberon.Time();
      entno := 1; dsize := 0; LoopLevel := 0; ExitNo := 0;
      OCC.Init; OCT.Init; OCS.Init(source, pos); OCS.Get(sym);
      Texts.WriteString(W, "  compiling ");
      IF sym = module THEN OCS.Get(sym) ELSE OCS.Mark(16) END ;
      IF sym = ident THEN
         Texts.WriteString(W, OCS.name); Texts.Append(Oberon.Log, W.buf);
         L0 := 0; ch := OCS.name[0];
         WHILE (ch # 0X) & (L0 < ModNameLen-1) DO modid[L0] := ch; INC(L0); ch := OCS.name[L0] END ;
         modid[L0] := 0X;
         IF ch # 0X THEN OCS.Mark(228) END ;
         OCT.OpenScope(0); OCS.Get(sym);
         CheckSym(semicolon); OCH.Enter(Mod, 0, L0);
         IF sym = import THEN
            OCS.Get(sym);
            LOOP
               IF sym = ident THEN
                  COPY(OCS.name, impid); OCS.Get(sym);
                  MakeFileName(impid, FName, ".Sym");
                  IF sym = becomes THEN OCS.Get(sym);
                     IF sym = ident THEN
                        MakeFileName(OCS.name, FName, ".Sym"); OCS.Get(sym)
                     ELSE OCS.Mark(10)
                     END
                  END ;
                  OCT.Import(impid, modid, FName)
               ELSE OCS.Mark(10)
               END ;
               IF sym = comma THEN OCS.Get(sym)
               ELSIF sym = ident THEN OCS.Mark(19)
               ELSE EXIT
               END
            END ;
            CheckSym(semicolon)
         END ;
         IF ~OCS.scanerr THEN
            OCC.SetLinkTable(OCT.nofGmod+1);
            Block(dsize); OCH.Return(XProc, 12);
            IF sym = ident THEN
               IF OCS.name # modid THEN OCS.Mark(4) END ;
               OCS.Get(sym)
            ELSE OCS.Mark(10)
            END ;
            IF sym # period THEN OCS.Mark(18) END ;
            IF ~OCS.scanerr THEN
               Oberon.GetClock(time, date); key := (date MOD 4000H) * 20000H + time;
               MakeFileName(modid, FName, ".Sym");
               OCT.Export(modid, FName, newSF, key);
               IF newSF THEN Texts.WriteString(W, " new symbol file") END ;
               IF ~OCS.scanerr THEN
                  MakeFileName(modid, FName, ".Obj");
                  OCC.OutCode(FName, modid, key, entno, dsize);
                  Texts.WriteInt(W, OCC.pc, 6); Texts.WriteInt(W, dsize, 6);
                  Texts.WriteInt(W, Oberon.Time() - tm, 6)
               END
            END
         END ;
         OCT.CloseScope
      ELSE OCS.Mark(10)
      END;
      OCC.Close; OCT.Close;
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END CompilationUnit;

   PROCEDURE Compile*;
      VAR beg, end, time: LONGINT;
         T: Texts.Text;
         S: Texts.Scanner;
         v: Viewers.Viewer;

      PROCEDURE Options;
         VAR ch: CHAR;
      BEGIN
         IF S.nextCh = "/" THEN
            LOOP Texts.Read(S, ch);
               IF ch = "x" THEN OCE.inxchk := FALSE
               ELSIF ch = "t" THEN OCC.typchk := FALSE
               ELSIF ch = "c" THEN OCH.clrchk := TRUE
               ELSIF ch = "s" THEN newSF := TRUE
               ELSE S.nextCh := ch; EXIT
               END
            END
         END
      END Options;

   BEGIN OCE.inxchk := TRUE; OCC.typchk := TRUE; OCH.clrchk := FALSE; newSF := FALSE;
      Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
      IF S.class = Texts.Char THEN
         IF S.c = "*" THEN
            v := Oberon.MarkedViewer();
            IF (v.dsc # NIL) & (v.dsc.next IS TextFrames.Frame) THEN
               Options; CompilationUnit(v.dsc.next(TextFrames.Frame).text, 0)
            END
         ELSIF S.c = "^" THEN
            Oberon.GetSelection(T, beg, end, time);
            IF time >= 0 THEN
               Texts.OpenScanner(S, T, beg); Texts.Scan(S);
               IF S.class = Texts.Name THEN
                  Options; Texts.WriteString(W, S.s); NEW(T); Texts.Open(T, S.s);
                  IF T.len # 0 THEN CompilationUnit(T, 0)
                  ELSE Texts.WriteString(W, " not found");
                     Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
                  END
               END
            END
         ELSIF S.c = "@" THEN
            Oberon.GetSelection(T, beg, end, time);
            IF time >= 0 THEN Options; CompilationUnit(T, beg) END
         END
      ELSE NEW(T);
         WHILE S.class = Texts.Name DO
            Options; Texts.WriteString(W, S.s); Texts.Open(T, S.s);
            IF T.len # 0 THEN CompilationUnit(T, 0)
            ELSE Texts.WriteString(W, " not found");
               Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
            END ;
            Texts.Scan(S)
         END
      END ;
      Oberon.Collect(0)
   END Compile;

BEGIN Texts.OpenWriter(W);
   Texts.WriteString(W, "Compiler  NW 19.7.92"); Texts.WriteLn(W);
   Texts.Append(Oberon.Log, W.buf)
END Compiler.
