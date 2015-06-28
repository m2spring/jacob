(* 6. Type declarations : Pointer types                                       *)
(* Variables of a pointer type P assume as values pointers to variables of    *)
(* some type T. T is called the pointer base type of P and must be a record   *)
(* or array type.                                                             *)

MODULE etpo001f;

TYPE
   Forward = POINTER TO NotYetDeclared;
(*                      ^--- Wrong type of pointer base *)
(* Pos: 9,25                                            *)
   UseFwd  = RECORD
              f    : Forward;
              proc : PROCEDURE (f : Forward);
             END;
VAR
   fp : Forward;

TYPE
   NotYetDeclared = INTEGER;

END etpo001f.
