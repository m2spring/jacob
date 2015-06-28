MODULE M3;
IMPORT O:=Out, S:=SYSTEM;

TYPE T=RECORD a:BOOLEAN; i:INTEGER; END;
VAR arr4x5:ARRAY 4,5 OF T; 
    arr6x7:ARRAY 6,7 OF T; 
    a:ARRAY 10,20 OF CHAR; c:CHAR; 
    i:LONGINT; 
    b:ARRAY 10 OF RECORD
                   f:POINTER TO ARRAY OF CHAR;
                  END;
    s:ARRAY 20 OF CHAR;                   

PROCEDURE P1(VAR i:LONGINT; s:ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
  i:=LEN(s);
 END Q;

BEGIN (* P1 *)              
 Q;
 O.String('LEN("');
 O.String(s);
 O.String('")=');
 O.Int(i); 
 O.Ln;
END P1;

PROCEDURE P2(a:ARRAY OF ARRAY OF T);
BEGIN (* P2 *)
 i:=LEN(a);    O.Int(i); O.Ln;
 i:=LEN(a,0);  O.Int(i); O.Ln;
 i:=LEN(a,1);  O.Int(i); O.Ln;
 i:=LEN(a[i]); O.Int(i); O.Ln;
END P2;

BEGIN (* M3 *)
 P1(i,'');
 P1(i,'1');
 P1(i,'12');
 P1(i,'123');
 P1(i,'1234');
 P2(arr4x5);
 P2(arr6x7);
END M3.
