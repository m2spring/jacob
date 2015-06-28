MODULE POS;
(*
 * Provides a data type 'source position'.
 *)

IMPORT Positions;

TYPE tPosition*  = Positions.tPosition;

VAR  NoPosition- : tPosition; (* The empty position (line 0, column 0). *)

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE IncCol*(VAR Position : tPosition; n:LONGINT);
BEGIN (* IncCol *)
 INC(Position.Column,SHORT(n));
END IncCol;

(*------------------------------------------------------------------------------------------------------------------------------*)
PROCEDURE Compare*(VAR p, q : tPosition) :LONGINT; 
BEGIN (* Compare *)
 IF    p.Line < q.Line THEN RETURN -1;
 ELSIF p.Line > q.Line THEN RETURN  1;
                       ELSE IF    p.Column < q.Column THEN RETURN -1;
                            ELSIF p.Column > q.Column THEN RETURN  1;
                                                      ELSE RETURN  0;
                            END; (* IF *)
 END; (* IF *)
END Compare;

(*------------------------------------------------------------------------------------------------------------------------------*)
BEGIN (* POS *)
 NoPosition.Line   := 0;
 NoPosition.Column := 0;
END POS.


