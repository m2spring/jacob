MODULE SysLib EXTERNAL [""]; 

CONST stdin*          = 0;
      stdout*         = 1;
      stderr*         = 2;
             
TYPE  int*            = LONGINT; 
      double*         = LONGREAL;
      size_t*         = LONGINT;
      unsigned_long*  = LONGINT;
      unsigned_short* = INTEGER;
      charP*          = LONGINT;
      voidP*          = LONGINT;
      mode_t*         = LONGINT;
      ptrdiff_t*      = LONGINT;
      time_t*         = LONGINT;
      time_tP*        = LONGINT;
      clock_t*        = LONGINT;
      off_t*          = LONGINT;

(* 
 * taken from linux/fcntl.h 
 *
 * open/fcntl - O_SYNC isn't implemented yet
 *)
CONST O_ACCMODE*      = 0003H;
      O_RDONLY*       = 0000H;
      O_WRONLY*       = 0001H;
      O_RDWR*         = 0002H;
      O_CREAT*        = 0040H;       (* not fcntl *)
      O_EXCL*         = 0080H;       (* not fcntl *)
      O_NOCTTY*       = 0100H;       (* not fcntl *)
      O_TRUNC*        = 0200H;       (* not fcntl *)
      O_APPEND*       = 0400H;
      O_NONBLOCK*     = 0800H;
      O_NDELAY*       = O_NONBLOCK;
      O_SYNC*         = 1000H;

(*
 * taken from linux/stat.h
 *)
TYPE  struct_statP    = LONGINT;
      struct_stat*    = RECORD
                         st_dev-     : unsigned_short;
                         __pad1-     : unsigned_short;
                         st_ino-     : unsigned_long;
                         st_mode-    : unsigned_short;
                         st_nlink-   : unsigned_short;
                         st_uid-     : unsigned_short;
                         st_gid-     : unsigned_short;
                         st_rdev-    : unsigned_short;
                         __pad2-     : unsigned_short;
                         st_size-    : unsigned_long;
                         st_blksize- : unsigned_long;
                         st_blocks-  : unsigned_long;
                         st_atime-   : unsigned_long;
                         __unused1-  : unsigned_long;
                         st_mtime-   : unsigned_long;
                         __unused2-  : unsigned_long;
                         st_ctime-   : unsigned_long;
                         __unused3-  : unsigned_long;
                         __unused4-  : unsigned_long;
                         __unused5-  : unsigned_long;
                        END;

CONST S_IRWXU*        = 1C0H;
      S_IRUSR*        = 100H;
      S_IWUSR*        = 080H;
      S_IXUSR*        = 040H;

      S_IRWXG*        = 038H;
      S_IRGRP*        = 020H;
      S_IWGRP*        = 010H;
      S_IXGRP*        = 008H;

      S_IRWXO*        = 007H;
      S_IROTH*        = 004H;
      S_IWOTH*        = 002H;
      S_IXOTH*        = 001H;
 
(*----------------------------------------------------------------------------------------------------------------------*)
(*
 * Taken from unistd.h
 *)

(* mode flags for access *)
CONST R_OK*           = 4;           (* Test for read permission.    *)
      W_OK*           = 2;           (* Test for write permission.   *)
      X_OK*           = 1;           (* Test for execute permission. *)
      F_OK*           = 0;           (* Test for existence.          *)

(* Values for the WHENCE argument to lseek. *)
CONST SEEK_SET*       = 0;           (* Seek from beginning of file. *)
      SEEK_CUR*       = 1;           (* Seek from current position.  *)
      SEEK_END*       = 2;           (* Seek from end of file.       *)

(*----------------------------------------------------------------------------------------------------------------------*)
(*
 * taken from linux/times.h
 *)
TYPE  struct_tmsP*    = LONGINT;
      struct_tms*     = RECORD
                         tms_utime-  : clock_t;
                         tms_stime-  : clock_t;
                         tms_cutime- : clock_t;
                         tms_cstime- : clock_t;
                        END; 

TYPE  stringP*        = POINTER TO ARRAY 200000000 OF CHAR; 
      ExitProcT*      = PROCEDURE;
VAR   argc*           : LONGINT; 
      argv*           ,
      env*            : POINTER TO ARRAY 200000000 OF stringP; 
      errno*          : LONGINT; 
      ExitProc*       : ExitProcT;      

PROCEDURE access*(pathname:charP; mode:int):int; 
PROCEDURE chdir*(path:charP):int; 
PROCEDURE close*(fd:int):int; 
PROCEDURE creat*(pathname:charP; mode:mode_t):int; 
PROCEDURE fstat*(fd:int; buf:struct_statP):int; 
PROCEDURE _fxstat*(ver,fd:int; buf:struct_statP):int; 
PROCEDURE ftruncate*(fd:int; length:size_t):int; 
PROCEDURE lseek*(fd:int; offset:off_t; whence:int):off_t; 
PROCEDURE mkdir*(path:charP; mode:mode_t):int; 
PROCEDURE open*(pathname:charP; flags:int; mode:mode_t):int; 
PROCEDURE read*(fd:int; buf:charP; count:size_t):int; 
PROCEDURE rename*(oldpath:charP; newpath:charP):int; 
PROCEDURE rmdir*(pathname:charP):int; 
PROCEDURE stat*(file_name:charP; buf:struct_statP):int; 
PROCEDURE umask*(mask:int):int; 
PROCEDURE unlink*(pathname:charP):int; 
PROCEDURE write*(fd:int; bufP:charP; count:size_t):int; 

PROCEDURE time*(t:time_tP):time_t; 
PROCEDURE times*(buf:struct_tmsP):clock_t; 
PROCEDURE system*(string:charP):int; 
PROCEDURE exit*(status:int); 
PROCEDURE abort*; 
PROCEDURE sbrk*(increment:ptrdiff_t):voidP; 

PROCEDURE random*():LONGINT; 
PROCEDURE srandom*(seed:LONGINT); 

PROCEDURE gcvt*(number:double; ndigit:size_t; buf:charP); 
PROCEDURE ecvt*(number:double; ndigit:size_t; VAR decpt:int; VAR sign:int):charP; 

PROCEDURE strtod*(nptr:charP; VAR endptr:charP):double; 

END SysLib.
