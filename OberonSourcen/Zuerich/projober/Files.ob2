MODULE Files;  (*NW 11.1.86 / 31.3.92*)
   IMPORT SYSTEM, Kernel, FileDir;

   (*A file consists of a sequence of pages. The first page
      contains the header. Part of the header is the page table, an array
      of disk addresses to the pages. A file is referenced through riders.
      A rider indicates a current position and refers to a file*)

   CONST MaxBufs    = 4;
            HS         = FileDir.HeaderSize;
            SS         = FileDir.SectorSize;
            STS        = FileDir.SecTabSize;
            XS         = FileDir.IndexSize;

   TYPE  DiskAdr = LONGINT;
            File*   = POINTER TO Handle;
            Buffer   = POINTER TO BufferRecord;
            FileHd  = POINTER TO FileDir.FileHeader;
            Index  = POINTER TO IndexRecord;

      Rider* =
         RECORD eof*: BOOLEAN;
            res*: LONGINT;
            file: File;
            apos, bpos: INTEGER;
            buf: Buffer;
            unused: LONGINT
         END ;

      Handle =
         RECORD next: File;
            aleng, bleng: INTEGER;
            nofbufs: INTEGER;
            modH: BOOLEAN;
            firstbuf: Buffer;
            sechint: DiskAdr;
            name: FileDir.FileName;
            time, date: LONGINT;
            unused: ARRAY 1 OF LONGINT;
            ext:  ARRAY FileDir.ExTabSize OF Index;
            sec: FileDir.SectorTable
         END ;

      BufferRecord =
         RECORD apos, lim: INTEGER;
            mod: BOOLEAN;
            next: Buffer;
            data: FileDir.DataSector
         END ;

      IndexRecord =
         RECORD adr: DiskAdr;
            mod: BOOLEAN;
            sec: FileDir.IndexSector
         END ;

      (*aleng * SS + bleng = length (including header)
         apos * SS + bpos = current position
         0 <= bpos <= lim <= SS
         0 <= apos <= aleng < PgTabSize
         (apos < aleng) & (lim = SS) OR (apos = aleng) *)

   VAR root: File;  (*list of open files*)

   (*Exported procedure:
      Old, New, Register, Close, Purge, Length, GetDate,
      Set, Read, ReadBytes, Write, WriteBytes, Pos, Base,
      Rename, Delete*)

   PROCEDURE Check(VAR s: ARRAY OF CHAR;
                                 VAR name: FileDir.FileName; VAR res: INTEGER);
      VAR i: INTEGER; ch: CHAR;
   BEGIN ch := s[0]; i := 0;
      IF ("A" <= CAP(ch)) & (CAP(ch) <= "Z") THEN
         LOOP name[i] := ch; INC(i); ch := s[i];
            IF ch = 0X THEN
               WHILE i < FileDir.FnLength DO name[i] := 0X; INC(i) END ;
               res := 0; EXIT
            END ;
            IF ~(("A" <= CAP(ch)) & (CAP(ch) <= "Z")
               OR ("0" <= ch) & (ch <= "9") OR (ch = ".")) THEN res := 3; EXIT
            END ;
            IF i = FileDir.FnLength THEN res := 4; EXIT END ;
         END
      ELSIF ch = 0X THEN name[0] := 0X; res := -1
      ELSE res := 3
      END
   END Check;


   PROCEDURE Old*(name: ARRAY OF CHAR): File;
      VAR i, k, res: INTEGER;
         f: File;
         header: DiskAdr;
         buf: Buffer;
         head: FileHd;
         namebuf: FileDir.FileName;
         inxpg: Index;
   BEGIN f := NIL; Check(name, namebuf, res);
      IF res = 0 THEN
         FileDir.Search(namebuf, header);
         IF header # 0 THEN f := root;
            WHILE (f # NIL) & (f.sec[0] # header) DO f := f.next END ;
            IF f = NIL THEN
               NEW(buf); buf.apos := 0; buf.next := buf; buf.mod := FALSE;
               head := SYSTEM.VAL(FileHd, SYSTEM.ADR(buf.data));
               Kernel.GetSector(header, head^);
               NEW(f); f.aleng := head.aleng; f.bleng := head.bleng;
               f.time := head.time; f.date := head.date;
               IF f.aleng = 0 THEN buf.lim := f.bleng ELSE buf.lim := SS END ;
               f.firstbuf := buf; f.nofbufs := 1; f.name[0] := 0X;
               f.sec := head.sec;
               k := (f.aleng + (XS-STS)) DIV XS; i := 0;
               WHILE i < k DO
                  NEW(inxpg); inxpg.adr := head.ext[i]; inxpg.mod := FALSE;
                  Kernel.GetSector(inxpg.adr, inxpg.sec); f.ext[i] := inxpg; INC(i)
               END ;
               WHILE i < FileDir.ExTabSize DO f.ext[i] := NIL; INC(i) END ;
               f.sechint := header; f.modH := FALSE; f.next := root; root := f
            END
         END
      END ;
      RETURN f
   END Old;

   PROCEDURE New*(name: ARRAY OF CHAR): File;
      VAR i, res: INTEGER;
         f: File;
         header: DiskAdr;
         buf: Buffer;
         head: FileHd;
         namebuf: FileDir.FileName;
   BEGIN f := NIL; Check(name, namebuf, res);
      IF res <= 0 THEN
         NEW(buf); buf.apos := 0; buf.mod := TRUE; buf.lim := HS; buf.next := buf;
         head := SYSTEM.VAL(FileHd, SYSTEM.ADR(buf.data));
         head.mark := FileDir.HeaderMark;
         head.aleng := 0; head.bleng := HS; head.name := namebuf;
         Kernel.GetClock(head.time, head.date);
         NEW(f); f.aleng := 0; f.bleng := HS; f.modH := TRUE;
         f.time := head.time; f.date := head.date;
         f.firstbuf := buf; f.nofbufs := 1; f.name := namebuf; f.sechint := 0;
         i := 0;
         REPEAT f.ext[i] := NIL; head.ext[i] := 0; INC(i) UNTIL i = FileDir.ExTabSize;
         i := 0;
         REPEAT f.sec[i] := 0; head.sec[i] := 0; INC(i) UNTIL i = STS
      END ;
      RETURN f
   END New;

   PROCEDURE UpdateHeader(f: File; VAR h: FileDir.FileHeader);
      VAR k: INTEGER;
   BEGIN h.aleng := f.aleng; h.bleng := f.bleng;
      h.sec := f.sec; k := (f.aleng + (XS-STS)) DIV XS;
      WHILE k > 0 DO DEC(k); h.ext[k] := f.ext[k].adr END
   END UpdateHeader;

   PROCEDURE ReadBuf(f: File; buf: Buffer; pos: INTEGER);
      VAR sec: DiskAdr;
   BEGIN
      IF pos < STS THEN sec := f.sec[pos]
      ELSE sec := f.ext[(pos-STS) DIV XS].sec.x[(pos-STS) MOD XS]
      END ;
      Kernel.GetSector(sec, buf.data);
      IF pos < f.aleng THEN buf.lim := SS ELSE buf.lim := f.bleng END ;
      buf.apos := pos; buf.mod := FALSE
   END ReadBuf;

   PROCEDURE WriteBuf(f: File; buf: Buffer);
      VAR i, k: INTEGER;
         secadr: DiskAdr; inx: Index;
   BEGIN
      IF buf.apos < STS THEN
         secadr := f.sec[buf.apos];
         IF secadr = 0 THEN
            Kernel.AllocSector(f.sechint, secadr);
            f.modH := TRUE; f.sec[buf.apos] := secadr; f.sechint := secadr
         END ;
         IF buf.apos = 0 THEN
            UpdateHeader(f, SYSTEM.VAL(FileDir.FileHeader, buf.data)); f.modH := FALSE
         END
      ELSE i := (buf.apos - STS) DIV XS; inx := f.ext[i];
         IF inx = NIL THEN
            NEW(inx); inx.adr := 0; inx.sec.x[0] := 0; f.ext[i] := inx; f.modH := TRUE
         END ;
         k := (buf.apos - STS) MOD XS; secadr := inx.sec.x[k];
         IF secadr = 0 THEN
            Kernel.AllocSector(f.sechint, secadr);
            f.modH := TRUE; inx.mod := TRUE; inx.sec.x[k] := secadr; f.sechint := secadr
         END
      END ;
      Kernel.PutSector(secadr, buf.data); buf.mod := FALSE
   END WriteBuf;

   PROCEDURE Buf(f: File; pos: INTEGER): Buffer;
      VAR buf: Buffer;
   BEGIN buf := f.firstbuf;
      LOOP
         IF buf.apos = pos THEN EXIT END ;
         buf := buf.next;
         IF buf = f.firstbuf THEN buf := NIL; EXIT END
      END ;
      RETURN buf
   END Buf;

   PROCEDURE GetBuf(f: File; pos: INTEGER): Buffer;
      VAR buf: Buffer;
   BEGIN buf := f.firstbuf;
      LOOP
         IF buf.apos = pos THEN EXIT END ;
         IF buf.next = f.firstbuf THEN
            IF f.nofbufs < MaxBufs THEN (*allocate new buffer*)
               NEW(buf); buf.next := f.firstbuf.next; f.firstbuf.next := buf;
               INC(f.nofbufs)
            ELSE (*take one of the buffers*) f.firstbuf := buf;
               IF buf.mod THEN WriteBuf(f, buf) END
            END ;
            buf.apos := pos;
            IF pos <= f.aleng THEN ReadBuf(f, buf, pos) END ;
            EXIT
         END ;
         buf := buf.next
      END ;
      RETURN buf
   END GetBuf;

   PROCEDURE Unbuffer(f: File);
      VAR i, k: INTEGER;
         buf: Buffer;
         inx: Index;
         head: FileDir.FileHeader;
   BEGIN buf := f.firstbuf;
      REPEAT
         IF buf.mod THEN WriteBuf(f, buf) END ;
         buf := buf.next
      UNTIL buf = f.firstbuf;
      k := (f.aleng + (XS-STS)) DIV XS; i := 0;
      WHILE i < k DO
         inx := f.ext[i]; INC(i);
         IF inx.mod THEN
            IF inx.adr = 0 THEN
               Kernel.AllocSector(f.sechint, inx.adr); f.sechint := inx.adr; f.modH := TRUE
            END ;
            Kernel.PutSector(inx.adr, inx.sec); inx.mod := FALSE
         END
      END ;
      IF f.modH THEN
         Kernel.GetSector(f.sec[0], head); UpdateHeader(f, head);
         Kernel.PutSector(f.sec[0], head); f.modH := FALSE
      END
   END Unbuffer;

   PROCEDURE Register*(f: File);
   BEGIN
      IF (f # NIL) & (f.name[0] > 0X) THEN
         Unbuffer(f); FileDir.Insert(f.name, f.sec[0]); f.name[0] := 0X; f.next := root; root := f
      END ;
   END Register;

   PROCEDURE Close*(f: File);
   BEGIN
      IF f # NIL THEN Unbuffer(f) END ;
   END Close;

   PROCEDURE Purge*(f: File);
      VAR a, i, j, k: INTEGER;
         ind: FileDir.IndexSector;
   BEGIN
      IF f # NIL THEN a := f.aleng + 1; f.aleng := 0;
         IF a <= STS THEN i := a
         ELSE i := STS; DEC(a, i);
            j := a MOD XS; k := a DIV XS;
            WHILE k >= 0 DO
               Kernel.GetSector(f.ext[k].adr, ind);
               REPEAT DEC(j); Kernel.FreeSector(ind.x[j])
               UNTIL j = 0;
               Kernel.FreeSector(f.ext[k].adr); j := XS; DEC(k)
            END
         END ;
         REPEAT DEC(i); Kernel.FreeSector(f.sec[i])
         UNTIL i = 0
      END
   END Purge;

   PROCEDURE Length*(f: File): LONGINT;
   BEGIN RETURN LONG(f.aleng)*SS + f.bleng - HS
   END Length;

   PROCEDURE GetDate*(f: File; VAR t, d: LONGINT);
   BEGIN t := f.time; d := f.date
   END GetDate;


   PROCEDURE Set*(VAR r: Rider; f: File; pos: LONGINT);
      VAR a, b: INTEGER;
   BEGIN  r.eof := FALSE; r.res := 0;
      IF f # NIL THEN
         IF pos < 0 THEN a := 0; b := HS
         ELSIF pos < LONG(f.aleng)*SS + f.bleng - HS THEN
            a := SHORT((pos + HS) DIV SS); b := SHORT((pos + HS) MOD SS);
         ELSE a := f.aleng; b := f.bleng
         END ;
         r.file := f; r.apos := a; r.bpos := b; r.buf := f.firstbuf
      ELSE r.file:= NIL
      END
   END Set;

   PROCEDURE Read*(VAR r: Rider; VAR x: SYSTEM.BYTE);
      VAR buf: Buffer;
   BEGIN
      IF r.apos # r.buf.apos THEN r.buf := GetBuf(r.file, r.apos) END ;
      IF r.bpos < r.buf.lim THEN
         x := r.buf.data.B[r.bpos]; INC(r.bpos)
      ELSIF r.apos < r.file.aleng THEN
         INC(r.apos); buf := Buf(r.file, r.apos);
         IF buf = NIL THEN
            IF r.buf.mod THEN WriteBuf(r.file, r.buf) END ;
            ReadBuf(r.file, r.buf, r.apos)
         ELSE r.buf := buf
         END ;
         x := r.buf.data.B[0]; r.bpos := 1
      ELSE
         x := 0X; r.eof := TRUE
      END
   END Read;

   PROCEDURE ReadBytes*(VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
      VAR src, dst, m: LONGINT; buf: Buffer;
   BEGIN dst := SYSTEM.ADR(x);
      IF LEN(x) < n THEN HALT(25) END ;
      IF r.apos # r.buf.apos THEN r.buf := GetBuf(r.file, r.apos) END ;
      LOOP
         IF n <= 0 THEN EXIT END ;
         src := SYSTEM.ADR(r.buf.data.B) + r.bpos; m := r.bpos + n;
         IF m <= r.buf.lim THEN
            SYSTEM.MOVE(src, dst, n); r.bpos := SHORT(m); r.res := 0; EXIT
         ELSIF r.buf.lim = SS THEN
            m := r.buf.lim - r.bpos;
            IF m > 0 THEN SYSTEM.MOVE(src, dst, m); INC(dst, m); DEC(n, m) END ;
            IF r.apos < r.file.aleng THEN
               INC(r.apos); r.bpos := 0; buf := Buf(r.file, r.apos);
               IF buf = NIL THEN
                  IF r.buf.mod THEN WriteBuf(r.file, r.buf) END ;
                  ReadBuf(r.file, r.buf, r.apos)
               ELSE r.buf := buf
               END
            ELSE r.res := n; r.eof := TRUE; EXIT
            END
         ELSE m := r.buf.lim - r.bpos;
            IF m > 0 THEN SYSTEM.MOVE(src, dst, m); r.bpos := r.buf.lim END ;
            r.res := n - m; r.eof := TRUE; EXIT
         END
      END
   END ReadBytes;

   PROCEDURE NewExt(f: File);
      VAR i, k: INTEGER; ext: Index;
   BEGIN k := (f.aleng - STS) DIV XS;
      IF k = FileDir.ExTabSize THEN HALT(23) END ;
      NEW(ext); ext.adr := 0; ext.mod := TRUE; f.ext[k] := ext; i := XS;
      REPEAT DEC(i); ext.sec.x[i] := 0 UNTIL i = 0
   END NewExt;

   PROCEDURE Write*(VAR r: Rider; x: SYSTEM.BYTE);
      VAR f: File; buf: Buffer;
   BEGIN
      IF r.apos # r.buf.apos THEN r.buf := GetBuf(r.file, r.apos) END ;
      IF r.bpos >= r.buf.lim THEN
         IF r.bpos < SS THEN
            INC(r.buf.lim); INC(r.file.bleng); r.file.modH := TRUE
         ELSE f := r.file; WriteBuf(f, r.buf); INC(r.apos); buf := Buf(r.file, r.apos);
            IF buf = NIL THEN
               IF r.apos <= f.aleng THEN ReadBuf(f, r.buf, r.apos)
               ELSE r.buf.apos := r.apos; r.buf.lim := 1; INC(f.aleng); f.bleng := 1; f.modH := TRUE;
                  IF (f.aleng - STS) MOD XS = 0 THEN NewExt(f) END
               END
            ELSE r.buf := buf
            END ;
            r.bpos := 0
         END
      END ;
      r.buf.data.B[r.bpos] := x; INC(r.bpos); r.buf.mod := TRUE
   END Write;

   PROCEDURE WriteBytes*(VAR r: Rider; VAR x: ARRAY OF SYSTEM.BYTE; n: LONGINT);
      VAR src, dst, m: LONGINT; f: File; buf: Buffer;
   BEGIN src := SYSTEM.ADR(x);
      IF LEN(x) < n THEN HALT(25) END ;
      IF r.apos # r.buf.apos THEN r.buf := GetBuf(r.file, r.apos) END ;
      LOOP
         IF n <= 0 THEN EXIT END ;
         r.buf.mod := TRUE; dst := SYSTEM.ADR(r.buf.data.B) + r.bpos; m := r.bpos + n;
         IF m <= r.buf.lim THEN
            SYSTEM.MOVE(src, dst, n); r.bpos := SHORT(m); EXIT
         ELSIF m <= SS THEN
            SYSTEM.MOVE(src, dst, n); r.bpos := SHORT(m);
            r.file.bleng := SHORT(m); r.buf.lim := SHORT(m); r.file.modH := TRUE; EXIT
         ELSE m := SS - r.bpos;
            IF m > 0 THEN SYSTEM.MOVE(src, dst, m); INC(src, m); DEC(n, m) END ;
            f := r.file; WriteBuf(f, r.buf); INC(r.apos); r.bpos := 0; buf := Buf(f, r.apos);
            IF buf = NIL THEN
               IF r.apos <= f.aleng THEN ReadBuf(f, r.buf, r.apos)
               ELSE r.buf.apos := r.apos; r.buf.lim := 0; INC(f.aleng); f.bleng := 0; f.modH := TRUE;
                  IF (f.aleng - STS) MOD XS = 0 THEN NewExt(f) END
               END
            ELSE r.buf := buf
            END
         END
      END
   END WriteBytes;

   PROCEDURE Pos*(VAR r: Rider): LONGINT;
   BEGIN RETURN LONG(r.apos)*SS + r.bpos - HS
   END Pos;

   PROCEDURE Base*(VAR r: Rider): File;
   BEGIN RETURN r.file
   END Base;


   PROCEDURE Delete*(name: ARRAY OF CHAR; VAR res: INTEGER);
      VAR adr: DiskAdr;
            namebuf: FileDir.FileName;
   BEGIN Check(name, namebuf, res);
      IF res = 0 THEN
         FileDir.Delete(namebuf, adr);
         IF adr = 0 THEN res := 2 END
      END
   END Delete;

   PROCEDURE Rename*(old, new: ARRAY OF CHAR; VAR res: INTEGER);
      VAR adr: DiskAdr;
            oldbuf, newbuf: FileDir.FileName;
            head: FileDir.FileHeader;
   BEGIN Check(old, oldbuf, res);
      IF res = 0 THEN
         Check(new, newbuf, res);
         IF res = 0 THEN
            FileDir.Delete(oldbuf, adr);
            IF adr # 0 THEN
               FileDir.Insert(newbuf, adr);
               Kernel.GetSector(adr, head); head.name := newbuf; Kernel.PutSector(adr, head)
            ELSE res := 2
            END
         END
      END
   END Rename;

BEGIN Kernel.FileRoot := SYSTEM.ADR(root)
END Files.
