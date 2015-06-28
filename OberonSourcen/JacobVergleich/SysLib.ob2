(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

(* for UNIX only *)
MODULE SysLib;

   TYPE
      SIGNED*    = LONGINT;
      UNSIGNED*  = LONGINT;
      ADDRESS*   = LONGINT;

      timeT*     = LONGINT;
      uidT*	= INTEGER;
      gidT*	= INTEGER;
      devT*      = INTEGER;
      inoT*      = LONGINT;
      umodeT*	= INTEGER;
      nlinkT*	= INTEGER;
      offT*      = LONGINT;

      Stat* =
         RECORD
            stDev*    : devT;
            pad1*     : INTEGER;
	    stIno*    : inoT;
            stMode*   : umodeT;
            stNlink*  : nlinkT;
            stUid*    : uidT;
            stGid*    : gidT;
            stRdev*   : devT;
            pad2*     : INTEGER;
	    stSize*   : offT;
            stBlksize*: LONGINT;
            stBlocks* : LONGINT;
            stAtime*  : timeT;
            unused1*  : LONGINT;
            stMtime*  : timeT;
            unused2*  : LONGINT;
            stCtime*  : timeT;
            unused3*  : LONGINT;
            unused4*  : LONGINT;
            unused5* :  LONGINT;
         END;

      tms* =
	 RECORD
	    utime*  : timeT;  
	    stime*  : timeT;
	    cutime* : timeT;
	    cstime* : timeT;
	 END;


   CONST

      (* flags for open *)

      oTRUNC*   = 0200H;    (* open with truncation *)
      oAPPEND*  = 0400H;    (* append, i.e writes at the end *)
      oRDWR*    =   02H;    (* open for reading and writing *)
      oWRONLY*  =   01H;    (* open for writing only *)
      oRDONLY*  =    0H;    (* open for reading only *)

      (* file access permisson flags (for create and umask) *)

      pXUSID*   = 0800H;    (* set user ID on execution *)
      pXGRID*   = 0400H;    (* set group ID on execution *)
      pSTEXT*   = 0200H;    (* save text image after execution *)
      pROWNER*  = 0100H;    (* read by owner *)
      pWOWNER*  =  080H;    (* write by owner *)
      pXOWNER*  =  040H;    (* execute by owner *)
      pRGROUP*  =  020H;    (* read by group *)
      pWGROUP*  =  010H;    (* write by group *)
      pXGROUP*  =   08H;    (* execute by group *)
      pROTHERS* =   04H;    (* read by others *)
      pWOTHERS* =   02H;    (* write by others *)
      pXOTHERS* =   01H;    (* execute by others *)
      pEMPTY*   =    0H;    (* no flag set *)
    
      (* file access check flags (for access) *)
 
      cREAD*    = 04H;       (* check if readable *)
      cWRITE*   = 02H;       (* check if writable *)
      cEXEC*    = 01H;       (* check if executable *)
      cEXISTS*  =  0H;       (* check existance *)
 

   PROCEDURE umask* (cmask : SIGNED) : SIGNED; END umask;

   PROCEDURE access* (path  : ADDRESS; amode : SIGNED) : SIGNED; END access;

   PROCEDURE creat* (path  : ADDRESS; cmode : SIGNED) : SIGNED; END creat;

   PROCEDURE open* (path : ADDRESS; oflag : SIGNED) : SIGNED; END open;

   PROCEDURE close* (fildes : SIGNED) : SIGNED; END close;

   PROCEDURE unlink* (path : ADDRESS) : SIGNED; END unlink;

   PROCEDURE read* (fildes : SIGNED; buf : ADDRESS; nbyte : UNSIGNED) : SIGNED; END read;

   PROCEDURE write* (fildes : SIGNED; buf : ADDRESS; nbyte : UNSIGNED) : SIGNED; END write;

   PROCEDURE sbrk* (incr : SIGNED): ADDRESS; END sbrk;

   PROCEDURE malloc* (size : UNSIGNED) : ADDRESS; END malloc;

   PROCEDURE free* (ptr : ADDRESS); END free;

   PROCEDURE stat* (path: ADDRESS; VAR buf: Stat) : SIGNED; END stat;

   PROCEDURE fstat* (fd: SIGNED  ; VAR buf: Stat) : SIGNED; END fstat;

   PROCEDURE time* (VAR t : INTEGER); END time;

   PROCEDURE times* (VAR buffer: tms); END times;

   PROCEDURE system* (string : ADDRESS) : SIGNED; END system;

   PROCEDURE exit* (n: SIGNED); END exit;

   PROCEDURE abort* (); END abort;

END SysLib.

