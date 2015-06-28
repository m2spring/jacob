(* Appendix C: The module SYSTEM                                              *)
(* The procedures of the modul SYSTEM                                         *)

MODULE eapc005t;
IMPORT SYS:=SYSTEM;

TYPE
  trecord    = RECORD
                 f:SHORTINT;
                END;

  tpointer   = POINTER TO trecord;

  tprocedure = PROCEDURE(A:SET);

  tarray     = ARRAY 10 OF CHAR;

VAR
  si   : SHORTINT;
  i    : INTEGER;
  li   : LONGINT;
  r    : REAL;
  lr   : LONGREAL;
  c    : CHAR;
  b    : BOOLEAN;
  s    : SET;
  ptr  : tpointer;
  pro  : tprocedure;
  byte : SYS.BYTE;
  rec  : trecord;
  arr  : tarray;

(* Proper procedures *)


(* GET *)

PROCEDURE PGet;
VAR
  a : LONGINT;
BEGIN
 SYS.GET(a,si);
 SYS.GET(a,i);
 SYS.GET(a,li);
 SYS.GET(a,r);
 SYS.GET(a,lr);
 SYS.GET(a,c);
 SYS.GET(a,b);
 SYS.GET(a,s);
 SYS.GET(a,ptr);
 SYS.GET(a,pro);
END PGet;


(* PUT *)

PROCEDURE PPut;
VAR
  a : LONGINT;
BEGIN
 SYS.PUT(a,si);
 SYS.PUT(a,i);
 SYS.PUT(a,li);
 SYS.PUT(a,r);
 SYS.PUT(a,lr);
 SYS.PUT(a,c);
 SYS.PUT(a,b);
 SYS.PUT(a,s);
 SYS.PUT(a,ptr);
 SYS.PUT(a,pro);

 SYS.PUT(a,12);
 SYS.PUT(a,2.0);
 SYS.PUT(a,'A');
 SYS.PUT(a,TRUE);
END PPut;


(* GETREG *)

PROCEDURE PGetReg;
BEGIN
 SYS.GETREG(1,si);
 SYS.GETREG(0,i);
 SYS.GETREG(400,li);
 SYS.GETREG(MAX(LONGINT),r);
 SYS.GETREG(1,lr);
 SYS.GETREG(1,c);
 SYS.GETREG(1,b);
 SYS.GETREG(1,s);
 SYS.GETREG(1,ptr);
 SYS.GETREG(1,pro);
END PGetReg;


(* PUTREG *)

PROCEDURE PPutReg;
BEGIN
 SYS.PUTREG(1,si);
 SYS.PUTREG(0,i);
 SYS.PUTREG(400,li);
 SYS.PUTREG(MAX(LONGINT),r);
 SYS.PUTREG(1,lr);
 SYS.PUTREG(1,c);
 SYS.PUTREG(1,b);
 SYS.PUTREG(1,s);
 SYS.PUTREG(1,ptr);
 SYS.PUTREG(1,pro);

 SYS.PUTREG(1,'Z');
 SYS.PUTREG(1,TRUE);
 SYS.PUTREG(1,2.0);
 SYS.PUTREG(1,{1,2,3});
END PPutReg;


(* MOVE *)

PROCEDURE PMove;
VAR
  a0, a1 : LONGINT;
BEGIN
 SYS.MOVE(a0,a0,8);
 SYS.MOVE(a0,a1,si);
 SYS.MOVE(a0,a1,i);
 SYS.MOVE(a0,a1,li);
END PMove;


(* NEW *)

PROCEDURE PNew;
TYPE
  tr = RECORD END;
  ta = ARRAY 3 OF CHAR;

VAR
  pr : POINTER TO tr;
  pa : POINTER TO ta;
BEGIN
 SYS.NEW(pr,100);
 SYS.NEW(pa,2000);
END PNew;

(* Function procedures *)

(* ADR *)

BEGIN
 li:=SYS.ADR(si);
 li:=SYS.ADR(i);
 li:=SYS.ADR(li);
 li:=SYS.ADR(r);
 li:=SYS.ADR(lr);
 li:=SYS.ADR(c);
 li:=SYS.ADR(b);
 li:=SYS.ADR(s);
 li:=SYS.ADR(byte);
 li:=SYS.ADR(rec);
 li:=SYS.ADR(ptr);
 li:=SYS.ADR(arr);
 li:=SYS.ADR(pro);


(* BIT *)

 b:=SYS.BIT(li,0);
 b:=SYS.BIT(li,si);
 b:=SYS.BIT(li,i);
 b:=SYS.BIT(li,li);


(* CC *)

 b:=SYS.CC(0);
 b:=SYS.CC(15);


(* LSH *)

 i   :=SYS.LSH(i,si);
 li  :=SYS.LSH(li,2);
 c   :=SYS.LSH(c,1);
 c   :=SYS.LSH(c,si);
 byte:=SYS.LSH(byte,2);
 byte:=SYS.LSH(byte,li);


(* ROT *)

 i   :=SYS.ROT(i,si);
 li  :=SYS.ROT(li,2);
 c   :=SYS.ROT(c,1);
 c   :=SYS.ROT(c,si);
 byte:=SYS.ROT(byte,2);
 byte:=SYS.ROT(byte,li);


(* VAL *)

si   := SYS.VAL(SHORTINT,li);
i    := SYS.VAL(INTEGER,arr);
li   := SYS.VAL(LONGINT,rec);
r    := SYS.VAL(REAL,byte);
lr   := SYS.VAL(LONGREAL,c);
c    := SYS.VAL(CHAR,si);
b    := SYS.VAL(BOOLEAN,ptr);
s    := SYS.VAL(SET,rec);
byte := SYS.VAL(SYS.BYTE,pro);
rec  := SYS.VAL(trecord,ptr);
ptr  := SYS.VAL(tpointer,r);
arr  := SYS.VAL(tarray,lr);
pro  := SYS.VAL(tprocedure,si);

END eapc005t.

