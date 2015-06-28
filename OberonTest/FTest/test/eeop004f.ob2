(* 8. Expressions: 8.1 Operands                                               *)
(* If p designates a pointer, p^ denotes the variable which is referenced by  *)
(* p.  The designators p^.f and p^[e] may be abbreviated as p.f and p[e],     *)
(* i.e.  record and array selectors imply dereferencing.                      *)
 
MODULE eeop004f;
 
TYPE
 
  TA = ARRAY 4 OF CHAR;
 
  TR = RECORD
        f : INTEGER;
        p : POINTER TO TA;
       END;
 
  T1 = POINTER TO TA;
  T2 = POINTER TO TR;
 
VAR
 pa:T1;
 pr:T2;
 
BEGIN
 pa.f:=1;
(* ^--- Field selector not applicable  Pos: 25,4 *)
(*  ^--- Record field not found        Pos: 25,5 *)
 
 pa[4]:='A';
(*  ^--- Index out of bounds *)
(* Pos: 29,5                 *)
 
 
 pr^.x:=1;
(*   ^--- Record field not found *)
(* Pos: 34,6                     *)
 
 pr.p.f:=2;
(*   ^--- Field selector not applicable   Pos: 38,6 *)
(*    ^--- Record field not found         Pos: 38,7 *)
 
 pr.p[1][2]:=0X;
(*      ^---   Index not applicable   Pos: 42,9  *)
(*       ^---  Index out of bounds    Pos: 42,10 *)
 
END eeop004f.
