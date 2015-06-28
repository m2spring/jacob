(* $Id: Checks.mi,v 1.2 1992/01/30 13:23:29 grosch rel $ *)

(* $Log: Checks.mi,v $
 * Revision 1.2  1992/01/30  13:23:29  grosch
 * redesign of interface to operating system
 *
 * Revision 1.1  1991/11/21  14:33:17  grosch
 * new version of RCS on SPARC
 *
 * Revision 1.0  88/10/04  11:46:50  grosch
 * Initial revision
 * 
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Sept. 1987 *)

MODULE Checks;
IMPORT IO,System;

PROCEDURE ErrorCheck* (s: ARRAY OF CHAR; n:LONGINT);
   BEGIN
      IF n < 0 THEN
	 IO.WriteS (IO.StdError, s);
	 IO.WriteS (IO.StdError, " : ");
	 IO.WriteI (IO.StdError, n, 2);
	 IO.WriteS (IO.StdError, ", errno = ");
	 IO.WriteI (IO.StdError, System.ErrNum (), 2);
	 IO.WriteNl (IO.StdError);
      END;
   END ErrorCheck;

END Checks.
