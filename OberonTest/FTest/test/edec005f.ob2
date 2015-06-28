(* 4. Declaration and scope rules *)
MODULE edec005f;

TYPE
  Forward = POINTER TO Deferred;
(*                     ^--- Unresolved forward reference *)
(* Pos: 5,24                                             *)
VAR
  appPtr : Forward;

END edec005f.
