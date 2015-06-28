(* 4. Declarations and scope rules                                            *)
(* No identifier may denote more than one object within a given scope         *)
(* i.e. no identifier may be declared twice in a block                        *)

MODULE edec010f;
  VAR x, y :INTEGER;
  PROCEDURE ^ab;
(*           ^--- Unresolved forward procedure *)
(* Pos: 7,14                                   *)

  PROCEDURE ^ab;
(*           ^--- Identifier already declared *)
(* Pos: 11,14                                 *)

  PROCEDURE ab;
  END ab;
END edec010f.
