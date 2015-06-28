MODULE Super01;
(*% Supering: Call of bound and inherited procs  *)
IMPORT O:=Out;

TYPE T0 = RECORD     END;
     T1 = RECORD(T0) END;
     T2 = RECORD(T1) END;
     
     P0 = POINTER TO T0;
     P1 = POINTER TO T1;
     P2 = POINTER TO T2;

VAR r0:T0;
    r1:T1;
    r2:T2;
    p0:P0;
    p1:P1;
    p2:P2;
    
PROCEDURE (VAR r:T0)P;
BEGIN (* P *)
 O.String('T0-bound P'); O.Ln;
END P;

PROCEDURE (VAR r:T1) P;
BEGIN (* P *)
 O.String('T1-bound P'); O.Ln;
 r.P^;
END P;

BEGIN (* Super01 *)
 r0.P;
 O.String('------'); O.Ln;
 r1.P;
 O.String('------'); O.Ln;
 r2.P;
 
 O.Ln;
 O.StrLn('Call via Pointer:');
 O.Ln;
 NEW(p0); NEW(p1); NEW(p2);
 p0.P;
 O.String('------'); O.Ln;
 p1.P;
 O.String('------'); O.Ln;
 p2.P;

END Super01.
