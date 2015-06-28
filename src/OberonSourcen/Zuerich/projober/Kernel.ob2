MODULE Kernel;  (*NW  11.4.86 / 12.4.91*)

   TYPE Sector* = RECORD END ;
      IntProc*  = PROCEDURE;

   VAR ModList*:    LONGINT;
         NofPages*, NofSectors*, allocated*:  LONGINT;
         StackOrg*, HeapLimit*: LONGINT;
         FileRoot*, FontRoot*: LONGINT;
         SectNo*:     LONGINT;

         pc*, sb*, fp*, sp0*, sp1*, mod*, eia*: LONGINT; (*status upon trap*)
         err*, pcr*: INTEGER;

(* Block storage management*)

 PROCEDURE AllocBlock*(VAR dadr, blkadr: LONGINT; size: LONGINT); END AllocBlock;
 PROCEDURE FreeBlock*(dadr: LONGINT); END FreeBlock;

(* Block storage management - garbage collector*)

 PROCEDURE GC*; END GC;

(* Disk storage management*)

 PROCEDURE AllocSector*(hint: LONGINT; VAR sec: LONGINT); END AllocSector;
 PROCEDURE MarkSector*(sec: LONGINT); END MarkSector;
 PROCEDURE FreeSector*(sec: LONGINT); END FreeSector;
 PROCEDURE GetSector*(src: LONGINT; VAR dest: Sector); END GetSector;
 PROCEDURE PutSector*(dest: LONGINT; VAR src: Sector); END PutSector;
 PROCEDURE ResetDisk*; END ResetDisk;

(* Miscellaneous procedures*)

 PROCEDURE InstallIP*(P: IntProc; chan: INTEGER); END InstallIP;
 PROCEDURE InstallTrap*(P: IntProc); END InstallTrap;
 PROCEDURE SetICU*(n: CHAR); END SetICU;
 PROCEDURE GetClock*(VAR time, date: LONGINT); END GetClock;
 PROCEDURE SetClock*(time, date: LONGINT); END SetClock;

END Kernel.
