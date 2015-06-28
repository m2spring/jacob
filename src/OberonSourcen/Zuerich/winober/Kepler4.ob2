MODULE Kepler4;

   IMPORT KeplerGraphs, KeplerPorts, Files, KeplerFrames, Fonts, Display, Kernel;

   TYPE
      Galaxy* = POINTER TO GalaxyDesc;
      GalaxyDesc* = RECORD (KeplerGraphs.ConsDesc)
         G*: KeplerGraphs.Graph;
      END;

      Icon* = POINTER TO IconDesc;
      IconDesc* = RECORD (KeplerFrames.ButtonDesc)
         fnt*: Fonts.Font;
      END;

   PROCEDURE (self: Galaxy) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: Galaxy) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Galaxy) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (I: Icon) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (I: Icon) Execute* (keys: SET);
   BEGIN
   END Execute;

   PROCEDURE (I: Icon) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (I: Icon) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE NewButton*;
   BEGIN
   END NewButton;

   PROCEDURE NewGalaxy*;
   BEGIN
   END NewGalaxy;

   PROCEDURE NewIcon*;
   BEGIN
   END NewIcon;

   PROCEDURE UpdateButton*;
   BEGIN
   END UpdateButton;

END Kepler4.
