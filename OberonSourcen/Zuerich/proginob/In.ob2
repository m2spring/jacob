MODULE In;
(* Stream-oriented input from a text, page 88, 98, 308 *)
IMPORT Texts, Viewers:=Viewers0, ViewersOrg:=Viewers, Oberon, 
       TextFramesOrg:=TextFrames,
       TextFrames:=TextFrames0;

VAR
   T: Texts.Text;  S: Texts.Scanner;  W: Texts.Writer;
   beg: LONGINT;
   Done*: BOOLEAN;

PROCEDURE Put(txt: ARRAY OF CHAR);  (* write txt to the System.Log viewer *)
BEGIN
   Texts.WriteString(W, txt);  Texts.WriteLn(W);  Texts.Append(Oberon.Log, W.buf)
END Put;

PROCEDURE Open*;
VAR
   end, time: LONGINT;
   VO: ViewersOrg.Viewer;
   V: Viewers.Viewer;
BEGIN
   Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos);  Texts.Scan(S);
   IF (S.class = Texts.Char) & (S.c = "^") THEN
      (* start input stream at beginning of selection *)
      Oberon.GetSelection(T, beg, end, time);
      IF time >= 0 THEN  Texts.OpenScanner(S, T, beg);  Done := ~S.eot;
      ELSE  Put("No selection"); Done := FALSE
      END
   ELSIF (S.class = Texts.Char) & (S.c = "*") THEN
      (* start input stream at beginning of text in marked viewer *)
      VO := Oberon.MarkedViewer();
      IF ~Oberon.Pointer.on THEN Put("Pointer not visible");  Done := FALSE
      ELSIF (VO.dsc # NIL) & (VO.dsc.next IS TextFramesOrg.Frame) THEN
         T := VO.dsc.next(TextFramesOrg.Frame).text;  beg := 0;
         Texts.OpenScanner(S, T, beg);  Done := ~S.eot;
      ELSE  Put("Marked viewer not a text viewer");  Done := FALSE
      END
   ELSE
      (* start input stream after command name *)
      T := Oberon.Par.text;  beg := Oberon.Par.pos;
      Texts.OpenScanner(S, T, beg);  Done := ~S.eot;
   END
END Open;

PROCEDURE Char*(VAR ch: CHAR);
BEGIN
   IF Done THEN  ch := S.nextCh;  Done := ~S.eot;  Texts.Read(S, S.nextCh)  END
END Char;

PROCEDURE Int*(VAR i: INTEGER);
BEGIN
   IF Done THEN  Texts.Scan(S);  i := SHORT(S.i);  Done := (S.class = Texts.Int)  END
END Int;

PROCEDURE LongInt*(VAR i: LONGINT);
BEGIN
   IF Done THEN  Texts.Scan(S);  i := S.i;  Done := (S.class = Texts.Int)  END
END LongInt;

PROCEDURE Real*(VAR x: REAL);
BEGIN
   IF Done THEN  Texts.Scan(S);  x := S.x;  Done := (S.class = Texts.Real)  END
END Real;

PROCEDURE LongReal*(VAR y: LONGREAL);
BEGIN
   IF Done THEN  Texts.Scan(S);  y := S.y;  Done := (S.class = Texts.LongReal)  END
END LongReal;

PROCEDURE Name*(VAR nme: ARRAY OF CHAR);
BEGIN
   IF Done THEN  Texts.Scan(S);  COPY(S.s, nme);  Done := (S.class = Texts.Name)  END
END Name;

PROCEDURE String*(VAR str: ARRAY OF CHAR);
CONST CR = 0DX;  NUL = 0X;
VAR ch: CHAR;  j: LONGINT;
BEGIN
   IF Done THEN
      REPEAT  Char(ch)  UNTIL ((ch # " ") & (ch # CR)) OR ~Done;
      j := 0;
      WHILE Done & (ch # " ") & (ch # CR) DO
         IF j < LEN(str) - 1 THEN str[j] := ch;  INC(j)  END;
         Char(ch)
      END;
      str[j] := NUL; Done := j # 0
   END
END String;

BEGIN  Texts.OpenWriter(W);  Done := FALSE
END In.   (* Copyright M. Reiser, 1992 *)
