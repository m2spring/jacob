(* 9.2 Procedure calls                                                        *)
(*                                                                            *)
(* A procedure call activates a procedure. It may contain a list of actual    *)
(* parameters which replace the corresponding formal parameters defined in    *)
(* the procedure declaration (see Ch. 10). The correspondence is              *)
(* established by the positions of the parameters in the actual and           *)
(* formal parameter lists.                                                    *)
 
MODULE espr001f;
 
PROCEDURE P(i:INTEGER; s:SET; c:CHAR; r:REAL);
BEGIN
END P;
 
BEGIN
 P(1.2,'A',{},1);
(* ^---^---^--- Actual parameter not compatible with formal *)
(* Pos: 16,(4|8|12)                                         *)
 
 P;
(*^--- Too few actual parameters *)
(* Pos: 20,3                     *)
 
 P(1,{},'A');
(*         ^--- Too few actual parameters *)
(* Pos: 24,12                             *)
 
 P(1,{},'A',1.2,6);
(*              ^--- Too many actual parameters *)
(* Pos: 28,17                                   *)
 
END espr001f.
