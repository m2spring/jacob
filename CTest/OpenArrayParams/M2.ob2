(*$! oc -it -kt -cmt -ic -nc M2 -ctei #*)
MODULE M2;
TYPE T*= RECORD
          i:LONGINT; 
         END;        
         
VAR a:T; p:POINTER TO T; s:POINTER TO ARRAY OF CHAR; 

PROCEDURE P*(VAR r:T);

 PROCEDURE Q;
 BEGIN (* Q *)
  P(r); 
 END Q;

BEGIN (* P *)
 P(r); 
END P;
         
PROCEDURE S*(s:ARRAY OF CHAR);
BEGIN (* S *)
END S;

BEGIN (* M2 *)
 S(s^); 
 P(p^); 
(*<<<<<<<<<<<<<<<
 P(a); 
>>>>>>>>>>>>>>>*)
END M2.
