MODULE M2;
IMPORT Out;
CONST set={5..4};
VAR a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,x:INTEGER; 

PROCEDURE OutInt(i:LONGINT);
BEGIN (* OutInt *)	  
 Out.Int(i); 
END OutInt;

BEGIN (* M2 *)		 
 a:=1;b:=1;c:=1;d:=1;e:=1;f:=1;g:=1;h:=1;i:=1;j:=1;k:=1;l:=1;m:=1;n:=1;o:=1;p:=1; 
 x:=(a+b)+((c+d)+(e+f)); 
 OutInt(x); Out.Ln;
 x:=(a+b)+((c+d)+((e+f)+(g+h))); 
 OutInt(x); Out.Ln;
 x:=(a+b)+((c+d)+((e+f)+((g+h)+(i+j)))); 
 OutInt(x); Out.Ln;
 x:=(a+b)+((c+d)+((e+f)+((g+h)+((i+j)+(k+l))))); 
 OutInt(x); Out.Ln;
 x:=(a+b)+((c+d)+((e+f)+((g+h)+((i+j)+((k+l)+(m+n)))))); 
 OutInt(x); Out.Ln;
 x:=(a+b)+((c+d)+((e+f)+((g+h)+((i+j)+((k+l)+((m+n)+(o+p))))))); 
 OutInt(x); Out.Ln;
END M2.
