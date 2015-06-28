MODULE AshLsh;
IMPORT O:=Out, S:=SYSTEM; 

VAR si,sib:SHORTINT; 
    in,inb:INTEGER; 
    li,lib:LONGINT; 
BEGIN (* AshLsh *)
 li:=ASH(sib,si); 
 li:=ASH(inb,si); 
 li:=ASH(lib,si); 
 li:=S.LSH(sib,si); 
 li:=S.LSH(inb,si); 
 li:=S.LSH(lib,si); 
 li:=S.ROT(sib,si); 
 li:=S.ROT(inb,si); 
 li:=S.ROT(lib,si); 
END AshLsh.
