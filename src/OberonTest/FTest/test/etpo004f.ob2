(* 6. Type declarations : Pointer types                                       *)
(* Variables of a pointer type P assume as values pointers to variables of    *)
(* some type T. T is called the pointer base type of P and must be a record   *)
(* or array type.                                                             *)

MODULE etpo004f;

TYPE tRec  = RECORD
             END;
     tPtr  = POINTER TO tRec;
     tProc = PROCEDURE;

TYPE P1  = POINTER TO BOOLEAN;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 13,23                                         *)

     P2  = POINTER TO CHAR;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 17,23                                         *)

     P3  = POINTER TO SHORTINT;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 21,23                                         *)

     P4  = POINTER TO INTEGER;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 25,23                                         *)

     P5  = POINTER TO LONGINT;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 29,23                                         *)

     P6  = POINTER TO REAL;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 33,23                                         *)

     P7  = POINTER TO LONGREAL;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 37,23                                         *)

     P8  = POINTER TO SET;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 41,23                                         *)

     P9  = POINTER TO tPtr;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 45,23                                         *)

     P10 = POINTER TO tProc;
(*                    ^--- Wrong type of pointer base *)
(* Pos: 49,23                                         *)
     P11 = POINTER TO P11;
(*                    ^___ Wrong type of pointer base *)
(* Pos: 53,23                                         *)


END etpo004f.
