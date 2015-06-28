(* 10.1 Formal parameters                                                     *)
(* Let Tf be the type of a formal parameter f (not an open array) and Ta      *)
(* the type of the corresponding actual parameter a.                          *)
(* [...]                                                                      *)
(* For value parameters, a must be assignment compatible with f (see App.     *)
(* A).                                                                        *)

MODULE epfp003t;

TYPE
  T0 = RECORD
       END;

  T1 = RECORD(T0)
       END;

VAR
 i  : INTEGER;
 r0 : T0;
 r1 : T1;

PROCEDURE Q(f:REAL);
BEGIN
END Q;

PROCEDURE P(f:T0);
BEGIN
END P;

PROCEDURE R(f:POINTER TO T1);
BEGIN
END R;

BEGIN
 Q(i);
 P(r0);
 P(r1);
 R(NIL);
END epfp003t.
