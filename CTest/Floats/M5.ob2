MODULE M5;
IMPORT O:=Out;

TYPE T = REAL;
VAR a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s:T;

BEGIN (* M5 *)
(*<<<<<<<<<<<<<<<
 a:=1.5; (* 1.5 *)
 b:=a;   (* 1.5 *)
 c:=a+b; (* 3 *)
 d:=c*a; (* 4.5 *)
 e:=d-c; (* 1.5 *)
 f:=d/c; (* 1.5 *)

 O.String('a= '); O.Real(a); O.Ln;
 O.String('b= '); O.Real(b); O.Ln;
 O.String('c= '); O.Real(c); O.Ln;
 O.String('d= '); O.Real(d); O.Ln;
 O.String('e= '); O.Real(e); O.Ln;
 O.String('f= '); O.Real(f); O.Ln;
>>>>>>>>>>>>>>>*)
 a:=3.1415926539; 
 b:=4.5;
 c:=1;
 d:=3.9;
 e:=2.45;
 f:=9.7;
 g:=1.2;
 h:=7;
 i:=12;
 j:=3.4;
 k:=9.0;
 l:=1;
 m:=400;
 n:=2000000;
 o:=12.3;
 p:=9.8;
 q:=1.234567;
 r:=4.0;
 s:=2.0;
 a:=b*c+d-e+f/g-h*i*j+k*l*m/n-o*p*q/r-s; 
 O.String('a='); O.Real(a); O.Ln;
END M5.
