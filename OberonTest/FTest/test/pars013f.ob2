(* FormalPars und FPSection *)

MODULE pars013f;

PROCEDURE Laber(VAR a,b,c:Type1; VAR e,b,VAR c:Type2);
(*                                       ^--- illegal VAR *)
(* Pos: 5,42                                              *)

END Laber;

END pars013f.
