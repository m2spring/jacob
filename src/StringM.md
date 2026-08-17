DEFINITION MODULE StringM;

(* cocktail2110's puma unconditionally imports StringM into every generated
   Tree module's boilerplate, whether or not the tree actually has any
   tString-typed fields (Jacob's doesn't). Delegate to the already-working
   StringMem module rather than pulling in the real StringM's WStrings
   (wide-string) dependency, which nothing here needs. *)

FROM Strings IMPORT tString;

TYPE tStringRef = LONGINT;

PROCEDURE PutString  (VAR s: tString) : tStringRef;
PROCEDURE GetString  (r: tStringRef; VAR s: tString);
PROCEDURE Length     (r: tStringRef) : CARDINAL;
PROCEDURE IsEqual    (r: tStringRef; VAR s: tString) : BOOLEAN;

END StringM.
