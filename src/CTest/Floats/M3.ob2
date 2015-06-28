MODULE M3;
IMPORT O:=Out;

VAR a,b,c,d:REAL;
    A,B,C,D:LONGREAL;
    li:LONGINT; 
BEGIN (* M3 *)  
(*<<<<<<<<<<<<<<<
 A:=B; 
 a:=b; 
 A:=b; 
>>>>>>>>>>>>>>>*)
 li:=15;   A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
 li:=li-1; A:=li/10; O.String('ENTIER('); O.Longreal(A); O.String(')='); O.Int(ENTIER(A)); O.Ln;
END M3.
