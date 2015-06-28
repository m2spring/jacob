MODULE MFiles;   (*NW 24.8.90 / 12.10.90  Ceres-3*)
   IMPORT SYSTEM, Kernel, FileDir;

   (*A file consists of a sequence of sectors. The first sector
      contains the header. Part of the header is the sector table, an array
      of addresses to the sectors. A file is referenced through riders.
      A rider indicates a current position and refers to a file*)

   CONST
         HS         = FileDir.HeaderSize;
         SS         = FileDir.SectorSize;
         STS        = FileDir.SecTabSize;
         XS         = FileDir.IndexSize;

   TYPE File*   = POINTER TO Header;
         Index  = POINTER TO FileDir.IndexSector;

      Rider* =
         RECORD eof*: BOOLEAN;
            res*: LONGINT;
            file: File;
            pos: LONGINT;
            unused: File;
            adr: LONGINT;
         END ;

      Header =
         RECORD mark: LONGINT;
            name: FileDir.FileName;
            len, time, date: LONGINT;
            ext:  ARRAY FileDir.ExTabSize OF Index;
            sec: FileDir.SectorTable
         END ;

   PROCEDURE Old*(name: ARRAY OF CHAR): File;
      VAR head: LONGINT;
         namebuf: FileDir.FileName;
   BEGIN COPY(name, namebuf);
      FileDir.Search(namebuf, head); RETURN SYSTEM.VAL(File, head)
   END Old;

   PROCEDURE New*(name: ARRAY OF CHAR): File;
      VAR f: File; head: LONGINT;
   BEGIN f := NIL; Kernel.AllocSector(0, head);
      IF head # 0 THEN
         f := SYSTEM.VAL(File, head); f.mark := FileDir.HeaderMark;
         f.len := HS; COPY(name, f.name);
         Kernel.GetClock(f.time, f.date); f.sec[0] := head
      END ;
      RETURN f
   END New;

   PROCEDURE Register*(f: File);
   BEGIN
      IF (f # NIL) & (f.name[0] > 0X) THEN FileDir.Insert(f.name, f.sec[0]) END ;
   END Register;

   PROCEDURE Length*(f: File): LONGINT;
   BEGIN RETURN f.len - HS
   END Length;

   PROCEDURE GetDate*(f: File; VAR t, d: LONGINT);
   BEGIN t := f.time; d := f.date
   END GetDate;

   PROCEDURE Set*(VAR r: Rider; f: File; pos: LONGINT);
      VAR m: INTEGER; n: LONGINT;
   BEGIN  r.eof := FALSE; r.res := 0; r.unused := NIL;
      IF f # NIL THEN
         IF pos < 0 THEN r.pos := 0
         ELSIF pos > f.len-HS THEN r.pos := f.len
         ELSE r.pos := pos+HS
         END ;
         r.file := f; m := SHORT(r.pos DIV SS); n := r.pos MOD SS;
         IF m < STS THEN r.adr := f.sec[m] + n
         ELSE r.adr := f.ext[(m-STS) DIV XS].x[(m-STS) MOD XS] + n
         END
      END
   END Set;

   PROCEDURE Read*(VAR r: Rider; VAR x: SYSTEM.BYTE);
      VAR m: INTEGER;
   BEGIN
      IF r.pos < r.file.len THEN
         SYSTEM.GET(r.adr, x); INC(r.adr); INC(r.pos);
         IF r.adr MOD SS = 0 THEN
            m := SHORT(r.pos DIV SS);
            IF m < STS THEN r.adr := r.file.sec[m]
            ELSE r.adr := r.file.ext[(m-STS) DIV XS].x[(m-STS) MOD XS]
            END
         END
      ELSE x := 0X; r.eof := TRUE
      END
   END Read;

   PROCEDURE ReadBytes*(VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
      VAR src, dst, m: LONGINT; k: INTEGER;
   BEGIN m := r.pos - r.file.len + n;
      IF m > 0 THEN DEC(n, m); r.res := m; r.eof := TRUE END ;
      src := r.adr; dst := SYSTEM.ADR(x); m := (-r.pos) MOD SS;
      LOOP
         IF n <= 0 THEN EXIT END ;
         IF n <= m THEN SYSTEM.MOVE(src, dst, n); INC(r.pos, n); r.adr := src+n; EXIT END ;
         SYSTEM.MOVE(src, dst, m); INC(r.pos, m); INC(dst,m); DEC(n, m);
         k := SHORT(r.pos DIV SS); m := SS;
         IF k < STS THEN src := r.file.sec[k]
         ELSE src := r.file.ext[(k-STS) DIV SS].x[(k-STS) MOD XS]
         END
      END
   END ReadBytes;

   PROCEDURE Write*(VAR r: Rider; x: SYSTEM.BYTE);
      VAR k, m, n: INTEGER; ix: LONGINT;
   BEGIN
      IF r.pos < r.file.len THEN
         m := SHORT(r.pos DIV SS); INC(r.pos);
         IF m < STS THEN r.adr := r.file.sec[m]
         ELSE r.adr := r.file.ext[(m-STS) DIV XS].x[(m-STS) MOD XS]
         END
      ELSE
         IF r.adr MOD SS = 0 THEN
            m := SHORT(r.pos DIV SS);
            IF m < STS THEN Kernel.AllocSector(0, r.adr); r.file.sec[m] := r.adr
            ELSE n := (m-STS) DIV XS; k := (m-STS) MOD XS;
               IF k = 0 THEN (*new index*)
                  Kernel.AllocSector(0, ix); r.file.ext[n] := SYSTEM.VAL(Index, ix)
               END ;
               Kernel.AllocSector(0, r.adr); r.file.ext[n].x[k] := r.adr
            END
         END ;
         INC(r.pos); r.file.len := r.pos
      END ;
      SYSTEM.PUT(r.adr, x); INC(r.adr)
   END Write;

   PROCEDURE WriteBytes*(VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
      VAR src, dst, m, ix: LONGINT;
         k, lim, h0, h1: INTEGER;
   BEGIN src := SYSTEM.ADR(x); dst := r.adr; m := (-r.pos) MOD SS; lim := SHORT(r.file.len DIV SS);
      LOOP
         IF n <= 0 THEN EXIT END ;
         IF m = 0 THEN
            k := SHORT(r.pos DIV SS); m := SS;
            IF k > lim THEN
               Kernel.AllocSector(0, dst);
               IF k < STS THEN r.file.sec[k] := dst
               ELSE h1 := (k-STS) DIV XS; h0 := (k-STS) MOD XS;
                  IF h0 = 0 THEN (*new extension index*)
                     Kernel.AllocSector(0, ix); r.file.ext[h1] := SYSTEM.VAL(Index, ix)
                  END ;
                  r.file.ext[h1].x[h0] := dst
               END
            ELSIF k < STS THEN dst := r.file.sec[k]
            ELSE dst := r.file.ext[(k-STS) DIV XS].x[(k-STS) MOD XS]
            END ;
         END ;
         IF n < m THEN
            SYSTEM.MOVE(src, dst, n); INC(r.pos, n); r.adr := dst + n;
            IF r.pos >= r.file.len THEN r.file.len := r.pos END ;
            EXIT
         END ;
         SYSTEM.MOVE(src, dst, m); INC(r.pos, m);
         IF r.pos >= r.file.len THEN r.file.len := r.pos END ;
         INC(src, m); DEC(n, m); m := 0
      END
   END WriteBytes;

   PROCEDURE Pos*(VAR r: Rider): LONGINT;
   BEGIN RETURN r.pos - HS
   END Pos;

   PROCEDURE Base*(VAR r: Rider): File;
   BEGIN RETURN r.file
   END Base;

END MFiles.
