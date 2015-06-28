MODULE Oper03;
(*% Operators: numeric / numeric -> smallest real including both *)

IMPORT O:=Out;

PROCEDURE P;
VAR si1, si2, si3, si4 :SHORTINT; 
    in1, in2, in3, in4 :INTEGER; 
    li1, li2, li3, li4 :LONGINT; 
    re1, re2, re3, re4 :REAL;
    lr1, lr2, lr3, lr4 :LONGREAL;

BEGIN (* P *)
 si1:= 1; si2:= 2; si3:= 3; si4:= 4; 
 in1:=LONG(-1); in2:=LONG(-2); in3:=LONG(-3); in4:=LONG(-4); 
 li1:=100000; li2:=200000; li3:=300000; li4:=400000; 
 re1:=1.0; re2:=2.0; re3:=3.0; re4:=4.0; 
 lr1:=1.0D2; lr2:=2.0D2; lr3:=3.0D2; lr4:=4.0D2; 
   
 O.Real(si4/si3); O.Ln;                                            (* 1.333... *)
 O.Real(in3/(-si1)); O.Ln;                                         (* 3        *)
 O.Longreal(li2/lr2); O.Ln;                                        (* 1000     *)
 O.Longreal(si3+in2*re4-lr2+lr3/lr4-in3/in2/in1+lr4); O.Ln;        (* 197.25   *)
END P;

BEGIN (* Oper03 *)
 P; 
END Oper03.
