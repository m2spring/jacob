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

MODULE east001f;

TYPE
  T  = RECORD 
        g,h : INTEGER;
       END;
  T2 = RECORD
        g,h: INTEGER; 
       END;


VAR
 a : RECORD
      f:INTEGER;
     END;

 b : RECORD
      f:INTEGER;
     END;

PROCEDURE^ Q(VAR r:T);
PROCEDURE Q(VAR r:T2); END Q;
(*        ^--- Actual declaration doesn't match with forward decl *)
(* Pos: 34,11                                                     *)

BEGIN
 a:=b; 
(*  ^--- Expression not assignment compatible *)
(* Pos: 39,5                                  *)

END east001f.

