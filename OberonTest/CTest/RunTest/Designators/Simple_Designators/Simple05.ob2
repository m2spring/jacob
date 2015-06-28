MODULE Simple05;
(*% Simple Designators: LONGINT *)

IMPORT O:=Out;

VAR 
  li:LONGINT; 

PROCEDURE P;
VAR pli:LONGINT; 

  PROCEDURE Q;
  VAR qli:LONGINT; 
  BEGIN (* Q *)
   qli:=80000; 
   O.Int(qli); O.Ln;
   
   O.Int(pli); O.Ln;
  END Q;
  
BEGIN (* P *)
 pli:=90000; 
 Q;
END P;

BEGIN (* Simple05 *)
 li:=70000; 
 O.Int(li); O.Ln;
 
 P;
END Simple05.

