(* 9.2 Procedure calls                                                        *)
(*                                                                            *)
(* A procedure call activates a procedure. It may contain a list of actual    *)
(* parameters which replace the corresponding formal parameters defined in    *)
(* the procedure declaration (see Ch. 10). The correspondence is              *)
(* established by the positions of the parameters in the actual and           *)
(* formal parameter lists.                                                    *)
 
MODULE espr001t;
 
PROCEDURE P(i:INTEGER; s:SET; c:CHAR; r:REAL);
BEGIN
END P;
 
BEGIN
 P(1,{},'A',1.0);
 P(0,{1,2,3},CHR(0),123455678);
END espr001t.
