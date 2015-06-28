MODULE GraphicFrames;

   IMPORT Graphics, Display, Oberon, Modules, Files;

   TYPE
      Frame* = POINTER TO FrameDesc;
      CtrlMsg* = RECORD (Graphics.Msg)
         f*: Frame;
         res*: INTEGER;
      END;
      DrawMsg* = RECORD (Graphics.Msg)
         f*: Frame;
         x*, y*, col*, mode*: INTEGER;
      END;
      Location* = POINTER TO LocDesc;
      LocDesc* = RECORD
         x*, y*: INTEGER;
         next*: Location;
      END;
      FrameDesc* = RECORD (Display.FrameDesc)
         graph*: Graphics.Graph;
         Xg*, Yg*, X1*, Y1*, x*, y*, col*: INTEGER;
         marked*, ticked*: BOOLEAN;
         mark*: LocDesc;
      END;

   VAR
      Crosshair*: Oberon.Marker;

   PROCEDURE Change* (F: Frame; VAR msg: Graphics.Msg);
   BEGIN
   END Change;

   PROCEDURE Defocus* (F: Frame);
   BEGIN
   END Defocus;

   PROCEDURE Deselect* (F: Frame);
   BEGIN
   END Deselect;

   PROCEDURE Draw* (F: Frame);
   BEGIN
   END Draw;

   PROCEDURE DrawObj* (F: Frame; obj: Graphics.Object);
   BEGIN
   END DrawObj;

   PROCEDURE Erase* (F: Frame);
   BEGIN
   END Erase;

   PROCEDURE EraseObj* (F: Frame; obj: Graphics.Object);
   BEGIN
   END EraseObj;

   PROCEDURE Focus* (): Frame;
   BEGIN
    RETURN NIL;
   END Focus;

   PROCEDURE Handle* (G: Display.Frame; VAR M: Display.FrameMsg);
   BEGIN
   END Handle;

   PROCEDURE Macro* (VAR Lname, Mname: ARRAY OF CHAR);
   BEGIN
   END Macro;

   PROCEDURE Open* (G: Frame; graph: Graphics.Graph; X, Y, col: INTEGER; ticked: BOOLEAN);
   BEGIN
   END Open;

   PROCEDURE Restore* (F: Frame);
   BEGIN
   END Restore;

   PROCEDURE Selected* (): Frame;
   BEGIN
    RETURN NIL;
   END Selected;

   PROCEDURE This* (x, y: INTEGER): Frame;
   BEGIN
    RETURN NIL;
   END This;

END GraphicFrames.
