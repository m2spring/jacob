MODULE Dos;

IMPORT 
  SYSTEM, C := CType, Unix, UnixSup, Time;

CONST
  pathSeperator* = "/";


PROCEDURE Delete*(file: ARRAY OF CHAR; VAR err : BOOLEAN);
  BEGIN
    err := (Unix.unlink  (file) # 0)
 END Delete;

PROCEDURE Rename* (old, new : ARRAY OF CHAR; VAR err : BOOLEAN);
  BEGIN
    err := (Unix.rename (old, new) = -1)
  END Rename;

PROCEDURE Copy* (src,dest: ARRAY OF CHAR; VAR err : BOOLEAN);
  CONST
    chunkSize = 32*1024;
  VAR
    in, out : C.FILE;
    inLen : C.int;
    buffer : ARRAY chunkSize OF CHAR;
    wantRead, hasRead, hasWritten : C.size_t;
  BEGIN
    err := FALSE;
    in := Unix.fopen (src, "r");
    IF (in # Unix.NULL) THEN
      out := Unix.fopen (dest, "w");
      IF (out # Unix.NULL) THEN
        inLen := UnixSup.stream_length (in);
        IF (inLen >= 0) THEN
          WHILE ~err & (inLen > 0) DO
            IF (inLen > chunkSize) THEN
              wantRead := chunkSize
            ELSE 
              wantRead := inLen
            END;
            hasRead := Unix.fread (SYSTEM.ADR (buffer), 1, wantRead, in);
            IF (hasRead = wantRead) THEN
              hasWritten := Unix.fwrite (SYSTEM.ADR (buffer), 1, hasRead, out);
              err := (hasWritten # hasRead)
            ELSE
              err := TRUE
            END;
            DEC (inLen, hasRead)
          END
        ELSE
          err := TRUE
        END;
        err := (Unix.fclose (out) # 0) OR err
      ELSE
        err := TRUE
      END;
      err := (Unix.fclose (in) # 0) OR err
    ELSE
      err := TRUE
    END
  END Copy;

PROCEDURE Exists* (file : ARRAY OF CHAR) : BOOLEAN;
  (* TRUE: Datei existiert, FALSE entsprechend: Keine Datei dieses Namens. *)
  BEGIN
    RETURN (Unix.access (file, Unix.F_OK) = 0)
  END Exists;

PROCEDURE GetDate* (file : ARRAY OF CHAR; VAR date : Time.Time; VAR err : BOOLEAN);
  VAR
    res : C.int;
  BEGIN
    res := UnixSup.file_date (file, date. tv_sec, date. tv_usec);
    err := (res # 0)
  END GetDate;

PROCEDURE GetUserHome*(VAR home: ARRAY OF CHAR; user: ARRAY OF CHAR);
(* gets the user's home directory path (stored in /etc/passwd)
   or the current user's home directory if user="". *)
  BEGIN
    UnixSup.get_homedir (home, LEN (home), user)
  END GetUserHome;

PROCEDURE GetCWD* (VAR path: ARRAY OF CHAR);
  VAR
    res : C.address;
  BEGIN
    res := Unix.getcwd (path, LEN (path))
  END GetCWD;

PROCEDURE TmpFileName* (VAR tmpnam : ARRAY OF CHAR);
(* If no file name can be generated, an empty string is returned in 'tmpnam'. *)
  VAR
    buffer : ARRAY 512 OF CHAR;
  BEGIN
    IF (Unix.tmpnam (buffer) # Unix.NULL) THEN
      COPY (buffer, tmpnam)
    ELSE
      COPY ("", tmpnam)
    END;
  END TmpFileName;
  
END Dos.


