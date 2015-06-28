(* 10.1 Formal parameters                                                     *)
(* Let Tf be the type of a formal parameter f (not an open array) and Ta      *)
(* the type of the corresponding actual parameter a. For variable             *)
(* parameters, Ta must be the same as Tf, or Tf must be a record type and     *)
(* Ta an extension of Tf.                                                     *)

MODULE epfp003f;

TYPE
  T0 = RECORD
       END;

  T1 = RECORD(T0)
       END;

VAR
 i  : SET;
 r0 : T0;

PROCEDURE Q(VAR f:INTEGER);
BEGIN
END Q;

PROCEDURE P(VAR f:T1);
VAR
 i:INTEGER;
BEGIN
 Q(i);
END P;

BEGIN
 Q(i);
(* ^--- Actual parameter not compatible with formal *)

 P(r0);
(* ^--- Actual parameter not compatible with formal *)

END epfp003f.
