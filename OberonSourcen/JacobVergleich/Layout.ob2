(* $Id: Layout.mi,v 1.2 1991/11/21 14:33:17 grosch rel $ *)

(* $Log: Layout.mi,v $
 * Revision 1.2  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.1  89/01/24  19:04:59  grosch
 * added procedure SkipSpaces
 * 
 * Revision 1.0  88/10/04  11:47:03  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE Layout;

IMPORT IO;

PROCEDURE WriteChar* (f: IO.tFile; Ch: CHAR);
   BEGIN
      IF ('!' <= Ch) & (Ch <= '~') THEN
	 IO.WriteC (f, "'");
	 IO.WriteC (f, Ch);
	 IO.WriteC (f, "'");
      ELSIF Ch = 0X THEN
	 IO.WriteS (f, "eps");
      ELSE
	 IO.WriteI (f, ORD (Ch), 2);
	 IO.WriteC (f, 'C');
      END;
   END WriteChar;

PROCEDURE WriteSpace* (f: IO.tFile);
   BEGIN
      IO.WriteC (f, ' ');
   END WriteSpace;

PROCEDURE WriteSpaces* (f: IO.tFile; Count:LONGINT);
   VAR i	:LONGINT; 
   BEGIN
      FOR i := 1 TO Count DO
	 IO.WriteC (f, ' ');
      END;
   END WriteSpaces;

PROCEDURE ReadSpace* (f: IO.tFile);
   VAR Ch	: CHAR;
   BEGIN
      Ch := IO.ReadC (f);
   END ReadSpace;

PROCEDURE ReadSpaces* (f: IO.tFile; Count:LONGINT);
   VAR i	:LONGINT; 
   VAR Ch	: CHAR;
   BEGIN
      FOR i := 1 TO Count DO
	 Ch := IO.ReadC (f);
      END;
   END ReadSpaces;

PROCEDURE SkipSpaces* (f: IO.tFile);
   BEGIN
      REPEAT UNTIL IO.ReadC (f) # ' ';
      IO.UnRead (f);
   END SkipSpaces;

END Layout.

