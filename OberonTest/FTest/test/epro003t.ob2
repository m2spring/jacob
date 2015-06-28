(* 10. Procedure declarations                                                 *)
(*    Objects declared in the environment of the                              *)
(*    procedure are also visible in those parts of the procedure in which     *)
(*    they are not concealed by a locally declared object with the same name. *)

MODULE epro003t;

CONST
 c = 1;

VAR
 i: INTEGER;
 s: SET;
 b: BOOLEAN;

TYPE
 T1 = RECORD
       f: INTEGER;
      END;

VAR
 t:T1;

PROCEDURE P(VAR r:T1; i:REAL; T1:BOOLEAN);
VAR
 s:REAL;
BEGIN
 r.f:=1;
 i  :=s; 
 T1 :=TRUE; 
 T1 :=b; 
 r.f:=c; 
END P;

BEGIN
 i:=1;
 t.f:=2; 
 s:={}; 
 b:=FALSE; 
END epro003t.
