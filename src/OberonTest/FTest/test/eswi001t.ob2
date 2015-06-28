(* 9.11 With statements                                                       *)
(*                                                                            *)
(* If v is a variable parameter of record type or a pointer variable, and if  *)
(* it is of a static type T0, the statement [...] has the following meaning.. *)

MODULE eswi001t;

TYPE
 T0 = RECORD
       s:SET;
      END;

 T1 = RECORD(T0)
       i:INTEGER;
      END;

 T2 = RECORD(T1)
       b:BOOLEAN;
      END;

PT0 = POINTER TO T0;
PT1 = POINTER TO T1;
PT2 = POINTER TO T2;

VAR
 p : PT0;

PROCEDURE P(VAR r:T0);
BEGIN
 WITH   r:T0 DO r.s:={}; 
      | r:T1 DO r.i:=1;
      | r:T2 DO r.b:=TRUE;
 END;
END P;

BEGIN
 WITH   p:PT0 DO p.s:={}; 
      | p:PT1 DO p.i:=1;
      | p:PT2 DO p.b:=FALSE;
 END;

END eswi001t.
