MODULE Kepler5;

   IMPORT KeplerGraphs, KeplerPorts, Files, Display, Fonts, Kernel;

   TYPE
      FocusStar* = POINTER TO StarDesc;
      StarDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      FocusStar2* = POINTER TO StarDesc2;
      StarDesc2* = RECORD (KeplerGraphs.ConsDesc)
      END;

      Planet* = POINTER TO PlanetDesc;
      PlanetDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      SelStar* = POINTER TO SelStarDesc;
      SelStarDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

   PROCEDURE (self: FocusStar) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: FocusStar2) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: Planet) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: SelStar) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE NewFocusStar*;
   BEGIN
   END NewFocusStar;

   PROCEDURE NewFocusStar2*;
   BEGIN
   END NewFocusStar2;

   PROCEDURE NewPlanet*;
   BEGIN
   END NewPlanet;

   PROCEDURE NewSelStar*;
   BEGIN
   END NewSelStar;

END Kepler5.
