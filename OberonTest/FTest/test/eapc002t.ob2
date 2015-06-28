(* Appendix C: The module SYSTEM                                              *)
(* If a formal variable parameter is of type ARRAY OF BYTE then the           *)
(* corresponding actual parameter may be of any type.                         *)

MODULE eapc002t;
IMPORT SYS:=SYSTEM;

TYPE
  trecord    = RECORD
                 f:SHORTINT;
                END;

  tpointer   = POINTER TO trecord;

  tprocedure = PROCEDURE(A:SET);

  tarray     = ARRAY 10 OF CHAR;


VAR
   si : SHORTINT;
   i  : INTEGER;
   li : LONGINT;
   r  : REAL;
   lr : LONGREAL;
   s  : SET;
   c  : CHAR;
   b  : BOOLEAN;
   rec: trecord;
   ptr: tpointer;
   arr: tarray;
   pro: tprocedure;

PROCEDURE P(VAR a:ARRAY OF SYS.BYTE); END P;

BEGIN
 P(si);
 P(i);
 P(li);
 P(r);
 P(lr);
 P(s);
 P(c);
 P(b);
 P(rec);
 P(ptr);
 P(arr);
 P(pro);
END eapc002t.

