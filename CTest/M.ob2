MODULE M;
IMPORT N;
TYPE T1 = RECORD
           s: ARRAY 4 OF CHAR;
          END;                     
     T2 = RECORD(T1)
           f: BOOLEAN;
          END;        
VAR  si : SHORTINT; 
     in : INTEGER; 
     li : LONGINT; 
     lr : LONGREAL;
     v1 : T1;
     v2 : T2;
     a1 : ARRAY 10 OF CHAR;
     a2 : ARRAY 2 OF ARRAY 5 OF CHAR;

 PROCEDURE P*(si: SHORTINT; 
              in: INTEGER; 
              li: LONGINT;
              lr: LONGREAL;
              p1: T1;
              p2: T2;
              s1: ARRAY OF LONGREAL;
              s2: ARRAY OF ARRAY OF ARRAY OF ARRAY OF INTEGER);
 VAR l1,l2:SET;             
 BEGIN (* P *)
 END P;

 PROCEDURE Q*(VAR si: SHORTINT; 
              VAR in: INTEGER; 
              VAR li: LONGINT;
              VAR lr: LONGREAL;
              VAR p1: T1;
              VAR p2: T2;
              VAR s1: ARRAY OF CHAR;
              VAR s2: ARRAY OF ARRAY OF CHAR);
 VAR l1,l2:SET;             
 BEGIN (* Q *)
 END Q;

BEGIN (* M *)
(*<<<<<<<<<<<<<<<
 P(1,2,3,4.0D0,v1,v2,"12345",a2);
 Q(si,in,li,lr,v1,v2,a1,a2); 
>>>>>>>>>>>>>>>*)
END M.
