(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

MODULE ByteIO;
IMPORT SYSTEM,SysLib,BasicIO,Storage;
TYPE File* = BasicIO.File;

  TYPE ADDRESS = SYSTEM.PTR;
       CARDINAL = LONGINT;

  CONST
    MAXFILE  = 50;
    BUFFSIZE = 1024;

  VAR
    ENDOFFILE		: ARRAY MAXFILE+1 OF BOOLEAN;
    ISOUTPUT            : ARRAY MAXFILE+1 OF BOOLEAN;
    BFIRST, BPOS, BLAST : ARRAY MAXFILE+1 OF ADDRESS;

    (* For Input:                 *)
    (* BFIRST .... BPOS ... BLAST *)
    (* [processed] [unprocessed ] *)

    (* For Output:                *)
    (* BFIRST  ... BPOS ... BLAST *)
    (* [filled   ] [free        ] *)

  PROCEDURE^EmitBuffer* (file : File);
  PROCEDURE^FillBuffer* (file : File);
  PROCEDURE^PutBf*(file: File);
  
  (*=== Open/Close ===*)

  PROCEDURE OpenInput* (VAR file : File; VAR name : ARRAY OF CHAR);
  BEGIN
     BasicIO.OpenInput (file, name);
     IF file < 0 THEN
	BasicIO.DONE := FALSE;
     ELSE
	Storage.ALLOCATE (BFIRST[file], BUFFSIZE);
	BPOS[file]  := SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BFIRST[file])+1);
	BLAST[file] := BFIRST[file];
	ISOUTPUT[file] := FALSE;
	BasicIO.DONE := TRUE;
     END;
  END OpenInput;

  PROCEDURE OpenOutput* (VAR file : File; VAR name : ARRAY OF CHAR);
  BEGIN
     BasicIO.OpenOutput (file, name);
     IF file < 0 THEN
	BasicIO.DONE := FALSE;
     ELSE
	Storage.ALLOCATE (BFIRST[file], BUFFSIZE);
	BPOS[file] := BFIRST[file];
	BLAST[file] := SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BFIRST[file]) + BUFFSIZE - 1);
	ISOUTPUT[file] := TRUE;
	BasicIO.DONE := TRUE;
     END;
  END OpenOutput;

  PROCEDURE Close* (file: File);
  BEGIN
     IF ISOUTPUT[file] THEN PutBf(file) END;
     BasicIO.Close (file);
     BasicIO.DONE := TRUE; (*;;*)
     (* ++ jv ++ *)
     Storage.DEALLOCATE (BFIRST[file], BUFFSIZE);
     (* -- jv -- *)
  END Close;


  (*=== Byte IO ===*)

  PROCEDURE GetByte* (file : File; VAR x : SYSTEM.BYTE);
  BEGIN
     IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	FillBuffer(file);
	IF ~BasicIO.DONE THEN RETURN END;
     END;
     SYSTEM.GET(SYSTEM.VAL(LONGINT,BPOS[file]),x);
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])+1); 
     BasicIO.DONE := TRUE;
  END GetByte;

PROCEDURE UndoGetByte* (file: File);
BEGIN
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])-1); 
  BasicIO.DONE := TRUE;
END UndoGetByte;

  PROCEDURE GetBytes* (file : File; VAR x : ARRAY OF SYSTEM.BYTE; len : CARDINAL);
     VAR i: CARDINAL;
  BEGIN
     i := 0;
     WHILE i # len DO
        IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	   FillBuffer(file);
	   IF ~BasicIO.DONE THEN RETURN END;
	END;
        SYSTEM.GET(SYSTEM.VAL(LONGINT,BPOS[file]),x[i]);
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])+1); 
	INC(i);
     END;
     BasicIO.DONE := TRUE;
  END GetBytes;

  PROCEDURE GetItem* (file : File; VAR x : ARRAY OF SYSTEM.BYTE);
     VAR i, len: CARDINAL; n: INTEGER;
  BEGIN
     i := 0;
     len := LEN(x);
     WHILE i # len DO
        IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	   FillBuffer(file);
	   IF ~BasicIO.DONE THEN RETURN END;
	END;
        SYSTEM.GET(SYSTEM.VAL(LONGINT,BPOS[file]),x[i]);
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])+1); 
	INC(i);
     END;
     BasicIO.DONE := TRUE;
  END GetItem;

  PROCEDURE PutByte* (file : File; x : SYSTEM.BYTE);
  BEGIN
     IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	EmitBuffer(file);
	IF ~BasicIO.DONE THEN RETURN END;
     END;
     SYSTEM.PUT(SYSTEM.VAL(LONGINT,BPOS[file]),x);
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])+1); 
     BasicIO.DONE := TRUE;
  END PutByte;

  PROCEDURE PutBytes* (file : File; VAR x : ARRAY OF SYSTEM.BYTE; len : CARDINAL);
     VAR i: CARDINAL;
  BEGIN
     i := 0;
     WHILE i # len DO
	IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	   EmitBuffer(file);
	   IF ~BasicIO.DONE THEN RETURN END;
	END;
        SYSTEM.PUT(SYSTEM.VAL(LONGINT,BPOS[file]),x[i]);
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])+1); 
        INC(i);
     END;
     BasicIO.DONE := TRUE;
  END PutBytes;

  PROCEDURE PutItem* (file : File; VAR x : ARRAY OF SYSTEM.BYTE);
     VAR i, len: CARDINAL;
  BEGIN
     i := 0;
     len := LEN(x);
     WHILE i # len DO
	IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	   EmitBuffer(file);
	   IF ~BasicIO.DONE THEN RETURN END;
	END;
        SYSTEM.PUT(SYSTEM.VAL(LONGINT,BPOS[file]),x[i]);
     BPOS[file]:=SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BPOS[file])+1); 
        INC(i);
     END;
     BasicIO.DONE := TRUE;
  END PutItem;


  (*=== Misc. ===*)

  PROCEDURE PutBf* (file: File);
  BEGIN
     IF SYSTEM.VAL(LONGINT,BPOS[file]) # SYSTEM.VAL(LONGINT,BFIRST[file]) THEN EmitBuffer(file) END;
  END PutBf;

  PROCEDURE Done* () : BOOLEAN;
  BEGIN
     RETURN BasicIO.DONE;
  END Done;

  PROCEDURE EOF* (file : File) : BOOLEAN;
  BEGIN;
     IF ISOUTPUT[file] THEN RETURN TRUE END;
     IF SYSTEM.VAL(LONGINT,BPOS[file]) > SYSTEM.VAL(LONGINT,BLAST[file]) THEN
	FillBuffer(file);
	RETURN (ENDOFFILE[file]);
     END;
     RETURN FALSE
  END EOF;

  PROCEDURE Accessible* (VAR name       : ARRAY OF CHAR; 
                            ForWriting : BOOLEAN) : BOOLEAN;
  BEGIN
    RETURN BasicIO.Accessible (name, ForWriting);
  END Accessible;
  
  PROCEDURE Erase* (VAR name : ARRAY OF CHAR; VAR ok : BOOLEAN);
  BEGIN
    BasicIO.Erase (name, ok);
  END Erase;
  
  (*=== Private ===*)

  PROCEDURE EmitBuffer* (file : File);
  BEGIN
     BasicIO.Write (file, SYSTEM.VAL(LONGINT,BFIRST[file]), (SYSTEM.VAL(LONGINT,BPOS[file]) - SYSTEM.VAL(LONGINT,BFIRST[file])));
     BPOS[file] := BFIRST[file];
     BasicIO.DONE := TRUE;
  END EmitBuffer;

  PROCEDURE FillBuffer* (file : File);
     VAR n:LONGINT; 
  BEGIN
     BasicIO.Read (file, SYSTEM.VAL(LONGINT,BFIRST[file]), BUFFSIZE, n);
     IF n > 0 THEN
	BPOS[file] := BFIRST[file];
	BLAST[file] := SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BFIRST[file]) + (n) - 1);
	BasicIO.DONE := TRUE;
	ENDOFFILE[file] := FALSE;
     ELSE
	BPOS[file] := BFIRST[file];
	BLAST[file] := SYSTEM.VAL(ADDRESS,SYSTEM.VAL(LONGINT,BFIRST[file]) - 1);
	BasicIO.DONE := FALSE;
	ENDOFFILE[file] := n = 0;
     END;
  END FillBuffer;

END ByteIO.

