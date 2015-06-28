(* 11. Modules                                                                *)
(* A module must not import itself.                                           *)

MODULE emod003f;

IMPORT edec001t, SERV:=emod003f;
(*                     ^--- Cyclic imports not allowed *)

END emod003f.
