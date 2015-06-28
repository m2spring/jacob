DEFINITION MODULE ErrLists;
(*
 * Provides a data type 'error list'.
 *)

IMPORT IO, POS;

TYPE   tErrorList;

PROCEDURE New() : tErrorList;
(*
 * Returns a new (empty) error list.
 *)

PROCEDURE Kill(VAR el : tErrorList);
(*
 * Kills an exisiting error list.
 *)

PROCEDURE App(el : tErrorList; p : POS.tPosition; s : ARRAY OF CHAR);
(*
 * Appends position p and message s to the error list.
 *)

PROCEDURE Write(f : IO.tFile; el : tErrorList; prefix : ARRAY OF CHAR);
(*
 * Writes an error list to a file. All list elements are sorted in 'position' order.
 *)

PROCEDURE Length(el : tErrorList) : CARDINAL;
(*
 * Returns the number of elements in the error list.
 *)

END ErrLists.

