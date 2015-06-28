MODULE M2;

TYPE T0 = RECORD END;
     T1 = RECORD b:BOOLEAN; END;
     T2 = RECORD i:INTEGER; END;
     T3 = RECORD i:INTEGER; b:BOOLEAN; END;
     T4 = RECORD l:LONGINT; END;
     S4 = ARRAY 4 OF CHAR;
VAR r0:T0;
    r1:T1;
    r2:T2;
    r3:T3;
    r4:T4;    
    s4:S4;

PROCEDURE P(p0:T0; p1:T1; p2:T2; p3:T3; p4:T4);
BEGIN (* P *)
 p1:=r1; 
 p0:=r0; 
END P;

PROCEDURE Q(s4:S4);
BEGIN (* Q *)
END Q;

BEGIN (* M2 *)
(*<<<<<<<<<<<<<<<
 P(r0,r1,r2,r3,r4); 
>>>>>>>>>>>>>>>*)
 Q(''); 
 Q('a'); 
 Q('ab'); 
 Q('abc'); 
END M2.
