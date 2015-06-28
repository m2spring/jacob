MODULE Storage EXTERNAL [""];

TYPE tHeapInfo* = RECORD
      Start-          ,          (* start address of the heap  *)
      End-            ,          (* end address of the heap    *)
      TotalBytes-     ,          (* total size of the heap     *)
      TotalFreeBytes- ,          (* sum of all free blocks     *)
      MaxFreeBytes-   ,          (* size of largest free block *)
      NofFreeBlocks-  : LONGINT; (* number of free block       *)
     END;

tAllocFailHandler* = PROCEDURE(size,nofAttempts:LONGINT);
(*
 * An allocation request of 'size' bytes has failed for
 * 'nofAttempts' times (=0 --> first time).
 *)

PROCEDURE SetAllocFailHandler*(proc:tAllocFailHandler):tAllocFailHandler; 
(*
 * Sets the allocation fail handler to 'proc' and returns the old handler.
 *)

PROCEDURE DumpHeap*; 
(*
 * Writes a detailed list of all heap blocks (free and allocated) to stdout.
 *)
 
PROCEDURE GetInfo*(VAR inf:tHeapInfo); 
(*
 * Yields information about the current heap status.
 *)

PROCEDURE ChangeHeapSize*(change:LONGINT):LONGINT; 
(*
 * Changes the size of the heap by 'change' bytes.
 * Returns the number of bytes of the performed change.
 *)

PROCEDURE GC*; 
(*
 * Performs a garbage collection.
 *)

END Storage.
