MODULE Oper07;
(*% Operators: character array,string {=,#,<,<=,>,>=} character array,string *)
(*%            Global- & Local-Var                                           *)

IMPORT O:=Out;

(************************************************************************************************************************)
PROCEDURE CompStr;
VAR a1,a2: ARRAY 10 OF CHAR; 
BEGIN (* CompStr *)
 O.Str('char-array <-> char-array'); O.Ln;
 a1:='abcde'; a2:='abcde';
 IF a1=a2 THEN O.Str(a1); O.Str(' = '); O.Str(a2); O.Ln; END;
 IF a1#a2 THEN O.Str(a1); O.Str(' # '); O.Str(a2); O.Ln; END;
 IF a1<a2 THEN O.Str(a1); O.Str(' < '); O.Str(a2); O.Ln; END;
 IF a1<=a2 THEN O.Str(a1); O.Str(' <= '); O.Str(a2); O.Ln; END;
 IF a1>a2 THEN O.Str(a1); O.Str(' > '); O.Str(a2); O.Ln; END;
 IF a1>=a2 THEN O.Str(a1); O.Str(' >= '); O.Str(a2); O.Ln; END;
 O.Ln;
 
 O.Str('char-array <-> char-array'); O.Ln;
 a1:='abcd'; a2:='abcde';
 IF a1=a2 THEN O.Str(a1); O.Str(' = '); O.Str(a2); O.Ln; END;
 IF a1#a2 THEN O.Str(a1); O.Str(' # '); O.Str(a2); O.Ln; END;
 IF a1<a2 THEN O.Str(a1); O.Str(' < '); O.Str(a2); O.Ln; END;
 IF a1<=a2 THEN O.Str(a1); O.Str(' <= '); O.Str(a2); O.Ln; END;
 IF a1>a2 THEN O.Str(a1); O.Str(' > '); O.Str(a2); O.Ln; END;
 IF a1>=a2 THEN O.Str(a1); O.Str(' >= '); O.Str(a2); O.Ln; END;
 O.Ln;
 
 O.Str('char-array <-> char-array'); O.Ln;
 a1:='abcde'; a2:='abcd';
 IF a1=a2 THEN O.Str(a1); O.Str(' = '); O.Str(a2); O.Ln; END;
 IF a1#a2 THEN O.Str(a1); O.Str(' # '); O.Str(a2); O.Ln; END;
 IF a1<a2 THEN O.Str(a1); O.Str(' < '); O.Str(a2); O.Ln; END;
 IF a1<=a2 THEN O.Str(a1); O.Str(' <= '); O.Str(a2); O.Ln; END;
 IF a1>a2 THEN O.Str(a1); O.Str(' > '); O.Str(a2); O.Ln; END;
 IF a1>=a2 THEN O.Str(a1); O.Str(' >= '); O.Str(a2); O.Ln; END;
 O.Ln;

 O.Str('char-array <-> char-array'); O.Ln;
 a1:='abcde'; a2:='vwxyz';
 IF a1=a2 THEN O.Str(a1); O.Str(' = '); O.Str(a2); O.Ln; END;
 IF a1#a2 THEN O.Str(a1); O.Str(' # '); O.Str(a2); O.Ln; END;
 IF a1<a2 THEN O.Str(a1); O.Str(' < '); O.Str(a2); O.Ln; END;
 IF a1<=a2 THEN O.Str(a1); O.Str(' <= '); O.Str(a2); O.Ln; END;
 IF a1>a2 THEN O.Str(a1); O.Str(' > '); O.Str(a2); O.Ln; END;
 IF a1>=a2 THEN O.Str(a1); O.Str(' >= '); O.Str(a2); O.Ln; END;
 O.Ln;
END CompStr;

(************************************************************************************************************************)
PROCEDURE CompConstStr;
VAR a1,a2: ARRAY 10 OF CHAR; 
BEGIN (* CompConstStr *)
 O.Str('string <-> char-array'); O.Ln;
 a2:='abcde'; 
 O.Str('abcde'); O.Str(' is { ');
 IF 'abcde'=a2 THEN O.Str('= '); END;
 IF 'abcde'#a2 THEN O.Str('# '); END;
 IF 'abcde'<a2 THEN  O.Str('< ');  END;
 IF 'abcde'<=a2 THEN O.Str('<= ');  END;
 IF 'abcde'>a2 THEN O.Str('> '); END;
 IF 'abcde'>=a2 THEN O.Str('>= '); END;
 O.Str(' } '); O.Str(a2); O.Ln;
 O.Ln;

 O.Str('string <-> char-array'); O.Ln;
 a2:='abcd'; 
 O.Str('abcde'); O.Str(' is { ');
 IF 'abcde'=a2 THEN O.Str('= '); END;
 IF 'abcde'#a2 THEN O.Str('# '); END;
 IF 'abcde'<a2 THEN  O.Str('< ');  END;
 IF 'abcde'<=a2 THEN O.Str('<= ');  END;
 IF 'abcde'>a2 THEN O.Str('> '); END;
 IF 'abcde'>=a2 THEN O.Str('>= '); END;
 O.Str(' } '); O.Str(a2); O.Ln;
 O.Ln;

 O.Str('char-array <-> string'); O.Ln;
 a1:='abcd'; 
 O.Str(a1); O.Str(' is { ');
 IF a1='abcde' THEN O.Str('= '); END;
 IF a1#'abcde' THEN O.Str('# '); END;
 IF a1<'abcde' THEN  O.Str('< ');  END;
 IF a1<='abcde' THEN O.Str('<= ');  END;
 IF a1>'abcde' THEN O.Str('> '); END;
 IF a1>='abcde' THEN O.Str('>= '); END;
 O.Str(' } '); O.Str('abcde'); O.Ln;
 O.Ln;

 O.Str('char-array <-> string'); O.Ln;
 a1:='ab'; 
 O.Str(a1); O.Str(' is { ');
 IF a1='xy' THEN O.Str('= '); END;
 IF a1#'xy' THEN O.Str('# '); END;
 IF a1<'xy' THEN  O.Str('< ');  END;
 IF a1<='xy' THEN O.Str('<= ');  END;
 IF a1>'xy' THEN O.Str('> '); END;
 IF a1>='xy' THEN O.Str('>= '); END;
 O.Str(' } '); O.Str('xy'); O.Ln;
 O.Ln;
END CompConstStr;

(************************************************************************************************************************)
PROCEDURE CompCharStr;
VAR a1,a2: ARRAY 10 OF CHAR; 
BEGIN (* CompCharStr *)
 O.Str('char-array <-> char'); O.Ln;
 a1:='ab';
 O.Str(a1); O.Str(' is { ');
 IF a1='c' THEN O.Str('= '); END;
 IF a1#'c' THEN O.Str('# '); END;
 IF a1<'c' THEN  O.Str('< ');  END;
 IF a1<='c' THEN O.Str('<= ');  END;
 IF a1>'c' THEN O.Str('> '); END;
 IF a1>='c' THEN O.Str('>= '); END;
 O.Str(' } '); O.Char('c'); O.Ln;
 O.Ln;
 
 O.Str('char-array <-> char'); O.Ln;
 a1:='ab';
 O.Str(a1); O.Str(' is { ');
 IF a1=41X THEN O.Str('= '); END;
 IF a1#41X THEN O.Str('# '); END;
 IF a1<41X THEN  O.Str('< ');  END;
 IF a1<=41X THEN O.Str('<= ');  END;
 IF a1>41X THEN O.Str('> '); END;
 IF a1>=41X THEN O.Str('>= '); END;
 O.Str(' } '); O.Char(41X); O.Ln;
 O.Ln;

 O.Str('char <-> char-array'); O.Ln;
 a2:='vw';
 O.Str('3'); O.Str(' is { ');
 IF '3'=a2 THEN O.Str('= '); END;
 IF '3'#a2 THEN O.Str('# '); END;
 IF '3'<a2 THEN  O.Str('< ');  END;
 IF '3'<=a2 THEN O.Str('<= ');  END;
 IF '3'>a2 THEN O.Str('> '); END;
 IF '3'>=a2 THEN O.Str('>= '); END;
 O.Str(' } '); O.Str(a2); O.Ln;
 O.Ln;
END CompCharStr;

(************************************************************************************************************************)
PROCEDURE CompEmptyStr;
VAR a1,a2: ARRAY 10 OF CHAR; 
BEGIN (* CompEmptyStr *)
 O.Str('empty-string <-> char-array'); O.Ln;
 a2:='vw';
 O.Str("''"); O.Str(' is { ');
 IF ''=a2 THEN O.Str('= '); END;
 IF ''#a2 THEN O.Str('# '); END;
 IF ''<a2 THEN  O.Str('< ');  END;
 IF ''<=a2 THEN O.Str('<= ');  END;
 IF ''>a2 THEN O.Str('> '); END;
 IF ''>=a2 THEN O.Str('>= '); END;
 O.Str(' } '); O.Str(a2); O.Ln;
 O.Ln;

 O.Str('char-array <-> empty-string'); O.Ln;
 a1:='xyz';
 O.Str(a1); O.Str(' is { ');
 IF a1="" THEN O.Str('= '); END;
 IF a1#"" THEN O.Str('# '); END;
 IF a1<"" THEN  O.Str('< ');  END;
 IF a1<="" THEN O.Str('<= ');  END;
 IF a1>"" THEN O.Str('> '); END;
 IF a1>="" THEN O.Str('>= '); END;
 O.Str(' } '); O.Str('""'); O.Ln;
 O.Ln;

END CompEmptyStr;

(************************************************************************************************************************)
BEGIN (* Oper07 *)
 CompStr;
 O.Str('***************************************'); O.Ln;
 CompConstStr;
 O.Str('***************************************'); O.Ln;
 CompCharStr;
 O.Str('***************************************'); O.Ln;
 CompEmptyStr;
END Oper07.
