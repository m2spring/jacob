MODULE MailServer0;  (*NW 17.4.89 / 25.8..91*)
   IMPORT SYSTEM, Core, Files, Texts, Oberon;

   VAR W: Texts.Writer;
      handler: Oberon.Task;

   PROCEDURE Dispatch(F: Files.File; rno, sno, hdlen: INTEGER; VAR orig, head: ARRAY OF CHAR);
   (*insert external message (from msg) in recipient rno's mail file*)
      VAR i, j, k, h: INTEGER;
         ch: CHAR; ok: BOOLEAN;
         pos, bdylen, tm, dt: LONGINT;
         fname: Core.Name;
         MF: Files.File; (*destination*)
         R, Q: Files.Rider;
         mrtab: Core.MResTab;
         mdir: Core.MailDir;
   BEGIN Core.GetFileName(rno, fname); MF := Files.Old(fname);
      IF MF # NIL THEN
         Files.Set(Q, MF, 0); Files.ReadBytes(Q, mrtab, 32);
         Files.ReadBytes(Q, mdir, SIZE(Core.MailDir))
      ELSE (*create new mailbox file*)
         MF := Files.New(fname); Files.Set(Q, MF, 0);  Files.Register(MF);
         mdir[0].next := 0; mrtab[0] := {4 .. 31}; i := 1;
         REPEAT mrtab[i] := {0 .. 31}; INC(i) UNTIL i = 7;
         mrtab[7] := {0 .. 29}; i := 0;
         REPEAT mdir[i].len := 0; INC(i) UNTIL i = 31
      END ;
      Files.Set(R, F, 0); bdylen := Files.Length(F);
      ok := FALSE; i := 0;
      REPEAT INC(i) UNTIL (i = 31) OR (mdir[i].len = 0);
      IF i < 31 THEN  (*free slot found, now find free blocks in file*)
         j := -1;
         REPEAT INC(j);
            IF j MOD 32 IN mrtab[j DIV 32] THEN
               h := j; k := SHORT((bdylen + hdlen + 255) DIV 256) + j;
               LOOP INC(h);
                  IF h = k THEN ok := TRUE; EXIT END ;
                  IF (h = 256) OR ~(h MOD 32 IN mrtab[h DIV 32]) THEN j := h; EXIT END
               END
            END
         UNTIL ok OR (j >= 255)
      END ;
      IF ok THEN (*insert msg in blocks j .. k-1*)
         pos := LONG(j) * 256; mdir[i].pos := j;
         REPEAT EXCL(mrtab[j DIV 32], j MOD 32); INC(j) UNTIL j = k;
         mdir[i].len := bdylen + hdlen;
         Oberon.GetClock(tm, dt);
         mdir[i].time := SHORT(tm DIV 2); mdir[i].date := SHORT(dt);
         j := 0;
         WHILE (j < 19) & (orig[j] > " ") DO mdir[i].originator[j] := orig[j]; INC(j) END ;
         mdir[i].originator[j] := 0X;
         mdir[i].next := mdir[0].next; mdir[0].next := i;
         Files.Set(Q, MF, 0); Files.WriteBytes(Q, mrtab, 32);
         Files.WriteBytes(Q, mdir, SIZE(Core.MailDir)); Files.Set(Q, MF, pos);
         j := 0;
         WHILE j < hdlen DO
            Files.Write(Q, SYSTEM.ROT(head[j], 5)); INC(j)
         END ;
         j := 0;
         WHILE j < bdylen DO
            Files.Read(R, ch); Files.Write(Q, SYSTEM.ROT(ch, 5)); INC(j)
         END ;
         j := SHORT((-Files.Pos(Q)) MOD 256);
         WHILE j > 0 DO Files.Write(Q, 0); DEC(j) END ;
         Files.Close(MF)
      ELSIF (rno # sno) & (sno > 0) THEN (*return to sender*)
         Dispatch(F, sno, sno, hdlen, orig, head)
      ELSIF sno # 0 THEN (*send to postmaster*)
         Dispatch(F, 0, sno, hdlen, orig, head)
      END
   END Dispatch;

   PROCEDURE Serve;
      VAR i, j, sno, rno, hdlen: INTEGER;
         ch: CHAR;
         pos, dt, tm: LONGINT;
         F: Files.File; R: Files.Rider;
         Id: Core.ShortName;
         orig: Core.LongName;
         head, recip: ARRAY 64 OF CHAR;

      PROCEDURE Pair(ch: CHAR; x: LONGINT);
      BEGIN head[j] := ch; INC(j);
         head[j] := CHR(x DIV 10 + 30H); INC(j); head[j] := CHR(x MOD 10 + 30H); INC(j)
      END Pair;

   BEGIN
      IF Core.MailQueue.n > 0 THEN
         Core.GetTask(Core.MailQueue, F, Id, sno);
            Core.GetUserName(sno, orig); Oberon.GetClock(tm, dt);
            COPY("From: ", head); i := 0; j := 6;
            WHILE orig[i] > 0X DO head[j] := orig[i]; INC(i); INC(j) END ;
            head[j] := 0DX; INC(j); head[j] := "A"; INC(j); head[j] := "t"; INC(j); head[j] := ":"; INC(j);
            Pair(" ", dt MOD 20H); Pair(".", dt DIV 20H MOD 10H); Pair(".", dt DIV 200H MOD 80H);
            Pair(" ", tm DIV 1000H MOD 20H); Pair(":", tm DIV 40H MOD 40H); Pair(":", tm MOD 40H);
            head[j] := 0DX; hdlen := j+1;
            Files.Set(R, F, 0);
            LOOP (*next line*) pos := Files.Pos(R);
               REPEAT Files.Read(R, ch) UNTIL (ch > " ") OR R.eof;
               IF R.eof THEN EXIT END ;
               i := 0;
               REPEAT recip[i] := ch; INC(i); Files.Read(R, ch) UNTIL ch <= ":";
               recip[i] := 0X;
               IF (recip # "To") & (recip # "cc") THEN EXIT END ;
               LOOP (*next recipient*)
                  WHILE (" " <= ch) & (ch < "A") DO Files.Read(R, ch) END ;
                  IF ch < " " THEN EXIT END ;
                  i := 0;
                  WHILE ch > " " DO recip[i] := ch; INC(i); Files.Read(R, ch) END ;
                  recip[i] := 0X;
                  IF recip = "all" THEN rno := Core.NofUsers();
                     WHILE rno > 1 DO  (*exclude postmaster*)
                        DEC(rno); Dispatch(F, rno, 0, hdlen, orig, head)
                     END
                  ELSE rno := Core.UserNum(recip);
                     IF rno < 0 THEN rno := sno END ;
                     Dispatch(F, rno, sno, hdlen, orig, head)
                  END
               END
            END ;
         Core.RemoveTask(Core.MailQueue)
      END
   END Serve;

   (*------------------------ Commands --------------------------*)

   PROCEDURE Start*;
   BEGIN Oberon.Install(handler);
      Texts.WriteString(W, "Mailer started  (NW 25.8.91)");
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Start;

   PROCEDURE State*;
   BEGIN Texts.WriteString(W, "Mail queue:"); Texts.WriteInt(W, Core.MailQueue.n, 3);
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END State;

   PROCEDURE Stop*;
   BEGIN Oberon.Remove(handler); Texts.WriteString(W, "Mailer stopped");
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END Stop;

BEGIN Texts.OpenWriter(W); NEW(handler); handler.handle := Serve
END MailServer0.
