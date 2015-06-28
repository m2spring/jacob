(*$! oc -it -kt -cmt -Ss Disp1 #*)
MODULE Disp1;

VAR i:INTEGER; 

PROCEDURE P1;
BEGIN (* P1 *)
END P1;

PROCEDURE Q1;
BEGIN (* Q1 *)
 P1;
END Q1;

PROCEDURE R1;

 PROCEDURE R2;
 
  PROCEDURE R3;
  BEGIN (* R3 *)
  END R3;

 BEGIN (* R2 *)
  R1; R2; R3;
 END R2;

BEGIN (* R1 *)
END R1;

PROCEDURE F1():REAL; 
VAR i:REAL;

 PROCEDURE F2():REAL; 
 BEGIN (* F2 *)           
  i:=F1(); 
  RETURN 1; 
 END F2;

BEGIN (* F1 *) 
 i:=F1(); 
 i:=F2(); 
 RETURN 0; 
END F1;

BEGIN (* Disp1 *)           
 P1;
END Disp1.
