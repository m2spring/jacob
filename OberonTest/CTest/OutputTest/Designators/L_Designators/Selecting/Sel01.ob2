MODULE Sel01;
(*% Global, local and outer variables *)

TYPE tProc = PROCEDURE;
     tPtr  = POINTER TO ARRAY OF CHAR;
     tRec1 = RECORD
              bo:BOOLEAN; 
              ch:CHAR; 
              si:SHORTINT; 
              in:INTEGER; 
              li:LONGINT; 
              re:REAL;
              lr:LONGREAL;
              se:SET;
              po: tPtr;
              pr: tProc;
             END;

VAR r:tRec1;                  (* Global *)

PROCEDURE RDesProc;
BEGIN (* RDesProc *)
END RDesProc;

PROCEDURE P2;
VAR rloc:tRec1;               (* Local *)

   PROCEDURE P3;
   BEGIN (* P3 *)
    rloc.bo:=TRUE;            (* Outer *)
    rloc.ch:=41X;
    rloc.si:=1;
    rloc.in:=4711;
    rloc.li:=80000;
    rloc.re:=1.0;
    rloc.lr:=1.0D1;
    rloc.se:={};
    rloc.po:=NIL;
    rloc.pr:=RDesProc;
   END P3;
  
BEGIN (* P2 *)
 rloc.bo:=TRUE;     
 rloc.ch:=41X;
 rloc.si:=1;
 rloc.in:=4711;
 rloc.li:=80000;
 rloc.re:=1.0;
 rloc.lr:=1.0D1;
 rloc.se:={};
 rloc.po:=NIL;
 rloc.pr:=RDesProc;
END P2;

BEGIN (* Sel01 *)
  r.bo:=TRUE;
  r.ch:=41X;
  r.si:=1;
  r.in:=4711;
  r.li:=80000;
  r.re:=1.0;
  r.lr:=1.0D1;
  r.se:={};
  r.po:=NIL;
  r.pr:=RDesProc;
END Sel01.

