#------------------------------------------------------------------------------
	.comm	saved_esp,4
	.comm	_argc,4
	.comm	_argv,4
	.comm	_env,4
        
	.globl	_main
_main:
	pushl	%ebp
	movl	%esp,%ebp
	movl	%esp,saved_esp

	movl	8(%ebp),%eax
	movl	%eax,_argc
	movl	12(%ebp),%eax
	movl	%eax,_argv
	movl	16(%ebp),%eax
	movl	%eax,_env

	# NDP control word format:
	#
	# +---------------+---------------+---------------+---------------+
	# |15  14  13  12 |11  10   9   8 | 7   6   5   4 | 3   2   1   0 |
	# +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
	# | X | X | X | 0 |   RC  |   PC  | X | X | PM| UM| OM| ZM| DM| IM|
	# +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
	#		      ^       ^             ^   ^   ^   ^   ^   ^
	#                     |	      |             |   |   |   |   |   |
	# Rounding Control ---+	      |             |   |   |   |   |   |
	# Precision Control ----------+             |   |   |   |   |   |
	#                                           |   |   |   |   |   |
	# Precision Mask ---------------------------+   |   |   |   |   |
	# Underflow Mask -------------------------------+   |   |   |   |
	# Overflow Mask ------------------------------------+   |   |   |
	# Zero divide Mask -------------------------------------+   |   |
	# Denormal operand Mask ------------------------------------+   |
	# Invalid operation Mask ---------------------------------------+

	# set NDP rounding control to 01 = "round down"
	subl	$4,%esp
	fnstcw	(%esp)
	orw	$0x0400,(%esp)
	andw	$0xf7ff,(%esp)
	fldcw	(%esp)
	addl	$4,%esp

	call	_Storage$I
	call	_$I
	
	pushl	$0
	call	_Halt
	
	xorl	%eax,%eax
	leave
	ret
        
#------------------------------------------------------------------------------
	.data
	.globl	_ExitProc
#*$
_ExitProc:
	.long	StdExit
#*$
ExitCode:
	.long	0
	.text

#------------------------------------------------------------------------------
#*$
StdExit:
	pushl	ExitCode
        call	_exit

        movl	saved_esp,%esp
        leave
	ret
	
#------------------------------------------------------------------------------
	.globl	_Halt
#*$
_Halt:
        pushl	%ebp
        movl	%esp,%ebp
        
        movl	8(%ebp),%eax
	movl	%eax,ExitCode
	
	movl	_ExitProc,%eax
        call	%eax

	jmp	StdExit

#------------------------------------------------------------------------------
#*$
RtErrMsg:
	.asciz	"\n*** RUNTIME ERROR: %s\n"
_RtErr:
	pushl	$RtErrMsg
	call	_printf
	addl	$8,%esp
	
	call	DumpProcStack

	pushl	$1
	call	_Halt
	
#------------------------------------------------------------------------------
	.globl	_NILPROC
NILPROC_Msg:
	.asciz	"NIL procedure called"
#*$
_NILPROC:        
	pushl	$NILPROC_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_FunctionFault
FunctionFault_Msg:
	.asciz	"Function procedure without return value"
#*$
_FunctionFault:        
	pushl	$FunctionFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_IndexFault
IndexFault_Msg:
	.asciz	"Index out of bounds"
#*$
_IndexFault:        
	pushl	$IndexFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_NilFault
NilFault_Msg:
	.asciz	"NIL pointer dereferenced"
#*$
_NilFault:        
	pushl	$NilFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_ElementFault
ElementFault_Msg:
	.asciz	"Element out of SET"
#*$
_ElementFault:        
	pushl	$ElementFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_DivFault
DivFault_Msg:
	.asciz	"Non-positive divisor in DIV or MOD"
#*$
_DivFault:        
	pushl	$DivFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_LenFault
LenFault_Msg:
	.asciz	"Non-positive LEN in NEW"
#*$
_LenFault:        
	pushl	$LenFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_AbsFault
AbsFault_Msg:
	.asciz	"ABS(MIN(integer))"
#*$
_AbsFault:        
	pushl	$AbsFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_ChrFault
ChrFault_Msg:
	.asciz	"CHR argument out of range"
#*$
_ChrFault:        
	pushl	$ChrFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_ShortFault
ShortFault_Msg:
	.asciz	"SHORT argument out of range"
#*$
_ShortFault:        
	pushl	$ShortFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_GuardFault
GuardFault_Msg:
	.asciz	"(Implicit) type guard failed"
GuardFault_Info:
	.asciz	"*** (actual type was %s, guarded type was %s)\n"
#*$
_GuardFault:        
	pushl	$GuardFault_Msg
	pushl	$RtErrMsg
	call	_printf
	addl	$8,%esp
	
        pushl	$GuardFault_Info
        call	_printf
        addl	$12,%esp

	call	DumpProcStack

	pushl	$1
	call	_Halt
	
#------------------------------------------------------------------------------
	.globl	_CaseFault
CaseFault_Msg:
	.asciz	"Missing ELSE in CASE statement"
#*$
_CaseFault:        
	pushl	$CaseFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_WithFault
WithFault_Msg:
	.asciz	"Missing ELSE in WITH statement"
#*$
_WithFault:        
	pushl	$WithFault_Msg
	jmp	_RtErr

#------------------------------------------------------------------------------
	.globl	_AssertFail
AssertFail_Msg:
	.asciz	"Assertion failed"
AssertFail_Info:
	.asciz	"*** (error code = %i)\n"
#*$
_AssertFail:        
        pushl	%ebp
        movl	%esp,%ebp
        
	pushl	$AssertFail_Msg
	pushl	$RtErrMsg
	call	_printf
	addl	$8,%esp
	
        pushl	8(%ebp)
	pushl	$AssertFail_Info
	call	_printf
	addl	$8,%esp

	movl	8(%ebp),%eax
	leave
	pushl	%eax

	call	DumpProcStack

        call	_exit
        movl	saved_esp,%esp
        leave
	ret

#------------------------------------------------------------------------------
DumpProcStackMsg:
	.asciz	"*** procedure stack:\n"
#*$
DumpProcStack:
	pushl	$DumpProcStackMsg
	call	_printf
	addl	$4,%esp

	# ebp points to last stackframe
	
	movl	%ebp,%ebx

DumpProcStackLoop:
	movl	-4(%ebx),%eax		# eax := tag(proc)
	cmpl	_FirstModuleTDesc,%eax	# IF tag(proc) = TDesc(root_init_proc) THEN RETURN
	jz	DumpProcStackRet

	pushl	-12(%eax)
	call	_printf
	addl	$4,%esp
	
	pushl	$10
	movl	%esp,%eax
	pushl	%eax
	call	_printf
	addl	$8,%esp
	
	movl	(%ebx),%ebx
	jmp	DumpProcStackLoop

DumpProcStackRet:
	ret	

#------------------------------------------------------------------------------
	.globl	_NullChar
	.align	2
	.long	0	# tag
	.long	0	# LEN
#*$
_NullChar:
	.asciz	""
	
#------------------------------------------------------------------------------
	.globl	_BitRangeTab
#*$
	.align	2
_BitRangeTab:
		# 33333333333222222222211111111111
		# 10987654321098765432109876543210

	.long	0b00000000000000000000000000000000	# 2^ 0 - 1
	.long	0b00000000000000000000000000000001	# 2^ 1 - 1
	.long	0b00000000000000000000000000000011	# 2^ 2 - 1
	.long	0b00000000000000000000000000000111	# 2^ 3 - 1
	.long	0b00000000000000000000000000001111	# 2^ 4 - 1
	.long	0b00000000000000000000000000011111	# 2^ 5 - 1
	.long	0b00000000000000000000000000111111	# 2^ 6 - 1
	.long	0b00000000000000000000000001111111	# 2^ 7 - 1
	.long	0b00000000000000000000000011111111	# 2^ 8 - 1
	.long	0b00000000000000000000000111111111	# 2^ 9 - 1
	.long	0b00000000000000000000001111111111	# 2^10 - 1
	.long	0b00000000000000000000011111111111	# 2^11 - 1
	.long	0b00000000000000000000111111111111	# 2^12 - 1
	.long	0b00000000000000000001111111111111	# 2^13 - 1
	.long	0b00000000000000000011111111111111	# 2^14 - 1
	.long	0b00000000000000000111111111111111	# 2^15 - 1
	.long	0b00000000000000001111111111111111	# 2^16 - 1
	.long	0b00000000000000011111111111111111	# 2^17 - 1
	.long	0b00000000000000111111111111111111	# 2^18 - 1
	.long	0b00000000000001111111111111111111	# 2^19 - 1
	.long	0b00000000000011111111111111111111	# 2^20 - 1
	.long	0b00000000000111111111111111111111	# 2^21 - 1
	.long	0b00000000001111111111111111111111	# 2^22 - 1
	.long	0b00000000011111111111111111111111	# 2^23 - 1
	.long	0b00000000111111111111111111111111	# 2^24 - 1
	.long	0b00000001111111111111111111111111	# 2^25 - 1
	.long	0b00000011111111111111111111111111	# 2^26 - 1
	.long	0b00000111111111111111111111111111	# 2^27 - 1
	.long	0b00001111111111111111111111111111	# 2^28 - 1
	.long	0b00011111111111111111111111111111	# 2^29 - 1
	.long	0b00111111111111111111111111111111	# 2^30 - 1
	.long	0b01111111111111111111111111111111	# 2^31 - 1
	.long	0b11111111111111111111111111111111	# 2^32 - 1

#------------------------------------------------------------------------------
# void DumpStr(char *str)

	.globl	DumpStr
	.globl	_DumpStr
DumpStr:
_DumpStr:
	pushl	%ebp
	movl	%esp,%ebp
	
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%esi
	pushl	%edi
	pushl	%ebp

	movl	8(%ebp),%edi
	movl	$-1,%ecx
	xor	%al,%al
	cld
	repnz
	scasb
	subl	8(%ebp),%edi

	pushl	%edi	# count
	pushl	8(%ebp)	# bufP
	pushl	$1	# fd
	call	_write
	addl	$12,%esp

	popl	%ebp
	popl	%edi
	popl	%esi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax

	movl	%ebp,%esp
	popl	%ebp
	ret
	
#------------------------------------------------------------------------------
#void DumpDec(int i);
	.globl	DumpDec
	.globl	_DumpDec
DumpDec_Buf:
	.fill	20	
DumpDec_IsNeg:
	.byte	0
DumpDec:
_DumpDec:
	pushl	%ebp
	movl	%esp,%ebp
	
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%esi
	pushl	%edi
	pushl	%ebp

	movl	$10,%ecx
	leal	19+DumpDec_Buf,%edi
	movb	$0,(%edi)
	decl	%edi

	movl	8(%ebp),%eax
	testl	%eax,%eax
	setl	DumpDec_IsNeg
	jge	DumpDecLoop
	negl	%eax

DumpDecLoop:	    
	xorl	%edx,%edx
	idiv	%ecx
	addb	$'0',%dl
	movb	%dl,(%edi)
	decl	%edi
	testl	%eax,%eax
	jnz	DumpDecLoop
	
	cmpb	$1,DumpDec_IsNeg
	jnz	DumpDecNotNeg
	movb	$'-',(%edi)
	decl	%edi
DumpDecNotNeg:

	incl	%edi
	pushl	%edi
	call	DumpStr
	addl	$4,%esp

	popl	%ebp
	popl	%edi
	popl	%esi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax

	movl	%ebp,%esp
	popl	%ebp
	ret

#------------------------------------------------------------------------------
# void DumpLn(); 
	.globl	DumpLn
	.globl	_DumpLn
DumpLn_Text:
	.asciz	"\n"
DumpLn:
_DumpLn:
	pushl	$DumpLn_Text
	call	DumpStr
	addl	$4,%esp
	ret

