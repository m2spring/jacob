(* 9.11 With statements                                                       *)
(*                                                                            *)
(* If v is a variable parameter of record type or a pointer variable, and if  *)
(* it is of a static type T0, the statement [...] has the following meaning.. *)
 
MODULE eswi001f;
 
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
 
VAR
 p : POINTER TO T2;
 
PROCEDURE P(r:T0);
BEGIN
 WITH   r:T1 DO r.i:=1;
(*       ^--- Guard not applicable *)
(* Pos: 26,10                      *)
 
 END;
END P;
 
BEGIN
 WITH   p:T1 DO p.i:=1;
(*       ^--- Guard not applicable *)
(* Pos: 34,10                      *)
 
 END;
END eswi001f.
