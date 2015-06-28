MODULE LDes01;
(*% Server-Module for extern Variables *)

TYPE TPO* = POINTER TO ARRAY OF CHAR;
     TPR* = PROCEDURE;
VAR 
 bo*:BOOLEAN; 
 ch*:CHAR; 
 si*:SHORTINT; 
 in*:INTEGER; 
 li*:LONGINT; 
 re*:REAL;
 lr*:LONGREAL;
 se*:SET;
 po*: TPO;
 pr*: TPR;

PROCEDURE P;
BEGIN (* P *)
END P;

BEGIN (* LDes01 *)
 bo:=TRUE; 
 ch:=0X; 
 si:=2; 
 in:=128; 
 li:=2000000; 
 re:=2.0; 
 lr:=2.0D0;
 se:={}; 
 po:=NIL; 
 pr:=P; 
END LDes01.
