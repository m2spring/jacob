	.text
	.globl	__M2ROOT
__M2ROOT:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$Lab1, %esp
	.globl	_RealConv
	call	_RealConv
	.globl	_Strings1
	call	_Strings1
	.globl	_BasicIO
	call	_BasicIO
	.globl	_Storage
	call	_Storage
	.globl	_ByteIO
	call	_ByteIO
	.globl	_TextIO
	call	_TextIO
	.globl	_InOut
	call	_InOut
	.globl	_pro
	call	_pro
	leave
	ret
	Lab1 = 4
