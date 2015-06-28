MODULE M4;
IMPORT O:=Out;

VAR a,b:REAL;
    f:BOOLEAN; 
    
PROCEDURE P(a,b:REAL);
VAR f:BOOLEAN; 
BEGIN (* P *)	    
 O.Str('a='); O.Int(ENTIER(a)); O.Str(' b='); O.Int(ENTIER(b)); O.Ln;
 IF a =  b THEN O.StrLn('a =  b'); END;
 IF a #  b THEN O.StrLn('a #  b'); END;
 IF a >  b THEN O.StrLn('a >  b'); END;
 IF a >= b THEN O.StrLn('a >= b'); END;
 IF a <  b THEN O.StrLn('a <  b'); END;
 IF a <= b THEN O.StrLn('a <= b'); END;
END P;

BEGIN (* M4 *) 
 P(0.0 , 0.0); O.Ln;
 P(0.0 , 1.1); O.Ln;
 P(1.1 , 0.0); O.Ln;
 P(1.1 , 1.1); O.Ln;
END M4.
