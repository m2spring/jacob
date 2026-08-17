#!/bin/sh
# Builds Jacob (the Oberon-2 compiler) and its runtime, then installs the
# binary where the 'oc' driver script expects to find it.
# Pass --clean to force full regeneration of all puma/rex/lark/ast output
# and the runtime .o files instead of relying on mtime-based incremental build.
set -e

HOME_DIR=/home/mspring/prj/jacob/jacob
COCKTAIL=/home/mspring/prj/jacob/cocktail2110/bin
MOCKA=/home/mspring/prj/jacob/Mocka0605/bin

# Mocka must come before $HOME_DIR/bin: jacob/bin also has a (stale, unrelated)
# 'mc' wrapper script that expects MOCKADIR=/usr/mocka.
export PATH="$COCKTAIL:$MOCKA:$HOME_DIR/bin:$PATH"

cd "$HOME_DIR/src"

if [ "$1" = "--clean" ]; then
    echo "==> Cleaning generated files..."
    rm -f ADR.md ADR.mi BL.md BL.mi CMT.md CMT.mi CO.md CO.mi CODE.md CODE.mi CODEf.md CODEf.mi \
          SI.md SI.mi T.md T.mi TD.md TD.mi TT.md TT.mi V.md V.mi PR.md PR.mi OD.md OD.mi \
          OB.md OB.mi Tree.md Tree.mi Eval.md Eval.mi Scanner.md Scanner.mi Parser.md Parser.mi \
          Tree.TS CoderTree.TS OB.TS oberon.aecp CODE.tmp CODEf.tmp \
          OB2RTS-elf.o Storage-elf.o UTIS-elf.o Storage-elf.s UTIS-elf.s \
          Jacob
    # Deliberately NOT wiping *.o/*.d/*.r wholesale: mc tracks per-module
    # dependencies via .d/.r files and recompiles whatever the .md/.mi
    # timestamps above now make stale, on its own. Blowing away .d/.r for
    # MySysLib/System (hand-written C objects providing _xstat and the
    # OpenInput/Read/Write/... FOREIGN implementations) makes mc think it
    # must recompile their trivial .mi stubs instead, silently overwriting
    # the real objects with empty (undefined-symbol) ones.
fi

# System.md and MySysLib.md are FOREIGN modules with no buildable Modula-2
# body; System.o/MySysLib.o are real C objects (from System.c/xstat_shim.c)
# providing OpenInput/Read/Write/.../_xstat. mc has no rule for them, and if
# it recompiles MySysLib.mi's trivial stub it silently overwrites the real
# _xstat with an empty (undefined-symbol) one, so rebuild them here and
# make sure their mtimes are newer than the .md/.mi before `make Jacob` runs.
echo "==> Building foreign-module runtime shims (System, MySysLib)..."
gcc -m32 -c -O2 -o System.o System.c -DUNIX
gcc -m32 -c -O2 -o MySysLib.o xstat_shim.c
touch System.o MySysLib.o

echo "==> Building Jacob..."
make Jacob

echo "==> Building Oberon-2 runtime (elf-rts)..."
make ELFAS="/usr/bin/as --32" ELFGCC="gcc -m32" elf-rts

echo "==> Installing Jacob to $HOME_DIR/Jacob..."
cp Jacob "$HOME_DIR/Jacob"

echo "==> Done. Compile programs with: $HOME_DIR/bin/oc <file.ob2>"
