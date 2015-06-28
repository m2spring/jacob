		.data
		.comm	saved_esp,4

                .globl	_main
_main:		pushl	%ebp
		movl	%esp,%ebp  
                movl	%esp,saved_esp
	
                call	Proc1

                movl	$0,%eax
		leave
		ret
	
#------------------------------------------------------------------------------                
Proc1:		pushl	%ebp
		movl	%esp,%ebp
                
#                pushl	$9
#                call	_Halt
                
                leave
                ret
                
#------------------------------------------------------------------------------                
_Halt:		pushl	%ebp
		movl	%esp,%ebp
                
                pushl	8(%ebp)
                call	_exit
                
                movl	saved_esp,%esp
                leave
                ret
                
