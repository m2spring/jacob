MODULE Viewers;

   IMPORT Display;

   CONST
      modify* = 1;
      restore* = 0;
      suspend* = 2;

   TYPE
      Viewer* = POINTER TO ViewerDesc;
      ViewerDesc* = RECORD (Display.FrameDesc)
         state*: INTEGER;
      END;
      ViewerMsg* = RECORD (Display.FrameMsg)
         id*, X*, Y*, W*, H*, state*: INTEGER;
      END;

   VAR
      curW*: INTEGER;
      minH*: INTEGER;

   PROCEDURE Broadcast* (VAR M: Display.FrameMsg);
   BEGIN
   END Broadcast;

   PROCEDURE Change* (V: Viewer; Y: INTEGER);
   BEGIN
   END Change;

   PROCEDURE Close* (V: Viewer);
   BEGIN
   END Close;

   PROCEDURE CloseTrack* (X: INTEGER);
   BEGIN
   END CloseTrack;

   PROCEDURE InitTrack* (W, H: INTEGER; Filler: Viewer);
   BEGIN
   END InitTrack;

   PROCEDURE Locate* (X, H: INTEGER; VAR fil, bot, alt, max: Display.Frame);
   BEGIN
   END Locate;

   PROCEDURE Next* (V: Viewer): Viewer;
   BEGIN
    RETURN NIL;
   END Next;

   PROCEDURE Open* (V: Viewer; X, Y: INTEGER);
   BEGIN
   END Open;

   PROCEDURE OpenTrack* (X, W: INTEGER; Filler: Viewer);
   BEGIN
   END OpenTrack;

   PROCEDURE Recall* (VAR V: Viewer);
   BEGIN
   END Recall;

   PROCEDURE This* (X, Y: INTEGER): Viewer;
   BEGIN
    RETURN NIL;
   END This;

END Viewers.
