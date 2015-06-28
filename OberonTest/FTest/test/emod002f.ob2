(* 11. Modules                                                                *)
(* The import list specifies the names of the imported modules. If a          *)
(* module A is imported by a module M and A exports an identifier x, then     *)
(* x is referred to as A.x within M. If A is imported as B := A, the          *)
(* object x must be referenced as B.x.                                        *)

MODULE emod002f;

IMPORT SERV:=edec001t;

CONST short=edec001t.cshortint;
(*          ^--- Identifier not declared *)

VAR
 si : SERV.tShortint;
 r  : edec001t.tReal;
(*    ^--- Identifier not declared *)

TYPE T = RECORD(SERV.t1Record)
         END;

END emod002f.
