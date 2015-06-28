DEFINITION MODULE TBL;
(*
 * Provides functionality for storing and retrieving declaration tables.
 *)

IMPORT Idents, OB;

PROCEDURE Retrieve(VAR tab : OB.tOB; serverIdent : Idents.tIdent) : BOOLEAN;
(*
 * Retrieves the declaration table, which belongs to module 'serverIdent'.
 * Fails, if nothing was found.
 *)

PROCEDURE Store(tab : OB.tOB; serverIdent : Idents.tIdent);
(*
 * Stores the declaration table, which belongs to module 'serverIdent'.
 *)

END TBL.

