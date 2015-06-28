(* 6. Type declarations : Pointer types                                       *)
(* Variables of a pointer type P assume as values pointers to variables       *)
(* of some type T. T is called the pointer base type of P and must be a       *)
(* record or array type.                                                      *)

MODULE etpo001t;

TYPE
   tArray  = ARRAY 3 OF CHAR;
   tRecord = RECORD
              a,b,c : INTEGER;
              k     : CHAR;
             END;

   tP1 = POINTER TO tArray;
   tP2 = POINTER TO tRecord;
   tP3 = POINTER TO ARRAY OF ARRAY OF INTEGER;

VAR
   p1 : tP1;
   p2 : tP2;
   p3 : tP3;

END etpo001t.
