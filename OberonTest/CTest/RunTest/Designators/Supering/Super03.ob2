MODULE Super03;
IMPORT O:=Out;

TYPE T0 = RECORD     END;
     T1 = RECORD(T0) END;
     T2 = RECORD(T1) END;

     U0 = RECORD
           r:T2;
          END;

     U1 = RECORD(U0) END;
     U2 = RECORD(U1) END;

VAR u2:U2;

PROCEDURE (VAR r:T0) P;
BEGIN (* P *)
 O.String('T0-bound P'); O.Ln;
END P;
          
PROCEDURE (VAR r:T1) P;
BEGIN (* P *)
 O.String('T1-bound P'); O.Ln;
 r.P^;
END P;

PROCEDURE (VAR u0:U0) Q;
BEGIN (* Q *)
 O.String('U0-bound Q'); O.Ln;
 u0.r.P;
END Q;

PROCEDURE (VAR u2:U2) Q;
BEGIN (* Q *)
 O.String('U2-bound Q'); O.Ln;
 u2.Q^;
END Q;

BEGIN (* Super03 *)
 u2.Q;
END Super03.
