MODULE Simple04;
(*% Simple Designators: INTEGER *)

IMPORT O:=Out;

VAR 
  in:INTEGER; 

PROCEDURE P;
VAR pin:INTEGER; 

  PROCEDURE Q;
  VAR qin:INTEGER; 
  BEGIN (* Q *)
   qin:=400; 
   O.Int(qin); O.Ln;
   
   O.Int(pin); O.Ln;
  END Q;
  
BEGIN (* P *)
 pin:=500; 
 Q;
END P;

BEGIN (* Simple04 *)
 in:=300; 
 O.Int(in); O.Ln;
 
 P;
END Simple04.

