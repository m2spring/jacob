MODULE M1;
IMPORT O:=Out; 
VAR s5:ARRAY 5 OF CHAR; 

PROCEDURE P1(s:ARRAY OF CHAR);

 PROCEDURE Q;
 BEGIN (* Q *)
  COPY(s,s5); 
 END Q;

BEGIN (* P1 *)              
 COPY(s,s5); 
 Q;
END P1;

PROCEDURE P2;
VAR p:POINTER TO ARRAY OF CHAR;
BEGIN (* P2 *)
 COPY(p^,s5);
END P2;

BEGIN (* M1 *)
 P1(''); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 P1('1'); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 P1('12'); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 P1('123'); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 P1('1234'); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 P1('12345'); O.String('"'); O.String(s5); O.String('"'); O.Ln;
 P1('123456'); O.String('"'); O.String(s5); O.String('"'); O.Ln;
END M1.
