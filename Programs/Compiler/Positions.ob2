MODULE Positions;

TYPE T*  = RECORD
            line*,column*:LONGINT; 
           END;
VAR  MT- : T;

BEGIN (* Positions *)
 MT.line:=0; MT.column:=0; 
END Positions.
