(*$!oc -it -kt -nc -cmt M2 && M2 #*)
MODULE M2;	    
IMPORT O:=Out;

TYPE T=POINTER TO ARRAY OF ARRAY OF CHAR;
VAR v:T; i:LONGINT; 	      

PROCEDURE P(v:ARRAY OF ARRAY OF CHAR);
BEGIN (* P *)			    
 O.StrLn(v[i]); 
END P;

BEGIN	
 NEW(v,10,20); 
 i:=1; 
 COPY("laber",v[1]); 
 O.StrLn(v[i]); 
END M2.
