MODULE BTree;
   IMPORT Texts, Oberon;

   CONST N = 3;

   TYPE Page = POINTER TO PageRec;

      Entry = RECORD
                  key, count: INTEGER;
                  p: Page
                END ;

      PageRec = RECORD
                  m: INTEGER;  (*no. of entries on page*)
                  p0: Page;
                  e: ARRAY 2*N OF Entry
                END ;

   VAR root: Page;
      W: Texts.Writer;

PROCEDURE search(x: INTEGER; a: Page; VAR cnt: INTEGER);
   VAR i, L, R: INTEGER;
BEGIN (*a # NIL*)
   LOOP L := 0; R := a.m;  (*binary search*)
      WHILE L < R DO
         i := (L+R) DIV 2;
         IF x <= a.e[i].key THEN R := i ELSE L := i+1 END
      END ;
      IF (R < a.m) & (a.e[R].key = x) THEN (*found*)
         INC(a.e[R].count); cnt := a.e[R].count; EXIT
      END ;
      IF R = 0 THEN a := a.p0 ELSE a := a.e[R-1].p END ;
      IF a = NIL THEN (*not found*) cnt := 0; EXIT END
   END
END search;

PROCEDURE insert(x: INTEGER; a: Page; VAR h: BOOLEAN; VAR v: Entry);
   (*a # NIL. Search key x in B-tree with root a; if found, increment counter.
      Otherwise insert new item with key x.  If an entry is to be passed up,
      assign it to v. h := "tree has become higher"*)
   VAR i, L, R: INTEGER;
      b: Page; u: Entry;
BEGIN (*a # NIL & ~h*)
   L := 0; R := a.m;  (*binary search*)
   WHILE L < R DO
      i := (L+R) DIV 2;
      IF x <= a.e[i].key THEN R := i ELSE L := i+1 END
   END ;
   IF (R < a.m) & (a.e[R].key = x) THEN (*found*) INC(a.e[R].count)
   ELSE (*item not on this page*)
      IF R = 0 THEN b := a.p0 ELSE b := a.e[R-1].p END ;
      IF b = NIL THEN (*not in tree, insert*)
         u.count := 0; u.p := NIL; h := TRUE; u.key := x
      ELSE insert(x, b, h, u)
      END ;
      IF h THEN (*insert u to the left of a.e[R]*)
         IF a.m < 2*N THEN
            h := FALSE; i := a.m;
            WHILE i > R DO DEC(i); a.e[i+1] := a.e[i] END ;
            a.e[R] := u; INC(a.m)
         ELSE NEW(b); (*overflow; split a into a,b and assign the middle entry to v*)
            IF R < N THEN (*insert in left page a*)
               i := N-1; v := a.e[i];
               WHILE i > R DO DEC(i); a.e[i+1] := a.e[i] END ;
               a.e[R] := u; i := 0;
               WHILE i < N DO b.e[i] := a.e[i+N]; INC(i) END
            ELSE (*insert in right page b*)
               DEC(R, N); i := 0;
               IF R = 0 THEN v := u
               ELSE v := a.e[N];
                  WHILE i < R-1 DO b.e[i] := a.e[i+N+1]; INC(i) END ;
                  b.e[i] := u; INC(i)
               END ;
               WHILE i < N DO b.e[i] := a.e[i+N]; INC(i) END
            END ;
            a.m := N; b.m := N; b.p0 := v.p; v.p := b
         END
      END
   END
END insert;

PROCEDURE underflow(c, a: Page; s: INTEGER; VAR h: BOOLEAN);
   (*a = underflowing page, c = ancestor page,
      s = index of deleted entry in c*)
   VAR b: Page;
      i, k: INTEGER;
BEGIN (*h & (a.m = N-1) & (c.e[s-1].p = a) *)
   IF s < c.m THEN (*b := page to the right of a*)
      b := c.e[s].p; k := (b.m-N+1) DIV 2; (*k = nof items available on page b*)
      a.e[N-1] := c.e[s]; a.e[N-1].p := b.p0;
      IF k > 0 THEN (*balance by moving k-1 items from b to a*) i := 0;
         WHILE i < k-1 DO a.e[i+N] := b.e[i]; INC(i) END ;
         c.e[s] := b.e[k-1]; b.p0 := c.e[s].p;
         c.e[s].p := b; DEC(b.m, k); i := 0;
         WHILE i < b.m DO b.e[i] := b.e[i+k]; INC(i) END ;
         a.m := N-1+k; h := FALSE
      ELSE (*merge pages a and b, discard b*)  i := 0;
         WHILE i < N DO a.e[i+N] := b.e[i]; INC(i) END ;
         i := s; DEC(c.m);
         WHILE i < c.m DO c.e[i] := c.e[i+1]; INC(i) END ;
         a.m := 2*N; h := c.m < N
      END
   ELSE (*b := page to the left of a*)  DEC(s);
      IF s = 0 THEN b := c.p0 ELSE b := c.e[s-1].p END ;
      k := (b.m-N+1) DIV 2; (*k = nof items available on page b*)
      IF k > 0 THEN i := N-1;
         WHILE i > 0 DO DEC(i); a.e[i+k] := a.e[i] END ;
         i := k-1; a.e[i] := c.e[s]; a.e[i].p := a.p0;
         (*move k-1 items from b to a, one to c*)  DEC(b.m, k);
         WHILE i > 0 DO DEC(i); a.e[i] := b.e[i+b.m+1] END ;
         c.e[s] := b.e[b.m]; a.p0 := c.e[s].p;
         c.e[s].p := a; a.m := N-1+k; h := FALSE
      ELSE (*merge pages a and b, discard a*)
         c.e[s].p := a.p0; b.e[N] := c.e[s]; i := 0;
         WHILE i < N-1 DO b.e[i+N+1] := a.e[i]; INC(i) END ;
         b.m := 2*N; DEC(c.m); h := c.m < N
      END
   END
END underflow;

PROCEDURE delete(x: INTEGER; a: Page; VAR h: BOOLEAN);
   (*search and delete key x in B-tree a; if a page underflow arises,
      balance with adjacent page or merge; h := "page a is undersize"*)
   VAR i, L, R: INTEGER; q: Page;

   PROCEDURE del(p: Page; VAR h: BOOLEAN);
      VAR k: INTEGER; q: Page;  (*global a, R*)
   BEGIN k := p.m-1; q := p.e[k].p;
      IF q # NIL THEN del(q, h);
         IF h THEN underflow(p, q, p.m, h) END
      ELSE p.e[k].p := a.e[R].p; a.e[R] := p.e[k];
         DEC(p.m); h := p.m < N
      END
   END del;

BEGIN (*a # NIL*)
   L := 0; R := a.m;  (*binary search*)
   WHILE L < R DO
      i := (L+R) DIV 2;
      IF x <= a.e[i].key THEN R := i ELSE L := i+1 END
   END ;
   IF R = 0 THEN q := a.p0 ELSE q := a.e[R-1].p END ;
   IF (R < a.m) & (a.e[R].key = x) THEN (*found*)
      IF q = NIL THEN (*a is leaf page*)
         DEC(a.m); h := a.m < N; i := R;
         WHILE i < a.m DO a.e[i] := a.e[i+1]; INC(i) END
      ELSE del(q, h);
         IF h THEN underflow(a, q, R, h) END
      END
   ELSE delete(x, q, h);
      IF h THEN underflow(a, q, R, h) END
   END
END delete;

PROCEDURE PrintTree(p: Page; level: INTEGER);
   VAR i: INTEGER;
BEGIN
   IF p # NIL THEN i := 0;
      WHILE i < level DO Texts.WriteString(W, "     "); INC(i) END ;
      i := 0;
      WHILE i < p.m DO Texts.WriteInt(W, p.e[i].key, 5); INC(i) END ;
      Texts.WriteLn(W);
      PrintTree(p.p0, level+1); i := 0;
      WHILE i < p.m DO PrintTree(p.e[i].p, level+1); INC(i) END
   END
END PrintTree;

PROCEDURE Search*;
   VAR cnt: INTEGER; S: Texts.Scanner;
BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos);
   Texts.WriteString(W, "search"); Texts.Scan(S);
   WHILE S.class = Texts.Int DO
      Texts.WriteInt(W, S.i, 4); search(SHORT(S.i), root, cnt); Texts.WriteInt(W, cnt, 4)
   END ;
   Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
END Search;

PROCEDURE Insert*;
   VAR S: Texts.Scanner;
      h: BOOLEAN; u: Entry; q: Page;
BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos);
   Texts.WriteString(W, "insert"); Texts.Scan(S);
   WHILE S.class = Texts.Int DO
      Texts.WriteInt(W, S.i, 4); h := FALSE; insert(SHORT(S.i), root, h, u);
      IF h THEN (*insert new base page*)
         q := root; NEW(root);
         root.m := 1; root.p0 := q; root.e[0] := u
      END ;
      Texts.Scan(S)
   END ;
   Texts.WriteLn(W); PrintTree(root, 0); Texts.Append(Oberon.Log, W.buf)
END Insert;

PROCEDURE Delete*;
   VAR S: Texts.Scanner;
      h: BOOLEAN;
BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos);
   Texts.WriteString(W, "delete"); Texts.Scan(S);
   WHILE S.class = Texts.Int DO
      Texts.WriteInt(W, S.i, 4); h := FALSE; delete(SHORT(S.i), root, h);
      IF h THEN (*base page size underflow*)
         IF root.m = 0 THEN root := root.p0 END
      END ;
      Texts.Scan(S)
   END ;
   Texts.WriteLn(W); PrintTree(root, 0); Texts.Append(Oberon.Log, W.buf)
END Delete;

PROCEDURE Init*;
BEGIN NEW(root); root.m := 0
END Init;

BEGIN Init; Texts.OpenWriter(W)
END BTree.
