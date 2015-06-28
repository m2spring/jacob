(* 10. Procedure declarations                                                 *)
(*    Objects declared in the environment of the                              *)
(*    procedure are also visible in those parts of the procedure in which     *)
(*    they are not concealed by a locally declared object with the same name. *)

MODULE epro003f;

CONST
 c = 1;

VAR
 i: REAL;
 s: SET;
 b: BOOLEAN;

TYPE
 T1 = RECORD
       f: INTEGER;
      END;

VAR
 t:T1;

PROCEDURE P(VAR r:T1; i:INTEGER; T1:BOOLEAN; f:T1);
(*                                             ^--- Type expected *)

VAR
 s:REAL;
 x:T1;
(* ^--- Type expected *)

BEGIN
 s:={};
(*  ^--- Expression not assignment compatible *)

 i:=2.0;
(*  ^--- Expression not assignment compatible *)

 t.f:=1;
END P;

END epro003f.
