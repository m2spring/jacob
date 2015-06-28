MODULE Oper05;
(*% Operators: integer { DIV MOD } integer -> smallest integer including both *)

IMPORT O:=Out;

CONST ArrayLen = 20;
      Divisor  = 3;

TYPE tArgument = ARRAY ArrayLen OF INTEGER;

VAR Arg : tArgument;
    i ,j:INTEGER; 

BEGIN (* Oper05 *)
 i:=(ArrayLen DIV 2);
 IF ~ODD(ArrayLen)
    THEN DEC(i); 
 END; (* IF *)
 i:=-i; 
 
 FOR j:=0 TO LEN(Arg)-1 DO
  Arg[j]:=i; 
  INC(i); 
 END; (* FOR *)
 
 FOR j:=0 TO LEN(Arg)-1 DO
  O.Int(Arg[j]); O.Str(' DIV '); O.Int(Divisor); O.Str('=');
  O.Int(Arg[j] DIV Divisor); O.Str('   ');
  O.Int(Arg[j]); O.Str(' MOD '); O.Int(Divisor); O.Str('=');
  O.Int(Arg[j] MOD Divisor); O.Ln;
 END; (* FOR *)
END Oper05.
