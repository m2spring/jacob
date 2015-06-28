(* Appendix A: Definition of terms: Same types                                *)
(* Two variables a and b with types Ta and Tb are of the same type if         *)
(* 1.  Ta and Tb are both denoted by the same type identifier, or             *)
(* 2.  Ta is declared to equal Tb in a type declaration of the form           *)
(*     Ta = Tb, or                                                            *)
(* 3.  a and b appear in the same identifier list in a variable, record       *)
(*     field, or formal parameter declaration and are not open arrays.        *)

(* In a forward declaration of a type-bound procedure the receiver            *)
(* parameter must be of the SAME TYPE as in the actual procedure              *)
(* declaration.                                                               *)
(* An expression e of type Te is assignment compatible with a variable v of   *)
(* type Tv if one of the following conditions hold:                           *)
(* 1.  Te and Tv are the SAME TYPE ...                                        *)


MODULE east001t;

TYPE
  T  = RECORD 
       END;
  T2 = T;
  T3 = RECORD
        g,h :T;
       END;

VAR
  j, k : T3;
  r    : T3;

(* 1. *)
PROCEDURE^ P(VAR r:T);
PROCEDURE P(VAR r:T); END P;

(* 2. *)
PROCEDURE^ Q(VAR r:T);
PROCEDURE Q(VAR r:T2); END Q;

(* 3. *)
PROCEDURE Proc(VAR a,b: T3);
BEGIN
 a:=b; 
END Proc;

BEGIN
 r.g:=r.h;
 j:=k;
END east001t.
