(* Appendix C: The module SYSTEM                                              *)
(* Another type exported by module SYSTEM is the type PTR. Variables of       *)
(* any pointer type may be assigned to variables of type PTR.                 *)

MODULE eapc003t;
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
  P    : SYS.PTR;

BEGIN
 P:=prec;
 P:=parr;
END eapc003t.
