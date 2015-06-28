MODULE StringsTest;
IMPORT O:=Out,S:=Strings;

VAR s:ARRAY 100 OF CHAR; 
BEGIN (* StringsTest *)
 s:='012abcz!(/"ABCZ0'; 
 O.Str(s); O.Ln;
 S.Cap(s); 
 O.Str(s); O.Ln;
END StringsTest.
