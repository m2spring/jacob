(* 11. Modules                                                                *)
(* The import list specifies the names of the imported modules. If a          *)
(* module A is imported by a module M and A exports an identifier x, then     *)
(* x is referred to as A.x within M. If A is imported as B := A, the          *)
(* object x must be referenced as B.x.                                        *)

MODULE emod001t;

IMPORT edec001t;

CONST short=edec001t.cshortint;

VAR
 si : edec001t.tShortint;
 r  : edec001t.tReal;

TYPE T = RECORD(edec001t.t1Record)
         END;

END emod001t.
