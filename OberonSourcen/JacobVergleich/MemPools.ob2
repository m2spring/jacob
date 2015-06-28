(******************************************************************************)
(* Copyright (c) 1993 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

(* $Id: MemPools.mi,v 1.3 1994/05/19 13:44:04 roques Exp $ *)
MODULE MemPools;
(* $Log: MemPools.mi,v $
 * Revision 1.3  1994/05/19  13:44:04  roques
 * Fixed the assertion for SIZE(ADDRESS)>4.
 *
 * Revision 1.2  1993/10/28  10:41:55  hopp
 * added Copyright
 *
 * Revision 1.1  1993/10/09  16:42:01  roques
 * Initial revision
 *
 *)

  IMPORT SYSTEM,SysLib;

  TYPE
    ADDRESS=LONGINT;  
    CARDINAL=LONGINT;  
    MemPool* = POINTER TO PoolHead;
    PoolHead = RECORD
                 next : MemPool;
                 size : CARDINAL;
                 this, last : ADDRESS;
               END;

  CONST
    InitialChunkSize = 32768;

  PROCEDURE NewPool*(VAR pool: MemPool);
  (* Does create a new [empty] MemPool.	*)
  BEGIN
    pool := SYSTEM.VAL(MemPool,SysLib.malloc(InitialChunkSize));
      pool.next := NIL;
      pool.size := InitialChunkSize;
      pool.this := SYSTEM.VAL(ADDRESS,pool) + SIZE(PoolHead);	(* should be aligned to 8. *)
      pool.last := SYSTEM.VAL(ADDRESS,pool) + pool.size;
  END NewPool;

  PROCEDURE PoolAllocate*(VAR pool: MemPool; VAR ptr: ADDRESS; want:LONGINT);
  (* Allocates want bytes of memory out of pool MemPool.	*)
  (* ptr's alignment will be suitable for all types.	*)
    VAR
      newSize :LONGINT; 
      newPool : MemPool;
  BEGIN
      IF pool.this + want > pool.last THEN
        newSize:=2*pool.size;
        WHILE newSize < want+SIZE(PoolHead) DO INC(newSize,newSize); END;
        newPool := SYSTEM.VAL(MemPool,SysLib.malloc(newSize));
        newPool^.next := pool;
        newPool^.size := newSize;
        newPool^.this := SYSTEM.VAL(ADDRESS,newPool) + SIZE(PoolHead);
        newPool^.last := SYSTEM.VAL(ADDRESS,newPool) + newSize;
        pool:=newPool;
    END;
      ptr := pool.this;
      pool.this := SYSTEM.VAL(ADDRESS,SYSTEM.VAL(SET,pool.this+want+7)-{0..2});
  END PoolAllocate;

  PROCEDURE KillPool*(VAR pool: MemPool);
  (* Destroys the pool. *)
  VAR
    nextPool: MemPool;
  BEGIN
    WHILE pool # NIL DO
      nextPool := pool^.next;
      SysLib.free(SYSTEM.VAL(LONGINT,pool));
      pool := nextPool;
    END;
  END KillPool;

BEGIN
  IF SYSTEM.VAL(SET,SIZE(PoolHead)) * {0..3} # {} THEN SysLib.abort; END;	(* We don't have assert() *)
END MemPools.

