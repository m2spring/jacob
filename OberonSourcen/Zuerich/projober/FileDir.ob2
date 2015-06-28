MODULE FileDir;   (*NW 12.1.86 / 23.8.90*)
   IMPORT SYSTEM, Kernel;

   (*File Directory is a B-tree with its root page at DirRootAdr.
      Each entry contains a file name and the disk address of the file's head sector*)

   CONST FnLength*    = 32;
            SecTabSize*   = 64;
            ExTabSize*   = 12;
            SectorSize*   = 1024;
            IndexSize*   = SectorSize DIV 4;
            HeaderSize*  = 352;
            DirRootAdr*  = 29;
            DirPgSize*   = 24;
            N = DirPgSize DIV 2;
            DirMark*    = 9B1EA38DH;
            HeaderMark* = 9BA71D86H;
            FillerSize = 52;

   TYPE DiskAdr      = LONGINT;
      FileName*       = ARRAY FnLength OF CHAR;
      SectorTable*    = ARRAY SecTabSize OF DiskAdr;
      ExtensionTable* = ARRAY ExTabSize OF DiskAdr;
      EntryHandler*   = PROCEDURE (name:FileName; sec: DiskAdr; VAR continue: BOOLEAN);

      FileHeader* =
         RECORD (Kernel.Sector)   (*allocated in the first page of each file on disk*)
            mark*: LONGINT;
            name*: FileName;
            aleng*, bleng*: INTEGER;
            date*, time*: LONGINT;
            ext*:  ExtensionTable;
            sec*: SectorTable;
            fill: ARRAY SectorSize - HeaderSize OF CHAR;
         END ;

      IndexSector* =
         RECORD (Kernel.Sector)
            x*: ARRAY IndexSize OF DiskAdr
         END ;

      DataSector* =
         RECORD (Kernel.Sector)
            B*: ARRAY SectorSize OF SYSTEM.BYTE
         END ;

      DirEntry* =  (*B-tree node*)
         RECORD
            name*: FileName;
            adr*:  DiskAdr; (*sec no of file header*)
            p*:    DiskAdr  (*sec no of descendant in directory*)
         END ;

      DirPage*  =
         RECORD (Kernel.Sector)
            mark*:  LONGINT;
            m*:     INTEGER;
            p0*:    DiskAdr;  (*sec no of left descendant in directory*)
            fill:  ARRAY FillerSize OF CHAR;
            e*:  ARRAY DirPgSize OF DirEntry
         END ;

   (*Exported procedures: Search, Insert, Delete, Enumerate, Init*)

   PROCEDURE Search*(VAR name: FileName; VAR A: DiskAdr);
      VAR i, j, L, R: INTEGER; dadr: DiskAdr;
         a: DirPage;
   BEGIN dadr := DirRootAdr;
           LOOP Kernel.GetSector(dadr, a);
         L := 0; R := a.m; (*binary search*)
         WHILE L < R DO
            i := (L+R) DIV 2;
            IF name <= a.e[i].name THEN R := i ELSE L := i+1 END
         END ;
         IF (R < a.m) & (name = a.e[R].name) THEN
            A := a.e[R].adr; EXIT (*found*)
         END ;
         IF R = 0 THEN dadr := a.p0 ELSE dadr := a.e[R-1].p END ;
         IF dadr = 0 THEN A := 0; EXIT  (*not found*) END
      END
   END Search;

   PROCEDURE insert(VAR name: FileName;
                            dpg0:  DiskAdr;
                            VAR h: BOOLEAN;
                            VAR v: DirEntry;
                            fad:     DiskAdr);
      (*h = "tree has become higher and v is ascending element"*)
      VAR ch: CHAR;
         i, j, L, R: INTEGER;
         dpg1: DiskAdr;
         u: DirEntry;
         a: DirPage;

   BEGIN (*~h*) Kernel.GetSector(dpg0, a);
      L := 0; R := a.m; (*binary search*)
      WHILE L < R DO
         i := (L+R) DIV 2;
         IF name <= a.e[i].name THEN R := i ELSE L := i+1 END
      END ;
      IF (R < a.m) & (name = a.e[R].name) THEN
         a.e[R].adr := fad; Kernel.PutSector(dpg0, a)  (*replace*)
      ELSE (*not on this page*)
         IF R = 0 THEN dpg1 := a.p0 ELSE dpg1 := a.e[R-1].p END ;
         IF dpg1 = 0 THEN (*not in tree, insert*)
            u.adr := fad; u.p := 0; h := TRUE; j := 0;
            REPEAT ch := name[j]; u.name[j] := ch; INC(j)
            UNTIL ch = 0X;
            WHILE j < FnLength DO u.name[j] := 0X; INC(j) END
         ELSE
            insert(name, dpg1, h, u, fad)
         END ;
         IF h THEN (*insert u to the left of e[R]*)
            IF a.m < DirPgSize THEN
               h := FALSE; i := a.m;
               WHILE i > R DO DEC(i); a.e[i+1] := a.e[i] END ;
               a.e[R] := u; INC(a.m)
            ELSE (*split page and assign the middle element to v*)
               a.m := N; a.mark := DirMark;
               IF R < N THEN (*insert in left half*)
                  v := a.e[N-1]; i := N-1;
                  WHILE i > R DO DEC(i); a.e[i+1] := a.e[i] END ;
                  a.e[R] := u; Kernel.PutSector(dpg0, a);
                  Kernel.AllocSector(dpg0, dpg0); i := 0;
                  WHILE i < N DO a.e[i] := a.e[i+N]; INC(i) END
               ELSE (*insert in right half*)
                  Kernel.PutSector(dpg0, a);
                  Kernel.AllocSector(dpg0, dpg0); DEC(R, N); i := 0;
                  IF R = 0 THEN v := u
                  ELSE v := a.e[N];
                     WHILE i < R-1 DO a.e[i] := a.e[N+1+i]; INC(i) END ;
                     a.e[i] := u; INC(i)
                  END ;
                  WHILE i < N DO a.e[i] := a.e[N+i]; INC(i) END
               END ;
               a.p0 := v.p; v.p := dpg0
            END ;
            Kernel.PutSector(dpg0, a)
         END
      END
   END insert;

   PROCEDURE Insert*(VAR name: FileName; fad: DiskAdr);
      VAR  oldroot: DiskAdr;
         h: BOOLEAN; U: DirEntry;
         a: DirPage;
   BEGIN h := FALSE;
      insert(name, DirRootAdr, h, U, fad);
      IF h THEN (*root overflow*)
         Kernel.GetSector(DirRootAdr, a);
         Kernel.AllocSector(DirRootAdr, oldroot); Kernel.PutSector(oldroot, a);
         a.mark := DirMark; a.m := 1; a.p0 := oldroot; a.e[0] := U;
         Kernel.PutSector(DirRootAdr, a)
      END
   END Insert;


   PROCEDURE underflow(VAR c: DirPage;  (*ancestor page*)
                                 dpg0:  DiskAdr;
                                 s:     INTEGER;  (*insertion point in c*)
                                 VAR h: BOOLEAN); (*c undersize*)
      VAR i, k: INTEGER;
            dpg1: DiskAdr;
            a, b: DirPage;  (*a := underflowing page, b := neighbouring page*)
   BEGIN Kernel.GetSector(dpg0, a);
      (*h & a.m = N-1 & dpg0 = c.e[s-1].p*)
      IF s < c.m THEN (*b := page to the right of a*)
         dpg1 := c.e[s].p; Kernel.GetSector(dpg1, b);
         k := (b.m-N+1) DIV 2; (*k = no. of items available on page b*)
         a.e[N-1] := c.e[s]; a.e[N-1].p := b.p0;
         IF k > 0 THEN
            (*move k-1 items from b to a, one to c*) i := 0;
            WHILE i < k-1 DO a.e[i+N] := b.e[i]; INC(i) END ;
            c.e[s] := b.e[i]; b.p0 := c.e[s].p;
            c.e[s].p := dpg1; DEC(b.m, k); i := 0;
            WHILE i < b.m DO b.e[i] := b.e[i+k]; INC(i) END ;
            Kernel.PutSector(dpg1, b); a.m := N-1+k; h := FALSE
         ELSE (*merge pages a and b, discard b*) i := 0;
            WHILE i < N DO a.e[i+N] := b.e[i]; INC(i) END ;
            i := s; DEC(c.m);
            WHILE i < c.m DO c.e[i] := c.e[i+1]; INC(i) END ;
            a.m := 2*N; h := c.m < N
         END ;
         Kernel.PutSector(dpg0, a)
      ELSE (*b := page to the left of a*) DEC(s);
         IF s = 0 THEN dpg1 := c.p0 ELSE dpg1 := c.e[s-1].p END ;
         Kernel.GetSector(dpg1, b);
         k := (b.m-N+1) DIV 2; (*k = no. of items available on page b*)
         IF k > 0 THEN
            i := N-1;
            WHILE i > 0 DO DEC(i); a.e[i+k] := a.e[i] END ;
            i := k-1; a.e[i] := c.e[s]; a.e[i].p := a.p0;
            (*move k-1 items from b to a, one to c*) DEC(b.m, k);
            WHILE i > 0 DO DEC(i); a.e[i] := b.e[i+b.m+1] END ;
            c.e[s] := b.e[b.m]; a.p0 := c.e[s].p;
            c.e[s].p := dpg0; a.m := N-1+k; h := FALSE;
            Kernel.PutSector(dpg0, a)
         ELSE (*merge pages a and b, discard a*)
            c.e[s].p := a.p0; b.e[N] := c.e[s]; i := 0;
            WHILE i < N-1 DO b.e[i+N+1] := a.e[i]; INC(i) END ;
            b.m := 2*N; DEC(c.m); h := c.m < N
         END ;
         Kernel.PutSector(dpg1, b)
      END
   END underflow;

   PROCEDURE delete(VAR name: FileName;
                            dpg0: DiskAdr;
                            VAR h: BOOLEAN;
                            VAR fad: DiskAdr);
   (*search and delete entry with key name; if a page underflow arises,
      balance with adjacent page or merge; h := "page dpg0 is undersize"*)

      VAR i, j, k, L, R: INTEGER;
         dpg1: DiskAdr;
         a: DirPage;

      PROCEDURE del(dpg1: DiskAdr; VAR h: BOOLEAN);
         VAR dpg2: DiskAdr;  (*global: a, R*)
               b: DirPage;
      BEGIN Kernel.GetSector(dpg1, b); dpg2 := b.e[b.m-1].p;
         IF dpg2 # 0 THEN del(dpg2, h);
            IF h THEN underflow(b, dpg2, b.m, h); Kernel.PutSector(dpg1, b) END
         ELSE
            b.e[b.m-1].p := a.e[R].p; a.e[R] := b.e[b.m-1];
            DEC(b.m); h := b.m < N; Kernel.PutSector(dpg1, b)
         END
      END del;

   BEGIN (*~h*) Kernel.GetSector(dpg0, a);
      L := 0; R := a.m; (*binary search*)
      WHILE L < R DO
         i := (L+R) DIV 2;
         IF name <= a.e[i].name THEN R := i ELSE L := i+1 END
      END ;
      IF R = 0 THEN dpg1 := a.p0 ELSE dpg1 := a.e[R-1].p END ;
      IF (R < a.m) & (name = a.e[R].name) THEN
         (*found, now delete*) fad := a.e[R].adr;
         IF dpg1 = 0 THEN  (*a is a leaf page*)
            DEC(a.m); h := a.m < N; i := R;
            WHILE i < a.m DO a.e[i] := a.e[i+1]; INC(i) END
         ELSE del(dpg1, h);
            IF h THEN underflow(a, dpg1, R, h) END
         END ;
         Kernel.PutSector(dpg0, a)
      ELSIF dpg1 # 0 THEN
         delete(name, dpg1, h, fad);
         IF h THEN underflow(a, dpg1, R, h); Kernel.PutSector(dpg0, a) END
      ELSE (*not in tree*) fad := 0
      END
   END delete;

   PROCEDURE Delete*(VAR name: FileName; VAR fad: DiskAdr);
      VAR h: BOOLEAN; newroot: DiskAdr;
         a: DirPage;
   BEGIN h := FALSE;
      delete(name, DirRootAdr, h, fad);
      IF h THEN (*root underflow*)
         Kernel.GetSector(DirRootAdr, a);
         IF (a.m = 0) & (a.p0 # 0) THEN
            newroot := a.p0; Kernel.GetSector(newroot, a);
            Kernel.PutSector(DirRootAdr, a) (*discard newroot*)
         END
      END
   END Delete;


   PROCEDURE enumerate(VAR prefix:   ARRAY OF CHAR;
                                 dpg:          DiskAdr;
                                 proc:         EntryHandler;
                                 VAR continue: BOOLEAN);
      VAR i, j, diff: INTEGER; dpg1: DiskAdr;
            a: DirPage;
   BEGIN Kernel.GetSector(dpg, a); i := 0;
      WHILE (i < a.m) & continue DO
         j := 0;
         LOOP
            IF prefix[j] = 0X THEN diff := 0; EXIT END ;
            diff := ORD(a.e[i].name[j]) - ORD(prefix[j]);
            IF diff # 0 THEN EXIT END ;
            INC(j)
         END ;
         IF i = 0 THEN dpg1 := a.p0 ELSE dpg1 := a.e[i-1].p END ;
         IF diff >= 0 THEN (*matching prefix*)
            IF dpg1 # 0 THEN enumerate(prefix, dpg1, proc, continue) END ;
            IF diff = 0 THEN
               IF continue THEN proc(a.e[i].name, a.e[i].adr, continue) END
            ELSE continue := FALSE
            END
         END ;
         INC(i)
      END ;
      IF continue & (i > 0) & (a.e[i-1].p # 0) THEN
         enumerate(prefix, a.e[i-1].p, proc, continue)
      END
   END enumerate;

   PROCEDURE Enumerate*(prefix: ARRAY OF CHAR; proc: EntryHandler);
      VAR b: BOOLEAN;
   BEGIN b := TRUE; enumerate(prefix, DirRootAdr, proc, b)
   END Enumerate;


   PROCEDURE Init;
      VAR k: INTEGER;
            A: ARRAY 2000 OF DiskAdr;

      PROCEDURE MarkSectors;
         VAR L, R, i, j, n: INTEGER; x: DiskAdr;
            hd: FileHeader;
            B: IndexSector;

         PROCEDURE sift(L, R: INTEGER);
            VAR i, j: INTEGER; x: DiskAdr;
         BEGIN j := L; x := A[j];
            LOOP i := j; j := 2*j + 1;
               IF (j+1 < R) & (A[j] < A[j+1]) THEN INC(j) END ;
               IF (j >= R) OR (x > A[j]) THEN EXIT END ;
               A[i] := A[j]
            END ;
            A[i] := x
         END sift;

      BEGIN L := k DIV 2; R := k; (*heapsort*)
         WHILE L > 0 DO DEC(L); sift(L, R) END ;
         WHILE R > 0 DO
            DEC(R); x := A[0]; A[0] := A[R]; A[R] := x; sift(L, R)
         END ;
         WHILE L < k DO
            Kernel.GetSector(A[L], hd);
            IF hd.aleng < SecTabSize THEN j := hd.aleng + 1;
               REPEAT DEC(j); Kernel.MarkSector(hd.sec[j]) UNTIL j = 0
            ELSE j := SecTabSize;
               REPEAT DEC(j); Kernel.MarkSector(hd.sec[j]) UNTIL j = 0;
               n := (hd.aleng - SecTabSize) DIV 256; i := 0;
               WHILE i <= n DO
                  Kernel.MarkSector(hd.ext[i]);
                  Kernel.GetSector(hd.ext[i], B); (*index sector*)
                  IF i < n THEN j := 256 ELSE j := (hd.aleng - SecTabSize) MOD 256 + 1 END ;
                  REPEAT DEC(j); Kernel.MarkSector(B.x[j]) UNTIL j = 0;
                  INC(i)
               END
            END ;
            INC(L)
         END
      END MarkSectors;

      PROCEDURE TraverseDir(dpg: DiskAdr);
         VAR i, j: INTEGER; a: DirPage;
      BEGIN Kernel.GetSector(dpg, a); Kernel.MarkSector(dpg); i := 0;
         WHILE i < a.m DO
            A[k] := a.e[i].adr; INC(k); INC(i);
            IF k = 2000 THEN MarkSectors; k := 0 END
         END ;
         IF a.p0 # 0 THEN
            TraverseDir(a.p0); i := 0;
            WHILE i < a.m DO
               TraverseDir(a.e[i].p); INC(i)
            END
         END
      END TraverseDir;

   BEGIN Kernel.ResetDisk; k := 0;
      TraverseDir(DirRootAdr); MarkSectors
   END Init;

BEGIN Init
END FileDir.
