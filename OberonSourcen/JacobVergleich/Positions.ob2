(* $Id: Positions.mi,v 1.1 1992/08/13 13:47:25 grosch rel $ *)

(* $Log: Positions.mi,v $
# Revision 1.1  1992/08/13  13:47:25  grosch
# increase format in WritePosition
#
# Revision 1.0  1992/08/07  14:42:00  grosch
# Initial revision
#
 *)

(* Ich, Doktor Josef Grosch, Informatiker, Juli 1992 *)

MODULE Positions;

IMPORT IO;

TYPE	  tPosition*	= RECORD Line*, Column*:INTEGER; END;

VAR	  NoPosition-	: tPosition;
			(* A default position (0, 0).			*)


PROCEDURE Compare* (Position1, Position2: tPosition):LONGINT; 
   BEGIN
	 IF Position1.Line   < Position2.Line   THEN RETURN -1; END;
	 IF Position1.Line   > Position2.Line   THEN RETURN  1; END;
	 IF Position1.Column < Position2.Column THEN RETURN -1; END;
	 IF Position1.Column > Position2.Column THEN RETURN  1; END;
	 RETURN 0;
   END Compare;

PROCEDURE WritePosition* (File: IO.tFile; Position: tPosition);
   BEGIN
      IO.WriteI (File, Position.Line  , 4);
      IO.WriteC (File, ',');
      IO.WriteI (File, Position.Column, 3);
   END WritePosition;

BEGIN
   NoPosition.Line	:= 0;
   NoPosition.Column	:= 0;
END Positions.

