(* 9.10 Return and exit statements                                            *)
(* The type of the expression must be assignment compatible (see App.A)       *)
(* with the result type specified in the procedure heading (see Ch.10).       *)

MODULE esrt002f;

TYPE T0  = RECORD
           END;

     T1  = RECORD(T0)
           END;

     PT0 = POINTER TO T0;

     PT1 = POINTER TO T1;

PROCEDURE Func1():PT0;
VAR
 p: PT1;
BEGIN
 RETURN p;
END Func1;

PROCEDURE Func2():PT1;
VAR
 p: PT0;
BEGIN
 RETURN p;
(*      ^--- RETURN expression not compatible with formal result type *)

END Func2;

END esrt002f.
