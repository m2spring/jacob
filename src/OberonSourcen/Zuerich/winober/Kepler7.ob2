MODULE Kepler7;

   IMPORT TextFrames, Display, Texts, KeplerGraphs, KeplerFrames, KeplerPorts, Files, Fonts, Kernel;

   TYPE
      Text* = POINTER TO TextDesc;
      TextDesc* = RECORD (KeplerFrames.ButtonDesc)
         text*: Texts.Text;
      END;

      Frame* = POINTER TO FrameDesc;
      FrameDesc* = RECORD (TextFrames.FrameDesc)
         keplerText*: Text;
         graph*: KeplerGraphs.Graph;
      END;

   PROCEDURE (t: Text) Draw* (f: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (t: Text) HandleMouse* (f: KeplerFrames.Frame; x, y: INTEGER; keys: SET);
   BEGIN
   END HandleMouse;

   PROCEDURE (t: Text) Read* (VAR r: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (t: Text) Write* (VAR r: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE NewText*;
   BEGIN
   END NewText;

   PROCEDURE Update*;
   BEGIN
   END Update;

END Kepler7.
