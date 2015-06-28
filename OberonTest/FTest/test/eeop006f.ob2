(* 8. Expressions: 8.1 Operands                                               *)
(* A type guard v(T) asserts that the dynamic type of v is T (or an extension *)
(* of T), i.e.  program execution is aborted, if the dynamic type of v is not *)
(* T (or an extension of T). Within the designator, v is then regarded as     *)
(* having the static type T. The guard is applicable, if                      *)
(*   1.  v is a variable parameter of record type or v is a pointer, and if   *)
(*   2.  T is an extension of the static type of v                            *)
 
MODULE eeop006f;
 
TYPE
 T0 = RECORD
       s    : SET;
      END;
 
 T1 = RECORD(T0)
       i    : INTEGER;
       proc : PROCEDURE (VAR r:T1);
      END;
 
PT0 = POINTER TO T0;
PT1 = POINTER TO T1;
 
VAR
 p0 : PT0;
 p1 : PT1;
 
PROCEDURE P(r:T0);
BEGIN
 r(T1).i:=1;
(*^--- Guard not applicable *)
(* Pos: 30,3                *)
 
END P;
 
PROCEDURE P2(VAR r:T0);
BEGIN
 r(T1).proc(r);
(*          ^--- Actual parameter not compatible with formal *)
(* Pos: 38,13                                                *)
 
END P2;
 
BEGIN
 p1(T0).s:={};
(* ^--- Guard not applicable Pos: 45,4           *)
(*     ^--- Dereference not applicable Pos: 45,8 *)
(*      ^--- Record field not found Pos: 45,9    *)
 
p0(T1).i:=1;
(*^--- Guard not applicable Pos: 50,3           *)
(*    ^--- Dereference not applicable Pos: 50,7 *)
(*     ^--- Record field not found Pos: 50,8    *)
 
p0^(T1).i:=1; 
(* ^--- Guard not applicable *)
(* Pos: 55,4                 *)
 
END eeop006f.
