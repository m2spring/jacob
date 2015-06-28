FOREIGN MODULE NDP;

CONST ZERO = 0.0;
      ONE  = 1.0;
      L2E  = 1.442695041; (* log2(e)  *)
      L2T  = 3.321928095; (* log2(10) *)
      LG2  = 0.301029995; (* log10(2) *)
      LN2  = 0.69314718;  (* ln(2)    *)
      PI   = 3.141592654; (* PI       *)

PROCEDURE FCOS*(a:LONGREAL):LONGREAL; END FCOS;
(* cos(a) *)

PROCEDURE FPATAN*(a,b:LONGREAL):LONGREAL; END FPATAN;
(* atan(a/b) *)

END NDP.
