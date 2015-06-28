(* $! oc -it Simple06 # *)
MODULE Simple06;
(*% Simple Designators: REAL *)

IMPORT O:=Out;

VAR 
  re:REAL;

PROCEDURE P;
VAR pre:REAL; 

  PROCEDURE Q;
  VAR qre:REAL;
  BEGIN (* Q *)
   qre:=2.0; 
   O.Real(qre); O.Ln;
   
   O.Real(pre); O.Ln;
  END Q;
  
BEGIN (* P *)
 pre:=3.0; 
 Q;
END P;

BEGIN (* Simple06 *)
 re:=1.0; 
 O.Real(re); O.Ln;
 
 P;
END Simple06.

