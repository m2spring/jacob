(* 10.1 Formal parameters                                                     *)
(* Let Tf be the type of a formal parameter f (not an open array) and Ta      *)
(* the type of the corresponding actual parameter a.                          *)
(* [...]                                                                      *)
(* For value parameters, a must be assignment compatible with f (see App.     *)
(* A).                                                                        *)

MODULE epfp004f;

TYPE
  T0 = RECORD
       END;

  T1 = RECORD(T0)
       END;

VAR
 i  : REAL;
 r0 : T0;

PROCEDURE Q(f:INTEGER);
BEGIN
END Q;

PROCEDURE P(f:T1);
BEGIN
END P;

PROCEDURE R(f:ARRAY 4 OF CHAR);
BEGIN
END R;

BEGIN
 Q(i);
(* ^--- Actual parameter not compatible with formal *)

 P(r0);
(* ^--- Actual parameter not compatible with formal *)

 R('ABCDE');
(* ^--- Actual parameter not compatible with formal *)

END epfp004f.
