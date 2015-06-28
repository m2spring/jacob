(* 10. Procedure declarations                                                 *)
(*     A forward declaration serves to allow forward references to a          *)
(*     procedure whose actual declaration appears later in the text. The      *)
(*     formal parameter lists of the forward declaration and the actual       *)
(*     declaration must match (see App. A).                                   *)

MODULE epro004f;

PROCEDURE ^ P;
PROCEDURE P(VAR a:SET);
(*        ^--- Actual declaration doesn't match with forward decl *)

BEGIN
END P;


PROCEDURE ^Q(x:SET);
PROCEDURE Q(x:SET): INTEGER;
(*        ^--- Actual declaration doesn't match with forward decl *)

BEGIN
 RETURN 1;
END Q;

PROCEDURE ^R(a:ARRAY OF ARRAY OF CHAR);
PROCEDURE R(a:ARRAY OF ARRAY OF SET);
(*        ^--- Actual declaration doesn't match with forward decl *)

BEGIN
END R;

PROCEDURE ^S(VAR i:INTEGER);
PROCEDURE S(i:INTEGER);
(*        ^--- Actual declaration doesn't match with forward decl *)

BEGIN
END S;

END epro004f.
