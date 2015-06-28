(* 6. Type declarations : Basic types                                         *)
(* They form a hierarchy; the larger type includes (the values of) the        *)
(* smaller type:                                                              *)
(*      LONGREAL  >=  REAL  >=  LONGINT  >=  INTEGER  >=  SHORTINT            *)

MODULE etba001f;

VAR
  vshortint : SHORTINT;
  vint      : INTEGER;
  vlongint  : LONGINT;
  vreal     : REAL;
  vlongreal : LONGREAL;

BEGIN
 vshortint := MAX(SHORTINT);
 vint      := MAX(INTEGER);
 vlongint  := MAX(LONGINT);
 vreal     := MAX(REAL);
 vlongreal := MAX(LONGREAL);

 vshortint := vint;
 (*           ^--- Expression not assignment compatible *)
 (* Pos: 22,15                                          *)

 vint      := vlongint;
 (*           ^--- Expression not assignment compatible *)
 (* Pos: 26,15                                          *)

 vlongint  := vreal;
 (*           ^--- Expression not assignment compatible *)
 (* Pos: 30,15                                          *)

 vreal     := vlongreal;
 (*           ^--- Expression not assignment compatible *)
 (* Pos: 34,15                                          *)

END etba001f.
