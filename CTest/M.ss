.comm	_M_s, 20
	.text
LBB0:
	.globl	_M
	.globl	_M_P
_M_P:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$Lab1, %esp
	movl	44(%ebp),%ecx
	incl	%ecx
	addl	$3,%ecx
	andl	$0xfffffffc, %ecx
	subl 	%ecx,%esp
	movl	%esp,%edi
	movl	40(%ebp),%esi
	movl	%edi,40(%ebp)
	shrl	$2,%ecx
	cld
	repz
	movsl
LBB1:
LBE1:
	leave
	ret
	Lab1 = 12
_M:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$Lab2, %esp
LBB2:
	.data
	.align 4
Lab4:
	.long	0,1074790400		# +0.39999999999999994E1
Lab3:
 	.ascii	"12345\000"
	.text
        
	pushl	$4
	leal	Lab3,%eax
	pushl	%eax
        
	leal	_M_s + 4,%esi
	subl	$8,%esp
	movl	%esp,%edi
	movl	$2,%ecx
	cld
	repz
	movsl
        
	pushl	_M_s

	pushl	Lab4 + 4
	pushl	Lab4

	pushl	$3
	pushl	$2
	pushl	$1
	call	_M_P
	addl	$40, %esp
LBE2:
	leave
	ret
	Lab2 = 4
        
        
        
/*-------------------------------------------------------------------*/
        pushl	%ebp
	movl	%esp,%ebp
        pushl	$M_P$D
	subl	$8,%esp

	movl	$2,%ecx            /* p2 */
	movl	36(%ebp),%esi
	subl	$8,%esp
	movl	%edi,%esp
        movl	%edi,36(%ebp)
	cld
	repz
	movsl
        
        movl	48(%ebp),%ecx      /* s1 */
	addl	$3,%ecx
	andl	$0xfffffffc,%ecx
        movl	44(%ebp),%esi
        subl	%ecx,%esp
	movl	%esp,%edi
        movl	%edi,44(%ebp)
	cld
	repz
	movsl

        movl	$1,%ecx
        imull	60(%ebp),%ecx
        imull	56(%ebp),%ecx
	addl	$3,%ecx
	andl	$0xfffffffc,%ecx
        movl	52(%ebp),%esi
        subl	%ecx,%esp
	movl	%esp,%edi
        movl	%edi,52(%ebp)
	cld
	repz
	movsl

	leave
	ret

/*-------------------------------------------------------------------*/
        pushl	$5
        pushl	$2
        leal	M$G + reladr<M.a2>,%eax
        pushl	%eax
        
        .data
        .align	4
L0:        
        .ascii	"12345\000"
        .text
        pushl	$6
        leal	L0,%eax
        pushl	%eax   
        
        pushl	$M_T2$D
        leal	M$G + reladr<M.v2>,%eax
        pushl	%eax

        pushl	$M_T1$D
        pushl	M$G + reladr<M.v1>
        
        .data
        .align	4
L1:
	.long	0,1074790400
        .text
        pushl	L1+4
        pushl	L1
        
        pushl	$3
        pushl	$2
        pushl	$1
        call	M_P
        addl	$56,%esp
