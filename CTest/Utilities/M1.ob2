MODULE M1;
IMPORT O:=Out, UTIS;

VAR s:ARRAY 40 OF CHAR; i:LONGINT; 
BEGIN (* M1 *)
 s:='laber';                       
 i:=UTIS.Length(s); 
 O.String('LENGTH("'); O.String(s); O.String('")='); O.Int(i); O.Ln;
 
 s:='abcdef'; UTIS.DoFillRb(s,6,'*'); O.String('"'); O.String(s); O.String('"'); O.Ln;
 s:='abcdef'; UTIS.DoFillRb(s,7,'*'); O.String('"'); O.String(s); O.String('"'); O.Ln;
 s:='abcdef'; UTIS.DoFillRb(s,8,'*'); O.String('"'); O.String(s); O.String('"'); O.Ln;
 s:='abcdef'; UTIS.DoFillRb(s,9,'*'); O.String('"'); O.String(s); O.String('"'); O.Ln;

 UTIS.Int2Dez(4711,s); O.String('"'); O.String(s); O.String('"'); O.Ln;
 UTIS.Int2Dez(-4711,s); O.String('"'); O.String(s); O.String('"'); O.Ln;

 UTIS.Int2Hex(4711H,s); O.String('"'); O.String(s); O.String('"'); O.Ln;
END M1.
