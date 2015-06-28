MODULE Simple09;
(*% Simple Designators: FIXED ARRAY OF CHAR *)

IMPORT O:=Out;

VAR 
  st:ARRAY 20 OF CHAR; 

PROCEDURE P;
VAR pst:ARRAY 20 OF CHAR; 

  PROCEDURE Q;
  VAR qst:ARRAY 20 OF CHAR;
  BEGIN (* Q *)
   qst:='Der zweite String';
   O.String(qst); O.Ln;
   
   O.String(pst); O.Ln;
  END Q;
  
BEGIN (* P *)
 pst:="Der dritte String"; 
 Q;
END P;

BEGIN (* Simple09 *)
 st:='Der erste String'; 
 O.String(st); O.Ln;
 
 P;
END Simple09.

