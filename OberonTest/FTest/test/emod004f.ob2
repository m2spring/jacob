(* 11. Modules                                                                *)
(* It follows that cyclic import of modules is illegal.                       *)

MODULE emod004f;

IMPORT emod003t;
(*     ^--- Cyclic imports not allowed *)

CONST
   c = emod003t.a;

END emod004f.
