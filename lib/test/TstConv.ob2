MODULE TstConv;
IMPORT L:=Lib, O:=Out, CV:=Conversions, SL:=SysLib, SYS:=SYSTEM, S:=Strings;

VAR i,n:LONGINT; s:ARRAY 200 OF CHAR; 
BEGIN (* TstConv *)
 n:=L.ParamCount(); 
 O.Int(n); O.Ln;
 FOR i:=0 TO n-1 DO
  L.ParamStr(i,s); 
  O.Str(s); O.Ln;
 END; (* FOR *)
END TstConv.
