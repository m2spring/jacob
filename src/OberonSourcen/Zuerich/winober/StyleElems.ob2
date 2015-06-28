MODULE StyleElems;

   IMPORT TextFrames, Texts, Files, Fonts, Display, Kernel;

   CONST
      change* = 1;
      rename* = 2;
      search* = 0;

   TYPE
      Name* = ARRAY 32 OF CHAR;
      Parc* = POINTER TO ParcDesc;
      ParcDesc* = RECORD (TextFrames.ParcDesc)
         name*: Name;
      END;
      UpdateMsg* = RECORD (Texts.ElemMsg)
         id*: INTEGER;
         pos*: LONGINT;
         name*, newName*: Name;
         parc*: Parc;
      END;

   VAR
      font*: Fonts.Font;

   PROCEDURE Alloc*;
   BEGIN
   END Alloc;

   PROCEDURE Broadcast* (T: Texts.Text; VAR msg: UpdateMsg);
   BEGIN
   END Broadcast;

   PROCEDURE ChangeName* (P: Parc; name: ARRAY OF CHAR; VAR synched: BOOLEAN);
   BEGIN
   END ChangeName;

   PROCEDURE ChangeSetting* (P: Parc);
   BEGIN
   END ChangeSetting;

   PROCEDURE Copy* (SP, DP: Parc);
   BEGIN
   END Copy;

   PROCEDURE Draw* (P: Parc; F: TextFrames.Frame; col: SHORTINT; x0, y0: INTEGER);
   BEGIN
   END Draw;

   PROCEDURE Edit* (P: Parc; F: TextFrames.Frame; pos: LONGINT; x0, y0, x, y: INTEGER; keysum: SET);
   BEGIN
   END Edit;

   PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
   BEGIN
   END Handle;

   PROCEDURE Insert*;
   BEGIN
   END Insert;

   PROCEDURE Load* (P: Parc; VAR r: Files.Rider);
   BEGIN
   END Load;

   PROCEDURE Prepare* (P: Parc; indent, unit: LONGINT);
   BEGIN
   END Prepare;

   PROCEDURE Rename*;
   BEGIN
   END Rename;

   PROCEDURE RenameAll*;
   BEGIN
   END RenameAll;

   PROCEDURE Search* (T: Texts.Text; VAR name: Name; VAR P: Parc);
   BEGIN
   END Search;

   PROCEDURE SetAttr* (P: Parc; F: TextFrames.Frame; VAR S: Texts.Scanner; log: Texts.Text);
   BEGIN
   END SetAttr;

   PROCEDURE Store* (P: Parc; VAR r: Files.Rider);
   BEGIN
   END Store;

   PROCEDURE Synch* (P: Parc; VAR synched: BOOLEAN);
   BEGIN
   END Synch;

END StyleElems.
