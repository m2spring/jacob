MODULE Rts;

IMPORT
  C := CType, CharInfo, Unix, UnixSup;
  
  
VAR 
  (* code returned with normal program termination, i.e. when leaving _main *)
  exitCode* : INTEGER;  
  (* arguments to the C function main() *)
  argc-: C.int;
  argv-: C.charPtr2d;

PROCEDURE ArgNumber*() : INTEGER;
(* post: Result is the number of arguments. Returns 0 if no args given. *)
  BEGIN
    RETURN SHORT (argc-1)
  END ArgNumber;

PROCEDURE GetArg* (num : INTEGER; VAR arg : ARRAY OF CHAR);
(* pre : 0 <= num <= ArgNumber().
   post: arg is a nul terminated string. num=0 gives the program's own name. *)
  VAR
    i: INTEGER;
  BEGIN
    (* copy characters into 'arg', terminate with 0X or when 'arg' full *)
    i := -1;
    REPEAT
      INC (i);
      arg[i] := argv[num][i]
    UNTIL (arg[i] = 0X) OR (i = LEN(arg)-2);
    arg[i+1] := 0X                       (* terminate if 'arg' full *)
  END GetArg;

PROCEDURE Terminate*;
(* post: Terminates program, similar to HALT.  The value in 'exitCode' is
     is used as the exit status. *)
  BEGIN
    Unix.exit (exitCode)
  END Terminate;

PROCEDURE Error* (msg : ARRAY OF CHAR);
(* post: Writes the error message to the standard output and
         terminates the program with exit code 1. *)
  VAR
    res : C.int;
  BEGIN
    res := Unix.printf ("*** Error: %s"(*!, msg*));
    res := Unix.fputc (ORD (CharInfo.eol), Unix.stdout);
    Unix.exit (1)
  END Error;

PROCEDURE Assert* (expr : BOOLEAN; msg : ARRAY OF CHAR);
(* post: If the expr fails, the message is written to the standard output
         and the programm terminates with exit code 1. *)
  VAR
    res : C.int;
  BEGIN
    IF ~expr THEN
      res := Unix.printf ("*** Assert: %s"(*!, msg*));
      res := Unix.fputc (ORD (CharInfo.eol), Unix.stdout);
      Unix.exit (1)
    END
  END Assert;


PROCEDURE TerminationProc* (proc: UnixSup.TermProc);
(* Adds 'proc' to the list of procedures executed at program termination.
   Procedures are called in reverse order of registration.  
   If the registration is not successful (e.g. due to the system limit o
   the number of registered functions), the program is aborted with an error
   message. *)
  BEGIN
    UnixSup.atexit (proc)
  END TerminationProc;
  
PROCEDURE System* (command : ARRAY OF CHAR) : INTEGER;
(* Executes 'command' as a shell command.  Result is the value returned by 
   libc's 'system' function. *)
  BEGIN
    RETURN SHORT (Unix.system (command))
  END System;

BEGIN
  exitCode := 0
END Rts.
