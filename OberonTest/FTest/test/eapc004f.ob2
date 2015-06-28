(* Appendix C: The module SYSTEM                                              *)
(* If a formal variable parameter is of type PTR, the actual parameter may    *)
(* be of any pointer type.                                                    *)

MODULE eapc004f;
IMPORT SYS:=SYSTEM;

TYPE
  trecord    = RECORD
                 f:SHORTINT;
                END;
  tarray     = ARRAY 10 OF CHAR;

  trecpointer = POINTER TO trecord;
  tarrpointer = POINTER TO tarray;

VAR
  rec : trecord;
  arr : tarray;

PROCEDURE P(p:SYS.PTR); END P;

BEGIN
 P(rec);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 24,4                                        *)

 P(arr);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 28,4                                        *)

END eapc004f.

