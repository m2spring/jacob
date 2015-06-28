(* 6. Type declarations : Pointer types                                       *)
(* If T is an n-dimensional open array type the allocation has to be done     *)
(* with NEW(p,e0,...,en-1) where T is allocated with lengths given by the     *)
(* expressions e0,...,en-1.                                                   *)

MODULE etpo003t;

TYPE
   t1Ptr = POINTER TO ARRAY 2 OF CHAR;
   t2Ptr = POINTER TO ARRAY OF ARRAY OF ARRAY OF INTEGER;
VAR
   p1 : t1Ptr;
   p2 : t2Ptr;

BEGIN
 NEW(p1);
 NEW(p2,1,2,3);
END etpo003t.
