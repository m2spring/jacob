MODULE  Modules;
IMPORT SYSTEM, Kernel, Files;

	CONST ModNameLen* = Kernel.ModNameLen; ObjMark = 0F8X; MaxImps = 32;

	TYPE
		Module* = Kernel.Module;
		Command* = PROCEDURE;
		ModuleName* = Kernel.ModuleName;
	VAR res*: INTEGER;
		importing*, imported*: ModuleName;
		loop: Command;

	CONST
		NumKernelServices = 3;

	VAR (* contains addresses of Kernel's compiler helpers; initialized by Loader.Obj *)
		KernelAdr : LONGINT; (* holds address of KernelServices for Loader.Obj *)
		KernelServices* : ARRAY NumKernelServices OF LONGINT; (* Kernel function addresses *)
	PROCEDURE ReadName(VAR R: Files.Rider; VAR s: ARRAY OF CHAR; n: INTEGER);
		VAR ch: CHAR; i: INTEGER;
	BEGIN i := 0; REPEAT Files.Read(R, ch); s[i] := ch; INC(i) UNTIL ch = 0X;
		WHILE i < n DO Files.Read(R, ch); s[i] := 0X; INC(i) END;
	END ReadName;

	PROCEDURE OpenFile(VAR F: Files.File; VAR name: ARRAY OF CHAR);
		VAR i: INTEGER; ch: CHAR; Fname: ARRAY 32 OF CHAR;
	BEGIN
		i := 0; ch := name[0]; (*make file name*)
		WHILE ch > 0X DO Fname[i] := ch; INC(i); ch := name[i] END ;
		Fname[i] := "."; Fname[i+1] := "O"; Fname[i+2] := "b"; Fname[i+3] := "j"; Fname[i+4] := 0X;
		F := Files.Old(Fname);
	END OpenFile;

	(* PD returns the address of the procedure in the module.  The use of this
   	result depends on the relative or absolute nature of the fixup
	*)
	PROCEDURE PD(md : Module; pno : LONGINT) : LONGINT;
	VAR v : LONGINT;
	BEGIN SYSTEM.GET(md.BB + pno * 4, v); RETURN md.PB + v;
	END PD;


	(*XXX*)
	PROCEDURE OutputMod(mod : Module);

		PROCEDURE WriteName(VAR name : ARRAY OF CHAR);
		VAR i : INTEGER; ch : CHAR;
		BEGIN i := 0; ch := name[0];
			WHILE ch # 0X DO Kernel.DebugWrite(ch); INC(i); ch := name[i]; END;
			WHILE i < 10 DO Kernel.DebugWrite(' '); INC(i); END;
		END WriteName;

	BEGIN
		Kernel.DebugWriteString('Init:');
		WriteName(mod.name); Kernel.DebugWriteHex(SYSTEM.VAL(LONGINT, mod));
		Kernel.DebugWriteHex(mod.SB); Kernel.DebugWriteHex(mod.LB);
		Kernel.DebugWriteHex(mod.PB); Kernel.DebugWriteString(' /');
		Kernel.DebugWriteHex(mod.size); Kernel.DebugWriteHex(mod.BB);
		Kernel.DebugWriteHex(mod.CB); Kernel.DebugWriteHex(mod.RB);
		Kernel.DebugWriteHex(mod.IB); Kernel.DebugWriteHex(mod.key); Kernel.DebugNL;
	END OutputMod;


	PROCEDURE ThisMod*(name: ARRAY OF CHAR): Module;
	VAR
		init: Command;
		import : ARRAY MaxImps OF Module;
		impmod, mod, md : Module;
		ch : CHAR;
		spno, smno	: SHORTINT;
		abs, done	: BOOLEAN;
		handle, mno, fixupTarget, i, j, k, entno, 
		comsize, nofptrs, nofGmod, lnkx, marker, conx, casex: INTEGER;
		refBlk, dsize, key, p, p1, q, size, pos1, pos2, 
		cfu, cval (* case fixup, value *), impkey, fixupDiskAdr : LONGINT;
		ci, cj, tdadr, fixupDest, caseAdr, pc, tmptarget, target, start, nextAdr  : LONGINT;
		modname, impname : ModuleName; (* module name *)
		F : Files.File;
		R : Files.Rider;
		tdescs : ARRAY 64 OF LONGINT; (* max # of records allowed by compiler *)
		tdescCnt : INTEGER;

		PROCEDURE err(level : INTEGER);
		BEGIN res := level; COPY(name, importing);
		END err;

	BEGIN
		res := 0; mod := Kernel.ModList;
		LOOP
			IF name = mod.name THEN EXIT; END;
			mod := mod.link;
			IF mod = NIL THEN EXIT; END;
		END;
		IF mod = NIL THEN (* load *)
			OpenFile(F, name);
			IF F # NIL THEN
				Files.Set(R, F, 0);
				Files.Read(R, ch); (* OBJ marker *)
				IF ch # ObjMark THEN err(2); RETURN NIL END ;

				Files.Read(R, ch); 
				IF ch # "7" THEN err(2); RETURN NIL; END; (* OBJ Version *)

				Files.ReadBytes(R, refBlk, 4);
				Files.ReadBytes(R, entno, 2); Files.ReadBytes(R, comsize, 2);
				Files.ReadBytes(R, nofptrs, 2); Files.ReadBytes(R, nofGmod, 2);
				Files.ReadBytes(R, lnkx, 2); Files.ReadBytes(R, dsize, 4);
				Files.ReadBytes(R, conx, 2); Files.ReadBytes(R, casex, 2);
				Files.ReadBytes(R, pc, 4); Files.ReadBytes(R, key, 4);
				ReadName(R, modname, ModNameLen);

				i := entno * 4 + nofptrs * 4 + comsize;
				pos1 := Files.Pos(R); Files.Set(R, F, pos1 + i + 3);
				INC(i, nofGmod * SIZE(Module)); k := (i MOD 4) + i;
		
				(* imports *) Files.Read(R, ch); i := 0;
				IF ch # 85X THEN err(4); RETURN NIL; END;
				IF nofGmod > MaxImps THEN err(6); RETURN NIL; END;

				WHILE (i < nofGmod) & (res = 0) DO
					Files.ReadBytes(R, impkey, 4); ReadName(R, impname, 0); Files.Read(R, ch);
					impmod := ThisMod(impname);

					IF res = 0 THEN
						IF impmod.key = impkey THEN import[i] := impmod; INC(i); INC(impmod.refcnt);
						ELSE res := 3; imported := impname; importing := modname;
						END;
					END;
				END;

				IF res # 0 THEN 
					WHILE i > 0 DO DEC(i); DEC(import[i].refcnt); END;
					RETURN NIL;
				END;

				pos2 := Files.Pos(R);
				size := k + lnkx * 8 + conx + pc + dsize;
				Kernel.AllocBlock(q, p, size); mod := SYSTEM.VAL(Module, q); (* module descriptor allocation *)
				IF SYSTEM.VAL(LONGINT, mod) = 0 THEN err(7); RETURN NIL; END;

				mod.BB := p;
				mod.size := size;
				mod.CB := entno * 4 + p;
				mod.RB := comsize + mod.CB;
				mod.IB := nofptrs * 4 + mod.RB;
				mod.LB := k + p;
				mod.SB := (lnkx * 8 + dsize) + mod.LB;
				mod.PB := conx + mod.SB;
				mod.refcnt := 0;
				mod.key := key;
				mod.name := modname; (* .link is set up by Kernel.AllocBlock *)

				(* entries *) q := mod.CB; Files.Set(R, F, pos1); Files.Read(R, ch);
				IF ch # 82X THEN err(4); RETURN NIL; END;
				WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p); END;

				(* commands *) q := mod.RB; Files.Read(R, ch);
				IF ch # 83X THEN err(4); RETURN NIL; END;
				WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p); END;

				(* pointers *) q := mod.IB; Files.Read(R, ch);
				IF ch # 84X THEN err(4); RETURN NIL; END;
				WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p); END;

				(* imports *) i := 0;
				WHILE i < nofGmod DO SYSTEM.PUT(p, import[i]); INC(i); INC(p, SIZE(Module)); END;

				(* links *) Files.Set(R, F, pos2 + 1); p := mod.LB; q := lnkx * 8 + p;
				fixupDiskAdr := pos2; (* links are stored, but unused in 386 version *)
				WHILE p < q DO Files.Read(R, spno); Files.Read(R, smno); Files.ReadBytes(R, i, 2); INC(p, 4); END;

				(* case fixups *) caseAdr := Files.Pos(R); Files.Set(R, F, caseAdr + 4 * casex + 1);

				(* variables *) q := mod.SB;
				WHILE p < q DO SYSTEM.PUT(p, 0); INC(p); END;

				(* constants *) q := mod.PB; Files.Read(R, ch);
				IF ch # 88X THEN err(4); RETURN NIL; END;
				WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p); END;

				(* code *) q := p + pc; Files.Read(R, ch);
				IF ch # 89X THEN err(4); RETURN NIL; END;
				WHILE p < q DO Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p); END;

				(* type descriptors *) Files.Read(R, ch);
				IF ch # 8AX THEN err(4); RETURN NIL; END;
				tdescCnt := 0;
				LOOP
					Files.ReadBytes(R, i, 2); (* size *)
					IF i MOD 100H = 8BH (* ref block *) THEN EXIT; END;
					Files.ReadBytes(R, tdadr, 4); (* addr *)
					SYSTEM.NEW(md, i); p := SYSTEM.VAL(LONGINT, md); q := p + i; (* new type descriptor *)
					SYSTEM.PUT(mod.SB + tdadr, p);	(* pointer to descriptor in constant block *)
					tdescs[tdescCnt] := p; INC(tdescCnt);
					p1 := p; REPEAT Files.Read(R, ch); SYSTEM.PUT(p, ch); INC(p); UNTIL p = q;

					(* p1 now is the address of the type descriptor *)
					(* initialize the n+1 pointer for type tag restoration in GC *)
					SYSTEM.GET(p1, fixupDest); (* pointer information *)
					fixupDest := fixupDest DIV 1000000H; (* get number of pointers *)
					SYSTEM.PUT(p1 + 24H + fixupDest * 4, -(24H + 4 * fixupDest)); (* 4 = size of offset *)

					(* initialize the module & the time fields for Files1 *)
					SYSTEM.PUT(p1 + 23CH (* address of Kernel.Module for Files1 *), mod);
					SYSTEM.PUT(p1 + 240H (* address of time field for Files1    *), 0);

					(* initialize the Modules.Modules & Module tag fields *)
					SYSTEM.PUT(p1 + 244H (* Modules.Module *), mod);
					SYSTEM.PUT(p1 + 248H (* tag *), mod.key);
				END;
				NEW(mod.tdescs, tdescCnt); ASSERT(mod.tdescs # NIL, 20);
				WHILE tdescCnt > 0 DO DEC(tdescCnt); mod.tdescs[tdescCnt] := tdescs[tdescCnt]; END;

				(* perform fixups on the case statements *)
				pos1 := Files.Pos(R); Files.Set(R, F, caseAdr);
				Files.Read(R, ch);
				IF ch # 87X THEN err(4); RETURN NIL; END;
				p := casex;
				WHILE p > 0 DO
					Files.ReadBytes(R, cfu, SIZE(LONGINT));
					ci := cfu DIV 10000H; cj := cfu MOD 10000H;
					WHILE ci > 0 DO
						SYSTEM.GET(mod.SB + cj, cval); cval := cval + mod.PB;
						SYSTEM.PUT(mod.SB + cj, cval);
						DEC(ci, SIZE(LONGINT)); INC(cj, SIZE(LONGINT));
					END;
					DEC(p);
				END;

				(* perform fixups on the loaded code *)
				Files.Set(R, F, fixupDiskAdr); Files.Read(R, ch); p := 0; q := lnkx;
				IF ch # 86X THEN err(4); RETURN NIL; END;
				WHILE p < q DO
					Files.ReadBytes(R, target, 4); Files.ReadBytes(R, start, 4);

					mno := SHORT(SHORT(ASH(target, -20))); target := ASH(ASH(target, 12), -12); (* sign extend *)

					IF mno = -60H THEN target := KernelServices[target]; 
					ELSE
						IF mno >= 33 THEN INC(target, import[mno - 33].SB);
						ELSIF mno = 32 THEN INC(target, mod.SB);
						ELSIF mno = 0 THEN target := PD(mod, target);
						ELSE target := PD(import[mno - 1], target);
						END;
					END;

					WHILE SYSTEM.VAL(SET, start) - {31} # {} DO (* start # 0 *)
						IF 31 IN SYSTEM.VAL(SET, start) THEN abs := TRUE; EXCL(SYSTEM.VAL(SET, start), 31);
						ELSE abs := FALSE;
						END;
						INC(start, mod.PB); SYSTEM.GET(start, nextAdr);
						IF (mno = -60H) OR ((mno < 32) & ~abs) THEN tmptarget := target - start - 4; (* relative fixup to code *)
						ELSE tmptarget := target; (* absolute fixup to code or data *)
						END;
						SYSTEM.PUT(start, tmptarget); start := nextAdr;
					END;
					INC(p);
				END;
	(*XXX*)OutputMod(mod);
				init := SYSTEM.VAL(Command, mod.PB); init; res := 0;
				Files.Close(F);
			ELSE COPY(name, imported); err(1);
			END;
		END;
		RETURN mod;
	END ThisMod;
	PROCEDURE ThisCommand*(mod: Module; name: ARRAY OF CHAR): Command;
	VAR i: LONGINT; ch: CHAR; comadr: LONGINT; com: Command;
	BEGIN
		com := NIL;
		IF mod # NIL THEN
			comadr := mod.CB; res := 5;
			LOOP SYSTEM.GET(comadr, ch); INC(comadr);
				IF ch = 0X THEN (*not found*) EXIT; END;
				i := 0;
				LOOP
					IF ch # name[i] THEN EXIT; END;
					INC(i);
					IF ch = 0X THEN res := 0; EXIT; END;
					SYSTEM.GET(comadr, ch); INC(comadr);
				END;
				IF res = 0 THEN (*match*)
					SYSTEM.GET(comadr, i); com := SYSTEM.VAL(Command, mod.PB + i); EXIT;
				ELSE
					WHILE ch > 0X DO SYSTEM.GET(comadr, ch); INC(comadr); END;
					INC(comadr, 4);
				END;
			END;
		END;
		RETURN com;
	END ThisCommand;
	PROCEDURE unload(mod: Module; all: BOOLEAN);
	VAR p, k: LONGINT; imp: Module;
	BEGIN
		p := mod.IB;
		WHILE p < mod.LB DO  (*scan imports*)
			SYSTEM.GET(p, k); imp := SYSTEM.VAL(Module, k);
			IF imp # NIL THEN
				DEC(imp.refcnt);
				IF all & (imp.refcnt = 0) THEN unload(imp, all); END;
			END;
			INC(p, SIZE(Module));
		END;
		Kernel.FreeBlock(SYSTEM.VAL(LONGINT, mod));
	END unload;

	(* remove a module from the loaded list *)
	PROCEDURE unlink(VAR list : Module; mod : Module);
	VAR p : Module;
	BEGIN
		IF list = mod THEN list := list.link;
		ELSE p := list; WHILE p.link # mod DO p := p.link; END; p.link := mod.link;
		END;
	END unlink;
	PROCEDURE Free*(name: ARRAY OF CHAR; all: BOOLEAN);
	VAR mod: Module;
	BEGIN
		mod := Kernel.ModList;
		LOOP
			IF mod = NIL THEN res := 1; EXIT; END;
			IF name = mod.name THEN
				IF mod.refcnt = 0 THEN unload(mod, all); unlink(Kernel.ModList, mod); res := 0 ELSE res := 2; END;
				EXIT;
			END;
			mod := mod.link;
		END;
	END Free;

	(* This procedure used by Loader.Obj.  It is not to be called by this module *)
	PROCEDURE InitKernel*;
	BEGIN KernelAdr := SYSTEM.ADR(KernelServices[0]); (* used by Loader.Obj *)
	END InitKernel;

BEGIN res := 0;
	Kernel.DebugWriteString('Modules Inited'); Kernel.DebugNL;
	IF Kernel.err = 0 THEN
		Kernel.DebugWriteString('Modules loading Oberon'); Kernel.DebugNL;
		loop := ThisCommand(ThisMod("Oberon"), "Loop"); loop;
	END;
END Modules.
