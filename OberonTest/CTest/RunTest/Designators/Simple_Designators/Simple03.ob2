MODULE Simple03;
(*% Simple Designators: SHORTINT *)

IMPORT O:=Out;

VAR 
  si:SHORTINT; 

PROCEDURE P;
VAR psi:SHORTINT; 

  PROCEDURE Q;
  VAR qsi:SHORTINT; 
  BEGIN (* Q *)
   qsi:=2; 
   O.Int(qsi); O.Ln;
   
   O.Int(psi); O.Ln;
  END Q;
  
BEGIN (* P *)
 psi:=3; 
 Q;
END P;

BEGIN (* Simple03 *)
 si:=1; 
 O.Int(si); O.Ln;
 
 P;
END Simple03.

