MODULE m2;
TYPE T7=RECORD
	 f:BOOLEAN; 
         g:ARRAY 6 OF CHAR; 
        END;
VAR a:ARRAY 20 OF RECORD f:T7; g:ARRAY 1 OF T7; END;
    b:BOOLEAN; 
    p:POINTER TO T7;
    si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
BEGIN (* m2 *)				 
 b:=a[1].g[0].f;    
 b:=p.f; 
 si:=1; 
 in:=1; 
 in:=128; 
 li:=1; 
 li:=128; 
 li:=65536; 
END m2.
