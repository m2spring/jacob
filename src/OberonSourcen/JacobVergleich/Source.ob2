(* $Id: Source.mi,v 1.5 1992/08/07 15:29:41 grosch rel $ *)

MODULE Source;

IMPORT SYSTEM,System;

PROCEDURE BeginSource* (FileName: ARRAY OF CHAR): System.tFile;
   BEGIN
      RETURN System.OpenInput (FileName);
   END BeginSource;

PROCEDURE GetLine* (File: System.tFile; Buffer: SYSTEM.PTR; Size:LONGINT):LONGINT; 
   CONST IgnoreChar = ' ';
   VAR n	:LONGINT; 
   VAR BufferPtr: POINTER TO ARRAY 30000 OF CHAR;
   BEGIN
   (* # ifdef Dialog
      n := Read (File, Buffer, Size);
      (* Add dummy after newline character in order to supply a lookahead for rex. *)
      (* This way newline tokens are recognized without typing an extra line.      *)
      BufferPtr := Buffer;
      IF (n > 0) & (BufferPtr^[n - 1] = 012C) THEN BufferPtr^[n] := IgnoreChar; INC (n); END;
      RETURN n;
      # else *)
      RETURN System.Read (File, SYSTEM.VAL(LONGINT,Buffer), Size);
   (* # endif *)
   END GetLine;

PROCEDURE CloseSource* (File: System.tFile);
   BEGIN
      System.Close (File);
   END CloseSource;

END Source.

