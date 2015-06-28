#!/bin/bash

SRC=$PRJHOME
VERSION=`cat version`

if [ ! -d jacob ] ;then
   echo "there's no directory $SRC/jacob"
   exit
fi

rm -rf jacob/*
cd jacob
mkdir lib sys test

cp $SRC/README.$VERSION ./README
cp $SRC/lib/*.ob2 lib/
cp $SRC/lib/*.def .
cp $SRC/Jacob sys/
cp $SRC/Scanner.Tab sys/
cp $SRC/Parser.Tab sys/
cp $SRC/Errors.Tab sys/

cp $SRC/bin/oc.assembler sys/
cp $SRC/bin/oc.linker sys/

cp $SRC/OB2RTS-elf.o sys/
cp $SRC/UTIS-elf.o sys/
cp $SRC/Storage-elf.o sys/
#cp $SRC/OB2RTS-aout.o sys/
#cp $SRC/UTIS-aout.o sys/
#cp $SRC/Storage-aout.o sys/

#------------------------------------------------------------------------------
cat >oc <<EOF
#!/bin/sh
HOME=/usr/jacob
SYS=\$HOME/sys

\$SYS/Jacob \\
   -tab  \$SYS \\
   -link \$SYS/oc.linker \\
   -asm  \$SYS/oc.assembler \\
   \$* \\
   -I\$HOME/lib
EOF
chmod +x oc

#------------------------------------------------------------------------------
cat >test/Test.ob2 <<EOF
MODULE Test;
IMPORT Lib,Out,RawFiles,Storage,Str,SysLib;
BEGIN (* Test *)
 Out.Str('This is Jacob V$VERSION'); Out.Ln;
END Test.
EOF

#------------------------------------------------------------------------------
cd ..
tar cvf jacob-$VERSION.tar jacob
gzip -fv9 jacob-$VERSION.tar
