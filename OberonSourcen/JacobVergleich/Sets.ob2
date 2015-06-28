(* $Id: Sets.mi,v 1.4 1991/11/21 14:33:17 grosch rel $ *)

(* $Log: Sets.mi,v $
 * Revision 1.4  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.3  90/05/30  17:08:45  grosch
 * bug fixes in Complement and ReadSet
 * 
 * Revision 1.2  89/09/20  11:50:33  grosch
 * turned many FOR into WHILE loops to increase efficiency
 * 
 * Revision 1.1  89/01/09  17:13:35  grosch
 * added functions Size, Minimum, and Maximum
 * 
 * Revision 1.0  88/10/04  11:47:13  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE Sets;

IMPORT SYSTEM,General,DynArray,IO;

TYPE
   CARDINAL = LONGINT;

   ArrayOfBitset*	= ARRAY 10000000 OF SET;
   ProcOfCard*		= PROCEDURE (x:CARDINAL);
   ProcOfCardToBool*	= PROCEDURE (x:CARDINAL): BOOLEAN;

   tSet* = RECORD
      BitsetPtr*		: POINTER TO ArrayOfBitset;
      MaxElmt*		,
      LastBitset*	,
      Card*		,
      FirstElmt*	,
      LastElmt*		:INTEGER; 
   END;

CONST
   BitsPerBitset	= 32;
   BitsPerByte		= 8;
   BytesPerBitset	= BitsPerBitset DIV BitsPerByte;
   NoCard		= -1;

VAR
   AllBits		: SET;
VAR g	: IO.tFile;

PROCEDURE^AssignEmpty* (VAR Set: tSet);
PROCEDURE^IsElement* (Elmt: CARDINAL; VAR Set: tSet): BOOLEAN;
PROCEDURE^IsNotEqual* (Set1, Set2: tSet): BOOLEAN;

PROCEDURE MakeSet* (VAR Set: tSet; MaxSize: CARDINAL);
   VAR ElmtCount : LONGINT;
   BEGIN
	 ElmtCount := (MaxSize + BitsPerBitset - MaxSize MOD BitsPerBitset)
	    DIV BitsPerBitset;
	 DynArray.MakeArray (Set.BitsetPtr, ElmtCount, BytesPerBitset);
	 Set.MaxElmt := SHORT(MaxSize);
	 Set.LastBitset := SHORT(ElmtCount) - 1;
	 AssignEmpty (Set);
   END MakeSet;
      
PROCEDURE ReleaseSet* (VAR Set: tSet);
   VAR ElmtCount : LONGINT;
   BEGIN
      ElmtCount := Set.LastBitset + 1;
      DynArray.ReleaseArray (Set.BitsetPtr, ElmtCount, BytesPerBitset);
   END ReleaseSet;

PROCEDURE Union* (VAR Set1: tSet; Set2: tSet);
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    Set1.BitsetPtr^[i] := Set1.BitsetPtr^[i] + Set2.BitsetPtr^[i];
	    INC (i);
	 END;
	 Set1.Card      := NoCard;
	 Set1.FirstElmt := SHORT(General.Min (Set1.FirstElmt, Set2.FirstElmt));
	 Set1.LastElmt  := SHORT(General.Max (Set1.LastElmt, Set2.LastElmt));
   END Union;

PROCEDURE Difference* (VAR Set1: tSet; Set2: tSet);
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    Set1.BitsetPtr^[i] := Set1.BitsetPtr^[i] - Set2.BitsetPtr^[i];
	    INC (i);
	 END;
	 Set1.Card := NoCard;
   END Difference;

PROCEDURE Intersection* (VAR Set1: tSet; Set2: tSet);
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    Set1.BitsetPtr^[i] := Set1.BitsetPtr^[i] * Set2.BitsetPtr^[i];
	    INC (i);
	 END;
	 Set1.Card      := NoCard;
	 Set1.FirstElmt := SHORT(General.Max (Set1.FirstElmt, Set2.FirstElmt));
	 Set1.LastElmt  := SHORT(General.Min (Set1.LastElmt, Set2.LastElmt));
   END Intersection;

PROCEDURE SymDiff* (VAR Set1: tSet; Set2: tSet);
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    Set1.BitsetPtr^[i] := Set1.BitsetPtr^[i] / Set2.BitsetPtr^[i];
	    INC (i);
	 END;
	 Set1.Card      := NoCard;
	 Set1.FirstElmt := SHORT(General.Min (Set1.FirstElmt, Set2.FirstElmt));
	 Set1.LastElmt  := SHORT(General.Max (Set1.LastElmt, Set2.LastElmt));
   END SymDiff;

PROCEDURE Complement* (VAR Set: tSet);
   VAR i :LONGINT; 
       s : SET;
   BEGIN
	 i := 0;
	 WHILE i <= (Set.LastBitset) - 1 DO
	    Set.BitsetPtr^[i] := AllBits - Set.BitsetPtr^[i];
	    INC (i);
	 END;
      (* ifdef MOCKA
	 BitsetPtr^[LastBitset] := {0 .. MaxElmt MOD BitsPerBitset} - BitsetPtr^[LastBitset];
	 else *)
	 s := {};
	 FOR i := 0 TO (Set.MaxElmt) MOD BitsPerBitset DO
	    INCL (s, (i));
	 END;
	 Set.BitsetPtr^[Set.LastBitset] := s - Set.BitsetPtr^[Set.LastBitset];
      (* endif *)
	 IF Set.Card # NoCard THEN
	    Set.Card   := (Set.MaxElmt) + 1 - Set.Card;
	 END;
	 Set.FirstElmt := 0;
	 Set.LastElmt  := Set.MaxElmt;
   END Complement;

PROCEDURE Include* (VAR Set: tSet; Elmt: CARDINAL);
   BEGIN
	 INCL (Set.BitsetPtr^[Elmt DIV BitsPerBitset], Elmt MOD BitsPerBitset);
	 Set.Card      := NoCard;
      (* FirstElmt := Min (FirstElmt, Elmt);
	 LastElmt  := Max (LastElmt, Elmt); *)
	 IF Set.FirstElmt > Elmt THEN Set.FirstElmt := SHORT(Elmt); END;
	 IF Set.LastElmt  < Elmt THEN Set.LastElmt  := SHORT(Elmt); END;
   END Include;

PROCEDURE Exclude* (VAR Set: tSet; Elmt: CARDINAL);
   BEGIN
	 EXCL (Set.BitsetPtr^[Elmt DIV BitsPerBitset], Elmt MOD BitsPerBitset);
	 Set.Card      := NoCard;
	 IF (Elmt = Set.FirstElmt) & (Elmt < Set.MaxElmt) THEN
	    INC (Set.FirstElmt);
	 END;
	 IF (Elmt = Set.LastElmt) & (Elmt > 0) THEN
	    DEC (Set.LastElmt);
	 END;
   END Exclude;

PROCEDURE Card* (VAR Set: tSet): CARDINAL;
   VAR i : CARDINAL;
   BEGIN
	 IF Set.Card = NoCard THEN
	    Set.Card := 0;
	    FOR i := Set.FirstElmt TO Set.LastElmt DO
	       IF IsElement (i, Set) THEN INC (Set.Card); END;
	    END;
	 END;
	 RETURN Set.Card;
   END Card;
    
PROCEDURE Size* (VAR Set: tSet): CARDINAL;
   BEGIN
      RETURN Set.MaxElmt;
   END Size;

PROCEDURE Minimum* (VAR Set: tSet): CARDINAL;
   VAR i : CARDINAL;
   BEGIN
	 i := Set.FirstElmt;
	 WHILE i <= Set.LastElmt DO
	    IF IsElement (i, Set) THEN
	       Set.FirstElmt := SHORT(i);
	       RETURN i;
	    END;
	    INC (i);
	 END;
	 RETURN 0;
   END Minimum;

PROCEDURE Maximum* (VAR Set: tSet): CARDINAL;
   VAR i : CARDINAL;
   BEGIN
	 i := Set.LastElmt;
	 WHILE i >= Set.FirstElmt DO
	    IF IsElement (i, Set) THEN
	       Set.LastElmt := SHORT(i);
	       RETURN i;
	    END;
	    DEC (i);
	 END;
	 RETURN 0;
   END Maximum;

PROCEDURE Select* (VAR Set: tSet): CARDINAL;
   BEGIN
      RETURN Minimum (Set);
   END Select;
    
PROCEDURE Extract* (VAR Set: tSet): CARDINAL;
   VAR i : CARDINAL;
   BEGIN
      i := Minimum (Set);
      Exclude (Set, i);
      RETURN i;
   END Extract;

PROCEDURE IsSubset* (Set1, Set2: tSet): BOOLEAN;
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    IF ~(Set2.BitsetPtr^[i] - Set1.BitsetPtr^[i] # {}) THEN RETURN FALSE; END;
	    INC (i);
	 END;
	 RETURN TRUE;
   END IsSubset;

PROCEDURE IsStrictSubset* (Set1, Set2: tSet): BOOLEAN;
   BEGIN
      RETURN IsSubset (Set1, Set2) & IsNotEqual (Set1, Set2);
   END IsStrictSubset;
    
PROCEDURE IsEqual* (VAR Set1, Set2: tSet): BOOLEAN;
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    IF Set1.BitsetPtr^[i] # Set2.BitsetPtr^[i] THEN RETURN FALSE; END;
	    INC (i);
	 END;
	 RETURN TRUE;
   END IsEqual;
    
PROCEDURE IsNotEqual* (Set1, Set2: tSet): BOOLEAN;
   BEGIN
      RETURN ~IsEqual (Set1, Set2);
   END IsNotEqual;

PROCEDURE IsElement* (Elmt: CARDINAL; VAR Set: tSet): BOOLEAN;
   BEGIN
      RETURN Elmt MOD BitsPerBitset IN Set.BitsetPtr^[Elmt DIV BitsPerBitset];
   END IsElement;

PROCEDURE IsEmpty* (Set: tSet): BOOLEAN;
   VAR i : CARDINAL;
   BEGIN
	 IF Set.FirstElmt <= Set.LastElmt THEN
	    i := 0;
	    WHILE i <= Set.LastBitset DO
	       IF Set.BitsetPtr^[i] # {} THEN RETURN FALSE; END;
	       INC (i);
	    END;
	 END;
	 RETURN TRUE;
   END IsEmpty;
    
PROCEDURE Forall* (Set: tSet; Proc: ProcOfCardToBool): BOOLEAN;
   VAR i : CARDINAL;
   BEGIN
	 FOR i := Set.FirstElmt TO Set.LastElmt DO
	    IF IsElement (i, Set) & ~Proc (i) THEN RETURN FALSE; END;
	 END;
	 RETURN TRUE;
   END Forall;
    
PROCEDURE Exists* (Set: tSet; Proc: ProcOfCardToBool): BOOLEAN;
   VAR i : CARDINAL;
   BEGIN
	 FOR i := Set.FirstElmt TO Set.LastElmt DO
	    IF IsElement (i, Set) & Proc (i) THEN RETURN TRUE; END;
	 END;
	 RETURN FALSE;
   END Exists;
    
PROCEDURE Exists1* (Set: tSet; Proc: ProcOfCardToBool): BOOLEAN;
   VAR i, n : CARDINAL;
   BEGIN
	 n := 0;
	 FOR i := Set.FirstElmt TO Set.LastElmt DO
	    IF IsElement (i, Set) & Proc (i) THEN INC (n); END;
	 END;
	 RETURN n = 1;
   END Exists1;

PROCEDURE Assign* (VAR Set1: tSet; Set2: tSet);
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set1.LastBitset DO
	    Set1.BitsetPtr^[i] := Set2.BitsetPtr^[i];
	    INC (i);
	 END;
	 Set1.Card      := Set2.Card;
	 Set1.FirstElmt := Set2.FirstElmt;
	 Set1.LastElmt  := Set2.LastElmt;
   END Assign;

PROCEDURE AssignElmt* (VAR Set: tSet; Elmt: CARDINAL);
   BEGIN
	 AssignEmpty (Set);
	 Include (Set, Elmt);
	 Set.Card      := 1;
	 Set.FirstElmt := SHORT(Elmt);
	 Set.LastElmt  := SHORT(Elmt);
   END AssignElmt;

PROCEDURE AssignEmpty* (VAR Set: tSet);
   VAR i : CARDINAL;
   BEGIN
	 i := 0;
	 WHILE i <= Set.LastBitset DO
	    Set.BitsetPtr^[i] := {};
	    INC (i);
	 END;
	 Set.Card      := 0;
	 Set.FirstElmt := Set.MaxElmt;
	 Set.LastElmt  := 0;
   END AssignEmpty;

PROCEDURE ForallDo* (Set: tSet; Proc: ProcOfCard);
   VAR i : CARDINAL;
   BEGIN
	 FOR i := Set.FirstElmt TO Set.LastElmt DO
	    IF IsElement (i, Set) THEN Proc (i); END;
	 END;
   END ForallDo;

PROCEDURE ReadSet* (f: IO.tFile; VAR Set: tSet);
   VAR card	: CARDINAL;
   BEGIN
      REPEAT UNTIL IO.ReadC (f) = '{';
      AssignEmpty (Set);
      card := 0;
      LOOP
	 IF IO.ReadC (f) = '}' THEN EXIT; END;
	 Include (Set, IO.ReadI (f));
	 INC (card);
      END;
      Set.Card := SHORT(card);
   END ReadSet;


PROCEDURE^WriteElmt(Elmt: CARDINAL);

PROCEDURE WriteSet* (f: IO.tFile; Set: tSet);
   BEGIN
      (* WriteS (f, "MaxElmt = "	) ; WriteI (f, MaxElmt	 , 0);
	 WriteS (f, " LastBitset = "	) ; WriteI (f, LastBitset, 0);
	 WriteS (f, " Card = "		) ; WriteI (f, Card	 , 0);
	 WriteS (f, " FirstElmt = "	) ; WriteI (f, FirstElmt , 0);
	 WriteS (f, " LastElmt = "	) ; WriteI (f, LastElmt	 , 0);
	 WriteNl (f);
      *)
	 g := f;
	 IO.WriteC (f, '{');
	 ForallDo (Set, WriteElmt);
	 IO.WriteC (f, '}');
   END WriteSet;

PROCEDURE WriteElmt (Elmt: CARDINAL);
   BEGIN
      IO.WriteC (g, ' ');
      IO.WriteI (g, Elmt, 0);
   END WriteElmt;

BEGIN
   AllBits := { 0 .. BitsPerBitset - 1 };
   IF SIZE (SET) # BytesPerBitset THEN
      IO.WriteS (IO.StdError, "SIZE (SET) = ");
      IO.WriteI (IO.StdError, SIZE (SET), 0);
      IO.WriteNl (IO.StdError);
   END;
END Sets.

