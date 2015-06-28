MODULE ShortLong;
VAR si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
    re:REAL;
    lr:LONGREAL;
BEGIN (* ShortLong *)
 in:=LONG(si); 
 li:=LONG(in); 
 lr:=LONG(re); 
 
 si:=SHORT(in); 
 in:=SHORT(li); 
 re:=SHORT(lr); 
 
 li:=si+1; 
 li:=LONG(si)+1; 
 li:=LONG(LONG(si))+1; 
 
 si:=SHORT(SHORT(li)); 
END ShortLong.
