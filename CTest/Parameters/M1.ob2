MODULE M1;  
IMPORT SYSTEM;
TYPE tPtr=POINTER TO ARRAY 10 OF CHAR;
     tPrc=PROCEDURE;
VAR  by:SYSTEM.BYTE;
     pt:SYSTEM.PTR;
     bo:BOOLEAN; 
     ch:CHAR; 	
     se:SET;
     si:SHORTINT; 
     in:INTEGER; 
     li:LONGINT; 
     re:REAL;
     lr:LONGREAL;
     po:tPtr;
     pr:tPrc;

PROCEDURE P(by:SYSTEM.BYTE;
	    pt:SYSTEM.PTR;
	    bo:BOOLEAN; 
            ch:CHAR; 	
	    se:SET;
            si:SHORTINT; 
	    in:INTEGER; 
	    li:LONGINT; 
            re:REAL;
            lr:LONGREAL;
	    po:tPtr;
            pr:tPrc);
BEGIN (* P *)	
END P;

BEGIN (* M1 *)	     
 P(by
  ,pt
  ,bo
  ,ch
  ,se
  ,si
  ,in
  ,li
  ,re
  ,1.0
  ,po
  ,pr); 
END M1.
