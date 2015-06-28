MODULE M3;
IMPORT O:=Out;

TYPE T0 = RECORD
           f:ARRAY 4711 OF CHAR; 
          END;
     T1 = RECORD(T0)
           a:LONGINT; 
          END;
VAR v0:T0; v1:T1; 
    p0:POINTER TO T0; p1:POINTER TO T1;

PROCEDURE P(VAR a:T0);

(*<<<<<<<<<<<<<<<
 PROCEDURE Q;
 BEGIN (* Q *)
  a:=v0; 
 END Q;
>>>>>>>>>>>>>>>*)

BEGIN (* P *)           
 WITH a:T1 DO O.Str('TYPE(v0)=T1 '); 
 |    a:T0 DO O.Str('TYPE(v0)=T0 '); 
 END; (* WITH *)
 a:=v0;            
 O.StrLn('OK.'); 
(*<<<<<<<<<<<<<<<
 a:=v1; 
>>>>>>>>>>>>>>>*)
END P;

BEGIN (* M3 *)
(*<<<<<<<<<<<<<<<
 P(v0); 
 P(v1); 
>>>>>>>>>>>>>>>*)
 
 NEW(p0); 
 NEW(p1); 
 
 O.StrLn('A'); 
 p0^:=v0; 
 O.StrLn('B'); 
 p0^:=v1; 
 O.StrLn('C'); 
 
 p0:=p1; 
 O.StrLn('D'); 
 p0^:=v0; 
 O.StrLn('E'); 
 p0^:=v1; 
END M3.
