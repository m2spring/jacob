MODULE Kepler8;

   IMPORT KeplerGraphs, KeplerPorts, Files, Display, Fonts, Kernel;

   TYPE
      AttrRect* = POINTER TO AttrRectDesc;
      AttrRectDesc* = RECORD (KeplerGraphs.ConsDesc)
         texture*, lineWidth*, shadow*, shadowWidth*, corner*: INTEGER;
      END;

      CircleIntersect* = POINTER TO CircleIntersectDesc;
      CircleIntersectDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

      EllipIntersect* = POINTER TO EllipIntersectDesc;
      EllipIntersectDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

      FilledCircle* = POINTER TO FilledCircleDesc;
      FilledCircleDesc* = RECORD (KeplerGraphs.ConsDesc)
         texture*: INTEGER;
      END;

      RectIntersect* = POINTER TO RectIntersectDesc;
      RectIntersectDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

   PROCEDURE (self: AttrRect) Draw* (f: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: AttrRect) Read* (VAR r: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: AttrRect) Write* (VAR r: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: CircleIntersect) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: EllipIntersect) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: FilledCircle) Draw* (f: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: FilledCircle) Read* (VAR r: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: FilledCircle) Write* (VAR r: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: RectIntersect) Calc*;
   BEGIN
   END Calc;

   PROCEDURE NewAttrRect*;
   BEGIN
   END NewAttrRect;

   PROCEDURE NewCircleIntersect*;
   BEGIN
   END NewCircleIntersect;

   PROCEDURE NewEllipseIntersect*;
   BEGIN
   END NewEllipseIntersect;

   PROCEDURE NewFilledCircle*;
   BEGIN
   END NewFilledCircle;

   PROCEDURE NewRectIntersect*;
   BEGIN
   END NewRectIntersect;

END Kepler8.
