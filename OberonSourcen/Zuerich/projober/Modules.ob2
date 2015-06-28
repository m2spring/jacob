MODULE  Modules;  (*NW 16.2.86 / 22.7.91*)
   IMPORT SYSTEM, Kernel, Files;

   CONST ModNameLen* = 20; ObjMark = 0F8X; maximps = 32;

   TYPE Module* = POINTER TO ModDesc;
      Command* = PROCEDURE;
      ModuleName* = ARRAY ModNameLen OF CHAR;

      ModDesc* = RECORD SB*, LB*, PB*, BB*, CB*, RB*, IB*, size*, key*: LONGINT;
            name*: ModuleName;
            refcnt*: LONGINT;
            link*: Module
         END ;

   VAR res*: INTEGER;
      importing*, imported*: ModuleName;
      loop: Command;

   (*Exported procedures: ThisMod, Free, ThisProc*)

   PROCEDURE ReadName(VAR R: Files.Rider; VAR s: ARRAY OF CHAR; n: INTEGER);
      VAR ch: CHAR; i: INTEGER;
   BEGIN i := 0;
      REPEAT Files.Read(R, ch); s[i] := ch; INC(i)
      UNTIL ch = 0X;
      WHILE i < n DO Files.Read(R, ch); s[i] := 0X; INC(i) END
   END ReadName;

   PROCEDURE OpenFile(VAR F: Files.File; VAR name: ARRAY OF CHAR);
      VAR i: INTEGER; ch: CHAR;
         Fname: ARRAY 32 OF CHAR;
   BEGIN i := 0; ch := name[0]; (*make file name*)
      WHILE ch > 0X DO Fname[i] := ch; INC(i); ch := name[i] END ;
      Fname[i] := "."; Fname[i+1] := "O"; Fname[i+2] := "b"; Fname[i+3] := "j"; Fname[i+4] := 0X;
      F := Files.Old(Fname)
   END OpenFile;

   PROCEDURE PD(mod: Module; pc: LONGINT): LONGINT;
   BEGIN (*procedure descriptor*)
      RETURN ASH(pc, 16) + SYSTEM.VAL(LONGINT, mod)
   END PD;

   PROCEDURE ThisMod*(name: ARRAY OF CHAR): Module;
      (*search module in list; if not found, load module*)

      VAR
         mod, impmod, md: Module;
         ch: CHAR; mno, pno: SHORTINT;
         i, j: INTEGER;
         nofentries, nofimps, nofptrs, comsize, noflinks, constsize, codesize: INTEGER;
         varsize, size, key, impkey, k, p, q, pos1, pos2: LONGINT;
         init: Command;
         F: Files.File; R: Files.Rider;
         modname, impname: ModuleName;
         import: ARRAY maximps OF Module;

      PROCEDURE err(n: INTEGER);
      BEGIN res := n; COPY(name, importing)
      END err;

   BEGIN res := 0; mod := SYSTEM.VAL(Module, Kernel.ModList);
      LOOP
         IF name = mod.name THEN EXIT END ;
         mod := mod.link;
         IF mod = NIL THEN EXIT END
      END ;
      IF mod = NIL THEN (*load*)
         OpenFile(F, name);
         IF F # NIL THEN
            Files.Set(R, F, 0); Files.Read(R, ch); (*header*)
            IF ch # ObjMark THEN err(2); RETURN NIL END ;
            Files.Read(R, ch);
            IF ch # "6" THEN err(2); RETURN NIL END ;
            Files.ReadBytes(R, k, 4);  (*skip*)
            Files.ReadBytes(R, nofentries, 2); Files.ReadBytes(R, comsize, 2);
            Files.ReadBytes(R, nofptrs, 2); Files.ReadBytes(R, nofimps, 2);
            Files.ReadBytes(R, noflinks, 2); Files.ReadBytes(R, varsize, 4);
            Files.ReadBytes(R, constsize, 2); Files.ReadBytes(R, codesize, 2);
            Files.ReadBytes(R, key, 4); ReadName(R, modname, ModNameLen);
            i := (nofentries + nofptrs)*2 + comsize;
            pos1 := Files.Pos(R); Files.Set(R, F, pos1 + i + 3);
            INC(i, nofimps*2); k := (i MOD 4) + i;
            (*imports*) Files.Read(R, ch);
            IF ch # 85X THEN err(4); RETURN NIL END ;
            IF nofimps > maximps THEN err(6); RETURN NIL END ;
            i := 0;
            WHILE (i < nofimps) & (res = 0) DO
               Files.ReadBytes(R, impkey, 4); ReadName(R, impname, 0); Files.Read(R, ch);
               impmod := ThisMod(impname);
               IF res = 0 THEN
                  IF impmod.key = impkey THEN import[i] := impmod; INC(i); INC(impmod.refcnt)
                  ELSE err(3); imported := impname
                  END
               END
            END ;
            IF res # 0 THEN
               WHILE i > 0 DO DEC(i); DEC(import[i].refcnt) END ;
               RETURN NIL
            END ;

            pos2 := Files.Pos(R);
            size := k + noflinks*4 + constsize + codesize + varsize;
            Kernel.AllocBlock(q, p, size); mod := SYSTEM.VAL(Module, q);
            IF p = 0 THEN err(7); RETURN NIL END ;
            mod.size := size;
            mod.BB := p;
            mod.CB := nofentries*2 + p;
            mod.RB := comsize + mod.CB;
            mod.IB := nofptrs*2 + mod.RB;
            mod.LB := k + p;
            mod.SB := (noflinks*4 + varsize) + mod.LB;
            mod.PB := constsize + mod.SB;
            mod.refcnt := 0;
            mod.key := key;
            mod.name := modname;

            (*entries*) q :=  mod.CB; Files.Set(R, F, pos1); Files.Read(R, ch);
            IF ch # 82X THEN err(4); RETURN NIL END ;
            WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p) END ;

            (*commands*) q := mod.RB; Files.Read(R, ch);
            IF ch # 83X THEN err(4); RETURN NIL END ;
            WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p) END ;

            (*pointer references*) q := mod.IB; Files.Read(R, ch);
            IF ch # 84X THEN err(4); RETURN NIL END ;
            WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p) END ;

            i := 0;
            WHILE i < nofimps DO SYSTEM.PUT(p, import[i]); INC(p, 2); INC(i) END ;

            (*links*) Files.Set(R, F, pos2+1); p := mod.LB; q := noflinks*4 + p;
            WHILE p < q DO
               Files.Read(R, pno); Files.Read(R, mno);
               IF mno > 0 THEN md := import[mno-1] ELSE md := mod END ;
               IF pno = -1 THEN SYSTEM.PUT(p, md.SB)   (*data segment entry*)
               ELSE SYSTEM.GET(pno*2 + md.BB, i); SYSTEM.PUT(p, PD(md, i))    (*procedure entry*)
               END ;
               INC(p, 4)
            END ;

            (*variables*) q := mod.SB;
            WHILE p < q DO SYSTEM.PUT(p, 0); INC(p) END ;

            (*constants*) q := mod.PB; Files.Read(R, ch);
            IF ch # 87X THEN err(4); RETURN NIL END ;
            WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p) END ;

            (*code*) q := p + codesize; Files.Read(R, ch);
            IF ch # 88X THEN err(4); RETURN NIL END ;
            WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p) END ;

            (*type descriptors*) Files.Read(R, ch);
            IF ch # 89X THEN err(4); RETURN NIL END ;
            LOOP Files.ReadBytes(R, i, 2);
               IF R.eof OR (i MOD 100H = 8AH) THEN EXIT END ;
               Files.ReadBytes(R, j, 2);  (*adr*)
(*<<<<<<<<<<<<<<<
               SYSTEM.NEW(md, i);
>>>>>>>>>>>>>>>*)
               p := SYSTEM.VAL(LONGINT, md); q := p + i;
               REPEAT Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p) UNTIL p = q;
               SYSTEM.PUT(mod.SB + j, md)
            END ;

            init := SYSTEM.VAL(Command, mod); init; res := 0
         ELSE COPY(name, imported); err(1)
         END
      END ;
      RETURN mod
   END ThisMod;

   PROCEDURE ThisCommand*(mod: Module; name: ARRAY OF CHAR): Command;
      VAR i: INTEGER; ch: CHAR;
            comadr: LONGINT; com: Command;
   BEGIN com := NIL;
      IF mod # NIL THEN
         comadr := mod.CB; res := 5;
         LOOP SYSTEM.GET(comadr, ch); INC(comadr);
            IF ch = 0X THEN (*not found*) EXIT END ;
            i := 0;
            LOOP
               IF ch # name[i] THEN EXIT END ;
               INC(i);
               IF ch = 0X THEN res := 0; EXIT END ;
               SYSTEM.GET(comadr, ch); INC(comadr)
            END ;
            IF res = 0 THEN (*match*)
               SYSTEM.GET(comadr, i); com := SYSTEM.VAL(Command, PD(mod, i)); EXIT
            ELSE
               WHILE ch > 0X DO SYSTEM.GET(comadr, ch); INC(comadr) END ;
               INC(comadr, 2)
            END
         END
      END ;
      RETURN com
   END ThisCommand;

   PROCEDURE unload(mod: Module; all: BOOLEAN);
      VAR p: LONGINT; k: INTEGER;
         imp: Module;
   BEGIN p := mod.IB;
      WHILE p < mod.LB DO  (*scan imports*)
         SYSTEM.GET(p, k); imp := SYSTEM.VAL(Module, LONG(k));
         IF imp # NIL THEN
            DEC(imp.refcnt);
            IF all & (imp.refcnt = 0) THEN unload(imp, all) END
         END ;
         INC(p, 2)
      END ;
      Kernel.FreeBlock(SYSTEM.VAL(LONGINT, mod))
   END unload;

   PROCEDURE Free*(name: ARRAY OF CHAR; all: BOOLEAN);
      VAR mod: Module;
   BEGIN mod :=  SYSTEM.VAL(Module, Kernel.ModList);
      LOOP
         IF mod = NIL THEN res := 1; EXIT END ;
         IF name = mod.name THEN
            IF mod.refcnt = 0 THEN unload(mod, all); res := 0 ELSE res := 2 END ;
            EXIT
         END ;
         mod := mod.link
      END
   END Free;

BEGIN
   IF Kernel.err = 0 THEN loop := ThisCommand(ThisMod("Oberon"), "Loop") END ;
   loop
END Modules.
