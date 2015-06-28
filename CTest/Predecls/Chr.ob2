MODULE Chr;
VAR si:SHORTINT; in:INTEGER; li:LONGINT; ch:CHAR; 

PROCEDURE siFail;
BEGIN (* siFail *)
 si:=-1; ch:=CHR(si); 
END siFail;

PROCEDURE inFail;
BEGIN (* inFail *)
 in:=256; ch:=CHR(in); 
END inFail;

PROCEDURE liFail;
BEGIN (* liFail *)
 li:=-1; ch:=CHR(li); 
END liFail;

BEGIN (* Chr *)					  
 si:=0; in:=0; li:=0; 
 ch:=CHR(si); 
 ch:=CHR(in); 
 ch:=CHR(li); 

 liFail;
 inFail;
 siFail;
END Chr.
