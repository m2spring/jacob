MODULE iOPS;

   CONST
      MaxStrLen* = 256;

   TYPE
      Name* = ARRAY 24 OF CHAR;
      String* = ARRAY 256 OF CHAR;

   VAR
      intval*: LONGINT;
      lrlval*: LONGREAL;
      name*: Name;
      numtyp*: INTEGER;
      realval*: REAL;
      str*: String;

   PROCEDURE Get* (VAR sym: SHORTINT);
   BEGIN
   END Get;

   PROCEDURE Init*;
   BEGIN
   END Init;

END iOPS.
