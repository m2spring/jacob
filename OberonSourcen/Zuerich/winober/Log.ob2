MODULE Log;

   IMPORT SYSTEM;

   PROCEDURE Bool* (b: BOOLEAN);
   BEGIN
   END Bool;

   PROCEDURE Ch* (ch: CHAR);
   BEGIN
   END Ch;

   PROCEDURE Clear*;
   BEGIN
   END Clear;

   PROCEDURE Date* (t, d: LONGINT);
   BEGIN
   END Date;

   PROCEDURE Dump* (VAR a: ARRAY OF SYSTEM.BYTE);
   BEGIN
   END Dump;

   PROCEDURE DumpRange* (VAR a: ARRAY OF SYSTEM.BYTE; beg, len: LONGINT);
   BEGIN
   END DumpRange;

   PROCEDURE Hex* (x: LONGINT);
   BEGIN
   END Hex;

   PROCEDURE Int* (x: LONGINT);
   BEGIN
   END Int;

   PROCEDURE Ln*;
   BEGIN
   END Ln;

   PROCEDURE Open*;
   BEGIN
   END Open;

   PROCEDURE Pin*;
   BEGIN
   END Pin;

   PROCEDURE Real* (x: LONGREAL);
   BEGIN
   END Real;

   PROCEDURE Set* (s: SET);
   BEGIN
   END Set;

   PROCEDURE Str* (s: ARRAY OF CHAR);
   BEGIN
   END Str;

END Log.
