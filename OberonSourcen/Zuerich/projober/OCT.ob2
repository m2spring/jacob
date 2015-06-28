MODULE OCT;  (*NW 28.5.87 / 5.3.91*)

   IMPORT Files, OCS;

   CONST maxImps = 24; SFtag = 0FAX; firstStr = 16;
         maxStr = 80; maxUDP = 16; maxMod = 24; maxParLev = 6;
         PtrSize = 4; ProcSize = 4; NotYetExp = 0;
      (*object modes*)
         Var = 1; Ind = 3; Con = 8; Fld = 12; Typ = 13;
         XProc = 15; SProc = 16; CProc = 17; Mod = 19; Head = 20;

      (*structure forms*)
         Undef = 0; Byte = 1; Bool = 2; Char = 3; SInt = 4; Int = 5; LInt = 6;
         Real = 7; LReal = 8; Set = 9; String = 10; NilTyp = 11; NoTyp = 12;
         Pointer = 13; ProcTyp = 14; Array = 15; DynArr = 16; Record = 17;

   TYPE
      Object* = POINTER TO ObjDesc;
      Struct* = POINTER TO StrDesc;

      ObjDesc* = RECORD
                        dsc*, next*: Object;
                        typ*:  Struct;
                        a0*, a1*:  LONGINT;
                        a2*: INTEGER;
                        mode*: SHORTINT;
                        marked*: BOOLEAN;
                        name*: ARRAY 32 OF CHAR;
                     END ;

      StrDesc* = RECORD
                        form*, n*, mno*, ref*: INTEGER;
                        size*, adr*: LONGINT;
                        BaseTyp*: Struct;
                        link*, strobj*: Object
                     END ;

      Item* =    RECORD
                        mode*, lev*: INTEGER;
                        a0*, a1*, a2*: LONGINT;
                        typ*: Struct;
                        obj*: Object
                     END ;

   (* Objects and Items:

         mode  | a0    a1    dsc   | lev  a0   a1   a2   obj
    -----------------------------------------------------------------
      0 Undef |                   |
      1 Var   | vadr              | lev  vadr           obj
      2 VarX  |                   | lev  vadr      RX
      3 Ind   |                   | lev  vadr off
      4 IndX  |                   | lev  vadr off  RX
      5 RegI  |                   |      R    off
      6 RegX  |                   |      R    off  RX
      7 Abs   |                   |      adr
      8 Con   | val               |      val  val
                  | sadr  leng        |      sadr leng (Strings)
      9 Stk   |                   |
    10 Coc   |                   |      CC   Tjmp Fjmp
    11 Reg   |                   |      R
    12 Fld   | off              |      off            obj
    13 Typ   |                   | mno  tadr           obj
    14 LProc | adr         par   |      adr            obj
    15 XProc | pno   Ladr  par   | mno  pno  Ladr      obj
    16 SProc | fno               |      fno
    17 CProc | cno         par   |      cno            obj
    18 IProc | adr   Ladr        |      adr  Ladr      obj
    19 Mod   | mno   key         |      mno            obj
    20 Head  | lev   psize       |

      Structures:

         form    | n     BaseTyp   link     mno   adr
    ------------------------------------------------
      0 Undef   |
      1 Byte    |
      2 Bool    |
      3 Char    |
      4 SInt    |
      5 Int     |
      6 LInt    |
      7 Real    |
      8 LReal   |
      9 Set     |
    10 String  |
    11 NilTyp  |
    12 NoTyp   |
    13 Pointer |       PBaseTyp
    14 ProcTyp |       ResTyp    param
    15 Array   | nofel ElemTyp            mno   bounds
    16 DynArr  |       ElemTyp
    17 Record  | exlev RBaseTyp  fields   mno   descr  *)

   VAR topScope*: Object;
      undftyp*, bytetyp*, booltyp*, chartyp*, sinttyp*, inttyp*, linttyp*,
      realtyp*, lrltyp*, settyp*, stringtyp*, niltyp*, notyp*: Struct;
      nofGmod*: INTEGER;   (*nof imports*)
      GlbMod*:  ARRAY maxImps OF Object;

      universe, syslink: Object;
      strno, udpinx: INTEGER;  (*for export*)
      nofExp: SHORTINT;
      SR: Files.Rider;
      undPtr: ARRAY maxUDP OF Struct;

   PROCEDURE Init*;
   BEGIN topScope := universe; strno := 0; udpinx := 0; nofGmod := 0
   END Init;

   PROCEDURE Close*;
      VAR i: INTEGER;
   BEGIN Files.Set(SR, NIL, 0); i := 0;
      WHILE i < maxImps DO GlbMod[i] := NIL; INC(i) END
   END Close;

   PROCEDURE FindImport*(mod: Object; VAR res: Object);
      VAR obj: Object;
   BEGIN obj := mod.dsc;
      WHILE (obj # NIL) & (obj.name # OCS.name) DO obj := obj.next END ;
      IF (obj # NIL) & (obj.mode = Typ) & ~obj.marked THEN obj := NIL END ;
      res := obj
   END FindImport;

   PROCEDURE Find*(VAR res: Object; VAR level: INTEGER);
      VAR obj, head: Object;
   BEGIN head := topScope;
      LOOP obj := head.next;
         WHILE (obj # NIL) & (obj.name # OCS.name) DO obj := obj.next END ;
         IF obj # NIL THEN level := SHORT(head.a0); EXIT END ;
         head := head.dsc;
         IF head = NIL THEN level := 0; EXIT END
      END ;
      res := obj
   END Find;

   PROCEDURE FindField*(typ: Struct; VAR res: Object);
      VAR obj: Object;
   BEGIN (*typ.form = Record*)
      LOOP obj := typ.link;
         WHILE (obj # NIL) & (obj.name # OCS.name) DO obj := obj.next END ;
         IF obj # NIL THEN EXIT END ;
         typ := typ.BaseTyp;
         IF typ = NIL THEN EXIT END
      END ;
      res := obj
   END FindField;

   PROCEDURE Insert*(VAR name: ARRAY OF CHAR; VAR res: Object);
      VAR obj, new: Object;
   BEGIN obj := topScope;
      WHILE (obj.next # NIL) & (obj.next.name # name) DO obj := obj.next END ;
      IF obj.next = NIL THEN NEW(new);
         new.dsc := NIL; new.next := NIL; COPY(name, new.name); obj.next := new; res := new
      ELSE res := obj.next;
         IF obj.next.mode # Undef THEN OCS.Mark(1) END
      END
   END Insert;

   PROCEDURE Remove*(del: Object);
      VAR obj: Object;
   BEGIN obj := topScope;
      WHILE obj.next # del DO obj := obj.next END ;
      obj.next := del.next
   END Remove;

   PROCEDURE OpenScope*(level: INTEGER);
      VAR head: Object;
   BEGIN NEW(head);
      head.mode := Head; head.a0 := level; head.typ := NIL;
      head.dsc := topScope; head.next := NIL; topScope := head
   END OpenScope;

   PROCEDURE CloseScope*;
   BEGIN topScope := topScope.dsc
   END CloseScope;

   (*---------------------- import ------------------------*)

   PROCEDURE ReadInt(VAR i: INTEGER);
   BEGIN Files.ReadBytes(SR, i, 2)
   END ReadInt;

   PROCEDURE ReadXInt(VAR k: LONGINT);
      VAR i: INTEGER;
   BEGIN Files.ReadBytes(SR, i, 2); k := i
   END ReadXInt;

   PROCEDURE ReadLInt(VAR k: LONGINT);
   BEGIN Files.ReadBytes(SR, k, 4)
   END ReadLInt;

   PROCEDURE ReadId(VAR id: ARRAY OF CHAR);
      VAR i: INTEGER; ch: CHAR;
   BEGIN i := 0;
      REPEAT Files.Read(SR, ch); id[i] := ch; INC(i)
      UNTIL ch = 0X
   END ReadId;

   PROCEDURE Import*(VAR name, self, FileName: ARRAY OF CHAR);
      VAR i, j, m, s, class: INTEGER; k: LONGINT;
            nofLmod, strno, parlev, fldlev: INTEGER;
            obj, ob0: Object;
            typ: Struct;
            ch, ch1, ch2: CHAR;
            si: SHORTINT;
            xval: REAL; yval: LONGREAL;
            SymFile: Files.File;
            modname: ARRAY 32 OF CHAR;
            LocMod:  ARRAY maxMod OF Object;
            struct:  ARRAY maxStr OF Struct;
            lastpar, lastfld: ARRAY maxParLev OF Object;

      PROCEDURE reversedList(p: Object): Object;
         VAR q, r: Object;
      BEGIN q := NIL;
         WHILE p # NIL DO
            r := p.next; p.next := q; q := p; p := r
         END ;
         RETURN q
      END reversedList;

   BEGIN nofLmod := 0; strno := firstStr;
      parlev := -1; fldlev := -1;
      IF FileName = "SYSTEM.Sym" THEN
         Insert(name, obj); obj.mode := Mod; obj.dsc := syslink;
         obj.a0 := 0; obj.typ := notyp
      ELSE SymFile := Files.Old(FileName);
         IF SymFile # NIL THEN
            Files.Set(SR, SymFile, 0); Files.Read(SR, ch);
            IF ch = SFtag THEN
               struct[Undef] := undftyp; struct[Byte] := bytetyp;
               struct[Bool] := booltyp;  struct[Char] := chartyp;
               struct[SInt] := sinttyp;  struct[Int] := inttyp;
               struct[LInt] := linttyp;  struct[Real] := realtyp;
               struct[LReal] := lrltyp;  struct[Set] := settyp;
               struct[String] := stringtyp; struct[NilTyp] := niltyp; struct[NoTyp] := notyp;
               LOOP (*read next item from symbol file*)
                  Files.Read(SR, ch); class := ORD(ch);
                  IF SR.eof THEN EXIT END ;
                  CASE class OF
                    0: OCS.Mark(151)
                  | 1..7: (*object*) NEW(obj); m := 0;
                     Files.Read(SR, ch); s := ORD(ch); obj.typ := struct[s];
                     CASE class OF
                       1: obj.mode := Con;
                              CASE obj.typ.form OF
                                 2,4: Files.Read(SR, si); obj.a0 := si
                              | 1,3: Files.Read(SR, ch); obj.a0 := ORD(ch)
                              | 5: ReadXInt(obj.a0)
                              | 6,7,9: ReadLInt(obj.a0)
                              | 8: ReadLInt(obj.a0); ReadLInt(obj.a1)
                              | 10: ReadId(obj.name); OCS.Mark(151)
                              | 11: (*NIL*)
                              END
                     |2,3: obj.mode := Typ; Files.Read(SR, ch); m := ORD(ch);
                              IF obj.typ.strobj = NIL THEN obj.typ.strobj := obj END;
                              obj.marked := class = 2
                     |4: obj.mode := Var; ReadLInt(obj.a0)
                     |5,6,7: IF class # 7 THEN obj.mode := XProc; Files.Read(SR, ch)
                              ELSE obj.mode := CProc;
                                 Files.Read(SR, ch); Files.Read(SR, ch); Files.Read(SR, ch)
                              END ;
                              obj.a0 := ORD(ch); obj.a1 := 0;  (*link adr*)
                              obj.dsc := reversedList(lastpar[parlev]); DEC(parlev)
                     END ;
                     ReadId(obj.name); ob0 := LocMod[m];
                     WHILE (ob0.next # NIL) & (ob0.next.name # obj.name) DO ob0 := ob0.next END ;
                     IF ob0.next = NIL THEN ob0.next := obj; obj.next := NIL  (*insert object*)
                     ELSIF obj.mode = Typ THEN struct[s] := ob0.next.typ
                     END
                  | 8..12: (*structure*)
                     NEW(typ); typ.strobj := NIL; typ.ref := 0;
                     Files.Read(SR, ch); typ.BaseTyp := struct[ORD(ch)];
                     Files.Read(SR, ch); typ.mno := SHORT(LocMod[ORD(ch)].a0);
                     CASE class OF
                         8: typ.form := Pointer; typ.size := PtrSize; typ.n := 0
                     |  9: typ.form := ProcTyp; typ.size := ProcSize;
                              typ.link := reversedList(lastpar[parlev]); DEC(parlev)
                     | 10: typ.form := Array; ReadLInt(typ.size);
                              ReadXInt(typ.adr); ReadLInt(k); typ.n := SHORT(k)
                     | 11: typ.form := DynArr; ReadLInt(typ.size); ReadXInt(typ.adr)
                     | 12: typ.form := Record; ReadLInt(typ.size); typ.n := 0;
                              typ.link := reversedList(lastfld[fldlev]); DEC(fldlev);
                              IF typ.BaseTyp = notyp THEN typ.BaseTyp := NIL; typ.n := 0
                              ELSE typ.n := typ.BaseTyp.n + 1
                              END ;
                              ReadXInt(typ.adr) (*of descriptor*)
                     END ;
                     struct[strno] := typ; INC(strno)
                  | 13: (*parameter list start*)
                     IF parlev < maxParLev-1 THEN INC(parlev); lastpar[parlev] := NIL
                     ELSE OCS.Mark(229)
                     END
                  | 14, 15: (*parameter*)
                     NEW(obj);
                     IF class = 14 THEN obj.mode := Var ELSE obj.mode := Ind END ;
                     Files.Read(SR, ch); obj.typ := struct[ORD(ch)];
                     ReadXInt(obj.a0); ReadId(obj.name);
                     obj.dsc := NIL; obj.next := lastpar[parlev]; lastpar[parlev] := obj
                  | 16: (*start field list*)
                     IF fldlev < maxParLev-1 THEN INC(fldlev); lastfld[fldlev] := NIL
                     ELSE OCS.Mark(229)
                     END
                  | 17: (*field*)
                     NEW(obj); obj.mode := Fld; Files.Read(SR, ch);
                     obj.typ := struct[ORD(ch)]; ReadLInt(obj.a0);
                     ReadId(obj.name); obj.marked := TRUE;
                     obj.dsc := NIL; obj.next := lastfld[fldlev]; lastfld[fldlev] := obj
                  | 18: (*hidden pointer field*)
                     NEW(obj); obj.mode := Fld; ReadLInt(obj.a0);
                     obj.name := ""; obj.typ := notyp; obj.marked := FALSE;
                     obj.dsc := NIL; obj.next := lastfld[fldlev]; lastfld[fldlev] := obj
                  | 19: (*hidden procedure field*)
                     ReadLInt(k)
                  | 20: (*fixup pointer typ*)
                     Files.Read(SR, ch); typ := struct[ORD(ch)];
                     Files.Read(SR, ch1);
                     IF typ.BaseTyp = undftyp THEN typ.BaseTyp := struct[ORD(ch1)] END
                  | 21, 23, 24: OCS.Mark(151); EXIT
                  | 22: (*module anchor*)
                     ReadLInt(k); ReadId(modname);
                     IF modname = self THEN OCS.Mark(49) END;
                     i := 0;
                     WHILE (i < nofGmod) & (modname # GlbMod[i].name) DO INC(i) END ;
                     IF i < nofGmod THEN (*module already present*)
                        IF k # GlbMod[i].a1 THEN OCS.Mark(150) END ;
                        obj := GlbMod[i]
                     ELSE NEW(obj);
                        IF nofGmod < maxImps THEN GlbMod[nofGmod] := obj; INC(nofGmod)
                        ELSE OCS.Mark(227)
                        END ;
                        obj.mode := NotYetExp; COPY(modname, obj.name);
                        obj.a1 := k; obj.a0 := nofGmod; obj.next := NIL
                     END ;
                     IF nofLmod < maxMod THEN LocMod[nofLmod] := obj; INC(nofLmod)
                     ELSE OCS.Mark(227)
                     END
                  END
               END (*LOOP*) ;
               Insert(name, obj);
               obj.mode := Mod; obj.dsc := LocMod[0].next;
               obj.a0  := LocMod[0].a0; obj.typ := notyp
            ELSE OCS.Mark(151)
            END
         ELSE OCS.Mark(152)   (*sym file not found*)
         END
      END
   END Import;

   (*---------------------- export ------------------------*)

   PROCEDURE WriteByte(i: INTEGER);
   BEGIN Files.Write(SR, CHR(i))
   END WriteByte;

   PROCEDURE WriteInt(i: LONGINT);
   BEGIN Files.WriteBytes(SR, i, 2)
   END WriteInt;

   PROCEDURE WriteLInt(k: LONGINT);
   BEGIN Files.WriteBytes(SR, k, 4)
   END WriteLInt;

   PROCEDURE WriteId(VAR name: ARRAY OF CHAR);
      VAR ch: CHAR; i: INTEGER;
   BEGIN i := 0;
      REPEAT ch := name[i]; Files.Write(SR, ch); INC(i)
      UNTIL ch = 0X
   END WriteId;

   PROCEDURE^ OutStr(typ: Struct);

   PROCEDURE OutPars(par: Object);
   BEGIN WriteByte(13);
      WHILE (par # NIL) & (par.mode <= Ind) & (par.a0 > 0) DO
         OutStr(par.typ);
         IF par.mode = Var THEN WriteByte(14) ELSE WriteByte(15) END ;
         WriteByte(par.typ.ref); WriteInt(par.a0); WriteId(par.name); par := par.next
      END
   END OutPars;

   PROCEDURE OutFlds(fld: Object; adr: LONGINT; visible: BOOLEAN);
   BEGIN
      IF visible THEN WriteByte(16) END ;
      WHILE fld # NIL DO
         IF fld.marked & visible THEN
            OutStr(fld.typ); WriteByte(17); WriteByte(fld.typ.ref);
            WriteLInt(fld.a0); WriteId(fld.name)
         ELSIF fld.typ.form = Record THEN OutFlds(fld.typ.link, fld.a0 + adr, FALSE)
         ELSIF (fld.typ.form = Pointer) OR (fld.name = "") THEN
            WriteByte(18); WriteLInt(fld.a0 + adr)
         END ;
         fld := fld.next
      END
   END OutFlds;

   PROCEDURE OutStr(typ: Struct);
      VAR m, em, r: INTEGER; btyp: Struct; mod: Object;
   BEGIN
      IF typ.ref = 0 THEN
         m := typ.mno; btyp := typ.BaseTyp;
         IF m > 0 THEN mod := GlbMod[m-1]; em := mod.mode;
            IF em = NotYetExp THEN
               GlbMod[m-1].mode := nofExp; m := nofExp; INC(nofExp);
               WriteByte(22); WriteLInt(mod.a1); WriteId(mod.name)
            ELSE m := em
            END
         END;
         CASE typ.form OF
            Undef .. NoTyp:
         | Pointer: WriteByte(8);
                  IF btyp.ref > 0 THEN WriteByte(btyp.ref)
                  ELSE WriteByte(Undef);
                     IF udpinx < maxUDP THEN undPtr[udpinx] := typ; INC(udpinx) ELSE OCS.Mark(224) END
                  END ;
                  WriteByte(m)
         | ProcTyp: OutStr(btyp); OutPars(typ.link);
                  WriteByte(9); WriteByte(btyp.ref); WriteByte(m)
         | Array: OutStr(btyp);
                  WriteByte(10); WriteByte(btyp.ref); WriteByte(m);
                  WriteLInt(typ.size); WriteInt(typ.adr); WriteLInt(typ.n)
         | DynArr: OutStr(btyp);
                  WriteByte(11); WriteByte(btyp.ref); WriteByte(m);
                  WriteLInt(typ.size); WriteInt(typ.adr)
         | Record:
                  IF btyp = NIL THEN r := NoTyp
                  ELSE OutStr(btyp); r := btyp.ref
                  END ;
                  OutFlds(typ.link, 0, TRUE); WriteByte(12); WriteByte(r); WriteByte(m);
                  WriteLInt(typ.size); WriteInt(typ.adr)
         END ;
         IF typ.strobj # NIL THEN
            IF typ.strobj.marked THEN WriteByte(2) ELSE WriteByte(3) END;
            WriteByte(strno); WriteByte(m); WriteId(typ.strobj.name)
         END ;
         typ.ref := strno; INC(strno);
         IF strno > maxStr THEN OCS.Mark(228) END
      END
   END OutStr;

   PROCEDURE OutObjs;
      VAR obj: Object;
         f: INTEGER; xval: REAL; yval: LONGREAL;
   BEGIN obj := topScope.next;
      WHILE obj # NIL DO
         IF obj.marked THEN
            IF obj.mode = Con THEN
               WriteByte(1); f := obj.typ.form; WriteByte(f);
                CASE f OF
                   Undef:
                | Byte, Bool, Char, SInt: WriteByte(SHORT(obj.a0))
                | Int: WriteInt(SHORT(obj.a0))
                | LInt, Real, Set: WriteLInt(obj.a0)
                | LReal:  WriteLInt(obj.a0); WriteLInt(obj.a1)
                | String: WriteByte(0); OCS.Mark(221)
                | NilTyp:
                END;
               WriteId(obj.name)
            ELSIF obj.mode = Typ THEN
               OutStr(obj.typ);
               IF (obj.typ.strobj # obj) & (obj.typ.strobj # NIL) THEN
                  WriteByte(2); WriteByte(obj.typ.ref); WriteByte(0); WriteId(obj.name)
               END
            ELSIF obj.mode = Var THEN
               OutStr(obj.typ); WriteByte(4);
               WriteByte(obj.typ.ref); WriteLInt(obj.a0); WriteId(obj.name)
            ELSIF obj.mode = XProc THEN
               OutStr(obj.typ); OutPars(obj.dsc); WriteByte(5);
               WriteByte(obj.typ.ref); WriteByte(SHORT(obj.a0)); WriteId(obj.name)
            ELSIF obj.mode = CProc THEN
               OutStr(obj.typ); OutPars(obj.dsc); WriteByte(7);
               WriteByte(obj.typ.ref); WriteByte(2); WriteByte(226);
               WriteByte(SHORT(obj.a0)); WriteId(obj.name)
            END
         END ;
         obj := obj.next
      END
   END OutObjs;

   PROCEDURE Export*(VAR name, FileName: ARRAY OF CHAR;
         VAR newSF: BOOLEAN; VAR key: LONGINT);
      VAR i: INTEGER;
         ch0, ch1: CHAR;
         oldkey: LONGINT;
         typ: Struct;
         oldFile, newFile: Files.File;
         oldSR: Files.Rider;
   BEGIN newFile := Files.New(FileName);
      IF newFile # NIL THEN
         Files.Set(SR, newFile, 0); Files.Write(SR, SFtag); strno := firstStr;
         WriteByte(22); WriteLInt(key); WriteId(name); nofExp := 1;
         OutObjs; i := 0;
         WHILE i < udpinx DO
            typ := undPtr[i]; OutStr(typ.BaseTyp); undPtr[i] := NIL; INC(i);
            WriteByte(20); (*fixup*)
            WriteByte(typ.ref); WriteByte(typ.BaseTyp.ref)
         END ;
         IF ~OCS.scanerr THEN
            oldFile := Files.Old(FileName);
            IF oldFile # NIL THEN (*compare*)
               Files.Set(oldSR, oldFile, 2); Files.ReadBytes(oldSR, oldkey, 4); Files.Set(SR, newFile, 6);
               REPEAT Files.Read(oldSR, ch0); Files.Read(SR, ch1)
               UNTIL (ch0 # ch1) OR SR.eof;
               IF oldSR.eof & SR.eof THEN (*equal*) newSF := FALSE;  key := oldkey
               ELSIF newSF THEN Files.Register(newFile)
               ELSE OCS.Mark(155)
               END
            ELSE Files.Register(newFile); newSF := TRUE
            END
         ELSE newSF := FALSE
         END
      ELSE OCS.Mark(153)
      END
   END Export;

   (*------------------------ initialization ------------------------*)

   PROCEDURE InitStruct(VAR typ: Struct; f: INTEGER);
   BEGIN NEW(typ); typ.form := f; typ.ref := f; typ.size := 1
   END InitStruct;

   PROCEDURE EnterConst(name: ARRAY OF CHAR; value: INTEGER);
      VAR obj: Object;
   BEGIN Insert(name, obj); obj.mode := Con; obj.typ := booltyp; obj.a0 := value
   END EnterConst;

   PROCEDURE EnterTyp(name: ARRAY OF CHAR; form, size: INTEGER; VAR res: Struct);
      VAR obj: Object; typ: Struct;
   BEGIN Insert(name, obj);
      NEW(typ); obj.mode := Typ; obj.typ := typ; obj.marked := TRUE;
      typ.form := form; typ.strobj := obj; typ.size := size;
      typ.mno := 0; typ.ref := form; res := typ
   END EnterTyp;

   PROCEDURE EnterProc(name: ARRAY OF CHAR; num: INTEGER);
      VAR obj: Object;
   BEGIN Insert(name, obj); obj.mode := SProc; obj.typ := notyp; obj.a0 := num
   END EnterProc;

BEGIN topScope := NIL; InitStruct(undftyp, Undef); InitStruct(notyp, NoTyp);
   InitStruct(stringtyp, String); InitStruct(niltyp, NilTyp); OpenScope(0);

   (*initialization of module SYSTEM*)
   EnterProc("LSH", 22);
   EnterProc("ROT", 23);
   EnterProc("ADR",  9);
   EnterProc("OVFL",15);
   EnterProc("GET", 24);
   EnterProc("PUT", 25);
   EnterProc("BIT", 26);
   EnterProc("VAL", 27);
   EnterProc("NEW", 28);
   EnterProc("MOVE",30);
   EnterProc("CC",  2);
   EnterTyp("BYTE", Byte, 1, bytetyp);
   syslink := topScope.next;
   universe := topScope; topScope.next := NIL;

   EnterTyp("CHAR", Char, 1, chartyp);
   EnterTyp("SET", Set, 4, settyp);
   EnterTyp("REAL", Real, 4, realtyp);
   EnterTyp("INTEGER", Int, 2, inttyp);
   EnterTyp("LONGINT",  LInt, 4, linttyp);
   EnterTyp("LONGREAL", LReal, 8, lrltyp);
   EnterTyp("SHORTINT", SInt, 1, sinttyp);
   EnterTyp("BOOLEAN", Bool, 1, booltyp);
   EnterProc("INC",   16);
   EnterProc("DEC",   17);
   EnterConst("FALSE", 0);
   EnterConst("TRUE",  1);
   EnterProc("HALT",   0);
   EnterProc("NEW",    1);
   EnterProc("ABS",    3);
   EnterProc("CAP",    4);
   EnterProc("ORD",    5);
   EnterProc("ENTIER", 6);
   EnterProc("SIZE",   7);
   EnterProc("ODD",    8);
   EnterProc("MIN",   10);
   EnterProc("MAX",   11);
   EnterProc("CHR",   12);
   EnterProc("SHORT", 13);
   EnterProc("LONG",  14);
   EnterProc("INCL",  18);
   EnterProc("EXCL",  19);
   EnterProc("LEN",   20);
   EnterProc("ASH",   21);
   EnterProc("COPY",  29);
END OCT.
