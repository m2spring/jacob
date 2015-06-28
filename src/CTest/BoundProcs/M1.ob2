MODULE M1;

TYPE T1 = RECORD END;
     P1 = POINTER TO T1;
          
PROCEDURE (VAR r:T1)Proc1(i:INTEGER);
VAR v:SHORTINT; 
BEGIN (* Proc1 *)
END Proc1;
          
PROCEDURE (p:P1)Proc2(j:LONGINT);
BEGIN (* Proc2 *)
END Proc2;

PROCEDURE Proc1(VAR r:T1; i:INTEGER);
VAR v:SHORTINT; 
BEGIN (* Proc1 *)
END Proc1;
          
BEGIN (* M1 *)
END M1.
