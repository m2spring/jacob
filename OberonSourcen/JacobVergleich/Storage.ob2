(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

MODULE Storage;
IMPORT SysLib,SYSTEM;

   CONST
     Alignment	       = 4;
     MinSizeSmallBlock = 4;	(* must be aligned *)

   CONST
     MaxSizeSmallBlock     = 30;
     MinSizeLargeBlockLog  = 5;    (* Log2 32    *)
     MaxSizeLargeBlockLog  = 24;   (* Log2 2**24 *)
     PoolSize              = 10240;
     cNoMoreSpace          = -1;

   TYPE
     tBlockPtr        = POINTER TO tBlock;
     tBlock           = RECORD
			  Successor : tBlockPtr;
			  Size      : LONGINT; 
			END;
     tSmallBlockRange = LONGINT;
     tLargeBlockRange = LONGINT;
     ADDRESS = SYSTEM.PTR;
     CARDINAL = LONGINT;
     
   VAR
     SmallChain    : ARRAY MaxSizeSmallBlock-MinSizeSmallBlock+1 OF ADDRESS;
     LargeChain    : ARRAY MaxSizeLargeBlockLog-MinSizeLargeBlockLog+1 OF ADDRESS;
     PoolFreePtr   : ADDRESS;
     PoolSpaceLeft : CARDINAL;
     NoMoreSpace   : LONGINT;

   VAR
     i : tSmallBlockRange;
     j : tLargeBlockRange;



   PROCEDURE^PoolAlloc (VAR a : ADDRESS; size: CARDINAL);
   PROCEDURE^DEALLOCATE* (VAR a : ADDRESS; size : CARDINAL);
   
   PROCEDURE Log2 (x: LONGINT) : CARDINAL;
   (* Returns the logarithm to the base 2 of 'x'.        *)
     VAR y: CARDINAL;
   BEGIN
     y := 0;
     IF x >= 65536 THEN INC (y, 16); x := x DIV 65536; END;
     IF x >=   256 THEN INC (y,  8); x := x DIV   256; END;
     IF x >=    16 THEN INC (y,  4); x := x DIV    16; END;
     IF x >=     4 THEN INC (y,  2); x := x DIV     4; END;
     IF x >=     2 THEN INC (y,  1); x := x DIV     2; END;
     RETURN y;
   END Log2;


   PROCEDURE ALLOCATE* (VAR a : SYSTEM.PTR; size :LONGINT);
   (* Allocates an area of the given size 'size' and returns it's *) 
   (* address in 'a'. If no space is available, 'a' becomes 'NIL'. *)

   VAR
     BlockPtr,
     CurrentBlock,
     PreviousBlock,
     BestBlock,
     PredecessorBlock : tBlockPtr;
     ChainNumber      : CARDINAL;
     CurrentBlockSize,
     BestBlockSize    : CARDINAL;
     j                : tLargeBlockRange;

   BEGIN
       (* align size to next Alignment boundary: *)
       size := SYSTEM.VAL(CARDINAL, SYSTEM.VAL(SET,size + (Alignment-1)) - SYSTEM.VAL(SET,Alignment-1) );

       IF size < MinSizeSmallBlock THEN
	 size := MinSizeSmallBlock;
       END;

       IF size <= MaxSizeSmallBlock THEN

	 (* handle small block *)

	 IF SYSTEM.VAL(LONGINT,SmallChain [size]) # 0 THEN

	   (* obtain block from freelist *)

	   BlockPtr := SYSTEM.VAL(tBlockPtr,SmallChain [size]);
	   SmallChain [size] := BlockPtr^.Successor;
	   a :=  BlockPtr;

	 ELSE

	   (* obtain block from storage pool *)

	   PoolAlloc (a, size);
	 END;
       ELSE

	 (* handle large block *)

	 (* 1. search in LargeChain [Log2 (size)] using BEST FIT *)

	 ChainNumber    := Log2 (size);
	 CurrentBlock   := SYSTEM.VAL(tBlockPtr,LargeChain [ChainNumber]);
	 PreviousBlock  := SYSTEM.VAL(tBlockPtr,SYSTEM.ADR (LargeChain [ChainNumber]));
	 BestBlock      := NIL;
	 BestBlockSize  := MAX(CARDINAL);

	 WHILE CurrentBlock # NIL DO

	   CurrentBlockSize := CurrentBlock^.Size;
	   IF CurrentBlockSize >= size THEN

	     (* exact match *)

	     IF CurrentBlockSize = size THEN
	       PreviousBlock^.Successor := CurrentBlock^.Successor;
	       a := CurrentBlock;
	       RETURN
	     END;

	     (* improve approximation *)

	     IF CurrentBlockSize < BestBlockSize THEN
	       BestBlock        := CurrentBlock;
	       BestBlockSize    := CurrentBlockSize;
	       PredecessorBlock := PreviousBlock;
	     END;
	   END;
	   PreviousBlock := CurrentBlock;
	   CurrentBlock  := CurrentBlock^.Successor;
	 END;

	 IF BestBlock # NIL THEN
	   PredecessorBlock^.Successor := BestBlock^.Successor;
	   IF   BestBlockSize - size >= MinSizeSmallBlock
	   THEN a := SYSTEM.VAL(SYSTEM.PTR,SYSTEM.VAL(LONGINT,BestBlock) + size);
		DEALLOCATE (a, BestBlockSize - size);
	   END;
	   a := BestBlock;
	   RETURN
	 END;

	 (* 2. search in LargeChain [j], j > Log2 (size), using FIRST FIT *)

	 FOR j := ChainNumber+1 TO MaxSizeLargeBlockLog DO
	   CurrentBlock := SYSTEM.VAL(tBlockPtr,LargeChain [j]);
	   IF CurrentBlock # NIL THEN
	     LargeChain [j] := CurrentBlock^.Successor;
	     IF   CurrentBlock^.Size - size >= MinSizeSmallBlock
	     THEN a := SYSTEM.VAL(SYSTEM.PTR,SYSTEM.VAL(LONGINT,CurrentBlock) + size);
		  DEALLOCATE (a, CurrentBlock^.Size - size);
	     END;

	     a := CurrentBlock;
	     RETURN
	   END;
	 END;

	 IF size < PoolSize THEN

	   (* 3. obtain block from storage pool *)

	   PoolAlloc (a, size);
	 ELSE

	   (* 4. allocate individual block *)
	   IF (size) >= 0 THEN
	     BlockPtr := SYSTEM.VAL(tBlockPtr,SysLib.sbrk (size));
	   ELSE
	     BlockPtr := SYSTEM.VAL(tBlockPtr,NoMoreSpace);
	   END;

	   IF (BlockPtr) = SYSTEM.VAL(tBlockPtr,NoMoreSpace) THEN
	     a := SYSTEM.VAL(SYSTEM.PTR,0);
	   ELSE
	     a := BlockPtr;
	   END;
	 END;
       END;
   END ALLOCATE;


   PROCEDURE DEALLOCATE* (VAR a : SYSTEM.PTR; size :LONGINT);
   (* Frees the area of size 'size' starting at address 'a' *)
   VAR
     BlockPtr    : tBlockPtr;
     ChainNumber : tLargeBlockRange;

   BEGIN
       (* align size to next Alignment boundary: *)
       size := SYSTEM.VAL(CARDINAL, SYSTEM.VAL(SET,size + (Alignment-1)) - SYSTEM.VAL(SET,Alignment-1) );

       IF size < MinSizeSmallBlock THEN
	 size := MinSizeSmallBlock;
       END;

       BlockPtr := SYSTEM.VAL(tBlockPtr,a);
       IF size <= MaxSizeSmallBlock THEN
	 BlockPtr^.Successor := SYSTEM.VAL(tBlockPtr,SmallChain [size]);
	 SmallChain [size]   := BlockPtr;
       ELSE
	 ChainNumber              := Log2 (size);
	 BlockPtr^.Successor      := SYSTEM.VAL(tBlockPtr,LargeChain [ChainNumber]);
	 BlockPtr^.Size           := size;
	 LargeChain [ChainNumber] := BlockPtr;
       END;
       a := SYSTEM.VAL(SYSTEM.PTR,0);
   END DEALLOCATE;


   PROCEDURE PoolAlloc (VAR a : SYSTEM.PTR; size:LONGINT);
   (* Allocates 'size' bytes in the internal      *)
   (* storage pool and returns the start address. *)
   BEGIN
     IF PoolSpaceLeft < size THEN

       (* release old pool *)

       IF PoolSpaceLeft >= MinSizeSmallBlock THEN
	 DEALLOCATE (PoolFreePtr, PoolSpaceLeft);
       END;

       (* allocate new pool *)

       ALLOCATE (PoolFreePtr, PoolSize);

       PoolSpaceLeft := PoolSize;
     END;

     IF SYSTEM.VAL(LONGINT,PoolFreePtr) # 0 THEN
       DEC (PoolSpaceLeft, size);
       PoolFreePtr:=SYSTEM.VAL(SYSTEM.PTR,SYSTEM.VAL(LONGINT,PoolFreePtr)+size); 
       a:=SYSTEM.VAL(SYSTEM.PTR,SYSTEM.VAL(LONGINT,PoolFreePtr)-size); 
     ELSE
       PoolSpaceLeft := 0;
       a := SYSTEM.VAL(SYSTEM.PTR,0);
     END;
   END PoolAlloc;






BEGIN

      FOR i := MinSizeSmallBlock TO MaxSizeSmallBlock BY 2 DO
	SmallChain [i] := SYSTEM.VAL(SYSTEM.PTR,0);
      END;
      FOR j := MinSizeLargeBlockLog TO MaxSizeLargeBlockLog DO
	LargeChain [j] := SYSTEM.VAL(SYSTEM.PTR,0);
      END;
      PoolSpaceLeft := 0;
      NoMoreSpace   := cNoMoreSpace;

END Storage.
