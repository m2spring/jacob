MODULE M4;
IMPORT O:=Out; 

VAR s1:ARRAY 1 OF CHAR; 
    s2:ARRAY 2 OF CHAR; 
    s3:ARRAY 3 OF CHAR; 
    s4:ARRAY 4 OF CHAR; 
    s5:ARRAY 5 OF CHAR; 

PROCEDURE P1(VAR s:ARRAY OF CHAR);
VAR t:ARRAY 10 OF CHAR; 
BEGIN (* P1 *)   
 COPY("",s); 
END P1;

BEGIN (* M4 *)                             
 P1(s1); O.String('"'); O.String(s1); O.String('"'); O.Ln;
 P1(s2); O.String('"'); O.String(s2); O.String('"'); O.Ln;
 P1(s3); O.String('"'); O.String(s3); O.String('"'); O.Ln;
 P1(s4); O.String('"'); O.String(s4); O.String('"'); O.Ln;
 P1(s5); O.String('"'); O.String(s5); O.String('"'); O.Ln;
END M4.
