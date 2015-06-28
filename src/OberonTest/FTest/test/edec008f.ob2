(* 4. Declaration and scope rules                                             *)
(* In identifier x exported by a module M may be used in other modules, if    *)
(* they import M. The identifier is then denoted as M.x in these modules.     *)
(* Identifiers marked with "-" in their declaration are read-only in          *)
(* importing modules.                                                         *)

MODULE edec008f;

IMPORT e:=edec001t;

CONST f = 10;

VAR
  li : e.tLongint;
(*       ^--- Identifier not exported from qualified module *)
(* Pos: 14,10                                               *)

  d  : e.tGibsnich;
(*       ^--- Identifier not declared in qualified module *)
(* Pos: 18,10                                             *)

  v1 : f.taType;
(*     ^--- Module identifier expected *)
(* Pos: 22,8                           *)

END edec008f.
