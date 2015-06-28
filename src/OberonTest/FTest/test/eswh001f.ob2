(* 9.6 While statements                                                       *)
(* While statements specify the repeated execution of a statement sequence    *)
(* while the Boolean expression (its guard) yields TRUE.                      *)

MODULE eswh001f;

TYPE TR = RECORD
          END;
     TP = POINTER TO TR;

VAR
   c  : CHAR;
   si : SHORTINT;
   i  : INTEGER;
   li : LONGINT;
   r  : REAL;
   lr : LONGREAL;
   s  : SET;

   rec : TR;
   ptr : TP;


BEGIN
 WHILE c DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE si DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE i DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE li DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE r DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE lr DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE s DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE rec DO
(*     ^--- Invalid type of expression *)

 END;

 WHILE ptr DO
(*     ^--- Invalid type of expression *)

 END;

END eswh001f.
