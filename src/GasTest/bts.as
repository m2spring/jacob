printVal:
		pushl	%eax
                pushl	$formatStr
                call	_printf
                addl	$8,%esp
                ret
formatStr:	.asciz	"%08X\n"                

		.globl	_main
_main:		pushl	%ebp
		movl	%esp,%ebp
	
                movl	$0,%eax
                movl	$0x02000001,%ebx
                btsl	%ebx,%eax
                
                call	printVal

		pushl	$3
                call	_exit

		leave
		ret
	

