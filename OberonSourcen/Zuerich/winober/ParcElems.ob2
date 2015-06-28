MODULE ParcElems;

   IMPORT Texts, TextFrames, Fonts, Display, Files, Kernel;

   CONST
      get* = 1;
      set* = 0;

   TYPE
      StateMsg* = RECORD (Texts.ElemMsg)
         id*: INTEGER;
         pos*: LONGINT;
         frame*: TextFrames.Frame;
         par*: Texts.Scanner;
         log*: Texts.Text;
      END;

   PROCEDURE Alloc*;
   BEGIN
   END Alloc;

   PROCEDURE ChangedParc* (P: TextFrames.Parc; beg: LONGINT);
   BEGIN
   END ChangedParc;

   PROCEDURE CopyParc* (SP, DP: TextFrames.Parc);
   BEGIN
   END CopyParc;

   PROCEDURE Draw* (P: TextFrames.Parc; F: Display.Frame; col: SHORTINT; x0, y0: INTEGER);
   BEGIN
   END Draw;

   PROCEDURE Edit* (P: TextFrames.Parc; F: TextFrames.Frame; pos: LONGINT; x0, y0, x, y: INTEGER; keysum: SET);
   BEGIN
   END Edit;

   PROCEDURE GetAttr* (P: TextFrames.Parc; F: TextFrames.Frame; VAR S: Texts.Scanner; log: Texts.Text);
   BEGIN
   END GetAttr;

   PROCEDURE Handle* (E: Texts.Elem; VAR msg: Texts.ElemMsg);
   BEGIN
   END Handle;

   PROCEDURE LoadParc* (P: TextFrames.Parc; VAR r: Files.Rider);
   BEGIN
   END LoadParc;

   PROCEDURE ParcExtent* (T: Texts.Text; beg: LONGINT; VAR end: LONGINT);
   BEGIN
   END ParcExtent;

   PROCEDURE Prepare* (P: TextFrames.Parc; indent, unit: LONGINT);
   BEGIN
   END Prepare;

   PROCEDURE SetAttr* (P: TextFrames.Parc; F: TextFrames.Frame; pos: LONGINT; VAR S: Texts.Scanner; log: Texts.Text);
   BEGIN
   END SetAttr;

   PROCEDURE StoreParc* (P: TextFrames.Parc; VAR r: Files.Rider);
   BEGIN
   END StoreParc;

END ParcElems.
