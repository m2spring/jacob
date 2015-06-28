Exit:	Exit.o
	ld -static -o Exit /usr/lib/crt0.o Exit.o -lc ; chmod 770 Exit

Exit.o:	Exit.as
	as -L -o Exit.o Exit.as -a >Exit.lst

bts:	bts.o
	ld -static -o bts /usr/lib/crt0.o bts.o -lc ; chmod 770 bts

bts.o:	bts.as
	as -L -o bts.o bts.as -a >bts.lst

tst:	tst.o
	ld -static -o tst /usr/lib/crt0.o tst.o -lc ; chmod 770 tst
 
tst.o:	tst.as
	cpp tst.as tst.s ; as -L -o tst.o tst.s -a >tst.lst

