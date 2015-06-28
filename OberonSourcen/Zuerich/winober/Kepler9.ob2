MODULE Kepler9;

   IMPORT KeplerGraphs, KeplerPorts, Files, Display, Fonts, Kernel;

   TYPE
      CircleInter* = POINTER TO CircleIntersection;
      CircleIntersection* = RECORD (KeplerGraphs.PlanetDesc)
         sign*: SHORTINT;
      END;

      CircleLineInter* = POINTER TO CircleLineIntersection;
      CircleLineIntersection* = RECORD (KeplerGraphs.PlanetDesc)
         sign*: SHORTINT;
      END;

      Extension* = POINTER TO ExtensionDesc;
      ExtensionDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

      Intersection* = POINTER TO IntersectionDesc;
      IntersectionDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

      Parallel* = POINTER TO ParallelDesc;
      ParallelDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

      RightAngle* = POINTER TO RightAngleDesc;
      RightAngleDesc* = RECORD (KeplerGraphs.PlanetDesc)
      END;

      Tangent* = POINTER TO TangentDesc;
      TangentDesc* = RECORD (KeplerGraphs.PlanetDesc)
         sign*: SHORTINT;
      END;

   PROCEDURE (self: CircleInter) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: CircleInter) Read* (VAR r: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: CircleInter) Write* (VAR r: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: CircleLineInter) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: CircleLineInter) Read* (VAR r: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: CircleLineInter) Write* (VAR r: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (self: Extension) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Intersection) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Parallel) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: RightAngle) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Tangent) Calc*;
   BEGIN
   END Calc;

   PROCEDURE (self: Tangent) Read* (VAR r: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (self: Tangent) Write* (VAR r: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE NewCircleIntersection*;
   BEGIN
   END NewCircleIntersection;

   PROCEDURE NewCircleLineIntersect*;
   BEGIN
   END NewCircleLineIntersect;

   PROCEDURE NewExtension*;
   BEGIN
   END NewExtension;

   PROCEDURE NewLineIntersection*;
   BEGIN
   END NewLineIntersection;

   PROCEDURE NewParallel*;
   BEGIN
   END NewParallel;

   PROCEDURE NewRightAngle*;
   BEGIN
   END NewRightAngle;

   PROCEDURE NewTangent*;
   BEGIN
   END NewTangent;

END Kepler9.
