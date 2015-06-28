(*$!oc -it -cmt -kt M6 #*)
MODULE M6;
IMPORT O:=Out;

VAR f:REAL; 

PROCEDURE F(p:LONGINT):LONGINT; 
BEGIN (* F *)
 RETURN 1; 
END F;

PROCEDURE G():LONGINT; 
BEGIN (* G *)	       
 RETURN 1; 
END G;

BEGIN (* M6 *)
 f:=(f*f)+F(G()+G()); 
END M6.
