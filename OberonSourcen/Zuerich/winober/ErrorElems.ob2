MODULE ErrorElems;

   IMPORT Texts, Display, Fonts, Kernel;

   TYPE
      Elem* = POINTER TO ElemDesc;
      ElemDesc* = RECORD (Texts.ElemDesc)
         err*: INTEGER;
         msg*: ARRAY 128 OF CHAR;
      END;

   VAR
      font*: Fonts.Font;

   PROCEDURE Copy* (SE, DE: Elem);
   BEGIN
   END Copy;

   PROCEDURE Delete* (E: Elem; pos: LONGINT);
   BEGIN
   END Delete;

   PROCEDURE Disp* (E: Elem; F: Display.Frame; col: SHORTINT; fnt: Fonts.Font; x0, y0: INTEGER);
   BEGIN
   END Disp;

   PROCEDURE Edit* (E: Elem; pos: LONGINT; x0, y0, x, y: INTEGER; keysum: SET);
   BEGIN
   END Edit;

   PROCEDURE Expand* (E: Elem; pos: LONGINT);
   BEGIN
   END Expand;

   PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
   BEGIN
   END Handle;

   PROCEDURE InsertAt* (T: Texts.Text; pos: LONGINT; err: INTEGER);
   BEGIN
   END InsertAt;

   PROCEDURE LocateNext*;
   BEGIN
   END LocateNext;

   PROCEDURE Mark*;
   BEGIN
   END Mark;

   PROCEDURE Prepare* (E: Elem; fnt: Fonts.Font; VAR voff: INTEGER);
   BEGIN
   END Prepare;

   PROCEDURE Print* (E: Elem; x0, y0: INTEGER);
   BEGIN
   END Print;

   PROCEDURE Reduce* (E: Elem; pos: LONGINT);
   BEGIN
   END Reduce;

   PROCEDURE ShowErrMsg* (E: Elem; F: Display.Frame; col: SHORTINT; x0, y0, dw: INTEGER);
   BEGIN
   END ShowErrMsg;

   PROCEDURE Unmark*;
   BEGIN
   END Unmark;

END ErrorElems.
