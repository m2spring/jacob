MODULE Bug2;
(* Register allocation not possible beim Compilieren -> Abbruch *)
  
(*<<<<<<<<<<<<<<<
TYPE T=RECORD Repr : INTEGER END;
VAR Ident, Ident1 : POINTER TO ARRAY OF T;
    v:T;
>>>>>>>>>>>>>>>*)
VAR Ident, Ident1 : POINTER TO ARRAY OF RECORD Repr : INTEGER END;
    i : LONGINT;


BEGIN
  NEW(Ident, 100); NEW(Ident1, 200);
  FOR i := 1 TO LEN(Ident^) - 1 DO 
(*<<<<<<<<<<<<<<<
   Ident1[i] := v;
>>>>>>>>>>>>>>>*)
   Ident1[i] := Ident[i] 
  END
END Bug2.

