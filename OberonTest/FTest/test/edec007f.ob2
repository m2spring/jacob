(* 4. Declaration and scope rules *)
MODULE edec007f;

TYPE
   Rec = RECORD
          field : INTEGER;
         END;
VAR
  i    : INTEGER;

PROCEDURE (VAR r : Rec) BoundProc;
BEGIN
END BoundProc;

BEGIN
   BoundProc;
(* ^--- Identifier not declared *)
(* Pos: 16,4                    *)
   i := field;
(*      ^--- Identifier not declared *)
(* Pos: 19,9                         *)

END edec007f.
