MODULE TextFrames0;   (*HM 17-Dec-1991*)
IMPORT OS, Viewers0, Texts0;

CONST
   EOL = 0DX; DEL = 7FX;
   scrollW = 12;  (*width of scroll bar*)

TYPE
   Line = POINTER TO LineDesc;
   LineDesc = RECORD
      len, asc, dsc, wid: INTEGER;  (*length, ascender, descender, width*)
      eol: BOOLEAN;  (*TRUE if line is terminated with EOL*)
      next: Line
   END;
   Position* = RECORD  (*position of a character c on the screen*)
      x-, y-, dx-: INTEGER;  (*(x,y) = left point on base line; dx = width of c*)
      org-, pos-: LONGINT; (*origin of line containing c; text position of c*)
      L: Line  (*line containing c*)
   END;
   Frame* = POINTER TO FrameDesc;
   FrameDesc* = RECORD (Viewers0.FrameDesc)
      text*: Texts0.Text;
      org-: LONGINT;  (*index of first character in the frame*)
      caret-: Position; (*caret visible of caret.pos >= 0*)
      selBeg-, selEnd-: Position; (*selection; visible if selBeg.pos >= 0*)
      selTime: LONGINT;  (*time stamp of selection*)
      lsp, margin: INTEGER;  (*space between lines; space between frame border and text*)
      lines: Line  (*list of lines in frame*)
   END;
   SelectionMsg = RECORD (OS.Message) f: Frame END;

VAR
   cmdFrame-: Frame;  (*frame from which most recent command was invoked*)
   cmdPos-: LONGINT;  (*text position after most recent command*)


(*auxiliary procedures*)

PROCEDURE GetMetric (at: Texts0.Attribute; ch: CHAR; VAR dx, x, y, asc, dsc: INTEGER; VAR pat: OS.Pattern);
   VAR w, h: INTEGER;
BEGIN
   IF at.elem = NIL THEN OS.GetCharMetric(at.fnt, ch, dx, x, y, w, h, pat);
      asc := at.fnt.maxY; dsc := -at.fnt.minY
   ELSE dx := at.elem.w; x := 0; y := 0; dsc := at.elem.dsc; asc := at.elem.h - dsc
   END
END GetMetric;

PROCEDURE MeasureLine (t: Texts0.Text; VAR L: Line);
   VAR ch: CHAR; dx, x, y, asc, dsc: INTEGER; pat: OS.Pattern;
BEGIN L.len := 0; L.asc := 0; L.dsc := 0; L.wid := 0; ch := " ";
   WHILE (ch # EOL) & (t.pos < t.len) DO t.Read(ch); INC(L.len);
      GetMetric(t.attr, ch, dx, x, y, asc, dsc, pat);
      INC(L.wid, dx);
      IF asc > L.asc THEN L.asc := asc END;
      IF dsc > L.dsc THEN L.dsc := dsc END
   END;
   L.eol := ch = EOL
END MeasureLine;

PROCEDURE DrawLine (t: Texts0.Text; len, left, right, base: INTEGER);
   VAR ch: CHAR; dx, x, y, w, h: INTEGER; pat: OS.Pattern;
BEGIN
   WHILE len > 0 DO t.Read(ch); DEC(len);
      IF t.attr.elem = NIL THEN OS.GetCharMetric(t.attr.fnt, ch, dx, x, y, w, h, pat);
         IF left + dx < right THEN OS.DrawPattern(pat, left + x, base + y) END
      ELSE dx := t.attr.elem.w;
         IF left + dx < right THEN t.attr.elem.Draw(left, base) END
      END;
      INC(left, dx)
   END
END DrawLine;

(*methods of class Frame*)

PROCEDURE (f: Frame) FlipCaret;
BEGIN OS.DrawPattern(OS.Caret, f.caret.x, f.caret.y - 10)
END FlipCaret;

PROCEDURE (f: Frame) FlipSelection (a, b: Position);
   VAR x, y: INTEGER; L: Line;
BEGIN L := a.L; x := a.x; y := a.y - L.dsc;
   WHILE L # b.L DO OS.InvertBlock(x, y, f.x + f.w - x, L.asc + L.dsc);
      L := L.next; x := f.x + scrollW + f.margin; y := y - f.lsp - L.asc - L.dsc
   END;
   OS.InvertBlock(x, y, b.x - x, L.asc + L.dsc)
END FlipSelection;

PROCEDURE (f: Frame) RedrawFrom (top: INTEGER);
   VAR t: Texts0.Text; L, L0: Line; y: INTEGER; org: LONGINT;
BEGIN
   (*find first line to be redrawn*)
   y := f.y + f.h - f.margin; org := f.org; L0 := f.lines; L := L0.next;
   WHILE (L # f.lines) & (y - L.asc - L.dsc >= top) DO DEC(y, L.asc + L.dsc + f.lsp); org := org + L.len; L0 := L; L := L.next END;
   IF y > top THEN top := y END;
   OS.FadeCursor; OS.EraseBlock(f.x, f.y, f.w, top - f.y);
   (*draw scroll bar*)
   IF f.margin > 0 THEN OS.InvertBlock(f.x + scrollW, f.y, 1, top - f.y) END;
   (*redraw lines and build new line descriptors; L0 is last valid line descriptor*)
   t := f.text;
   LOOP NEW(L);
      t.SetPos(org); MeasureLine(t, L); IF (L.len = 0) OR (y - L.asc - L.dsc < f.y + f.margin) THEN EXIT END;
      t.SetPos(org); DrawLine(t, L.len, f.x + scrollW + f.margin, f.x + f.w - f.margin, y - L.asc); org := org + L.len;
      DEC(y, L.asc + L.dsc + f.lsp); L0.next := L; L0 := L; IF t.pos >= t.len THEN EXIT END
   END;
   L0.next := f.lines
END RedrawFrom;

PROCEDURE (f: Frame) GetPointPos (x0, y0: INTEGER; VAR p: Position);
   VAR t: Texts0.Text; ch: CHAR; L: Line; dx, x, y, asc, dsc: INTEGER; pat: OS.Pattern;
BEGIN
   (*find line containing y0*)
   L := f.lines.next; p.y := f.y + f.h - f.margin; p.org := f.org;
   WHILE (L # f.lines) & (y0 < p.y - L.asc - L.dsc - f.lsp) & L.eol DO
      DEC(p.y, L.asc + L.dsc + f.lsp); p.org := p.org + L.len; L := L.next
   END;
   DEC(p.y, L.asc);
   (*find character containing x0*)
   p.x := f.x + scrollW + f.margin; p.L := L; p.pos := p.org; t := f.text; t.SetPos(p.pos);
   LOOP IF t.pos >= t.len THEN p.dx := 0; EXIT END;
      t.Read(ch); GetMetric(t.attr, ch, dx, x, y, asc, dsc, pat);
      IF (ch = EOL) OR (p.x + dx > x0) THEN p.dx := dx; EXIT ELSE INC(p.pos); INC(p.x, dx) END;
   END
END GetPointPos;

PROCEDURE (f: Frame) GetCharPos (pos: LONGINT; VAR p: Position);
   VAR t: Texts0.Text; ch: CHAR; L: Line; dx, x, y, asc, dsc: INTEGER; pat: OS.Pattern; i: LONGINT;
BEGIN
   (*find line containing pos*)
   L := f.lines.next; p.y := f.y + f.h - f.margin; p.org := f.org; p.pos := pos;
   WHILE (L # f.lines) & (pos >= p.org + L.len) & L.eol DO p.org := p.org + L.len; DEC(p.y, L.asc + L.dsc + f.lsp); L := L.next END;
   DEC(p.y, L.asc); p.L := L;
   (*find character at pos*)
   p.x := f.x + scrollW + f.margin; t := f.text; t.SetPos(p.org);
   FOR i := 1 TO p.pos - p.org DO
      t.Read(ch); GetMetric(t.attr, ch, dx, x, y, asc, dsc, pat);
      INC(p.x, dx)
   END;
   IF t.pos >= t.len THEN p.dx := 0 ELSE t.Read(ch); GetMetric(t.attr, ch, p.dx, x, y, asc, dsc, pat) END
END GetCharPos;

PROCEDURE (f: Frame) CallCommand;
   VAR x, y, i: INTEGER; buttons: SET; p: Position; t: Texts0.Text; ch: CHAR; cmd: ARRAY 64 OF CHAR;
BEGIN REPEAT OS.GetMouse(buttons, x, y) UNTIL buttons = {};
   f.GetPointPos(x, y, p); t := f.text; t.SetPos(p.org); t.Read(ch);
   REPEAT
      WHILE (t.pos < t.len) & (ch # EOL) & ((CAP(ch) < "A") OR (CAP(ch) > "Z")) DO t.Read(ch) END;
      i := 0;
      WHILE (CAP(ch) >= "A") & (CAP(ch) <= "Z") OR (ch >= "0") & (ch <= "9") OR (ch = ".") DO
         cmd[i] := ch; INC(i); t.Read(ch)
      END;
      cmd[i] := 0X;
   UNTIL (t.pos >= t.len) OR (ch = EOL) OR (t.pos > p.pos);
   cmdFrame := f; cmdPos := t.pos; OS.Call(cmd)
END CallCommand;

PROCEDURE (f: Frame) RemoveCaret*;
BEGIN
   IF f.caret.pos >= 0 THEN f.FlipCaret; f.caret.pos := -1 END
END RemoveCaret;

PROCEDURE (f: Frame) SetCaret* (pos: LONGINT);
   VAR p: Position;
BEGIN
   IF pos < 0 THEN pos := 0 ELSIF pos > f.text.len THEN pos := f.text.len END;
   f.SetFocus; f.GetCharPos(pos, p);
   IF p.x < f.x + f.w - f.margin THEN f.caret := p; f.FlipCaret END
END SetCaret;

PROCEDURE (f: Frame) RemoveSelection*;
BEGIN IF f.selBeg.pos >= 0 THEN f.FlipSelection(f.selBeg, f.selEnd); f.selBeg.pos := -1 END
END RemoveSelection;

PROCEDURE (f: Frame) SetSelection* (from, to: LONGINT);
BEGIN f.RemoveSelection;
   f.GetCharPos(from, f.selBeg); f.GetCharPos(to, f.selEnd); f.FlipSelection(f.selBeg, f.selEnd); f.selTime := OS.Time()
END SetSelection;

PROCEDURE (f: Frame) Defocus*;
BEGIN f.RemoveCaret; f.Defocus^
END Defocus;

PROCEDURE (f: Frame) Neutralize*;
BEGIN f.RemoveCaret; f.RemoveSelection
END Neutralize;

PROCEDURE (f: Frame) Draw*;
BEGIN f.RedrawFrom(f.y + f.h)
END Draw;

PROCEDURE (f: Frame) Modify* (dy: INTEGER);
   VAR y: INTEGER;
BEGIN y := f.y; f.Modify^ (dy);
   IF y > f.y THEN f.RedrawFrom(y) ELSE f.RedrawFrom(f.y) END
END Modify;

PROCEDURE (f: Frame) HandleMouse* (x, y: INTEGER; buttons: SET);
   VAR p: Position; b: SET; t: Texts0.Text; ch: CHAR; f1: Frame;
BEGIN f.HandleMouse^ (x, y, buttons);
   t := f.text;
   IF (x < f.x + scrollW) & (buttons # {}) THEN (*handle click in scroll bar*)
      REPEAT OS.GetMouse(b, x, y); buttons := buttons + b UNTIL b = {};
      f.Neutralize;
      IF OS.left IN buttons THEN f.GetPointPos(x, y, p); f.org := p.org
      ELSIF OS.right IN buttons THEN f.org := 0
      ELSIF OS.middle IN buttons THEN t.SetPos((f.y + f.h - y) * f.text.len DIV f.h);
         REPEAT t.Read(ch) UNTIL (ch = EOL) OR (t.pos >= t.len);
         f.org := t.pos
      END;
      f.RedrawFrom(f.y + f.h)
   ELSE (*handle click in text area*)
      f.GetPointPos(x, y, p);
      IF OS.left IN buttons THEN
         IF p.pos # f.caret.pos THEN f.SetCaret(p.pos) END
      ELSIF OS.middle IN buttons THEN t.SetPos(p.pos); t.Read(ch);
         IF t.attr.elem = NIL THEN f.CallCommand ELSE t.attr.elem.HandleMouse(f, x, y) END
      ELSIF OS.right IN buttons THEN f.RemoveSelection;
         f.selBeg := p; f.selEnd := p; f.selTime := OS.Time();
         LOOP OS.GetMouse(b, x, y); buttons := buttons + b; IF b = {} THEN EXIT END;
            OS.DrawCursor(x, y); f.GetPointPos(x, y, p);
            IF p.pos < f.selBeg.pos THEN p := f.selBeg END; (*dont expand selection to the left*)
            IF p.pos < t.len THEN INC(p.pos); INC(p.x, p.dx) END;
            IF p.pos # f.selEnd.pos THEN
               IF p.pos > f.selEnd.pos THEN f.FlipSelection(f.selEnd, p) ELSE f.FlipSelection(p, f.selEnd) END;
               f.selEnd := p
            END
         END;
         (*handle interclick*)
         IF OS.left IN buttons THEN t.Delete(f.selBeg.pos, f.selEnd.pos)
         ELSIF (OS.middle IN buttons) & (Viewers0.focus # NIL) & (Viewers0.focus IS Frame) THEN
            f1 := Viewers0.focus(Frame);
            IF f1.caret.pos >= 0 THEN f1.text.Insert(f1.caret.pos, t, f.selBeg.pos, f.selEnd.pos) END
         END
      END
   END
END HandleMouse;

PROCEDURE (f: Frame) HandleKey* (ch: CHAR);
   VAR pos: LONGINT;
BEGIN pos := f.caret.pos;
   IF pos >= 0 THEN
      IF ch = DEL THEN
         IF pos > 0 THEN f.text.Delete(pos - 1, pos); f.SetCaret(pos - 1) END
      ELSE f.text.SetPos(pos); f.text.Write(ch); f.SetCaret(pos + 1)
      END
   END
END HandleKey;

PROCEDURE (f: Frame) Handle* (VAR m: OS.Message);
   VAR t: Texts0.Text; ch: CHAR; VAR dx, x, y, asc, dsc: INTEGER; pat: OS.Pattern; p: Position;
BEGIN
   t := f.text;
   WITH
      m: Texts0.NotifyInsMsg DO
         IF m.t = t THEN
            IF m.beg < f.org THEN f.org := f.org + (m.end - m.beg)
            ELSE
               f.Neutralize; OS.FadeCursor;
               f.GetCharPos(m.beg, p);
               t.SetPos(m.beg); t.Read(ch); GetMetric(t.attr, ch, dx, x, y, asc, dsc, pat);
               IF (m.end = m.beg+1) & (ch # EOL) & (p.L # f.lines) & (asc+dsc <= p.L.asc+p.L.dsc) THEN
                  IF p.x + dx <= f.x + f.w - f.margin THEN
                     OS.CopyBlock(p.x, p.y-p.L.dsc, f.x+f.w-f.margin-dx-p.x, p.L.asc+p.L.dsc,
                        p.x+dx, p.y-p.L.dsc);
                     OS.EraseBlock(p.x, p.y-p.L.dsc, dx, p.L.asc + p.L.dsc);
                     IF t.attr.elem = NIL THEN OS.DrawPattern(pat, p.x + x, p.y + y)
                     ELSE t.attr.elem.Draw(p.x, p.y)
                     END
                  ELSE OS.EraseBlock(p.x, p.y-p.L.dsc, f.x+f.w-p.x, p.L.asc+p.L.dsc)
                  END;
                  INC(p.L.len); INC(p.L.wid, dx)
               ELSE f.RedrawFrom(p.y + p.L.asc)
               END
            END
         END
   | m: Texts0.NotifyDelMsg DO
         IF m.t = t THEN
            IF m.end <= f.org THEN f.org := f.org - (m.end - m.beg)
            ELSE
               f.Neutralize;
               IF m.beg < f.org THEN f.org := m.beg; f.RedrawFrom(f.y + f.h)
               ELSE f.GetCharPos(m.beg, p); f.RedrawFrom(p.y + p.L.asc)
               END
            END
         END
   | m: Texts0.NotifyReplMsg DO
         IF (m.t = t) & (m.end > f.org) THEN
            f.Neutralize;
            IF m.beg < f.org THEN m.beg := f.org END;
            f.GetCharPos(m.beg, p); f.RedrawFrom(p.y + p.L.asc)
         END
   | m: SelectionMsg DO
         IF (f.selBeg.pos >= 0) & ((m.f = NIL) OR (m.f.selTime < f.selTime)) THEN m.f := f END
   ELSE
   END
END Handle;

PROCEDURE New* (t: Texts0.Text): Frame;
   VAR f: Frame; fnt: OS.Font;
BEGIN NEW(f); f.text := t;
   f.org := 0; f.caret.pos := -1; f.selBeg.pos := -1; f.lsp := 2; f.margin := 5;
   NEW(f.lines); f.lines.next := f.lines; fnt := OS.DefaultFont(); f.lines.asc := fnt.maxY; f.lines.dsc := -fnt.minY; f.lines.len := 0;
   RETURN f
END New;

PROCEDURE NewMenu* (name, menu: ARRAY OF CHAR): Frame;
   VAR t: Texts0.Text; f: Frame; i: INTEGER;
BEGIN NEW(t); t.Clear;
   i := 0; WHILE name[i] # 0X DO t.Write(name[i]); INC(i) END;
   t.Write(" "); t.Write("|"); t.Write(" ");
   i := 0; WHILE menu[i] # 0X DO t.Write(menu[i]); INC(i) END;
   f := New(t); f.margin := 0; RETURN f
END NewMenu;

PROCEDURE (f: Frame) Copy* (): Viewers0.Frame;
   VAR f1: Frame;
BEGIN f1 := New(f.text); f1.margin := f.margin; RETURN f1
END Copy;

PROCEDURE GetSelection* (VAR f: Frame);
   VAR m: SelectionMsg;
BEGIN m.f := NIL; Viewers0.Broadcast(m); f := m.f
END GetSelection;

END TextFrames0.
