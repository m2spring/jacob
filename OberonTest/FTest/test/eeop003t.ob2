(* 8. Expressions: 8.1 Operands                                               *)
(* If r designates a record, then r.f denotes the field f of r or the         *)
(* procedure f bound to the dynamic type of r (Ch. 10.2).                     *)
 
MODULE eeop003t;
 
TYPE
  T0 = RECORD
        f: CHAR;
        i: INTEGER;
        r: REAL;
       END;
 
  T1 = RECORD(T0)
       END;
 
  T2 = RECORD(T1)
       END;
 
VAR
 r0:T0;
 r1:T1;
 r2:T2;
 
PROCEDURE (VAR r:T0) P;
BEGIN
END P;
 
BEGIN
 r0.f:=0X;
 r0.i:=1;
 r0.P;
 
 r1.r:=9;
 
 r2.f:=r0.f;
 r2.r:=r1.i;
 r2.P;
END eeop003t.
