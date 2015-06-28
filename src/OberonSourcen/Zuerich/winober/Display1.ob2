MODULE Display1;

   IMPORT Display;

   PROCEDURE Circle* (F: Display.Frame; col, X, Y, R, mode: INTEGER);
   BEGIN
   END Circle;

   PROCEDURE Ellipse* (F: Display.Frame; col, X, Y, A, B, mode: INTEGER);
   BEGIN
   END Ellipse;

   PROCEDURE GetPatternSize* (pat: LONGINT; VAR w, h: INTEGER);
   BEGIN
   END GetPatternSize;

   PROCEDURE Line* (F: Display.Frame; col, X0, Y0, X1, Y1, mode: INTEGER);
   BEGIN
   END Line;

   PROCEDURE ThisPattern* (n: INTEGER): LONGINT;
   BEGIN
    RETURN 0;
   END ThisPattern;

END Display1.
