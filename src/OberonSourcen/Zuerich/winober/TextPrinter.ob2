MODULE TextPrinter;

   IMPORT Texts, Fonts, Kernel, Display;

   CONST
      Unit* = 3048;

   TYPE
      PrintMsg* = RECORD (Texts.ElemMsg)
         prepare*: BOOLEAN;
         indent*: LONGINT;
         fnt*: Fonts.Font;
         col*: SHORTINT;
         pos*: LONGINT;
         X0*, Y0*, pno*: INTEGER;
      END;

   PROCEDURE DX* (fno: SHORTINT; ch: CHAR): LONGINT;
   BEGIN
    RETURN 0;
   END DX;

   PROCEDURE Font* (fno: SHORTINT): Fonts.Font;
   BEGIN
    RETURN NIL;
   END Font;

   PROCEDURE FontNo* (fnt: Fonts.Font): SHORTINT;
   BEGIN
    RETURN 0;
   END FontNo;

   PROCEDURE Get* (fno: SHORTINT; ch: CHAR; VAR dx, x, y, w, h: LONGINT);
   BEGIN
   END Get;

   PROCEDURE GetChar* (fno: SHORTINT; targetUnit: LONGINT; ch: CHAR; VAR pdx: LONGINT; VAR dx, x, y, w, h: INTEGER; VAR pat: LONGINT);
   BEGIN
   END GetChar;

   PROCEDURE InitFonts*;
   BEGIN
   END InitFonts;

   PROCEDURE PlaceBody* (bodyX, bodyY, bodyW, bodyH: INTEGER; T: Texts.Text; VAR pos: LONGINT; pno: INTEGER; place: BOOLEAN);
   BEGIN
   END PlaceBody;

   PROCEDURE PlaceHeader* (headerX, headerY, headerW, pno: INTEGER; fnt: Fonts.Font; VAR header: ARRAY OF CHAR; alt: BOOLEAN);
   BEGIN
   END PlaceHeader;

   PROCEDURE PrintDraft* (t: Texts.Text; header: ARRAY OF CHAR; copies: INTEGER);
   BEGIN
   END PrintDraft;

END TextPrinter.
