#ifdef ELF
#define EXTERNAL(x) .globl x; x
#define EXT(x) x
#else
#define EXTERNAL(x) .globl _##x; _##x
#define EXT(x) _##x
#endif

//------------------------------------------------------------------------------
	.comm	saved_esp,4
	.comm	_argc,4
	.comm	_argv,4
	.comm	_env,4
        
EXTERNAL(main):
	pushl	%ebp
	movl	%esp,%ebp
	movl	%esp,saved_esp

	movl	8(%ebp),%eax
	movl	%eax,_argc
	movl	12(%ebp),%eax
	movl	%eax,_argv
	movl	16(%ebp),%eax
	movl	%eax,_env

	// NDP control word format:
	//
	// +---------------+---------------+---------------+---------------+
	// |15  14  13  12 |11  10   9   8 | 7   6   5   4 | 3   2   1   0 |
	// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
	// | X | X | X | 0 |   RC  |   PC  | X | X | PM| UM| OM| ZM| DM| IM|
	// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
	//		      ^       ^             ^   ^   ^   ^   ^   ^
	//                     |	      |             |   |   |   |   |   |
	// Rounding Control ---+	      |             |   |   |   |   |   |
	// Precision Control ----------+             |   |   |   |   |   |
	//                                           |   |   |   |   |   |
	// Precision Mask ---------------------------+   |   |   |   |   |
	// Underflow Mask -------------------------------+   |   |   |   |
	// Overflow Mask ------------------------------------+   |   |   |
	// Zero divide Mask -------------------------------------+   |   |
	// Denormal operand Mask ------------------------------------+   |
	// Invalid operation Mask ---------------------------------------+

	// set NDP rounding control to 01 = "round down"
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
        
//------------------------------------------------------------------------------
	.data
	.globl	_ExitProc
_ExitProc:
	.long	StdExit
ExitCode:
	.long	0
	.text

//------------------------------------------------------------------------------
StdExit:
	pushl	ExitCode
        call	EXT(exit)

        movl	saved_esp,%esp
        leave
	ret
	
//------------------------------------------------------------------------------
	.globl	_Halt
_Halt:
        pushl	%ebp
        movl	%esp,%ebp
        
        movl	8(%ebp),%eax
	movl	%eax,ExitCode
	
	movl	_ExitProc,%eax
        call	%eax

	jmp	StdExit

//------------------------------------------------------------------------------
RtErrMsg:
	.asciz	"\n*** RUNTIME ERROR: %s\n"
_RtErr:
	pushl	$RtErrMsg
	call	EXT(printf)
	addl	$8,%esp
	
	call	DumpProcStack

	pushl	$1
	call	_Halt
	
//------------------------------------------------------------------------------
NILPROC_Msg:
	.asciz	"NIL procedure called"
	.globl	_NILPROC
_NILPROC:        
	pushl	$NILPROC_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
FunctionFault_Msg:
	.asciz	"Function procedure without return value"
	.globl	_FunctionFault
_FunctionFault:        
	pushl	$FunctionFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
IndexFault_Msg:
	.asciz	"Index out of bounds"
	.globl	_IndexFault
_IndexFault:        
	pushl	$IndexFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
NilFault_Msg:
	.asciz	"NIL pointer dereferenced"
	.globl	_NilFault
_NilFault:        
	pushl	$NilFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
ElementFault_Msg:
	.asciz	"Element out of SET"
	.globl	_ElementFault
_ElementFault:        
	pushl	$ElementFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
DivFault_Msg:
	.asciz	"Non-positive divisor in DIV or MOD"
	.globl	_DivFault
_DivFault:        
	pushl	$DivFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
LenFault_Msg:
	.asciz	"Non-positive LEN in NEW"
	.globl	_LenFault
_LenFault:        
	pushl	$LenFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
AbsFault_Msg:
	.asciz	"ABS(MIN(integer))"
	.globl	_AbsFault
_AbsFault:        
	pushl	$AbsFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
ChrFault_Msg:
	.asciz	"CHR argument out of range"
	.globl	_ChrFault
_ChrFault:        
	pushl	$ChrFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
ShortFault_Msg:
	.asciz	"SHORT argument out of range"
	.globl	_ShortFault
_ShortFault:        
	pushl	$ShortFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
GuardFault_Msg:
	.asciz	"(Implicit) type guard failed"
GuardFault_Info:
	.asciz	"*** (actual type was %s, guarded type was %s)\n"
	.globl	_GuardFault
_GuardFault:        
	pushl	$GuardFault_Msg
	pushl	$RtErrMsg
	call	EXT(printf)
	addl	$8,%esp
	
        pushl	$GuardFault_Info
        call	EXT(printf)
        addl	$12,%esp

	call	DumpProcStack

	pushl	$1
	call	_Halt
	
//------------------------------------------------------------------------------
CaseFault_Msg:
	.asciz	"Missing ELSE in CASE statement"
	.globl	_CaseFault
_CaseFault:        
	pushl	$CaseFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
WithFault_Msg:
	.asciz	"Missing ELSE in WITH statement"
	.globl	_WithFault
_WithFault:        
	pushl	$WithFault_Msg
	jmp	_RtErr

//------------------------------------------------------------------------------
AssertFail_Msg:
	.asciz	"Assertion failed"
AssertFail_Info:
	.asciz	"*** (error code = %i)\n"
	.globl	_AssertFail
_AssertFail:        
        pushl	%ebp
        movl	%esp,%ebp
        
	pushl	$AssertFail_Msg
	pushl	$RtErrMsg
	call	EXT(printf)
	addl	$8,%esp
	
        pushl	8(%ebp)
	pushl	$AssertFail_Info
	call	EXT(printf)
	addl	$8,%esp

	movl	8(%ebp),%eax
	leave
	pushl	%eax

	call	DumpProcStack

        call	EXT(exit)
        movl	saved_esp,%esp
        leave
	ret

//------------------------------------------------------------------------------
DumpProcStackMsg:
	.asciz	"*** procedure stack:\n"
DumpProcStack:
	pushl	$DumpProcStackMsg
	call	EXT(printf)
	addl	$4,%esp

	// ebp points to last stackframe
	
	movl	%ebp,%ebx

DumpProcStackLoop:
	movl	-4(%ebx),%eax		// eax := tag(proc)
	cmpl	_FirstModuleTDesc,%eax	// IF tag(proc) = TDesc(root_init_proc) THEN RETURN
	jz	DumpProcStackRet

	pushl	-12(%eax)
	call	EXT(printf)
	addl	$4,%esp
	
	pushl	$10
	movl	%esp,%eax
	pushl	%eax
	call	EXT(printf)
	addl	$8,%esp
	
	movl	(%ebx),%ebx
	jmp	DumpProcStackLoop

DumpProcStackRet:
	ret	

//------------------------------------------------------------------------------
	.align	2
	.long	0	// tag
	.long	0	// LEN
	.globl	_NullChar
_NullChar:
	.asciz	""
	
//------------------------------------------------------------------------------
	.align	2
	.globl	_BitRangeTab
_BitRangeTab:
		// 33333333333222222222211111111111
		// 10987654321098765432109876543210

	.long	0b00000000000000000000000000000000	// 2^ 0 - 1
	.long	0b00000000000000000000000000000001	// 2^ 1 - 1
	.long	0b00000000000000000000000000000011	// 2^ 2 - 1
	.long	0b00000000000000000000000000000111	// 2^ 3 - 1
	.long	0b00000000000000000000000000001111	// 2^ 4 - 1
	.long	0b00000000000000000000000000011111	// 2^ 5 - 1
	.long	0b00000000000000000000000000111111	// 2^ 6 - 1
	.long	0b00000000000000000000000001111111	// 2^ 7 - 1
	.long	0b00000000000000000000000011111111	// 2^ 8 - 1
	.long	0b00000000000000000000000111111111	// 2^ 9 - 1
	.long	0b00000000000000000000001111111111	// 2^10 - 1
	.long	0b00000000000000000000011111111111	// 2^11 - 1
	.long	0b00000000000000000000111111111111	// 2^12 - 1
	.long	0b00000000000000000001111111111111	// 2^13 - 1
	.long	0b00000000000000000011111111111111	// 2^14 - 1
	.long	0b00000000000000000111111111111111	// 2^15 - 1
	.long	0b00000000000000001111111111111111	// 2^16 - 1
	.long	0b00000000000000011111111111111111	// 2^17 - 1
	.long	0b00000000000000111111111111111111	// 2^18 - 1
	.long	0b00000000000001111111111111111111	// 2^19 - 1
	.long	0b00000000000011111111111111111111	// 2^20 - 1
	.long	0b00000000000111111111111111111111	// 2^21 - 1
	.long	0b00000000001111111111111111111111	// 2^22 - 1
	.long	0b00000000011111111111111111111111	// 2^23 - 1
	.long	0b00000000111111111111111111111111	// 2^24 - 1
	.long	0b00000001111111111111111111111111	// 2^25 - 1
	.long	0b00000011111111111111111111111111	// 2^26 - 1
	.long	0b00000111111111111111111111111111	// 2^27 - 1
	.long	0b00001111111111111111111111111111	// 2^28 - 1
	.long	0b00011111111111111111111111111111	// 2^29 - 1
	.long	0b00111111111111111111111111111111	// 2^30 - 1
	.long	0b01111111111111111111111111111111	// 2^31 - 1
	.long	0b11111111111111111111111111111111	// 2^32 - 1

//------------------------------------------------------------------------------
// void DumpStr(char *str)

	.globl	_DumpStr
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

	pushl	%edi	// count
	pushl	8(%ebp)	// bufP
	pushl	$1	// fd
	call	EXT(write)
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
	
//------------------------------------------------------------------------------
//void DumpDec(int i);
DumpDec_Buf:
	.fill	20	
DumpDec_IsNeg:
	.byte	0
	.globl	_DumpDec
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
	call	_DumpStr
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

//------------------------------------------------------------------------------
// void DumpLn(); 
DumpLn_Text:
	.asciz	"\n"
	.globl	_DumpLn
_DumpLn:
	pushl	$DumpLn_Text
	call	_DumpStr
	addl	$4,%esp
	ret


