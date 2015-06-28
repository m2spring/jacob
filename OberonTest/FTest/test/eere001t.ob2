(* 8.2.4 Relations                                                            *)
(* v IS T stands for "the dynamic type of v is T (or an extension of T)" and  *)
(* is called a type test. It is applicable if                                 *)
(*     1.  v is a variable parameter of record type or v is a pointer, and if *)
(*     2.  T is an extension of the static type of v                          *)

MODULE eere001t;

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
 IF r IS T0 THEN r(T0).s:={} END;
 IF r IS T1 THEN r(T1).i:=2 END;
END P;

BEGIN
 IF p IS PT0 THEN p(PT0)^.s:={1} END;

 IF p IS PT1 THEN p(PT1).i:=1 END;
END eere001t.

