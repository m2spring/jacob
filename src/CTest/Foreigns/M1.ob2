(*$! oc M1 -kt -cmt -it #*)
MODULE M1;         
IMPORT F;               
TYPE TA = ARRAY 10 OF CHAR;
     TR = RECORD
           i:LONGINT; 
           a:ARRAY 1019 OF CHAR; 
          END;
VAR i:LONGINT; c:CHAR; s:ARRAY 10 OF CHAR; 
    r:TR; a:TA; p:POINTER TO ARRAY OF CHAR; 
BEGIN
 F.system('ls'); 

 NEW(p,10); COPY('laber',p^); 
 F.printf('This is %i a %s test',4711,p^); 
END M1.
