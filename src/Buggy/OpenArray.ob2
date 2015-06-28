(*$!oc -it -kt -nc -cmt OpenArray -ctei -ctra #*)
MODULE OpenArray;
IMPORT SYSTEM;

VAR i:LONGINT; v:SYSTEM.BYTE;

PROCEDURE P(VAR x:ARRAY OF SYSTEM.BYTE);
BEGIN (* P *)                         
 SYSTEM.GET(i,x[i]);
(*<<<<<<<<<<<<<<<
 SYSTEM.GET(i,v);
 x[i]:=v; 
>>>>>>>>>>>>>>>*)
END P;

BEGIN (* OpenArray *)
END OpenArray.
