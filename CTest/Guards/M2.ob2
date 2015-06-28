MODULE M2;
IMPORT O:=Out; 

TYPE P1 = POINTER TO T1;
     T1 = RECORD
           a:LONGINT; 
          END;       
     P2 = POINTER TO RECORD(T1)
           b:LONGINT; 
          END;

PROCEDURE OK;
VAR p1:P1; p2:P2;
BEGIN (* OK *)
 p1^:=p2^;
 NEW(p2); 
 p1:=p2; 
 p1(P2).b:=0; 
 
END OK;

PROCEDURE Fail;
VAR p1:P1; 
BEGIN (* Fail *)
 NEW(p1); 
 p1(P2).b:=0; 
END Fail;

BEGIN (* M1 *)
 OK;
 Fail;
END M2.
