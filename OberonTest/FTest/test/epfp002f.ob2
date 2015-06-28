(* 10.1 Formal parameters                                                     *)
(* The result type of a procedure can be neither a record nor an array.       *)

MODULE epfp002f;

TYPE R = RECORD
         END;
     A = ARRAY 3 OF CHAR;

PROCEDURE P():R;
(*            ^--- Illegal type of function result *)
BEGIN
  RETURN 1.2;
(*       ^--- RETURN expression not compatible with formal result type *)
END P;

PROCEDURE Q(i:INTEGER):A;
(*                     ^--- Illegal type of function result *)
VAR
 a: A;
BEGIN
 RETURN a;
END Q;

END epfp002f.
