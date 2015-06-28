(* 10.3 Predeclared procedures                                                *)
(* The following table lists the predeclared procedures. Some are generic     *)
(* procedures, i.e. they apply to several types of operands. v stands for a   *)
(* variable, x and n for expressions, and T for a type.                       *)

MODULE eppr001f;

(* Function procedures *)

CONST

(* ABS *)

  abs1 = ABS(TRUE);
(*           ^--- Actual parameter not compatible with formal *)


(* ASH *)

  ash1 = ASH(4,2.0);
(*             ^--- Actual parameter not compatible with formal *)

  ash2 = ASH(3.4D0,1);
(*           ^--- Actual parameter not compatible with formal *)

  ash3 = ASH(TRUE,{});
(*           ^----^--- Actual parameter not compatible with formal *)

  ash4 = ASH({1,2},1);
(*           ^--- Actual parameter not compatible with formal *)

(* CAP *)

  cap1 = CAP(1);
(*           ^--- Actual parameter not compatible with formal *)

  cap2 = CAP(TRUE);
(*           ^--- Actual parameter not compatible with formal *)

  cap3 = CAP(3.4);
(*           ^--- Actual parameter not compatible with formal *)

(* CHR *)

  chr1 = CHR(2.0);
(*           ^--- Actual parameter not compatible with formal *)

  chr2 = CHR(TRUE);
(*           ^--- Actual parameter not compatible with formal *)

  chr3 = CHR({});
(*           ^--- Actual parameter not compatible with formal *)

(* ENTIER *)

  ent1 = ENTIER(2);
(*              ^--- Actual parameter not compatible with formal *)

  ent2 = ENTIER(MIN(INTEGER));
(*              ^--- Actual parameter not compatible with formal *)

  ent3 = ENTIER(TRUE);
(*              ^--- Actual parameter not compatible with formal *)

  ent4 = ENTIER('a');
(*              ^--- Actual parameter not compatible with formal *)

  ent5 = ENTIER({1});
(*              ^--- Actual parameter not compatible with formal *)


(* LONG *)

  long1 = LONG(MIN(LONGREAL));
(*             ^--- Actual parameter not compatible with formal *)

  long2 = LONG(SET);
(*             ^--- Actual parameter not compatible with formal *)

  long3 = LONG(MAX(LONGINT));
(*             ^--- Actual parameter not compatible with formal *)

(* MAX *)

TYPE
  tmaxrecord    = RECORD END;
  tmaxarray     = ARRAY 1 OF CHAR;
  tmaxpointer   = POINTER TO tmaxrecord;
  tmaxprocedure = PROCEDURE (i:SET);

CONST
  max1 = MAX(tmaxrecord);
(*           ^--- Actual parameter not compatible with formal *)

  max2 = MAX(tmaxarray);
(*           ^--- Actual parameter not compatible with formal *)

  max3 = MAX(tmaxpointer);
(*           ^--- Actual parameter not compatible with formal *)

  max4 = MAX(tmaxprocedure);
(*           ^--- Actual parameter not compatible with formal *)


(* MIN *)

TYPE
  tminrecord    = RECORD END;
  tminarray     = ARRAY 1 OF CHAR;
  tminpointer   = POINTER TO tminrecord;
  tminprocedure = PROCEDURE (i:SET);

CONST
  min1 = MIN(tminrecord);
(*           ^--- Actual parameter not compatible with formal *)

  min2 = MIN(tminarray);
(*           ^--- Actual parameter not compatible with formal *)

  min3 = MIN(tminpointer);
(*           ^--- Actual parameter not compatible with formal *)

  min4 = MIN(tminprocedure);
(*           ^--- Actual parameter not compatible with formal *)


(* ODD *)

  odd1 = ODD(2.3);
(*           ^--- Actual parameter not compatible with formal *)

  odd2 = ODD(1.0D0);
(*           ^--- Actual parameter not compatible with formal *)

  odd3 = ODD(TRUE);
(*           ^--- Actual parameter not compatible with formal *)

  odd4 = ODD({});
(*           ^--- Actual parameter not compatible with formal *)

(* ORD *)

  ord1 = ORD(1);
(*           ^--- Actual parameter not compatible with formal *)

  ord2 = ORD(2.0);
(*           ^--- Actual parameter not compatible with formal *)

  ord3 = ORD({2});
(*           ^--- Actual parameter not compatible with formal *)

(* SHORT *)

  short1 = SHORT(12);
(*               ^--- Actual parameter not compatible with formal *)

  short2 = SHORT(2.0);
(*               ^--- Actual parameter not compatible with formal *)

  short3 = SHORT(TRUE);
(*               ^--- Actual parameter not compatible with formal *)

(* LEN *)

VAR
  vlen1 : ARRAY 3,4,5 OF INTEGER;
  vlen2 : ARRAY 1,4,8,10 OF BOOLEAN;

CONST

  len1 = LEN(vlen1,3);
(*                 ^--- Illegal LEN dimension *)

  len2 = LEN(vlen2,4);
(*                 ^--- Illegal LEN dimension *)

(* Proper procedures *)

(* ASSERT *)

PROCEDURE PAssert;
BEGIN
 ASSERT(1);
(*      ^--- Actual parameter not compatible with formal *)

 ASSERT(12.0);
(*      ^--- Actual parameter not compatible with formal *)

 ASSERT({});
(*      ^--- Actual parameter not compatible with formal *)

 ASSERT('A');
(*      ^--- Actual parameter not compatible with formal *)


 ASSERT(TRUE,2.0);
(*           ^--- Actual parameter not compatible with formal *)

 ASSERT(FALSE,1.0D0);
(*            ^--- Actual parameter not compatible with formal *)

 ASSERT(1<2,{});
(*          ^--- Actual parameter not compatible with formal *)

END PAssert;

(* COPY *)

PROCEDURE PCopy;
VAR
  x  : ARRAY 10 OF CHAR;
  v : ARRAY 5 OF CHAR;
BEGIN
 COPY(TRUE,x);
(*    ^--- Actual parameter not compatible with formal *)

 COPY(2,v);
(*    ^--- Actual parameter not compatible with formal *)

END PCopy;


(* DEC *)

PROCEDURE PDec;
VAR
 r  : REAL;
 lr : LONGREAL;
 s  : SET;
 c  : CHAR;
 b  : BOOLEAN;
BEGIN
 DEC(r);
(*   ^--- Actual parameter not compatible with formal *)

 DEC(lr);
(*   ^--- Actual parameter not compatible with formal *)

 DEC(s);
(*   ^--- Actual parameter not compatible with formal *)

 DEC(c);
(*   ^--- Actual parameter not compatible with formal *)

 DEC(b);
(*   ^--- Actual parameter not compatible with formal *)

 DEC(r,1);
(*   ^--- Actual parameter not compatible with formal *)

 DEC(lr,r);
(*   ^--^--- Actual parameter not compatible with formal *)

 DEC(s,{});
(*   ^-^--- Actual parameter not compatible with formal *)

END PDec;

(* EXCL *)

PROCEDURE PExcl;
VAR
 si : SHORTINT;
 i  : INTEGER;
 li : LONGINT;
 s  : SET;
BEGIN
 EXCL(si,1);
(*    ^--- Actual parameter not compatible with formal *)

 EXCL(i,12);
(*    ^--- Actual parameter not compatible with formal *)

 EXCL(li,3);
(*    ^--- Actual parameter not compatible with formal *)

 EXCL(s,TRUE);
(*      ^--- Actual parameter not compatible with formal *)
(*  *)

 EXCL(s,s);
(*      ^--- Actual parameter not compatible with formal *)

END PExcl;

(* HALT *)

PROCEDURE PHalt;
BEGIN
 HALT(2.0);
(*    ^--- Actual parameter not compatible with formal *)

 HALT(TRUE);
(*    ^--- Actual parameter not compatible with formal *)

 HALT({});
(*    ^--- Actual parameter not compatible with formal *)

 HALT('A');
(*    ^--- Actual parameter not compatible with formal *)

END PHalt;

(* INC *)

PROCEDURE PInc;
VAR
 r  : REAL;
 lr : LONGREAL;
 s  : SET;
 c  : CHAR;
 b  : BOOLEAN;
BEGIN
 INC(r);
(*   ^--- Actual parameter not compatible with formal *)

 INC(lr);
(*   ^--- Actual parameter not compatible with formal *)

 INC(s);
(*   ^--- Actual parameter not compatible with formal *)

 INC(c);
(*   ^--- Actual parameter not compatible with formal *)

 INC(b);
(*   ^--- Actual parameter not compatible with formal *)

 INC(r,1);
(*   ^--- Actual parameter not compatible with formal *)

 INC(lr,r);
(*   ^--^--- Actual parameter not compatible with formal *)

 INC(s,{});
(*   ^-^--- Actual parameter not compatible with formal *)

END PInc;

(* INCL *)

PROCEDURE PIncl;
VAR
 si : SHORTINT;
 i  : INTEGER;
 li : LONGINT;
 s  : SET;
BEGIN
 INCL(si,2);
(*    ^--- Actual parameter not compatible with formal *)

 INCL(i,{});
(*    ^-^--- Actual parameter not compatible with formal *)

 INCL(li,2.0);
(*    ^--^--- Actual parameter not compatible with formal *)

 INCL(s,s);
(*      ^--- Actual parameter not compatible with formal *)

END PIncl;

(* NEW *)

PROCEDURE PNew;
TYPE
  topen1 = POINTER TO ARRAY OF CHAR;
  topen2 = POINTER TO ARRAY OF ARRAY OF INTEGER;
  topen3 = POINTER TO ARRAY OF ARRAY OF ARRAY OF SHORTINT;

VAR
  popen1 : topen1;
  popen2 : topen2;
  popen3 : topen3;

  si : SHORTINT;
  i  : INTEGER;
  li : LONGINT;
  r  : REAL;
  lr : LONGREAL;
  s  : SET;
  b  : BOOLEAN;
BEGIN
 NEW(si);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(i);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(li);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(r);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(lr);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(s);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(b);
(*   ^--- Actual parameter not compatible with formal *)

 NEW(popen1);
(*         ^--- Too few actual parameters *)

 NEW(popen1,1,2);
(*            ^--- Too many actual parameters *)

 NEW(popen2,3);
(*           ^--- Too few actual parameters *)

 NEW(popen2,1.0,2,3);
(*          ^--- Actual parameter not compatible with formal *)
(*                ^--- Too many actual parameters            *)

 NEW(popen3,1,2);
(*             ^--- Too few actual parameters *)

 NEW(popen3,1,'a',3,4);
(*            ^--- Actual parameter not compatible with formal *)
(*                  ^--- Too many actual parameters            *)

END PNew;

END eppr001f.
