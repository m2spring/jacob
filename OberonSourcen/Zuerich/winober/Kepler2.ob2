MODULE Kepler2;

   IMPORT KeplerGraphs, KeplerPorts, Files, Display, Fonts, Kernel;

   TYPE
      Fraction* = POINTER TO FractionDesc;
      FractionDesc* = RECORD (KeplerGraphs.PlanetDesc)
         cnt*, dn*: LONGINT;
      END;
      Offset* = POINTER TO OffsetDesc;
      OffsetDesc* = RECORD (KeplerGraphs.PlanetDesc)
         dx*, dy*: INTEGER;
      END;

      XY* = POINTER TO XYDesc;
      XYDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

   PROCEDURE (self: Fraction) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Fraction) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Fraction) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: Offset) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Offset) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Offset) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: XY) Calc*;
   BEGIN
   END Calc;

   PROCEDURE NewFractions*;
   BEGIN
   END NewFractions;

   PROCEDURE NewOffset*;
   BEGIN
   END NewOffset;

   PROCEDURE NewXY*;
   BEGIN
   END NewXY;

END Kepler2.
