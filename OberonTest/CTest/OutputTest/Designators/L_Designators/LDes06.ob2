MODULE LDes06;
(*% Parameters with extern Values *)

IMPORT L:=LDes01;

PROCEDURE P1;
BEGIN (* P1 *)
END P1;

PROCEDURE P2( VAR bo:BOOLEAN; 
              VAR ch:CHAR; 
              VAR si:SHORTINT; 
              VAR in:INTEGER; 
              VAR li:LONGINT; 
              VAR re:REAL;
              VAR lr:LONGREAL;
              VAR se:SET;
              VAR po: L.TPO;
              VAR pr: L.TPR
            );
BEGIN (* P2 *)
END P2;

BEGIN (* LDes06 *)
 P2(L.bo,
    L.ch,
    L.si,
    L.in,
    L.li,
    L.re,
    L.lr,
    L.se,
    L.po,
    L.pr);
END LDes06.
