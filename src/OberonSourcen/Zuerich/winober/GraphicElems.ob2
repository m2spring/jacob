MODULE GraphicElems;

   IMPORT Texts, Graphics, Display, Files, Modules;

   TYPE
      Elem* = POINTER TO ElemDesc;
      ElemDesc* = RECORD (Texts.ElemDesc)
         SW*, SH*, PW*, PH*: LONGINT;
         graph*: Graphics.Graph;
         Xg*, Yg*: INTEGER;
         empty*: BOOLEAN;
      END;

   PROCEDURE Alloc*;
   BEGIN
   END Alloc;

   PROCEDURE Changed* (E: Elem);
   BEGIN
   END Changed;

   PROCEDURE Copy* (SE, DE: Elem);
   BEGIN
   END Copy;

   PROCEDURE CopyGraph* (G: Graphics.Graph): Graphics.Graph;
   BEGIN
    RETURN NIL;
   END CopyGraph;

   PROCEDURE Draw* (E: Elem; F: Display.Frame; x0, y0, col: INTEGER; VAR ef: Display.Frame);
   BEGIN
   END Draw;

   PROCEDURE Focus* (E: Elem; focus: BOOLEAN; f, F: Display.Frame);
   BEGIN
   END Focus;

   PROCEDURE Handle* (e: Texts.Elem; VAR msg: Texts.ElemMsg);
   BEGIN
   END Handle;

   PROCEDURE Insert*;
   BEGIN
   END Insert;

   PROCEDURE Load* (E: Elem; VAR r: Files.Rider);
   BEGIN
   END Load;

   PROCEDURE Open* (E: Elem; G: Graphics.Graph; Xg, Yg: INTEGER; adjust: BOOLEAN);
   BEGIN
   END Open;

   PROCEDURE OpenViewer* (E: Elem);
   BEGIN
   END OpenViewer;

   PROCEDURE Prepare* (E: Elem; printing: BOOLEAN);
   BEGIN
   END Prepare;

   PROCEDURE Print* (E: Elem; x0, y0: INTEGER);
   BEGIN
   END Print;

   PROCEDURE SetSize* (E: Elem; w, h: LONGINT);
   BEGIN
   END SetSize;

   PROCEDURE Store* (E: Elem; VAR r: Files.Rider);
   BEGIN
   END Store;

   PROCEDURE Track* (E: Elem; keys: SET; x, y, x0, y0: INTEGER);
   BEGIN
   END Track;

   PROCEDURE Update*;
   BEGIN
   END Update;

END GraphicElems.
