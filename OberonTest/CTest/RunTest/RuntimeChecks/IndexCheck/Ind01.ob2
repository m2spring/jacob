MODULE Ind01;
IMPORT O:=Out;

VAR s:ARRAY 3 OF CHAR; 

PROCEDURE OpenPar(a:ARRAY OF CHAR);
BEGIN (* OpenPar *)
 O.Char(a[0]); O.Ln;
 O.Char(a[1]); O.Ln;
 O.Char(a[2]); O.Ln;
 O.Char(a[3]); O.Ln;
END OpenPar;

BEGIN (* Ind01 *)
 s:='AB';
 OpenPar(s);
END Ind01.
