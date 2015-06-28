MODULE Simple08;
(*% Simple Designators: SET *)

IMPORT O:=Out;

VAR 
  se:SET;

PROCEDURE P;
VAR pse:SET; 

  PROCEDURE Q;
  VAR qse:SET;
  BEGIN (* Q *)
   qse:={19..21,23,25,28..31};
   O.Set(qse); O.Ln;
   
   O.Set(pse); O.Ln;
  END Q;
  
BEGIN (* P *)
 pse:={5,6..8,9,11,13..17};
 Q;
END P;

BEGIN (* Simple08 *)
 se:={1,2..4};
 O.Set(se); O.Ln;
 
 P;
END Simple08.

