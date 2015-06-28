MODULE In;

   IMPORT Texts, Fonts, Kernel, Display;

   VAR
      Done*: BOOLEAN;
      S*: Texts.Scanner;

   PROCEDURE Char* (VAR ch: CHAR);
   BEGIN
   END Char;

   PROCEDURE Int* (VAR i: INTEGER);
   BEGIN
   END Int;

   PROCEDURE LongInt* (VAR i: LONGINT);
   BEGIN
   END LongInt;

   PROCEDURE LongReal* (VAR y: LONGREAL);
   BEGIN
   END LongReal;

   PROCEDURE Name* (VAR name: ARRAY OF CHAR);
   BEGIN
   END Name;

   PROCEDURE Open*;
   BEGIN
   END Open;

   PROCEDURE Real* (VAR x: REAL);
   BEGIN
   END Real;

   PROCEDURE String* (VAR str: ARRAY OF CHAR);
   BEGIN
   END String;

END In.
