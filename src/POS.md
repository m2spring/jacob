DEFINITION MODULE POS;
(*
 * Provides a data type 'source position'.
 *)

IMPORT Positions, IO;

(*$1*)
TYPE tPosition  = Positions.tPosition;

VAR  NoPosition : tPosition; (* The empty position (line 0, column 0). *)

PROCEDURE IncCol(VAR Position : tPosition; n : SHORTINT);
(*
 * Increments the column of the Position by n.
 *)

PROCEDURE Compare(VAR p, q : tPosition) : INTEGER;
(* 
 * p '<' q --> -1 
 * p '=' q -->  0 
 * p '>' q --> +1 
 *)

PROCEDURE WritePosition(f : IO.tFile; Position : tPosition);
(*
 * Prints the Position on file 'f' as "Line.Column".
 * (Added for cocktail2110's generated error-recovery boilerplate,
 * which expects this alongside NoPosition/Compare.)
 *)

END POS.

