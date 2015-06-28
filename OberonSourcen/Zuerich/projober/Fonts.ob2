MODULE Fonts; (*JG 27.8.90*)

   IMPORT SYSTEM, Kernel, Display, Files;

 CONST FontFileId = 0DBX;

   TYPE

      Name* = ARRAY 32 OF CHAR;

      Font* = POINTER TO FontDesc;

      FontDesc* = RECORD
         name*: Name;
         height*, minX*, maxX*, minY*, maxY*: INTEGER;
         raster*: Display.Font;
         next: Font
      END;

   VAR Default*, First: Font;

   PROCEDURE This* (name: ARRAY OF CHAR): Font;

      TYPE

         RunRec = RECORD beg, end: INTEGER END;
         BoxRec = RECORD dx, x, y, w, h: INTEGER END;

      VAR

         F: Font;
         f: Files.File; R: Files.Rider;
         NofBytes, RasterBase, A, a: LONGINT;
         NofRuns, NofBoxes: INTEGER;
         k, l, m, n: INTEGER;
         ch: CHAR;

         run: ARRAY 16 OF RunRec;
         box: ARRAY 256 OF BoxRec;

      PROCEDURE Enter (d: LONGINT);
      BEGIN
         SYSTEM.PUT(A, d MOD 256); INC(A);
         SYSTEM.PUT(A, d DIV 256); INC(A)
      END Enter;

   BEGIN F := First;
      LOOP
         IF F = NIL THEN EXIT END;
         IF name = F.name THEN EXIT END;
         F := F.next
      END;
      IF F = NIL THEN
         f := Files.Old(name);
         IF f # NIL THEN
            Files.Set(R, f, 0); Files.Read(R, ch);
            IF ch = FontFileId THEN
               Files.Read(R, ch); (*abstraction*)
               Files.Read(R, ch); (*family*)
               Files.Read(R, ch); (*variant*)
               NEW(F);
               Files.ReadBytes(R, F.height, 2);
               Files.ReadBytes(R, F.minX, 2); Files.ReadBytes(R, F.maxX, 2);
               Files.ReadBytes(R, F.minY, 2); Files.ReadBytes(R, F.maxY, 2);
               Files.ReadBytes(R, NofRuns, 2);
               NofBoxes := 0; k := 0;
               WHILE k # NofRuns DO
                  Files.ReadBytes(R, run[k].beg, 2); Files.ReadBytes(R, run[k].end, 2);
                  NofBoxes := NofBoxes + run[k].end - run[k].beg;
                  INC(k)
               END;
               NofBytes := 512 + 5; l := 0;
               WHILE l # NofBoxes DO
                  Files.ReadBytes(R, box[l].dx, 2);
                  Files.ReadBytes(R, box[l].x, 2); Files.ReadBytes(R, box[l].y, 2);
                  Files.ReadBytes(R, box[l].w, 2); Files.ReadBytes(R, box[l].h, 2);
                  NofBytes := NofBytes + 5 + (box[l].w + 7) DIV 8 * box[l].h;
                  INC(l)
               END;
               SYSTEM.NEW(F.raster, NofBytes);
               RasterBase := SYSTEM.VAL(LONGINT, F.raster);
               A := RasterBase; a := A + 512;
               SYSTEM.PUT(a, 0X); INC(a); (*dummy ch*)
               SYSTEM.PUT(a, 0X); INC(a);
               SYSTEM.PUT(a, 0X); INC(a);
               SYSTEM.PUT(a, 0X); INC(a);
               SYSTEM.PUT(a, 0X); INC(a);
               k := 0; l := 0; m := 0;
               WHILE k < NofRuns DO
                  WHILE m < run[k].beg DO Enter(515); INC(m) END;
                  WHILE m < run[k].end DO Enter(a + 3 - RasterBase);
                     SYSTEM.PUT(a, box[l].dx MOD 256); INC(a);
                     SYSTEM.PUT(a, box[l].x MOD 256); INC(a);
                     SYSTEM.PUT(a, box[l].y MOD 256); INC(a);
                     SYSTEM.PUT(a, box[l].w MOD 256); INC(a);
                     SYSTEM.PUT(a, box[l].h MOD 256); INC(a);
                     n := (box[l].w + 7) DIV 8 * box[l].h;
                     WHILE n # 0 DO
                        Files.Read(R, ch); SYSTEM.PUT(a, ch); INC(a); DEC(n)
                     END;
                     INC(l); INC(m)
                  END;
                  INC(k)
               END;
               WHILE m < 256 DO Enter(515); INC(m) END;
                   COPY(name, F.name);
               F.next := First; First := F
            ELSE F := Default
            END
         ELSE F := Default
            END
      END;
      RETURN F
   END This;

BEGIN
  First := NIL; Kernel.FontRoot := SYSTEM.ADR(First); Default := This("Syntax10.Scn.Fnt")
END Fonts.
