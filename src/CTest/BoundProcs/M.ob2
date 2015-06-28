MODULE M;
TYPE R=RECORD END;
     P=POINTER TO R;
VAR  vR:R;
     vP:P;

PROCEDURE (    r:P)ProcP; BEGIN END ProcP;
PROCEDURE (VAR r:R)ProcR; BEGIN END ProcR;

BEGIN (* M *)           
 vR.ProcR;
 vR.ProcP;
 vP.ProcR;
 vP.ProcP;
END M.
