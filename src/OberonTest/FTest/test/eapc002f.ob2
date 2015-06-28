(* Appendix C: The module SYSTEM                                              *)
(* If a formal variable parameter is of type ARRAY OF BYTE then the           *)
(* corresponding actual parameter may be of any type.                         *)

MODULE eapc002f;
IMPORT SYS:=SYSTEM;

TYPE
  trecord    = RECORD
                 f:SHORTINT;
                END;

  tpointer   = POINTER TO trecord;

VAR
   si : SHORTINT;
   i  : INTEGER;
   rec: trecord;
   ptr: tpointer;

PROCEDURE P(a:ARRAY OF SYS.BYTE); END P;

BEGIN
 P(si);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 24,4                                        *)

 P(i);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 28,4                                        *)

 P(rec);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 32,4                                        *)

 P(ptr);
(* ^--- Actual parameter not compatible with formal *)
(* Pos: 36,4                                        *)
END eapc002f.

