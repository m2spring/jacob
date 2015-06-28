MODULE VisRec0;
TYPE
   T* = RECORD
         f: INTEGER;
         g*: CHAR;
        END;
PROCEDURE (VAR r: T) P1; END P1;
PROCEDURE (VAR r: T) P2*; END P2;
END VisRec0.
