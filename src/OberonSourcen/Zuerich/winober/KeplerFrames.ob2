MODULE KeplerFrames;

   IMPORT KeplerGraphs, KeplerPorts, Files, Fonts, Display, Kernel;

   TYPE
      Button* = POINTER TO ButtonDesc;
      ButtonDesc* = RECORD (KeplerGraphs.ConsDesc)
         cmd*, par*: ARRAY 32 OF CHAR;
      END;

      Caption* = POINTER TO CaptionDesc;
      CaptionDesc* = RECORD (KeplerGraphs.ConsDesc)
         s*: ARRAY 128 OF CHAR;
         fnt*: Fonts.Font;
         align*: SHORTINT;
      END;

      FocusPoint* = POINTER TO FocusPointDesc;
      FocusPointDesc* = RECORD
         next*: FocusPoint;
         p*: KeplerGraphs.Star;
      END;

      Frame* = POINTER TO FrameDesc;
      FrameDesc* = RECORD (KeplerPorts.DisplayPortDesc)
         G*: KeplerGraphs.Graph;
         col*, grid*: INTEGER;
      END;

      Notifier* = PROCEDURE (op: INTEGER; G: KeplerGraphs.Graph; O: KeplerGraphs.Object; P: KeplerPorts.Port);
      SelMsg* = RECORD (Display.FrameMsg)
         time*: LONGINT;
         G*: KeplerGraphs.Graph;
      END;

      UpdateMsg* = RECORD (Display.FrameMsg)
         id*: INTEGER;
         G*: KeplerGraphs.Graph;
         O*: KeplerGraphs.Object;
         P*: KeplerPorts.Port;
      END;

   VAR
      Focus*: KeplerGraphs.Graph;
      carpos*: INTEGER;
      first*: FocusPoint;
      focus*: Caption;
      last*: FocusPoint;
      nofpts*: INTEGER;

   PROCEDURE (B: Button) Execute* (keys: SET);
   BEGIN
   END Execute;

   PROCEDURE (B: Button) HandleMouse* (F: Frame; x, y: INTEGER; keys: SET);
   BEGIN
   END HandleMouse;

   PROCEDURE (B: Button) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (B: Button) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (C: Caption) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (C: Caption) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (C: Caption) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (F: Frame) Consume* (ch: CHAR);
   BEGIN
   END Consume;

   PROCEDURE (F: Frame) EditFrame* (x, y: INTEGER; keys: SET);
   BEGIN
   END EditFrame;

   PROCEDURE (F: Frame) Extend* (newY: INTEGER);
   BEGIN
   END Extend;

   PROCEDURE (F: Frame) Invert* (p: KeplerGraphs.Star);
   BEGIN
   END Invert;

   PROCEDURE (F: Frame) Neutralize*;
   BEGIN
   END Neutralize;

   PROCEDURE (F: Frame) Reduce* (newY: INTEGER);
   BEGIN
   END Reduce;

   PROCEDURE (F: Frame) Restore* (X, Y, W, H: INTEGER);
   BEGIN
   END Restore;

   PROCEDURE (F: Frame) TrackMouse* (x, y: INTEGER; keys: SET);
   BEGIN
   END TrackMouse;

   PROCEDURE AlignToGrid* (F: Frame; VAR X, Y: INTEGER);
   BEGIN
   END AlignToGrid;

   PROCEDURE AppendFocusPoint* (p: KeplerGraphs.Star);
   BEGIN
   END AppendFocusPoint;

   PROCEDURE ConsumePoint* (VAR p: KeplerGraphs.Star);
   BEGIN
   END ConsumePoint;

   PROCEDURE DeleteFocusPoint* (F: Frame);
   BEGIN
   END DeleteFocusPoint;

   PROCEDURE GetMouse* (F: Frame; VAR x, y: INTEGER; VAR keys: SET);
   BEGIN
   END GetMouse;

   PROCEDURE GetPoint* (VAR p: KeplerGraphs.Star);
   BEGIN
   END GetPoint;

   PROCEDURE GetSelection* (VAR sel: KeplerGraphs.Graph);
   BEGIN
   END GetSelection;

   PROCEDURE Handle* (F: Display.Frame; VAR M: Display.FrameMsg);
   BEGIN
   END Handle;

   PROCEDURE IsFocusPoint* (p: KeplerGraphs.Star): BOOLEAN;
   BEGIN
    RETURN FALSE; 
   END IsFocusPoint;

   PROCEDURE MarkedButton* (): Button;
   BEGIN
    RETURN NIL; 
   END MarkedButton;

   PROCEDURE MoveOrigin* (F: Frame; x0, y0: INTEGER);
   BEGIN
   END MoveOrigin;

   PROCEDURE New* (G: KeplerGraphs.Graph): Frame;
   BEGIN
    RETURN NIL; 
   END New;

   PROCEDURE NotifyDisplay* (op: INTEGER; G: KeplerGraphs.Graph; O: KeplerGraphs.Object; P: KeplerPorts.Port);
   BEGIN
   END NotifyDisplay;

   PROCEDURE Open* (F: Frame; G: KeplerGraphs.Graph; grid, scale: INTEGER; notify: KeplerGraphs.Notifier; handle: Display.Handler);
   BEGIN
   END Open;

   PROCEDURE ThisButton* (G: KeplerGraphs.Graph; x, y: INTEGER): Button;
   BEGIN
    RETURN NIL; 
   END ThisButton;

   PROCEDURE ThisCaption* (G: KeplerGraphs.Graph; x, y: INTEGER): Caption;
   BEGIN
    RETURN NIL; 
   END ThisCaption;

END KeplerFrames.
