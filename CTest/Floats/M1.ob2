MODULE M1;
CONST c1=1.0;
VAR a,b,c,d,e:REAL;
    f:BOOLEAN;
    si:SHORTINT; 
    in:INTEGER; 
    li:LONGINT;  
    lr:LONGREAL;

PROCEDURE P(r:LONGREAL):LONGREAL;
BEGIN (* P *)	   
 RETURN 0; 
END P;

BEGIN (* M1 *)  
(*<<<<<<<<<<<<<<<
 e:=(a-b)*(a+b); 
 e:=a/b;       
 f:=(a>b); 
 IF (a-b)>(c-d)
    THEN 
    ELSE 
 END; (* IF *)
 
>>>>>>>>>>>>>>>*)
 a:=(b-c)-in; 
 a:=(b-c)-d; 
 a:=in-(b-c); 
 a:=d-(b-c); 
 a:=SHORT(lr); 
(*<<<<<<<<<<<<<<<
 a:=b+c; 
 a:=b-c; 
 a:=(a+b)+c; 
 a:=(a+b)-c; 
 a:=a+(b+c); 
 a:=P(a)+(P(b)+P(c)); 
 a:=a-(b+c); 
 a:=(a+b)+(c+d); 
>>>>>>>>>>>>>>>*)
 a:=(a+b)-(c+d); 
END M1.
