(* 9.10 Return and exit statements                                            *)
(* Function procedures require the presence of a return statement             *)
(* indicating the result value.                                               *)

MODULE esrt003f;

PROCEDURE Func1(): INTEGER;
END Func1;
(* No error message: No RETURN in function procedure                *)
(* According to a change in the Front-End this behavier is correkt: *)
(* Function procedures without a BEGIN requires no RETURN statement *)

PROCEDURE Func2(): SHORTINT;
BEGIN
END Func2;
(* Pos: 1 -  No RETURN in function procedure *)

END esrt003f.
