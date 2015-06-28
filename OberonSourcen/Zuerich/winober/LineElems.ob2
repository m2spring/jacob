MODULE LineElems;

   IMPORT Texts, Files;

   CONST
      autoHOpt* = 2;
      autoVOpt* = 0;
      doubleOpt* = 3;
      tabVOpt* = 1;

   TYPE
      Elem* = POINTER TO ElemDesc;
      ElemDesc* = RECORD (Texts.ElemDesc)
         opts*: SET;
      END;

   PROCEDURE Alloc*;
   BEGIN
   END Alloc;

   PROCEDURE Copy* (SE, DE: Elem);
   BEGIN
   END Copy;

   PROCEDURE Draw* (E: Elem; x0, y0: INTEGER; col: SHORTINT);
   BEGIN
   END Draw;

   PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
   BEGIN
   END Handle;

   PROCEDURE Insert*;
   BEGIN
   END Insert;

   PROCEDURE Load* (E: Elem; VAR r: Files.Rider);
   BEGIN
   END Load;

   PROCEDURE Prepare* (E: Elem; pos, indent: LONGINT; printing: BOOLEAN);
   BEGIN
   END Prepare;

   PROCEDURE Print* (E: Elem; x0, y0: INTEGER; col: SHORTINT);
   BEGIN
   END Print;

   PROCEDURE Store* (E: Elem; VAR r: Files.Rider);
   BEGIN
   END Store;

END LineElems.
