MODULE For01; 
(*% For-Statement: Control var is global, local and outer *)

IMPORT O:=Out;
VAR i:LONGINT; 

PROCEDURE P;
VAR i:LONGINT; 

  PROCEDURE Q;
  BEGIN (* Q *)
   O.StrLn('Outer(20-29)');
   FOR i:=20 TO 29 DO
    O.Str('i='); O.Int(i); O.Ln;
   END; (* FOR *)
  END Q;

BEGIN (* P *)
 O.StrLn('Local(10-19)');
 FOR i:=10 TO 19 DO
  O.Str('i='); O.Int(i); O.Ln;
 END; (* FOR *)
 Q;
END P;

BEGIN (* For01 *)
 O.StrLn('Global(0-9)');
 FOR i:=0 TO 9 DO
  O.Str('i='); O.Int(i); O.Ln;
 END; (* FOR *)
 P;
END For01.
