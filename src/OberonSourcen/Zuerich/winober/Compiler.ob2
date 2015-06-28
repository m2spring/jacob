MODULE Compiler;

   IMPORT Texts, Fonts, iOPT, Kernel, Display, iOPS;

   VAR
      ModName*: ARRAY 32 OF CHAR;
      prog*: iOPT.Node;

   PROCEDURE Compile*;
   BEGIN
   END Compile;

   PROCEDURE DoWatch*;
   BEGIN
   END DoWatch;

   PROCEDURE DontWatch*;
   BEGIN
   END DontWatch;

   PROCEDURE HideCode*;
   BEGIN
   END HideCode;

   PROCEDURE HideTree*;
   BEGIN
   END HideTree;

   PROCEDURE Module* (source: Texts.Reader; options: ARRAY OF CHAR; breakpc: LONGINT; log: Texts.Text; VAR error: BOOLEAN);
   BEGIN
   END Module;

   PROCEDURE ShowCode*;
   BEGIN
   END ShowCode;

   PROCEDURE ShowTree*;
   BEGIN
   END ShowTree;

END Compiler.
