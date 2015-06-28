MODULE Bitmaps;

IMPORT Kernel;

TYPE
   Bitmap*     = POINTER TO BitmapDesc;
   BitmapDesc* = RECORD (Kernel.FinObjDesc)
                  w-, h-: LONGINT;
                 END;
VAR
   Disp-: Bitmap;

PROCEDURE CopyBlock* (sB, dB: Bitmap; sx, sy, w, h, dx, dy, mode: INTEGER);
BEGIN
END CopyBlock;

PROCEDURE New* (w, h: LONGINT): Bitmap;
BEGIN
 RETURN NIL;
END New;

END Bitmaps.
