(******************************************************************************)
(* Copyright (c) 1988 by GMD Karlruhe, Germany				      *)
(* Gesellschaft fuer Mathematik und Datenverarbeitung			      *)
(* (German National Research Center for Computer Science)		      *)
(* Forschungsstelle fuer Programmstrukturen an Universitaet Karlsruhe	      *)
(* All rights reserved.							      *)
(******************************************************************************)

MODULE BasicIO;
IMPORT SYSTEM, SysLib, Strings1;

TYPE File* = LONGINT;
VAR DONE* :BOOLEAN; 

TYPE tFileName = ARRAY 1024 OF CHAR;


  PROCEDURE OpenInput* (VAR file : File; VAR name : ARRAY OF CHAR);
    VAR s: tFileName;
  BEGIN
    IF (name[0] = '-') & (LEN(name) = 1) THEN
       file := 0
    ELSE
       Strings1.Assign(s,name); (* ms 11/90 *)
       file := SysLib.open (SYSTEM.ADR (s), SysLib.oRDONLY); (* ms 11/90 *)
    END;
  END OpenInput;

  PROCEDURE OpenOutput* (VAR file : File; VAR name : ARRAY OF CHAR);
    VAR s: tFileName;
  BEGIN
    IF (name[0] = '-') & (LEN(name) = 1) THEN
	file := 1;
     ELSE
        Strings1.Assign(s,name); (* ms 11/90 *)
        file := SysLib.creat (SYSTEM.ADR (s), SysLib.pROWNER + SysLib.pWOWNER + SysLib.pRGROUP + SysLib.pWGROUP + SysLib.pROTHERS + SysLib.pWOTHERS);
        (* access mode is rw-rw-rw- & ~umask *)
     END;
  END OpenOutput;

  PROCEDURE Close* (file : File);
     VAR result :LONGINT; 
  BEGIN
     IF (file # 0) & (file # 1) THEN
        result := SysLib.close (file);
     END;
  END Close;

  PROCEDURE Read* (file: File; x:LONGINT; n:LONGINT; VAR bytesread:LONGINT);
  BEGIN
    bytesread := SysLib.read (file, x, n);
  END Read;

  PROCEDURE Write* (file : File; x,n:LONGINT);
     VAR result:LONGINT; 
  BEGIN
    result := SysLib.write (file, x, n);
  END Write;

  PROCEDURE Accessible* (VAR name : ARRAY OF CHAR; ForWriting : BOOLEAN)
		       : BOOLEAN;
    VAR
      s: tFileName;
      amode :LONGINT; 
  BEGIN
    Strings1.Assign(s,name); (* ms 11/90 *)
    IF ForWriting THEN
      amode := SysLib.cWRITE
    ELSE (* for reading *)
      amode := SysLib.cREAD
    END;
    RETURN SysLib.access (SYSTEM.ADR(s), amode) = 0  (* ms 11/90 *)
  END Accessible;

  PROCEDURE Erase* (VAR name : ARRAY OF CHAR; VAR ok : BOOLEAN);
    VAR s: tFileName;
  BEGIN
     Strings1.Assign(s,name); (* ms 11/90 *)
     ok := SysLib.unlink (SYSTEM.ADR(s)) = 0  (* ms 11/90 *)
  END Erase;

END BasicIO.
