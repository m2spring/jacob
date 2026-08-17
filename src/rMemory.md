DEFINITION MODULE rMemory;

FROM SYSTEM IMPORT ADDRESS;

(* Minimal stand-in for cocktail2110's reuse-library rMemory module (which
   pulls in the foreign/C "Pointers" module we can't compile under Mocka).
   ast-generated Tree modules only ever call Alloc/Free for their node-pool
   block allocation, so just forward those to Mocka's own Storage module. *)

PROCEDURE Alloc (ByteCount: LONGINT) : ADDRESS;

PROCEDURE Free (ByteCount: LONGINT; a: ADDRESS);

END rMemory.
