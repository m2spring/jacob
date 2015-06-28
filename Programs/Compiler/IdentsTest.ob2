MODULE IdentsTest;
IMPORT O:=Out,ID:=Idents;

PROCEDURE P(s:ARRAY OF CHAR);
BEGIN (* P *)              
 O.Str('Idents.Make("'); O.Str(s); O.Str('") --> '); O.Int(ID.Make(s)); O.Ln;
END P;

BEGIN (* IdentsTest *)
 P('laber'); 
 P('bla'); 
 P('laber'); 
 P('hurga'); 
 P('wuerg'); 
 P('bla'); 
END IdentsTest.
