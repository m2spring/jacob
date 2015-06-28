MODULE Oper04;
(*% Operators: SET { + - * / } SET -> SET *)

IMPORT O:=Out;

VAR s, se1, se2, se3, se4, se5: SET;

(************************************************************************************************************************)
PROCEDURE P;
VAR s, se1, se2, se3, se4, se5: SET;

 PROCEDURE Q;

  PROCEDURE R;

   PROCEDURE S;
   BEGIN (* S *)
    se1:={1..4,5}; 
    se2:={6,7,8..12,13}; 
    se3:={3..5};
    se4:={2,3..8,9..12}; 
    se5:={0..8,12,17..19,29,30,31}; 
    s:=se1 + se2; O.Set(s); O.Ln;                  (* 1..13   *)
    s:=se1-se3; O.Set(s); O.Ln;                    (* 1,2     *)
    s:=se1*se3; O.Set(s); O.Ln;                    (* 3,4,5   *)
    s:=se1/se4; O.Set(s); O.Ln;                    (* 1,6..12 *)
    s:=se1+se2/se4-(-se3)+(se1*se2)/se5+se2*se3;   (* se5     *)
    IF s = se5
       THEN O.StrLn('OK');
       ELSE O.StrLn('FALSCH');
    END; (* IF *)
    O.Set(s); O.Ln;
    
    se1:={1..4}; se2:={5}; 
    O.Set(se1/se2); O.Ln;                        (* 1,2,3,4,5 *)
    se3:={0..4,27..30,31}; se4:={2,28..29};
    O.Set(se3-se4); O.Ln;                        (* 0,1,3,4,27,30,31 *)
    O.Set(se3*(-se4)); O.Ln;                     (* 0,1,3,4,27,30,31 *)
    
    se1:={2,3..8,9..12}; se2:={1..4,10,12..15}; 
    O.Set(se1/se2); O.Ln;                        (* 1,5..9,11,13..15 *)
    O.Set((se1-se2)+(se2-se1)); O.Ln;             (* 1,5..9,11,13..15 *)
   END S;
  BEGIN (* R *)
   S;
  END R;
 BEGIN (* Q *)
  R;
 END Q;

BEGIN (* P *)
 Q;
END P;

BEGIN (* Oper04 *)
 se1:={1..4,5}; 
 se2:={6,7,8..12,13}; 
 se3:={3..5};
 se4:={2,3..8,9..12}; 
 se5:={0..8,12,17..19,29,30,31}; 
 s:=se1 + se2; O.Set(s); O.Ln;                (* 1..13   *)
 s:=se1-se3; O.Set(s); O.Ln;                  (* 1,2     *)
 s:=se1*se3; O.Set(s); O.Ln;                  (* 3,4,5   *)
 s:=se1/se4; O.Set(s); O.Ln;                  (* 1,6..12 *)
 s:=se1+se2/se4-(-se3)+(se1*se2)/se5+se2*se3; (* se5     *)
 IF s = se5
    THEN O.StrLn('OK');
    ELSE O.StrLn('FALSCH');
 END; (* IF *)
 O.Set(s); O.Ln;
 
 se1:={1..4}; se2:={5}; 
 O.Set(se1/se2); O.Ln;                        (* 1,2,3,4,5 *)
 se3:={0..4,27..30,31}; se4:={2,28..29};
 O.Set(se3-se4); O.Ln;                        (* 0,1,3,4,27,30,31 *)
 O.Set(se3*(-se4)); O.Ln;                     (* 0,1,3,4,27,30,31 *)
 
 se1:={2,3..8,9..12}; se2:={1..4,10,12..15}; 
 O.Set(se1/se2); O.Ln;                        (* 1,5..9,11,13..15 *)
 O.Set((se1-se2)+(se2-se1)); O.Ln;            (* 1,5..9,11,13..15 *)

 O.StrLn('Outer:');
 P;
END Oper04.

