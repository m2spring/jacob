(* 8. Expressions: 8.1 Operands                                               *)
(* If p designates a pointer, p^ denotes the variable which is referenced by  *)
(* p.  The designators p^.f and p^[e] may be abbreviated as p.f and p[e],     *)
(* i.e.  record and array selectors imply dereferencing.                      *)

MODULE eeop004t;

TYPE

  TA = ARRAY 4 OF CHAR;
  TX = ARRAY 4 OF POINTER TO ARRAY 3 OF POINTER TO ARRAY 2 OF CHAR;

  TR = RECORD
        f : INTEGER;
        p : POINTER TO TA;
       END;

  T1 = POINTER TO TA;
  T2 = POINTER TO TR;
  T3 = POINTER TO TX;

VAR
 pa:T1;
 pr:T2;
 px:T3;

BEGIN
 NEW(pa);
 pa^[2]:=CHR(0);
 pa [3]:=CHR(1); 

 NEW(pr);
 pr^.f:=1;
 pr.f :=2;
 pr.p[2]:=1X; 

 NEW(px);
 px^[3]^[2]^[1]:=1X;
 px[3][2][1]:=2X;
 px^[0][1]^[1]:=3X;
 px[1][1]^[1]:=4X; 
END eeop004t.

