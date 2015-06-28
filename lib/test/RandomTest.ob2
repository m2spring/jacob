MODULE RandomTest;
IMPORT Lib,O:=Out;
VAR i:LONGINT; 
BEGIN (* RandomTest *)  
 Lib.RANDOMIZE;
 LOOP
  O.Int(Lib.RANDOM(100)); O.Char(' '); 
 END; (* LOOP *)
END RandomTest.
