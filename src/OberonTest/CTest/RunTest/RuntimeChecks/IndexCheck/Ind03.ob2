MODULE Ind03;
IMPORT O:=Out;

VAR 
  i:LONGINT; 
  a:ARRAY 3 ,3 OF INTEGER; 


PROCEDURE Check(a:ARRAY OF ARRAY OF INTEGER);
VAR i:LONGINT; 

 PROCEDURE Print(b:ARRAY OF INTEGER );
 BEGIN
  O.Int(b[i]); O.Ln; INC(i);
  O.Int(b[i]); O.Ln; INC(i);
  O.Int(b[i]); O.Ln; INC(i);
  O.Int(b[i]); O.Ln; 
 END Print;
 
BEGIN (* Check *)
 i:=0;
 Print(a[1]);
END Check;

BEGIN (* Ind03 *)
 i:=1;
 a[i,0]:=1;
 a[i,1]:=2;
 a[i,2]:=3;
 Check(a);
 
END Ind03.
