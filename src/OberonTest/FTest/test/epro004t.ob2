(* 10. Procedure declarations                                                 *)
(*     A forward declaration serves to allow forward references to a          *)
(*     procedure whose actual declaration appears later in the text. The      *)
(*     formal parameter lists of the forward declaration and the actual       *)
(*     declaration must match (see App. A).                                   *)

MODULE epro004t;

PROCEDURE ^P(VAR a:SET);
PROCEDURE P(VAR a:SET);
BEGIN
END P;

PROCEDURE ^Q(x:SET): INTEGER;
PROCEDURE Q(x:SET): INTEGER;
BEGIN
 RETURN 1;
END Q;

PROCEDURE ^R(a:ARRAY OF ARRAY OF CHAR);
PROCEDURE R(a:ARRAY OF ARRAY OF CHAR);
BEGIN
END R;

PROCEDURE ^S(VAR i:INTEGER);
PROCEDURE S(VAR i:INTEGER);
BEGIN
END S;

END epro004t.

