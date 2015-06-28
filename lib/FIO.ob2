MODULE FIO;
(** Inspired by TopSpeed Modula-2 library module FIO *)
IMPORT L:=Lib,SL:=SysLib,SYSTEM;

CONST StandardInput*  = SL.stdin;
      StandardOutput* = SL.stdout;
      ErrorOutput*    = SL.stderr;
TYPE  File*   = SL.int;
VAR   errno-  : LONGINT; 

(************************************************************************************************************************)
PROCEDURE ChDir(dn:ARRAY OF CHAR);
BEGIN (* ChDir *)
 IF SL.chdir(SYSTEM.ADR(dn))=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END ChDir;

(************************************************************************************************************************)
PROCEDURE Close*(f:File);
BEGIN (* Close *)
 IF SL.close(f)=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END Close;

(************************************************************************************************************************)
PROCEDURE Create*(fn:ARRAY OF CHAR):File;
VAR f:File;
BEGIN (* Create *)
 f:=SL.creat(SYSTEM.ADR(fn)
            ,SL.S_IRUSR+SL.S_IWUSR
            +SL.S_IRGRP+SL.S_IWGRP
            +SL.S_IROTH+SL.S_IWOTH);
 IF f>=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
 RETURN f; 
END Create;

(************************************************************************************************************************)
PROCEDURE Erase*(fn:ARRAY OF CHAR);
VAR ok:BOOLEAN; 
BEGIN (* Erase *)
 ok:=(SL.unlink(SYSTEM.ADR(fn))=0); 
 IF ok THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END Erase;

(************************************************************************************************************************)
PROCEDURE Exists*(fn:ARRAY OF CHAR):BOOLEAN; 
VAR ok:BOOLEAN; 
BEGIN (* Exists *)			    
 ok:=(SL.access(SYSTEM.ADR(fn),SL.R_OK)=0); 
 IF ok THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
 RETURN ok;
END Exists;

(************************************************************************************************************************)
PROCEDURE GetPos*(f:File):LONGINT; 
VAR p:LONGINT; 
BEGIN (* GetPos *)		  
 p:=SL.lseek(f,0,SL.SEEK_CUR); 
 IF p>=0 THEN errno:=0; ELSE p:=0; errno:=SL.errno; END; (* IF *)
 RETURN p; 
END GetPos;

(************************************************************************************************************************)
PROCEDURE IOresult*():LONGINT; 
VAR e:LONGINT; 
BEGIN (* IOresult *)	      
 e:=errno; errno:=0; RETURN e; 
END IOresult;

(************************************************************************************************************************)
PROCEDURE MkDir*(dn:ARRAY OF CHAR);
BEGIN (* MkDir *)		
 IF SL.mkdir(SYSTEM.ADR(dn),SL.S_IRUSR+SL.S_IWUSR
                           +SL.S_IRGRP+SL.S_IWGRP
                           +SL.S_IROTH+SL.S_IWOTH)=0 THEN 
    errno:=0; 
 ELSE 
    errno:=SL.errno; 
 END; (* IF *)
END MkDir;

(************************************************************************************************************************)
PROCEDURE Open*(fn:ARRAY OF CHAR):File;
VAR f:File;
BEGIN (* Open *)
 f:=SL.open(SYSTEM.ADR(fn),SL.O_RDONLY,0); 
 IF f>=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
 RETURN f; 
END Open;

(************************************************************************************************************************)
PROCEDURE RdBin*(f:File; VAR buf:ARRAY OF SYSTEM.BYTE; sz:LONGINT):LONGINT; 
VAR n:LONGINT; 
BEGIN (* RdBin *)
 n:=SL.read(f,SYSTEM.ADR(buf),sz); 
 IF n>=0 THEN errno:=0; ELSE n:=0; errno:=SL.errno; END; (* IF *)
 RETURN n; 
END RdBin;

(************************************************************************************************************************)
PROCEDURE Rename*(on,nn:ARRAY OF CHAR);
BEGIN (* Rename *)				  
 IF SL.rename(SYSTEM.ADR(on),SYSTEM.ADR(nn))=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END Rename;

(************************************************************************************************************************)
PROCEDURE RmDir*(dn:ARRAY OF CHAR);
BEGIN (* RmDir *)
 IF SL.rmdir(SYSTEM.ADR(dn))=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END RmDir;

(************************************************************************************************************************)
PROCEDURE Seek*(f:File; pos:LONGINT);
VAR p:LONGINT; 
BEGIN (* Seek *)		   
 p:=SL.lseek(f,0,SL.SEEK_SET); 
 IF p>=0 THEN errno:=0; ELSE p:=0; errno:=SL.errno; END; (* IF *)
END Seek;

(************************************************************************************************************************)
PROCEDURE Size*(f:File):LONGINT; 
VAR stat:SL.struct_stat;
BEGIN (* Size *)	
 IF SL._fxstat(1,f,SYSTEM.ADR(stat))=0 THEN 
    errno:=0; RETURN stat.st_size; 
 ELSE 
    errno:=SL.errno; RETURN 0; 
 END; (* IF *)
END Size;

(************************************************************************************************************************)
PROCEDURE Truncate*(f:File);
VAR p:LONGINT; 
BEGIN (* Truncate *)
 p:=SL.lseek(f,0,SL.SEEK_CUR); 
 IF (p>=0) & (SL.ftruncate(f,p)=0) THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END Truncate;

(************************************************************************************************************************)
PROCEDURE WrBin*(f:File; buf:ARRAY OF SYSTEM.BYTE; sz:LONGINT);
BEGIN (* WrBin *)
 IF SL.write(f,SYSTEM.ADR(buf),sz)>=0 THEN errno:=0; ELSE errno:=SL.errno; END; (* IF *)
END WrBin;

(************************************************************************************************************************)
END FIO.
