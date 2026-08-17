DEFINITION MODULE Pack;

(* Minimal stand-in for cocktail2110's reuse-library Pack module: Jacob's
   generated Scanner/Parser tables only ever call UnpackCard/UnpackInt to
   decode packed constant-string table data at startup; the packing
   (write) side (PackHandle, BeginPackCard, PackCard, EndPack, ...) is
   only used by rex/lark themselves when generating that source, never
   by Jacob at its own runtime, so it's intentionally omitted here to
   avoid pulling in cocktail2110's rMemory/Pointers (foreign C) modules. *)

TYPE
  UnpackCardHandler = PROCEDURE(LONGCARD);
  UnpackIntHandler  = PROCEDURE(LONGINT);
  UnpackHandler     = UnpackCardHandler;

PROCEDURE UnpackCard
  (    handler : UnpackCardHandler;
       string  : ARRAY OF CHAR;
       count   : CARDINAL);

PROCEDURE Unpack
  (    handler : UnpackCardHandler;
       string  : ARRAY OF CHAR;
       count   : CARDINAL);

PROCEDURE UnpackInt
  (    handler : UnpackIntHandler;
       string  : ARRAY OF CHAR;
       count   : CARDINAL);

END Pack.
