#$! make
ELFAS=/usr/bin/as
ELFGCC=gcc
AOUTAS=/usr/i486-linuxaout/bin/as
AOUTGCC=gcc -b i486-linuxaout

CHECK = $(PRJHOME)/OberonTest/check all

all:		Jacob rts pat
		echo -e "\a"

test:		all
		$(CHECK)
		(echo "Compiling various sources"; cd OberonSourcen; allmains)

dist:		all
		sh $(PRJHOME)/bin/makeDist.sh

Jacob:		DatePatch \
		Jacob.mi \
		ADR.md      ADR.mi \
		ARG.md      ARG.mi \
		ASM.md      ASM.mi \
		ASMOP.md    ASMOP.mi \
		BETO.md     BETO.mi \
		BL.md       BL.mi \
		Target.md   Target.mi \
		CMT.md      CMT.mi \
		CO.md       CO.mi \
		CODE.md     CODE.mi \
		CODEf.md    CODEf.mi \
		Cons.md     Cons.mi \
		CV.md       CV.mi \
		DRV.md      DRV.mi \
		ED.md       ED.mi \
		Emit.md     Emit.mi \
		Eval.md     Eval.mi \
		ERR.md      ERR.mi \
		Errors.md   Errors.mi \
		FIL.md      FIL.mi \
		GcgTab.md   GcgTab.mi \
		IR.md       IR.mi \
		LAB.md      LAB.mi \
		LIM.md      LIM.mi \
		MySysLib.md MySysLib.mi \
		NDP.md      NDP.mi \
		O.md        O.mi \
		OB.md       OB.mi \
		OD.md       OD.mi \
		OT.md       OT.mi \
		Parser.md   Parser.mi \
		POS.md      POS.mi \
		PR.md       PR.mi \
		RegAlloc.md RegAlloc.mi \
		Scanner.md  Scanner.mi \
		SI.md       SI.mi \
		Source.md   Source.mi \
		STR.md      STR.mi \
		T.md        T.mi \
		TBL.md      TBL.mi \
		TT.md       TT.mi \
		Tree.md     Tree.mi \
		TD.md       TD.mi \
		UTI.md      UTI.mi \
		V.md        V.mi
		echo p Jacob | mc -nog -nogc -index -range -info -noblip

DatePatch:
		sh ../bin/PatchJacobDate

StorageTest:	StorageTest.c Storage.h Storage.c
		gcc -O2 -fdollars-in-identifiers -o StorageTest StorageTest.c Storage.c && chmod 770 StorageTest

pat:		CODE.pat

CODE.pat:	CODE.tmp
		puma -dinpr CODE.tmp >CODE.pat

#--- Run-time system ----------------------------------------------------------

rts: 		elf-rts

aout-rts:	OB2RTS-aout.o Storage-aout.o UTIS-aout.o
elf-rts:	OB2RTS-elf.o Storage-elf.o UTIS-elf.o

#--- a.out

OB2RTS-aout.o:	OB2RTS.as
		cpp -D AOUT -lang-c++ -P OB2RTS.as | \
		$(AOUTAS) -o OB2RTS-aout.o - -a >OB2RTS-aout.lst

Storage-aout.o:	Storage-aout.s
		$(AOUTAS) -o Storage-aout.o Storage-aout.s -a >Storage-aout.lst

UTIS-aout.o:	UTIS-aout.s
		$(AOUTAS) -o UTIS-aout.o UTIS-aout.s -a >UTIS-aout.lst

Storage-aout.s:	Storage.c Storage.h
		$(AOUTGCC) -DAOUT -o Storage-aout.s -fdollars-in-identifiers -S Storage.c

UTIS-aout.s:	UTIS.c UTIS.h
		$(AOUTGCC) -O2 -o UTIS-aout.s -S UTIS.c

#--- ELF

OB2RTS-elf.o:	OB2RTS.as
		cpp -D ELF -lang-c++ -P OB2RTS.as | \
		$(ELFAS) -o OB2RTS-elf.o -a >OB2RTS-elf.lst

Storage-elf.o:	Storage-elf.s
		$(ELFAS) -o Storage-elf.o Storage-elf.s -a >Storage-elf.lst

UTIS-elf.o:	UTIS-elf.s
		$(ELFAS) -o UTIS-elf.o UTIS-elf.s -a >UTIS-elf.lst

Storage-elf.s:	Storage.c Storage.h
		$(ELFGCC) -DELF -o Storage-elf.s -fdollars-in-identifiers -S Storage.c

UTIS-elf.s:	UTIS.c UTIS.h
		$(ELFGCC) -O2 -o UTIS-elf.s -S UTIS.c

#--- Temporary files ----------------------------------------------------------

%.md:			%.mi
   
# Watch the leading \t in the line above :-)

Scanner.mi:	oberon.rex
	    	rex -dmi oberon.rex

oberon.aecp:	oberon.ast oberon.eva oberon.che oberon.pre
	    	cat oberon.ast oberon.eva oberon.che oberon.pre >$@

Tree.md Tree.mi:    	oberon.aecp
	    	ast -mdiF7 oberon.aecp

Tree.TS:	oberon.ast
		echo VIEW Tree SELECT SyntaxTree ExtendedSyntaxTree \
		| cat - oberon.ast | ast -47

CoderTree.TS:	oberon.ast
		echo VIEW CoderTree | cat - oberon.ast | ast -47

Parser.md Parser.mi:	oberon.lal
		lark -b -d oberon.lal

Eval.md Eval.mi:	oberon.aecp
		ag -A7 oberon.aecp

OB.md OB.mi:		OB.ast
		ast -mdi=7 OB.ast

OB.TS:		OB.ast
		ast -47 OB.ast

TT.md TT.mi:		TT.pum OB.TS Tree.TS POS.md
		puma -dinmp7 TT.pum

E.md E.mi:		E.pum OB.TS ERR.md OT.md POS.md Tree.md
		puma -dinp7 E.pum

SI.md SI.mi:		SI.pum OB.TS OT.md POS.md Tree.md V.md
		puma -dinp7 SI.pum

T.md T.mi:		T.pum OB.TS ADR.md BL.md Target.md E.md ERR.md LIM.md O.md OT.md \
		POS.md SI.md UTI.md V.md
		puma -dinp7 T.pum

V.md V.mi:		V.pum OB.TS OT.md PR.md
		puma -dinp7 V.pum

PR.md PR.mi:		PR.pum OB.TS ERR.md OT.md POS.md UTI.md
		puma -dinp7 PR.pum

CO.md CO.mi:		CO.pum OB.TS OT.md
		puma -dinp7 CO.pum

ADR.md ADR.mi:		ADR.pum OB.TS
		puma -dinp7 ADR.pum

BL.md BL.mi:		BL.pum OB.TS ADR.md LIM.md UTI.md
		puma -dinp7 BL.pum

CMT.md CMT.mi:		CMT.pum OB.TS CoderTree.TS
		puma -dinp7 CMT.pum

CODE.tmp:	CODE.pum OB.TS CoderTree.TS \
		CODE.pum.ProcCalls CODE.pum.Assignments CODE.pum.Stmts CODE.pum.Exprs \
		CODE.pum.BooleanExprs CODE.pum.Designators CODE.pum.Predecls \
		ADR.md ARG.md BL.md Target.md Cons.md
		cpp -P -C CODE.pum CODE.tmp

CODE.md CODE.mi:	CODE.tmp OB.TS CoderTree.TS ADR.md ARG.md BL.md Target.md Cons.md \
		E.md ERR.md FIL.md LIM.md O.md PR.md SI.md STR.md T.md UTI.md V.md
		puma -dinp7 CODE.tmp

CODEf.tmp:	CODEf.pum CODEf.pum.Init CODEf.pum.TDesc
		cpp -P -C CODEf.pum CODEf.tmp

CODEf.md CODEf.mi:	CODEf.tmp OB.TS CoderTree.TS 
		puma -dinp7 CODEf.tmp

TD.md TD.mi:		TD.pum CoderTree.TS ED.md UTI.md
		puma -dinpk7 TD.pum

OD.md OD.mi:		OD.pum OB.TS ARG.md BL.md ED.md Tree.md O.md OT.md \
		PR.md STR.md T.md UTI.md
		puma -dinp7 OD.pum

oberon.cgd.tmp:	oberon.cgd oberon.cgd.min oberon.cgd.opt \
		oberon.cgd.floats.min oberon.cgd.floats.opt
		cpp -P -C oberon.cgd oberon.cgd.tmp

Cons.md Cons.mi:	oberon.cgd.tmp
		beg oberon.cgd.tmp && EmitPatch && touch Cons.mi

#------------------------------------------------------------------------------

clean:
	rm -f *.d *.r *.o *~ *.imp *.bak *.lst pat *.pat *.TS oberon.aecp \
	nohup.out \
	oberon.cgd.tmp \
	LISTING ERRORS _Debug Stat \
	ADR.md      ADR.mi \
	BL.md       BL.mi \
	CMT.md      CMT.mi \
	CO.md       CO.mi \
	CODE.md     CODE.mi CODE.tmp \
	CODEf.md    CODEf.mi CODEf.tmp\
	E.md        E.mi \
	Eval.md     Eval.mi \
	OD.md       OD.mi \
	OB.md       OB.mi \
	Parser.md   Parser.mi \
	PR.md       PR.mi \
	Scanner.md  Scanner.mi \
	SI.md       SI.mi \
	Tree.md     Tree.mi \
	Cons.md     Cons.mi \
	Emit.md     Emit.mi \
	GcgTab.md   GcgTab.mi \
	IR.md       IR.mi \
	RegAlloc.md RegAlloc.mi \
	TD.md       TD.mi \
	TT.md       TT.mi \
	T.md        T.mi \
	V.md        V.mi

totalclean:	clean
	rm -f Scanner.Tab Parser.Tab Jacob jacob-`cat version`.tar.gz
	rm -rf jacob/*
	bin/subClean

