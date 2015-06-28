(* $! oc -it -cmt -kt M2 # *)
MODULE M2;
IMPORT Out;

TYPE T=REAL; 
VAR a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z:T;
    arr:ARRAY 30 OF T; 
    se:SET;

PROCEDURE G(p:T):LONGINT; 
BEGIN (* G *)             
 RETURN 0; 
END G;

PROCEDURE F(p:T):T;
BEGIN (* F *)           
 RETURN p; 
END F;

PROCEDURE P1():LONGINT; 
BEGIN (* P1 *)          
 RETURN 1; 
END P1;

BEGIN (* M2 *)
 z:=2; a:=z; b:=z; c:=a; d:=z; e:=z; f:=z; g:=z; h:=z; i:=z; j:=z; k:=z; 
 z:=a*(b*(c*(d*(e*(f*(g*(h*(i*(j*F(k))))))))));  
 Out.Real(z); Out.Ln;
END M2.
