MODULE Merge;
IMPORT Errors,F:=RawFiles,O:=Out,S:=Str,SYS:=SYSTEM;

VAR buf:ARRAY 16384 OF CHAR; index,nofBytes:LONGINT; 
    f:F.File;
    
(************************************************************************************************************************)
PROCEDURE WrError(e:Errors.tElem);
VAR i:LONGINT; 
BEGIN (* WrError *)
 O.Char('@'); 
 IF e.col>1 THEN 
    FOR i:=3 TO e.col DO O.Char(' '); END; (* FOR *)
    O.Str('^ '); 
 END; (* IF *)
 O.Int(e.col); 
 O.Char(','); 
 O.Int(e.lin); 
 O.Str(': '); 
 O.Str(e.msg^); 
 O.Ln;
END WrError;

(************************************************************************************************************************)
PROCEDURE Read;
VAR err:Errors.tElem; line:LONGINT; c:CHAR; 
BEGIN (* Read *)
 line:=1; err:=Errors.anchor.next; 
 LOOP
  WHILE (err#Errors.anchor) & (err.lin<line) DO
   WrError(err); 
   err:=err.next; 
  END; (* WHILE *)
  
  REPEAT
   IF index>=nofBytes THEN 
      F.Read(f,SYS.ADR(buf),LEN(buf),nofBytes); 
      IF nofBytes=0 THEN 
         WHILE err#Errors.anchor DO
          WrError(err); 
          err:=err.next; 
         END; (* WHILE *)
         RETURN; 
      END; (* IF *)
      index:=0; 
   END; (* IF *)
   
   c:=buf[index]; INC(index); 
   O.Char(c); 
  UNTIL c=0AX;
  INC(line); 
 END; (* LOOP *)
END Read;

(************************************************************************************************************************)
PROCEDURE Do*(fn:ARRAY OF CHAR);
BEGIN (* Do *)
 IF ~F.Accessible(fn,FALSE) OR ~Errors.Read(fn) THEN RETURN; END; (* IF *)
 
 F.OpenInput(f,fn); index:=0; nofBytes:=0; 
 Read;
 F.Close(f); 
END Do;

(************************************************************************************************************************)
END Merge.
