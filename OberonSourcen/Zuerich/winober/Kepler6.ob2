MODULE Kepler6;

   IMPORT KeplerGraphs, KeplerPorts, Files, Display, Fonts, Kernel;

   TYPE
      Bezier* = POINTER TO BezierDesc;
      BezierDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      CRSpline* = POINTER TO CRSplineDesc;
      CRSplineDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

   PROCEDURE (s: Bezier) Draw* (f: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (s: CRSpline) Draw* (f: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE NewBezier*;
   BEGIN
   END NewBezier;

   PROCEDURE NewCRSpline*;
   BEGIN
   END NewCRSpline;

   PROCEDURE NewClosedBezier*;
   BEGIN
   END NewClosedBezier;

   PROCEDURE NewClosedCRSpline*;
   BEGIN
   END NewClosedCRSpline;

END Kepler6.
