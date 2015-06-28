(* 8.2.3 Set Operators                                                        *)
(* A set constructor defines the value of a set by listing its elements       *)
(* between curly brackets. The elements must be integers in the range         *)
(* 0..MAX(SET). A range a..b denotes all integers in the interval [a, b].     *)
 
MODULE eeso002t;
 
VAR
 a, b, c, d, e, f, g, h, j, k:SET; 
 i:INTEGER;
 
BEGIN
   a := {1,2,3,4,5,6,7,8,9};
   b := {1,2..4,5,6,7..9};
   c := {1..8,9};
   d := {};
   e := {1..2,5,7..9};
   f := {1..1,4,7..2,9};
   g := {1,2,3..4,i,8};
   h := {i..i,1,3,5};
   j := {1..8,2..4,3..i};
   k := {i..2,3,8..9,10,12};
 
END eeso002t.
