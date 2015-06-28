MODULE OpenInd01;
(*% OpenIndex: Global Fixed 1Dim -> Open *)

IMPORT O:=Out;

TYPE 
   Ta* = ARRAY OF INTEGER;
   Tp* = POINTER TO Ta;
   
VAR 
   a*  : ARRAY 10 OF INTEGER;
   p*  : Tp;

PROCEDURE PVal(a:Ta);
BEGIN (* PVal *)
 O.String('a[0]='); O.Int(a[0]); O.Ln;
 O.String('a[1]='); O.Int(a[1]); O.Ln;
 O.String('a[2]='); O.Int(a[2]); O.Ln;
 O.String('a[3]='); O.Int(a[3]); O.Ln;
 O.String('a[4]='); O.Int(a[4]); O.Ln;
 O.String('a[5]='); O.Int(a[5]); O.Ln;
 O.String('a[6]='); O.Int(a[6]); O.Ln;
 O.String('a[7]='); O.Int(a[7]); O.Ln;
 O.String('a[8]='); O.Int(a[8]); O.Ln;
 O.String('a[9]='); O.Int(a[9]); O.Ln;
 O.Ln;
END PVal;

PROCEDURE PVar(VAR a:Ta);
BEGIN (* PVar *)
 O.String('a[0]='); O.Int(a[0]); O.Ln;
 O.String('a[1]='); O.Int(a[1]); O.Ln;
 O.String('a[2]='); O.Int(a[2]); O.Ln;
 O.String('a[3]='); O.Int(a[3]); O.Ln;
 O.String('a[4]='); O.Int(a[4]); O.Ln;
 O.String('a[5]='); O.Int(a[5]); O.Ln;
 O.String('a[6]='); O.Int(a[6]); O.Ln;
 O.String('a[7]='); O.Int(a[7]); O.Ln;
 O.String('a[8]='); O.Int(a[8]); O.Ln;
 O.String('a[9]='); O.Int(a[9]); O.Ln;
 O.Ln;
END PVar;


BEGIN (* OpenInd01 *)
 a[0]:=1;
 a[1]:=2; 
 a[2]:=3; 
 a[3]:=4; 
 a[4]:=5; 
 a[5]:=6; 
 a[6]:=7; 
 a[7]:=8; 
 a[8]:=9; 
 a[9]:=10; 
 PVal(a);
 PVar(a);

 NEW(p,10);
 p[0]:=1;
 p[1]:=2; 
 p[2]:=3; 
 p[3]:=4; 
 p[4]:=5; 
 p[5]:=6; 
 p[6]:=7; 
 p[7]:=8; 
 p[8]:=9; 
 p[9]:=10; 

 PVal(p^);
 PVar(p^);
END OpenInd01.
