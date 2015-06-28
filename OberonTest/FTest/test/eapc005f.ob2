(* Appendix C: The module SYSTEM                                              *)
(* The procedures of the modul SYSTEM                                         *)

MODULE eapc005f;
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
 SYS.GET(i,si);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 42,10                                             *)

 SYS.GET(a,arr);
(*         ^--- Actual parameter not compatible with formal *)
(* Pos: 46,12                                               *)

 SYS.GET(a,rec);
(*         ^--- Actual parameter not compatible with formal *)
(* Pos: 50,12                                               *)

 SYS.GET(lr,r);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 54,10                                             *)

 SYS.GET(s,lr);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 58,10                                             *)

END PGet;

(* PUT *)

PROCEDURE PPut;
VAR
  a : LONGINT;
BEGIN
 SYS.PUT(i,si);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 70,10                                             *)

 SYS.PUT(a,arr);
(*         ^--- Actual parameter not compatible with formal *)
(* Pos: 74,12                                               *)

 SYS.PUT(a,rec);
(*         ^--- Actual parameter not compatible with formal *)
(* Pos: 78,12                                               *)

 SYS.PUT(lr,r);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 82,10                                             *)

 SYS.PUT(s,lr);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 86,10                                             *)

END PPut;

(* GETREG *)

PROCEDURE PGetReg;
BEGIN
 SYS.GETREG(si,si);
(*          ^--- Expression not constant *)
(* Pos: 96,13                            *)

 SYS.GETREG(i,i);
(*          ^--- Expression not constant *)
(* Pos: 100,13                           *)

 SYS.GETREG(li,li);
(*          ^--- Expression not constant *)
(* Pos: 104,13                           *)

 SYS.GETREG(1,arr);
(*            ^--- Actual parameter not compatible with formal *)
(* Pos: 108,15                                                 *)

 SYS.GETREG(1,rec);
(*            ^--- Actual parameter not compatible with formal *)
(* Pos: 112,15                                                 *)

END PGetReg;

(* PUTREG *)

PROCEDURE PPutReg;
BEGIN
 SYS.PUTREG(si,si);
(*          ^--- Expression not constant *)
(* Pos: 122,13                           *)

 SYS.PUTREG(i,i);
(*          ^--- Expression not constant *)
(* Pos: 126,13                           *)

 SYS.PUTREG(li,li);
(*          ^--- Expression not constant *)
(* Pos: 130,13                           *)

 SYS.PUTREG(1,arr);
(*            ^--- Actual parameter not compatible with formal *)
(* Pos: 134,15                                                 *)

 SYS.PUTREG(1,rec);
(*            ^--- Actual parameter not compatible with formal *)
(* Pos: 138,15                                                 *)

END PPutReg;

(* MOVE *)

PROCEDURE PMove;
VAR
  a0, a1 : LONGINT;
BEGIN
 SYS.MOVE(a0,lr,8);
(*           ^--- Actual parameter not compatible with formal *)
(* Pos: 150,14                                                *)

 SYS.MOVE(i,i,r);
(*        ^-^-^--- Actual parameter not compatible with formal *)
(* Pos: 154,11; 154,13; 154,15                                 *)

 SYS.MOVE(a0,a1,s);
(*              ^--- Actual parameter not compatible with formal *)
(* Pos: 158,17                                                   *)

 SYS.MOVE(a0,a1,c);
(*              ^--- Actual parameter not compatible with formal *)
(* Pos: 162,17                                                   *)

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
 SYS.NEW(rec,100);
(*       ^--- Actual parameter not compatible with formal *)
(* Pos: 179,10                                            *)

 SYS.NEW(pa,r);
(*          ^--- Actual parameter not compatible with formal *)
(* Pos: 183,13                                               *)

END PNew;


(* Function procedures *)

(* ADR *)

BEGIN
 i:=SYS.ADR(si);
(*  ^--- Expression not assignment compatible *)
(* Pos: 195,5                                 *)

 si:=SYS.ADR(i);
(*   ^--- Expression not assignment compatible *)
(* Pos: 199,6                                  *)

(* BIT *)

 b:=SYS.BIT(li,r);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 205,16                                                  *)

 b:=SYS.BIT(li,s);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 209,16                                                  *)

 b:=SYS.BIT(li,c);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 213,16                                                  *)

 b:=SYS.BIT(i,3);
(*          ^--- Actual parameter not compatible with formal *)
(* Pos: 217,13                                               *)


(* CC *)

 c:=SYS.CC(0);
(*  ^--- Expression not assignment compatible *)
(* Pos: 224,5                                 *)

 b:=SYS.CC(i);
(*         ^--- Expression not constant *)
(* Pos: 228,12                          *)


(* LSH *)

 i   :=SYS.LSH(r,si);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 235,16                                                  *)

 li  :=SYS.LSH(lr,2);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 239,16                                                  *)

 i   :=SYS.LSH(c,1);
(*     ^--- Expression not assignment compatible *)
(* Pos: 243,8                                    *)

 li  :=SYS.LSH(c,si);
(*     ^--- Expression not assignment compatible *)
(* Pos: 247,8                                    *)

 c   :=SYS.LSH(byte,2);
(*     ^--- Expression not assignment compatible *)
(* Pos: 251,8                                    *)

 byte:=SYS.LSH(r,li);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 255,16                                                  *)


(* ROT *)

 i   :=SYS.ROT(r,si);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 262,16                                                  *)

 li  :=SYS.ROT(lr,2);
(*             ^--- Actual parameter not compatible with formal *)
(* Pos: 266,16                                                  *)

 i   :=SYS.ROT(c,1);
(*     ^--- Expression not assignment compatible *)
(* Pos: 270,8                                    *)

 c   :=SYS.ROT(c,r);
(*               ^--- Actual parameter not compatible with formal *)
(* Pos: 274,18                                                    *)

 c   :=SYS.ROT(byte,2);
(*     ^--- Expression not assignment compatible *)
(* Pos: 278,8                                    *)

 byte:=SYS.ROT(byte,lr);
(*                  ^--- Actual parameter not compatible with formal *)
(* Pos: 282,21                                                       *)


(* VAL *)

s    := SYS.VAL(LONGINT,rec);
(*      ^--- Expression not assignment compatible *)
(* Pos: 289,9                                     *)

END eapc005f.

