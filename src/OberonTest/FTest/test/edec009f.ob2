(* 4. Declaration and scope rules                                             *)
(* In identifier x exported by a module M may be used in other modules, if    *)
(* they import M. The identifier is then denoted as M.x in these modules.     *)
(* Identifiers marked with "-" in their declaration are read-only in          *)
(* importing modules.                                                         *)

MODULE edec009f;

IMPORT e:=edec001t;

CONST
  b = e.cbool;
(*      ^--- Identifier not exported from qualified module *)
(* Pos: 12,9                                               *)

BEGIN
   e.vint := 2;
(* ^--- Object is read-only *)
(* Pos: 17,4                *)

   e.cshortint := 2;
(* ^--- L-value expected *)
(* Pos: 21,4             *)

END edec009f.
