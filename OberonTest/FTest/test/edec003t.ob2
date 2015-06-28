(* 4. Declaration and scope rules                                      *)
(* "It excludes the scopes of equally named objects which are declared *)
(* in nested blocks."                                                  *)

MODULE edec003t;

VAR
  b : REAL;
  c : BOOLEAN;

PROCEDURE proc;
VAR
  b, c : CHAR;

BEGIN
 b := CAP(c);
END proc;


BEGIN (* te02 *)
 b := 0.0;
 c := TRUE;
END edec003t.
