(* $Id: DynArray.mi,v 1.6 1992/08/07 14:45:20 grosch rel $ *)

(* $Log: DynArray.mi,v $
 * Revision 1.6  1992/08/07  14:45:20  grosch
 * added error message if out of memory
 *
 * Revision 1.5  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.4  90/03/02  17:36:10  grosch
 * automized handling of machine independent alignment
 * 
 * Revision 1.3  90/02/28  22:07:00  grosch
 * comment for alignment on SPARC
 * 
 * Revision 1.2  89/12/08  20:12:44  grosch
 * introduced a machine dependent variant for MIPS
 * 
 * Revision 1.1  88/10/18  16:30:08  grosch
 * fixed bug: invariant must hold: ElmtCount * ElmtSize MOD 4 = 0
 * 
 * Revision 1.0  88/10/04  11:46:52  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE DynArray;

IMPORT SYSTEM,General,Memory,IO;

TYPE ADDRESS = SYSTEM.PTR;
     tLongintP = POINTER TO RECORD
                             v:LONGINT; 
                            END;

(* INVARIANT ElmtCount * AlignedSize (ElmtSize) MOD TSIZE (LONGINT) = 0 *)

PROCEDURE^AlignedSize  (ElmtSize: LONGINT): LONGINT;

PROCEDURE MakeArray*   (ArrayPtr	: ADDRESS	;
			VAR ElmtCount	: LONGINT	;
			    ElmtSize	: LONGINT)	;
   BEGIN
      ElmtSize := AlignedSize (ElmtSize);
      CASE ElmtSize MOD 4 OF
      | 0   :
      | 2   : IF ODD (ElmtCount) THEN INC (ElmtCount); END;
      | 1, 3: INC (ElmtCount, SIZE (LONGINT) - 1 - (ElmtCount - 1) MOD SIZE (LONGINT));
      END;
      ArrayPtr := SYSTEM.VAL(ADDRESS,Memory.Alloc (ElmtCount * ElmtSize));
      IF SYSTEM.VAL(LONGINT,ArrayPtr) = 0 THEN
	 IO.WriteS (IO.StdError, "MakeArray: out of memory"); IO.WriteNl (IO.StdError);
      END;
   END MakeArray;

PROCEDURE ExtendArray* (ArrayPtr	: ADDRESS	;
			VAR ElmtCount	: LONGINT	;
			    ElmtSize	: LONGINT)	;
   VAR
      NewPtr		: ADDRESS;
      Source, Target	: tLongintP;
      i			: LONGINT;
   BEGIN
      ElmtSize := AlignedSize (ElmtSize);
      NewPtr := SYSTEM.VAL(ADDRESS,Memory.Alloc (ElmtCount * ElmtSize * 2));
      IF SYSTEM.VAL(LONGINT,NewPtr) = 0 THEN
	 IO.WriteS (IO.StdError, "ExtendArray: out of memory"); IO.WriteNl (IO.StdError);
      ELSE
	 Source := SYSTEM.VAL(tLongintP,ArrayPtr);
	 Target := SYSTEM.VAL(tLongintP,NewPtr);
	 FOR i := 1 TO ElmtCount * ElmtSize DIV SIZE (LONGINT) DO
	    Target ^ := Source ^;
	    Source := SYSTEM.VAL(tLongintP,SYSTEM.VAL(LONGINT,Source) + SIZE (LONGINT));
	    Target := SYSTEM.VAL(tLongintP,SYSTEM.VAL(LONGINT,Target) + SIZE (LONGINT));
	 END;
	 Memory.Free (ElmtCount * ElmtSize, SYSTEM.VAL(LONGINT,ArrayPtr));
	 INC (ElmtCount, ElmtCount);
      END;
      ArrayPtr := NewPtr;
   END ExtendArray;

PROCEDURE ReleaseArray*(ArrayPtr	: ADDRESS	;
			VAR ElmtCount	: LONGINT	;
			    ElmtSize	: LONGINT)	;
   BEGIN
      ElmtSize := AlignedSize (ElmtSize);
      Memory.Free (ElmtCount * ElmtSize, SYSTEM.VAL(LONGINT,ArrayPtr));
   END ReleaseArray;

PROCEDURE AlignedSize  (ElmtSize: LONGINT): LONGINT;
   VAR Align	: LONGINT;
   BEGIN
      IF ElmtSize >= General.MaxAlign THEN
	 Align := General.MaxAlign;
      ELSE
	 Align := General.Exp2 (General.Log2 (ElmtSize + ElmtSize - 2));
      END;
      RETURN ElmtSize + Align - 1 - (ElmtSize - 1) MOD Align;
   END AlignedSize;

END DynArray.

