MODULE Copy1;
TYPE T3=RECORD
         i:INTEGER; 
	 c:CHAR; 
        END;
     T50=ARRAY 50 OF CHAR;
VAR a,b,i,j,k:LONGINT; 
    s10:ARRAY 10 OF CHAR; 
    s20:ARRAY 20 OF CHAR; 
    a1,a2:ARRAY 20,30 OF CHAR; 
    p1,p2:POINTER TO ARRAY OF ARRAY OF CHAR; 
    ptr  :ARRAY 10 OF RECORD
		       g:LONGINT; 
                       f:ARRAY 20 OF POINTER TO ARRAY OF ARRAY 20 OF CHAR; 
		      END;
    const:T3;

BEGIN (* Copy1 *)
 COPY(s10,p2[i]); 
END Copy1.
