MODULE M2;

TYPE P=POINTER TO ARRAY OF CHAR;
     T=RECORD
        i:INTEGER; 
	n:P;
       END; 
     T2=RECORD
         f:T;
	 a:ARRAY 10 OF P; 
        END;  
VAR v:T2;
BEGIN (* M2 *)
END M2.
