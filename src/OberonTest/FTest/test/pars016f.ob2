(* RecordTypes *)

MODULE pars016f;

TYPE

A = RECORD
     VAR a:Type1;
(*   ^--- illegal VAR *)
(* Pos: 8,6           *)

    END;

END pars016f.
