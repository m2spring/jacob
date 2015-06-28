MODULE Test; 
VAR f:BOOLEAN; 

PROCEDURE True; BEGIN (* True *) END True;
PROCEDURE False; BEGIN (* False *) END False;

BEGIN
 IF TRUE & f THEN True; ELSE False; END;
 IF f & TRUE THEN True; ELSE False; END;
 IF FALSE & f THEN True; ELSE False; END;
 IF f & FALSE THEN True; ELSE False; END;
END Test.

