(* 9.5 Case statements                                                        *)
(*                                                                            *)
(* The case expression must either be of an integer type that includes        *)
(* the types of all case labels, or both the case expression and the          *)
(* case labels must be of type CHAR.                                          *)
 
MODULE esca001f;
 
VAR
  i: SHORTINT;
  c: CHAR;
 
BEGIN
 CASE i OF
   1..2,3,5..5 :;
  |8..12       :;
  |4000..6000   :;
(* ^--- Case label not compatible with case expression       Pos: 17,4  *)
(*       ^--- Case label not compatible with case expression Pos: 17,10 *)
 
  ELSE;
 END;
 
 CASE c OF
   'A'..'Z':;
  | '0'..'9':;
  |CHR(0)..CHR(12):;
  | 2..5:;
(*  ^--- Case label not compatible with case expression    Pos: 28,5 *)
(*     ^--- Case label not compatible with case expression Pos: 28,8 *)
 
 END;
 
 
END esca001f.
