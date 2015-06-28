MODULE Main;
IMPORT S:=SYSTEM;

PROCEDURE Ln*;
BEGIN (* Ln *)
 S.ASM('	.data'
      ,'Ln0:	.asciz	"\n"'
      ,'	.text'
      ,'	pushl	$Ln0'
      ,'	call	_printf'
      ,'	addl	$4,%esp'
      ); 
END Ln;

PROCEDURE DumpRootFrames*;
BEGIN (* DumpRootFrames *)
 S.ASM('	movl	%ebp,%ebx'
      ,'Loop1:'
      ,'        movl	-4(%ebx),%eax	# eax := tag'
      ,''
      ,'	pushl	%eax'
      ,'	pushl	%ebx'
      ,''
      ,'	pushl	-12(%eax)	# name'
      ,'	call	_printf'
      ,'	addl	$4,%esp                '
      ,'        '
      ,'	call	Main_Ln'
      ,''
      ,'	popl	%ebx'
      ,'	popl	%eax'
      ,''
      ,'	cmpl	$_$I$D,%eax'
      ,'        jz	Done'
      ,''
      ,'	movl	(%ebp),%ebx'
      ,'	jmp	Loop1'
      ,''
      ,'Done:'
      );
END DumpRootFrames;

PROCEDURE test*;
BEGIN (* test *)
 S.ASM('	.data'
      ,'msg0:'
      ,'	.asciz	"Hello world!\n"'
      ,'	.text'
      ,'	pushl	$msg0'
      ,'	call	_printf'
      ,'	addl	$4,%esp'
      ); 
END test;

BEGIN (* Main *)
 S.ASM('	call	Main_DumpRootFrames'); 
END Main.
