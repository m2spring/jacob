MODULE Printmaps; (*NW 9.7.89 / 17.11.90*)

   VAR Pat*: ARRAY 10 OF LONGINT;

   PROCEDURE Map*(): LONGINT;
   BEGIN
    RETURN 0; 
   END Map;

   PROCEDURE ClearPage*;
   END ClearPage;

    PROCEDURE CopyPattern*(pat: LONGINT; X, Y: INTEGER);
   END CopyPattern;

    PROCEDURE ReplPattern*(pat: LONGINT; X, Y, W, H: INTEGER);
   END ReplPattern;

    PROCEDURE ReplConst*(X, Y, W, H: INTEGER);
   END ReplConst;

   PROCEDURE Dot*(x, y: LONGINT);
   END Dot;

END Printmaps.
