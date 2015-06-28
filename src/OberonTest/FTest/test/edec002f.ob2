(* 4. Declaration and scope rules *)
MODULE edec002f;

TYPE
   a = INTEGER;

PROCEDURE proc(x:a; a:CHAR; y:a);
(*                            ^---- Type expected *)
(* Pos: 7,31                                      *)

BEGIN
END proc;

END edec002f.
