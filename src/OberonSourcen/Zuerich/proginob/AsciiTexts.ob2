MODULE AsciiTexts; (*HM Mar-25-92*)
IMPORT OS, Viewers0;

CONST minBufLen = 32;

TYPE
   Buffer = POINTER TO ARRAY OF CHAR;
   Text* = POINTER TO TextDesc;
   TextDesc* = RECORD (OS.ObjectDesc)
      len-: LONGINT;
      pos-: LONGINT;  (*read/write position*)
      buf: Buffer;
      gap: LONGINT (*index of first byte in gap*)
   END;
   NotifyInsMsg* = RECORD (OS.Message) t*: Text; beg*, end*: LONGINT END;
   NotifyDelMsg* = RECORD (OS.Message) t*: Text; beg*, end*: LONGINT END;

PROCEDURE (t: Text) MoveGap (to: LONGINT);
   VAR n, gapLen: LONGINT;
BEGIN n := ABS(to - t.gap); gapLen := LEN(t.buf^) - t.len;
   IF to > t.gap THEN OS.Move(t.buf^, t.gap + gapLen, t.buf^, t.gap, n)
   ELSIF to < t.gap THEN OS.Move(t.buf^, t.gap - n, t.buf^, t.gap + gapLen - n, n)
   END;
   t.gap := to
END MoveGap;

PROCEDURE (t: Text) Grow (size: LONGINT);
   VAR bufLen: LONGINT; old: Buffer;
BEGIN bufLen := LEN(t.buf^);
   IF size > bufLen THEN t.MoveGap(t.len);
      WHILE bufLen < size DO bufLen := 2*bufLen END;
      old := t.buf; NEW(t.buf, bufLen); OS.Move(old^, 0, t.buf^, 0, t.len)
   END
END Grow;

PROCEDURE (t: Text) Shrink;
   VAR bufLen: LONGINT; old: Buffer;
BEGIN bufLen := LEN(t.buf^); t.MoveGap(t.len);
   WHILE (bufLen >= 2*t.len) & (bufLen > minBufLen) DO bufLen := bufLen DIV 2 END;
   old := t.buf; NEW(t.buf, bufLen); OS.Move(old^, 0, t.buf^, 0, t.len)
END Shrink;

PROCEDURE (t: Text) Clear*;
BEGIN NEW(t.buf, minBufLen); t.gap := 0; t.pos := 0; t.len := 0
END Clear;

PROCEDURE (t: Text) Insert* (at: LONGINT; t1: Text; beg, end: LONGINT);
   VAR len: LONGINT; m: NotifyInsMsg; t0: Text;
BEGIN
   IF t = t1 THEN NEW(t0); t0.Clear; t0.Insert(0, t1, beg, end); t.Insert(at, t0, 0, t0.len)
   ELSE len := end - beg;
      IF t.len + len > LEN(t.buf^) THEN t.Grow(t.len + len) END;
      t.MoveGap(at); t1.MoveGap(end);
      OS.Move(t1.buf^, beg, t.buf^, t.gap, len);
      INC(t.gap, len); INC(t.len, len);
      m.t := t; m.beg := at; m.end := at + len; Viewers0.Broadcast(m)
   END
END Insert;

PROCEDURE (t: Text) Delete* (beg, end: LONGINT);
   VAR m: NotifyDelMsg;
BEGIN t.MoveGap(end); t.gap := beg; DEC(t.len, end-beg);
   IF (t.len * 2 < LEN(t.buf^)) & (LEN(t.buf^) > minBufLen) THEN t.Shrink END;
   m.t := t; m.beg := beg; m.end := end; Viewers0.Broadcast(m)
END Delete;

PROCEDURE (t: Text) SetPos* (pos: LONGINT);
BEGIN t.pos := pos END SetPos;

PROCEDURE (t: Text) Read* (VAR ch: CHAR);
   VAR i: LONGINT;
BEGIN i := t.pos;
   IF t.pos >= t.gap THEN INC(i, LEN(t.buf^) - t.len) END;
   IF t.pos < t.len THEN ch := t.buf[i]; INC(t.pos) ELSE ch := 0X END
END Read;

PROCEDURE (t: Text) Write* (ch: CHAR);
   VAR m: NotifyInsMsg;
BEGIN
   IF t.len = LEN(t.buf^) THEN t.Grow(t.len + 1) END;
   IF t.pos # t.gap THEN t.MoveGap(t.pos) END;
   t.buf[t.gap] := ch; INC(t.gap); INC(t.pos); INC(t.len);
   m.t := t; m.beg := t.gap-1; m.end := t.gap; Viewers0.Broadcast(m)
END Write;

PROCEDURE (t: Text) Load* (VAR r: OS.Rider);
   VAR len: LONGINT;
BEGIN t.Clear; r.ReadLInt(len); t.Grow(len); r.ReadChars(t.buf^, len);
   t.gap := len; t.len := len
END Load;

PROCEDURE (t: Text) Store* (VAR r: OS.Rider);
BEGIN t.MoveGap(t.len); r.WriteLInt(t.len); r.WriteChars(t.buf^, t.len)
END Store;

END AsciiTexts.
