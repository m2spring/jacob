MODULE adr;

TYPE T = RECORD
          c:CHAR;    
          i:INTEGER; 
          f:BOOLEAN; 
          l:LONGINT; 
         END;
         
VAR c:CHAR;    
    i:INTEGER; 
    f:BOOLEAN; 
    l:LONGINT; 
    
PROCEDURE P1*;

VAR c:CHAR;     
    i:INTEGER; 
    f:BOOLEAN; 
    l:LONGINT; 

 PROCEDURE P2;
 VAR c:CHAR;     
 
  PROCEDURE P3;
  VAR b:BOOLEAN; 
  END P3;

 END P2;

END P1;
   

BEGIN (* adr *)
END adr.
