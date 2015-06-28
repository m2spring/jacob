MODULE TableElems;

   IMPORT Texts, MenuViewers, Viewers, Display, TextFrames, Files;

   TYPE
      Elem* = POINTER TO ElemDesc;
      ElemDesc* = RECORD (Texts.ElemDesc)
         def*: Texts.Text;
      END;
      Viewer* = POINTER TO ViewerDesc;
      ViewerDesc* = RECORD (MenuViewers.ViewerDesc)
         elem*: Elem;
      END;

   PROCEDURE Alloc*;
   BEGIN
   END Alloc;

   PROCEDURE Changed* (E: Elem);
   BEGIN
   END Changed;

   PROCEDURE CopyText* (T: Texts.Text): Texts.Text;
   BEGIN
    RETURN NIL;
   END CopyText;

   PROCEDURE Draw* (E: Elem; F: TextFrames.Frame; x0, y0: INTEGER);
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

   PROCEDURE Open* (E: Elem; def: Texts.Text);
   BEGIN
   END Open;

   PROCEDURE OpenViewer* (E: Elem);
   BEGIN
   END OpenViewer;

   PROCEDURE Print* (E: Elem; pno, x0, y0: INTEGER);
   BEGIN
   END Print;

   PROCEDURE Store* (E: Elem; VAR r: Files.Rider);
   BEGIN
   END Store;

   PROCEDURE Track* (E: Elem; pos: LONGINT; keys: SET; x, y, x0, y0: INTEGER);
   BEGIN
   END Track;

   PROCEDURE Update*;
   BEGIN
   END Update;

END TableElems.
