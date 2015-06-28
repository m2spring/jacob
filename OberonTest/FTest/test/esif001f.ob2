(* 9.4 If statements                                                          *)
(* The Boolean expression preceding a statement sequence is called its guard. *)

MODULE esif001f;

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
 IF c
(*  ^--- Invalid type of expression *)

    THEN
 END;

 IF si THEN
(*  ^--- Invalid type of expression *)

       ELSE
 END;

 IF i
(*  ^--- Invalid type of expression *)

    THEN
 END;

 IF li THEN
(*  ^--- Invalid type of expression *)

       ELSE
 END;

 IF r
(*  ^--- Invalid type of expression *)

    THEN
 END;

 IF lr THEN
(*  ^--- Invalid type of expression *)

       ELSE
 END;

 IF s
(*  ^--- Invalid type of expression *)

    THEN
 END;

 IF rec THEN
(*  ^--- Invalid type of expression *)

       ELSE
 END;

 IF ptr
(*  ^--- Invalid type of expression *)

    THEN
 END;

END esif001f.
