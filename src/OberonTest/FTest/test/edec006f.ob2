(* 4. Declaration and scope rules *)
MODULE edec006f;

TYPE
  Forward = POINTER TO Deferred;
(*                     ^--- Unresolved forward reference *)
(* Pos: 5,24                                             *)
VAR
  appPtr : Forward;

PROCEDURE Laber;
TYPE
  Deferred = RECORD
             END;
VAR
  appPtr : Forward;

BEGIN
END Laber;

END edec006f.
