MODULE M1;
IMPORT O:=Out; 

TYPE P1 = POINTER TO T1;
     T1*= RECORD
           a:LONGINT; 
          END;       
     P2 = POINTER TO T2;
     T2*= RECORD(T1)
           b:LONGINT; 
          END;
VAR v1:T1;         
    v2:T2;
    p1:P1;
    p2:P2;

PROCEDURE P;
BEGIN (* P *)
 p1(P2).b:=0; 
END P;

PROCEDURE Proc1(VAR v:T1);
BEGIN (* Proc1 *)
 v(T2).b:=0; 
END Proc1;

PROCEDURE Proc2(VAR v:T1);

 PROCEDURE Q;
 BEGIN (* Q *)
  v(T2).b:=0; 
 END Q;

BEGIN (* Proc2 *)
 Q;
END Proc2;

BEGIN (* M1 *)
(*<<<<<<<<<<<<<<<
 Proc1(v1);
>>>>>>>>>>>>>>>*)
 O.String('Local: '); 
 v2.b:=1; O.Int(v2.b); O.String(' '); 
 Proc1(v2);
 O.Int(v2.b); O.Ln;

 O.String('Stack: '); 
 v2.b:=1; O.Int(v2.b); O.String(' '); 
 Proc2(v2);
 O.Int(v2.b); O.Ln;
 
 O.String('Failing...'); O.Ln;
 Proc2(v1);
END M1.
