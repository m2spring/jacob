MODULE Abs;
IMPORT O:=Out; 

VAR si:SHORTINT; in:INTEGER; li:LONGINT; 

PROCEDURE siFail;
BEGIN (* siFail *)
 si:=MIN(SHORTINT); si:=ABS(si); 
END siFail;

PROCEDURE inFail;
BEGIN (* inFail *)
 in:=MIN(INTEGER); in:=ABS(in); 
END inFail;

PROCEDURE liFail;
BEGIN (* liFail *)
 li:=MIN(LONGINT); li:=ABS(li); 
END liFail;

BEGIN (* Abs *)				 
 si:=MIN(SHORTINT)+1; O.Str("ABS("); O.Int(si); si:=ABS(si); O.Str(")="); O.Int(si); O.Ln;
 in:=MIN(INTEGER )+1; O.Str("ABS("); O.Int(in); in:=ABS(in); O.Str(")="); O.Int(in); O.Ln;
 li:=MIN(LONGINT )+1; O.Str("ABS("); O.Int(li); li:=ABS(li); O.Str(")="); O.Int(li); O.Ln;
 liFail;
 inFail;
 siFail;
END Abs.
