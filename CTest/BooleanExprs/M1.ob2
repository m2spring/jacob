MODULE M1;
IMPORT O:=Out; 
VAR se:SET;
    si:SHORTINT; in:INTEGER; li:LONGINT; 
    f,g,h:BOOLEAN; 
    re1,re2:REAL;
BEGIN (* M1 *)	 
(*<<<<<<<<<<<<<<<
 se:={1,2,3,5,7,11,13,17,19,23}; 
 f:=TRUE; 
 O.Str('{'); 
 FOR li:=-200000 TO 200000 DO
  g:=li IN se; 
  IF g THEN 
     IF f THEN f:=FALSE; ELSE O.Str(','); END; (* IF *)
     O.Int(li); 
  END; (* IF *)
 END; (* FOR *)
 O.StrLn('}'); 
>>>>>>>>>>>>>>>*)
 f:=re1>re2; 
 
 IF re1>re2
    THEN si:=1; 
    ELSE si:=2; 
 END; (* IF *)
END M1.
