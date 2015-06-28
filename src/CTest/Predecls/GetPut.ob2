MODULE GetPut;
IMPORT S:=SYSTEM; 
VAR bo:BOOLEAN;
    ch:CHAR;
    si:SHORTINT;
    in:INTEGER;
    li:LONGINT;
    re:REAL;
    lr:LONGREAL;
    se:SET;
    pt:S.PTR;
    pr:PROCEDURE;

    adr:LONGINT; 
BEGIN (* GetPut *)
 adr:=S.ADR(adr); 
 S.GET(adr,bo);
 S.GET(adr,ch);
 S.GET(adr,si);
 S.GET(adr,in);
 S.GET(adr,li);
 S.GET(adr,re);
 S.GET(adr,lr);
 S.GET(adr,se);
 S.GET(adr,pt);
 S.GET(adr,pr);
 
 S.PUT(adr,TRUE); 
 S.PUT(adr,1X); 
 S.PUT(adr,127); 
 S.PUT(adr,32767); 
 S.PUT(adr,32768); 
 S.PUT(adr,1.0); 
 S.PUT(adr,2.0D0); 
 S.PUT(adr,{1,2,3}); 
 S.PUT(adr,pt); 
 S.PUT(adr,pr); 
END GetPut.
