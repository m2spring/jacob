MODULE NetServer;  (*NW 15.2.90 / 22.11.91*)
   IMPORT SYSTEM, SCC, Core, FileDir, Files, Texts, Oberon;

   CONST PakSize = 512; GCInterval = 50;
      T0 = 300; T1 = 1000;  (*timeouts*)
      maxFileLen = 100000H;

      ACK = 10H; NAK = 25H; NPR = 26H; (*acknowledgements*)
      NRQ = 34H; NRS = 35H; (*name request, response*)
      SND = 41H; REC = 42H; (*send / receive request*)
      FDIR = 45H; DEL = 49H;  (*directory and delete file requests*)
      PRT = 43H;  (*receive to print request*)
      TRQ = 46H; TIM = 47H; (*time requests*)
      MSG = 44H; NPW = 48H;  (*new password request*)
      TOT = 7FH; (*timeout*)
      MDIR = 4AH; SML = 4BH; RML = 4CH; DML = 4DH;

   VAR W: Texts.Writer;
      handler: Oberon.Task;

      head0, head1: SCC.Header;
      partner: Core.ShortName;
      seqno: SHORTINT;

      K, reqcnt, mailuno: INTEGER;
      protected: BOOLEAN;
      MF: Files.File;  (*last mail file accessed*)
      buf: ARRAY 1024 OF CHAR;  (*used by FDIR*)
      dmy: ARRAY 4 OF CHAR;

   PROCEDURE EOL;
   BEGIN Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END EOL;

   PROCEDURE SetPartner(VAR name: ARRAY OF CHAR);
   BEGIN head0.dadr := head1.sadr; head0.destLink := head1.srcLink;
      COPY(name, partner)
   END SetPartner;

   PROCEDURE Send(t: SHORTINT; L: INTEGER; VAR data: ARRAY OF CHAR);
   BEGIN head0.typ := t; head0.len := L; SCC.SendPacket(head0, data)
   END Send;

   PROCEDURE ReceiveHead(timeout: LONGINT);
      VAR time: LONGINT;
   BEGIN time := Oberon.Time() + timeout;
      LOOP SCC.ReceiveHead(head1);
         IF head1.valid THEN
            IF head1.sadr = head0.dadr THEN EXIT
            ELSE SCC.Skip(head1.len)
            END
         ELSIF Oberon.Time() >= time THEN head1.typ := TOT; EXIT
         END
      END
   END ReceiveHead;

   PROCEDURE AppendS(VAR s, d: ARRAY OF CHAR; VAR k: INTEGER);
      VAR i: INTEGER; ch: CHAR;
   BEGIN i := 0;
      REPEAT ch := s[i]; d[k] := ch; INC(i); INC(k) UNTIL ch = 0X
   END AppendS;

   PROCEDURE AppendW(s: LONGINT; VAR d: ARRAY OF CHAR; n: INTEGER; VAR k: INTEGER);
      VAR i: INTEGER;
   BEGIN i := 0;
      REPEAT d[k] := CHR(s); s := s DIV 100H; INC(i); INC(k) UNTIL i = n
   END AppendW;

   PROCEDURE AppendN(x: LONGINT; VAR d: ARRAY OF CHAR; VAR k: INTEGER);
      VAR i: INTEGER; u: ARRAY 8 OF CHAR;
   BEGIN i := 0;
      REPEAT u[i] := CHR(x MOD 10 + 30H); INC(i); x := x DIV 10 UNTIL x = 0;
      REPEAT DEC(i); d[k] := u[i]; INC(k) UNTIL i = 0
   END AppendN;

   PROCEDURE AppendDate(t, d: INTEGER; VAR buf: ARRAY OF CHAR; VAR k: INTEGER);

      PROCEDURE Pair(ch: CHAR; x: LONGINT);
      BEGIN buf[k] := ch; INC(k);
         buf[k] := CHR(x DIV 10 + 30H); INC(k); buf[k] := CHR(x MOD 10 + 30H); INC(k)
      END Pair;

   BEGIN
      Pair(" ", d MOD 20H); Pair(".", d DIV 20H MOD 10H); Pair(".", d DIV 200H MOD 80H);
      Pair(" ", t DIV 800H MOD 20H); Pair(":", t DIV 20H MOD 40H); Pair(":", t MOD 20H * 2)
   END AppendDate;

   PROCEDURE SendBuffer(len: INTEGER; VAR done: BOOLEAN);
   VAR i, kd, ks: INTEGER; ch: CHAR;
   BEGIN
      REPEAT Send(seqno, len, buf); ReceiveHead(T1)
      UNTIL head1.typ # seqno + 10H;
      seqno := (seqno+1) MOD 8; kd := 0; ks := PakSize;
      WHILE ks < K DO buf[kd] := buf[ks]; INC(kd); INC(ks) END ;
      K := kd; done := head1.typ = seqno + 10H
   END SendBuffer;

   PROCEDURE AppendDirEntry(name: FileDir.FileName; adr: LONGINT; VAR done: BOOLEAN);
      VAR i, kd, ks: INTEGER; ch: CHAR;
   BEGIN i := 0; ch := name[0];
      WHILE ch > 0X DO buf[K] := ch; INC(i); INC(K); ch := name[i] END ;
      buf[K] := 0DX; INC(K);
      IF K >= PakSize THEN SendBuffer(PakSize, done) END
   END AppendDirEntry;

   PROCEDURE PickS(VAR s: ARRAY OF CHAR);
      VAR i, n: INTEGER; ch: CHAR;
   BEGIN i := 0; n := SHORT(LEN(s))-1; SCC.Receive(ch);
      WHILE ch > 0X DO
         IF i < n THEN s[i] := ch; INC(i) END ;
         SCC.Receive(ch)
      END ;
      s[i] := 0X
   END PickS;

   PROCEDURE PickQ(VAR w: LONGINT);
      VAR c0, c1, c2: CHAR; s: SHORTINT;
   BEGIN SCC.Receive(c0); SCC.Receive(c1); SCC.Receive(c2); SCC.Receive(s);
      w := s; w := ((w * 100H + LONG(ORD(c2))) * 100H + LONG(ORD(c1))) * 100H + LONG(ORD(c0))
   END PickQ;

   PROCEDURE PickW(VAR w: INTEGER);
      VAR c0: CHAR; s: SHORTINT;
   BEGIN SCC.Receive(c0); SCC.Receive(s); w := s; w := w * 100H + ORD(c0)
   END PickW;

   PROCEDURE SendData(F: Files.File);
      VAR k: INTEGER;
         x: CHAR;
         len: LONGINT;
         R: Files.Rider;
   BEGIN Files.Set(R, F, 0); len := 0; seqno := 0;
      LOOP k := 0;
         LOOP Files.Read(R, x);
            IF R.eof THEN EXIT END ;
            buf[k] := x; INC(k);
            IF k = PakSize THEN EXIT END
         END ;
         REPEAT Send(seqno, k, buf); ReceiveHead(T1)
         UNTIL head1.typ # seqno + 10H;
         seqno := (seqno + 1) MOD 8; len := len + k;
         IF head1.typ # seqno + 10H THEN EXIT END ;
         IF k < PakSize THEN EXIT END
      END
   END SendData;

   PROCEDURE ReceiveData(F: Files.File; VAR done: BOOLEAN);
      VAR k, retry: INTEGER;
         x: CHAR;
         len: LONGINT;
         R: Files.Rider;
   BEGIN Files.Set(R, F, 0); seqno := 0; len := 0; retry := 4;
      LOOP
         IF head1.typ = seqno THEN
            seqno := (seqno + 1) MOD 8; len := len + head1.len;
            IF len > maxFileLen THEN
               Send(NAK, 0, dmy); done := FALSE; Files.Close(F); Files.Purge(F); EXIT
            END ;
            retry := 4; Send(seqno + 10H, 0, dmy); k := 0;
            WHILE k < head1.len DO
               SCC.Receive(x); Files.Write(R, x); INC(k)
            END ;
            IF k < PakSize THEN done := TRUE; EXIT END
         ELSE DEC(retry);
            IF retry = 0 THEN done := FALSE; EXIT END ;
            Send(seqno + 10H, 0, dmy)
         END ;
         ReceiveHead(T0)
      END
   END ReceiveData;

   PROCEDURE SendMail(VAR R: Files.Rider; len: LONGINT);
      VAR k: INTEGER; x: CHAR;
   BEGIN seqno := 0;
      LOOP k := 0;
         LOOP Files.Read(R, x);
            IF k = len THEN EXIT END ;
            buf[k] := SYSTEM.ROT(x, 3); INC(k);
            IF k = PakSize THEN EXIT END
         END ;
         REPEAT Send(seqno, k, buf); ReceiveHead(T1)
         UNTIL head1.typ # seqno + 10H;
         seqno := (seqno + 1) MOD 8; len := len - k;
         IF head1.typ # seqno + 10H THEN EXIT END ;
         IF k < PakSize THEN EXIT END
      END
   END SendMail;

   PROCEDURE Serve;
      VAR i, j, k0, k1, n, uno: INTEGER;
         ch: CHAR; typ: SHORTINT;
         done: BOOLEAN;
         F: Files.File;
         R: Files.Rider;
         t, d, pw, npw, pos, len: LONGINT;
         Id: Core.ShortName;
         fname: Core.Name;
         mdir: Core.MailDir;
         mrtab: Core.MResTab;
   BEGIN SCC.ReceiveHead(head1);
      IF ~head1.valid THEN RETURN END ;
      typ := head1.typ;
      IF typ = SND THEN
         PickS(Id); PickQ(pw); PickS(fname); SetPartner(Id);
         IF Core.UserNo(Id, pw) >= 0 THEN
            F := Files.Old(fname);
            IF F # NIL THEN SendData(F)
            ELSE Send(NAK, 0, dmy)
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = REC THEN
         PickS(Id); PickQ(pw); PickS(fname); SetPartner(Id);
         IF ~protected & (Core.UserNo(Id, pw) >= 0) THEN
            F := Files.New(fname);
            Send(ACK, 0, dmy); ReceiveHead(T0);
            IF head1.valid THEN
               ReceiveData(F, done);
               IF done THEN Files.Register(F) END
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = PRT THEN
         PickS(Id); PickQ(pw); SetPartner(Id); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            F := Files.New("");
            Send(ACK, 0, dmy); ReceiveHead(T0);
            IF head1.valid THEN
               ReceiveData(F, done);
               IF done THEN Files.Close(F); Core.InsertTask(Core.PrintQueue, F, Id, uno) END
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = DEL THEN
         PickS(Id); PickQ(pw); PickS(fname); SetPartner(Id);
         IF ~protected & (Core.UserNo(Id, pw) >= 0) THEN
            Files.Delete(fname, i);
            IF i = 0 THEN Send(ACK, 0, dmy) ELSE Send(NAK, 0, dmy) END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = FDIR THEN
         PickS(Id); PickQ(pw); PickS(fname); SetPartner(Id); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            K := 0; seqno := 0; FileDir.Enumerate(fname, AppendDirEntry);
            SendBuffer(K, done)
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = MDIR THEN
         PickS(Id); PickQ(pw); SetPartner(Id); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            IF uno # mailuno THEN
               Core.GetFileName(uno, fname); MF := Files.Old(fname); mailuno := uno
            END ;
            K := 0; seqno := 0;
            IF MF # NIL THEN
               Files.Set(R, MF, 32); Files.ReadBytes(R, mdir, SIZE(Core.MailDir));
               i := mdir[0].next; j := 30; done := TRUE;
               WHILE (i # 0) & (j > 0) & done DO
                  AppendN(i, buf, K); AppendDate(mdir[i].time, mdir[i].date, buf, K);
                  buf[K] := " "; INC(K); AppendS(mdir[i].originator, buf, K);
                  buf[K-1] := " "; AppendN(mdir[i].len, buf, K); buf[K] := 0DX; INC(K);
                  IF K >= PakSize THEN SendBuffer(PakSize, done) END ;
                  i := mdir[i].next; DEC(j)
               END
            END ;
            SendBuffer(K, done)
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = SML THEN (*send mail*)
         PickS(Id); PickQ(pw); PickW(n); SetPartner(Id); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            IF uno # mailuno THEN
               Core.GetFileName(uno, fname); MF := Files.Old(fname); mailuno := uno
            END ;
            IF (MF # NIL) & (n > 0) & (n < 31) THEN
               Files.Set(R, MF, (n+1)*32);
               Files.ReadBytes(R, i, 2); Files.ReadBytes(R, j, 2); pos := LONG(i) * 100H;
               Files.ReadBytes(R, len, 4);
               IF len > 0 THEN Files.Set(R, MF, pos); SendMail(R, len)
               ELSE Send(NAK, 0, dmy)
               END
            ELSE Send(NAK, 0, dmy)
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = RML THEN (*receive mail*)
         PickS(Id); PickQ(pw); SetPartner(Id); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            F := Files.New("");
            Send(ACK, 0, dmy); ReceiveHead(T0);
            IF head1.valid THEN
               ReceiveData(F, done);
               IF done THEN Files.Close(F); Core.InsertTask(Core.MailQueue, F, Id, uno) END
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = DML THEN (*delete mail*)
         PickS(Id); PickQ(pw); PickW(n); SetPartner(Id); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            IF uno # mailuno THEN
               Core.GetFileName(uno, fname); MF := Files.Old(fname); mailuno := uno
            END ;
            IF (MF # NIL) & (n > 0) & (n < 31) THEN
               Files.Set(R, MF, 0);
               Files.ReadBytes(R, mrtab, 32); Files.ReadBytes(R, mdir, SIZE(Core.MailDir));
               i := 0; k1 := 30;
               LOOP k0 := mdir[i].next; DEC(k1);
                  IF (k0 = 0) OR (k1 = 0) THEN Send(NAK, 0, buf); EXIT END ;
                  IF k0 = n THEN
                     j := mdir[n].pos;
                     k0 := SHORT((mdir[n].len + LONG(j)*100H) DIV 100H) + 1;
                     REPEAT INCL(mrtab[j DIV 32], j MOD 32); INC(j) UNTIL j = k0;
                     mdir[n].len := 0; mdir[i].next := mdir[n].next;
                     Files.Set(R, MF, 0); Files.WriteBytes(R, mrtab, 32);
                     Files.WriteBytes(R, mdir, SIZE(Core.MailDir)); Files.Close(MF);
                     Send(ACK, 0, dmy); EXIT
                  END ;
                  i := k0
               END
            ELSE Send(NAK, 0, dmy)
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF typ = TRQ THEN
         Oberon.GetClock(t, d); SetPartner(Id); i := 0;
         AppendW(t, fname, 4, i); AppendW(d, fname, 4, i); Send(TIM, 8, fname)
      ELSIF typ = NRQ THEN i := 0;
         LOOP SCC.Receive(ch); Id[i] := ch; INC(i);
            IF ch = 0X THEN EXIT END ;
            IF i = 7 THEN Id[7] := 0X; EXIT END
         END ;
         WHILE i < head1.len DO SCC.Receive(ch); INC(i) END ;
         IF Id = Oberon.User THEN SetPartner(Id); Send(NRS, 0, dmy) END
      ELSIF typ = MSG THEN i := 0;
         WHILE i < head1.len DO SCC.Receive(ch); Texts.Write(W, ch); INC(i) END ;
         SetPartner(Id); Send(ACK, 0, dmy); EOL
      ELSIF typ = NPW THEN
         PickS(Id); PickQ(pw); uno := Core.UserNo(Id, pw);
         IF uno >= 0 THEN
            SetPartner(Id); Send(ACK, 0, dmy); ReceiveHead(T0);
            IF head1.typ = 0 THEN
               PickQ(npw); Core.SetPassword(uno, npw); Send(ACK, 0, dmy)
            ELSE Send(NAK, 0, dmy)
            END
         ELSE Send(NPR, 0, dmy)
         END
      ELSE SCC.Skip(head1.len)
      END ;
      Core.Collect
   END Serve;

   (*----------------------- Commands -------------------*)

   PROCEDURE Start*;
   BEGIN Oberon.Remove(handler); Oberon.Install(handler);
      reqcnt := 0; MF := NIL; mailuno := -2;
      Texts.WriteString(W, "Net started  (NW 22.11.91)"); EOL
   END Start;

   PROCEDURE Reset*;
   BEGIN SCC.Start(TRUE)
   END Reset;

   PROCEDURE Stop*;
   BEGIN Oberon.Remove(handler); Texts.WriteString(W, "Net stopped"); EOL
   END Stop;

   PROCEDURE Protect*;
   BEGIN protected := TRUE
   END Protect;

   PROCEDURE Unprotect*;
   BEGIN protected := FALSE
   END Unprotect;

BEGIN Texts.OpenWriter(W); NEW(handler); handler.handle := Serve
END NetServer.
