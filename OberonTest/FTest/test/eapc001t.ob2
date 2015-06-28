(* Appendix C: The module SYSTEM                                              *)
(* Module SYSTEM exports a type BYTE with the following characteristics:      *)
(* Variables of type CHAR or SHORTINT can be assigned to variables of type    *)
(* BYTE.                                                                      *)

MODULE eapc001t;
IMPORT SYS:=SYSTEM;

VAR
  c  : CHAR;
  si : SHORTINT;
  b  : SYS.BYTE;

PROCEDURE P(VAR b:SYS.BYTE); END P;

BEGIN
  b:=c;
  b:=si;
  P(c);
  P(si);
END eapc001t.
