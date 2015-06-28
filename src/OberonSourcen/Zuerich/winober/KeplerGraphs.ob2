MODULE KeplerGraphs;

   IMPORT KeplerPorts, Files, Display, Fonts, Kernel;

   CONST
      draw* = 0;
      restore* = 1;

   TYPE
      Graph* = POINTER TO GraphDesc;
      Object* = POINTER TO ObjectDesc;

      Notifier* = PROCEDURE (op: INTEGER; G: Graph; O: Object; P: KeplerPorts.Port);
      ObjectDesc* = RECORD
      END;

      Star* = POINTER TO StarDesc;
      StarDesc* = RECORD (ObjectDesc)
         x*, y*, refcnt*: INTEGER;
         sel*: BOOLEAN;
         next*: Star;
      END;

      Constellation* = POINTER TO ConsDesc;
      ConsDesc* = RECORD (ObjectDesc)
         nofpts*: INTEGER;
         p*: ARRAY 4 OF Star;
         next*: Constellation;
      END;

      GraphDesc* = RECORD (ObjectDesc)
         cons*: Constellation;
         stars*: Star;
         seltime*: LONGINT;
         notify*: Notifier;
      END;

      Planet* = POINTER TO PlanetDesc;
      PlanetDesc* = RECORD (StarDesc)
         c*: Constellation;
      END;

   VAR
      loading*: Graph;

   PROCEDURE (self: Constellation) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Constellation) State* (): INTEGER;
   BEGIN
    RETURN 0;
   END State;

   PROCEDURE (self: Constellation) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (G: Graph) All* (op: INTEGER);
   BEGIN
   END All;

   PROCEDURE (G: Graph) Append* (o: Object);
   BEGIN
   END Append;

   PROCEDURE (G: Graph) CopySelection* (from: Graph; dx, dy: INTEGER);
   BEGIN
   END CopySelection;

   PROCEDURE (G: Graph) Delete* (o: Object);
   BEGIN
   END Delete;

   PROCEDURE (G: Graph) DeleteSelection* (minstate: INTEGER);
   BEGIN
   END DeleteSelection;

   PROCEDURE (G: Graph) Draw* (P: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (G: Graph) FlipSelection* (p: Star);
   BEGIN
   END FlipSelection;

   PROCEDURE (G: Graph) Move* (s: Star; dx, dy: INTEGER);
   BEGIN
   END Move;

   PROCEDURE (G: Graph) MoveSelection* (dx, dy: INTEGER);
   BEGIN
   END MoveSelection;

   PROCEDURE (G: Graph) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (G: Graph) SendToBack* (o: Object);
   BEGIN
   END SendToBack;

   PROCEDURE (G: Graph) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (G: Graph) WriteSel* (VAR R: Files.Rider);
   BEGIN
   END WriteSel;

   PROCEDURE (self: Object) Draw* (P: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: Object) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Object) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: Planet) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Planet) Draw* (P: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: Planet) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Planet) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: Star) Draw* (P: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: Star) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Star) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE GetType* (o: Object; VAR module, type: ARRAY OF CHAR);
   BEGIN
   END GetType;

   PROCEDURE Old* (name: ARRAY OF CHAR): Graph;
   BEGIN
    RETURN NIL;
   END Old;

   PROCEDURE ReadObj* (VAR R: Files.Rider; VAR x: Object);
   BEGIN
   END ReadObj;

   PROCEDURE Recall*;
   BEGIN
   END Recall;

   PROCEDURE Reset*;
   BEGIN
   END Reset;

   PROCEDURE WriteObj* (VAR R: Files.Rider; x: Object);
   BEGIN
   END WriteObj;

END KeplerGraphs.
