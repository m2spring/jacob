(* $Id: Idents.mi,v 1.8 1992/06/22 14:23:18 grosch rel $ *)

(* $Log: Idents.mi,v $
 * Revision 1.8  1992/06/22  14:23:18  grosch
 * cosmetic changes
 *
 * Revision 1.7  1992/03/24  13:50:12  grosch
 * decreased array type size from 100000000 to 1000000 because of C compiler restrictions
 *
 * Revision 1.6  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.5  91/06/07  12:19:54  grosch
 * decreased bounds of flexible arrays
 * 
 * Revision 1.4  91/06/07  11:37:45  grosch
 * increased bounds of flexible arrays
 * 
 * Revision 1.3  89/06/01  18:21:16  grosch
 * added predefined identifier NoIdent
 * 
 * Revision 1.2  89/01/25  12:05:42  grosch
 * added function MaxIdent
 * 
 * Revision 1.1  89/01/21  23:03:34  grosch
 * added file parameter to procedure WriteIdent
 * 
 * Revision 1.0  88/10/04  11:47:01  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE Idents;

IMPORT SYSTEM,DynArray,Strings,StringMem,IO;

TYPE CARDINAL = LONGINT;
TYPE	  tIdent*	= INTEGER;

VAR IdentCASEFAULT*,
    IdentWITHFAULT*,
    IdentPREDECL*,
    IdentSYSTEM*,
    NoIdent-	: tIdent;
			(* A default identifer (empty string).		*)

CONST
   cNoIdent		= 0;
   InitialTableSize	= 512;
   HashTableSize	= 256;

TYPE
   IdentTableEntry	=
      RECORD 
	 String		: StringMem.tStringRef;
	 Length		: Strings.tStringIndex;
	 Collision	: tIdent;
      END;

   HashIndex		= LONGINT; 

VAR
   TablePtr		: POINTER TO ARRAY 1000000 OF IdentTableEntry;
   IdentTableSize	: LONGINT;
   IdentCount		: tIdent;

   HashTable		: ARRAY HashTableSize+1 OF tIdent; 
   i			: HashIndex;

PROCEDURE MakeIdent* (VAR s: Strings.tString): tIdent;
   VAR
      HashTableIndex	: HashIndex;
      CurIdent		: tIdent;
      lIdentCount	: LONGINT;
   BEGIN
  	 IF s.Length = 0 THEN
	    HashTableIndex := 0;
	 ELSE 
	    HashTableIndex := (ORD (s.Chars [1]) + ORD (s.Chars [s.Length]) * 11
				 + s.Length * 26) MOD HashTableSize;
	 END;

      CurIdent := HashTable [HashTableIndex];	(* search *)
      LOOP
	 IF CurIdent = cNoIdent THEN EXIT; END;
	    IF (TablePtr^[CurIdent].Length = s.Length) & StringMem.IsEqual (TablePtr^[CurIdent].String, s) THEN
	       RETURN CurIdent;			(* found *)
	    END;  
	    CurIdent := TablePtr^[CurIdent].Collision;
      END;

      INC (IdentCount);				(* not found: enter *)
      lIdentCount := IdentCount;		(* damned MODULA *)
      IF lIdentCount = IdentTableSize THEN
	 DynArray.ExtendArray (TablePtr, IdentTableSize, SIZE (IdentTableEntry));
      END;
	 TablePtr^[IdentCount].String		:= StringMem.PutString (s);
	 TablePtr^[IdentCount].Length		:= s.Length;
	 TablePtr^[IdentCount].Collision	:= HashTable [HashTableIndex];
      HashTable [HashTableIndex] := IdentCount;
      RETURN IdentCount;
   END MakeIdent;

PROCEDURE GetString* (i: tIdent; VAR s: Strings.tString);
   BEGIN
	 StringMem.GetString (TablePtr^[i].String, s);
   END GetString;

PROCEDURE GetStringRef* (i: tIdent): StringMem.tStringRef;
   BEGIN
      RETURN TablePtr^[i].String;
   END GetStringRef;

PROCEDURE MaxIdent* (): tIdent;
   BEGIN
      RETURN IdentCount;
   END MaxIdent;

PROCEDURE WriteIdent* (f: IO.tFile; i: tIdent);
   VAR s	: Strings.tString;
   BEGIN
      GetString (i, s);
      Strings.WriteS (f, s);
   END WriteIdent;

PROCEDURE WriteIdents*;
   VAR i	: CARDINAL;
   BEGIN
      FOR i := 1 TO IdentCount DO
	 IO.WriteI (IO.StdOutput, i, 5);
	 IO.WriteC (IO.StdOutput, ' ');
	 WriteIdent (IO.StdOutput, SHORT(i));
	 IO.WriteNl (IO.StdOutput);
      END;
   END WriteIdents;

PROCEDURE WriteHashTable*;
   VAR
      CurIdent	: tIdent;
      i		: HashIndex;
      Count	: CARDINAL;
   BEGIN
      FOR i := 0 TO HashTableSize DO
	 IO.WriteI (IO.StdOutput, i, 5);

	 Count := 0;
	 CurIdent := HashTable [i];
	 WHILE CurIdent # cNoIdent DO
	    INC (Count);
	    CurIdent := TablePtr^[CurIdent].Collision;
	 END;
	 IO.WriteI (IO.StdOutput, Count, 5);

	 CurIdent := HashTable [i];
	 WHILE CurIdent # cNoIdent DO
	    IO.WriteC (IO.StdOutput, ' ');
	    WriteIdent (IO.StdOutput, CurIdent);
	    CurIdent := TablePtr^[CurIdent].Collision;
	 END;
	 IO.WriteNl (IO.StdOutput);
      END;

      IO.WriteNl (IO.StdOutput);
      IO.WriteS (IO.StdOutput, "Idents =");
      IO.WriteI (IO.StdOutput, IdentCount, 5);
      IO.WriteNl (IO.StdOutput);
   END WriteHashTable;
    
PROCEDURE InitIdents*;
   VAR String	: Strings.tString;
   BEGIN
      FOR i := 0 TO HashTableSize DO
	 HashTable [i] := cNoIdent;
      END;
      IdentCount := 0;
      Strings.AssignEmpty (String);
      NoIdent := MakeIdent (String);
   END InitIdents;

BEGIN
   IdentTableSize := InitialTableSize;
   DynArray.MakeArray (TablePtr, IdentTableSize, SIZE (IdentTableEntry));
   InitIdents;
END Idents.

