MODULE M1;

PROCEDURE P;
VAR bo:BOOLEAN; 
    ch:CHAR; 
    si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT; 
    re:REAL;
    lr:LONGREAL;
    se:SET;
    pt:POINTER TO ARRAY OF CHAR;
    pr:PROCEDURE;
BEGIN (* P *)
 bo:=TRUE; 
 ch:='A'; 
 si:=20; 
 in:=21; 
 li:=22; 
 re:=1.0; 
 lr:=2.0D0; 
 se:={0,1,2};    
 pt:=NIL; 
 pr:=NIL; 
END P;


BEGIN (* M1 *)
END M1.
