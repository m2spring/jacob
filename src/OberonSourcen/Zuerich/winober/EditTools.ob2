MODULE EditTools;

   IMPORT Texts, TextFrames, Viewers, Display;

   PROCEDURE Change*;
   BEGIN
   END Change;

   PROCEDURE ChangeFamily*;
   BEGIN
   END ChangeFamily;

   PROCEDURE ChangeFont* (T: Texts.Text; beg, end: LONGINT; old, new: ARRAY OF CHAR);
   BEGIN
   END ChangeFont;

   PROCEDURE ChangeFontFamily* (T: Texts.Text; beg, end: LONGINT; old, new: ARRAY OF CHAR);
   BEGIN
   END ChangeFontFamily;

   PROCEDURE ChangeFontSize* (T: Texts.Text; beg, end: LONGINT; old, new: INTEGER);
   BEGIN
   END ChangeFontSize;

   PROCEDURE ChangeFontStyle* (T: Texts.Text; beg, end: LONGINT; old, new: CHAR);
   BEGIN
   END ChangeFontStyle;

   PROCEDURE ChangeSize*;
   BEGIN
   END ChangeSize;

   PROCEDURE ChangeStyle*;
   BEGIN
   END ChangeStyle;

   PROCEDURE Cleanup*;
   BEGIN
   END Cleanup;

   PROCEDURE ConvertToAscii* (T: Texts.Text; beg, end: LONGINT);
   BEGIN
   END ConvertToAscii;

   PROCEDURE Count* (T: Texts.Text; beg, end: LONGINT; VAR wc, pc, ec: LONGINT);
   BEGIN
   END Count;

   PROCEDURE DeleteElems* (T: Texts.Text; beg, end: LONGINT);
   BEGIN
   END DeleteElems;

   PROCEDURE DeleteMonsters* (T: Texts.Text; monsterW, monsterH: LONGINT; VAR mc: LONGINT);
   BEGIN
   END DeleteMonsters;

   PROCEDURE GetAttr*;
   BEGIN
   END GetAttr;

   PROCEDURE IncFontSize* (T: Texts.Text; beg, end: LONGINT; delta: INTEGER);
   BEGIN
   END IncFontSize;

   PROCEDURE IncSize*;
   BEGIN
   END IncSize;

   PROCEDURE InsertCR*;
   BEGIN
   END InsertCR;

   PROCEDURE LocateLine*;
   BEGIN
   END LocateLine;

   PROCEDURE Refresh*;
   BEGIN
   END Refresh;

   PROCEDURE RemoveCR*;
   BEGIN
   END RemoveCR;

   PROCEDURE RemoveElems*;
   BEGIN
   END RemoveElems;

   PROCEDURE SearchAttr*;
   BEGIN
   END SearchAttr;

   PROCEDURE SearchDiff*;
   BEGIN
   END SearchDiff;

   PROCEDURE SelectedFrame* (): TextFrames.Frame;
   BEGIN
    RETURN NIL;
   END SelectedFrame;

   PROCEDURE ShowAliens*;
   BEGIN
   END ShowAliens;

   PROCEDURE StoreAscii*;
   BEGIN
   END StoreAscii;

   PROCEDURE ToAscii*;
   BEGIN
   END ToAscii;

   PROCEDURE UnmarkMenu* (V: Viewers.Viewer);
   BEGIN
   END UnmarkMenu;

   PROCEDURE Words*;
   BEGIN
   END Words;

END EditTools.
