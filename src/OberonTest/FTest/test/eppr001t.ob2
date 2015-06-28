(* 10.3 Predeclared procedures                                                *)
(* The following table lists the predeclared procedures. Some are generic     *)
(* procedures, i.e. they apply to several types of operands. v stands for a   *)
(* variable, x and n for expressions, and T for a type.                       *)

MODULE eppr001t;

(* Function procedures *)

CONST

(* ABS *)

  csiabs = -1;
  ciabs  = LONG(csiabs);
  cliabs = MIN(LONGINT)+1;
  crabs  = 4.1;
  clrabs = 2.5D0;

  abs1 = ABS(csiabs);
  abs2 = ABS(ciabs);
  abs3 = ABS(cliabs);
  abs4 = ABS(crabs);
  abs5 = ABS(clrabs);


(* ASH *)

  csiash = -2;
  ciash  = 1024;
  cliash = LONG(LONG(2));

  ash1 = ASH(csiash , ciash);
  ash2 = ASH(csiash , cliash);
  ash3 = ASH(ciash  , csiash);
  ash4 = ASH(ciash  , cliash);
  ash5 = ASH(cliash , csiash);
  ash6 = ASH(cliash , cliash);


(* CAP *)

  ccap1 = 'a';
  ccap2 = 0X;
  ccap3 = 'E';

  cap1 = CAP(ccap1);
  cap2 = CAP(ccap2);
  cap3 = CAP(ccap3);


(* CHR *)

  csichr = 65;
  cichr  = LONG(csichr);
  clichr = LONG(LONG(49));

  chr1 = CHR(csichr);
  chr2 = CHR(cichr);
  chr3 = CHR(clichr);


(* ENTIER *)

  cent1 = -2.3;
  cent2 = 44.3D0;
  cent3 = 22.3E2;
  cent4 = 10.5D6;

  ent1 = ENTIER(cent1);
  ent2 = ENTIER(cent2);
  ent3 = ENTIER(cent3);
  ent4 = ENTIER(cent4);


(* LONG *)

  csilong = -12;
  cilong  = MIN(INTEGER);
  crlong  = 2.4E0;

  long1 = LONG(csilong);
  long2 = LONG(cilong);
  long3 = LONG(crlong);


(* MAX *)

  max1 = MAX(BOOLEAN);
  max2 = MAX(CHAR);
  max3 = MAX(SHORTINT);
  max4 = MAX(INTEGER);
  max5 = MAX(LONGINT);
  max6 = MAX(REAL);
  max7 = MAX(LONGREAL);
  max8 = MAX(SET);


(* MIN *)

  min1 = MIN(BOOLEAN);
  min2 = MIN(CHAR);
  min3 = MIN(SHORTINT);
  min4 = MIN(INTEGER);
  min5 = MIN(LONGINT);
  min6 = MIN(REAL);
  min7 = MIN(LONGREAL);
  min8 = MIN(SET);


(* ODD *)

  csiodd = 1;
  ciodd  = -300;
  cliodd = MAX(LONGINT);

  odd1 = ODD(csiodd);
  odd2 = ODD(ciodd);
  odd3 = ODD(cliodd);


(* ORD *)

  ord1 = ORD('A');
  ord2 = ORD(0X);
  ord3 = ORD(chr1);
  ord4 = ORD(chr2);
  ord5 = ORD(chr3);


(* SHORT *)

  clishort = LONG(500);
  cishort  = LONG(200);
  clrshort = 5.0D0;

  short1 = SHORT(clishort);
  short2 = SHORT(cishort);
  short3 = SHORT(clrshort);


(* SIZE *)

TYPE
  trecord    = RECORD
                 f:SHORTINT;
                END;

  tpointer   = POINTER TO trecord;

  tprocedure = PROCEDURE(A:SET);

  tarray     = ARRAY 10 OF CHAR;


CONST
  size1  = SIZE(BOOLEAN);
  size2  = SIZE(CHAR);
  size3  = SIZE(SHORTINT);
  size4  = SIZE(INTEGER);
  size5  = SIZE(LONGINT);
  size6  = SIZE(REAL);
  size7  = SIZE(LONGREAL);
  size8  = SIZE(SET);
  size9  = SIZE(trecord);
  size10 = SIZE(tpointer);
  size11 = SIZE(tprocedure);
  size12 = SIZE(tarray);


(* LEN *)

VAR
  vlen1 : ARRAY 3 OF CHAR;
  vlen2 : ARRAY 3,4,5 OF INTEGER;
  vlen3 : ARRAY 1,4,8,10 OF BOOLEAN;

CONST
  len1  = LEN(vlen1);
  len2  = LEN(vlen2);
  len3  = LEN(vlen3);

  len4  = LEN(vlen2,0);
  len5  = LEN(vlen2,LONG(1));
  len6  = LEN(vlen2,2);

  len7  = LEN(vlen3,0);
  len8  = LEN(vlen3,1);
  len9  = LEN(vlen3,LONG(LONG(2)));
  len10 = LEN(vlen3,3);


(* Proper procedures *)

(* ASSERT *)

PROCEDURE PAssert;
BEGIN
 ASSERT(TRUE);
 ASSERT(FALSE);
 ASSERT(1<2);
 ASSERT('A' > 'Z');

 ASSERT(TRUE,1);
 ASSERT(FALSE,LONG(10));
 ASSERT(1<2,MAX(LONGINT));
END PAssert;


(* COPY *)

PROCEDURE PCopy;
VAR
  v  : ARRAY 10 OF CHAR;
  x : ARRAY 5 OF CHAR;
BEGIN
 COPY('Test',x);
 COPY(x,v);
 COPY('Ein Test',v);
 COPY('A',v);
END PCopy;


(* DEC *)

PROCEDURE PDec;
VAR
 si : SHORTINT;
 i  : INTEGER;
 li : LONGINT;

BEGIN
 DEC(si);
 DEC(i);
 DEC(li);

 DEC(si,1);
 DEC(i,si);
 DEC(li,12);
 DEC(li,si);
 DEC(li,li);
END PDec;


(* EXCL *)

PROCEDURE PExcl;
VAR
 si : SHORTINT;
 i  : INTEGER;
 li : LONGINT;
 s  : SET;
BEGIN
 EXCL(s,si);
 EXCL(s,i);
 EXCL(s,li);
 EXCL(s,12);
 EXCL(s,31);
END PExcl;


(* HALT *)

PROCEDURE PHalt;
BEGIN
 HALT(csiabs);
 HALT(ciabs);
 HALT(cliabs);
END PHalt;


(* INC *)

PROCEDURE PInc;
VAR
 si : SHORTINT;
 i  : INTEGER;
 li : LONGINT;

BEGIN
 INC(si);
 INC(i);
 INC(li);

 INC(si,1);
 INC(i,si);
 INC(li,12);
 INC(li,si);
 INC(li,li);
END PInc;


(* INCL *)

PROCEDURE PIncl;
VAR
 si : SHORTINT;
 i  : INTEGER;
 li : LONGINT;
 s  : SET;
BEGIN
 INCL(s,si);
 INCL(s,i);
 INCL(s,li);
 INCL(s,12);
 INCL(s,31);
END PIncl;


(* NEW *)


PROCEDURE PNew;
TYPE
  trecord = RECORD
             END;
  tarray  = ARRAY 4 OF CHAR;

  tarrpointer = POINTER TO tarray;
  trecpointer = POINTER TO trecord;

  topen1 = POINTER TO ARRAY OF CHAR;
  topen2 = POINTER TO ARRAY OF ARRAY OF INTEGER;
  topen3 = POINTER TO ARRAY OF ARRAY OF ARRAY OF SHORTINT;

VAR
  parr : tarrpointer;
  prec : trecpointer;

  popen1 : topen1;
  popen2 : topen2;
  popen3 : topen3;

BEGIN
 NEW(parr);
 NEW(prec);

 NEW(popen1,3);
 NEW(popen2,1,LONG(20));
 NEW(popen3,5,2,LONG(MAX(INTEGER)));
END PNew;

END eppr001t.

