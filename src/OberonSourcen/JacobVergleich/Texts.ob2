(* $Id: Texts.mi,v 1.2 1992/08/07 14:43:04 grosch rel $ *)

(* $Log: Texts.mi,v $
 * Revision 1.2  1992/08/07  14:43:04  grosch
 * added procedure IsEmpty
 *
 * Revision 1.1  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.0  88/10/04  11:47:37  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, 31.8.1988 *)

MODULE Texts;

IMPORT SYSTEM,IO,Lists,Strings,StringMem;

TYPE tText*	= Lists.tList;

PROCEDURE MakeText* (VAR Text: tText);
   BEGIN
      Lists.MakeList (Text);
   END MakeText;

PROCEDURE Append* (VAR Text: tText; VAR String: Strings.tString);
   BEGIN
      Lists.Append (Text, SYSTEM.VAL(SYSTEM.PTR,StringMem.PutString (String)));
   END Append;

PROCEDURE Insert* (VAR Text: tText; VAR String: Strings.tString);
   BEGIN
      Lists.Insert (Text, SYSTEM.VAL(SYSTEM.PTR,StringMem.PutString (String)));
   END Insert;

PROCEDURE IsEmpty* (VAR Text: tText): BOOLEAN;
   BEGIN
      RETURN Lists.IsEmpty (Text);
   END IsEmpty;

PROCEDURE WriteText* (f: IO.tFile; Text: tText);
   VAR String	: Strings.tString;
   BEGIN
      WHILE ~Lists.IsEmpty (Text) DO
	 StringMem.GetString (SYSTEM.VAL(StringMem.tStringRef,Lists.Head (Text)), String);
	 Strings.WriteL (f, String);
	 Lists.Tail (Text);
      END;
   END WriteText;

END Texts.

