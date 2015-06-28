MODULE M;
IMPORT SYSTEM;

TYPE T=ARRAY 4 OF CHAR;
     R=RECORD
        f:BOOLEAN; 
        i:LONGINT; 
	p:POINTER TO ARRAY OF CHAR;
       END;
     U=POINTER TO RECORD
                   i:LONGINT; 
                  END;
VAR v:R;

    x:RECORD
       bla:LONGINT; 
       p:POINTER TO RECORD
                     i:LONGINT; 
                    END;
      END;
      
    a:POINTER TO ARRAY OF CHAR;
TYPE tPROC=PROCEDURE;
VAR p:tPROC;

PROCEDURE P(s:ARRAY OF CHAR);
TYPE T=ARRAY 4 OF CHAR;
     R=RECORD
        i:LONGINT; 
       END;
     U=POINTER TO RECORD
                   i:LONGINT; 
                  END;
VAR i:LONGINT; 
BEGIN (* P *)		   
 FOR i:=0 TO LEN(s)-1 DO
  s[i]:=0X;     
 END; (* FOR *)
END P;

PROCEDURE Q(p:T);
BEGIN (* Q *)
END Q;		 

PROCEDURE P1(VAR r:R);
BEGIN (* P1 *)
END P1;


BEGIN (* M *)  
 p:=SYSTEM.VAL(tPROC,0); 
 p;
END M.
