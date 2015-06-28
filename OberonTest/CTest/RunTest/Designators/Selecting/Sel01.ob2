(* $! OC -it -cmt -kt Sel01# *)
MODULE Sel01;
(*% Selecting: Global und als Parameter *)
(*% Procedurinternes veraendern von VAL und VAR Parametern *)

IMPORT O:=Out;

TYPE 
  T0 = RECORD
        s:ARRAY 5 OF CHAR; 
       END;
  T1 = RECORD
        r:T0;
        e:RECORD
           i:INTEGER; 
           s:ARRAY 50, 20 OF RECORD
                              li:LONGINT; 
                              c:CHAR; 
                              s:ARRAY 30 OF CHAR; 
                             END;
          END;
       END;

VAR r0: T0;
    r1: T1;
    
PROCEDURE PRef(VAR r0:T0; VAR r1:T1);
BEGIN (* PRef *)
 O.String(r0.s); O.Ln;
 O.String(r1.r.s); O.Ln;
 O.Int(r1.e.i); O.Ln;
 O.Int(r1.e.s[2,3].li); O.Ln;
 O.Char(r1.e.s[0,0].c); O.Ln;
 O.String(r1.e.s[0,0].s); O.Ln;
 r1.e.s[0,0].s:='Jetzt veraendert!';
 O.Ln;
END PRef;

PROCEDURE PVal(r0:T0; r1:T1);
BEGIN (* PVal *)
 O.String(r0.s); O.Ln;
 O.String(r1.r.s); O.Ln;
 O.Int(r1.e.i); O.Ln;
 O.Int(r1.e.s[2,3].li); O.Ln;
 O.Char(r1.e.s[0,0].c); O.Ln;
 O.String(r1.e.s[0,0].s); O.Ln;
 r1.e.s[0,0].s:='Sollte nie ausgegeben werden!';
 O.Ln;
END PVal;


BEGIN (* Sel01 *)
 r0.s:='ABCD';
 r1.r:=r0; 
 r1.e.i:=-12;
 r1.e.s[2,3].li:=300000;
 r1.e.s[0,0].c:='A'; 
 r1.e.s[0,0].s:='Hier ganz innen!';

 O.String(r0.s); O.Ln;
 O.String(r1.r.s); O.Ln;
 O.Int(r1.e.i); O.Ln;
 O.Int(r1.e.s[2,3].li); O.Ln;
 O.Char(r1.e.s[0,0].c); O.Ln;
 O.String(r1.e.s[0,0].s); O.Ln;
 O.Ln;

 PRef(r0,r1);
 PVal(r0,r1);

 O.String(r0.s); O.Ln;
 O.String(r1.r.s); O.Ln;
 O.Int(r1.e.i); O.Ln;
 O.Int(r1.e.s[2,3].li); O.Ln;
 O.Char(r1.e.s[0,0].c); O.Ln;
 O.String(r1.e.s[0,0].s); O.Ln;
 O.Ln;
END Sel01.

