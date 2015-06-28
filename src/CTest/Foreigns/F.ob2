FOREIGN MODULE F;

CONST a=1;
VAR i:LONGINT; 
TYPE t=RECORD
        i:LONGINT; 
       END;        
       
PROCEDURE P;

VAR k:LONGINT; 

PROCEDURE Q(i:LONGINT; VAR k:SHORTINT; .. );

TYPE T=RECORD
        i:CHAR; 
       END;

PROCEDURE printf*(s:ARRAY OF CHAR; ..);
PROCEDURE system* (command : ARRAY OF CHAR);

END F.
