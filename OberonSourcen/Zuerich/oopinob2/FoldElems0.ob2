MODULE FoldElems0;   (*HM Mar-25-92*)
IMPORT OS, Texts0, TextFrames0, Viewers0;

CONST
   colLeft* = 0; colRight* = 1; expRight* = 2; expLeft* = 3;

TYPE
   Element* = POINTER TO ElemDesc;
   ElemDesc* = RECORD (Texts0.ElemDesc)
      mode-: INTEGER;
      hidden: Texts0.Text
   END;

VAR
   pat: ARRAY 4 OF OS.Pattern;
   eW, eH: INTEGER;

PROCEDURE Twin (e: Texts0.Element; t: Texts0.Text; VAR pos: LONGINT): Element;
   VAR level: INTEGER;
BEGIN
   t.SetPos(pos + 1); level := 1;
   LOOP t.ReadNextElem(e); pos := t.pos - 1;
      IF e = NIL THEN RETURN NIL
      ELSIF e IS Element THEN
         IF e(Element).mode IN {expLeft, colLeft} THEN INC(level) ELSE DEC(level) END;
         IF level = 0 THEN RETURN e(Element) END
      END
   END;
   RETURN NIL; 
END Twin;

PROCEDURE (e: Element) Copy* (): Texts0.Element;
   VAR x: Element;
BEGIN NEW(x); x.w := e.w; x.h := e.h; x.dsc := e.dsc; x.mode := e.mode;
   IF e.hidden # NIL THEN NEW(x.hidden); x.hidden.Clear; x.hidden.Insert(0, e.hidden, 0, e.hidden.len) END;
   RETURN x
END Copy;

PROCEDURE (e: Element) Draw* (x, y: INTEGER);
BEGIN OS.DrawPattern(pat[e.mode], x + 2, y - e.dsc)
END Draw;

PROCEDURE (e: Element) HandleMouse* (f: OS.Object; x, y: INTEGER);
   VAR buttons: SET; e1: Element; t: Texts0.Text; pos, pos1, len1: LONGINT; m: Texts0.NotifyReplMsg;
BEGIN REPEAT OS.GetMouse(buttons, x, y) UNTIL buttons = {};
   WITH f: TextFrames0.Frame DO
      IF e.mode IN {expLeft, colLeft} THEN
         pos := f.text.ElemPos(e); pos1 := pos; e1 := Twin(e, f.text, pos1); len1 := e.hidden.len;
         NEW(t); t.Clear; t.Insert(0, f.text, pos + 1, pos1); f.text.Delete(pos + 1, pos1);
         f.text.Insert(pos + 1, e.hidden, 0, e.hidden.len); e.hidden := t;
         e.mode := 3 - e.mode; e1.mode := 3 - e1.mode;
         m.t := f.text; m.beg := pos; m.end := pos + len1 + 1; Viewers0.Broadcast(m)
      END
   END
END HandleMouse;

PROCEDURE (e: Element) Load* (VAR r: OS.Rider);
   VAR x: OS.Object;
BEGIN e.Load^ (r); r.ReadInt(e.mode); r.ReadObj(x);
   IF x # NIL THEN e.hidden := x(Texts0.Text) END
END Load;

PROCEDURE (e: Element) Store* (VAR r: OS.Rider);
BEGIN e.Store^ (r); r.WriteInt(e.mode); r.WriteObj(e.hidden)
END Store;

PROCEDURE Insert*;
   VAR f: TextFrames0.Frame; e: Element; beg, end: LONGINT;
BEGIN TextFrames0.GetSelection(f);
   IF f # NIL THEN beg := f.selBeg.pos; end := f.selEnd.pos;
      NEW(e); e.mode := expRight; e.w := eW; e.h := eH; e.dsc := 0;
      f.text.SetPos(end); f.text.WriteElem(e);
      NEW(e); e.mode := expLeft; e.w := eW; e.h := eH; e.dsc := 0; NEW(e.hidden); e.hidden.Clear;
      f.text.SetPos(beg); f.text.WriteElem(e)
   END
END Insert;

PROCEDURE Init;
   VAR fnt: OS.Font; dx, x, y, w, h: INTEGER;
BEGIN
   fnt := OS.FontWithName("Syntax10.Scn.Fnt");
   OS.GetCharMetric(fnt, 1BX, dx, x, y, w, h, pat[0]);   (*collapsed open*)
   OS.GetCharMetric(fnt, 1FX, dx, x, y, w, h, pat[1]);   (*collapsed close*)
   OS.GetCharMetric(fnt, 1EX, dx, x, y, w, h, pat[2]);   (*expanded close*)
   OS.GetCharMetric(fnt, 1AX, dx, x, y, w, h, pat[3]);   (*expanded open*)
   eW := dx; eH := h;
END Init;

BEGIN Init
END FoldElems0.
