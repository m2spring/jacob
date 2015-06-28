MODULE m4;
TYPE tRec = RECORD
             h:ARRAY 19 OF CHAR; 
            END;       
     tRec2 = RECORD(tRec)
 	      bla:SHORTINT; 
             END;
VAR r1:tRec;	    
    r2:tRec2;
    
PROCEDURE P(VAR r:tRec);

 PROCEDURE Q;
 BEGIN (* Q *)
  r:=r1; 
  r.h[0]:=r.h[1]; 
  r.h[1]:='b'; 
 END Q;

BEGIN (* P *)
END P;		       

PROCEDURE P1(s:ARRAY OF CHAR);
BEGIN (* P1 *)
 s[0]:='b'; 
END P1;


BEGIN (* m4 *) 
 r1:=r2; 		    
 P1('laber bla'); 
END m4.
