(* $! oc -it Simple07 # *)
MODULE Simple07;
(*% Simple Designators: LONGREAL *)

IMPORT O:=Out;

VAR 
  lr:LONGREAL;

PROCEDURE P;
VAR plr:LONGREAL; 

  PROCEDURE Q;
  VAR qlr:LONGREAL;
  BEGIN (* Q *)
   qlr:=2.0D0; 
   O.Longreal(qlr); O.Ln;
   
   O.Longreal(plr); O.Ln;
  END Q;
  
BEGIN (* P *)
 plr:=3.0D0; 
 Q;
END P;

BEGIN (* Simple07 *)
 lr:=1.0D0; 
 O.Longreal(lr); O.Ln;
 
 P;
END Simple07.

