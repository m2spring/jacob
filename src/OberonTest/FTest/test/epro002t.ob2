(* 10. Procedure declarations                                                 *)
(*     Since procedures may be declared as local objects too, procedure       *)
(*     declarations may be nested. The call of a procedure within its         *)
(*     declaration implies recursive activation.                              *)

MODULE epro002t;

PROCEDURE P;

 PROCEDURE Q;

  PROCEDURE R;
  BEGIN
   P;
   Q;
   R;
  END R;

 BEGIN
  P;
  Q;
 END Q;

BEGIN
 Q;
 P;
END P;

END epro002t.
