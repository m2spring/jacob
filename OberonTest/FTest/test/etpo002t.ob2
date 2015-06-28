(* 6. Type declarations : Pointer types                                       *)
(* Pointer types inherit the extension relation of their pointer base types:  *)
(* if a type T1 is an extension of T, and P1 is of type POINTER TO T1, then   *)
(* P1 is also an extension of P.                                              *)

MODULE etpo002t;

TYPE
   t1Rec = RECORD
           END;
   t2Rec = RECORD(t1Rec)
           END;
   t1Ptr = POINTER TO t1Rec;
   t2Ptr = POINTER TO t2Rec;

VAR
   p1 : t1Ptr;
   p2 : t2Ptr;

PROCEDURE Apply (p : t1Ptr);
BEGIN
 p := NIL;
END Apply;

BEGIN (* te08 *)
 Apply(p1);
 Apply(p2);
END etpo002t.
