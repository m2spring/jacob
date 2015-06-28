MODULE For02;
(*% For-Statement: Border check *)

IMPORT O:=Out;

VAR si:SHORTINT;
    i :INTEGER;

PROCEDURE PrintI(i:INTEGER);
BEGIN (* PrintI *)
 O.Str('i='); O.Int(i); O.Ln;
END PrintI;

BEGIN (* For02 *)
  FOR i:=0 TO MAX(SHORTINT) DO       (* i must not be SHORTINT *)
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');

  FOR i:=1 TO 1 DO
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');

  FOR i:=1 TO 4 BY 2 DO
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');

  i:=5; 
  FOR i:=0 TO i DO                   (* see Oberon2.ChangeList.Text *)
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');

  FOR i:=1 TO 0 DO
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');

  i:=1;
  FOR i:=i TO i DO
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');

  FOR i:=1 TO 2 DO
   i:=20;
   PrintI(i);
  END; (* FOR i *)
  O.StrLn('----');

  FOR i:=1 TO 100 BY -1 DO
   PrintI(i);
  END; (* FOR *)
  O.StrLn('----');
END For02.
