MODULE Console;

   VAR
      printf*: PROCEDURE (format, data: LONGINT);

   PROCEDURE Ch* (ch: CHAR);
   BEGIN
   END Ch;

   PROCEDURE ChX* (ch: CHAR);
   BEGIN
   END ChX;

   PROCEDURE Hex* (x: LONGINT);
   BEGIN
   END Hex;

   PROCEDURE Init*;
   BEGIN
   END Init;

   PROCEDURE Int* (x: LONGINT);
   BEGIN
   END Int;

   PROCEDURE Ln*;
   BEGIN
   END Ln;

   PROCEDURE Real* (x: LONGREAL);
   BEGIN
   END Real;

   PROCEDURE Str* (s: ARRAY OF CHAR);
   BEGIN
   END Str;

END Console.
