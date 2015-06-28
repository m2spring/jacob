MODULE Printer;

   IMPORT Fonts, Kernel, Display;

   VAR
      PageHeight*: INTEGER;
      PageWidth*: INTEGER;
      res*: INTEGER;

   PROCEDURE Circle* (x0, y0, r: INTEGER);
   BEGIN
   END Circle;

   PROCEDURE Close*;
   BEGIN
   END Close;

   PROCEDURE ContString* (str: ARRAY OF CHAR; VAR fname: ARRAY OF CHAR);
   BEGIN
   END ContString;

   PROCEDURE Ellipse* (x0, y0, a, b: INTEGER);
   BEGIN
   END Ellipse;

   PROCEDURE GetChar* (f: Fonts.Font; ch: CHAR; VAR dx, x, y, w, h: INTEGER);
   BEGIN
   END GetChar;

   PROCEDURE Line* (x0, y0, x1, y1: INTEGER);
   BEGIN
   END Line;

   PROCEDURE Open* (name, user: ARRAY OF CHAR; password: LONGINT);
   BEGIN
   END Open;

   PROCEDURE Page* (nofcopies: INTEGER);
   BEGIN
   END Page;

   PROCEDURE Picture* (x, y, w, h, mode: INTEGER; adr: LONGINT);
   BEGIN
   END Picture;

   PROCEDURE ReplConst* (x, y, w, h: INTEGER);
   BEGIN
   END ReplConst;

   PROCEDURE ReplPattern* (x, y, w, h, patno: INTEGER);
   BEGIN
   END ReplPattern;

   PROCEDURE Spline* (x0, y0, n, open: INTEGER; X, Y: ARRAY OF INTEGER);
   BEGIN
   END Spline;

   PROCEDURE String* (x, y: INTEGER; str: ARRAY OF CHAR; VAR fname: ARRAY OF CHAR);
   BEGIN
   END String;

   PROCEDURE UseColor* (red, green, blue: INTEGER);
   BEGIN
   END UseColor;

   PROCEDURE UseListFont* (name: ARRAY OF CHAR);
   BEGIN
   END UseListFont;

END Printer.
