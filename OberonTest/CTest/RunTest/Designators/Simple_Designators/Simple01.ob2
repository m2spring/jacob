MODULE Simple01;
(*% Simple Designators: BOOLEAN *)

IMPORT O:=Out;

VAR 
  bo : BOOLEAN; 

PROCEDURE P;
VAR pbo : BOOLEAN; 

  PROCEDURE Q;
  VAR qbo : BOOLEAN; 
  BEGIN (* Q *)
   qbo:=FALSE;
   O.Bool(qbo); O.Ln;
   
   O.Bool(pbo); O.Ln;
  END Q;
  
BEGIN (* P *)
 pbo:=TRUE; 
 Q;
END P;

BEGIN (* Simple01 *)
 bo:=TRUE; 
 O.Bool(bo); O.Ln;
 
 P;
END Simple01.

