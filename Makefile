# Builds Jacob (the Oberon-2 compiler) and its runtime, then installs the
# binary where the 'oc' driver script expects to find it. Requires
# ./configure to have generated config.mk first.
#
#   make                incremental build
#   make clean && make  forces full puma/rex/lark/ast regeneration first

ifeq ($(wildcard config.mk),)
$(error No config.mk found; run ./configure first)
endif
include config.mk

# Mocka must come before $(HOME_DIR)/bin: jacob/bin also has a (stale,
# unrelated) 'mc' wrapper script that expects MOCKADIR=/usr/mocka.
export PATH := $(COCKTAIL):$(MOCKA):$(HOME_DIR)/bin:$(PATH)

.PHONY: all shims clean

all: shims
	@echo "==> Building Jacob..."
	$(MAKE) -C src Jacob
	@echo "==> Building Oberon-2 runtime (elf-rts)..."
	$(MAKE) -C src ELFAS="/usr/bin/as --32" ELFGCC="gcc -m32" elf-rts
	@echo "==> Installing Jacob to $(HOME_DIR)/Jacob..."
	cp src/Jacob Jacob
	@echo "==> Done. Compile programs with: $(HOME_DIR)/bin/oc <file.ob2>"

# System.md and MySysLib.md are FOREIGN modules with no buildable Modula-2
# body; System.o/MySysLib.o are real C objects (from System.c/xstat_shim.c)
# providing OpenInput/Read/Write/.../_xstat. mc has no rule for them, and if
# it recompiles MySysLib.mi's trivial stub it silently overwrites the real
# _xstat with an empty (undefined-symbol) one, so rebuild them here and
# make sure their mtimes are newer than the .md/.mi before `make Jacob` runs.
shims:
	@echo "==> Building foreign-module runtime shims (System, MySysLib)..."
	gcc -m32 -c -O2 -o src/System.o src/System.c -DUNIX
	gcc -m32 -c -O2 -o src/MySysLib.o src/xstat_shim.c
	touch src/System.o src/MySysLib.o
	# Cons.md/Cons.mi are Beg-generated output, committed as source (see
	# README Prerequisites: we do not reproduce Beg). Their only Makefile
	# rule ties them to oberon.cgd.tmp, a generated intermediate; on a
	# fresh clone/checkout/merge, file mtimes don't reflect build order,
	# so oberon.cgd.tmp can look newer than the already-checked-out
	# Cons.md/mi, and `make Jacob` then tries to regenerate them via the
	# (unavailable, 1994-era) Beg binary. Build oberon.cgd.tmp first, then
	# touch Cons.md/mi so they're never seen as stale relative to it.
	$(MAKE) -C src oberon.cgd.tmp
	touch src/Cons.md src/Cons.mi

clean:
	@echo "==> Cleaning generated files..."
	rm -f src/ADR.md src/ADR.mi src/BL.md src/BL.mi src/CMT.md src/CMT.mi \
	      src/CO.md src/CO.mi src/CODE.md src/CODE.mi src/CODEf.md src/CODEf.mi \
	      src/SI.md src/SI.mi src/T.md src/T.mi src/TD.md src/TD.mi src/TT.md src/TT.mi \
	      src/V.md src/V.mi src/PR.md src/PR.mi src/OD.md src/OD.mi \
	      src/OB.md src/OB.mi src/Tree.md src/Tree.mi src/Eval.md src/Eval.mi \
	      src/Scanner.md src/Scanner.mi src/Parser.md src/Parser.mi \
	      src/Tree.TS src/CoderTree.TS src/OB.TS src/oberon.aecp src/CODE.tmp src/CODEf.tmp \
	      src/OB2RTS-elf.o src/Storage-elf.o src/UTIS-elf.o src/Storage-elf.s src/UTIS-elf.s \
	      Jacob
	# Deliberately NOT wiping src/*.o/*.d/*.r wholesale: mc tracks per-module
	# dependencies via .d/.r files and recompiles whatever the .md/.mi
	# timestamps above now make stale, on its own. Blowing away .d/.r for
	# MySysLib/System (hand-written C objects providing _xstat and the
	# OpenInput/Read/Write/... FOREIGN implementations) makes mc think it
	# must recompile their trivial .mi stubs instead, silently overwriting
	# the real objects with empty (undefined-symbol) ones.
