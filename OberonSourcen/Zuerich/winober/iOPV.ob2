MODULE iOPV;

   IMPORT iOPT, iOPS;

   VAR
      EntryNr*: INTEGER;
      ProcName*: iOPS.Name;
      dumpCode*: BOOLEAN;

   PROCEDURE AdrAndSize* (topScope: iOPT.Object);
   BEGIN
   END AdrAndSize;

   PROCEDURE Init* (opt: SET; bpc: LONGINT);
   BEGIN
   END Init;

   PROCEDURE Module* (prog: iOPT.Node);
   BEGIN
   END Module;

   PROCEDURE TypSize* (typ: iOPT.Struct; allocDesc: BOOLEAN);
   BEGIN
   END TypSize;

END iOPV.
