MODULE Index03;
(*% Indexing: Fixed mit verschiedenen Typen und ueber Parameter *)

IMPORT O:=Out;

TYPE 
  T0 = ARRAY 2 OF RECORD
                   boa:ARRAY 2 OF BOOLEAN; 
                   cha:ARRAY 10 OF CHAR;
                   sia:ARRAY 2 OF SHORTINT;
                   ina:ARRAY 2 OF INTEGER;
                   lia:ARRAY 2 OF LONGINT; 
                   rea:ARRAY 2 OF REAL;
                   lra:ARRAY 2 OF LONGREAL;
                   sea:ARRAY 2 OF SET;
                  END; 
VAR a:T0;

PROCEDURE P(bo:BOOLEAN; 
            ch:CHAR; 
            si:SHORTINT; 
            in:INTEGER; 
            li:LONGINT; 
            re:REAL; 
            lr:LONGREAL; 
            se:SET);
BEGIN (* P *)
 a[0].boa[1]:=bo;
 a[0].cha[1]:=CHR(ORD(ch)+1);
 a[0].sia[1]:=si+1;
 a[0].ina[1]:=in+1;
 a[0].lia[1]:=li+1;
 a[0].rea[1]:=re+1;
 a[0].lra[1]:=lr+1;
 a[0].sea[1]:=-se;
END P;


PROCEDURE Q(VAR a:T0);
BEGIN (* Q *)
 a[1]:=a[0]; 
END Q;

BEGIN (* Index03 *)
 a[0].boa[0]:=TRUE;
 a[0].cha[0]:='Y';
 a[0].sia[0]:=1;
 a[0].ina[0]:=-4711;
 a[0].lia[0]:=800000;
 a[0].rea[0]:=2.0;
 a[0].lra[0]:=3.0D0;
 a[0].sea[0]:={1,2,3};

 P( a[0].boa[0],
    a[0].cha[0],
    a[0].sia[0],
    a[0].ina[0],
    a[0].lia[0],
    a[0].rea[0],
    a[0].lra[0],
   a[0].sea[0]);

 Q(a);

(*<<<<<<<<<<<<<<<
 O.Bool(a[1].boa[0]); O.String('  '); O.Bool(a[1].boa[1]); O.Ln;
>>>>>>>>>>>>>>>*)
 O.Char(a[1].cha[0]); O.String('  '); O.Char(a[1].cha[1]); O.Ln;
 O.Int(a[1].sia[0]); O.String('  '); O.Int(a[1].sia[1]); O.Ln;
 O.Int(a[1].ina[0]); O.String('  '); O.Int(a[1].ina[1]); O.Ln;
 O.Int(a[1].lia[0]); O.String('  '); O.Int(a[1].lia[1]); O.Ln;
(*<<<<<<<<<<<<<<<
 O.Real(a[1].rea[0]); O.String('  '); O.Real(a[1].rea[1]); O.Ln;
 O.Longreal(a[1].lra[0]); O.String('  '); O.Longreal(a[1].lra[1]); O.Ln;
 O.Set(a[1].sea[0]); O.String('  '); O.Set(a[1].sea[1]); O.Ln;
>>>>>>>>>>>>>>>*)
END Index03.
