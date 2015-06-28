(* 11. Modules                                                                *)
(* The import list specifies the names of the imported modules. If a          *)
(* module A is imported by a module M and A exports an identifier x, then     *)
(* x is referred to as A.x within M. If A is imported as B := A, the          *)
(* object x must be referenced as B.x.                                        *)

MODULE emod001f;

IMPORT edec001t;

CONST short=edec001t.cshortint;

VAR
 si : tShortint;
(*    ^--- Identifier not declared *)
(* Pos: 14,7                       *)

TYPE T = RECORD(t1Record)
(*              ^--- Identifier not declared *)
(* Pos: 18,17                                *)

         END;

END emod001f.

