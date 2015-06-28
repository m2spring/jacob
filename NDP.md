DEFINITION MODULE NDP;
(*
 * Encapsulates the handling of an conceptually infinite ndp stack.
 *)

IMPORT ASM, ASMOP;

PROCEDURE Init(ftempOfs:LONGINT); 
(*
 * Tell NDP the offset relative to ebp, where to store temporaries.
 *)

PROCEDURE SetTop(top:LONGINT); 
(*
 * Sets explicitly the number of elements in the ndp stack.
 *)

PROCEDURE UsedTempSize():LONGINT; 
(*
 * Yields the number of bytes used for temporaries since last call of 'Init'.
 *)

PROCEDURE C0(oper:ASMOP.tOper); 
(*
 * Codes a machine instruction with implied operands.
 *)

PROCEDURE C1(oper:ASMOP.tOper; op:ASM.tOp); 
(*
 * Codes a machine instruction with one operand.
 *)

PROCEDURE CS1(oper:ASMOP.tOper; s:ASM.tSize; op:ASM.tOp); 
(*
 * Codes a machine instruction with a size specifier and one operand.
 *)

PROCEDURE Save;
(*
 * Produces code for saving the current ndp elements into the temp area.
 *)

END NDP.
