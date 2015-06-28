MODULE M1;
IMPORT O:=Out;
VAR si:SHORTINT; in:INTEGER; li:LONGINT; c:CHAR; 
    a:LONGINT; 
BEGIN (* M1 *) 
(*<<<<<<<<<<<<<<<
 FOR li:=-200000 TO 200000 DO
  CASE li OF
  |1,2,3,7,13,17: O.Int(li); O.Str('A '); 
  |0,8,9,10     : O.Int(li); O.Str('B '); 
  |4095         : O.Int(li); O.Str('C '); 
  ELSE            a:=0; 
  END; (* CASE *)
 END; (* FOR *)            
 O.Ln; 
>>>>>>>>>>>>>>>*)
 
 CASE si OF
 |0: ;
 |1: ;
 |127: ;
 END; (* CASE *)
 
 FOR li:=0 TO 255 DO
  CASE CHR(li) OF
  |0X      : O.StrLn('0X'); 
  |'('     : O.StrLn('('); 
  |'0'..'9': O.StrLn('0..9'); 
  |'A'..'Z': O.StrLn('A..Z'); 
  |0FFX    : O.StrLn('0FFX'); 
  ELSE
  END; (* CASE *)
 END; (* FOR *)
END M1.
