(* 8. Expressions: 8.1 Operands                                               *)
(* If a designates an array, then a[e] denotes that element of a whose index  *)
(* is the current value of the expression e. The type of e must be an         *)
(* integer type. A designator of the form a[e0,e1,...,en] stands for          *)
(* a[e0][e1]...e[n].                                                          *)
 
MODULE eeop002f;
 
CONST
  c = 0DX;
  r = 1.0;
 
TYPE
 T1 = ARRAY 1 OF CHAR;
 T2 = ARRAY 1, 2, 3 OF CHAR;
 T3 = ARRAY 1 OF ARRAY 2 OF ARRAY 3 OF CHAR;
 
VAR
 li : LONGINT;
 a1 : T1;
 a2 : T2;
 a3 : T3;
 
BEGIN
 a1[1]:=c;
(*  ^--- Index out of bounds *)
(* Pos: 25,5                 *)
 
 a2[0][r][0]:=c;
(*     ^--- Invalid type of expression *)
(* Pos: 29,8                           *)
 
 a3[li,1,r]:=c;
(*       ^--- Invalid type of expression *)
(* Pos: 33,10                            *)
 
END eeop002f.
