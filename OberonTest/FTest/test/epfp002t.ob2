(* 10.1 Formal parameters                                                     *)
(* Let Tf be the type of a formal parameter f (not an open array) and Ta      *)
(* the type of the corresponding actual parameter a. For variable             *)
(* parameters, Ta must be the same as Tf, or Tf must be a record type and     *)
(* Ta an extension of Tf.                                                     *)

MODULE epfp002t;

TYPE
  T0 = RECORD
       END;

  T1 = RECORD(T0)
       END;

VAR
 i  : INTEGER;
 r0 : T0;
 r1 : T1;

PROCEDURE Q(VAR f:INTEGER);
BEGIN
END Q;

PROCEDURE P(VAR f:T0);
VAR
 i:INTEGER;
BEGIN
 Q(i);
END P;

BEGIN
 Q(i);
 P(r0);
 P(r1);
END epfp002t.
