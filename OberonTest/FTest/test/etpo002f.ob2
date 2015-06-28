(* 6. Type declarations : Pointer types                                       *)
(* Variables of a pointer type P assume as values pointers to variables       *)
(* of some type T. T is called the pointer base type of P and must be a       *)
(* record or array type.                                                      *)

MODULE etpo002f;

TYPE
   tInt        = INTEGER;

   tP1         = POINTER TO tInt;
(*                          ^--- Wrong type of pointer base *)
(* Pos: 11,29                                               *)

VAR
   p1 : tP1;

END etpo002f.

