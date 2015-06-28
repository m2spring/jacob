MODULE UnixSup(*! ["C"] EXTERNAL ["UnixSup.c"]!*);

IMPORT
  C := CType;

(* Additional C functions used to extract tidbits of data out
   of large, system dependent C data structures.  This way these
   data structures don't need to be declared in Oberon-2.  *)

CONST
  flO_RDONLY* = 0;
  flO_WRONLY* = 1;
  flO_RDWR* = 2;
  flO_CREAT* = 3;
  flO_TRUNC* = 4;

TYPE
  TermProc* = PROCEDURE;
  
PROCEDURE file_length* (filename : ARRAY OF C.char) : C.int; (*<*)END file_length;(*>*)
PROCEDURE stream_length* (stream : C.address) : C.int; (*<*)END stream_length;(*>*)
PROCEDURE file_date* (filename : ARRAY OF C.char; VAR sec, usec : C.longint) : C.int; (*<*)END file_date;(*>*)
PROCEDURE stream_date* (stream : C.address; VAR sec, usec : C.longint) : C.int; (*<*)END stream_date;(*>*)
PROCEDURE fd_date* (fd : C.int; VAR sec, usec : C.longint) : C.int; (*<*)END fd_date;(*>*)
PROCEDURE fd_len* (fd : C.int; VAR len: C.longint) : C.int; (*<*)END fd_len;(*>*)
PROCEDURE get_o2time* (sec : C.longint; VAR t, d : LONGINT) : C.int; (*<*)END get_o2time;(*>*)
PROCEDURE get_homedir* (VAR home : ARRAY OF C.char; sizeHome : C.int; user : ARRAY OF C.char); (*<*)END get_homedir;(*>*)
PROCEDURE get_open_flags* (*!["UnixSup_get_open_flags"]!*) (flags: SET): C.int; (*<*)END get_open_flags;(*>*)

PROCEDURE round* (*!["UnixSup_round"]!*) (x: C.double) : C.double; (*<*)END round;(*>*)
PROCEDURE log* (*!["UnixSup_log"]!*) (x, base: C.double) : C.double; (*<*)END log;(*>*)

PROCEDURE atexit* (*!["UnixSup_atexit"]!*) (proc: TermProc); (*<*)END atexit;(*>*)

END UnixSup.


