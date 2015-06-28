(* $Id: Memory.mi,v 1.8 1992/06/24 12:25:33 grosch rel $ *)

(* $Log: Memory.mi,v $
 * Revision 1.8  1992/06/24  12:25:33  grosch
 * changed cNoMoreSpace from -1 to 0
 *
 * Revision 1.7  1992/03/24  13:31:43  grosch
 * suppress warning message during compilation of C version
 *
 * Revision 1.6  1992/01/30  13:23:29  grosch
 * redesign of interface to operating system
 *
 * Revision 1.5  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.4  90/12/19  11:36:26  grosch
 * inlined procedure PoolAlloc
 * 
 * Revision 1.3  90/03/02  17:36:07  grosch
 * automized handling of machine independent alignment
 * 
 * Revision 1.2  90/02/28  22:07:02  grosch
 * comment for alignment on SPARC
 * 
 * Revision 1.1  89/12/08  20:12:45  grosch
 * introduced a machine dependent variant for MIPS
 * 
 * Revision 1.0  88/10/04  11:47:11  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Juli 1986 *)

MODULE Memory;
IMPORT General,System,SYSTEM;
VAR	  MemoryUsed* :LONGINT; 
			(* Holds the total amount of memory managed by	*)
			(* this module.					*)

CONST
   MinSizeSmallBlock	= 4	;
   MaxSizeSmallBlock	= 62	;   (* 64 - 2     *)
   MinSizeLargeBlockLog	= 6	;   (* Log2 64    *)
   MaxSizeLargeBlockLog = 24	;   (* Log2 2**24 *)
   PoolSize		= 10240	;

TYPE
   tBlockPtr		= POINTER TO tBlock;
   tBlock		= RECORD
			     Successor	: tBlockPtr	;
			     Size	: LONGINT	;
			  END;
   tSmallBlockRange	= LONGINT;
   tLargeBlockRange	= LONGINT;
   ADDRESS = LONGINT;

VAR
   SmallChain	: ARRAY MaxSizeSmallBlock OF ADDRESS;
   LargeChain	: ARRAY MaxSizeLargeBlockLog OF ADDRESS;
   PoolFreePtr	: ADDRESS;
   PoolEndPtr	: ADDRESS;
   i		: tSmallBlockRange;
   j		: tLargeBlockRange;

(* Returns a pointer to dynamically allocated	*)
(* space of size 'ByteCount' bytes.		*)

PROCEDURE^Free*	(ByteCount: LONGINT; a: ADDRESS);

PROCEDURE Alloc*	(ByteCount: LONGINT):LONGINT; 
VAR
   BlockPtr		,
   CurrentBlock		,
   PreviousBlock	,
   BestBlock		,
   PredecessorBlock	: tBlockPtr;
   ChainNumber		:LONGINT; 
   CurrentBlockSize	,
   BestBlockSize	: LONGINT;
   j			: tLargeBlockRange;
BEGIN
   ByteCount := SYSTEM.VAL(LONGINT,SYSTEM.VAL(SET,(ByteCount + General.MaxAlign - 1)) * General.AlignMasks [General.MaxAlign]);

   IF ByteCount <= MaxSizeSmallBlock THEN	(* handle small block *)
      IF ByteCount < MinSizeSmallBlock THEN ByteCount := MinSizeSmallBlock; END;
      IF SmallChain [ByteCount] # 0 THEN	(* obtain block from freelist *)
	 BlockPtr := SYSTEM.VAL(tBlockPtr,SmallChain [ByteCount]);
	 SmallChain [ByteCount] := SYSTEM.VAL(LONGINT,BlockPtr^.Successor);
	 RETURN SYSTEM.VAL(LONGINT,BlockPtr);
      ELSE					(* obtain block from storage pool *)
	 IF (PoolEndPtr - PoolFreePtr) < ByteCount THEN
						(* release old pool *)
	    IF (PoolEndPtr - PoolFreePtr) >= MinSizeSmallBlock THEN
	       Free ((PoolEndPtr - PoolFreePtr), PoolFreePtr);
	    END;
	    PoolFreePtr := Alloc (PoolSize);	(* allocate new pool *)
	    PoolEndPtr  := PoolFreePtr + PoolSize;
	 END;
	 INC (PoolFreePtr, ByteCount);
	 RETURN PoolFreePtr - ByteCount;
      END;
   ELSE						(* handle large block *)

      (* 1. search in LargeChain [Log2 (ByteCount)] using BEST FIT *)

      ChainNumber	:= General.Log2 (ByteCount);
      CurrentBlock	:= SYSTEM.VAL(tBlockPtr,LargeChain [ChainNumber]);
      PreviousBlock	:= SYSTEM.VAL(tBlockPtr,SYSTEM.ADR (LargeChain [ChainNumber]));
      BestBlock		:= NIL;
      BestBlockSize	:= 1000000000;

      WHILE CurrentBlock # NIL DO
	 CurrentBlockSize := CurrentBlock^.Size;
	 IF CurrentBlockSize >= ByteCount THEN	(* exact match *)
	    IF CurrentBlockSize = ByteCount THEN
	       PreviousBlock^.Successor := CurrentBlock^.Successor;
	       RETURN SYSTEM.VAL(LONGINT,CurrentBlock);
	    END;

	    IF CurrentBlockSize < BestBlockSize THEN	(* improve approximation *)
	       BestBlock	:= CurrentBlock;
	       BestBlockSize	:= CurrentBlockSize;
	       PredecessorBlock	:= PreviousBlock;
	    END;
	 END;
	 PreviousBlock	:= CurrentBlock;
	 CurrentBlock	:= CurrentBlock^.Successor;
      END;

      IF BestBlock # NIL THEN
	 PredecessorBlock^.Successor := BestBlock^.Successor;
	 IF BestBlockSize - ByteCount >= MinSizeSmallBlock THEN
	    Free (BestBlockSize - ByteCount,
		  SYSTEM.VAL(LONGINT,BestBlock) + (ByteCount));
	 END;
	 RETURN SYSTEM.VAL(LONGINT,BestBlock);
      END;

      (* 2. search in LargeChain [j], j > Log2 (ByteCount), using FIRST FIT *)

      FOR j := ChainNumber+1 TO MaxSizeLargeBlockLog DO
	 CurrentBlock := SYSTEM.VAL(tBlockPtr,LargeChain [j]);
	 IF CurrentBlock # NIL THEN
	    LargeChain [j] := SYSTEM.VAL(LONGINT,CurrentBlock^.Successor);
	    IF CurrentBlock^.Size - ByteCount >= MinSizeSmallBlock THEN
	       Free (CurrentBlock^.Size - ByteCount,
		     SYSTEM.VAL(LONGINT,CurrentBlock) + (ByteCount));
	    END;
	    RETURN SYSTEM.VAL(LONGINT,CurrentBlock);
	 END;
      END;

      IF ByteCount < PoolSize THEN	(* 3. obtain block from storage pool *)
	 IF (PoolEndPtr - PoolFreePtr) < ByteCount THEN
						(* release old pool *)
	    IF (PoolEndPtr - PoolFreePtr) >= MinSizeSmallBlock THEN
	       Free ((PoolEndPtr - PoolFreePtr), PoolFreePtr);
	    END;
	    PoolFreePtr := Alloc (PoolSize);	(* allocate new pool *)
	    PoolEndPtr  := PoolFreePtr + PoolSize;
	 END;
	 INC (PoolFreePtr, (ByteCount));
	 RETURN PoolFreePtr - (ByteCount);

      ELSE				(* 4. allocate individual block *)
	 BlockPtr := SYSTEM.VAL(tBlockPtr,System.SysAlloc (ByteCount));
	 INC (MemoryUsed, ByteCount);
	 RETURN SYSTEM.VAL(LONGINT,BlockPtr);
      END;
   END;
END Alloc;

(* The dynamically allocated space starting at	*)
(* address 'a' of size 'ByteCount' bytes is	*)
(* released.					*)

PROCEDURE Free*	(ByteCount: LONGINT; a: ADDRESS);
VAR
   BlockPtr	: tBlockPtr;
   ChainNumber	: tLargeBlockRange;
BEGIN
   ByteCount := SYSTEM.VAL(LONGINT ,SYSTEM.VAL(SET ,ByteCount + General.MaxAlign - 1) * General.AlignMasks [General.MaxAlign]);

   BlockPtr := SYSTEM.VAL(tBlockPtr,a);
   IF ByteCount <= MaxSizeSmallBlock THEN
      IF ByteCount < MinSizeSmallBlock THEN ByteCount := MinSizeSmallBlock; END;
      BlockPtr^.Successor	:= SYSTEM.VAL(tBlockPtr,SmallChain [ByteCount]);
      SmallChain [ByteCount]	:= SYSTEM.VAL(LONGINT,BlockPtr);
   ELSE
      ChainNumber		:= General.Log2 (ByteCount);
      BlockPtr^.Successor	:= SYSTEM.VAL(tBlockPtr,LargeChain [ChainNumber]);
      BlockPtr^.Size		:= ByteCount;
      LargeChain [ChainNumber]	:= SYSTEM.VAL(LONGINT,BlockPtr);
   END;
END Free;

(*
PROCEDURE WriteMemory;
   VAR
      BlockPtr	: tBlockPtr;
      Count	: INTEGER;
   BEGIN
      WriteS (StdOutput, "PoolFreePtr, PoolEndPtr = ");
      WriteN (StdOutput, INTEGER (PoolFreePtr), 8, 16);
      WriteN (StdOutput, INTEGER (PoolEndPtr ), 8, 16);
      WriteNl (StdOutput);
      WriteNl (StdOutput);

      WriteS (StdOutput, "SmallChain:");
      WriteNl (StdOutput);
      FOR i := MinSizeSmallBlock TO MaxSizeSmallBlock BY 2 DO
	 WriteI (StdOutput, i, 3);
	 WriteC (StdOutput, ':');
	 Count := 0;
	 BlockPtr := SmallChain [i];
	 WHILE BlockPtr # NIL DO
	    IF Count = 8 THEN
	       WriteNl (StdOutput);
	       WriteS (StdOutput, "    ");
	       Count := 0;
	    END;
	    INC (Count);
	    WriteC (StdOutput, ' ');
	    WriteN (StdOutput, INTEGER (BlockPtr), 8, 16);
	    BlockPtr := BlockPtr^.Successor;
	 END;
	 WriteNl (StdOutput);
      END;
      WriteNl (StdOutput);

      WriteS (StdOutput, "LargeChain:");
      WriteNl (StdOutput);
      FOR j := MinSizeLargeBlockLog TO MaxSizeLargeBlockLog DO
	 WriteI (StdOutput, j, 3);
	 WriteC (StdOutput, ':');
	 Count := 0;
	 BlockPtr := LargeChain [j];
	 WHILE BlockPtr # NIL DO
	    IF Count = 5 THEN
	       WriteNl (StdOutput);
	       WriteS (StdOutput, "    ");
	       Count := 0;
	    END;
	    INC (Count);
	    WriteC (StdOutput, ' ');
	    WriteN (StdOutput, INTEGER (BlockPtr), 8, 16);
	    WriteI (StdOutput, BlockPtr^.Size, 5);
	    BlockPtr := BlockPtr^.Successor;
	 END;
	 WriteNl (StdOutput);
      END;
      WriteNl (StdOutput);
   END WriteMemory;
*)

BEGIN
   FOR i := MinSizeSmallBlock TO MaxSizeSmallBlock BY 2 DO
      SmallChain [i] := 0;
   END;
   FOR j := MinSizeLargeBlockLog TO MaxSizeLargeBlockLog DO
      LargeChain [j] := 0;
   END;
   PoolFreePtr	:= 0;
   PoolEndPtr	:= 0;
   MemoryUsed	:= 0;
END Memory.
