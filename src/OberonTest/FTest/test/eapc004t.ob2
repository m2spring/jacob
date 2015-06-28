(* Appendix C: The module SYSTEM                                              *)
(* If a formal variable parameter is of type PTR, the actual parameter may    *)
(* be of any pointer type.                                                    *)

MODULE eapc004t;
IMPORT SYS:=SYSTEM;

TYPE
  trecord    = RECORD
                 f:SHORTINT;
                END;
  tarray     = ARRAY 10 OF CHAR;

  trecpointer = POINTER TO trecord;
  tarrpointer = POINTER TO tarray;

VAR
  prec : trecpointer;
  parr : tarrpointer;

PROCEDURE P(VAR p:SYS.PTR); END P;

BEGIN
 P(prec);
 P(parr);
END eapc004t.
