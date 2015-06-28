MODULE Sel04;
(*% Record Parameter *)
IMPORT S:=Sel03;

VAR r:S.tRec1;

PROCEDURE P1(r:S.tRec1);
BEGIN (* P1 *)
 r.r1.r2.r3.r4.s5:={}; 
END P1;

PROCEDURE P2(VAR r:S.tRec1);
BEGIN (* P2 *)
 r.r1.r2.r3.r4.s5:={}; 
END P2;

BEGIN (* Sel04 *)
 P1(r);
 P2(r);
END Sel04.
