MODULE Net;  (*NW 3.7.88 / 19.9.91*)
   IMPORT SCC, Files, Viewers, Texts, TextFrames, MenuViewers, Oberon;

   CONST PakSize = 512;
      T0 = 300; T1 = 1000;  (*timeouts*)

      ACK = 10H; NAK = 25H; NPR = 26H; (*acknowledgements*)
      NRQ = 34H; NRS = 35H; (*name request, response*)
      SND = 41H; REC = 42H; (*send / receive request*)
      FDIR = 45H; DEL = 49H;
      MSG = 44H; TRQ = 46H; TIM = 47H;
      NPW = 48H;   (*new password request*)
      MDIR = 4AH; SML = 4BH; RML = 4CH; DML = 4DH;

   VAR W: Texts.Writer;
      Server: Oberon.Task;
      head0, head1: SCC.Header;
      partner, dmy: ARRAY 8 OF CHAR;
      protected: BOOLEAN;  (*write-protection*)

   PROCEDURE SetPartner(VAR name: ARRAY OF CHAR);
   BEGIN head0.dadr := head1.sadr; COPY(name, partner)
   END SetPartner;

   PROCEDURE Send(t: SHORTINT; L: INTEGER; VAR data: ARRAY OF CHAR);
   BEGIN head0.typ := t; head0.len := L; SCC.SendPacket(head0, data)
   END Send;

   PROCEDURE ReceiveHead(timeout: LONGINT);
      VAR time: LONGINT;
   BEGIN time := Oberon.Time() + timeout;
      LOOP SCC.ReceiveHead(head1);
         IF head1.valid THEN
            IF head1.sadr = head0.dadr THEN EXIT ELSE SCC.Skip(head1.len) END
         ELSIF Oberon.Time() >= time THEN head1.typ := -1; EXIT
         END
      END
   END ReceiveHead;

   PROCEDURE FindPartner(VAR name: ARRAY OF CHAR; VAR res: INTEGER);
      VAR time: LONGINT; k: INTEGER;
   BEGIN SCC.Skip(SCC.Available()); res := 0;
      IF name # partner THEN k := 0;
         WHILE name[k] > 0X DO INC(k) END ;
         head0.dadr := -1; Send(NRQ, k+1, name); time := Oberon.Time() + T1;
         LOOP SCC.ReceiveHead(head1);
            IF head1.valid THEN
               IF head1.typ = NRS THEN SetPartner(name); EXIT
               ELSE SCC.Skip(head1.len)
               END
            ELSIF Oberon.Time() >= time THEN res := 1; partner[0] := 0X; EXIT
            END
         END
      END
   END FindPartner;

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

   PROCEDURE PickS(VAR s: ARRAY OF CHAR);
      VAR i: INTEGER; ch: CHAR;
   BEGIN i := 0;
      REPEAT SCC.Receive(ch); s[i] := ch; INC(i) UNTIL ch = 0X
   END PickS;

   PROCEDURE PickQ(VAR w: LONGINT);
      VAR c0, c1, c2: CHAR; s: SHORTINT;
   BEGIN SCC.Receive(c0); SCC.Receive(c1); SCC.Receive(c2); SCC.Receive(s);
      w := s; w := ((w * 100H + LONG(ORD(c2))) * 100H + LONG(ORD(c1))) * 100H + LONG(ORD(c0))
   END PickQ;

   PROCEDURE SendData(F: Files.File);
      VAR k: INTEGER;
         seqno: SHORTINT; x: CHAR;
         len: LONGINT;
         R: Files.Rider;
         buf: ARRAY PakSize OF CHAR;
   BEGIN Files.Set(R, F, 0); len := 0; seqno := 0;
      LOOP k := 0;
         LOOP Files.Read(R, x);
            IF R.eof THEN EXIT END ;
            buf[k] := x; INC(k);
            IF k = PakSize THEN EXIT END
         END ;
         REPEAT Send(seqno, k, buf); ReceiveHead(T1)
         UNTIL head1.typ # seqno + ACK;
         seqno := (seqno + 1) MOD 8; len := len + k;
         IF head1.typ # seqno + ACK THEN
            Texts.WriteString(W, " failed"); EXIT
         END ;
         IF k < PakSize THEN EXIT END
      END ;
      Texts.WriteInt(W, len, 7)
   END SendData;

   PROCEDURE ReceiveData(F: Files.File; VAR done: BOOLEAN);
      VAR k, retry: INTEGER;
         seqno: SHORTINT; x: CHAR;
         len: LONGINT;
         R: Files.Rider;
   BEGIN Files.Set(R, F, 0); seqno := 0; len := 0; retry := 2;
      LOOP
         IF head1.typ = seqno THEN
            seqno := (seqno + 1) MOD 8; len := len + head1.len; retry := 2;
            Send(seqno + ACK, 0, dmy); k := 0;
            WHILE k < head1.len DO
               SCC.Receive(x); Files.Write(R, x); INC(k)
            END ;
            IF k < PakSize THEN done := TRUE; EXIT END
         ELSE DEC(retry);
            IF retry = 0 THEN
               Texts.WriteString(W, " failed"); done := FALSE; EXIT
            END ;
            Send(seqno + ACK, 0, dmy)
         END ;
         ReceiveHead(T0)
      END ;
      Texts.WriteInt(W, len, 7)
   END ReceiveData;

   PROCEDURE SendText(T: Texts.Text);
      VAR k: INTEGER;
         seqno: SHORTINT; x: CHAR;
         R: Texts.Reader;
         buf: ARRAY PakSize OF CHAR;
   BEGIN Texts.OpenReader(R, T, 0); seqno := 0;
      LOOP k := 0;
         LOOP Texts.Read(R, x);
            IF x = 0X THEN EXIT END ;
            buf[k] := x; INC(k);
            IF k = PakSize THEN EXIT END
         END ;
         REPEAT Send(seqno, k, buf); ReceiveHead(T1)
         UNTIL head1.typ # seqno + ACK;
         seqno := (seqno + 1) MOD 8;
         IF head1.typ # seqno + ACK THEN
            Texts.WriteString(W, " failed"); EXIT
         END ;
         IF k < PakSize THEN EXIT END
      END
   END SendText;

   PROCEDURE ReceiveText(T: Texts.Text);
      VAR k, retry: INTEGER;
         seqno: SHORTINT; x: CHAR;
   BEGIN seqno := 0; retry := 2;
      LOOP
         IF head1.typ = seqno THEN
            seqno := (seqno + 1) MOD 8; retry := 2;
            Send(seqno + 10H, 0, dmy); k := 0;
            WHILE k < head1.len DO
               SCC.Receive(x); Texts.Write(W, x); INC(k)
            END ;
            Texts.Append(T, W.buf);
            IF k < PakSize THEN EXIT END
         ELSE DEC(retry);
            IF retry = 0 THEN
               Texts.WriteString(W, " failed"); Texts.WriteLn(W);
               Texts.Append(Oberon.Log, W.buf); EXIT
            END ;
            Send(seqno + 10H, 0, dmy)
         END ;
         ReceiveHead(T0)
      END
   END ReceiveText;

   PROCEDURE reply(msg: INTEGER);
   BEGIN
      CASE msg OF
           0:
         | 1: Texts.WriteString(W, " no link")
         | 2: Texts.WriteString(W, " no permission")
         | 3: Texts.WriteString(W, " not done")
         | 4: Texts.WriteString(W, " not found")
         | 5: Texts.WriteString(W, " no response")
         | 6: Texts.WriteString(W, " time set")
         | 7: Texts.WriteString(W, " password set")
         | 8: Texts.WriteString(W, " no recipient")
         | 9: Texts.WriteString(W, " msg too long")
      END ;
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END reply;

   PROCEDURE Serve;
      VAR i: INTEGER;
         done: BOOLEAN; ch: CHAR;
         F: Files.File;
         pw: LONGINT;
         Id: ARRAY 10 OF CHAR;
         FileName: ARRAY 32 OF CHAR;
   BEGIN SCC.ReceiveHead(head1);
   IF head1.valid THEN
      IF head1.typ = SND THEN
         PickS(Id); PickQ(pw); PickS(FileName);
         Texts.WriteString(W, Id); Texts.Write(W, " "); Texts.WriteString(W, FileName);
         F := Files.Old(FileName);
         IF F # NIL THEN
            Texts.WriteString(W, " sending"); SetPartner(Id);
            Texts.Append(Oberon.Log, W.buf); SendData(F)
         ELSE Send(NAK, 0, dmy); Texts.Write(W, "~")
         END ;
         reply(0)
      ELSIF head1.typ = REC THEN
         PickS(Id); PickQ(pw); PickS(FileName);
         IF ~protected THEN
            Texts.WriteString(W, Id); Texts.Write(W, " "); Texts.WriteString(W, FileName);
            F := Files.New(FileName);
            IF F # NIL THEN
               Texts.WriteString(W, " receiving"); SetPartner(Id);
               Texts.Append(Oberon.Log, W.buf);
               Send(ACK, 0, dmy); ReceiveHead(T0); ReceiveData(F, done);
               IF done THEN Files.Register(F) END
            ELSE Send(NAK, 0, dmy); Texts.Write(W, "~")
            END ;
            reply(0)
         ELSE Send(NPR, 0, dmy)
         END
      ELSIF head1.typ = MSG THEN i := 0;
         WHILE i < head1.len DO SCC.Receive(ch); Texts.Write(W, ch); INC(i) END ;
         Send(ACK, 0, dmy); reply(0)
      ELSIF head1.typ = NRQ THEN i := 0;
         LOOP SCC.Receive(ch); Id[i] := ch; INC(i);
            IF ch = 0X THEN EXIT END ;
            IF i = 7 THEN Id[7] := 0X; EXIT END
         END ;
         WHILE i < head1.len DO SCC.Receive(ch); INC(i) END ;
         IF Id = Oberon.User THEN SetPartner(Id); Send(NRS, 0, dmy) END
      ELSE SCC.Skip(head1.len)
      END
   END
   END Serve;

   PROCEDURE GetPar1(VAR S: Texts.Scanner);
   BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S)
   END GetPar1;

   PROCEDURE GetPar(VAR S: Texts.Scanner; VAR end: LONGINT);
      VAR T: Texts.Text; beg, tm: LONGINT;
   BEGIN Texts.Scan(S);
      IF (S.class = Texts.Char) & (S.c = "^") THEN
         Oberon.GetSelection(T, beg, end, tm);
         IF tm >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
      ELSE end := Oberon.Par.text.len
      END
   END GetPar;

   PROCEDURE SendFiles*;
      VAR k: INTEGER;
         end: LONGINT;
         S: Texts.Scanner;
         F: Files.File;
         name: ARRAY 32 OF CHAR;
         buf: ARRAY 64 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN
            GetPar(S, end);
            LOOP
               IF S.class # Texts.Name THEN EXIT END ;
               Texts.WriteString(W, S.s); k := 0; AppendS(S.s, name, k);
               IF S.nextCh = ":" THEN (*prefix*)
                  Texts.Scan(S); Texts.Scan(S);
                  IF S.class = Texts.Name THEN
                     name[k-1] := "."; AppendS(S.s, name, k);
                     Texts.Write(W, ":"); Texts.WriteString(W, S.s)
                  END
               END ;
               F := Files.Old(S.s);
               IF F # NIL THEN k := 0;
                  AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
                  AppendS(name, buf, k); Send(REC, k, buf); ReceiveHead(T0);
                  IF head1.typ = ACK THEN
                     Texts.WriteString(W, " sending"); Texts.Append(Oberon.Log, W.buf);
                     SendData(F); reply(0)
                  ELSIF head1.typ = NPR THEN reply(2); EXIT
                  ELSIF head1.typ = NAK THEN reply(3); EXIT
                  ELSE reply(5); EXIT
                  END
               ELSE reply(4)
               END ;
               IF Texts.Pos(S) >= end THEN EXIT END ;
               Texts.Scan(S)
            END
         ELSE reply(1)
         END
      END
   END SendFiles;

   PROCEDURE ReceiveFiles*;
      VAR k: INTEGER; done: BOOLEAN;
         end: LONGINT;
         S: Texts.Scanner;
         F: Files.File;
         name: ARRAY 32 OF CHAR;
         buf: ARRAY 64 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN
            GetPar(S, end);
            LOOP
               IF S.class # Texts.Name THEN EXIT END ;
               Texts.WriteString(W, S.s); k := 0; AppendS(S.s, name, k);
               IF S.nextCh = ":" THEN (*prefix*)
                  Texts.Scan(S); Texts.Scan(S);
                  IF S.class = Texts.Name THEN
                     name[k-1] := "."; AppendS(S.s, name, k);
                     Texts.Write(W, ":"); Texts.WriteString(W, S.s)
                  END
               END ;
               k := 0; AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
               AppendS(name, buf, k); Send(SND, k, buf);
               Texts.WriteString(W, " receiving"); Texts.Append(Oberon.Log, W.buf);
               ReceiveHead(T1);
               IF head1.typ = 0 THEN
                  F := Files.New(S.s);
                  IF F # NIL THEN
                     ReceiveData(F, done);
                     IF done THEN Files.Register(F); reply(0) ELSE EXIT END
                  ELSE reply(3); Send(NAK, 0, dmy)
                  END
               ELSIF head1.typ = NAK THEN reply(4)
               ELSIF head1.typ = NPR THEN reply(2); EXIT
               ELSE reply(5); EXIT
               END ;
               IF Texts.Pos(S) >= end THEN EXIT END ;
               Texts.Scan(S)
            END
         ELSE reply(1)
         END
      END
   END ReceiveFiles;

   PROCEDURE DeleteFiles*;
      VAR k: INTEGER;
         S: Texts.Scanner;
         buf: ARRAY 64 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN
            LOOP Texts.Scan(S);
               IF S.class # Texts.Name THEN EXIT END ;
               k := 0; AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
               AppendS(S.s, buf, k); Send(DEL, k, buf);
               Texts.WriteString(W, S.s); Texts.WriteString(W, " remote deleting");
               ReceiveHead(T1);
               IF head1.typ = ACK THEN reply(0)
               ELSIF head1.typ = NAK THEN reply(3)
               ELSIF head1.typ = NPR THEN reply(2); EXIT
               ELSE reply(5); EXIT
               END
            END
         ELSE reply(1)
         END
      END
   END DeleteFiles;

   PROCEDURE Directory*;
      VAR k, X, Y: INTEGER;
         T: Texts.Text;
         V: Viewers.Viewer;
         buf: ARRAY 32 OF CHAR;
         S: Texts.Scanner;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN
            Texts.Scan(S);
            IF S.class = Texts.Name THEN (*prefix*)
               AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
               AppendS(S.s, buf, k); Send(FDIR, k, buf); ReceiveHead(T1);
               IF head1.typ = 0 THEN
                  T := TextFrames.Text("");
                  Oberon.AllocateSystemViewer(Oberon.Par.frame.X, X, Y);
                  V := MenuViewers.New(
                           TextFrames.NewMenu("Net.Directory", "System.Close  Edit.Store"),
                           TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
                  ReceiveText(T)
               ELSIF head1.typ = NAK THEN reply(4)
               ELSIF head1.typ = NPR THEN reply(2)
               ELSE  reply(5)
               END
            END
         ELSE reply(1)
         END
      END
   END Directory;

   PROCEDURE Mailbox*;
      VAR k, X, Y: INTEGER;
         T: Texts.Text;
         V: Viewers.Viewer;
         S: Texts.Scanner;
         buf: ARRAY 32 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN
            AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
            Send(MDIR, k, buf); ReceiveHead(T1);
            IF head1.typ = 0 THEN
               T := TextFrames.Text("");
               Oberon.AllocateSystemViewer(Oberon.Par.frame.X, X, Y);
               V := MenuViewers.New(
                     TextFrames.NewMenu(S.s, "System.Close  Net.ReceiveMail  Net.DeleteMail"),
                     TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
               ReceiveText(T)
            ELSIF head1.typ = NAK THEN reply(4)
            ELSIF head1.typ = NPR THEN reply(2)
            ELSE  reply(5)
            END
         ELSE reply(1)
         END
      END
   END Mailbox;

   PROCEDURE ReceiveMail*;
      VAR k, X, Y: INTEGER;
         T: Texts.Text;
         F: TextFrames.Frame;
         S: Texts.Scanner;
         V: Viewers.Viewer;
         buf: ARRAY 32 OF CHAR;
   BEGIN F := Oberon.Par.frame(TextFrames.Frame);
      Texts.OpenScanner(S, F.text, 0); Texts.Scan(S); FindPartner(S.s, k);
      IF k = 0 THEN
         F := F.next(TextFrames.Frame);
         IF F.sel > 0 THEN
            Texts.OpenScanner(S, F.text, F.selbeg.pos); Texts.Scan(S);
            IF S.class = Texts.Int THEN
               k := 0; AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
               AppendW(S.i, buf, 2, k); Send(SML, k, buf); ReceiveHead(T1);
               IF head1.typ = 0 THEN
                  T := TextFrames.Text("");
                  Oberon.AllocateUserViewer(Oberon.Par.frame.X, X, Y);
                  V := MenuViewers.New(
                     TextFrames.NewMenu("Message.Text", "System.Close  System.Copy  System.Grow  Edit.Store"),
                     TextFrames.NewText(T, 0), TextFrames.menuH, X, Y);
                  ReceiveText(T)
               ELSIF head1.typ = NAK THEN reply(4)
               ELSIF head1.typ = NPR THEN reply(2)
               ELSE  reply(5)
               END
            END
         END
      ELSE reply(1)
      END
   END ReceiveMail;

   PROCEDURE SendMail*;
      VAR k: INTEGER;
         S: Texts.Scanner;
         T: Texts.Text;
         v: Viewers.Viewer;
         buf: ARRAY 64 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN
            v := Oberon.MarkedViewer();
            IF (v.dsc # NIL) & (v.dsc.next IS TextFrames.Frame) THEN
               T := v.dsc.next(TextFrames.Frame).text;
               IF T.len < 60000 THEN
                  Texts.OpenScanner(S, T, 0); Texts.Scan(S);
                  IF (S.class = Texts.Name) & (S.s = "To") THEN
                     AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
                     Send(RML, k, buf); ReceiveHead(T1);
                     IF head1.typ = ACK THEN
                        Texts.WriteString(W, " mailing"); Texts.Append(Oberon.Log, W.buf);
                        SendText(T); reply(0)
                     ELSIF head1.typ = NPR THEN reply(2)
                     ELSIF head1.typ = NAK THEN reply(3)
                     ELSE reply(5)
                     END
                  ELSE reply(8)
                  END
               ELSE reply(9)
               END
            END
         ELSE reply(1)
         END
      END
   END SendMail;

   PROCEDURE DeleteMail*;
      VAR k: INTEGER; ch: CHAR;
         F: TextFrames.Frame;
         S: Texts.Scanner;
         buf: ARRAY 32 OF CHAR;
   BEGIN F := Oberon.Par.frame(TextFrames.Frame);
      Texts.OpenScanner(S, F.text, 0); Texts.Scan(S); FindPartner(S.s, k);
      IF k = 0 THEN
         F := F.next(TextFrames.Frame);
         IF F.sel > 0 THEN
            Texts.OpenScanner(S, F.text, F.selbeg.pos); Texts.Scan(S);
            IF S.class = Texts.Int THEN
               k := 0; AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
               AppendW(S.i, buf, 2, k); Send(DML, k, buf); ReceiveHead(T1);
               IF head1.typ = ACK THEN
                  REPEAT Texts.Read(S, ch) UNTIL ch < " ";
                  Texts.Delete(F.text, F.selbeg.pos, Texts.Pos(S))
               ELSIF head1.typ = NAK THEN reply(3)
               ELSIF head1.typ = NPR THEN reply(2)
               ELSE reply(5)
               END
            END
         END
      ELSE reply(1)
      END
   END DeleteMail;

   PROCEDURE SendMsg*;
      VAR i: INTEGER; ch: CHAR;
         S: Texts.Scanner;
         msg: ARRAY 64 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, i);
         IF i = 0 THEN
            Texts.Read(S, ch);
            WHILE (ch >= " ") & (i < 64) DO
               msg[i] := ch; INC(i); Texts.Read(S, ch)
            END ;
            Send(MSG, i, msg); ReceiveHead(T0);
            IF head1.typ # ACK THEN reply(3) END
         ELSE reply(1)
         END
      END
   END SendMsg;

   PROCEDURE GetTime*;
      VAR t, d: LONGINT; res: INTEGER;
         S: Texts.Scanner;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, res);
         IF res = 0 THEN
            Send(TRQ, 0, dmy); ReceiveHead(T1);
            IF head1.typ = TIM THEN
               PickQ(t); PickQ(d); Oberon.SetClock(t, d); reply(6)
            END
         ELSE reply(1)
         END
      END
   END GetTime;

   PROCEDURE SetPassword*;
      VAR k: INTEGER; oldpw: LONGINT;
         S: Texts.Scanner;
         buf: ARRAY 64 OF CHAR;
   BEGIN GetPar1(S);
      IF S.class = Texts.Name THEN
         FindPartner(S.s, k);
         IF k = 0 THEN Texts.Scan(S);
            IF S.class = Texts.String THEN
               AppendS(Oberon.User, buf, k); AppendW(Oberon.Password, buf, 4, k);
               Send(NPW, k, buf); ReceiveHead(T1);
               IF head1.typ = ACK THEN
                  k := 0; Oberon.SetUser(Oberon.User, S.s); AppendW(Oberon.Password, buf, 4, k);
                  Send(0, 4, buf); ReceiveHead(T0);
                  IF head1.typ = ACK THEN reply(7) ELSE reply(3) END
               ELSIF head1.typ = NPR THEN reply(2)
               ELSE reply(3)
               END
            END
         ELSE reply(1)
         END
      END
   END SetPassword;

   PROCEDURE StartServer*;
   BEGIN protected := TRUE; SCC.Start(TRUE);
      Oberon.Remove(Server); Oberon.Install(Server);
      Texts.WriteString(W, "  Server started");
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END StartServer;

   PROCEDURE Unprotect*;
   BEGIN protected := FALSE
   END Unprotect;

   PROCEDURE WProtect*;
   BEGIN protected := TRUE
   END WProtect;

   PROCEDURE Reset*;
   BEGIN SCC.Start(TRUE)
   END Reset;

   PROCEDURE StopServer*;
   BEGIN Oberon.Remove(Server); Texts.WriteString(W, "  Server stopped");
      Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
   END StopServer;

BEGIN Texts.OpenWriter(W); NEW(Server); Server.handle := Serve
END Net.
