MODULE Fonts;

   IMPORT Kernel, Display;

   TYPE
      Name* = ARRAY 32 OF CHAR;
      Font* = POINTER TO FontDesc;
      FontDesc* = RECORD (Kernel.FinObjDesc)
         name*: Name;
         height*, minX*, maxX*, minY*, maxY*: INTEGER;
         raster*: Display.Font;
      END;

   VAR
      Default*: Font;

   PROCEDURE This* (name: ARRAY OF CHAR): Font;
   BEGIN
    RETURN NIL;
   END This;

END Fonts.
