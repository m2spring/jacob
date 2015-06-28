(* 8. Expressions: 8.1 Operands                                               *)
(* A type guard v(T) asserts that the dynamic type of v is T (or an extension *)
(* of T), i.e.  program execution is aborted, if the dynamic type of v is not *)
(* T (or an extension of T). Within the designator, v is then regarded as     *)
(* having the static type T. The guard is applicable, if                      *)
(*   1.  v is a variable parameter of record type or v is a pointer, and if   *)
(*   2.  T is an extension of the static type of v                            *)

MODULE eeop006t;

TYPE
 T0 = RECORD
       s:SET;
      END;

 T1 = RECORD(T0)
       i:INTEGER;
      END;

PT0 = POINTER TO T0;
PT1 = POINTER TO T1;

VAR
 p : PT0;

PROCEDURE P(VAR r:T0);
BEGIN
 r.s:={};
 r(T0).s:={1};
 r(T1).i:=1;
END P;

BEGIN
 p.s:={};

 p(PT1).i:=1;


 p(PT1)^.i:=1;

 p(PT0).s:={};

END eeop006t.
