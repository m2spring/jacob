MODULE M2;
VAR si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
BEGIN (* M2 *)  
 si:=si DIV 2; si:=si DIV 3; 
 in:=in DIV 2; in:=in DIV 3; 
 li:=li DIV 2; li:=li DIV 3; 

 si:=si MOD 2; si:=si MOD 3; 
 in:=in MOD 2; in:=in MOD 3; 
 li:=li MOD 2; li:=li MOD 3; 
END M2.
