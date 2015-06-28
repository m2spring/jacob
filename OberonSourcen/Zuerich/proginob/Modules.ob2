MODULE Modules;

   IMPORT Kernel;

   CONST
      ModNameLen* = 32;

   TYPE
      Cmd* = Kernel.Cmd;
      Command* = PROCEDURE;
      Module* = Kernel.Module;
      ModuleDesc* = Kernel.ModuleDesc;
      ModuleName* = Kernel.Name;

   VAR
      imported*: Kernel.Name;
      importing*: Kernel.Name;
      res*: INTEGER;

   PROCEDURE Free* (name: ARRAY OF CHAR; all: BOOLEAN);
   BEGIN
   END Free;

   PROCEDURE ThisCommand* (mod: Kernel.Module; name: ARRAY OF CHAR): Command;
   BEGIN
    RETURN NIL;
   END ThisCommand;

   PROCEDURE ThisMod* (name: ARRAY OF CHAR): Kernel.Module;
   BEGIN
    RETURN NIL;
   END ThisMod;

END Modules.
