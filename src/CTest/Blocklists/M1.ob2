MODULE M1;

TYPE P=RECORD
	f:SHORTINT; 
        p:ARRAY 10 OF POINTER TO ARRAY OF CHAR;
       END;	
     A=ARRAY 10 OF RECORD
                   f:SHORTINT; 
                   g:P;
		   h:INTEGER; 
		   i:ARRAY 20 OF POINTER TO P;
(*<<<<<<<<<<<<<<<
		   j:LONGINT; 
>>>>>>>>>>>>>>>*)
		   k:ARRAY 30 OF POINTER TO P;
		   l:LONGINT; 
                  END;
VAR v:ARRAY 50 OF RECORD
                   f:SET;
		   g:A;
                  END;

PROCEDURE Proc;
VAR v:P;
BEGIN (* Proc *)
END Proc;

BEGIN (* M1 *)
END M1.
