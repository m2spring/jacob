MODULE M1;

CONST s1 = "laber bla";
      s2 = 'Hier ist ein "Wort"!';
      r1* = 1.0D0;
      r2 = LONG(ABS(1.0-10)/2); 
      r3=4711.0;
      s3*=s2;
      ch = 'a';

VAR s:ARRAY 50 OF CHAR; 
BEGIN (* M1 *)
 s:=s1; 
END M1.
