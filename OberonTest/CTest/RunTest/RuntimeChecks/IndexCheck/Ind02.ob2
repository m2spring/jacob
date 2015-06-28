MODULE Ind02;
IMPORT O:=Out;

VAR
 p1 : POINTER TO ARRAY OF CHAR;
 
PROCEDURE Print(a: ARRAY OF CHAR);
BEGIN (* Print *)
 O.String('a[0]='); O.Char(a[0]); O.Ln;
 O.String('a[1]='); O.Char(a[1]); O.Ln;
 O.String('a[2]='); O.Char(a[2]); O.Ln;
 O.String('a[3]='); O.Char(a[3]); O.Ln;
END Print;


BEGIN (* Ind02 *)
 NEW(p1,4);

 COPY('abcd',p1^);
 Print(p1^);

 NEW(p1,5);

 COPY('abcd',p1^);
 Print(p1^);

END Ind02.
