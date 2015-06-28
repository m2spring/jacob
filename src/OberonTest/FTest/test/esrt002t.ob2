(* 9.10 Return and exit statements                                            *)
(* The type of the expression must be assignment compatible (see App.A)       *)
(* with the result type specified in the procedure heading (see Ch.10).       *)

MODULE esrt002t;

PROCEDURE Func(): INTEGER; 
VAR
   si: SHORTINT;
BEGIN
 RETURN si;
END Func;

END esrt002t.

