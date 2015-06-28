(* 8.2.4 Relations                                                            *)
(* v IS T stands for "the dynamic type of v is T (or an extension of T)" and  *)
(* is called a type test. It is applicable if                                 *)
(*     1.  v is a variable parameter of record type or v is a pointer, and if *)
(*     2.  T is an extension of the static type of v                          *)
 
MODULE eere001f;
 
TYPE
 T0 = RECORD
       s:SET;
      END;
 
 T1 = RECORD(T0)
       i:INTEGER;
      END;
 
VAR
 p : POINTER TO T1;
 
PROCEDURE P(r:T0);
BEGIN
 IF r IS T1 THEN r.i:=1 END;
(*    ^--- Type test not applicable            Pos: 23,7  *)
(*                 ^--- Record field not found Pos: 23,20 *)
 
 IF p IS T0 THEN p.s:={} END;
(*    ^--- Type test not applicable *)
(* Pos: 27,7                        *)
 
END P;
 
END eere001f.
