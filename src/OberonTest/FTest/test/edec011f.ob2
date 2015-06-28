(* 4. Declarations and scope rules                                            *)
(* 3. A type T of the form POINTER TO T1 can be declared at a point           *)
(* where T1 is still unknown. The declaration of T1 must follow in the same   *)
(* block to which T is local.                                                 *)

MODULE edec011f;

TYPE  T = ARRAY 2 OF POINTER TO M;
(*                              ^--- Identifier not declared *)
(* Pos: 8,33                                                 *)

VAR   v : POINTER TO M;
(*                   ^--- Identifier not declared *)
(* Pos: 12,22                                     *)

TYPE  M = RECORD
          END;

END edec011f.
