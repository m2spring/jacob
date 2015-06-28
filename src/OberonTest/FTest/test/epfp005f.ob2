(* 10.1 Formal parameters                                                     *)
(* Let Tf be the type of a formal parameter f (not an open array) and Ta      *)
(* the type of the corresponding actual parameter a.                          *)
(* [...]                                                                      *)
(* If Tf is an open array , then a must be array compatible with f (see       *)
(* App. A). The lengths of f are taken from a.                                *)

MODULE epfp005f;

VAR a: ARRAY 4, 5 OF INTEGER;

PROCEDURE P(f:ARRAY OF ARRAY OF CHAR);
BEGIN
END P;

BEGIN
 P(a);
(* ^--- Actual parameter not compatible with formal *)

END epfp005f.
