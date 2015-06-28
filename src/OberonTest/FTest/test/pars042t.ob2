(* Expressions *)

MODULE pars042t;

CONST a1  = laber(5);

CONST a2  = + hurga * 3;

CONST a3  = - 2.0;

CONST a4  = - 3.4D-2 / 'A' / 234 + 7AX DIV "hallohallo";

CONST a5  = NIL + {} MOD {3,1,7,2} + {1,2..5,3,1..1,9} =  - ~~~NIL &  (-2) + 41X &  3 OR hurga - "string";

CONST a6  = ~laber -  2 -  NIL # - 1.0D3 * 'A' - hurga(la.ber^.hu) - (~bla) + {1};

CONST a7  = NIL OR 1 / "hurga" OR {} DIV {3..2,5,2..2,0} < - 2 OR 3X MOD 9 +  {} OR la.ber.hu;

CONST a8  = 1 OR 2 - 3 <= - 4 OR 5 & 6 OR 7 - 8;

CONST a9  = NIL - {2} + 0.0 > - "bla" & 'A' - (la[3,2,1]) - ~bla OR ~"hurga";

CONST a10 = 1 + 41X MOD 65535 OR NIL >= - {} + 5 + 2 DIV 8 + 9;

CONST a11 = (~3) - la^ / bae * 7 - NIL IN - 3 + ~true * 2 OR 4711 + (((~NIL)));

(* a1  = laber(5)                                                                                                                 *)
(* a2  = + (hurga * 3)                                                                                                            *)
(* a3  = - 2.0                                                                                                                    *)
(* a4  = (- ((3.4D-2 / 'A') / 234)) + (7AX DIV "hallohallo" )                                                                     *)
(* a5  = ((NIL +  ({} MOD {3,1,7,2})) +  {1,2..5,3,1..1,9}) = ((( - ( (~(~(~NIL))) & (-2) ) ) +  (41X & 3)) OR  hurga) - "string" *)
(* a6  = (  (~laber - 2) - NIL ) # ( (((- (1.0D3 * 'A')) -  hurga(la.ber^.hu)) -  (~bla)) + {1} )                                 *)
(* a7  = (NIL OR (1 / "hurga")) OR ({} DIV {3..2,5,2..2,0}) < (((- 2) OR (3X MOD 9)) + {}) OR la.ber.hu                           *)
(* a8  = (1 OR 2) - 3 <= ((- 4 OR (5 & 6)) OR 7) - 8                                                                              *)
(* a9  = (NIL - {2}) + 0.0 > (((- ("bla" & 'A')) - (la[3,2,1])) - ~bla) OR ~"hurga"                                               *)
(* a10 = (1 + (41X MOD 65535)) OR NIL >= ((- {} + 5) +  (2 DIV 8)) + 9                                                            *)
(* a11 = ((~3) - ((la^ / bae)  *   7)) - NIL IN  (( - 3 + (~true * 2)) OR 4711) + (((~NIL)))                                      *)

END pars042t.
