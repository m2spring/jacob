MODULE ExpMark;
 
CONST c-=1;
TYPE T-=INTEGER;
PROCEDURE P-; BEGIN END P;
 
PROCEDURE ^P0; PROCEDURE P0; END P0;
 
PROCEDURE ^P1; PROCEDURE P1-; END P1;
(*                          ^ err 118: export mark doesn't match with forward declaration *)
 
PROCEDURE ^P2; PROCEDURE P2*; END P2;
(*                          ^ err 118: export mark doesn't match with forward declaration *)
 
PROCEDURE ^P3-; PROCEDURE P3; END P3;
(*                          ^ err 118: export mark doesn't match with forward declaration *)
 
PROCEDURE ^P4-; PROCEDURE P4-; END P4;
 
PROCEDURE ^P5-; PROCEDURE P5*; END P5;
(*                           ^ err 118: export mark doesn't match with forward declaration *)
 
PROCEDURE ^P6*; PROCEDURE P6; END P6;
(*                          ^ err 118: export mark doesn't match with forward declaration *)
 
PROCEDURE ^P7*; PROCEDURE P7-; END P7;
(*                           ^ err 118: export mark doesn't match with forward declaration *)
 
PROCEDURE ^P8*; PROCEDURE P8*; END P8;
 
END ExpMark.
