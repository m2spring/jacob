MODULE LDes05;
(*% Global, local and outer Variables *)

VAR 
 bo:BOOLEAN; 
 ch:CHAR; 

PROCEDURE P1;
VAR 
 si:SHORTINT; 
 in:INTEGER; 
 li:LONGINT; 
BEGIN (* P1 *)
END P1;

 PROCEDURE P2;
 VAR 
  si:SHORTINT; 
  in:INTEGER; 
  li:LONGINT; 

  PROCEDURE P3;
  VAR 
   re:REAL;
   lr:LONGREAL;
   se:SET;

   PROCEDURE P4;
   VAR
    pr: PROCEDURE;
    po: POINTER TO ARRAY OF CHAR; 
   BEGIN (* P4 *)
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
   END P4;

  BEGIN (* P3 *)
  END P3;

BEGIN (* P2 *)
END P2;

BEGIN (* LDes05 *)
END LDes05.
