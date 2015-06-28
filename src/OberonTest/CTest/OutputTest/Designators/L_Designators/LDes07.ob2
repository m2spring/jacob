MODULE LDes07;
(*% Extern variable assignments *)

IMPORT L:=LDes01;

VAR PO:L.TPO;
    PR:L.TPR;
     
BEGIN (* LDes07 *)
 L.bo:=TRUE;
 L.ch:=41X;
 L.si:=6;
 L.in:=4711;
 L.li:=80000;
 L.re:=2.0;
 L.lr:=2.0D0;
 L.se:={};
 L.po:=PO;
 L.pr:=PR;
END LDes07.
