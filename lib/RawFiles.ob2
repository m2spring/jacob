MODULE RawFiles;
IMPORT SysLib,SYSTEM;

CONST StdIn*    = SysLib.stdin;
      StdOut*   = SysLib.stdout;
      StdErr*   = SysLib.stderr;
TYPE  File*     = SysLib.int;
      tFilename = ARRAY 1024 OF CHAR; 

(************************************************************************************************************************)
PROCEDURE OpenInput*(VAR f:File; name:ARRAY OF CHAR);
VAR fn:tFilename;
BEGIN (* OpenInput *)
 IF name='-' THEN 
    f:=SysLib.stdin; 
 ELSE
    COPY(name,fn); 
    f:=SysLib.open(SYSTEM.ADR(fn),SysLib.O_RDONLY,0); 
 END; (* IF *)
END OpenInput;

(************************************************************************************************************************)
PROCEDURE OpenOutput*(VAR f:File; name:ARRAY OF CHAR);
VAR fn:tFilename;
BEGIN (* OpenOutput *)
 IF name='-' THEN 
    f:=SysLib.stdout; 
 ELSE
    COPY(name,fn); 
    f:=SysLib.creat(SYSTEM.ADR(fn)
                   ,SysLib.S_IRUSR+SysLib.S_IWUSR
                   +SysLib.S_IRGRP+SysLib.S_IWGRP
                   +SysLib.S_IROTH+SysLib.S_IWOTH);
 END; (* IF *)
END OpenOutput;

(************************************************************************************************************************)
PROCEDURE Close*(f:File);
VAR dummy:SysLib.int;
BEGIN (* Close *)    
 IF f>SysLib.stderr THEN dummy:=SysLib.close(f); END; (* IF *)
END Close;

(************************************************************************************************************************)
PROCEDURE Read*(f:File; adr,n:LONGINT; VAR bytesread:LONGINT); 
BEGIN (* Read *)				
 bytesread:=SysLib.read(f,adr,n); 
END Read;

(************************************************************************************************************************)
PROCEDURE Write*(f:File; adr,n:LONGINT); 
VAR dummy:LONGINT; 
BEGIN (* Write *)
 dummy:=SysLib.write(f,adr,n); 
END Write;	    

(************************************************************************************************************************)
PROCEDURE Accessible*(VAR name:ARRAY OF CHAR; ForWriting:BOOLEAN):BOOLEAN; 
VAR fn:tFilename; amode:LONGINT; 
BEGIN (* Accessible *)		 
 IF ForWriting THEN amode:=SysLib.R_OK; ELSE amode:=SysLib.W_OK; END; (* IF *)
 COPY(name,fn); 
 RETURN (SysLib.access(SYSTEM.ADR(fn),amode)=0); 
END Accessible;

(************************************************************************************************************************)
PROCEDURE Erase*(VAR name:ARRAY OF CHAR; VAR ok:BOOLEAN);
VAR fn:tFilename;
BEGIN (* Erase *)
 COPY(name,fn); 
 ok:=(SysLib.unlink(SYSTEM.ADR(fn))=0); 
END Erase;

(************************************************************************************************************************)
END RawFiles.
