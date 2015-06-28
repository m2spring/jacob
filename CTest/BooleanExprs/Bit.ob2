MODULE Bit;
IMPORT S:=SYSTEM; 
VAR a:LONGINT; n:SHORTINT; f:BOOLEAN; x:CHAR; 
BEGIN (* Bit *) 
 IF S.BIT(a,n) THEN 			       
    x:=0X; 
 ELSE 
    x:=1X; 
 END; (* IF *)
 f:=S.BIT(a,n); 
END Bit.
