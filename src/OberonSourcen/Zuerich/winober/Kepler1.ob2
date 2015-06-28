MODULE Kepler1;

   IMPORT KeplerGraphs, KeplerPorts, Files, KeplerFrames, Fonts, Display, Kernel;

   TYPE
      AttrLine* = POINTER TO AttrDesc;
      AttrDesc* = RECORD (KeplerGraphs.ConsDesc)
         width*, a1*, a2*: INTEGER;
      END;

      Circle* = POINTER TO CircleDesc;
      CircleDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      Ellipse* = POINTER TO EllipseDesc;
      EllipseDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      H90Shape* = POINTER TO H90ShapeDesc;
      H90ShapeDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      HShape* = POINTER TO HShapeDesc;
      HShapeDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      Line* = POINTER TO LineDesc;
      LineDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      Rectangle* = POINTER TO RectangleDesc;
      RectangleDesc* = RECORD (KeplerGraphs.ConsDesc)
      END;

      String* = POINTER TO StringDesc;
      StringDesc* = RECORD (KeplerFrames.CaptionDesc) END;

      Texture* = POINTER TO TextureDesc;
      TextureDesc* = RECORD (KeplerGraphs.ConsDesc)
         pat*: INTEGER;
      END;

      Triangle* = POINTER TO TriangleDesc;
      TriangleDesc* = RECORD (KeplerGraphs.ConsDesc)
         pat*: INTEGER;
      END;

   PROCEDURE (A: AttrLine) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (A: AttrLine) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (A: AttrLine) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (E: Ellipse) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: H90Shape) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (self: HShape) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (L: Line) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (R: Rectangle) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (T: Texture) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (T: Texture) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (T: Texture) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE (T: Triangle) Draw* (F: KeplerPorts.Port);
   BEGIN
   END Draw;

   PROCEDURE (T: Triangle) Read* (VAR R: Files.Rider);
   BEGIN
   END Read;

   PROCEDURE (T: Triangle) Write* (VAR R: Files.Rider);
   BEGIN
   END Write;

   PROCEDURE ChangeAlign*;
   BEGIN
   END ChangeAlign;

   PROCEDURE ChangeAttrLine*;
   BEGIN
   END ChangeAttrLine;

   PROCEDURE ChangeFont*;
   BEGIN
   END ChangeFont;

   PROCEDURE NewAttrLine*;
   BEGIN
   END NewAttrLine;

   PROCEDURE NewCircle*;
   BEGIN
   END NewCircle;

   PROCEDURE NewEllipse*;
   BEGIN
   END NewEllipse;

   PROCEDURE NewH90Shape*;
   BEGIN
   END NewH90Shape;

   PROCEDURE NewHShape*;
   BEGIN
   END NewHShape;

   PROCEDURE NewLine*;
   BEGIN
   END NewLine;

   PROCEDURE NewRectangle*;
   BEGIN
   END NewRectangle;

   PROCEDURE NewString*;
   BEGIN
   END NewString;

   PROCEDURE NewTexture*;
   BEGIN
   END NewTexture;

   PROCEDURE NewTriangle*;
   BEGIN
   END NewTriangle;

END Kepler1.
