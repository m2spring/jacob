(* 4. Declaration and scope rules                                             *)
(* In identifier x exported by a module M may be used in other modules, if    *)
(* they import M. The identifier is then denoted as M.x in these modules.     *)
(* Identifiers marked with "-" in their declaration are read-only in          *)
(* importing modules.                                                         *)

MODULE edec005t;

IMPORT E:=edec001t;

VAR
  i : E.tInt;
  b : E.tBool;
  s : E.tShortint;

BEGIN
 E.vshortint := 2;
 i           := E.vint;
 E.vreal     := 2.0;
 b           := E.vbool;
 s           := E.cshortint;
END edec005t.
