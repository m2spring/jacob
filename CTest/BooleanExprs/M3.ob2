MODULE M3;
IMPORT O:=Out; 
TYPE P = POINTER TO T;
     T = RECORD 
          a:SHORTINT; 
	  n:P;
         END;
VAR h,e:P; a,b,i:LONGINT; f:BOOLEAN; si:SHORTINT; 
BEGIN (* M3 *)	      
(*<<<<<<<<<<<<<<<
 h:=NIL; 
 FOR i:=1 TO 10 DO
  NEW(e); e.a:=SHORT(SHORT(i)); e.n:=h; h:=e; 
 END; (* FOR *)	      
 
 e:=h; 
 WHILE (e#NIL) & (e.a>5) DO
  O.Int(e.a); O.Str(' '); e:=e.n; 
 END; (* WHILE *)     
 
 IF h#NIL THEN 
    e:=h; 
    REPEAT
     O.Int(e.a); O.Str(' '); e:=e.n; 
    UNTIL (e=NIL) OR (e.a<5);
 END; (* IF *)
 O.Ln;
>>>>>>>>>>>>>>>*)
 f:=(si=0); 
END M3.
