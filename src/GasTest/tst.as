FalseStr:	.asciz	"FALSE"
TrueStr:	.asciz	"TRUE"

/*---------------------------------------------------------------------------*/
CmpStrStr:	.asciz	"cmpl 0x%08X,0x%08X ; "
CmpStr:		pushl	%ecx
		pushl	%edx
		
		pushl	%edx
		pushl	%ecx
		pushl	$CmpStrStr
		call	_printf
		addl	$12,%esp
		
		popl	%edx
		popl	%ecx
		ret
		
/*---------------------------------------------------------------------------*/
#define JXX1(X) \
Test_ ## X ##:	call	CmpStr ;\
		cmpl	%ecx,%edx ;\
		X	X ## T ;\
		pushl	$FalseStr ;\
		jmp	X ## Cont ;
     
#define JXX2(X) \
X ## T:		pushl	$TrueStr ;\
X ## Cont: 	pushl	$ ## X ## Str ;\
		pushl	$Test_Str ;\
		call	_printf ;\
		addl	$12,%esp ;\
		ret ;\
X ## Str:  	.asciz	#X ;

Test_Str:	.asciz	"%-4s  --> %s\n"	
     
#define JXX(X) \
JXX1(X) \
JXX2(X)

JXX(ja)
JXX(jae)
JXX(jb)
JXX(jbe)
JXX(je)
JXX(jg)
JXX(jge)
JXX(jl)
JXX(jle)
JXX(jna)
JXX(jnae)
JXX(jnb)
JXX(jnbe)
JXX(jne)
JXX(jng)
JXX(jnge)
JXX(jnl)
JXX(jnle)

/*---------------------------------------------------------------------------*/
/* PROCEDURE Test(a:LONGINT IN ecx; b:LONGINT IN edx) */
#define TEST(X) \
pushl	%ecx ;\
pushl	%edx ;\
call	Test_ ## X ;\
popl	%edx ;\
popl	%ecx ;

Test:		
                TEST(ja)
		TEST(jae)
		TEST(jb)
		TEST(jbe)
		TEST(je)
		TEST(jg)
		TEST(jge)
		TEST(jl)
		TEST(jle)
		TEST(jna)
		TEST(jnae)
		TEST(jnb)
		TEST(jnbe)
		TEST(jne)
		TEST(jng)
		TEST(jnge)
		TEST(jnl)
		TEST(jnle)
		
		ret

/*---------------------------------------------------------------------------*/
NlStr:		.asciz	"\n"

#define TestEm(A,B) \
movl	$ ## A,%ecx ;\
movl	$ ## B,%edx ;\
call	Test ;\
pushl	$NlStr ;\
call	_printf ;\
addl	$4,%esp

		.globl	_main
_main:		pushl	%ebp
		movl	%esp,%ebp
	
		TestEm(0x80000000,0x80000000)
		TestEm(0x80000000,0xffffffff)
		TestEm(0x80000000,0x00000000)
		TestEm(0x80000000,0x00000001)
		TestEm(0x80000000,0x7fffffff)

		TestEm(0xffffffff,0x80000000)
		TestEm(0xffffffff,0xffffffff)
		TestEm(0xffffffff,0x00000000)
		TestEm(0xffffffff,0x00000001)
		TestEm(0xffffffff,0x7fffffff)
	
		TestEm(0x00000000,0x80000000)
		TestEm(0x00000000,0xffffffff)
		TestEm(0x00000000,0x00000000)
		TestEm(0x00000000,0x00000001)
		TestEm(0x00000000,0x7fffffff)

		TestEm(0x00000001,0x80000000)
		TestEm(0x00000001,0xffffffff)
		TestEm(0x00000001,0x00000000)
		TestEm(0x00000001,0x00000001)
		TestEm(0x00000001,0x7fffffff)

		TestEm(0x7fffffff,0x80000000)
		TestEm(0x7fffffff,0xffffffff)
		TestEm(0x7fffffff,0x00000000)
		TestEm(0x7fffffff,0x00000001)
		TestEm(0x7fffffff,0x7fffffff)

		leave
		ret
	
