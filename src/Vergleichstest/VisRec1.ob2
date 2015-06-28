MODULE VisRec1;
IMPORT M:=VisRec0;
TYPE
   T = RECORD(M.T)
        f: INTEGER;
(*                 ^ err 1: multiply defined identifier *)
        g: CHAR;
       END;
PROCEDURE (VAR r: T) P1(c: CHAR); END P1;
PROCEDURE (VAR r: T) P2(c: CHAR); END P2;
(*                              ^ err 116: number of parameters doesn't match *)
END VisRec1.
