(* 9.5 Case statements                                                        *)
(*                                                                            *)
(* The case expression must either be of an integer type that includes        *)
(* the types of all case labels, or both the case expression and the          *)
(* case labels must be of type CHAR.                                          *)

MODULE esca001t;

VAR
  i: INTEGER;
  c: CHAR;

BEGIN
 CASE i OF
   1..2,3,5..5 :;
  |8..12       :;
  |4000..6000   :;
  ELSE;
 END;

 CASE c OF
   'A'..'Z':;
  | '0'..'9':;
  |CHR(0)..CHR(12):;
 END;

END esca001t.
