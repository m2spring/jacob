(* $Id: StdIO.mi,v 1.3 1991/11/21 14:33:17 grosch rel $ *)

(* $Log: StdIO.mi,v $
 * Revision 1.3  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.2  89/07/14  16:27:23  grosch
 * made WriteN work for numbers with MSBit set
 * 
 * Revision 1.1  89/01/24  19:04:43  grosch
 * added procedure UnRead
 * 
 * Revision 1.0  88/10/04  11:47:16  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE StdIO;			(* buffered standard IO	*)

IMPORT SYSTEM,IO;

TYPE ADDRESS = LONGINT;
     CARDINAL = LONGINT;
     LONGCARD = LONGINT;

PROCEDURE ReadClose*	;			(* close input file	*)
   BEGIN
      IO.ReadClose (IO.StdInput);
   END ReadClose;

PROCEDURE Read*		(Buffer: ADDRESS; Size: CARDINAL): LONGINT;
   BEGIN					(* binary		*)
      RETURN IO.Read (IO.StdInput, Buffer, Size);
   END Read;

PROCEDURE ReadC*		(): CHAR    ;		(* character		*)
   BEGIN
      RETURN IO.ReadC (IO.StdInput);
   END ReadC;

PROCEDURE ReadI*		(): LONGINT ;		(* integer  number	*)
   BEGIN
      RETURN IO.ReadI (IO.StdInput);
   END ReadI;

PROCEDURE ReadR*		(): REAL    ;		(* real     number	*)
   BEGIN
      RETURN IO.ReadR (IO.StdInput);
   END ReadR;

PROCEDURE ReadB*		(): BOOLEAN ;		(* boolean		*)
   BEGIN
      RETURN IO.ReadB (IO.StdInput);
   END ReadB;

PROCEDURE ReadN*		(Base: LONGINT): LONGINT;
   BEGIN					(* number of base 'Base'*)
      RETURN IO.ReadN (IO.StdInput, Base);
   END ReadN;

PROCEDURE ReadS*		(VAR s: ARRAY OF CHAR);	(* string		*)
   BEGIN
      IO.ReadS (IO.StdInput, s);
   END ReadS;

PROCEDURE ReadShort*	(): SHORTINT;		(* shortint number ?	*)
   BEGIN
      RETURN SHORT(SHORT(IO.ReadShort (IO.StdInput)));
   END ReadShort;

PROCEDURE ReadLong*	(): LONGINT ;		(* longint  number ?	*)
   BEGIN
      RETURN IO.ReadLong (IO.StdInput);
   END ReadLong;

PROCEDURE ReadCard*	(): CARDINAL;		(* cardinal number ?	*)
   BEGIN
      RETURN IO.ReadCard (IO.StdInput);
   END ReadCard;

PROCEDURE ReadNl*	;			(* new line		*)
   BEGIN
      IO.ReadNl (IO.StdInput);
   END ReadNl;

PROCEDURE UnRead*	;			(* backspace 1 char.	*)
   BEGIN
      IO.UnRead (IO.StdInput);
   END UnRead;


PROCEDURE EndOfLine*	(): BOOLEAN ;		(* end of line ?	*)
   BEGIN
      RETURN IO.EndOfLine (IO.StdInput);
   END EndOfLine;

PROCEDURE EndOfFile*	(): BOOLEAN ;		(* end of file ?	*)
   BEGIN
      RETURN IO.EndOfFile (IO.StdInput);
   END EndOfFile;



PROCEDURE WriteClose*	;			(* close output file	*)
   BEGIN
      IO.WriteClose (IO.StdOutput);
   END WriteClose;

PROCEDURE WriteFlush*	;			(* flush output buffer	*)
   BEGIN
      IO.WriteFlush (IO.StdOutput);
   END WriteFlush;

PROCEDURE Write*		(Buffer: ADDRESS; Size: CARDINAL): LONGINT;
   BEGIN					(* binary		*)
      RETURN IO.Write (IO.StdOutput, Buffer, Size);
   END Write;

PROCEDURE WriteC*	(c: CHAR);		(* character		*)
   BEGIN
      IO.WriteC (IO.StdOutput, c);
   END WriteC;

PROCEDURE WriteI*	(n: LONGINT ; FieldWidth: CARDINAL);
   BEGIN					(* integer  number	*)
      IO.WriteI (IO.StdOutput, n, FieldWidth);
   END WriteI;

PROCEDURE WriteR*	(n: REAL; Before, After, Exp: CARDINAL);
   BEGIN					(* real     number	*)
      IO.WriteR (IO.StdOutput, n, Before, After, Exp);
   END WriteR;

PROCEDURE WriteB*	(b: BOOLEAN);		(* boolean		*)
   BEGIN
      IO.WriteB (IO.StdOutput, b);
   END WriteB;

PROCEDURE WriteN*	(n: LONGCARD; FieldWidth, Base: CARDINAL);
   BEGIN					(* number of base 'Base'*)
      IO.WriteN (IO.StdOutput, n, FieldWidth, Base);
   END WriteN;

PROCEDURE WriteS*	(s: ARRAY OF CHAR);	(* string		*)
   BEGIN
      IO.WriteS (IO.StdOutput, s);
   END WriteS;

PROCEDURE WriteShort*	(n: SHORTINT; FieldWidth: CARDINAL);
   BEGIN					(* shortint number ?	*)
      IO.WriteShort (IO.StdOutput, n, FieldWidth);
   END WriteShort;

PROCEDURE WriteLong*	(n: LONGINT ; FieldWidth: CARDINAL);
   BEGIN					(* longint  number ?	*)
      IO.WriteLong (IO.StdOutput, n, FieldWidth);
   END WriteLong;

PROCEDURE WriteCard*	(n: CARDINAL; FieldWidth: CARDINAL);
   BEGIN					(* cardinal number ?	*)
      IO.WriteCard (IO.StdOutput, n, FieldWidth);
   END WriteCard;

PROCEDURE WriteNl*	;			(* new line		*)
   BEGIN
      IO.WriteNl (IO.StdOutput);
   END WriteNl;


PROCEDURE CloseIO*;				(* close all files	*)
   BEGIN
      IO.WriteFlush (IO.StdOutput);
   END CloseIO;

END StdIO.

