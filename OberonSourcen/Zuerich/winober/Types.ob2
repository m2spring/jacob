MODULE Types;

   IMPORT SYSTEM, Kernel;

   TYPE
      Type* = POINTER TO TypeDesc;
      TypeDesc* = RECORD
         name*: ARRAY 32 OF CHAR;
         module*: Kernel.Module;
      END;

   PROCEDURE BaseOf* (t: Type; level: INTEGER): Type;
   BEGIN
    RETURN NIL;
   END BaseOf;

   PROCEDURE LevelOf* (t: Type): INTEGER;
   BEGIN
    RETURN 0;
   END LevelOf;

   PROCEDURE NewObj* (VAR o: SYSTEM.PTR; t: Type);
   BEGIN
   END NewObj;

   PROCEDURE This* (mod: Kernel.Module; name: ARRAY OF CHAR): Type;
   BEGIN
    RETURN NIL;
   END This;

   PROCEDURE TypeOf* (o: SYSTEM.PTR): Type;
   BEGIN
    RETURN NIL;
   END TypeOf;

END Types.
