(* 9.5 Case statements                                                        *)
(*                                                                            *)
(* Case labels are constants, and no value must occur more than once.         *)
 
MODULE esca002f;
 
VAR
  i, j : INTEGER;
  c, h : CHAR;
 
BEGIN
 CASE i OF
   1..2,3,5..5 :;
  |8..12       :;
  |11          :;
(* ^--- Overlapping case label *)
(* Pos: 15,4                   *)
 
  |14..i       :;
(*     ^--- Expression not constant *)
(* Pos: 19,8                        *)
 
  ELSE;
 END;
 
 CASE c OF
   'A'..'Z':;
  | '0'..'9':;
  |CHR(50)..CHR(56):;
(* ^--- Overlapping case label *)
(* Pos: 29,4                   *)
 
 END;
 
END esca002f.
