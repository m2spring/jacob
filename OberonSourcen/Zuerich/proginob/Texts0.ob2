MODULE Texts0;   (* HM Mar-25-92*)
IMPORT OS, AsciiTexts, Viewers0, Texts;

CONST ELEM = 1CX;

TYPE
   Scanner* = Texts.Scanner;
   Writer* = Texts.Writer;

   Element* = POINTER TO ElemDesc;
   Attribute* = POINTER TO AttrDesc;
   AttrDesc* = RECORD
      fnt-: OS.Font;
      elem-: Element;
      len: LONGINT;
      next: Attribute
   END;
   ElemDesc* = RECORD (OS.ObjectDesc)
      w*, h*, dsc*: INTEGER
   END;
   Text* = POINTER TO TextDesc;
   TextDesc* = RECORD (AsciiTexts.TextDesc)
      attr-: Attribute;  (*attributes of previously read character*)
      firstAttr: Attribute;  (*to attribute list*)
      attrRest: LONGINT  (*unread bytes in current attribute block*)
   END;
   NotifyInsMsg* = AsciiTexts.NotifyInsMsg;
   NotifyDelMsg* = AsciiTexts.NotifyDelMsg;
   NotifyReplMsg* = RECORD (OS.Message) t*: Text; beg*, end*: LONGINT END;

(*methods of class Element*)

PROCEDURE (e: Element) Draw* (x, y: INTEGER); END Draw;
PROCEDURE (e: Element) HandleMouse* (f: OS.Object; x, y: INTEGER); END HandleMouse;
PROCEDURE (e: Element) Copy* (): Element; END Copy;

PROCEDURE (e: Element) Load* (VAR r: OS.Rider);
BEGIN r.ReadInt(e.w); r.ReadInt(e.h); r.ReadInt(e.dsc)
END Load;

PROCEDURE (e: Element) Store* (VAR r: OS.Rider);
BEGIN r.WriteInt(e.w); r.WriteInt(e.h); r.WriteInt(e.dsc)
END Store;

(*methods of class Text*)

PROCEDURE (t: Text) Split (pos: LONGINT; VAR prev: Attribute);
   VAR a, b: Attribute;
BEGIN a := t.firstAttr;
   WHILE (a # NIL) & (pos >= a.len) DO DEC(pos, a.len); prev := a; a := a.next END;
   IF (a # NIL) & (pos > 0) THEN
      NEW(b); b.elem := a.elem; b.fnt := a.fnt; b.len := a.len - pos; a.len := pos;
      b.next := a.next; a.next := b; prev := a
   END
END Split;

PROCEDURE (t: Text) Merge (a: Attribute);
   VAR b: Attribute;
BEGIN b := a.next;
   IF (b # NIL) & (a.fnt = b.fnt) & (a.len > 0) & (a.elem = NIL) & (b.elem = NIL) THEN
      INC(a.len, b.len); a.next := b.next
   END
END Merge;

PROCEDURE (t: Text) Insert* (at: LONGINT; t1: AsciiTexts.Text; beg, end: LONGINT);
   VAR a, b, c, d, i, j, k: Attribute; t0: Text;
BEGIN
   IF t = t1 THEN NEW(t0); t0.Clear; t0.Insert(0, t1, beg, end); t.Insert(at, t0, 0, t0.len)
   ELSE
      WITH t1: Text DO t1.Split(beg, a); t1.Split(end, b); t.Split(at, c); d := c.next;
         i := a; j := c;
         WHILE i # b DO i := i.next; NEW(k); k^ := i^;
            IF i.elem # NIL THEN k.elem := i.elem.Copy() END;
            j.next := k; j := k
         END;
         j.next := d; t1.Merge(b); t1.Merge(a); t.Merge(j); t.Merge(c);
         t.Insert^ (at, t1, beg, end)
      END
   END
END Insert;

PROCEDURE (t: Text) Delete* (beg, end: LONGINT);
   VAR a, b: Attribute;
BEGIN t.Split(beg, a); t.Split(end, b); a.next := b.next; t.Merge(a);
   t.Delete^ (beg, end)
END Delete;

PROCEDURE (t: Text) SetPos* (pos: LONGINT);
   VAR prev, a: Attribute;
BEGIN t.SetPos^(pos);
   a := t.firstAttr;
   WHILE (a # NIL) & (pos >= a.len) DO DEC(pos, a.len); prev := a; a := a.next END;
   IF (a = NIL) OR (pos = 0) THEN t.attr := prev; t.attrRest := 0 ELSE t.attr := a; t.attrRest := a.len-pos END
END SetPos;

PROCEDURE (t: Text) Read* (VAR ch: CHAR);
BEGIN t.Read^(ch);
   IF (t.attrRest = 0) & (t.attr.next # NIL) THEN t.attr := t.attr.next; t.attrRest := t.attr.len END;
   DEC(t.attrRest)
END Read;

PROCEDURE (t: Text) Write* (ch: CHAR);
   VAR a, prev: Attribute; at: LONGINT;
BEGIN a := t.firstAttr; at := t.pos;
   WHILE (a # NIL) & (at >= a.len) DO DEC(at, a.len); prev := a; a := a.next END;
   IF (a = NIL) OR (at = 0) THEN (*insert at end of attribute stretch*)
      IF (prev = t.firstAttr) OR (prev.elem # NIL) THEN
         NEW(a); a.elem := NIL; a.fnt := prev.fnt; a.len := 1; a.next := prev.next; prev.next := a; t.Merge(a)
      ELSE INC(prev.len)
      END
   ELSE INC(a.len)
   END;
   t.Write^ (ch)
END Write;

PROCEDURE (t: Text) ReadNextElem* (VAR e: Element);
   VAR pos: LONGINT; a: Attribute;
BEGIN
   pos := t.pos + t.attrRest; a := t.attr.next;
   WHILE (a # NIL) & (a.elem = NIL) DO pos := pos + a.len; a := a.next END;
   IF a # NIL THEN e := a.elem; t.SetPos(pos+1) ELSE e := NIL; t.SetPos(t.len) END
END ReadNextElem;

PROCEDURE (t: Text) WriteElem* (e: Element);
   VAR x, y: Attribute; m: NotifyReplMsg;
BEGIN t.Write(ELEM); t.Split(t.pos - 1, x); t.Split(t.pos, y); y.elem := e;
   m.t := t; m.beg := t.pos-1; m.end := t.pos; Viewers0.Broadcast(m)
END WriteElem;

PROCEDURE (t: Text) ElemPos* (e: Element): LONGINT;
   VAR pos: LONGINT; a: Attribute;
BEGIN
   a := t.firstAttr; pos := 0;
   WHILE (a # NIL) & (a.elem # e) DO pos := pos + a.len; a := a.next END;
   RETURN pos
END ElemPos;

PROCEDURE (t: Text) ChangeFont* (beg, end: LONGINT; fnt: OS.Font);
   VAR a, b: Attribute; m: NotifyReplMsg;

   PROCEDURE Change(a: Attribute);
   BEGIN a.fnt := fnt;
      IF a # b THEN Change(a.next) END;
      t.Merge(a)
   END Change;

BEGIN
   IF end > beg THEN
      t.Split(beg, a); t.Split(end, b); Change(a.next); t.Merge(a);
      m.t := t; m.beg := beg; m.end := end; Viewers0.Broadcast(m)
   END
END ChangeFont;

PROCEDURE (t: Text) Clear*;
BEGIN
   t.Clear^;
   NEW(t.firstAttr); t.firstAttr.elem := NIL; t.firstAttr.next := NIL;
   t.firstAttr.fnt := OS.DefaultFont(); t.firstAttr.len := 0; t.SetPos(0)
END Clear;

PROCEDURE (t: Text) Store* (VAR r: OS.Rider);
   VAR a: Attribute;
BEGIN t.Store^(r); a := t.firstAttr.next;
   WHILE a # NIL DO
      r.WriteString(a.fnt.name); r.WriteObj(a.elem); r.WriteLInt(a.len);
      a := a.next
   END;
   r.Write(0X) (*empty font name terminates attribute list*)
END Store;

PROCEDURE (t: Text) Load* (VAR r: OS.Rider);
   VAR prev, a: Attribute; name: ARRAY 32 OF CHAR; x: OS.Object;
BEGIN t.Load^(r);
   prev := t.firstAttr;
   LOOP
      r.ReadString(name); IF name = "" THEN EXIT END;
      NEW(a); a.fnt := OS.FontWithName(name); r.ReadObj(x); r.ReadLInt(a.len);
      IF x = NIL THEN a.elem := NIL ELSE a.elem := x(Element) END;
      prev.next := a; prev := a
   END;
   prev.next := NIL
END Load;

PROCEDURE Append* (T: Texts.Text; B: Texts.Buffer);
BEGIN
 Texts.Append(T,B);
END Append;

PROCEDURE WriteLn* (VAR W: Texts.Writer);
BEGIN
 Texts.WriteLn(W);
END WriteLn;

PROCEDURE WriteString* (VAR W: Texts.Writer; s: ARRAY OF CHAR);
BEGIN
 Texts.WriteString(W,s);
END WriteString;

END Texts0.
