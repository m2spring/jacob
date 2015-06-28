MODULE M3;
IMPORT O:=Out, S:=SYSTEM; 
TYPE T0* = RECORD
            fl:BOOLEAN; 
            se:SET;
            pt:POINTER TO ARRAY OF CHAR;
            pr:PROCEDURE;
            ar:ARRAY 5 OF POINTER TO ARRAY OF CHAR;
            re:REAL;
           END;        
VAR ar:POINTER TO ARRAY OF T0;           
    p0:POINTER TO T0;
    pr:PROCEDURE;   
    i,j:LONGINT; 
    
PROCEDURE DumpT0(VAR r:T0);
VAR i:LONGINT; 
BEGIN (* DumpT0 *)
 O.Str('p0.fl    = '); O.Hex(S.VAL(LONGINT,p0.fl)); O.Ln;
 O.Str('p0.se    = '); O.Hex(S.VAL(LONGINT,p0.se)); O.Ln;
 O.Str('p0.pt    = '); O.Hex(S.VAL(LONGINT,p0.pt)); O.Ln;
 O.Str('p0.pr    = '); O.Hex(S.VAL(LONGINT,p0.pr)); O.Ln;
 FOR i:=0 TO LEN(p0.ar)-1 DO
  O.Str('p0.ar['); O.Int(i); O.Str('] = '); O.Hex(S.VAL(LONGINT,p0.ar[i])); O.Ln;
 END; (* FOR *)
 O.Str('p0.re    = '); O.Hex(S.VAL(LONGINT,p0.re)); O.Ln;
END DumpT0;

BEGIN (* M3 *)       
 pr:=NIL; 
 O.Str('NILPROC = '); O.Hex(S.VAL(LONGINT,pr)); O.Ln;
 
 NEW(p0); 
 O.StrLn('p0^:'); DumpT0(p0^); 
 
O.StrLn('A'); 
 NEW(ar,3); 
O.StrLn('B'); 
 i:=0; 
 ar[i].fl:=FALSE; 
O.StrLn('C'); 
 FOR i:=0 TO 2 DO
  O.Str('ar['); O.Int(i); O.Str(']:'); O.Ln; DumpT0(ar[i]); 
 END; (* FOR *)
END M3.
