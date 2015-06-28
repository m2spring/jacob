MODULE Index01;
(*% Indexing: Fixed mit globalen Variablen und Parametern *)

IMPORT O:=Out;

TYPE 
  T0 = ARRAY 2 OF ARRAY 5 OF INTEGER;
  
VAR 
  a0:T0;
  
PROCEDURE P(a0:T0);
BEGIN (* P *)
 O.String('Procedure P:'); O.Ln;
 O.Int(a0[1,0]); O.Ln;
 O.Int(a0[1,1]); O.Ln;
 O.Int(a0[1,2]); O.Ln;
 O.Int(a0[1,3]); O.Ln;
 O.Int(a0[1,4]); O.Ln;
 O.Ln;
 O.Int(a0[1,a0[0,0]]); O.Ln;
 O.Int(a0[1,a0[0,1]]); O.Ln;
 O.Int(a0[1,a0[0,2]]); O.Ln;
 O.Int(a0[1,a0[0,3]]); O.Ln;
 O.Int(a0[1,a0[0,4]]); O.Ln;
 O.Ln;
END P;

PROCEDURE Q(VAR a0:T0);
BEGIN (* Q *)
 O.String('Procedure Q:'); O.Ln;
 O.Int(a0[1,0]); O.Ln;
 O.Int(a0[1,1]); O.Ln;
 O.Int(a0[1,2]); O.Ln;
 O.Int(a0[1,3]); O.Ln;
 O.Int(a0[1,4]); O.Ln;
 O.Ln;
 O.Int(a0[1,a0[0,0]]); O.Ln;
 O.Int(a0[1,a0[0,1]]); O.Ln;
 O.Int(a0[1,a0[0,2]]); O.Ln;
 O.Int(a0[1,a0[0,3]]); O.Ln;
 O.Int(a0[1,a0[0,4]]); O.Ln;
 O.Ln;
END Q;

BEGIN (* Index01 *)
 a0[0][0]:=0; 
 a0[0,1]:=1; 
 a0[0][2]:=2; 
 a0[0,3]:=3; 
 a0[0][4]:=4; 
 a0[1]:=a0[0];

 O.Int(a0[1,0]); O.Ln;
 O.Int(a0[1,1]); O.Ln;
 O.Int(a0[1,2]); O.Ln;
 O.Int(a0[1,3]); O.Ln;
 O.Int(a0[1,4]); O.Ln;
 O.Ln;
 O.Int(a0[1,a0[0,0]]); O.Ln;
 O.Int(a0[1,a0[0,1]]); O.Ln;
 O.Int(a0[1,a0[0,2]]); O.Ln;
 O.Int(a0[1,a0[0,3]]); O.Ln;
 O.Int(a0[1,a0[0,4]]); O.Ln;
 
 P(a0);
 Q(a0);

END Index01.
