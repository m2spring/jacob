MODULE KeplerPorts;

   IMPORT Display, Fonts, Kernel;

   TYPE
      Port* = POINTER TO PortDesc;
      PortDesc* = RECORD (Display.FrameDesc)
         x0*, y0*, scale*: INTEGER;
         ext*: Port;
      END;

      BalloonPort* = POINTER TO BalloonPortDesc;
      BalloonPortDesc* = RECORD (PortDesc)
      END;

      DisplayPort* = POINTER TO DisplayPortDesc;
      DisplayPortDesc* = RECORD (PortDesc)
      END;

      PrinterPort* = POINTER TO PrinterPortDesc;
      PrinterPortDesc* = RECORD (PortDesc)
      END;

   PROCEDURE (P: BalloonPort) DrawCircle* (x, y, r, col, mode: INTEGER);
   BEGIN
   END DrawCircle;

   PROCEDURE (P: BalloonPort) DrawEllipse* (x, y, a, b, col, mode: INTEGER);
   BEGIN
   END DrawEllipse;

   PROCEDURE (P: BalloonPort) DrawLine* (x1, y1, x2, y2, col, mode: INTEGER);
   BEGIN
   END DrawLine;

   PROCEDURE (P: BalloonPort) DrawRect* (x, y, w, h, col, mode: INTEGER);
   BEGIN
   END DrawRect;

   PROCEDURE (P: BalloonPort) DrawString* (x, y: INTEGER; s: ARRAY OF CHAR; font: Fonts.Font; col, mode: INTEGER);
   BEGIN
   END DrawString;

   PROCEDURE (P: BalloonPort) FillCircle* (x, y, r, col, pat, mode: INTEGER);
   BEGIN
   END FillCircle;

   PROCEDURE (P: BalloonPort) FillQuad* (x1, y1, x2, y2, x3, y3, x4, y4, col, pat, mode: INTEGER);
   BEGIN
   END FillQuad;

   PROCEDURE (P: BalloonPort) FillRect* (x, y, w, h, col, pat, mode: INTEGER);
   BEGIN
   END FillRect;

   PROCEDURE (P: DisplayPort) DrawCircle* (x, y, r, col, mode: INTEGER);
   BEGIN
   END DrawCircle;

   PROCEDURE (P: DisplayPort) DrawEllipse* (x, y, a, b, col, mode: INTEGER);
   BEGIN
   END DrawEllipse;

   PROCEDURE (P: DisplayPort) DrawLine* (x1, y1, x2, y2, col, mode: INTEGER);
   BEGIN
   END DrawLine;

   PROCEDURE (P: DisplayPort) DrawString* (x, y: INTEGER; s: ARRAY OF CHAR; font: Fonts.Font; col, mode: INTEGER);
   BEGIN
   END DrawString;

   PROCEDURE (P: DisplayPort) FillRect* (x, y, w, h, col, pat, mode: INTEGER);
   BEGIN
   END FillRect;

   PROCEDURE (P: Port) CX* (x: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END CX;

   PROCEDURE (P: Port) CY* (y: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END CY;

   PROCEDURE (P: Port) Cx* (X: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END Cx;

   PROCEDURE (P: Port) Cy* (Y: INTEGER): INTEGER;
   BEGIN
    RETURN 0;
   END Cy;

   PROCEDURE (P: Port) DrawCircle* (x, y, r, col, mode: INTEGER);
   BEGIN
   END DrawCircle;

   PROCEDURE (P: Port) DrawEllipse* (x, y, a, b, col, mode: INTEGER);
   BEGIN
   END DrawEllipse;

   PROCEDURE (P: Port) DrawLine* (x1, y1, x2, y2, col, mode: INTEGER);
   BEGIN
   END DrawLine;

   PROCEDURE (P: Port) DrawRect* (x, y, w, h, col, mode: INTEGER);
   BEGIN
   END DrawRect;

   PROCEDURE (P: Port) DrawString* (x, y: INTEGER; s: ARRAY OF CHAR; font: Fonts.Font; col, mode: INTEGER);
   BEGIN
   END DrawString;

   PROCEDURE (P: Port) FillCircle* (x, y, r, col, pat, mode: INTEGER);
   BEGIN
   END FillCircle;

   PROCEDURE (P: Port) FillQuad* (x1, y1, x2, y2, x3, y3, x4, y4, col, pat, mode: INTEGER);
   BEGIN
   END FillQuad;

   PROCEDURE (P: Port) FillRect* (x, y, w, h, col, pat, mode: INTEGER);
   BEGIN
   END FillRect;

   PROCEDURE (P: PrinterPort) DrawCircle* (x, y, r, col, mode: INTEGER);
   BEGIN
   END DrawCircle;

   PROCEDURE (P: PrinterPort) DrawEllipse* (x, y, a, b, col, mode: INTEGER);
   BEGIN
   END DrawEllipse;

   PROCEDURE (P: PrinterPort) DrawLine* (x1, y1, x2, y2, col, mode: INTEGER);
   BEGIN
   END DrawLine;

   PROCEDURE (P: PrinterPort) DrawString* (x, y: INTEGER; s: ARRAY OF CHAR; font: Fonts.Font; col, mode: INTEGER);
   BEGIN
   END DrawString;

   PROCEDURE (P: PrinterPort) FillRect* (x, y, w, h, col, pat, mode: INTEGER);
   BEGIN
   END FillRect;

   PROCEDURE InitBalloon* (P: BalloonPort);
   BEGIN
   END InitBalloon;

   PROCEDURE StringWidth* (VAR s: ARRAY OF CHAR; f: Fonts.Font): INTEGER;
   BEGIN
    RETURN 0;
   END StringWidth;

END KeplerPorts.
