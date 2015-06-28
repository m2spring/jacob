(* 6. Type declarations                                                       *)
(* A type must not be used in its own declaration except as a pointer base    *)
(* type or a type of a formal variable parameter.                             *)
 
MODULE etyp001f;
  TYPE A = RECORD
            x : A;
(*              ^--- Illegal recursive type application *)
(* Pos: 7,17                                            *)
           END;
 
  TYPE B = ARRAY 3 OF B;
(*                    ^--- Illegal recursive type application *)
(* Pos: 12,23                                                 *)
 
END etyp001f.
