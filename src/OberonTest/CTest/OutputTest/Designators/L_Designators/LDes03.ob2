MODULE LDes03;
(*% Local Variables of Procedure *)

PROCEDURE P1;
BEGIN (* P1 *)
END P1;

PROCEDURE P2;
VAR 
 bo:BOOLEAN; 
 ch:CHAR; 
 si:SHORTINT; 
 in:INTEGER; 
 li:LONGINT; 
 re:REAL;
 lr:LONGREAL;
 se:SET;
 po: POINTER TO ARRAY OF CHAR; 
 pr: PROCEDURE;

BEGIN (* P2 *)
 bo:=FALSE; 
 ch:=0X; 
 si:=2; 
 in:=128; 
 li:=2000000; 
 re:=2.0; 
 lr:=2.0D0;
 se:={}; 
 po:=NIL; 
 pr:=P1; 
END P2;

BEGIN (* LDes03 *)
END LDes03.
