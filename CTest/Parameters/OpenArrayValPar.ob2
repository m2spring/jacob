MODULE OpenArrayValPar;

PROCEDURE P1(s:ARRAY OF CHAR);
BEGIN (* P1 *)
END P1;

BEGIN (* OpenArrayValPar *)
 P1(''); 
 P1(0X); 
 P1('1'); 
 P1('12'); 
 P1('123'); 
END OpenArrayValPar.
