(* 9.7 Repeat statements                                                      *)
(* A repeat statement specifies the repeated execution of a statement         *)
(* sequence until a condition specified by a Boolean expression is satisfied. *)

MODULE esre001f;

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
 REPEAT
 UNTIL c;
(*     ^--- Invalid type of expression *)

 REPEAT
 UNTIL si;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL i;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL li;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL r;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL lr;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL s;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL rec;
(*     ^--- Invalid type of expression *)


 REPEAT
 UNTIL ptr;
(*     ^--- Invalid type of expression *)

END esre001f.
