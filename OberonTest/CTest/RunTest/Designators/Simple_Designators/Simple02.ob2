MODULE Simple02;
(*% Simple Designators: CHAR*)

IMPORT O:=Out;

VAR 
  ch: CHAR; 

PROCEDURE P;
VAR pch: CHAR;  

  PROCEDURE Q;
  VAR qch: CHAR; 
  BEGIN (* Q *)
   qch:='B';
   O.Char(qch); O.Ln;
   
   O.Char(pch); O.Ln;
  END Q;
  
BEGIN (* P *)
 pch:=43X; 
 Q;
END P;

BEGIN (* Simple02 *)
 ch:='A';
 O.Char(ch); O.Ln;
 
 P;
END Simple02.

