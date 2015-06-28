(* 9.6 While statements                                                       *)
(* While statements specify the repeated execution of a statement sequence    *)
(* while the Boolean expression (its guard) yields TRUE.                      *)

MODULE eswh001t;

VAR
   b: BOOLEAN;

BEGIN
 WHILE b DO
 END;

 WHILE TRUE DO
 END;

 WHILE 1>2 DO
 END;

END eswh001t.
