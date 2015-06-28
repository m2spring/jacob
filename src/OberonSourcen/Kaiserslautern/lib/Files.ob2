MODULE Files;
(* see also [Oakwood Guidelines, revision 1A]
Module Files provides operations on files and the file directory.

Operations for unformatted input and output
In general, all operations must use the following format for external
representation:
- 'Little endian' representation (i.e., the least significant byte of a word is
  the one with the lowest address on the file).
- Numbers: SHORTINT 1 byte, INTEGER 2 bytes, LONGINT 4 bytes
- Sets: 4 bytes, element 0 is the least significant bit
- Booleans: single byte with FALSE = 0, TRUE = 1
- Reals: IEEE standard; REAL 4 bytes, LONGREAL 8 bytes
- Strings: with terminating 0X


Examples:
  VAR f: Files.File; r: Files.Rider; ch: CHAR;

Reading from an existing file:
  f := Files.Old ("xxx");
  IF f # NIL THEN
    Files.Set (r, f, 0);
    Files.Read (r, ch);
    WHILE ~ r.eof DO.
      Files.Read (r, ch)
    END
  END

Writing to a new file yyy:
  f := Files.New ("yyy");
  Files.Set (r, f, 0);
  Files.WriteInt (r, 8);
  Files.WriteString (r, " bytes");
  Files.Register (f)
*)



(* This module implements virtual filedescriptors for Unix, because in
   Unix there is a strict limitation of open files, which Oakwood does
   not share *)

IMPORT
  SYSTEM, C := CType, Unix, UnixSup, Time, Dos, Strings, Rts, CharInfo;
  

CONST
  done = 0;
  notDone = 1;
  notFound = 2;  (* file not found *)



CONST
  (* maximum length+1 for filenames *)
  sizeFilename = 256;
  (* maximum number of file descriptors's to allocate *)
  maxFdUsed = 10;

TYPE
  FileName = ARRAY sizeFilename OF CHAR;


CONST
  flagValid = 0;
  (* This flag is set in Handle's flags, if the corresponding filedescriptor
     is valid. This means that the file is physically attached to a
     Unix file. If this flag is not set, then no (read|write) operation
     on this file is allowed. *)
  flagRead = 1;
  (* This flag is set in Handle's flags, if the file is opened for reading,
     which is for now always the case. *)
  flagWrite = 2;
  (* This flag is set in Handle's flags, if the file is also opened for
     writing. It is always tried to open a file also for writing, but
     sometimes this fails due to file permissions in Unix. *)
  flagReg = 3;
  (* This flag tells the internal routines, which filename is valid.
     If set, the file was made resident with a 'Files.Register'
     call and 'name' tells you the name, under which the file is
     reachable. If not set, 'tmpn' tells you the file's temporary name. *)
  flagMark = 4;
  (* This flag is used in the virtual file descriptor's second chance
     algorithm for indication of a valid file. If this flag is present
     in Handle's flags, then the corresponding Unix file is likely to be
     closed the next time a new Unix file descriptor is needed, iff the
     number of open files exceeds the number of Unix files which this
     module allows to be open simultaneously. *)
  flagKeepFd = 5;
  (* Set iff the file descriptor must not be removed from this file. *)

CONST
  sizeBuffer = 2*1024;
  largeBlock = sizeBuffer DIV 4;
  (* blocks of size largeBlock or more won't refill the buffer *)

TYPE
  File* = POINTER TO Handle;
  Handle = RECORD
    fd   : Unix.fd;                  (* the file's fd *)
    flags: SET;
    pos  : LONGINT;                  (* the position within the file *)
    next : File;                     (* next File, internal use only *)
    name : FileName;                 (* name of the file (for New and Old) *)
    tmpn : FileName;                 (* tmpname of the file (for New only) *)

    buffer: ARRAY sizeBuffer OF SYSTEM.BYTE;
    bufferStart, bufferEnd: LONGINT;
    (* the buffer contains valid data from the file positions bufferStart<=pos<
    bufferEnd, buffer[i] corresponds to file[bufferStart+i] *)
    bufferRead: BOOLEAN;
    (* TRUE iff the last operation on the file was a read *)
  END;

  Rider* = RECORD
    eof- : BOOLEAN;
    res- : LONGINT;
    file : File;
    pos  : LONGINT;
  END;

VAR
  fdInUse: INTEGER; (* number of currently unassigned fds *)
  openFiles: File; (* all open files *)


VAR
  regFile: File;
  (* This place is temporarly used for the file info when Files.Register is
     called. *)
  swapBytes: BOOLEAN;
  (* TRUE iff byte order has to be reversed when reading or writing
     numerical values. *)
  swapTest: INTEGER;


PROCEDURE SetResult (errno: C.int; setDone: BOOLEAN; VAR res: LONGINT);
  BEGIN
    IF (errno # 0) THEN
      IF (errno = Unix.ENOENT) THEN
        res := notFound;
      ELSE
        res := notDone;
      END;
    ELSIF setDone THEN
      res := done;
    END;
  END SetResult;


PROCEDURE DeallocateFileDesc (file: File);
(* If 'file' has a valid Unix file descriptor, i.e. the Unix file associated
   with 'file' is open, then close it and release the Unix file descriptor.
   Update also the internal fields within file. *)
  VAR
    res, errno: C.int;
  BEGIN
    IF flagValid IN file.flags THEN
      (* The Unix file is opened. Close it and update the 'file' to reflect
         the closing of the underlying Unix file *)
      REPEAT
        res := Unix.close (file.fd);
        errno := Unix.Errno()
      UNTIL (res = 0) OR (errno # Unix.EINTR);
      file.fd := -1;
      file.flags := file.flags - {flagValid, flagRead, flagWrite, flagMark};
      (* we closed a Unix file, so we have one more filedescriptor available *)
      DEC (fdInUse);
    END;
  END DeallocateFileDesc;

PROCEDURE GetFileDesc (file: File; new: BOOLEAN): BOOLEAN;
(* Opens a Unix file and sets the file's fd to the correponding Unix
   file descriptor.
   If 'new' is TRUE, then the file will be created using Unix's creat call.
   The name of the file is 'file.name' or 'file.tmpn'.
   This is decided on the state of 'flagReg' in file.flags. If set,
   'file.name' is used, otherwise 'file.tmpn'.
   Result = TRUE, if the file could be opened/created. FALSE otherwise.  *)
  VAR
    fd: Unix.fd;
    fn: FileName;
    flags, errno: C.int;
    
  PROCEDURE FreeFileDesc;
  (* FreeFileDesc implements a second chance algorithm for Unix file
     descriptors associated with some Oberon files.
     This loop does only have effects on valid files, i.e. files with
     an opened Unix file underneeth.

     If a valid file is not marked (i.e. ~(flagMark IN file.flags)), then
     flagMark is set.
     If a valid file _is_ marked, the underlying Unix file is closed and
     it's Unix file descriptor is put back into the pool of avail
     file descriptors. *)
    VAR
      walk: File;
    BEGIN
      walk := openFiles; (* here we find all files we opened *)
      REPEAT
        IF (flagValid IN walk.flags) & ~(flagKeepFd IN walk.flags) THEN
          (* as stated, we are only interested in valid file, because they
             allocate Unix file descriptors; file with flagKeepFd are not
             considered *)
          IF flagMark IN walk.flags THEN
            (* this file is marked, so we steal it's file descriptor *)
            DeallocateFileDesc (walk);
            openFiles:=walk.next;
            RETURN;
          ELSE (* second chance, just mark it *)
            walk.flags := walk.flags + {flagMark}
          END
        END;
        walk := walk.next
      UNTIL walk = openFiles;
      (* this round we were not able to release any file descriptor, but we
         marked every valid file.  So once again try to release some file
         descriptors (will succeed, because all files are marked) *)
      FreeFileDesc
    END FreeFileDesc;

  BEGIN
    IF (fdInUse = maxFdUsed) THEN
      FreeFileDesc
    END;

    (* reset some flags *)
    file.flags := file.flags - {flagValid, flagMark, flagRead, flagWrite};

    (* determine, which name to use for the file *)
    IF (flagReg IN file.flags) THEN
      COPY (file.name, fn);
    ELSE
      COPY (file.tmpn, fn);
    END;

    IF new THEN
      (* Create a new file. The Unix permissions for the new file are
         set to rw-rw-rw *)
      flags := UnixSup.get_open_flags ({UnixSup.flO_CREAT, UnixSup.flO_TRUNC,
                                        UnixSup.flO_RDWR});
      REPEAT
        fd := Unix.open (fn, flags(*!, {1, 2, 4, 5, 7, 8}*));
        errno := Unix.Errno()
      UNTIL (fd # -1) OR (errno # Unix.EINTR);
      IF (fd = -1) & ((errno = Unix.EMFILE) OR (errno = Unix.ENFILE)) & (fdInUse # 0) THEN
        (* close one file and try again *)
        FreeFileDesc;
        RETURN GetFileDesc(file,new);
      ELSIF (fd = -1) THEN
        RETURN FALSE
      ELSE
        file. fd := fd;
        file. flags := file.flags + {flagValid, flagRead, flagWrite}
      END
    ELSE
      (* Try to open the file for reading/writing *)
      flags := UnixSup.get_open_flags ({UnixSup.flO_RDWR});
      REPEAT
        fd := Unix.open (fn, flags);
        errno := Unix.Errno()
      UNTIL (fd # -1) OR (errno # Unix.EINTR);
      IF (fd = -1) & ((errno = Unix.EMFILE) OR (errno = Unix.ENFILE)) & (fdInUse # 0) THEN
        (* close one file and try again *)
        FreeFileDesc;
        RETURN GetFileDesc(file,new);
      ELSIF (fd # -1) THEN
        file.fd := fd;
        file.flags := file.flags + {flagValid, flagRead, flagWrite}
      ELSE
        (* Open failed for reading/writing, so we try to open the file
           just for reading *)
        flags := UnixSup.get_open_flags ({UnixSup.flO_RDONLY});
        REPEAT
          fd := Unix.open (fn, flags);
          errno := Unix.Errno()
        UNTIL (fd # -1) OR (errno # Unix.EINTR);
        IF (fd = -1) & ((errno = Unix.EMFILE) OR (errno = Unix.ENFILE)) & (fdInUse # 0) THEN
          (* close one file and try again *)
          FreeFileDesc;
          RETURN GetFileDesc(file,new);
        ELSIF (fd # -1) THEN
          file.fd := fd;
          file.flags := file.flags + {flagValid, flagRead}
        ELSE
          (* file could not be opened for both reading/writing and reading 
             only, so we take this as an error *)
          RETURN FALSE
        END
      END
    END;
    
    INC (fdInUse); (* Update internal counter *)
    (* Set the position of the Unix file to the position of the file. *)
    IF (Unix.lseek (file.fd, file.pos, Unix.SEEK_SET) = -1) THEN END;
    RETURN TRUE
  END GetFileDesc;

PROCEDURE AllocateFileDesc (file: File);
(* Allocates a Unix file descriptor for 'file'. If 'file' has already one,
   unmark it, so it will not be released in the first round of 'FreeFileDesc'.
   If 'file' is not valid, then call 'GetFileDesc' *)
  VAR
    str: ARRAY sizeFilename+50 OF CHAR;
  BEGIN
    IF flagValid IN file.flags THEN
      file.flags := file.flags - {flagMark}  (* touch *)
    ELSIF ~GetFileDesc (file, FALSE) THEN
      COPY ("[Files] Failed to reopen file ", str);
      Strings.Append (file. name, str);
      Rts.Error (str)
    END
  END AllocateFileDesc;

PROCEDURE InsertFile (file: File);
(* inserts 'file' into the internal tracking list of open files *)
  VAR
    oldEnd: File;
  BEGIN
    IF openFiles # NIL THEN
      oldEnd:=openFiles;
      WHILE oldEnd.next # openFiles DO
        oldEnd:=oldEnd.next;
      END;
      oldEnd.next:=file;
      file.next:=openFiles;
    ELSE
      openFiles:=file;
      file.next:=file;
    END;
  END InsertFile;

PROCEDURE RemoveFile (file: File);
(* Removes 'file' from the internal tracking list of open file, if it is there.
   If 'file' is not on the internal tracking list, then nothing is
   done at all *)
  VAR
    walk: File;
  BEGIN
    DeallocateFileDesc (file); (* release file's Unix file descriptor *)
    IF file.next = file THEN
      openFiles:=NIL;
    ELSE
      walk:=openFiles;
      WHILE (walk.next # file) DO
        walk:=walk.next;
      END;
      walk.next:=file.next;
      IF file = openFiles THEN
        openFiles:=file.next;
      END;
    END;
  END RemoveFile;


PROCEDURE Old*(name: ARRAY OF CHAR): File;
(* Old (fn) searches the name fn in the directory and returns the
   corresponding file.  If the name is not found, it returns NIL. *)
  VAR
    f: File;
  BEGIN
    NEW (f);
    COPY (name, f.name); (* copy name to internal structure *)
    (* initialize buffer *)
    f. bufferStart := 0;
    f. bufferEnd := 0;
    f. bufferRead := TRUE;
    (* set flags, so 'name' is used for opening of the file *)
    f.flags := {flagReg};
    f.pos := 0;
    IF GetFileDesc (f, FALSE) THEN
      (* file could be opened, so insert to internal tracking list
         and return file *)
      InsertFile (f);
      RETURN (f);
    ELSE
      (* file could not be opened *)
      RETURN (NIL);
    END;
  END Old;


PROCEDURE New* (name : ARRAY OF CHAR): File;
(* New (fn) creates and returns a new file. The name fn is remembered for the
   later use of the operation Register.  The file is only entered into the
   directory when Register is called. *)
  VAR
    f: File;
  BEGIN
    NEW (f);
    COPY (name, f.name); (* remember 'name' for later (Files.Register) *)
    (* initialize buffer *)
    f. bufferStart := 0;
    f. bufferEnd := 0;
    f. bufferRead := TRUE;
    Dos.TmpFileName (f.tmpn); (* Generate a new temorary name *)
    f.flags := {}; (* no flags are set for creation of file *)
    f.pos := 0;
    IF GetFileDesc (f, TRUE) THEN
      (* new file could be created an opened. Put it onto the
         internal tracking list *)
      InsertFile (f);
      RETURN (f);
    ELSE
      (* new file could not be created or opened. Return NIL to
         indicate error *)
      RETURN NIL;
    END; (* IF *)
  END New;



PROCEDURE Delete*(name: ARRAY OF CHAR; VAR res: INTEGER);
(* Delete (fn, res) removes the directory entry for the file fn without
   deleting the file. If res=0 the file has been successfully deleted.
   If there are variables referring to the file while Delete is called,
   they can still be used. *)
  VAR
    r: LONGINT;
  BEGIN
    SetResult (Unix.unlink (name), TRUE, r);
    res := SHORT (r);
  END Delete;


PROCEDURE WriteToFile (f: File; pos: LONGINT; adr, n: LONGINT): LONGINT;
(* WriteToFile (r, buf, n) writes the first n bytes starting at memory address
   adr to file f at position pos.  f.pos is updated accordingly.  Result is 0
   on success and the number of bytes that could not be written on failure. *)
  VAR
    res : C.int;
  BEGIN
    AllocateFileDesc (f);
    IF (flagWrite IN f.flags) THEN  (* fd is valid *)
      IF TRUE OR (f.pos # pos) THEN  (* warp to the right position *)
        res := Unix.lseek (f.fd, pos, Unix.SEEK_SET)
      END;
      REPEAT
        res := Unix.write (f.fd, adr, n);
      UNTIL (res # -1) OR (Unix.Errno() # Unix.EINTR);
      IF (res = -1) THEN  (* write error *)
        res := 0
      END;
      f. pos := pos+res;
      RETURN n-res
    ELSE
      RETURN n
    END
  END WriteToFile;

PROCEDURE ReadFromFile (f: File; pos: LONGINT; adr, n: LONGINT): LONGINT;
(* ReadFromFile (r, buf, n) reads the first n bytes at position pos from file
   f and stores them at memory address adr.  f.pos is updated accordingly.
   Result is 0 on success and the number of bytes that could not be read on
   failure. *)
  VAR
    res : C.int;
  BEGIN
    AllocateFileDesc (f);
    IF (flagRead IN f.flags) THEN  (* fd is valid *)
      IF TRUE OR (f.pos # pos) THEN  (* warp to the right position *)
        res := Unix.lseek (f.fd, pos, Unix.SEEK_SET)
      END;
      REPEAT
        res := Unix.read (f.fd, adr, n);
      UNTIL (res # -1) OR (Unix.Errno() # Unix.EINTR);
      IF (res = -1) THEN  (* read error *)
        res := 0
      END;
      f. pos := pos+res;
      RETURN n-res
    ELSE
      RETURN n
    END
  END ReadFromFile;

PROCEDURE Flush (f: File);
(* Result is TRUE iff buffer was successfully flushed. *)
  VAR
    res: LONGINT;
  BEGIN
    IF ~f. bufferRead & (f. bufferEnd # f. bufferStart) THEN  
      (* write buffer to file if necessary *)
      res := WriteToFile (f, f. bufferStart, SYSTEM.ADR (f. buffer), 
                          f. bufferEnd-f. bufferStart);      
      f. bufferEnd := f. bufferStart  (* clear buffer *)
    END
  END Flush;

PROCEDURE Length*(f: File): LONGINT;
(* Length (f) returns the number of bytes in file f. *)
  VAR
    len: C.longint;
    res: C.int;
  BEGIN
    AllocateFileDesc (f);
    res := UnixSup.fd_len (f.fd, len);
    IF (len < f. bufferEnd) THEN
      RETURN f. bufferEnd
    ELSE
      RETURN len
    END
  END Length;

PROCEDURE Close*(f: File);
(* Close (f) writes back the file buffers of f. The file is still accessible by
   its handle f and the riders positioned on it. If a file is not modified it
   is not necessary to close it. *)
  BEGIN
    Flush (f);
    DeallocateFileDesc (f)
  END Close;

PROCEDURE CloseDown (f: File);
(* CloseDown (f) writes back the file buffers of f. The file is no more
   accessible by its handle f or the riders positioned on it. *)
  VAR
    res: INTEGER;
  BEGIN
    Close (f); (* Close the file *)
    (* remove it from the internal tracking list *)
    RemoveFile (f);
    IF ~(flagReg IN f.flags) THEN
      (* File was not registered, so delete the temporary file. *)
      Delete (f.tmpn, res);
    END;
  END CloseDown;


PROCEDURE Register*(f: File);
(* Register (f) enters the file f into the directory together with the name
   provided in the operation New that created f. The file buffers are written
   back. Any existing mapping of this name to another file is overwritten. *)
  CONST
    bufSize = 32 * 1024;
  VAR
    oldpos: LONGINT;                     (* the old position in the file *)
    dummy: INTEGER;
    n: C.int;                            (* byte counter for copy *)
    buffer: ARRAY bufSize OF SYSTEM.BYTE; (* copy buffer *)
    error : ARRAY 50 + sizeFilename OF CHAR;
    err: BOOLEAN;
  BEGIN
    (* check, if file is still accessible and not registered *)
    IF ~(flagReg IN f.flags) THEN
      Flush (f);
      oldpos := f.pos; (* remember old position *)

      (* ok, initialise a new file with the name the file
         should become upon Register *)
      COPY (f.name, regFile.name);
      (* this is for 'AllocateFileDesc'. Force to take
         'regFile.name' as filename *)
      regFile.flags := {flagReg};
      (* initialize internal fields *)
      regFile.fd := -1;
      regFile.pos := 0;
      regFile.bufferStart := 0;
      regFile.bufferEnd := 0;

      (* try to open old file (whose contents are to be copied into to
         registered file) and the new file, which will reside in the
         registered file's place *)
      AllocateFileDesc (f);
      INCL (f. flags, flagKeepFd);  (* ensure that f keeps it's fd *)
      IF GetFileDesc (regFile, TRUE) THEN
        (* new file could be opened, so 'f' becomes registered *)
        InsertFile(regFile);
        f.flags := f.flags + {flagReg}
      END;
      EXCL (f. flags, flagKeepFd);  (* make f's fd available again *)

      IF ~(flagValid IN regFile.flags) OR
         ~(flagWrite IN regFile.flags) OR
         ~(flagValid IN f.flags) OR ~(flagRead IN f.flags) THEN
        COPY ("[Files] Unable to register file ", error);
        Strings.Append (regFile.name, error);
        Rts.Error (error)
      END;

      (* copy the whole file *)
      (* set both positions to start of file *)
      IF Unix.lseek (f.fd, 0, Unix.SEEK_SET) = -1 THEN END;
      IF Unix.lseek (regFile.fd, 0, Unix.SEEK_SET) = -1 THEN END;
      err:=FALSE;
      LOOP
        REPEAT
          n := Unix.read (f.fd, SYSTEM.ADR (buffer), bufSize);
        UNTIL (n # -1) OR (Unix.Errno() # Unix.EINTR);
        IF (n = -1) THEN err:=TRUE; EXIT; END;
        REPEAT
          n := Unix.write (regFile.fd, SYSTEM.ADR (buffer), n);
        UNTIL (n # -1) OR (Unix.Errno() # Unix.EINTR);
        IF (n = -1) THEN err:=TRUE; EXIT; END;
        IF (n # bufSize) THEN EXIT; END;
      END;
      Close (f); (* close old file *)
      IF err THEN
        Delete(f.name, dummy); (* an error occured during registration, remove file *)
        COPY ("[Files] Unable to register file ", error);
        Strings.Append (regFile.name, error);
        n:=Unix.printf("*** Warning: %s"(*!, error*));
        n:=Unix.fputc (ORD (CharInfo.eol), Unix.stdout);
        f.pos := oldpos; (* set the old position *)
        f.flags:=f.flags-{flagReg};
      ELSE
        CloseDown (regFile); (* Remove 'regFile' from tracking list *)
        Delete (f.tmpn, dummy); (* delete the old temporary file *)
        f.pos := oldpos; (* set the old position *)
        AllocateFileDesc (f)  (* try to get a file descriptor for 'f' *)
      END; (* IF *)
    END;
  END Register;

PROCEDURE Purge*(f: File);
(* Purge (f) resets the length of file f to 0. *)
  VAR
    res: C.int;
  BEGIN
    AllocateFileDesc (f);
    res := Unix.ftruncate (f.fd, 0);
    (* clear buffer (no flush necessary) *)
    f. bufferStart := 0;
    f. bufferEnd := 0;
    f. bufferRead := TRUE
  END Purge;

PROCEDURE Rename* (old, new: ARRAY OF CHAR; VAR res: INTEGER);
(* Rename (oldfn, newfn, res) renames the directory entry oldfn to newfn.
   If res=0 the file has been successfully renamed. If there are variables
   referring to the file while Rename is called, they can still be used. *)
  VAR
    r: LONGINT;
  BEGIN
    SetResult (Unix.rename (old, new), TRUE, r);
    res := SHORT (r);
  END Rename;


PROCEDURE GetDate* (f : File; VAR t, d: LONGINT);
(* GetDate (f, t, d) returns the time t and date d of the last modification of
   file f.
   The encoding is:
     hour = t DIV 4096; minute = t DIV 64 MOD 64; second = t MOD 64;
     year = d DIV 512; month = d DIV 32 MOD 16; day = d MOD 32. *)
  VAR
    time: Time.Time;
  BEGIN
    AllocateFileDesc (f);
    IF (UnixSup.fd_date (f.fd, time.tv_sec, time.tv_usec) = 0) THEN
      IF (UnixSup.get_o2time (time.tv_sec, t, d) # 0) THEN
        t := 0; d := 0;
      END
    ELSE
      d := 0; t := 0;
    END;
  END GetDate;

PROCEDURE Set*(VAR r: Rider; f: File; pos: LONGINT);
(* Set (r, f, pos) sets the rider r to position pos in file f. The field r.eof
   is set to FALSE.  The operation requires that 0 <= pos <= Length (f). *)
  BEGIN
    r.file := f; (* associate 'r' with 'f' *)
    AllocateFileDesc (f);
    r.eof := FALSE;
    r.pos := pos
  END Set;

PROCEDURE Pos* (VAR r: Rider): LONGINT;
(* Pos (r) returns the position of the rider r. *)
  BEGIN
    RETURN r.pos;
  END Pos;

PROCEDURE Base*(VAR r: Rider): File;
(* Base (r) returns the file to which the rider r has been set. *)
  BEGIN
    RETURN r.file;
  END Base;




PROCEDURE ReadBytes* (VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
(* ReadBytes (r, buf, n) reads n bytes into buffer buf starting at the
   rider position r. The rider is advanced accordingly. If less than n bytes
   could be read, r.res contains the number of requested but unread bytes. *)
  VAR
    f: File;
    n0: LONGINT;
  BEGIN
    f := r. file;
    IF f.bufferRead & (f.bufferStart <= r.pos) & (r.pos+n <= f.bufferEnd) THEN
      (* all required bytes are in the file buffer *)
      SYSTEM.MOVE (SYSTEM.ADR (f. buffer[r. pos-f. bufferStart]),
                   SYSTEM.ADR (x), n);
      INC (r. pos, n);
      r. res := 0
    ELSIF (n < largeBlock) THEN  (* block small enough to update buffer *)
      (* refill buffer *)
      Flush (f);
      n0 := sizeBuffer-ReadFromFile (f, r. pos, SYSTEM.ADR (f. buffer), sizeBuffer);
      (* n0 is the number of bytes that were actually read into buffer *)
      f. bufferStart := r. pos;
      f. bufferEnd := r. pos+n0;
      (* not more than n0 bytes can be taken from the buffer *)
      IF (n > n0) THEN
        r. res := n-n0;
        n := n0;
        r. eof := TRUE
      ELSE
        r. res := 0
      END;
      SYSTEM.MOVE (SYSTEM.ADR (f. buffer[0]), SYSTEM.ADR (x), n);
      INC (r. pos, n)
    ELSE  (* bytes not in buffer and block too large to use buffer *)
      Flush (f);
      r. res := ReadFromFile (r. file, r. pos, SYSTEM.ADR (x), n);
      IF (r. res # 0) THEN  (* couldn't read n bytes: probably end of file *)
        r. eof := TRUE
      END;
      r. pos := f. pos
    END
  END ReadBytes;

PROCEDURE WriteBytes* (VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
(* WriteBytes (r, buf, n) writes the first n bytes from buf to rider r and
   advances r accordingly. r.res contains the number of bytes that could not
   be written (e.g., due to a disk full error). *)
  VAR
    f: File;
  BEGIN
    f := r. file;
    IF ~f.bufferRead & (f.bufferStart <= r.pos) &
       (r. pos <= f.bufferEnd) & (r.pos+n <= f.bufferStart+sizeBuffer) THEN
      (* bytes fit into buffer *)
      SYSTEM.MOVE (SYSTEM.ADR (x),
                   SYSTEM.ADR (f. buffer[r. pos-f. bufferStart]), n);
      INC (r. pos, n);
      r. res := 0;
      IF (r. pos > f. bufferEnd) THEN
        f. bufferEnd := r. pos
      END
    ELSIF (n < largeBlock) THEN
      (* block small enough to put it into the buffer *)
      Flush (f);
      f. bufferRead := FALSE;
      f. bufferStart := r. pos;
      INC (r. pos, n);
      r. res := 0;
      f. bufferEnd := r. pos;
      SYSTEM.MOVE (SYSTEM.ADR (x), SYSTEM.ADR (f. buffer), n)
    ELSE  (* block to large, write directly to file *)
      Flush (f);
      r. res := WriteToFile (f, r. pos, SYSTEM.ADR (x), n);
      r. pos := f. pos;
    END
  END WriteBytes;

PROCEDURE Swap (VAR x: ARRAY OF SYSTEM.BYTE);
  VAR
    i, j: SHORTINT;
    c: SYSTEM.BYTE;
  BEGIN
    IF swapBytes THEN
      i := 0; j := SHORT (SHORT (LEN (x)))-1;
      WHILE (i < j) DO
        c := x[i]; x[i] := x[j]; x[j] := c;
        INC (i); DEC (j)
      END
    END
  END Swap;

PROCEDURE WriteBytesSwap (VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE);
  BEGIN
    Swap (x);
    WriteBytes (r, x, LEN (x))
  END WriteBytesSwap;

PROCEDURE ReadBytesSwap (VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE);
  BEGIN
    ReadBytes (r, x, LEN (x));
    Swap (x)
  END ReadBytesSwap;



PROCEDURE Read*(VAR r: Rider; VAR x: SYSTEM.BYTE);
(* Read (r, x) reads the next byte x from rider r and advances r
   accordingly. *)
  BEGIN
    IF r. file. bufferRead &
       (r. file. bufferStart <= r. pos) &
       (r. pos < r. file. bufferEnd) THEN
      (* previous operation was read and the current byte is in the buffer *)
      x := r. file. buffer[r. pos-r. file. bufferStart];
      INC (r. pos)
    ELSE
      ReadBytes (r, x, SIZE (SYSTEM.BYTE))
    END
  END Read;

PROCEDURE ReadInt*(VAR r: Rider; VAR x: INTEGER);
(* ReadInt (r, i) read a integer number i from rider r and advance r
   accordingly. *)
  BEGIN
    ReadBytesSwap (r, x)
  END ReadInt;

PROCEDURE ReadLInt*(VAR r: Rider; VAR x: LONGINT);
(* ReadLInt (r, i) read a long integer number i from rider r and advance r
   accordingly. *)
  BEGIN
    ReadBytesSwap (r, x)
  END ReadLInt;

PROCEDURE ReadReal*(VAR r: Rider; VAR x: REAL);
(* ReadReal (r, x) read a real number x from rider r and advance r
   accordingly. *)
  BEGIN
    ReadBytesSwap (r, x)
  END ReadReal;

PROCEDURE ReadLReal*(VAR r: Rider; VAR x: LONGREAL);
(* ReadLReal (r, x) read a long real number x from rider r and advance r
   accordingly. *)
  BEGIN
    ReadBytesSwap (r, x)
  END ReadLReal;

PROCEDURE ReadNum*(VAR r: Rider; VAR x: LONGINT);
(* ReadNum (r, i) reads an integer number i from rider r and advances r
   accordingly.  The number i is compactly encoded. *)
  VAR
    s: SHORTINT;
    ch: CHAR;
    n: LONGINT;
  BEGIN
    s := 0; n := 0;
    Read (r, ch);
    WHILE ORD (ch) >= 128 DO
      INC (n, ASH (ORD (ch)-128, s));
      INC (s, 7);
      Read (r, ch);
    END;
    x := n + ASH (ORD (ch) MOD 64 - ORD (ch) DIV 64*64, s);
  END ReadNum;

PROCEDURE ReadString*(VAR r: Rider; VAR x: ARRAY OF CHAR);
(* ReadString (r, s) reads a sequence of characters (including the terminating
   0X) from rider r and returns it in s. The rider is advanced accordingly.
   The actual parameter corresponding to s must be long enough to hold the
   character sequence plus the terminating 0X *)
  VAR
    i: LONGINT;
  BEGIN
    i := -1;
    REPEAT
      INC (i);
      Read (r, x[i]);
    UNTIL (x[i]=0X);
  END ReadString;

PROCEDURE ReadSet*(VAR r: Rider; VAR x: SET);
(* ReadSet (r, s) reads a set s from rider r and advances r accordingly. *)
  BEGIN
    ReadBytesSwap (r, x)
  END ReadSet;

PROCEDURE ReadBool*(VAR r: Rider; VAR x: BOOLEAN);
(* ReadBool (r, b) reads a Boolean value b from rider r and advances r
   accordingly. *)
  VAR
    ch: CHAR;
  BEGIN
    Read (r, ch);
    x := (ch # 0X);
  END ReadBool;



PROCEDURE Write*(VAR r: Rider; x: SYSTEM.BYTE);
(* Write (r, x) writes the byte x to rider r and advances r accordingly. *)
  BEGIN
    IF ~r. file. bufferRead &
       (r. file. bufferStart <= r. pos) &
       (r. pos <= r. file. bufferEnd) &
       (r. file. bufferEnd < r. file. bufferStart+sizeBuffer) THEN
      (* previous operation was a write, the current byte is in the buffer
         and the buffer won't overflow is a byte is appended *)
      r. file. buffer[r. pos-r. file. bufferStart] := x;
      INC (r. pos);
      IF (r. file. bufferEnd < r. pos) THEN
        r. file. bufferEnd := r. pos
      END
    ELSE
      WriteBytes (r, x, SIZE (SYSTEM.BYTE))
    END
  END Write;

PROCEDURE WriteInt*(VAR r: Rider; x: INTEGER);
(* WriteInt (r, i) write the integer number i to rider r and advance r
   accordingly. *)
  BEGIN
    WriteBytesSwap (r, x)
  END WriteInt;

PROCEDURE WriteLInt*(VAR r: Rider; x: LONGINT);
(* WriteLInt (r, i) write the long integer number i
   to rider r and advance r accordingly. *)
  BEGIN
    WriteBytesSwap (r, x)
  END WriteLInt;

PROCEDURE WriteReal*(VAR r: Rider; x: REAL);
(* WriteReal (r, x) write the real number x to rider r and advance r
   accordingly. *)
  BEGIN
    WriteBytesSwap (r, x)
  END WriteReal;

PROCEDURE WriteLReal*(VAR r: Rider; x: LONGREAL);
(* WriteLReal (r, x) write the long real number x to rider r and advance r
   accordingly. *)
  BEGIN
    WriteBytesSwap (r, x)
  END WriteLReal;

PROCEDURE WriteNum*(VAR r: Rider; x: LONGINT);
(* WriteNum (r, i) writes the integer number i to rider r and advances r
   accordingly.  The number i is compactly encoded. *)
  BEGIN
    WHILE (x < -64) OR (x > 63) DO
      Write (r, CHR (x MOD 128 + 128));
      x := x DIV 128;
    END;
    Write (r, CHR (x MOD 128));
  END WriteNum;

PROCEDURE WriteString*(VAR r: Rider; x: ARRAY OF CHAR);
(* WriteString (r, s) writes the sequence of characters s (including the
   terminating 0X) to rider r and advances r accordingly. *)
  VAR
    i: LONGINT;
  BEGIN
    i := -1;
    REPEAT
      INC (i);
      Write (r, x[i]);
    UNTIL (x[i] = 0X);
  END WriteString;

PROCEDURE WriteSet*(VAR r: Rider; x: SET);
(* WriteSet (r, s) writes the set s to rider r and advances r accordingly. *)
  BEGIN
    WriteBytesSwap (r, x)
  END WriteSet;

PROCEDURE WriteBool*(VAR r: Rider; x: BOOLEAN);
(* WriteBool (r, b) writes the Boolean value b to rider r and advances r
   accordingly. *)
  BEGIN
    IF x THEN
      Write (r, 1X);
    ELSE
      Write (r, 0X);
    END;
  END WriteBool;

PROCEDURE Cleanup;
(* Closes all ever opened files which are still valid. *)
  VAR
    walk: File;
  BEGIN
    LOOP
      walk := openFiles;
      IF walk # NIL THEN
        CloseDown (walk);
      ELSE
        EXIT;
      END;
    END;
  END Cleanup;

PROCEDURE InitSwap (VAR x: ARRAY OF SYSTEM.BYTE);
  BEGIN
    swapBytes := (SYSTEM.VAL (SHORTINT, x[1]) # 1)
  END InitSwap;


BEGIN
  (* determine if bytes need to be swapped when reading or writing numerical
     values *)
  swapTest := 1;
  InitSwap (swapTest);
  (* initialize virtual file descriptor mechanism *)
  openFiles := NIL;
  NEW (regFile);
  regFile.flags := {};
  fdInUse := 0;
  Rts.TerminationProc (Cleanup)
END Files.
