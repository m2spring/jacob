(* 8. Expressions: 8.1 Operands                                               *)
(* If a designates an array, then a[e] denotes that element of a whose index  *)
(* is the current value of the expression e. The type of e must be an         *)
(* integer type. A designator of the form a[e0,e1,...,en] stands for          *)
(* a[e0][e1]...e[n].                                                          *)

MODULE eeop001t;

CONST
   c1 = 0;
   c2 = 3;

TYPE
   t1array = ARRAY 3       OF INTEGER;
   t2array = ARRAY 2, 2    OF INTEGER;
   t3array = ARRAY 4, 4, 4 OF INTEGER;

VAR
   a1 : t1array;
   a2 : t2array;
   a3 : t3array;

BEGIN (* te11 *)
 a1[c1]        := 0;
 a2[c1,c1]     := 1;
 a3[c2,c2,1]   := 2;
 a3[c2][c2][2] := 3;
END eeop001t.
