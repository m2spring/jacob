MODULE TstFiles;
IMPORT F:=RawFiles, L:=Lib, O:=Out, SYS:=SYSTEM;

VAR i:LONGINT; fn:ARRAY 200 OF CHAR; 

(************************************************************************************************************************)
PROCEDURE Cat(fn:ARRAY OF CHAR);
VAR f:F.File; n:LONGINT; buf:ARRAY 2 OF CHAR; 
BEGIN (* Cat *)
 IF ~F.Accessible(fn,FALSE) THEN 
    O.Str('File '); O.Str(fn); O.Str(' not found'); O.Ln;
    RETURN;
 END; (* IF *)
 
 F.OpenInput(f,fn); 
 LOOP
  F.Read(f,SYS.ADR(buf),LEN(buf)-1,n); 
  IF n=0 THEN EXIT; END; (* IF *)
  buf[n]:=0X; 
  O.Str(buf); 
 END; (* LOOP *)
 F.Close(f); 
END Cat;

(************************************************************************************************************************)
BEGIN (* TstFiles *)
 IF L.ParamCount()<2 THEN 
    O.Str('Usage: TstFiles {<filenames>}'); O.Ln;
    HALT(1); 
 END; (* IF *)
 
 FOR i:=1 TO L.ParamCount()-1 DO
  L.ParamStr(fn,i); 
  Cat(fn); 
 END; (* FOR *)
END TstFiles.
