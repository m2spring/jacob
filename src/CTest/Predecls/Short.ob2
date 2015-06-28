MODULE Short;

VAR si:SHORTINT; in:INTEGER; li:LONGINT; 

PROCEDURE inFail;
BEGIN (* inFail *)
 in:=128; si:=SHORT(in); 
END inFail;

PROCEDURE liFail;
BEGIN (* liFail *)
 li:=32768; in:=SHORT(li); 
END liFail;

BEGIN (* Short *)      
 liFail;
 inFail;
END Short.
