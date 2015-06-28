(* 8. Expressions: 8.1 Operands                                               *)
(* If r designates a record, then r.f denotes the field f of r or the         *)
(* procedure f bound to the dynamic type of r (Ch. 10.2).                     *)
 
MODULE eeop003f;
 
TYPE
  T0 = RECORD
        f: CHAR;
       END;
 
  T1 = RECORD(T0)
        i: INTEGER;
       END;
 
  T2 = RECORD(T1)
        r: REAL;
       END;
 
VAR
 r0:T0;
 r1:T1;
 
PROCEDURE (VAR r:T1) P;
BEGIN
 r.P^;
(*  ^--- There is no redefined procedure to call *)
(* Pos: 26,5                                     *)
 
END P;
 
PROCEDURE PROC(VAR x:T0);
BEGIN
 x.P;
(* ^--- Record field not found *)
(* Pos: 34,4                   *)
 
 x(T1).P;
END PROC;
 
BEGIN
 r0.i:=1;
(*  ^--- Record field not found *)
(* Pos: 42,5                    *)
 
 r1.r:=MAX(LONGINT);
(*  ^--- Record field not found *)
(* Pos: 46,5                    *)
 
END eeop003f.
