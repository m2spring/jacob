MODULE FIOTest;
IMPORT FIO,O:=Out,SL:=SysLib,L:=Lib;
VAR fn:ARRAY 100 OF CHAR; i:LONGINT; 
BEGIN (* FIOTest *)		     
 FOR i:=1 TO L.ParamCount()-1 DO
  L.ParamStr(fn,i); 
  O.Str(fn); 
  IF FIO.Exists(fn)
     THEN O.Str(' Exists '); 
     ELSE O.Str(' ~Exists '); 
  END; (* IF *)		  
  O.Int(SL.Errno()); 
  O.Ln;
 END; (* FOR *)
END FIOTest.
