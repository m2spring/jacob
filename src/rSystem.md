DEFINITION MODULE rSystem;

(* Minimal stand-in for cocktail2110's reuse-library rSystem module.
   puma's generated error-recovery boilerplate ("yyExit") only ever
   calls rExit; the other two symbols (StdInput, tFile) are only used
   for their types/values, never actually read from a real file. *)

FROM Argument IMPORT ArgTable;
FROM SYSTEM IMPORT ADDRESS;

CONST
   StdInput = 0;

TYPE
   tFile = INTEGER;

PROCEDURE rExit (Status: INTEGER);

PROCEDURE PutArgs (Argc: SHORTCARD; Argv: ArgTable);

PROCEDURE rAlloc (ByteCount: LONGINT) : ADDRESS;

END rSystem.
