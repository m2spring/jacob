MODULE MenuViewers;

   IMPORT Display, Viewers;

   CONST
      extend* = 0;
      reduce* = 1;

   TYPE
      ModifyMsg* = RECORD (Display.FrameMsg)
         id*, dY*, Y*, H*: INTEGER;
      END;
      Viewer* = POINTER TO ViewerDesc;
      ViewerDesc* = RECORD (Viewers.ViewerDesc)
         menuH*: INTEGER;
      END;

   VAR
      Ancestor*: Viewer;

   PROCEDURE Handle* (V: Display.Frame; VAR M: Display.FrameMsg);
   BEGIN
   END Handle;

   PROCEDURE New* (Menu, Main: Display.Frame; menuH, X, Y: INTEGER): Viewer;
   BEGIN
    RETURN NIL;
   END New;

END MenuViewers.
