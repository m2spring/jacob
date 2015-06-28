MODULE Index;
IMPORT O:=Out; 
VAR s:ARRAY 20 OF CHAR; 
    i:LONGINT; 

PROCEDURE P(s:ARRAY OF CHAR);
BEGIN (* P *)
 i:=3; 
 s[i]:=0X; 
END P;

BEGIN (* Index *)
(*
 P('abc'); 
*)
 i:=19;
 s[i]:=0X; 
 O.String('Index is OK'); O.Ln;
END Index.
