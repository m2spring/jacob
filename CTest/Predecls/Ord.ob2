MODULE Ord;
IMPORT O:=Out; 
VAR c:CHAR; i:INTEGER; 
BEGIN (* Ord *)
 c:=CHR(129); 
 i:=ORD(c); 
 O.Int(i); O.Ln;
END Ord.
