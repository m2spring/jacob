(* $Id: Heap.mi,v 1.5 1991/11/21 14:33:17 grosch rel $ *)

(* $Log: Heap.mi,v $
 * Revision 1.5  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.4  90/03/02  17:36:09  grosch
 * automized handling of machine independent alignment
 * 
 * Revision 1.3  90/02/28  22:07:01  grosch
 * comment for alignment on SPARC
 * 
 * Revision 1.2  90/02/12  10:53:40  grosch
 * introduced a machine dependent variant for MIPS
 * 
 * Revision 1.1  89/07/13  11:27:01  grosch
 * reset pointers to NIL in Free
 * 
 * Revision 1.0  88/10/04  11:46:56  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, 2.9.1988 *)

MODULE Heap;

IMPORT SYSTEM,General,Memory;

TYPE ADDRESS = LONGINT;   
     LONGCARD = LONGINT;
     
VAR	  HeapUsed*	: LONGCARD;
			(* Holds the total amount of memory managed by	*)
			(* this module.					*)

CONST
   PoolSize		= 10240	;

TYPE
   tBlockPtr		= POINTER TO tBlock;
   tBlock		= RECORD
			     Successor	: tBlockPtr	;
			     Block	: ARRAY PoolSize OF CHAR;
			  END;

VAR
   BlockList	: tBlockPtr;
   PoolFreePtr	: ADDRESS;
   PoolEndPtr	: ADDRESS;

(* Returns a pointer to dynamically allocated	*)
(* space of size 'ByteCount' bytes.		*)

PROCEDURE Alloc*	(ByteCount: LONGINT): ADDRESS;
VAR BlockPtr	: tBlockPtr;
BEGIN
   ByteCount := SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,ByteCount + General.MaxAlign - 1) * General.AlignMasks [General.MaxAlign]);
   IF (PoolEndPtr - PoolFreePtr) < ByteCount THEN
      BlockPtr	  := BlockList;
      BlockList	  := SYSTEM.VAL(tBlockPtr,Memory.Alloc (SIZE (tBlock)));
      BlockList^.Successor := BlockPtr;
      PoolFreePtr := SYSTEM.ADR (BlockList^.Block);
      PoolEndPtr  := PoolFreePtr + PoolSize;
      INC (HeapUsed, PoolSize);
   END;
   INC (PoolFreePtr, (ByteCount));
   RETURN PoolFreePtr - (ByteCount);
END Alloc;

(* The complete space allocated for the heap	*)
(* is released.					*)

PROCEDURE Free*;
VAR BlockPtr	: tBlockPtr;
BEGIN
   WHILE BlockList # NIL DO
      BlockPtr	:= BlockList;
      BlockList	:= BlockList^.Successor;
      Memory.Free (SIZE (tBlock), SYSTEM.VAL(LONGINT,BlockPtr));
   END;
   PoolFreePtr	:= 0;
   PoolEndPtr	:= 0;
   HeapUsed	:= 0;
END Free;

BEGIN
   BlockList	:= NIL;
   Free;
END Heap.

