MODULE Odd;
IMPORT O:=Out; 
VAR f:BOOLEAN; si:SHORTINT; in:INTEGER; li:LONGINT; a:LONGINT; 
BEGIN (* Odd *)					    
 FOR si:=0 TO 10 DO
  O.Int(si); 
  IF ODD(si) THEN O.StrLn(' ODD'); ELSE O.StrLn(' EVEN'); END; (* IF *)
 END; (* FOR *)

 f:=ODD(si); 
 f:=ODD(in); 
 f:=ODD(li); 						       
 IF ODD(si) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF ODD(in) THEN a:=1; ELSE a:=2; END; (* IF *)
 IF ODD(li) THEN a:=1; ELSE a:=2; END; (* IF *)
END Odd.
