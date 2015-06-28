MODULE Oper02;
(*% Operators: numeric {+ - * } numeric -> smallest numeric including both *)

IMPORT O:=Out;

VAR si, si1, si2, si3, si4 :SHORTINT; 
    in, in1, in2, in3, in4 :INTEGER; 
    li, li1, li2, li3, li4 :LONGINT; 
    re, re1, re2, re3, re4 :REAL;
    lr, lr1, lr2, lr3, lr4 :LONGREAL;
    
BEGIN (* Oper02 *)
 si1:= 1; si2:= 2; si3:= 3; si4:= 4; 
 in1:=LONG(-1); in2:=LONG(-2); in3:=LONG(-3); in4:=LONG(-4); 
 li1:=100000; li2:=200000; li3:=300000; li4:=400000; 
 re1:=1.0; re2:=2.0; re3:=3.0; re4:=4.0; 
 lr1:=1.0D2; lr2:=2.0D2; lr3:=3.09D2; lr4:=4.0D2; 

 O.Int(si1+si2*(-in3)-si4); O.Ln;                   (* 3       *)
 O.Int(in1+in2*in3-in4); O.Ln;                      (* 9       *)
 O.Int(((li2-li1)*si3-li3)*li4); O.Ln;              (* 0       *)
 O.Int(((li2-li1)*si3-li3)*li4+li4); O.Ln;          (* 400.000 *)

 O.Real((re1+re2+re4-re3)*re2); O.Ln;               (* 8       *)
 O.Longreal(lr3*re2-lr4+lr1); O.Ln;                 (* 318     *)
END Oper02.
