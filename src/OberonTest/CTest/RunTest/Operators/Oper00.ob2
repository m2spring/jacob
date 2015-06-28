MODULE Oper00;
(*% Operators: numeric {+ - * } numeric -> smallest numeric including both *)

IMPORT O:=Out;

VAR si, si1, si2, si3, si4 :SHORTINT; 
    
BEGIN (* Oper00 *)
 si1:= 1; si2:= 2; si3:= 3; si4:= 4; 

 O.Int(si1+si2*si3-si4); O.Ln; (* 3 *)

END Oper00.

